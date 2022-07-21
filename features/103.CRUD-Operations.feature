#
# This Feature follows the requests composing the FIWARE Tutorial 103.Crud Operations
# available at: https://github.com/FIWARE/tutorials.CRUD-Operations/tree/NGSI-v2
#
# version 27 July 2021
#

Feature: test tutorial 103.CRUD-Operations

  This is the feature file of the FIWARE Step by Step tutorial for NGSI-v2
  url: https://fiware-tutorials.readthedocs.io/en/latest/crud-operations.html
  git-clone: https://github.com/FIWARE/tutorials.CRUD-Operations.git
  git-directory: /tmp/tutorials.CRUD-Operations
  shell-commands: ./services start
  clean-shell-commands: ./services stop


  Background:
    Given I set the tutorial 103

  Scenario: Checking the service health
    When  I send GET HTTP request to "http://localhost:1026/version"
    Then  I receive a HTTP "200" response code from Orion with the body equal to "response101-01.json"


#
#  Request 1
#
  Scenario Outline: Creating Context Data
    When I send POST HTTP request to "http://localhost:1026/v2/entities"
    And  With the body request described in file "<file>"
    Then I receive a HTTP response with the following data
      | Status-Code | Location   | Connection | fiware-correlator |
      | 201         | <location> | Keep-Alive | Any               |

    Examples:
      | file               | location |
      | request103-01.json | /v2/entities/urn:ngsi-ld:Product:010?type=Product |


#
#  Request 2
#   Note: In the tutorial the body response for this request is missing, so the test can only check if the code is 200
#         and not if the new Product is created as expected.
#
  Scenario: Obtain entity data by Id
    When I send GET HTTP request no body to assert to "http://localhost:1026/v2/entities/urn:ngsi-ld:Product:010?type=Product"
    Then I receive a HTTP "200" response code


#
#  Request 3
#   Note: In the tutorial is missing the error code 404 which is returned
#         if the entity to which you want to add the attribute does not exist.
#
  Scenario Outline: Adding an Attribute to an existing entity by Id
    When I send POST HTTP request to add an attribute to "http://localhost:1026/v2/entities/urn:ngsi-ld:Product:001/attrs"
    And  With the attribute request described in file "<file>"
    Then I receive a HTTP response on attribute with the following data
      | Status-Code |
      | 204         |

      Examples:
      | file               |
      | request103-03.json |


#
#  Request 4
#   Note: In the tutorial the body response for this request is missing, so the test can only check if the code is 200
#         and not if the new attribute as been added to the intended Product as expected.
#
  Scenario: Obtain entity data by Id
    When I send GET HTTP request no body to assert to "http://localhost:1026/v2/entities/urn:ngsi-ld:Product:001?type=Product"
    Then I receive a HTTP "200" response code


#
#  Request 5
#   Note: the tutorial mentions a scenario only as text ("Subsequent requests using the same data with the actionType=append_strict
#         batch operation will result in an error response."). This scenario is obviously not considered here.
#
  Scenario Outline: Create several entities and append attributes to existing once at the same time
    When I send POST HTTP batch request to "http://localhost:1026/v2/op/update"
    And  With the body batch request described in file "<file>"
    Then I receive a HTTP batch response with the following data
      | Status-Code |
      | 204         |

    Examples:
      | file               |
      | request103-05.json |


#
#  Request 6
#   Note 1: the data provided in the tutorial do not allow to see what intended to happen
#   Note 2: the tutorial mentions a scenario only as text ("SA subsequent request containing the same data
#         (i.e. same entities and actionType=append) won't change the context state."). Such scenario is obviously not considered here.
#
  Scenario Outline: Update several existing entities at the same time
    When I send POST HTTP batch request to "http://localhost:1026/v2/op/update"
    And  With the body batch request described in file "<file>"
    Then I receive a HTTP batch response with the following data
      | Status-Code |
      | 204         |

    Examples:
      | file               |
      | request103-06.json |


#
#  Request 7
#
  Scenario: Obtain entity data by Type
    When I send GET HTTP request to "http://localhost:1026/v2/entities/urn:ngsi-ld:Product:010?type=Product"
    Then I receive a HTTP "200" response code from Orion with the body equal to "response103-07.json"


#
#  Request 8
#
  Scenario: Obtain the value of a single attribute from an existing entity with a known id
    When I send GET HTTP request to "http://localhost:1026/v2/entities/urn:ngsi-ld:Product:001/attrs/name/value"
    Then I receive a HTTP "200" response code from Orion with the body equal to "response103-08.json"

#
#  Request 9
#
  Scenario: Obtain the value of the key-value pairs of two attributes from the context of existing entities with a known id
    When I send GET HTTP request to "http://localhost:1026/v2/entities/urn:ngsi-ld:Product:001?type=Product&options=keyValues&attrs=name,price"
    Then I receive a HTTP "200" response code from Orion with the body equal to "response103-09.json"


#
#  Request 10
#
  Scenario: Obtain the value of two attributes from the context of existing entities with a known id
    When I send GET HTTP request to "http://localhost:1026/v2/entities/urn:ngsi-ld:Product:001?type=Product&options=values&attrs=name,price"
    Then I receive a HTTP "200" response code from Orion with the body equal to "response103-10.json"


