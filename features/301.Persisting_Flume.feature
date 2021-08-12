Feature: test tutorial 301.Persisting Context Data using Apache Flume (MongoDB, MySQL, PostgreSQL)

  This is the feature file of the FIWARE Step by Step tutorial for Persisting Context Data using Apache Flume (MongoDB, MySQL, PostgreSQL)
  url: https://fiware-tutorials.readthedocs.io/en/latest/historic-context-flume.html
  git-clone: https://github.com/FIWARE/tutorials.Historic-Context-Flume.git
  git-directory: /tmp/tutorials.Historic-Context-Flume
  shell-commands: ./services create; ./services mongodb
  clean-shell-commands: ./services stop


  Background:
    Given I set the tutorial 301


  Scenario: Checking the Cygnus service health
    When  I send GET HTTP request to "http://localhost:5080/v1/version"
    Then  I receive a HTTP "200" response code with the body "response301-01.json"

  Scenario: Getting API key for lamp and door
    When  The fiware-service header is "openiot" and the fiware-servicepath header is "/"
    And   I send GET HTTP request to "http://localhost:4041/iot/services" with fiware-service and fiware-servicepath
    Then  I receive a HTTP "200" response code with all the services information

  Scenario Outline: Generating context data
    When  The fiware-service header is "openiot" and the fiware-servicepath header is "/"
    And   I send PATCH HTTP request with the following data
      | Url                      | Entity_ID   | Command |
      | http://localhost:1026/v2 | <entity_id> | <command> |
    Then  I receive a HTTP "204" response

    Examples:
        | command | entity_id |
        | unlock  | Door:001  |
        | on      | Lamp:001 |
