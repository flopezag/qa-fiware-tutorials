Feature: test tutorial 306 NGSI-LD Big Data Analysis (Spark)

  This is the feature file of the FIWARE Step by Step tutorial Big Data Analysis with Spark- NGSI-LD
  # url (used): https://documenter.getpostman.com/view/513743/TWDUpxxx
  #   -- This is linked in "url" as "POSTMAN" -- It works much better than the original.
  url: https://ngsi-ld-tutorials.readthedocs.io/en/latest/big-data-spark.html

  # git-clone -- As shown in the "POSTMAN" part of the tutorial.
  git-clone: https://github.com/FIWARE/tutorials.Big-Data-Spark.git

  git-directory: /tmp/tutorials.Big-Data-Spark
  shell-commands: git checkout NGSI-LD ; ./services create  ; ./services start
  clean-shell-commands: ./services stop


  Background:
    Given I set the tutorial 306 NGSI-LD - Big Data analysis with Spark

    # COMPILING A JAR FILE FOR SPARK --
    Scenario: Compiling a Jar File For Spark
        Given I prepare the script create-spark-jar.sh to be run
        And   I set the environ variable WORKING_DIR to "cosmos-examples" under git
        And   I set the environ variable OUTPUT_DIR to "cosmos-examples/target" under git
        When  I run the script as in the tutorial page
        And   I wait for debug
        Then  I expect the scripts shows a result of 0

    #   LOGGER - READING CONTEXT DATA STREAMS
    # - Logger - Installing the JAR
    Scenario: Run the generated jar in Spark. This process won't end
        Given I prepare the script run-spark-ld-jar.sh to be run
        When  I open a new shell terminal spark-run-jar and run "features/data/306.ngsild.Big_Data_Spark/run-spark-ld-jar.sh"
        And   I wait "2" seconds
        And   I wait for debug
        Then  everything is ok
