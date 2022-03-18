Feature: Test tutorial 603.Traversing_Linked_Data (Orion)
  This is feature file of the FIWARE step by step tutorial for Traversing Linked Data (Orion)
  url: https://fiware-tutorials.readthedocs.io/en/latest/open-id-connect.html
  git-clone: https://github.com/FIWARE/tutorials.Working-with-Linked-Data.git
  git-directory: /tmp/tutorials.Working-with-Linked-Data
  shell-commands: ./services create; ./services orion
  clean-shell-commands: ./services stop

  Background:
    Given I set the tutorial 603

  Scenario: 01 - Retrieve a known store
    When   I set the "Content-Type" header with the value "application/json"
    And    I set the "Link" header with the value "<https://fiware.github.io/tutorials.Step-by-Step/tutorials-context.jsonld>; rel="http://www.w3.org/ns/json-ld#context"; type="application/ld+json""
    And    I set the url to "http://localhost:1026/ngsi-ld/v1/entities/urn:ngsi-ld:Building:store001"
    And    the params equal to "options=keyValues"
    And    I send a GET HTTP request to that url
    Then   I receive a HTTP "200" response code from Broker with the body "response603-01.json"

  Scenario: 02 - Access the furniture attribute of a known Building entity
    When   I set the "Content-Type" header with the value "application/json"
    And    I set the "Link" header with the value "<https://fiware.github.io/tutorials.Step-by-Step/tutorials-context.jsonld>; rel="http://www.w3.org/ns/json-ld#context"; type="application/ld+json""
    And    I set the url to "http://localhost:1026/ngsi-ld/v1/entities/urn:ngsi-ld:Building:store001"
    And    the params equal to "options=keyValues"
    And    the params equal to "attrs=furniture"
    And    I send a GET HTTP request to that url
    Then   I receive a HTTP "200" response code from Broker with the body "response603-02.json"

  Scenario: 03 - Retrieve stocked products from shelves
    When   I set the "Content-Type" header with the value "application/json"
    And    I set the "Link" header with the value "<https://fiware.github.io/tutorials.Step-by-Step/tutorials-context.jsonld>; rel="http://www.w3.org/ns/json-ld#context"; type="application/ld+json""
    And    I set the url to "http://localhost:1026/ngsi-ld/v1/entities"
    And    the params equal to "options=keyValues"
    And    the params equal to "attrs=stocks,numberOfItems"
    And    the params equal to "id=urn:ngsi-ld:Shelf:unit001,urn:ngsi-ld:Shelf:unit002,urn:ngsi-ld:Shelf:unit003"
    And    I send a GET HTTP request to that url
    Then   I receive a HTTP "200" response code from Broker with the body "response603-03.json"

  Scenario: 04 - Retrieve product details for selected shelves
    When   I set the "Content-Type" header with the value "application/json"
    And    I set the "Accept" header with the value "application/json"
    And    I set the "Link" header with the value "<https://fiware.github.io/tutorials.Step-by-Step/tutorials-context.jsonld>; rel="http://www.w3.org/ns/json-ld#context"; type="application/ld+json""
    And    I set the url to "http://localhost:1026/ngsi-ld/v1/entities"
    And    the params equal to "type=Product"
    And    the params equal to "options=keyValues"
    And    the params equal to "attrs=name,price"
    And    the params equal to "id=urn:ngsi-ld:Product:001,urn:ngsi-ld:Product:003,urn:ngsi-ld:Product:004"
    And    I send a GET HTTP request to that url
    Then   I receive a HTTP "200" response code from Broker with the body "response603-04.json"

  Scenario: 05 - Find a shelf stocking a product
    When   I set the "Content-Type" header with the value "application/json"
    And    I set the "Accept" header with the value "application/json"
    And    I set the "Link" header with the value "<https://fiware.github.io/tutorials.Step-by-Step/tutorials-context.jsonld>; rel="http://www.w3.org/ns/json-ld#context"; type="application/ld+json""
    And    I set the url to "http://localhost:1026/ngsi-ld/v1/entities"
    And    the params equal to "type=Shelf"
    And    the params equal to "options=keyValues"
    And    the params equal to "q=numberOfItems%3E0;locatedIn==%22urn:ngsi-ld:Building:store001%22;stocks==%22urn:ngsi-ld:Product:001%22"
    And    I send a GET HTTP request to that url
    Then   I receive a HTTP "200" response code from Broker with the body "response603-05.json"

  Scenario: 06 - Update the state of a shelf
    When   I set the "Content-Type" header with the value "application/json"
    And    I set the "Link" header with the value "<https://fiware.github.io/tutorials.Step-by-Step/tutorials-context.jsonld>; rel="http://www.w3.org/ns/json-ld#context"; type="application/ld+json""
    And    I set the url to "http://localhost:1026/ngsi-ld/v1/entities/urn:ngsi-ld:Shelf:unit001/attrs"
    And    the body request described in file "request603-06.json"
    And    I send a PATCH HTTP request to that url
    Then   I receive a HTTP "204" status code response

  Scenario: 07 - 01 Creating an entity using an alternate schema
    When   I set the "Content-Type" header with the value "application/ld+json"
    And    I set the url to "http://localhost:1026/ngsi-ld/v1/entities/"
    And    the body request described in file "request603-07.json"
    And    I encode this body in "utf-8"
    And    I send a POST HTTP request to that url
    Then   I receive a HTTP "201" status code response

  Scenario: 08 - 02 Reading an entity using the default schema
    When   I set the "Content-Type" header with the value "application/json"
    And    I set the "Link" header with the value "<https://fiware.github.io/tutorials.Step-by-Step/tutorials-context.jsonld>; rel="http://www.w3.org/ns/json-ld#context"; type="application/ld+json""
    And    I set the url to "http://localhost:1026/ngsi-ld/v1/entities/urn:ngsi-ld:Building:store005"
    And    I send a GET HTTP request to that url
    Then   I receive a HTTP "200" response code from Broker with the body "response603-08.json"

  Scenario: 09 - 03 Reading an entity using an alternate schema
    When   I set the "Content-Type" header with the value "application/json"
    And    I set the "Link" header with the value "<https://fiware.github.io/tutorials.Step-by-Step/japanese-context.jsonld>; rel="http://www.w3.org/ns/json-ld#context"; type="application/ld+json""
    And    I set the url to "http://localhost:1026/ngsi-ld/v1/entities/urn:ngsi-ld:Building:store003"
    And    I send a GET HTTP request to that url
    Then   I receive a HTTP "200" response code from Broker with the body "response603-09.json"

  Scenario: 10 - 04 Applying entity expansion/compaction
    When   I set the "Accept" header with the value "application/json"
    And    I set the "Link" header with the value "<https://fiware.github.io/tutorials.Step-by-Step/japanese-context.jsonld>; rel="http://www.w3.org/ns/json-ld#context"; type="application/ld+json""
    And    I set the url to "http://localhost:3000/japanese/ngsi-ld/v1/entities/urn:ngsi-ld:Building:store005"
    And    I send a GET HTTP request to that url
    Then   I receive a HTTP "200" response code from Broker with the body "response603-10.json"
