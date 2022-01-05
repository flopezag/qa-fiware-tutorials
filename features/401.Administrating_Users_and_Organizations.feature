Feature: Test tutorial 401.Administrating Users and Organizations
    This is feature file of the FIWARE step by step tutorial for Administrating Users and Organizations
    url: https://fiware-tutorials.readthedocs.io/en/latest/identity-management.html
    git-clone: https://github.com/FIWARE/tutorials.Identity-Management.git
    git-directory: /tmp/tutorials.Identity-Management
    shell-commands: ./services create; ./services start
    clean-shell-commands: ./services stop

    Background:
        Given I set the tutorial 401

  Scenario: 00 - Reading directly from the Keyrock MySQL Database
    Given  I connect to the MySQL docker instance with the following data
      | DockerInstance | User | Password | Database | Columns                       | Table |
      | db-mysql       | root | secret   | idm      | id, username, email, password | user  |
    When   I request the information from user table
    Then   I obtain the following data from MySQL
      | id    | username | email          | password |
      | admin | admin    | admin@test.com | ANY      |

  Scenario: 01 - Create token with password
    When   I send POST HTTP request to "http://localhost:3005/v1/auth/tokens"
    And    With the body request described in file "request401-01.json"
    Then   I receive a HTTP response with the following data in header and payload
      | Status-Code | X-Subject-Token | Connection | data                | excluded                |
      | 201         | Any             | keep-alive | response401-01.json | response401-01.excludes |

  Scenario: 02 - Get user information via a token
    When   I send GET HTTP request to "http://localhost:3005/v1/auth/tokens" with equal X-Auth-Token and X-Subject-Token
    Then   I receive a HTTP "200" status code from Keyrock with the body "response401-02.json" and exclusions "response401-02.excludes"
