#
# This Feature follows the requests composing the FIWARE Tutorial 102.Entity Relationships
# available at: https://github.com/FIWARE/tutorials.Entity-Relationships/tree/NGSI-v2
#
# version 21 July 2021
#

Feature: test tutorial 102.Entity_Relationships

  This is the feature file of the FIWARE Step by Step tutorial for NGSI-v2
  url: https://fiware-tutorials.readthedocs.io/en/latest/entity-relationships/index.html
  docker-compose: https://raw.githubusercontent.com/FIWARE/tutorials.Entity-Relationships/ce7531bc77b8576efddadaeec7ec84c9b5608d62/docker-compose.yml
  environment: https://raw.githubusercontent.com/FIWARE/tutorials.Entity-Relationships/ce7531bc77b8576efddadaeec7ec84c9b5608d62/.env
  init-script: https://raw.githubusercontent.com/FIWARE/tutorials.Entity-Relationships/ce7531bc77b8576efddadaeec7ec84c9b5608d62/services
  aux: [https://raw.githubusercontent.com/FIWARE/tutorials.Entity-Relationships/ce7531bc77b8576efddadaeec7ec84c9b5608d62/import-data]

  Background:
    Given I set the tutorial 102


  Scenario: Checking the service health
    When  I send GET HTTP request to "http://localhost:1026/version"
    Then  I receive a HTTP "200" response code with the body "response101-01.json"

  Scenario Outline: Create several entities at the same time
    When I send POST HTTP batch request to "http://localhost:1026/v2/op/update"
    And  With the body batch request described in file "<file>"
    Then I receive a HTTP batch response with the following data
      | Status-Code |
      | 204         |

    Examples:
      | file               |
      | request102-01.json |
      | request102-02.json |


 Scenario: Obtain entity data by Id
   When I send GET HTTP request to "http://localhost:1026/v2/entities/urn:ngsi-ld:Shelf:unit001/?type=Shelf&options=keyValues"
   Then I receive a HTTP "200" response code with the body "response102-03.json"


   Scenario Outline: Create several entities at the same time
     When I send POST HTTP batch request to "http://localhost:1026/v2/op/update"
     And  With the body batch request described in file "<file>"
     Then I receive a HTTP batch response with the following data
       | Status-Code |
       | 204         |

     Examples:
         | file               |
         | request102-04.json |

 Scenario: Obtain entity data by Id
   When I send GET HTTP request to "http://localhost:1026/v2/entities/urn:ngsi-ld:Shelf:unit001/?type=Shelf&options=keyValues"
   Then I receive a HTTP "200" response code with the body "response102-05.json"

 Scenario: Obtain entity data by Id
   When I send GET HTTP request to "http://localhost:1026/v2/entities/urn:ngsi-ld:Shelf:unit001/?type=Shelf&options=values&attrs=refStore"
   Then I receive a HTTP "200" response code with the body "response102-06.json"

 Scenario: Obtain entity data by Id
   When I send GET HTTP request to "http://localhost:1026/v2/entities/?q=refStore==urn:ngsi-ld:Store:001&options=count&attrs=type&type=Shelf"
   Then I receive a HTTP "200" response code with the body "response102-07.json"

 Scenario: Obtain entity data by Id
   When I send GET HTTP request to "http://localhost:1026/v2/entities/?q=refStore==urn:ngsi-ld:Store:001&type=Shelf&options=values&attrs=name"
   Then I receive a HTTP "200" response code with the body "response102-08.json"


 Scenario Outline: Creating Context Data
   When I send POST HTTP request to "http://localhost:1026/v2/entities"
   And  With the body request described in file "<file>"
   Then I receive a HTTP response with the following data
     | Status-Code | Location   | Connection | fiware-correlator |
     | 201         | <location> | Keep-Alive | Any               |

   Examples:
     | file               | location |
     | request102-09.json | /v2/entities/urn:ngsi-ld:InventoryItem:001?type=InventoryItem |


 Scenario: Obtain entity data by Id
   When I send GET HTTP request to "http://localhost:1026/v2/entities/?q=refStore==urn:ngsi-ld:Store:001&options=values&attrs=refProduct&type=InventoryItem"
   Then I receive a HTTP "200" response code with the body "response102-10.json"

 Scenario: Obtain entity data by Id
   When I send GET HTTP request to "http://localhost:1026/v2/entities/?q=refProduct==urn:ngsi-ld:Product:001&options=values&attrs=refStore&type=InventoryItem"
   Then I receive a HTTP "200" response code with the body "response102-11.json"

 Scenario: Obtain entity data by Id
   When I send GET HTTP request to "http://localhost:1026/v2/entities/?q=refStore==urn:ngsi-ld:Store:001&options=count&attrs=type"
   Then I receive a HTTP "200" response code with the body "response102-12.json"