#
#  Request 11
#
  Scenario: Obtain all entities of a given type and all of their attributes
    When I send GET HTTP request to "http://localhost:1026/v2/entities?type=Product"
    Then I receive a HTTP "200" response code from Orion with the body equal to "response103-11.json"


#
#  Request 12
#
  Scenario: Obtain two specific attributes of all entities of a given type
    When I send GET HTTP request to "http://localhost:1026/v2/entities/?type=Product&options=keyValues&attrs=name,price"
    Then I receive a HTTP "200" response code from Orion with the body equal to "response103-12.json"


#
#  Request 13
#
  Scenario: Obtain all entities of a given type
    When I send GET HTTP request to "http://localhost:1026/v2/entities/?type=Product&options=count&attrs=__NONE"
    Then I receive a HTTP "200" response code from Orion with the body equal to "response103-13.json"


#
#  Request 14
#
  Scenario Outline: Update the value of an attribute
    When I send PUT HTTP request to update an attribute to "http://localhost:1026/v2/entities/urn:ngsi-ld:Product:001/attrs/price/value"
    And  With the update request described in file "<file>"
    Then I receive a HTTP response on update with the following data
      | Status-Code |
      | 204         |

    Examples:
      | file               |
      | request103-14.json |


#
#  Request 15
#
  Scenario Outline: Overwrite Multiple Attributes of a Data Entity
    When I send PATCH HTTP request to update attributes to "http://localhost:1026/v2/entities/urn:ngsi-ld:Product:001/attrs"
    And  With the patch update request described in file "<file>"
    Then I receive a HTTP response on updates with the following data
      | Status-Code |
      | 204         |

    Examples:
      | file               |
      | request103-15.json |


#
#  Request 16
#
  Scenario Outline: Batch Overwrite Attributes of Multiple Data Entities
    When I send POST HTTP batch request to "http://localhost:1026/v2/op/update"
    And  With the body batch request described in file "<file>"
    Then I receive a HTTP batch response with the following data
      | Status-Code |
      | 204         |

    Examples:
      | file               |
      | request103-16.json |


#
#  Request 17
#
  Scenario Outline: Batch Create/Overwrite Attributes of Multiple Data Entities
    When I send POST HTTP batch request to "http://localhost:1026/v2/op/update"
    And  With the body batch request described in file "<file>"
    Then I receive a HTTP batch response with the following data
      | Status-Code |
      | 204         |

    Examples:
      | file               |
      | request103-17.json |


#
#  Request 18
#
  Scenario Outline: Batch Replace Entity Data
    When I send POST HTTP batch request to "http://localhost:1026/v2/op/update"
    And  With the body batch request described in file "<file>"
    Then I receive a HTTP batch response with the following data
      | Status-Code |
      | 204         |

    Examples:
      | file               |
      | request103-18.json |


#
#  Request 19
#   Note: the tutorial mentions a scenario only as text ("Subsequent requests using the same id
#         will result in an error response since the entity no longer exists in the context.").
#         This scenario is obviously not considered here.
#
Scenario: Delete an Entity
  When I send DELETE HTTP request no body to "http://localhost:1026/v2/entities/urn:ngsi-ld:Product:010"
  Then I receive a DELETE HTTP "204" response code


#
#  Request 20
#   Note: the tutorial mentions a scenario only as text ("If the attribute does not exist in the context,
#         the result will be an error response.").
#         This scenario is obviously not considered here.
#
  Scenario: Delete an Attribute from an Entity
    When I send DELETE HTTP request no body to "http://localhost:1026/v2/entities/urn:ngsi-ld:Product:001/attrs/specialOffer"
    Then I receive a DELETE HTTP "204" response code


#
#  Request 21
#   Note: the tutorial mentions a scenario only as text ("If an entity does not exist in the context,
#         the result will be an error response.").
#         This scenario is obviously not considered here.
#
  Scenario Outline: Batch Delete Multiple Entities
    When I send POST HTTP batch request to "http://localhost:1026/v2/op/update"
    And  With the body batch request described in file "<file>"
    Then I receive a HTTP batch response with the following data
      | Status-Code |
      | 204         |

    Examples:
      | file               |
      | request103-21.json |


#
#  Request 22
#   Note: the tutorial mentions a scenario only as text ("If an attribute does not exist in the context,
#         the result will be an error response.").
#         This scenario is obviously not considered here.
#
  Scenario Outline: Batch Delete Multiple Attributes from an Entity
    When I send POST HTTP batch request to "http://localhost:1026/v2/op/update"
    And  With the body batch request described in file "<file>"
    Then I receive a HTTP batch response with the following data
      | Status-Code |
      | 204         |

    Examples:
      | file               |
      | request103-22.json |


#
#  Request 23
#
  Scenario: Find existing data relationships
    When I send GET HTTP request to "http://localhost:1026/v2/entities/?q=refProduct==urn:ngsi-ld:Product:001&options=count&attrs=type"
    Then I receive a HTTP "200" response code from Orion with the body equal to "response103-23.json"
