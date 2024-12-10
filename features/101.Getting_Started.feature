Feature: test tutorial 101.Getting Started

  This is the feature file of the FIWARE Step by Step tutorial for NGSI-v2
  url: https://fiware-tutorials.readthedocs.io/en/latest/getting-started.html
  git-clone: https://github.com/FIWARE/tutorials.Getting-Started.git
  git-directory: /tmp/tutorials.Getting-Started
  shell-commands: git checkout NGSI-v2 ; export $(cat .env | grep "#" -v); docker compose -p fiware up -d
  clean-shell-commands: docker compose -p fiware down

  Background:
    Given I set the tutorial 101


  Scenario: Checking the service health
    When  I wait "5" seconds
    When  I send GET HTTP request to "http://localhost:1026/version"
    Then  I receive a HTTP "200" response code from Orion with the body "response101-01.json" and exclusions "response101-01.excludes"

  Scenario Outline: Creating Context Data
    When The content-type header key equal to "application/json"
    And  the body request described in file "<file>"
    And  I send a POST HTTP request to "http://localhost:1026/v2/entities"
    Then I receive a HTTP response with the following data
      | Status-Code | Location   | Connection | fiware-correlator |
      | 201         | <location> | Keep-Alive | Any               |

    Examples:
        | file               | location                                      |
        | request101-02.json | /v2/entities/urn:ngsi-ld:Store:001?type=Store |
        | request101-03.json | /v2/entities/urn:ngsi-ld:Store:002?type=Store |


  Scenario: Obtain entity data by Id
    When I send GET HTTP request to "http://localhost:1026/v2/entities/urn:ngsi-ld:Store:001?options=keyValues"
    Then I receive a HTTP "200" response code from Orion with the body equal to "response101-04.json"


  Scenario: Obtain entity data by Type
    When I send GET HTTP request to "http://localhost:1026/v2/entities?type=Store&options=keyValues"
    Then I receive a HTTP "200" response code from Orion with the body equal to "response101-05.json"


  Scenario: Filter context data by comparing the values of an attribute
    When I send GET HTTP request to "http://localhost:1026/v2/entities?type=Store&options=keyValues&q=name==%27Checkpoint%20Markt%27"
    Then I receive a HTTP "200" response code from Orion with the body equal to "response101-06.json"
