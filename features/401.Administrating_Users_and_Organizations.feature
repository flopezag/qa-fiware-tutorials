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
    When   I send a GET HTTP request to "http://localhost:3005/v1/auth/tokens" with equal X-Auth-Token and X-Subject-Token
    Then   I receive a HTTP "200" status code from Keyrock with the body "response401-02.json" and exclusions "response401-02.excludes"

  Scenario: 03 - Refresh token
    When   I send POST HTTP request to "http://localhost:3005/v1/auth/tokens"
    And    With the body request containing the previous token
    Then   I receive a HTTP "200" status code from Keyrock with the body "response401-03.json" and exclusions "response401-01.excludes"

  Scenario: 04.1 - Creating admin user
    When   I send POST HTTP request to "http://localhost:3005/v1/users"
    And    With the X-Auth-Token header with the previous obtained token
    And    With the body request described in file "request401-04.json"
    Then   I receive a HTTP "201" status code from Keyrock with the body "response401-04.json" and exclusions "response401-04.excludes"

  Scenario: 04.02 - Grant super-admin to Alice user
    Given  I connect to the MySQL docker instance to grant user with the following data
      | DockerInstance | User | Password | Database | Table | Username |
      | db-mysql       | root | secret   | idm      | user  | alice    |
    When   I update the information into the user table
    Then   I can check the table with the following data
      | DockerInstance | User | Password | Database | Table | Column | Username |
      | db-mysql       | root | secret   | idm      | user  | admin  | alice    |
    And    I request the information from user table
    And    I obtain the value "1" from the select

  Scenario Outline: 04.03 - Creating the rest of the users
    When   I send POST HTTP request to "http://localhost:3005/v1/users"
    And    With the X-Auth-Token header with the previous obtained token
    And    With the body request with "<username>", "<email>", and "<password>" data
    Then   I receive a HTTP "201" response with the corresponding "<username>" and "<email>" data

    Examples:
        | username   | email                     | password |
        | bob        | bob-the-manager@test.com  | test     |
        | charlie    | charlie-security@test.com | test     |
        | manager1   | manager1@test.com         | test     |
        | manager2   | manager2@test.com         | test     |
        | detective1 | detective1@test.com       | test     |
        | detective2 | detective2@test.com       | test     |

  Scenario: 05 - Read information about the admin user
    When   I send a GET HTTP request to "http://localhost:3005/v1/users"
    And    With the X-Auth-Token header with the previous obtained token
    And    With the admin user id from the previous operation
    Then   I receive a HTTP "200" status code from Keyrock with the body "response401-05.json" and exclusions "response401-04.excludes"
