Feature: test tutorial 101.Getting Started

  This is the feature file of the FIWARE Step by Step tutorial for NGSI-v2
  url: https://fiware-tutorials.readthedocs.io/en/latest/getting-started/index.html
  docker-compose: https://raw.githubusercontent.com/FIWARE/tutorials.Getting-Started/master/docker-compose.yml
  environment: https://raw.githubusercontent.com/FIWARE/tutorials.Getting-Started/master/.env

  Background:
    Given I set the tutorial


  Scenario: Checking the service health
    When  I send GET HTTP request to "http://localhost:1026/version"
    Then  I receive a HTTP "200" response code with the body "response101-01.json"


  Scenario Outline: Creating Context Data
    When I send POST HTTP request to "http://localhost:1026/v2/entities"
    And  With the body request described in file "<file>"
    Then I receive a HTTP response with the following data
      | Status-Code | Location   | Connection | fiware-correlator |
      | 201         | <location> | Keep-Alive | Any               |

    Examples:
        | file               | location                                      |
        | request101-02.json | /v2/entities/urn:ngsi-ld:Store:001?type=Store |
        | request101-03.json | /v2/entities/urn:ngsi-ld:Store:002?type=Store |


  Scenario: Obtain entity data by Id
    When I send GET HTTP request to "http://localhost:1026/v2/entities/urn:ngsi-ld:Store:001?options=keyValues"
    Then  I receive a HTTP "200" response code with the body "response101-04.json"


  Scenario: Obtain entity data by Type
    When I send GET HTTP request to "http://localhost:1026/v2/entities?type=Store&options=keyValues"
    Then I receive a HTTP "200" response code with the body "response101-05.json"


  Scenario: Filter context data by comparing the values of an attribute
    When I send GET HTTP request to "http://localhost:1026/v2/entities?type=Store&options=keyValues&q=name==%27Checkpoint%20Markt%27"
    Then I receive a HTTP "200" response code with the body "response101-06.json"
