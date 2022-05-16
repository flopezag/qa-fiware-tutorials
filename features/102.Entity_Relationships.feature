#
# This Feature follows the requests composing the FIWARE Tutorial 102.Entity Relationships
# available at: https://github.com/FIWARE/tutorials.Entity-Relationships/tree/NGSI-v2
#
# version 21 July 2021
#

Feature: test tutorial 102.Entity_Relationships

  This is the feature file of the FIWARE Step by Step tutorial for NGSI-v2
  url: https://fiware-tutorials.readthedocs.io/en/latest/entity-relationships.html
  git-clone: https://github.com/FIWARE/tutorials.Entity-Relationships.git
  git-directory: /tmp/tutorials.Entity-Relationships
  shell-commands: ./services start
  clean-shell-commands: ./services stop

  Background:
    Given I set the tutorial 102


  Scenario: Checking the service health
    #When  I wait "5" seconds
    When  I send GET HTTP request to "http://localhost:1026/version"
    Then  I receive a HTTP "200" response code from Orion with the body equal to "response101-01.json"


#
#  Requests 1 and 2
#
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


#
#  Request 3
#
 Scenario: Obtain entity data by Id
   When I send GET HTTP request to "http://localhost:1026/v2/entities/urn:ngsi-ld:Shelf:unit001/?type=Shelf&options=keyValues"
   Then I receive a HTTP "200" response code from Orion with the body equal to "response102-03.json"


#
#  Request 4
#
   Scenario Outline: Creating several one-to-many Relationships at the same time
     When I send POST HTTP batch request to "http://localhost:1026/v2/op/update"
     And  With the body batch request described in file "<file>"
     Then I receive a HTTP batch response with the following data
       | Status-Code |
       | 204         |

     Examples:
         | file               |
         | request102-04.json |

#
#  Request 5
#
 Scenario: Obtain entity data by Id
   When I send GET HTTP request to "http://localhost:1026/v2/entities/urn:ngsi-ld:Shelf:unit001/?type=Shelf&options=keyValues"
   Then I receive a HTTP "200" response code from Orion with the body equal to "response102-05.json"


#
#  Request 6
#
 Scenario: Reading from Child Entity to Parent Entity
   When I send GET HTTP request to "http://localhost:1026/v2/entities/urn:ngsi-ld:Shelf:unit001/?type=Shelf&options=values&attrs=refStore"
   Then I receive a HTTP "200" response code from Orion with the body equal to "response102-06.json"


#
#  Request 7
#
 Scenario: Reading from Parent Entity to Child Entity
   When I send GET HTTP request to "http://localhost:1026/v2/entities/?q=refStore==urn:ngsi-ld:Store:001&options=count&attrs=type&type=Shelf"
   Then I receive a HTTP "200" response code from Orion with the body equal to "response102-07.json"


#
#  Request 8
#
 Scenario: Reading from Parent Entity to Child Entity values of a specific attribute
   When I send GET HTTP request to "http://localhost:1026/v2/entities/?q=refStore==urn:ngsi-ld:Store:001&type=Shelf&options=values&attrs=name"
   Then I receive a HTTP "200" response code from Orion with the body equal to "response102-08.json"


#
#  Request 9
#
Scenario Outline: Creating many-to-many Relationships
   When I send POST HTTP request to "http://localhost:1026/v2/entities"
   And  With the body request described in file "<file>"
   Then I receive a HTTP response with the following data
     | Status-Code | Location   | Connection | fiware-correlator |
     | 201         | <location> | Keep-Alive | Any               |

   Examples:
     | file               | location |
     | request102-09.json | /v2/entities/urn:ngsi-ld:InventoryItem:001?type=InventoryItem |


#
#  Requests 10 and 11
#
Scenario: Reading from a bridge table
   When I send GET HTTP request to "http://localhost:1026/v2/entities/?q=refStore==urn:ngsi-ld:Store:001&options=values&attrs=refProduct&type=InventoryItem"
   Then I receive a HTTP "200" response code from Orion with the body equal to "response102-10.json"


Scenario: Reading from a bridge table
   When I send GET HTTP request to "http://localhost:1026/v2/entities/?q=refProduct==urn:ngsi-ld:Product:001&options=values&attrs=refStore&type=InventoryItem"
   Then I receive a HTTP "200" response code from Orion with the body equal to "response102-11.json"


#
#  Request 12
#
Scenario: Data Integrity
   When I send GET HTTP request to "http://localhost:1026/v2/entities/?q=refStore==urn:ngsi-ld:Store:001&options=count&attrs=type"
   Then I receive a HTTP "200" response code from Orion with the body equal to "response102-12.json"
