Feature: test tutorial 306 NGSI-LD Big Data Analysis (Spark)

  This is the feature file of the FIWARE Step by Step tutorial Big Data Analysis with Spark- NGSI-LD

  url: https://ngsi-ld-tutorials.readthedocs.io/en/latest/big-data-spark.html
  git-clone: https://github.com/FIWARE/tutorials.Big-Data-Spark.git
  git-directory: /tmp/tutorials.Big-Data-Spark
  shell-commands: git checkout NGSI-LD ; mkdir cosmos-examples ; ./services create  ; ./services start
  clean-shell-commands: ./services stop ; docker kill  spark-worker-1 ; docker kill spark-master ; docker rm  spark-worker-1 ; docker rm spark-master

  Background:
    Given I set the tutorial 306 NGSI-LD - Big Data analysis with Spark

    # COMPILING A JAR FILE FOR SPARK --
    Scenario: Compiling a Jar File For Spark
        Given I prepare the script create-spark-jar.sh to be run
        And   I set the environ variable WORKING_DIR to "cosmos-examples" under git
        And   I set the environ variable OUTPUT_DIR to "cosmos-examples/target" under git
        When  I run the script as in the tutorial page
        Then  I expect the scripts shows a result of 0

    #   LOGGER - READING CONTEXT DATA STREAMS
    # - Logger - Installing the JAR
    Scenario: Run the generated jar in Spark. This process won't end
        Given I prepare the script run-spark-ld-jar.sh to be run
        When  I open a new shell terminal spark-run-jar and run "features/data/306.ngsild.Big_Data_Spark/run-spark-ld-jar.sh"
        And   I wait "2" seconds
        Then  everything is ok

    Scenario Outline: Registering spark logger
        When I prepare a POST HTTP request for "<description>" to "http://localhost:1026/ngsi-ld/v1/subscriptions/"
        And  I set header Content-Type to application/ld+json
        And  I set header NGSILD-Tenant to openiot
        And  I set the body request as described in <file>
        And  I perform the request
        Then  I receive a HTTP "201" response code
        Examples:
            | description                | file            |
            | notify of animal locations | 01.request.json |

    # Request 2 -
    Scenario: Check the subscriptions for Spark Logger to ngsi-ld
        When  I send GET HTTP request to "http://localhost:1026/ngsi-ld/v1/subscriptions/"
        And   I set header NGSILD-Tenant to openiot
        Then  I receive a HTTP "200" response code

    # Populate things....
    # Somehow I need to add data to Sensors so they can add data to Cratedb
    # This is not in tutorial, but it is the way to add data without Web dashboard
    ## Example post: 12:53:47 PM HTTP POST http://iot-agent:7896/iot/d?i=filling001&k=854782081 f|0.45
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

    # After sending data for Tractor and Devices, we wait one minute until we could have some
    # output.
    #
    Scenario: Logger - checking the output
        Given I wait "60" seconds
        When  I Compare next lines in terminal spark-run-jar at least I can find 1 in stdout with a timeout 10 matching filename 01.expected_on_terminal.txt
        And   I flush the terminal spark-run-jar queues

    # - Logger - Installing the JAR - feedback-ld - 2nd example
    Scenario: Run Feedback Loop - Persisting Context Data
        Given I prepare the script run-spark-feedback-ld.sh to be run
        When  I open a new shell terminal run-spark-feedback-ld and run "features/data/306.ngsild.Big_Data_Spark/run-spark-feedback-ld.sh"
        And   I wait "2" seconds
        Then  everything is ok

    # Request 3 -- register
    Scenario Outline: Registering spark logger
        When I prepare a POST HTTP request for "<description>" to "http://localhost:1026/ngsi-ld/v1/subscriptions/"
        And  I set header Content-Type to application/ld+json
        And  I set header NGSILD-Tenant to openiot
        And  I set the body request as described in <file>
        And  I perform the request
        Then  I receive a HTTP "201" response code
        Examples:
            | description                | file            |
            | notify of animal locations | 03.request.json |

    # Request 4 -
    Scenario: Check the new subscritpion for Spark logger
        When  I send GET HTTP request to "http://localhost:1026/ngsi-ld/v1/subscriptions/"
        And   I set header NGSILD-Tenant to openiot
        Then  I receive a HTTP "200" response code

    # Populate humidity sensors....
    # In order to get some data relative to humidity
    # This is not in tutorial, but it is the way to add data without Web dashboard
    ## Example post: 12:53:47 PM HTTP POST http://iot-agent:7896/iot/d?i=filling001&k=854782081 f|0.45
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
            | sensor_value | key_value   | sensor      |
            | h\|73        | 548027571   | humidity001 |
            | h\|78        | 548027571   | humidity001 |
            | h\|83        | 548027571   | humidity001 |
            | h\|88        | 548027571   | humidity001 |

    # After sending data for Tractor and Devices, we wait one minute until we could have some
    # output.
    Scenario: Logger - checking the output
        Given I wait "60" seconds
        When  I Compare next lines in terminal run-spark-feedback-ld at least I can find 1 in stdout with a timeout 10 matching filename 02.expected_on_terminal.txt
        And   I flush the terminal run-spark-feedback-ld queues

