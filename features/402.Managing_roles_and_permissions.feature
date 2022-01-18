Feature: Test tutorial 402.Managing roles and permissions
    This is feature file of the FIWARE step by step tutorial for Managing roles and permissions
    url: https://fiware-tutorials.readthedocs.io/en/latest/roles-permissions.html
    git-clone: https://github.com/FIWARE/tutorials.Roles-Permissions.git
    git-directory: /tmp/tutorials.Roles-Permissions
    shell-commands: git checkout NGSI-v2; ./services create; ./services start
    clean-shell-commands: ./services stop

    Background:
        Given I set the tutorial 402

  Scenario: 00 - Reading directly from the Keyrock MySQL Database
    Given  I connect to the MySQL docker instance with the following data
      | DockerInstance | User | Password | Database | Columns                       | Table |
      | db-mysql       | root | secret   | idm      | id, username, email, password | user  |
    When   I request the information from user table
    Then   I obtain the following data from MySQL
      | id                                   | username | email                    | password |
      | aaaaaaaa-good-0000-0000-000000000000 | alice    | alice-the-admin@test.com | ANY      |

  Scenario: 01 - Create token with password
    When   I define the body request described in file "request402-01.json"
    And    the content-type header key equal to "application/json"
    And    I send a POST HTTP request to "http://localhost:3005/v1/auth/tokens"
    Then   I receive a HTTP response with the following data in header and payload
      | Status-Code | X-Subject-Token                      | Connection | data                | excluded                |
      | 201         | bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb | keep-alive | response402-01.json | response402-01.excludes |

  Scenario: 02 - Get token info
    When  I set the "X-Auth-Token" header with the value "aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa"
    And   I set the "X-Subject-token" header with the value "bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb"
    And   the content-type header key equal to "application/json"
    And   I send a GET HTTP request to the url "http://localhost:3005/v1/auth/tokens"
    Then  I receive a HTTP "200" status code from Keyrock with the body "response402-02.json" and exclusions "response402-02.excludes"
