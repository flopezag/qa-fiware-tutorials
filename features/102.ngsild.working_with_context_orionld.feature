Feature: test tutorial 102 NGSI-LD: Working with Context feature (Orion-LD)

  This is the feature file of the FIWARE Step by Step tutorial for NGSI-LD
  url: https://ngsi-ld-tutorials.readthedocs.io/en/latest/working-with-%40context.html
  git-clone: https://github.com/FIWARE/tutorials.Getting-Started.git
  git-directory: /tmp/tutorials.Getting-Started
  shell-commands: git checkout NGSI-LD ; ./services orion
  clean-shell-commands: ./services stop

  Background:
    Given I set the tutorial 102 NGSI-LD

# Once the services have started up, and before interacting with the context broker itself, it is useful to check
# that the necessary prerequisites are in place.
  Scenario Outline: 00 - Check the files are in place.
    When I prepare a GET HTTP request to "http://localhost:3004/<file>"
    And   I perform the query request
    Then  I receive a HTTP "200" response code
    Examples:
       | file                     |
       | ngsi-context.jsonld      |
       | json-context.jsonld      |
       | alternate-context.jsonld |

  # Request 1
  Scenario: 01 - Checking the Service Health
    When I prepare a GET HTTP request to "http://localhost:1026/version"
    And   I perform the query request
    Then  I receive a HTTP "200" response code

  # Request 2: Create data entities
  Scenario: 02 - Create a new data entity
    When  I prepare a POST HTTP request to "http://localhost:1026/ngsi-ld/v1/entities/"
    And   I set header Content-type to application/ld+json
    And   I set the body request as described in 102.ld.02.request.json
    And   I perform the request
    Then  I receive a HTTP "201" response code
    And   I have the header "Location" with value "/ngsi-ld/v1/entities/urn:ngsi-ld:Building:farm001"

  # Request 3: New data entities
  Scenario: 03 - Each subsequent entity must have a unique id for the given type
    When  I prepare a POST HTTP request to "http://localhost:1026/ngsi-ld/v1/entities/"
    And   I set header Content-type to application/json
    And   I set header Link to <http://context/ngsi-context.jsonld>; rel="http://www.w3.org/ns/json-ld#context"; type="application/ld+json"
    And   I set the body request as described in 102.ld.03.request.json
    And   I perform the request
    Then  I receive a HTTP "201" response code
    And   I have the header "Location" with value "/ngsi-ld/v1/entities/urn:ngsi-ld:Building:barn002"

  # Request 4:
  Scenario: 04 - Obtaining Entity data by FQN Type
    When  I prepare a GET HTTP request to "http://localhost:1026/ngsi-ld/v1/entities?type=https://uri.fiware.org/ns/dataModels%23Building"
    And   I set header Accept to application/ld+json
    And   I perform the query request
    Then  I receive a HTTP "200" status code from Broker with the body "102.ld.04.response.json" and exclusions "response102-04.excludes"

  # Request 5:
  Scenario: 05 - Obtaining Entity data by ID
    When  I prepare a GET HTTP request to "http://localhost:1026/ngsi-ld/v1/entities/urn:ngsi-ld:Building:farm001"
    And   I set header Accept to application/ld+json
    And   I set header Link to <http://context/ngsi-context.jsonld>; rel="http://www.w3.org/ns/json-ld#context"; type="application/ld+json"
    And   I perform the query request
    Then  I receive a HTTP "200" status code from Broker with the body "102.ld.05.response.json" and exclusions "response102-05.excludes"

  # Requests 6 to 12: Several different queries with data
  Scenario Outline: 06-12 - Several queries
    When  I prepare a GET HTTP request to "http://localhost:1026/ngsi-ld/v1/entities"
    And   I set header Accept to <accept>
    And   I set header Link to <Link>
    And   I set the body request as described in <body_request>
    And   I perform the query request
    Then  I receive a HTTP "200" status code from Broker with the body "<body_response>" and exclusions "<excludes_file>"
    Examples:
       | body_request         | accept              | body_response           | excludes_file           | Link                                                                                                                          |
       | 102.ld.06.query.json | application/ld+json | 102.ld.06.response.json | response102-04.excludes | <http://context/ngsi-context.jsonld>; rel="http://www.w3.org/ns/json-ld#context"; type="application/ld+json"                  |
       | 102.ld.07.query.json | application/ld+json | 102.ld.07.response.json | response102-07.excludes | <http://context/json-context.jsonld>; rel="http://www.w3.org/ns/json-ld#context"; type="application/ld+json"                  |
       | 102.ld.08.query.json | application/ld+json | 102.ld.08.response.json | response102-07.excludes | <http://context/alternate-context.jsonld>; rel="http://www.w3.org/ns/json-ld#context"; type="application/ld+json"             |
       | 102.ld.09.query.json | application/ld+json | 102.ld.09.response.json | response102-07.excludes | <http://context/ngsi-context.jsonld>; rel="http://www.w3.org/ns/json-ld#context"; type="application/ld+json"                  |
       | 102.ld.10.query.json | application/ld+json | 102.ld.10.response.json | response102-04.excludes | <http://context/json-context.jsonld>; rel="http://www.w3.org/ns/json-ld#context"; type="application/ld+json"                  |
       | 102.ld.11.query.json | application/ld+json | 102.ld.11.response.json | response102-04.excludes | <http://context/json-context.jsonld>; rel="http://www.w3.org/ns/json-ld#context"; type="application/ld+json"                  |
       | 102.ld.12.query.json | application/json    | 102.ld.12.response.json | response102-07.excludes | <http://context/json-context.jsonld>; rel="http://www.w3.org/ns/json-ld#context"; type="application/ld+json" |
