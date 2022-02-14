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
    When   I define the body request described in file "request401-01.json"
    And    the content-type header key equal to "application/json"
    And    I send a POST HTTP request to "http://localhost:3005/v1/auth/tokens"
    Then   I receive a HTTP response with the following data in header and payload
      | Status-Code | X-Subject-Token | Connection | data                | excluded                |
      | 201         | any             | keep-alive | response401-01.json | response401-01.excludes |

  Scenario: 02 - Get user information via a token
    When   I send a GET HTTP request to "http://localhost:3005/v1/auth/tokens" with equal X-Auth-Token and X-Subject-Token
    Then   I receive a HTTP "200" status code from Keyrock with the body "response401-02.json" and exclusions "response401-02.excludes"

  Scenario: 03 - Refresh token
    When   We defined a payload with token equal to the previous token
    And    the content-type header key equal to "application/json"
    And    I send a POST HTTP request to "http://localhost:3005/v1/auth/tokens"
    Then   I receive a HTTP "201" status code from Keyrock with the body "response401-03.json" and exclusions "response401-01.excludes"

  Scenario: 04.1 - Creating admin user
    When   I set the X-Auth-Token header with the previous obtained token
    And    the content-type header key equal to "application/json"
    And    the body request described in file "request401-04.json"
    And    I send a POST HTTP request to "http://localhost:3005/v1/users"
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
    When   I set the X-Auth-Token header with the previous obtained token
    And    the content-type header key equal to "application/json"
    And    With the body request with "<username>", "<email>", and "<password>" data
    And    I send a POST HTTP request to "http://localhost:3005/v1/users"
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
    When   I set the X-Auth-Token header with the previous obtained token
    And    the content-type header key equal to "application/json"
    And    I send a GET HTTP request to "http://localhost:3005/v1/users" with the admin user id from previous execution
    Then   I receive a HTTP "200" status code from Keyrock with the body "response401-05.json" and exclusions "response401-04.excludes"

  Scenario: 06 - List all users
    When   I set the X-Auth-Token header with the previous obtained token
    And    the content-type header key equal to "application/json"
    And    I send a GET HTTP request to the url "http://localhost:3005/v1/users"
    Then   I receive a HTTP "200" status code from Keyrock with the following data for each created user
        | id  | username   | email                     | enabled | gravatar | date_password | description | website |
        | any | alice      | alice-the-admin@test.com  | true    | false    | any           | null        | null    |
        | any | bob        | bob-the-manager@test.com  | true    | false    | any           | null        | null    |
        | any | charlie    | charlie-security@test.com | true    | false    | any           | null        | null    |
        | any | manager1   | manager1@test.com         | true    | false    | any           | null        | null    |
        | any | manager2   | manager2@test.com         | true    | false    | any           | null        | null    |
        | any | detective1 | detective1@test.com       | true    | false    | any           | null        | null    |
        | any | detective2 | detective2@test.com       | true    | false    | any           | null        | null    |

  Scenario: 07 - Update a user
    When  I set the X-Auth-Token header with the previous obtained token
    And   the content-type header key equal to "application/json"
    And   the body request described in file "request401-07.json"
    And   I send a PATCH HTTP request to the url "http://localhost:3005/v1/users" with the "admin user" id from previous execution
    Then  I receive a HTTP "200" response code from Keyrock with the body "response401-07.json"

  Scenario: 08 - Delete a user
    When  I set the X-Auth-Token header with the previous obtained token
    And   the content-type header key equal to "application/json"
    And   I send a DELETE HTTP request to the url "http://localhost:3005/v1/users" with the "admin user" id from previous execution
    Then  I receive a HTTP "204" status code response

  Scenario: 09 - Create an organization
    When  I set the X-Auth-Token header with the previous obtained token
    And   the content-type header key equal to "application/json"
    And   the body request described in file "request401-09.json"
    And   I send a POST HTTP request to "http://localhost:3005/v1/organizations"
    Then  I receive a HTTP "201" status code from Keyrock with the body "response401-09.json" and exclusions "response401-09.excludes"

  Scenario: 10 - Read organization details
    When  I set the X-Auth-Token header with the previous obtained token
    And   the content-type header key equal to "application/json"
    And   I send a GET HTTP request to the url "http://localhost:3005/v1/organizations" with the "organization" id from previous execution
    Then  I receive a HTTP "200" status code from Keyrock with the body "response401-10.json" and exclusions "response401-09.excludes"

  Scenario: 11 - List all organizations
    When  I set the X-Auth-Token header with the previous obtained token
    And   the content-type header key equal to "application/json"
    And   I send a GET HTTP request to the url "http://localhost:3005/v1/organizations"
    Then  I receive a HTTP "200" status code from Keyrock with the body "response401-11.json" and exclusions "response401-11.excludes"

  Scenario: 12 - Update an organization
    When  I set the X-Auth-Token header with the previous obtained token
    And   the content-type header key equal to "application/json"
    And   the body request described in file "request401-12.json"
    And   I send a PATCH HTTP request to the url "http://localhost:3005/v1/organizations" with the "organization" id from previous execution
    Then  I receive a HTTP "200" response code from Keyrock with the body "response401-12.json"

  Scenario: 13 - Delete an organization
    When  I set the X-Auth-Token header with the previous obtained token
    And   the content-type header key equal to "application/json"
    And   I send a DELETE HTTP request to the url "http://localhost:3005/v1/organizations" with the "organization" id from previous execution
    Then  I receive a HTTP "204" status code response

  # In the documentation there is no reference to which user that has to be assigned, so we decided to use charlie user
  # In the documentation there is no reference to which organization to use, in fact there is no organization
  Scenario: 14 - Add a user as a member of an organization
    When  I set the X-Auth-Token header with the previous obtained token
    And   the content-type header key equal to "application/json"
    And   I send a GET HTTP request to the url "http://localhost:3005/v1/users"
    And   I receive a HTTP "200" status code from Keyrock and extract the id from "charlie" user
    And   I send a GET HTTP request to the url "http://localhost:3005/v1/organizations"
    And   I receive a HTTP "200" status code from Keyrock and extract the id from the first organization
    And   I set the organization_roles as "member" url with organizationId and userId
    And   I send a PUT HTTP request to that url
    Then  I receive a HTTP "200" status code with the same organizationId and userId and role equal to "member"

  # In the documentation there is no reference to which user that has to be assigned, so we decided to use charlie user
  # In the documentation there is no reference to which organization to use, in fact there is no organization
  Scenario: 15 - Add a user as an owner of an organization
    When  I set the X-Auth-Token header with the previous obtained token
    And   the content-type header key equal to "application/json"
    And   I send a GET HTTP request to the url "http://localhost:3005/v1/users"
    And   I receive a HTTP "200" status code from Keyrock and extract the id from "bob" user
    And   I send a GET HTTP request to the url "http://localhost:3005/v1/organizations"
    And   I receive a HTTP "200" status code from Keyrock and extract the id from the first organization
    And   I set the organization_roles as "owner" url with organizationId and userId
    And   I send a PUT HTTP request to that url
    Then  I receive a HTTP "200" status code with the same organizationId and userId and role equal to "owner"

  # There is no organization at this point
  Scenario: 16 - List users within an organization
    When  I set the X-Auth-Token header with the previous obtained token
    And   the content-type header key equal to "application/json"
    And   I send a GET HTTP request to the url "http://localhost:3005/v1/organizations"
    And   I receive a HTTP "200" status code from Keyrock and extract the id from the first organization
    And   I set the organization users url with organizationId from the previous scenario
    And   I send a GET HTTP request to that url
    Then  I receive a HTTP "200" status code with the same organizationId and userId and role equal to "owner"

  # There is no organization at this point
  Scenario: 17 - Read user roles within an organization
    When  I set the X-Auth-Token header with the previous obtained token
    And   the content-type header key equal to "application/json"
    And   I send a GET HTTP request to the url "http://localhost:3005/v1/users"
    And   I receive a HTTP "200" status code from Keyrock and extract the id from "bob" user
    And   I set the organization roles url with organizationId from the previous scenario and userId from "bob"
    And   I send a GET HTTP request to that url
    Then  I receive a HTTP "200" status code with the same organizationId and userId and role equal to "owner"

  # There is no organization at this point
  Scenario: 18 - Remove a user from an organization
    When  I set the X-Auth-Token header with the previous obtained token
    And   the content-type header key equal to "application/json"
    And   I send a GET HTTP request to the url "http://localhost:3005/v1/users"
    And   I receive a HTTP "200" status code from Keyrock and extract the id from "bob" user
    And   I set the organization roles url with organizationId from the previous scenario and userId from "bob"
    And   I send a DELETE HTTP request to that url
    Then  I receive a HTTP "200" status code with the same organizationId and userId and role equal to "owner"
