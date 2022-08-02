Feature: test tutorial 302 - Big Data Analysis (Flink)

  url: https://ngsi-ld-tutorials.readthedocs.io/en/latest/big-data-flink.html

  git-clone: https://github.com/FIWARE/tutorials.Big-Data-Flink.git
  git-directory: /tmp/tutorials.Big-Data-Flink
  shell-commands: git checkout NGSI-LD ; ./services create  ; ./services start
  clean-shell-commands: ./services stop

Background:
    Given  I set the tutorial 302 LD - Big Data Flink

  # COMPILING A JAR FILE FOR SPARK --
    # Scenario: Compiling a Jar File For Flink
    #    Given I prepare the script create-flink-jar.sh to be run
    #    When  I run the script as in the tutorial page
    #    Then  I expect the scripts shows a result of 0

  @ongoing
  Scenario: Compiling a jar file for Flink
    Given  I download the Orion Flink Connector "orion.flink.connector-1.2.4.jar"
    When   I execute the maven install command with the following data
      | file                            | artifactId            | version |
      | orion.flink.connector-1.2.4.jar | orion.flink.connector | 1.2.4   |
    And    I execute the maven package command
    And  Wait for debug
    Then   A new JAR file called "cosmos-examples-1.2.jar" is created within the "cosmos-examples/target" directory

    Scenario: Upload generated jar file
    Given  I have generated the "cosmos-examples-1.2.jar" in the target directory
    When   I submit this new jar file to the Flink instance
    Then   I receive the response with the following data
      | filename | status  | status_code |
      | ANY      | success | 200         |


    Scenario Outline: Subscribing Logger to context changes
    When I prepare a POST HTTP request for "<description>" to "http://localhost:1026/ngsi-ld/v1/subscriptions/"
    And  I set header Content-Type to application/ld+json
    And  I set header NGSILD-Tenant to openiot
    And  I set the body request as described in <file>
    And  I perform the request
    And  Wait for debug
    Then  I receive a HTTP "201" response code
    Examples:
        | description                            | file            |
        | notify feedstock and tractor changes   | 01.request.json |