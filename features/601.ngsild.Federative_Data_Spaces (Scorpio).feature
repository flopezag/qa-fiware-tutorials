Feature: Test tutorial 601.Federative_Data_Spaces (Orion-LD)
  This is feature file of the FIWARE step by step tutorial for Federative Data Spaces (Orion-LD)
  url: https://ngsi-ld-tutorials.readthedocs.io/en/latest/linked-data.html
  git-clone: https://github.com/FIWARE/tutorials.Linked-Data.git
  git-directory: /tmp/tutorials.Linked-Data
  shell-commands: git checkout NGSI-LD; ./services create; ./services scorpio
  clean-shell-commands: ./services stop

  Background:
    Given I set the tutorial 601_FDS

    Scenario: 01 - Reading NGSI-v2 Data Directly
      When   I set the url to "http://localhost:1027/v2/entities/urn:ngsi-ld:Store:001"
      And    I send a GET HTTP request to that url
      Then   I receive a HTTP "200" response code from Orion with the body equal to "response601FDS_01.json"

    Scenario: 02 - Reading NGSI-v2 Data in NGSI-LD Format
      When   I set the url to "http://localhost:3005/ngsi-ld/v1/entities/urn:ngsi-ld:Store:001"
      And    I set the "Accept" header with the value "application/ld+json"
      And    I set the "Link" header with the value "<http://context/ngsi-context.jsonld>; rel="http://www.w3.org/ns/json-ld#context"; type="application/ld+json""
      And    I send a GET HTTP request to that url
      Then   I receive a HTTP "200" response code from Lepus with the body equal to "response601FDS_02.json"

    Scenario: 03 - Retrieving Fixed Context
      When   I set the url to "http://localhost:3004/fixed-context.jsonld"
      And    I send a GET HTTP request to that url
      Then   I receive a HTTP "200" response code from Lepus with the body equal to "response601FDS_03.json"

    Scenario: 04 - Get information from Lepus
      When   I set the url to "http://localhost:3005/ngsi-ld/v1/info/sourceIdentity"
      And    I set the "Accept" header with the value "application/ld+json"
      And    I send a GET HTTP request to that url
      Then   I receive a HTTP "200" status code from Lepus with the body "response601FDS_04.json" and exclusions "response601FDS_04.excludes"

    Scenario: 05 - Creating a federation registration
      When   I set the url to "http://localhost:1026/ngsi-ld/v1/csourceRegistrations"
      And    I set the "Link" header with the value "<http://context/ngsi-context.jsonld>; rel="http://www.w3.org/ns/json-ld#context"; type="application/ld+json""
      And    I set the "Content-Type" header with the value "application/json"
      And    the body request described in file "request601FDS_05.json"
      And    I send a POST HTTP request to that url
      Then   I receive a HTTP "201" status code response

    Scenario: 06 - Retrieve one entity data
      When   I set the url to "http://localhost:1026/ngsi-ld/v1/entities/urn:ngsi-ld:Store:001"
      And    I set the "Link" header with the value "<http://context/ngsi-context.jsonld>; rel="http://www.w3.org/ns/json-ld#context"; type="application/ld+json""
      And    I send a GET HTTP request to that url
      Then   I receive a HTTP "200" response code from Scorpio with the body equal to "response601FDS_06.json"

    Scenario: 07 - Retrieve Entities
      When   I set the url to "http://localhost:1026/ngsi-ld/v1/entities"
      And    I set the "Link" header with the value "<http://context/ngsi-context.jsonld>; rel="http://www.w3.org/ns/json-ld#context"; type="application/ld+json""
      And    I set the "Accept" header with the value "application/ld+json"
      And    the params equal to "type=Building"
      And    the params equal to "q=category==%22supermarket%22"
      And    the params equal to "attrs=name"
      And    the params equal to "options=keyValues"
      And    I send a GET HTTP request to that url
      Then   I receive a HTTP "200" response code from Scorpio with the body equal to "response601FDS_07.json"

    Scenario: 08 - Using an Alternate @context
      When   I set the url to "http://localhost:1026/ngsi-ld/v1/entities/urn:ngsi-ld:Store:001"
      And    I set the "Link" header with the value "<http://context/alternate-context.jsonld>; rel="http://www.w3.org/ns/json-ld#context"; type="application/ld+json""
      And    I send a GET HTTP request to that url
      Then   I receive a HTTP "200" response code from Scorpio with the body equal to "response601FDS_08.json"
