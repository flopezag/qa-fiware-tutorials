Feature: test tutorial 102.Entry Relationships

  This is the feature file of the FIWARE Step by Step tutorial for NGSI-v2
  url: https://fiware-tutorials.readthedocs.io/en/latest/entity-relationships/index.html
  docker-compose: ...
  environment: ...

  Background:
    Given I set the tutorial


  Scenario: Checking the service health
    When  I send GET HTTP request to "http://localhost:1026/version"
    Then  I receive a HTTP "200" response code with the body "response101-01.json"
