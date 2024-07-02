Feature: test tutorial 305.Big Data (Flink)

  This is the feature file of the FIWARE Step by Step tutorial for Big Data (Flink)
  url: https://fiware-tutorials.readthedocs.io/en/latest/big-data-flink.html
  git-clone: https://github.com/FIWARE/tutorials.Big-Data-Flink.git
  git-directory: /tmp/tutorials.Big-Data-Flink
  shell-commands: git checkout NGSI-v2 ; ./services create ; ./services start
  clean-shell-commands: ./services stop


  Background:
    Given I set the tutorial 305

  @ongoing
  Scenario: Compiling a jar file for Flink
    Given  I download the Orion Flink Connector "orion.flink.connector-1.2.4.jar"
    When   I execute the maven install command with the following data
      | file                            | artifactId            | version |
      | orion.flink.connector-1.2.4.jar | orion.flink.connector | 1.2.4   |
    And    I execute the maven package command
    Then   A new JAR file called "cosmos-examples-1.1.jar" is created within the "cosmos-examples/target" directory

  Scenario Outline: Generating context data
    Given  the fiware-service header is "openiot" and the fiware-servicepath header is "/"
    When   I send PATCH HTTP request with the following data
      | Url                      | Entity_ID   | Command |
      | http://localhost:1026/v2 | <entity_id> | <command> |
    Then  I receive a HTTP "204" status code response

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

  Scenario: Logger - Subscribing to context changes
    Given  The fiware-service header is "openiot" and the fiware-servicepath header is "/"
    When   I send a subscription to the Url "http://localhost:1026/v2/subscriptions" and payload "request305-01.json"
    Then   I receive a HTTP "201" status code response

  Scenario: Logger - Check that subscription is firing
    Given  The fiware-service header is "openiot" and the fiware-servicepath header is "/"
    And    I wait "120" seconds
    When   I send GET HTTP request to "http://localhost:1026/v2/subscriptions" with fiware-service and fiware-servicepath
    Then   I receive a HTTP "200" response code from Broker with the body "response305-02.json" and exclusions "response305-02.excludes"
    And    The timesSent is bigger than 0
    And    The lastNotification should be a recent timestamp
    And    The lastSuccess should match the lastNotification date
    And    The status is "active"

  Scenario: Logger - Checking the output
    Given  I wait "5" seconds
    When   I obtain the stderr log from the flink-taskmanager
    Then   I obtain the output from the console

  Scenario: Create Feedback Loop Flink job
    Given  I have a proper jar file id
    When   I try to create a new job with Entry Class "org.fiware.cosmos.tutorial.Feedback"
    Then   I receive the 200 Ok response with the id of the new created job

  Scenario: Feedback Loop - Subscribing to context changes
    Given  The fiware-service header is "openiot" and the fiware-servicepath header is "/"
    When   I send a subscription to the Url "http://localhost:1026/v2/subscriptions" and payload "request305-03.json"
    Then   I receive a HTTP "201" response with a subscriptionId

  Scenario: Feedback Loop - Check that subscription is firing
    Given  The fiware-service header is "openiot" and the fiware-servicepath header is "/"
    And    I wait "120" seconds
    When   I send GET HTTP request to "http://localhost:1026/v2/subscriptions" with fiware-service and fiware-servicepath
    Then   I receive a HTTP "200" response code from Broker
    And    The timesSent is bigger than 0
    And    The lastNotification should be a recent timestamp
    And    The lastSuccess should match the lastNotification date
    And    The status is "active"

  Scenario: Feedback Loop - Checking the output
    Given  I wait "5" seconds
    When   I obtain the stderr log from the flink-taskmanager
    Then   I obtain the output from the console
