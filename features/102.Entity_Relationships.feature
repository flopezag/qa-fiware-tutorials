Feature: test tutorial 102.Entry Relationships

  This is the feature file of the FIWARE Step by Step tutorial for NGSI-v2
  url: https://fiware-tutorials.readthedocs.io/en/latest/entity-relationships.html
  git-clone: https://github.com/FIWARE/tutorials.Entity-Relationships.git
  git-directory: /tmp/tutorials.Entity-Relationships
  shell-commands: ./services start
  clean-shell-commands: ./services stop

  Background:
    Given I set the tutorial


  Scenario: Checking the service health
    When  I wait "5" seconds
    When  I send GET HTTP request to "http://localhost:1026/version"
    Then  I receive a HTTP "200" response code from Context Broker with the body "response101-01.json"
