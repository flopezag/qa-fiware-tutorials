Feature: test tutorial 305.Big Data (Spark)

  This is the feature file of the FIWARE Step by Step tutorial for Big Data (Spark)
  url: https://fiware-tutorials.readthedocs.io/en/latest/big-data-spark.html
  git-clone: https://github.com/FIWARE/tutorials.Big-Data-Spark.git
  git-directory: /tmp/tutorials.Big-Data-Spark
  shell-commands: git checkout NGSI-v2 ; ./services create; ./services start
  clean-shell-commands: ./services stop


    Background:
        Given I set the tutorial 305.Spark


    Scenario: Compiling a Jar File For Spark
        Given I prepare the script create-spark-jar.sh to be run
        And   I set the environ variable WORKING_DIR to "cosmos-examples" under git
        And   I set the environ variable OUTPUT_DIR to "cosmos-examples/target" under git
        When  I exec the script as in the tutorial page
        Then  I expect the scripts shows a result of 0

    Scenario: Run the generated jar in Spark. This process won't end
        Given I prepare the script run-spark-jar.sh to be run
        When  I open a new shell terminal spark-run-jar and exec "features/data/305.Big_Data_Spark/run-spark-jar.sh"
        And   I wait "2" seconds

    Scenario: Request 1 - Create a subscription with the Context Broker
      When  I prepare a POST HTTP request to "http://localhost:1026/v2/subscriptions"
      And   I set header fiware-service to openiot
      And   I set header fiware-servicepath to /
      And   I set the body request as described in 01.request_305.json
      And   I perform the request
      Then  I receive a HTTP response with status 201 and empty dict

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

    Scenario: Request 2 - Test the subscriptions
       When  I prepare a GET HTTP request to "http://localhost:1026/v2/subscriptions/"
       And   I set header fiware-service to openiot
       And   I set header fiware-servicepath to /
       And   I perform the query request
       Then  I receive a HTTP "200" response code from Broker with the body "02.response_305.json" and exclusions "02.excludes"

    # I see no output here. Not even running the tutorial from the command line.... however I learn that
    # before testing the Subscription.. there is some info there:
    #
    #  Remember to unlock the Smart Door and switch on the Smart Lamp
    # So I added a couple things before Request 2 to fulfill that requirement.
    #
    Scenario: Logger - checking the output
      Given I wait "70" seconds
      When  I Compare next lines in terminal spark-run-jar are like in filename 01.expected_on_terminal.txt
      Then  All lines must have matched

    Scenario: Run the generated jar in Spark using the LoggerLD. This process won't end
      Given I prepare the script run-spark-ld-jar.sh to be run
      When  I open a new shell terminal spark-run-ld-jar and exec "features/data/305.Big_Data_Spark/run-spark-ld-jar.sh"

    Scenario: Run the generated jar in Spark for the feedback loop. This process won't end
      Given I prepare the script run-spark-feedback-loop-jar.sh to be run
      When  I open a new shell terminal run-spark-feedback-loop-jar and exec "features/data/305.Big_Data_Spark/run-spark-feedback-loop-jar.sh"
      And   I wait "2" seconds

    Scenario: Request x - Feedback Loop - Subscribing to context changes
      When  I prepare a POST HTTP request to "http://localhost:1026/v2/subscriptions"
      And   I set header fiware-service to openiot
      And   I set header fiware-servicepath to /
      And   I set the body request as described in 0x.feedback.request_305.json
      And   I perform the request
      Then  I receive a HTTP response with status 201 and empty dict

    # FIXME
  Scenario: Remove me
    Given I wait "190" seconds
