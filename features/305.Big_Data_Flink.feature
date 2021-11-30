Feature: test tutorial 305.Big Data (Flink)

  This is the feature file of the FIWARE Step by Step tutorial for Big Data (Flink)
  url: https://fiware-tutorials.readthedocs.io/en/latest/big-data-flink.html
  git-clone: https://github.com/FIWARE/tutorials.Big-Data-Flink.git
  git-directory: /tmp/tutorials.Big-Data-Flink
  shell-commands: ./services create; ./services start
  clean-shell-commands: ./services stop


  Background:
    Given I set the tutorial 305

  Scenario: Compiling a jar file for Flink
    Given  I download the Orion Flink Connector "orion.flink.connector-1.2.4.jar"
    When   I execute the maven install command
    And    I execute the maven package command
    Then   A new JAR file called "cosmos-examples-1.1.jar" will be created within the "cosmos-examples/target" directory

  @ongoing
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
