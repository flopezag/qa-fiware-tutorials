Feature: test tutorial 102.Entry Relationships

  This is the feature file of the FIWARE Step by Step tutorial for NGSI-v2
  url: https://fiware-tutorials.readthedocs.io/en/latest/entity-relationships/index.html
  docker-compose: https://raw.githubusercontent.com/FIWARE/tutorials.Entity-Relationships/ce7531bc77b8576efddadaeec7ec84c9b5608d62/docker-compose.yml
  environment: https://raw.githubusercontent.com/FIWARE/tutorials.Entity-Relationships/ce7531bc77b8576efddadaeec7ec84c9b5608d62/.env
  init-script: https://raw.githubusercontent.com/FIWARE/tutorials.Entity-Relationships/ce7531bc77b8576efddadaeec7ec84c9b5608d62/services
  aux: [https://raw.githubusercontent.com/FIWARE/tutorials.Entity-Relationships/ce7531bc77b8576efddadaeec7ec84c9b5608d62/import-data]

  Background:
    Given I set the tutorial


  Scenario: Checking the service health
    When  I send GET HTTP request to "http://localhost:1026/version"
    Then  I receive a HTTP "200" response code with the body "response101-01.json"
