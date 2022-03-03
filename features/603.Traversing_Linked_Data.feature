Feature: Test tutorial 603.Traversing_Linked_Data
  This is feature file of the FIWARE step by step tutorial for Traversing Linked Data
  url: https://fiware-tutorials.readthedocs.io/en/latest/open-id-connect.html
  git-clone: https://github.com/FIWARE/tutorials.Working-with-Linked-Data.git
  git-directory: /tmp/tutorials.Working-with-Linked-Data
  shell-commands: ./services create; ./services orion
  clean-shell-commands: ./services stop

  Background:
    Given I set the tutorial 603

  Scenario: 01 - Retrieve a known store
curl -G -X GET 'http://localhost:1026/ngsi-ld/v1/entities/urn:ngsi-ld:Building:store001/' \
-H 'Link: <https://fiware.github.io/tutorials.Step-by-Step/tutorials-context.jsonld>; rel="http://www.w3.org/ns/json-ld#context"; type="application/ld+json"' \
-H 'Content-Type: application/json' \
-d 'options=keyValues'
    When   I set the "Content-Type" header with the value "application/json"
    And    I set the "Link" header with the value "<https://fiware.github.io/tutorials.Step-by-Step/tutorials-context.jsonld>; rel="http://www.w3.org/ns/json-ld#context"; type="application/ld+json""
    And    I set the url to "http://localhost:1026/ngsi-ld/v1/entities/urn:ngsi-ld:Building:store001"
    And    the data equal to "options=keyValues"
    And    I send a GET HTTP request to that url
    Then   I receive a HTTP "200" response code from Keystone with the body "response406-13.json"
