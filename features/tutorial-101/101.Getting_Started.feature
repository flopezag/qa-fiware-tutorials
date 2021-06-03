Feature: test tutorial 101.Getting Started

  This is the feature file of the FIWARE Step by Step tutorial for NGSI-v2
  url: https://fiware-tutorials.readthedocs.io/en/latest/getting-started/index.html
  docker-compose: https://raw.githubusercontent.com/FIWARE/tutorials.Getting-Started/master/docker-compose.yml
  environment: https://raw.githubusercontent.com/FIWARE/tutorials.Getting-Started/master/.env

Background: 
    Given I set the tutorial

Scenario: GET version request
    When  I send GET HTTP request to "http://localhost:1026/version"
    Then  I receive a HTTP "200" response code
    And   I receive a dictionary with the key "orion" and the following data
          | version     | uptime | git_hash                                 | compile_time                |
          | 1.12.0-next | AAA    | e2ff1a8d9515ade24cf8d4b90d27af7a616c7725 | Wed Apr 4 19:08:02 UTC 2018 |
    And   also the following data
          | compiled_by | compiled_in  | release_date                | doc                                             |
          | root        | 2f4a69bdc191 | Wed Apr 4 19:08:02 UTC 2018 | https://fiware-orion.readthedocs.org/en/master/ |
    And   there is no other information on it
