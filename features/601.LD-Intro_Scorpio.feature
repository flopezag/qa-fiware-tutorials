Feature: test tutorial 601 Introduction to Linked Data (Scorpio)

#
#   Parameters to be considered (aka INTERESTING_FEATURES_STRINGS)
#
    url: https://fiware-tutorials.readthedocs.io/en/latest/linked-data.html
    git-clone: https://github.com/FIWARE/tutorials.Linked-Data.git
    git-directory: /tmp/tutorials.Linked-Data-Intro

    shell-commands: ./services create; ./services scorpio
    clean-shell-commands: ./services stop


    Background:
        Given I set the tutorial 601

#
#   Request 0
#       Note: There is no /version in the Scorpio API and the response is not the one that it is detailed in
#             the tutorial. We need to check the url /health and the response is the following:
#                 {
#                  "Status of Registrymanager": "Up and running",
#                  "Status of Entitymanager": "Up and running",
#                  "Status of Subscriptionmanager": "Up and running",
#                  "Status of Storagemanager": "Up and running",
#                  "Status of Querymanager": "Up and running",
#                  "Status of Historymanager": "Up and running"
#                 }
    Scenario: [1] Checking the Scorpio service health
        When  I send GET HTTP request to "http://localhost:9090/health"
        Then  I receive a HTTP "202" response code from Scorpio with the body equal to "response601-01-scorpio.json"

#
#   Request 2, 3: Creating an Entity
#
    Scenario Outline: [2, 3] Creating an Entity
      When I send POST HTTP request to Scorpio at "http://localhost:9090/ngsi-ld/v1/entities"
      And  I set the "Content-Type" header with the value "application/ld+json"
      And  With the body request described in an Scorpio file "<file>"
      Then I receive a HTTP response with the following Scorpio data
        | Status-Code | Location   |
        | 201         | <location> |

      Examples:
        | file               | location                                           |
        | request601-02.json | /ngsi-ld/v1/entities/urn:ngsi-ld:Building:store001 |
        | request601-03.json | /ngsi-ld/v1/entities/urn:ngsi-ld:Building:store002 |


#
#   Request 4
#     Note: the body response is quite different from what expected. In particular:
#           - the attribute "@context" is at the beginning of the entity and not at the end as expected
#           - the attribute "http://schema.org/address" is instead of "https://schema.org/address"
#           - the structured attribute
#                           "https://uri.fiware.org/ns/data-models#category": {
#                                "type": "Property",
#                                "value": ["commercial"]
#                                }, is instead of
#                           "https://smart-data-models.github.io/data-models/terms.jsonld#/definitions/category": {
#                                "type": "Property",
#                                "value": "commercial"
#                                } and is in a wrong position.
#
    Scenario: [4] OBTAIN ENTITY DATA BY FQN TYPE
      When  I send GET HTTP request to "http://localhost:9090/ngsi-ld/v1/entities?type=https://uri.fiware.org/ns/data-models%23Building"
      Then  I receive a HTTP "200" response code from Scorpio with the body equal to "response601-04.json"


#
#   Request 5
#     Note: the body response is quite different from what expected. In particular:
#           - the attribute "@context" is at the beginning of the entity and not at the end as expected
#           - the attribute "http://schema.org/address" is instead of "https://schema.org/address"
#           - the structured attribute
#                           "https://uri.fiware.org/ns/data-models#category": {
#                                "type": "Property",
#                                "value": ["commercial"]
#                                }, is instead of
#                           "https://smart-data-models.github.io/data-models/terms.jsonld#/definitions/category": {
#                                "type": "Property",
#                                "value": "commercial"
#                                } and is in a wrong position.
#
    Scenario: [5] OBTAIN ENTITY DATA BY ID
      When  I send GET HTTP request to "http://localhost:9090/ngsi-ld/v1/entities/urn:ngsi-ld:Building:store001"
      Then  I receive a HTTP "200" response code from Scorpio with the body equal to "response601-05.json"


#
#   Request 6
#     Note: the body response is quite different from what expected. In particular:
#           - the attribute "@context" is at the beginning of the entity and not at the end as expected
#           - the attribute "category" is of a wrong type and misplaced.
#           - in the file "response601_06" the first entity is as provided by Scorpio while the second entity
#             is left as expected in the tutorial to let understand the differences to make easier the correct the tutorial.
#     Note: the request itself in the tutorial is wrong as the url appears twice.
#
    Scenario: [6] OBTAIN ENTITY DATA BY TYPE
      When   I set the "Link" header with the value '<https://smartdatamodels.org/context.jsonld>; rel="http://www.w3.org/ns/json-ld#context"; type="application/ld+json"'
      And    I set the "Accept" header with the value "application/ld+json"
      And    I set the url to "http://localhost:9090/ngsi-ld/v1/entities"
      And    I set a parameter with the value equal to "type=Building"
      And    I set a parameter with the value equal to "options=keyValues"
      And    I send a GET HTTP request to that url
      Then   I receive a HTTP "200" response code from Scorpio with the body equal to "response601-06.json"


