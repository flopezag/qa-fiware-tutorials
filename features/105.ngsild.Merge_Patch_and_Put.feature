Feature: Test tutorial 105.NGSI-LD.Merge Patch and Put (Orion-LD)
  This is feature file of the FIWARE step by step tutorial for Merge Patch and Put (Orion-LD)
  url: https://ngsi-ld-tutorials.readthedocs.io/en/latest/merge-patch.html
  git-clone: https://github.com/FIWARE/tutorials.Merge-Patch-Put.git
  git-directory: /tmp/tutorials.Concise-Format
  shell-commands: git checkout NGSI-LD ; ./services create; ./services orion
  clean-shell-commands: ./services stop

Background:
  Given I set the tutorial 105.NGSI-LD

Scenario: 01 - Create a New Data Entity
  When  I set the "Content-Type" header with the value "application/json"
  And   I set the "Link" header with the value "<http://context/user-context.jsonld>; rel=\"http://www.w3.org/ns/json-ld#context\"; type=\"application/ld+json\""
  And   I set the url to "http://localhost:1026/ngsi-ld/v1/entities"
  And   I set the request body described in file "request104ld-01.json"
  And   I send a POST HTTP request to that url
  Then  I receive a HTTP "201" response code

Scenario: 02 - Retrieve a Specific Temperature Sensor Entity
  When  I set the "Link" header with the value "<http://context/user-context.jsonld>; rel=\"http://www.w3.org/ns/json-ld#context\"; type=\"application/ld+json\""
  And   I set the url to "http://localhost:1026/ngsi-ld/v1/entities/urn:ngsi-ld:TemperatureSensor:001"
  And   I send a GET HTTP request to that url
  Then  I receive a HTTP "200" response code from Orion-LD with the body equal to "response104ld-02.json"

Scenario: 03 - Preflight Request for Entities
  When  I set the "Accept" header with the value "application/json"
  And   I set the url to "http://localhost:1026/ngsi-ld/v1/entities/"
  And   I send an OPTIONS HTTP request to that url
  Then  I receive a HTTP "200" response code from Orion-LD

Scenario: 04 - Preflight Request for Specific Entity
  When  I set the "Accept" header with the value "application/json"
  And   I set the url to "http://localhost:1026/ngsi-ld/v1/entities/urn:ngsi-ld:City:001"
  And   I send an OPTIONS HTTP request to that url
  Then  I receive a HTTP "200" response code from Orion-LD

Scenario: 05 - Preflight Request for Entity Attributes
  When  I set the "Accept" header with the value "application/json"
  And   I set the url to "http://localhost:1026/ngsi-ld/v1/entities/urn:ngsi-ld:City:001/attrs"
  And   I send an OPTIONS HTTP request to that url
  Then  I receive a HTTP "200" response code from Orion-LD

Scenario: 06 - Preflight Request for Specific Attribute
  When  I set the "Accept" header with the value "application/json"
  And   I set the url to "http://localhost:1026/ngsi-ld/v1/entities/urn:ngsi-ld:City:001/attrs/temperature"
  And   I send an OPTIONS HTTP request to that url
  Then  I receive a HTTP "200" response code from Orion-LD

Scenario: 07 - Retrieve City Entity
  When  I set the "Accept" header with the value "application/json"
  And   I set the url to "http://localhost:1026/ngsi-ld/v1/entities/urn:ngsi-ld:City:001"
  And   I send a GET HTTP request to that url
  Then  I receive a HTTP "200" response code from Orion-LD with the body equal to "response1.json"

Scenario: 08 - Update City Temperature
  When  I set the "Content-Type" header with the value "application/json"
  And   I set the url to "http://localhost:1026/ngsi-ld/v1/entities/urn:ngsi-ld:City:001"
  And   I set the payload equal to '{"temperature": {"type": "Property", "value": 20}}'
  And   I send a PATCH HTTP request to that url
  Then  I receive a HTTP "204" response code from Orion-LD

Scenario: 09 - Retrieve Updated City Entity
  When  I set the "Accept" header with the value "application/json"
  And   I set the url to "http://localhost:1026/ngsi-ld/v1/entities/urn:ngsi-ld:City:001"
  And   I send a GET HTTP request to that url
  Then  I receive a HTTP "200" response code from Orion-LD with the body equal to "response2.json"

Scenario: 10 - Update City Attributes
  When  I set the "Content-Type" header with the value "application/json"
  And   I set the url to "http://localhost:1026/ngsi-ld/v1/entities/urn:ngsi-ld:City:002"
  And   I set the payload equal to '{"humidity": 80, "temperature": "urn:ngsi-ld:null"}'
  And   I send a PATCH HTTP request to that url
  Then  I receive a HTTP "204" response code from Orion-LD

Scenario: 11 - Retrieve Updated City Attributes
  When  I set the "Accept" header with the value "application/json"
  And   I set the url to "http://localhost:1026/ngsi-ld/v1/entities/urn:ngsi-ld:City:002"
  And   I send a GET HTTP request to that url
  Then  I receive a HTTP "200" response code from Orion-LD with the body equal to "response3.json"