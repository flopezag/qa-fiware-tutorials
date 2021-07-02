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
    Then I receive a HTTP "201" code response

    Examples:
        | file |
        | request101-02.json |
        | request101-03.json |

  Scenario: POST request3
    When I set the following request body to "request101-03.json"
    And  I send POST HTTP request to "http://localhost:1026/v2/entities"
    Then I receive a HTTP "201" code response
    And  I receive this dictionary
      | Connection | Content-Length | Location                                      |
      | Keep-Alive | 0              | /v2/entities/urn:ngsi-ld:Store:002?type=Store |
    And also the following variables
      | Fiware-correlator | Date |

  Scenario: GET request4
    When I send GET HTTP request to "http://localhost:1026/v2/entities/urn:ngsi-ld:Store:001"
    Then I receive a HTTP "200" code response
    And  I receive the dictionary below
      | id                    | type  | address                                                   | location          | name               |
      | urn:ngsi-ld:Store:001 | store | streetAddress, addressRegion, addressLocality, postalCode | type, coordinates | Bösebrücke Einkauf |
    And  I receive the following info with the "address" key
      | streetAdress         | addressRegion | addressLocality | postalCode |
      | Bornholmer Straße 65 | Berlin        | Prenzlauer Berg | 10439      |

    And  I receive the following info with the "location" key
      | type  | coordinates      |
      | Point | 13.3986, 52.5547 |


  Scenario: GET request5
    When I send GET HTTP request to "http://localhost:1026/v2/entities"
    Then I receive a HTTP "200" code response
    And  I receive the entities dictionary


  Scenario: GET request6
    When I send GET HTTP request to "http://localhost:1026/v2/entities"
    Then I receive a HTTP "200" code response
    And  I receive the entities dictionary
