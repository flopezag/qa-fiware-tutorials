Feature: test tutorial 302 - Big Data Analysis (Flink)

  url: https://ngsi-ld-tutorials.readthedocs.io/en/latest/big-data-flink.html

  git-clone: https://github.com/FIWARE/tutorials.Big-Data-Flink.git
  git-directory: /tmp/tutorials.Big-Data-Flink
  shell-commands: git checkout NGSI-LD ; ./services create  ; ./services start
  clean-shell-commands: ./services stop

Background:
    Given  I set the tutorial 302 LD - Big Data Flink

    # COMPILING A JAR FILE FOR Flink --
    Scenario: Compiling a Jar File For Flink
       Given I prepare the script create-flink-jar.sh to be run
       And   I set the environ variable WORKING_DIR to "cosmos-examples" under git
       And   I set the environ variable OUTPUT_DIR to "cosmos-examples/target" under git
       When  I run the script as in the tutorial page
       Then  I expect the scripts shows a result of 0

    Scenario Outline: Subscribing Logger to context changes
    When I prepare a POST HTTP request for "<description>" to "http://localhost:1026/ngsi-ld/v1/subscriptions/"
    And  I set header Content-Type to application/ld+json
    And  I set header NGSILD-Tenant to openiot
    And  I set the body request as described in <file>
    And  I perform the request
    Then  I receive a HTTP "201" response code
    Examples:
        | description                            | file            |
        | notify feedstock and tractor changes   | 01.request.json |

   # Request 2 -
   Scenario: Check the subscriptions for Flink Logger to ngsi-ld
   When  I send GET HTTP request to "http://localhost:1026/ngsi-ld/v1/subscriptions/"
   And   I set header NGSILD-Tenant to openiot
   Then  I receive a HTTP "200" response code

    # Populate things....
    # Somehow I need to add data to Sensors so they can push data to CB and via subscription to flink
    # This is not in tutorial, but it is a way to add data without Web dashboard
    Scenario Outline: Communicating with IoT Devices: Using Actuators
    When  I prepare a POST HTTP request to "http://localhost:7896/iot/d?k=<key_value>&i=<sensor>"
    And   I set header fiware-service to openiot
    And   I set header fiware-servicepath to /
    And   I set header Content-Type to text/plain
    And   I set simple sensor values as described in "<sensor_value>"
    And   I perform the request
    Then  I receive a HTTP "200" response code
    And   I wait "1" seconds
    Examples:
        | sensor_value                                                | key_value   | sensor     |
        | d\|SOWING\|gps\|13.387,52.56\|s\|8                          | 1067386313  | tractor001 |
        | d\|AT_REST\|bpm\|61\|gps\|13.357,52.515\|s\|0               | 110990      | pig001     |
        | d\|AT_REST\|bpm\|50\|gps\|13.411,52.468\|s\|0               | 98699       | cow001     |
        | d\|MOVING\|gps\|13.387,52.561\|s\|7                         | 1067386313  | tractor001 |
        | d\|AT_REST\|bpm\|60\|gps\|13.359,52.516\|s\|0               | 110990      | pig001     |
        | d\|GRAZING\|bpm\|53\|gps\|13.41,52.467\|s\|0                | 98699       | cow001     |
        | d\|IDLE\|gps\|13.3698,52.5163\|s\|0                         | 1067386313  | tractor001 |
        | d\|WALLOWING\|bpm\|66\|gps\|13.359,52.514\|s\|5             | 110990      | pig001     |
        | d\|GRAZING\|bpm\|53\|gps\|13.41,52.467\|s\|0                | 98699       | cow001     |
        | d\|AT_REST\|bpm\|66\|gps\|13.3986,52.5547\|s\|5             | 110990      | pig001     |
        | d\|AT_REST\|bpm\|53\|gps\|13.3987,52.5547\|s\|0             | 98699       | cow001     |

    Scenario: Checkout the logs. This proccess won't end
        When  I open a new shell terminal flink-logs and run "docker logs -f flink-taskmanager 2>&1"
        And   I wait "20" seconds
        Then  everything is ok

    Scenario: Check Flink docker output after some time to test that things worked with the registration
    Given I wait "60" seconds
    When  I Compare next lines in terminal flink-logs at least I can find 1 in stdout with a timeout 10 matching filename 01.expected_on_terminal.txt
    And   I flush the terminal flink-logs queues