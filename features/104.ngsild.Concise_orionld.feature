Feature: Test tutorial 104.NGSI-LD.Concise NGSI-LD Payloads (Orion-LD)
  This is feature file of the FIWARE step by step tutorial for Concise NGSI-LD Payloads (Orion-LD)
  url: https://ngsi-ld-tutorials.readthedocs.io/en/latest/concise.html
  git-clone: https://github.com/FIWARE/tutorials.Concise-Format.git
  git-directory: /tmp/tutorials.Concise-Format
  shell-commands: git checkout NGSI-LD ; ./services create; ./services orion
  clean-shell-commands: ./services stop

  Background:
    Given I set the tutorial 104.NGSI-LD

    Scenario: 01 - Create a New Data Entity
      When  I set the "Content-Type" header with the value "application/json"
      And   I set the "Link" header with the value "<http://context/user-context.jsonld>; rel="http://www.w3.org/ns/json-ld#context"; type="application/ld+json""
      And   I set the url to "http://localhost:1026/ngsi-ld/v1/entities"
      And   I set the request body described in file "request104ld-01.json"
      And   I send a POST HTTP request to that url
      Then  I receive a HTTP "201" response code

    Scenario: 02 - Retrieve a Specific Temperature Sensor Entity
      When  I set the "Link" header with the value "<http://context/user-context.jsonld>; rel=\"http://www.w3.org/ns/json-ld#context\"; type=\"application/ld+json\""
      And   I set the url to "http://localhost:1026/ngsi-ld/v1/entities/urn:ngsi-ld:TemperatureSensor:001"
      And   I send a GET HTTP request to that url
      Then  I receive a HTTP "200" response code from Orion-LD with the body equal to "response104ld-02.json"

    Scenario: 03 - Create New Attributes
      When  I set the "Content-Type" header with the value "application/json"
      And   I set the "Link" header with the value "<http://context/user-context.jsonld>; rel="http://www.w3.org/ns/json-ld#context"; type="application/ld+json""
      And   I set the url to "http://localhost:1026/ngsi-ld/v1/entities/urn:ngsi-ld:TemperatureSensor:001/attrs"
      And   I set the request body described in file "request104ld-03.json"
      And   I send a POST HTTP request to that url
      Then  I receive a HTTP "204" response code

    Scenario: 04 - Retrieve a Specific Temperature Sensor Entity
      When  I set the "Link" header with the value "<http://context/user-context.jsonld>; rel=\"http://www.w3.org/ns/json-ld#context\"; type=\"application/ld+json\""
      And   I set the url to "http://localhost:1026/ngsi-ld/v1/entities/urn:ngsi-ld:TemperatureSensor:001"
      And   I send a GET HTTP request to that url
      Then  I receive a HTTP "200" response code from Orion-LD with the body equal to "response104ld-04.json"

    Scenario: 05 - Batch Create New Data Entities or Attributes
      When  I set the "Content-Type" header with the value "application/json"
      And   I set the "Accept" header with the value "application/ld+json"
      And   I set the "Link" header with the value "<http://context/user-context.jsonld>; rel="http://www.w3.org/ns/json-ld#context"; type="application/ld+json""
      And   I set the url to "http://localhost:1026/ngsi-ld/v1/entityOperations/create"
      And   I set the request body described in file "request104ld-05.json"
      And   I send a POST HTTP request to that url
      Then  I receive a HTTP "201" response code from Orion-LD with the body equal to "response104ld-05.json"

    Scenario: 06 - Batch Create/Overwrite New Data Entities
      When  I set the "Content-Type" header with the value "application/json"
      And   I set the "Link" header with the value "<http://context/user-context.jsonld>; rel=\"http://www.w3.org/ns/json-ld#context\"; type=\"application/ld+json\""
      And   I set the "Accept" header with the value "application/ld+json"
      And   I set the url to "http://localhost:1026/ngsi-ld/v1/entityOperations/upsert"
      And   I set the request body described in file "request104ld-06.json"
      And   I send a POST HTTP request to that url
      Then  I receive a HTTP "204" response code

    Scenario: 07 - Read a Data Entity (concise)
      When  I set the "Link" header with the value "<http://context/user-context.jsonld>; rel="http://www.w3.org/ns/json-ld#context"; type="application/ld+json""
      And   I set the url to "http://localhost:1026/ngsi-ld/v1/entities/urn:ngsi-ld:TemperatureSensor:001"
      And   I set the params equal to "options=concise,sysAttrs"
      And   I send a GET HTTP request to that url
      Then  I receive a HTTP "200" response code from Orion-LD with the body equal to "response104ld-07.json"

    Scenario: 08 - Read an Attribute from a Data Entity
      When  I set the "Link" header with the value "<http://context/user-context.jsonld>; rel=\"http://www.w3.org/ns/json-ld#context\"; type=\"application/ld+json\""
      And   I set the url to "http://localhost:1026/ngsi-ld/v1/entities/urn:ngsi-ld:TemperatureSensor:001"
      And   I set the params equal to "attrs=temperature"
      And   I send a GET HTTP request to that url
      Then  I receive a HTTP "200" response code from Orion-LD with the body equal to "response104ld-08.json"

    Scenario: 09 - Read a Data Entity (concise)
      When  I set the "Link" header with the value "<http://context/user-context.jsonld>; rel=\"http://www.w3.org/ns/json-ld#context\"; type=\"application/ld+json\""
      And   I set the "Accept" header with the value "application/json"
      And   I set the url to "http://localhost:1026/ngsi-ld/v1/entities/urn:ngsi-ld:TemperatureSensor:001"
      And   I set the params equal to "options=concise"
      And   I send a GET HTTP request to that url
      Then  I receive a HTTP "200" response code from Orion-LD with the body equal to "response104ld-09.json"

    Scenario: 10 - Retrieve Concise Representation of Selected Attributes of a Temperature Sensor Entity
      When  I set the "Link" header with the value "<http://context/user-context.jsonld>; rel=\"http://www.w3.org/ns/json-ld#context\"; type=\"application/ld+json\""
      And   I set the "Accept" header with the value "application/json"
      And   I set the url to "http://localhost:1026/ngsi-ld/v1/entities/urn:ngsi-ld:TemperatureSensor:001"
      And   I set the params equal to "options=concise"
      And   I set the params equal to "attrs=category,temperature"
      And   I send a GET HTTP request to that url
      Then  I receive a HTTP "200" response code from Orion-LD with the body equal to "response104ld-10.json"

    Scenario: 11 - List all Data Entities (concise)
      When  I set the "Link" header with the value "<http://context/user-context.jsonld>; rel="http://www.w3.org/ns/json-ld#context"; type="application/ld+json""
      And   I set the url to "http://localhost:1026/ngsi-ld/v1/entities/"
      And   I set the params equal to "type=TemperatureSensor"
      And   I set the params equal to "options=concise"
      And   I send a GET HTTP request to that url
      Then  I receive a HTTP "200" response code from Orion-LD with the body equal to "response104ld-11.json"

    Scenario: 12 - Retrieve Concise Representation of Temperature Sensors with Specific Attributes
      When  I set the "Link" header with the value "<http://context/user-context.jsonld>; rel=\"http://www.w3.org/ns/json-ld#context\"; type=\"application/ld+json\""
      And   I set the "Accept" header with the value "application/json"
      And   I set the url to "http://localhost:1026/ngsi-ld/v1/entities/"
      And   I set the params equal to "type=TemperatureSensor"
      And   I set the params equal to "options=concise"
      And   I set the params equal to "attrs=temperature"
      And   I send a GET HTTP request to that url
      Then  I receive a HTTP "200" response code from Orion-LD with the body equal to "response104ld-12.json"

    Scenario: 13 - Filter Data Entities by ID
      When  I set the "Link" header with the value "<http://context/user-context.jsonld>; rel="http://www.w3.org/ns/json-ld#context"; type="application/ld+json""
      And   I set the url to "http://localhost:1026/ngsi-ld/v1/entities/"
      And   I set the params equal to "id=urn:ngsi-ld:TemperatureSensor:001,urn:ngsi-ld:TemperatureSensor:002"
      And   I set the params equal to "attrs=temperature"
      And   I set the params equal to "options=concise"
      And   I send a GET HTTP request to that url
      Then  I receive a HTTP "200" response code from Orion-LD with the body equal to "response104ld-13.json"

    Scenario: 14 - Returning data as GeoJSON
      When  I set the "Link" header with the value "<http://context/user-context.jsonld>; rel=\"http://www.w3.org/ns/json-ld#context\"; type=\"application/ld+json\""
      And   I set the "Accept" header with the value "application/geo+json"
      And   I set the "NGSILD-Tenant" header with the value "openiot"
      And   I set the url to "http://localhost:1026/ngsi-ld/v1/entities/"
      And   I set the params equal to "id=urn:ngsi-ld:Animal:pig010,urn:ngsi-ld:Animal:pig006"
      And   I set the params equal to "options=concise"
      And   I send a GET HTTP request to that url
      Then  I receive a HTTP "200" response code from Orion-LD with the body equal to "response104ld-14.json"

    # curl: (52) Empty reply from server --> crashed Orion-LD
    Scenario: 15 - Overwrite the value of an Attribute
      When  I set the "Content-Type" header with the value "application/json"
      And   I set the "Link" header with the value "<http://context/user-context.jsonld>; rel="http://www.w3.org/ns/json-ld#context"; type="application/ld+json""
      And   I set the url to "http://localhost:1026/ngsi-ld/v1/entities/urn:ngsi-ld:TemperatureSensor:001/attrs/category"
      And   I set the request body described in file "request104ld-15.json"
      And   I send a PATCH HTTP request to that url
      Then  I receive a HTTP "201" response code from Orion-LD with the body equal to "response104ld-15.json"

    Scenario: 16 - Update Attributes of a Temperature Sensor Entity
      When  I set the "Content-Type" header with the value "application/json"
      And   I set the "Link" header with the value "<http://context/user-context.jsonld>; rel=\"http://www.w3.org/ns/json-ld#context\"; type=\"application/ld+json\""
      And   I set the url to "http://localhost:1026/ngsi-ld/v1/entities/urn:ngsi-ld:TemperatureSensor:001/attrs"
      And   I set the request body described in file "request104ld-16.json"
      And   I send a PATCH HTTP request to that url
      Then  I receive a HTTP "201" response code from Orion-LD with the body equal to "response104ld-16.json"

    Scenario: 17 - Batch Update Attributes of Multiple Data Entities
      When  I set the "Content-Type" header with the value "application/json"
      And   I set the "Link" header with the value "<http://context/user-context.jsonld>; rel="http://www.w3.org/ns/json-ld#context"; type="application/ld+json""
      And   I set the url to "http://localhost:1026/ngsi-ld/v1/entityOperations/upsert?options=update"
      And   I set the request body described in file "request104ld-17.json"
      And   I send a POST HTTP request to that url
      Then  I receive a HTTP "201" response code from Orion-LD with the body equal to "response104ld-17.json"

    Scenario: 18 - Batch Replace Entity Data
      When  I set the "Content-Type" header with the value "application/json"
      And   I set the "Link" header with the value "<http://context/user-context.jsonld>; rel="http://www.w3.org/ns/json-ld#context"; type="application/ld+json""
      And   I set the url to "http://localhost:1026/ngsi-ld/v1/entityOperations/update?options=replace"
      And   I set the request body described in file "request104ld-18.json"
      And   I send a POST HTTP request to that url
      Then  I receive a HTTP "201" response code from Orion-LD with the body equal to "response104ld-18.json"

    Scenario: 19 - Setting up concise Subscriptions with concise notifications
      When  I set the "Content-Type" header with the value "application/ld+json"
      And   I set the "NGSILD-Tenant" header with the value "openiot"
      And   I set the url to "http://localhost:1026/ngsi-ld/v1/subscriptions"
      And   I set the request body described in file "request104ld-19.json"
      And   I send a POST HTTP request to that url
      Then  I receive a HTTP "201" response code from Orion-LD with the body equal to "response104ld-19.json"

    Scenario: 20 - Create a Subscription for Low Feedstock Notifications
      When  I set the "Content-Type" header with the value "application/ld+json"
      And   I set the "NGSILD-Tenant" header with the value "openiot"
      And   I set the url to "http://localhost:1026/ngsi-ld/v1/subscriptions"
      And   I set the request body described in file "request104ld-20.json"
      And   I send a POST HTTP request to that url
      Then  I receive a HTTP "201" response code from Orion-LD with the body equal to "response104ld-20.json"
