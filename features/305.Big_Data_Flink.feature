Feature: test tutorial 305.Big Data (Flink)

  This is the feature file of the FIWARE Step by Step tutorial for Big Data (Flink)
  url: https://fiware-tutorials.readthedocs.io/en/latest/big-data-flink.html
  git-clone: https://github.com/FIWARE/tutorials.Big-Data-Flink.git
  git-directory: /tmp/tutorials.Big-Data-Flink
  shell-commands: ./services create; ./services start
  clean-shell-commands: ./services stop


  Background:
    Given I set the tutorial 305

  @ongoing
  Scenario: Compiling a jar file for Flink
    Given  I download the Orion Flink Connector "orion.flink.connector-1.2.4.jar"
    When   I execute the maven install command
    And    I execute the maven package command
    Then   A new JAR file called "cosmos-examples-1.1.jar" is created within the "cosmos-examples/target" directory

  Scenario Outline: Generating context data
    Given  the fiware-service header is "openiot" and the fiware-servicepath header is "/"
    When   I send PATCH HTTP request with the following data
      | Url                      | Entity_ID   | Command |
      | http://localhost:1026/v2 | <entity_id> | <command> |
    Then  I receive a HTTP "204" response

    Examples:
        | command | entity_id |
        | unlock  | Door:001  |
        | on      | Lamp:001  |

  Scenario: Upload generated jar file
    Given  I have generated the "cosmos-examples-1.1.jar" in the target directory
    When   I submit this new jar file to the Flink instance
    Then   I receive the response with the following data
      | filename | status  | status_code |
      | ANY      | success | 200         |

  Scenario: Create Logger Flink job
    Given  I have a proper jar file id
    When   I try to create a new job with Entry Class "org.fiware.cosmos.tutorial.Logger"
    Then   I receive the 200 Ok response with the id of the new created job
