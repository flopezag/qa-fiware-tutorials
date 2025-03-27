Feature: Test tutorial 103.NGSI-LD.CRUD Operations (Scorpio)
  This is feature file of the FIWARE step by step tutorial for CRUD Operations (Scorpio)
  url: https://ngsi-ld-tutorials.readthedocs.io/en/latest/ngsi-ld-operations.html
  git-clone: https://github.com/FIWARE/tutorials.CRUD-Operations.git
  git-directory: /tmp/tutorials.CRUD-Operations
  shell-commands: git checkout NGSI-LD ; ./services create; ./services scorpio
  clean-shell-commands: ./services stop

  Background:
    Given I set the tutorial 103.NGSI-LD

    Scenario: 01 - Create a New Data Entity
      When    I set the "Content-Type" header with the value "application/json"
      And     I set the "Link" header with the value "<http://context/user-context.jsonld>; rel="http://www.w3.org/ns/json-ld#context"; type="application/ld+json""
      And     I set the url to "http://localhost:1026/ngsi-ld/v1/entities"
      And     I set the request body described in file "request103ld-01.json"
      And     I send a POST HTTP request to that url
      Then    I receive a HTTP "201" response code

    Scenario: 02 - Check if the Entity Exists
      When    I set the "Link" header with the value "<http://context/user-context.jsonld>; rel="http://www.w3.org/ns/json-ld#context"; type="application/ld+json""
      And     I set the url to "http://localhost:1026/ngsi-ld/v1/entities/urn:ngsi-ld:TemperatureSensor:001"
      And     I send a GET HTTP request to that url
      Then    I receive a HTTP "200" response code

    Scenario: 03 - Create New Attributes
      When    I set the "Content-Type" header with the value "application/json"
      And     I set the "Link" header with the value "<http://context/user-context.jsonld>; rel="http://www.w3.org/ns/json-ld#context"; type="application/ld+json""
      And     I set the url to "http://localhost:1026/ngsi-ld/v1/entities/urn:ngsi-ld:TemperatureSensor:001/attrs"
      And     I set the request body described in file "request103ld-03.json"
      And     I send a POST HTTP request to that url
      Then    I receive a HTTP "204" response code

    Scenario: 04 - Read a Data Entity (verbose)
      When    I set the "Link" header with the value "<http://context/user-context.jsonld>; rel="http://www.w3.org/ns/json-ld#context"; type="application/ld+json""
      And     I set the url to "http://localhost:1026/ngsi-ld/v1/entities/urn:ngsi-ld:TemperatureSensor:001"
      And     I set the params equal to "options=sysAttrs"
      And     I send a GET HTTP request to that url
      Then    I receive a HTTP "200" response code

    Scenario: 05 - Batch Create New Data Entities or Attributes
      When   I set the "Content-Type" header with the value "application/json"
      And    I set the "Link" header with the value "<http://context/user-context.jsonld>; rel="http://www.w3.org/ns/json-ld#context"; type="application/ld+json""
      And    I set the "Accept" header with the value "application/ld+json"
      And    I set the url to "http://localhost:1026/ngsi-ld/v1/entityOperations/create"
      And    I set the request body described in file "request103ld-05.json"
      And    I send a POST HTTP request to that url
      Then   I receive a HTTP "201" response code from Scorpio with the body equal to "response103ld-05.json"

    Scenario: 06 - Batch Create/Overwrite New Data Entities
      When   I set the "Content-Type" header with the value "application/json"
      And    I set the "Link" header with the value "<http://context/user-context.jsonld>; rel="http://www.w3.org/ns/json-ld#context"; type="application/ld+json""
      And    I set the "Accept" header with the value "application/ld+json"
      And    I set the url to "http://localhost:1026/ngsi-ld/v1/entityOperations/upsert"
      And    I set the request body described in file "request103ld-06.json"
      And    I send a POST HTTP request to that url
      Then   I receive a HTTP "204" response code

    Scenario: 07 - Read a Data Entity (verbose)
      When   I set the "Link" header with the value "<http://context/user-context.jsonld>; rel="http://www.w3.org/ns/json-ld#context"; type="application/ld+json""
      And    I set the url to "http://localhost:1026/ngsi-ld/v1/entities/urn:ngsi-ld:TemperatureSensor:001"
      And    I set the params equal to "options=sysAttrs"
      And    I send a GET HTTP request to that url
      Then   I receive a HTTP "200" status code from Scorpio with the body "response103ld-07.json" and exclusions "response103ld-07.excludes"

    Scenario: 08 - Read an Attribute from a Data Entity
      When   I set the "Link" header with the value "<http://context/user-context.jsonld>; rel="http://www.w3.org/ns/json-ld#context"; type="application/ld+json""
      And    I set the url to "http://localhost:1026/ngsi-ld/v1/entities/urn:ngsi-ld:TemperatureSensor:001"
      And    I set the params equal to "attrs=temperature"
      And    I send a GET HTTP request to that url
      Then   I receive a HTTP "200" response code from Scorpio with the body equal to "response103ld-08.json"

    Scenario: 09 - Read a Data Entity (key-value pairs)
      When   I set the "Link" header with the value "<http://context/user-context.jsonld>; rel="http://www.w3.org/ns/json-ld#context"; type="application/ld+json""
      And    I set the url to "http://localhost:1026/ngsi-ld/v1/entities/urn:ngsi-ld:TemperatureSensor:001"
      And    I set the "Accept" header with the value "application/json"
      And    I set the params equal to "options=keyValues"
      And    I send a GET HTTP request to that url
      Then   I receive a HTTP "200" response code from Scorpio with the body equal to "response103ld-09.json"

    Scenario: 10 - Read Multiple attributes values from a Data Entity
      When   I set the "Link" header with the value "<http://context/user-context.jsonld>; rel="http://www.w3.org/ns/json-ld#context"; type="application/ld+json""
      And    I set the "Accept" header with the value "application/json"
      And    I set the url to "http://localhost:1026/ngsi-ld/v1/entities/urn:ngsi-ld:TemperatureSensor:001"
      And    I set the params equal to "options=keyValues"
      And    I set the params equal to "attrs=category,temperature"
      And    I send a GET HTTP request to that url
      Then   I receive a HTTP "200" response code from Scorpio with the body equal to "response103ld-10.json"

    Scenario: 11 - List all Data Entities (verbose)
      When   I set the "Link" header with the value "<http://context/user-context.jsonld>; rel="http://www.w3.org/ns/json-ld#context"; type="application/ld+json""
      And    I set the url to "http://localhost:1026/ngsi-ld/v1/entities/"
      And    I set the params equal to "type=TemperatureSensor"
      And    I send a GET HTTP request to that url
      Then   I receive a HTTP "200" response code from Scorpio with the body equal to "response103ld-11.json"

    Scenario: 12 - List all Data Entities (key-value pairs)
      When   I set the "Link" header with the value "<http://context/user-context.jsonld>; rel="http://www.w3.org/ns/json-ld#context"; type="application/ld+json""
      And    I set the url to "http://localhost:1026/ngsi-ld/v1/entities/"
      And    I set the "Accept" header with the value "application/json"
      And    I set the params equal to "type=TemperatureSensor"
      And    I set the params equal to "options=keyValues"
      And    I set the params equal to "attrs=temperature"
      And    I send a GET HTTP request to that url
      Then   I receive a HTTP "200" response code from Scorpio with the body equal to "response103ld-12.json"

    Scenario: 13 - Filter Data Entities by ID
      When   I set the "Link" header with the value "<http://context/user-context.jsonld>; rel="http://www.w3.org/ns/json-ld#context"; type="application/ld+json""
      And    I set the "Accept" header with the value "application/json"
      And    I set the url to "http://localhost:1026/ngsi-ld/v1/entities/"
      And    I set the params equal to "id=urn:ngsi-ld:TemperatureSensor:001,urn:ngsi-ld:TemperatureSensor:002"
      And    I set the params equal to "options=keyValues"
      And    I set the params equal to "attrs=temperature"
      And    I send a GET HTTP request to that url
      Then   I receive a HTTP "200" response code from Scorpio with the body equal to "response103ld-13.json"

    Scenario: 14 - Overwrite the value of an Attribute value
      When   I set the "Content-Type" header with the value "application/json"
      And    I set the "Link" header with the value "<http://context/user-context.jsonld>; rel="http://www.w3.org/ns/json-ld#context"; type="application/ld+json""
      And    I set the url to "http://localhost:1026/ngsi-ld/v1/entities/urn:ngsi-ld:TemperatureSensor:001/attrs/category"
      And    I set the request body described in file "request103ld-14.json"
      And    I send a PATCH HTTP request to that url
      Then   I receive a HTTP "204" response code

    Scenario: 15 - Overwrite Multiple Attributes of a Data Entity
      When   I set the "Content-Type" header with the value "application/json"
      And    I set the "Link" header with the value "<http://context/user-context.jsonld>; rel="http://www.w3.org/ns/json-ld#context"; type="application/ld+json""
      And    I set the url to "http://localhost:1026/ngsi-ld/v1/entities/urn:ngsi-ld:TemperatureSensor:001/attrs"
      And    I set the request body described in file "request103ld-15.json"
      And    I send a PATCH HTTP request to that url
      Then   I receive a HTTP "204" response code

    Scenario: 16 - Batch Update Attributes of Multiple Data Entities
      When   I set the "Content-Type" header with the value "application/json"
      And    I set the "Link" header with the value "<http://context/user-context.jsonld>; rel="http://www.w3.org/ns/json-ld#context"; type="application/ld+json""
      And    I set the url to "http://localhost:1026/ngsi-ld/v1/entityOperations/upsert?options=update"
      And    I set the request body described in file "request103ld-16.json"
      And    I send a POST HTTP request to that url
      Then   I receive a HTTP "204" response code

    Scenario: 17 - Batch Replace Entity Data
      When   I set the "Content-Type" header with the value "application/json"
      And    I set the "Link" header with the value "<http://context/user-context.jsonld>; rel="http://www.w3.org/ns/json-ld#context"; type="application/ld+json""
      And    I set the url to "http://localhost:1026/ngsi-ld/v1/entityOperations/update?options=replace"
      And    I set the request body described in file "request103ld-17.json"
      And    I send a POST HTTP request to that url
      Then   I receive a HTTP "204" response code

    Scenario: 18 - Delete an Entity
      When   I set the url to "http://localhost:1026/ngsi-ld/v1/entities/urn:ngsi-ld:TemperatureSensor:004"
      And    I send a DELETE HTTP request to that url
      Then   I receive a HTTP "204" response code

    Scenario: 19 - Delete an Attribute from an Entity
      When   I set the "Link" header with the value "<http://context/user-context.jsonld>; rel="http://www.w3.org/ns/json-ld#context"; type="application/ld+json""
      And    I set the url to "http://localhost:1026/ngsi-ld/v1/entities/urn:ngsi-ld:TemperatureSensor:001/attrs/batteryLevel"
      And    I send a DELETE HTTP request to that url
      Then   I receive a HTTP "204" response code

    Scenario: 20 - Batch Delete Multiple Entities
      When   I set the "Content-Type" header with the value "application/json"
      And    I set the url to "http://localhost:1026/ngsi-ld/v1/entityOperations/delete"
      And    the body request described in file "request103ld-20.json"
      And    I send a POST HTTP request to that url
      Then   I receive a HTTP "204" response code

    Scenario: 21 - Find Existing Data Relationships
      When   I set the "Link" header with the value "<http://context/user-context.jsonld>; rel="http://www.w3.org/ns/json-ld#context"; type="application/ld+json""
      And    I set the url to "http://localhost:1026/ngsi-ld/v1/entities/?type=TemperatureSensor&limit=0&count=true&q=controlledAsset==%22urn:ngsi-ld:Building:barn002%22"
      And    I set the "Accept" header with the value "application/json"
      And    I send a GET HTTP request to that url
      Then   I receive a HTTP response with the following data in header and payload
      | Status-Code | NGSILD-Results-Count |
      | 200         | 1                    |
