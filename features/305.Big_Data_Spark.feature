Feature: test tutorial 305.Big Data (Spark)

  This is the feature file of the FIWARE Step by Step tutorial for Big Data (Spark)
  url: https://fiware-tutorials.readthedocs.io/en/latest/big-data-spark.html
  git-clone: https://github.com/FIWARE/tutorials.Big-Data-Spark.git
  git-directory: /tmp/tutorials.Big-Data-Spark
  shell-commands: git checkout NGSI-v2 ; ./services create; ./services start
  clean-shell-commands: ./services stop


    Background:
        Given I set the tutorial 305.Spark

    # COMPILING A JAR FILE FOR SPARK --
    Scenario: Compiling a Jar File For Spark
        Given I prepare the script create-spark-jar.sh to be run
        And   I set the environ variable WORKING_DIR to "cosmos-examples" under git
        And   I set the environ variable OUTPUT_DIR to "cosmos-examples/target" under git
        When  I exec the script as in the tutorial page
        Then  I expect the scripts shows a result of 0

    #   LOGGER - READING CONTEXT DATA STREAMS
    # - Logger - Installing the JAR
    Scenario: Run the generated jar in Spark. This process won't end
        Given I prepare the script run-spark-jar.sh to be run
        When  I open a new shell terminal spark-run-jar and exec "features/data/305.Big_Data_Spark/run-spark-jar.sh"
        And   I wait "2" seconds

    # -- Subscribing to Context changes. Request 1
    Scenario: Request 1 - Create a subscription with the Context Broker
      When  I prepare a POST HTTP request to "http://localhost:1026/v2/subscriptions"
      And   I set header fiware-service to openiot
      And   I set header fiware-servicepath to /
      And   I set the body request as described in 01.request_305.json
      And   I perform the request
      Then  I receive a HTTP response with status 201 and empty dict

    # The next Scenario outline is not shown in the tutorial, but it is writen textually:
    #
    # "... if this is not the case, then the devices are not regularly sending data. \
    # Remember to unlock the Smart Door and switch on the Smart Lamp"
    #
    # so I translate English to Context-Broker
    Scenario Outline: Pre-Request 2 scenario - Do something with the devices
      When  I prepare a PATCH HTTP request to "http://localhost:1026/v2/entities/<device>/attrs"
      And   I set header fiware-service to openiot
      And   I set header fiware-servicepath to /
      And   I set the body request as described in <request_file>
      And   I perform the request
      Then  I receive a HTTP response with status <response_code> and empty dict
      Examples:
        | request_file           | device     | response_code  |
        | ring_bell_req.json     | Bell:001   | 204            |
        | unlock_door.json       | Door:001   | 204            |

    # Check the subscrition is done.
    Scenario: Request 2 - Test the subscriptions
       When  I prepare a GET HTTP request to "http://localhost:1026/v2/subscriptions/"
       And   I set header fiware-service to openiot
       And   I set header fiware-servicepath to /
       And   I perform the query request
       Then  I receive a HTTP "200" response code from Broker with the body "02.response_305.json" and exclusions "02.excludes"

    #  Remember to unlock the Smart Door and switch on the Smart Lamp
    # So I added a couple things before Request 2 to fulfill that requirement.
    #
    Scenario: Logger - checking the output
      Given I wait "60" seconds
      When  I Compare next lines in terminal spark-run-jar at least I can find 1 in stdout with a timeout 10 matching filename 01.expected_on_terminal.txt
      And   I flush the terminal spark-run-jar queues

    # LOGGER NGSI-DL:
    # I guess this should be the same as previous case but for LD. Don't know if I have to do something in
    # between for this to work.
    Scenario: Run the generated jar in Spark using the LoggerLD. This process won't end
      Given I kill process in terminal spark-run-jar
      And   I wait "10" seconds
      Given I prepare the script run-spark-ld-jar.sh to be run
      When  I open a new shell terminal spark-run-ld-jar and exec "features/data/305.Big_Data_Spark/run-spark-ld-jar.sh"


    # I check the output as I did in previous case, but don't know what to expect here.
    Scenario: Logger - checking the output on LD if any...
      Given I wait "60" seconds
      When  I Compare next lines in terminal spark-run-ld-jar at least I can find 1 in stdout with a timeout 10 matching filename 01.expected_on_terminal.txt
      And   I flush the terminal spark-run-jar queues

    ##   FEEDBACK LOOP - INSTALLING THE JAR
    # This is failing. I have no output as expected o shouldn't I expect anything.
    Scenario: Run the generated jar in Spark for the feedback loop. This process won't end
      Given I kill process in terminal spark-run-ld-jar
      And   I wait "10" seconds
      Given I prepare the script run-spark-feedback-loop-jar.sh to be run
      When  I open a new shell terminal run-spark-feedback-loop-jar and exec "features/data/305.Big_Data_Spark/run-spark-feedback-loop-jar.sh"
      And   I wait "2" seconds

    #   FEEDBACK LOOP - PERSISTING CONTEXT DATA
    # Subscrition as in 03
    Scenario: Request 3 - Feedback Loop - Subscribing to context changes
      When  I prepare a POST HTTP request to "http://localhost:1026/v2/subscriptions"
      And   I set header fiware-service to openiot
      And   I set header fiware-servicepath to /
      And   I set the body request as described in 03.feedback.request_305.json
      And   I perform the request
      Then  I receive a HTTP response with status 201 and empty dict

    # Unlock the door and wait. Once the door opens and the Motion sensor is triggered, the lamp will switch on directly"
    # So, basically the same as previously done 1st scenario
    Scenario Outline: Unlock the door to test if the light gets on later.
      When  I prepare a PATCH HTTP request to "http://localhost:1026/v2/entities/<device>/attrs"
      And   I set header fiware-service to openiot
      And   I set header fiware-servicepath to /
      And   I set the body request as described in <request_file>
      And   I perform the request
      Then  I receive a HTTP response with status <response_code> and empty dict
      Examples:
        | request_file           | device     | response_code  |
        | unlock_door.json       | Door:001   | 204            |

    # Wait and check that light is on
    # I wait 5 seconds, but watching the monitor on http://localhost:3000/device/monitor nothing happens
    #
    Scenario: Wait and check that light is on
       When  I prepare a GET HTTP request to "http://localhost:1026/v2/entities/Lamp:001/attrs/state"
       And   I set header fiware-service to openiot
       And   I set header fiware-servicepath to /
       And   I wait "5" seconds
       And   I perform the query request
       Then  I receive a HTTP "200" response code from Broker with the body "03.response_305.json" and exclusions "03.excludes"