#
#   Request 7
#     Note: the body response is quite different from what expected. In particular:
#           - the attribute "@context" is at the beginning of the entity and not at the end as expected
#           - the attribute "category" is of a wrong type and misplaced.
#           The file "response601_07" is updated as provided by Scorpio to let understand how to correct the tutorial.
#
    Scenario: [7] FILTER CONTEXT DATA BY COMPARING THE VALUES OF AN ATTRIBUTE
      When   I set the "Link" header with the value '<https://smartdatamodels.org/context.jsonld>; rel="http://www.w3.org/ns/json-ld#context"; type="application/ld+json"'
      And    I set the "Accept" header with the value "application/ld+json"
      And    I set the url to "http://localhost:9090/ngsi-ld/v1/entities"
      And    I set a parameter with the value equal to "type=Building"
      And    I set a parameter with the value equal to "q=name==%22Checkpoint%20Markt%22"
      And    I set a parameter with the value equal to "options=keyValues"
      And    I send a GET HTTP request to that url
      Then   I receive a HTTP "200" response code from Scorpio with the body equal to "response601-07.json"


#
#   Request 8
#     Note: the body response is quite different from what expected. In particular:
#           - the attribute "@context" is at the beginning of the entity and not at the end as expected
#           - the attribute "category" is of a wrong type and misplaced.
#           The file "response601_08" is left unchanged.
#
    Scenario: [8] FILTER CONTEXT DATA BY COMPARING THE VALUES OF AN ATTRIBUTE IN AN ARRAY
      When   I set the "Link" header with the value '<https://smartdatamodels.org/context.jsonld>; rel="http://www.w3.org/ns/json-ld#context"; type="application/ld+json"'
      And    I set the "Accept" header with the value "application/ld+json"
      And    I set the url to "http://localhost:9090/ngsi-ld/v1/entities"
      And    I set a parameter with the value equal to "type=Building"
      And    I set a parameter with the value equal to "q=category==%22commercial%22,%22office%22"
      And    I set a parameter with the value equal to "options=keyValues"
      And    I send a GET HTTP request to that url
      Then   I receive a HTTP "200" response code from Scorpio with the body equal to "response601-08.json"


#
#   Request 9
#     Note: the body response is quite different from what expected. In particular:
#           - the attribute "@context" is at the beginning of the entity and not at the end as expected
#           - the attribute "category" is of a wrong type and misplaced.
#           The file "response601_09" is left unchanged.
#
    Scenario: [9] FILTER CONTEXT DATA BY COMPARING THE VALUES OF A SUB-ATTRIBUTE
      When   I set the "Link" header with the value '<https://smartdatamodels.org/context.jsonld>; rel="http://www.w3.org/ns/json-ld#context"; type="application/ld+json"'
      And    I set the "Accept" header with the value "application/ld+json"
      And    I set the url to "http://localhost:9090/ngsi-ld/v1/entities"
      And    I set a parameter with the value equal to "type=Building"
      And    I set a parameter with the value equal to "q=address[addressLocality]==%22Kreuzberg%22'"
      And    I set a parameter with the value equal to "options=keyValues"
      And    I send a GET HTTP request to that url
      Then   I receive a HTTP "200" response code from Scorpio with the body equal to "response601-09.json"


#
#   Request 10
#     Note: the body response is quite different from what expected. In particular:
#           - the attribute "@context" is at the beginning of the entity and not at the end as expected
#           - the attribute "category" is of a wrong type and misplaced.
#           The file "response601_10" is left unchanged.
#
    Scenario: [10] FILTER CONTEXT DATA BY QUERYING METADATA
      When   I set the "Link" header with the value '<https://smartdatamodels.org/context.jsonld>; rel="http://www.w3.org/ns/json-ld#context"; type="application/ld+json"'
      And    I set the "Accept" header with the value "application/json"
      And    I set the url to "http://localhost:9090/ngsi-ld/v1/entities"
      And    I set a parameter with the value equal to "type=Building"
      And    I set a parameter with the value equal to "q=address.verified==true"
      And    I set a parameter with the value equal to "options=keyValues"
      And    I send a GET HTTP request to that url
      Then   I receive a HTTP "200" response code from Scorpio with the body equal to "response601-10.json"


#
#   Request 11
#     Note: the body response is quite different from what expected. In particular:
#           - the attribute "@context" is at the beginning of the entity and not at the end as expected
#           - the attribute "category" is of a wrong type and misplaced.
#           The file "response601_11" is left unchanged.
#
    Scenario: [11] FILTER CONTEXT DATA BY COMPARING THE VALUES OF A GEO:JSON ATTRIBUTE
      When   I set the "Link" header with the value '<https://smartdatamodels.org/context.jsonld>; rel="http://www.w3.org/ns/json-ld#context"; type="application/ld+json"'
      And    I set the "Accept" header with the value "application/json"
      And    I set the url to "http://localhost:9090/ngsi-ld/v1/entities"
      And    I set a parameter with the value equal to "type=Building"
      And    I set a parameter with the value equal to "geometry=Point"
      And    I set a parameter with the value equal to "coordinates=[13.3777,52.5162]"
      And    I set a parameter with the value equal to "georel=near;maxDistance==2000"
      And    I set a parameter with the value equal to "options=keyValues"
      And    I send a GET HTTP request to that url
      Then   I receive a HTTP "200" response code from Scorpio with the body equal to "response601-11.json"
