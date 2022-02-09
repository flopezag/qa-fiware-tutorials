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

  Scenario: 03 - Create an application
    When  I set the "X-Auth-Token" header with the value "aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa"
    And   the content-type header key equal to "application/json"
    And   the body request described in file "request402-03.json"
    And   I send a POST HTTP request to "http://localhost:3005/v1/applications"
    Then  I receive a HTTP "201" status code from Keyrock with the body "response402-03.json" and exclusions "response402-03.excludes"

  Scenario: 04 - Read application details
    When  I set the "X-Auth-Token" header with the value "aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa"
    And   the content-type header key equal to "application/json"
    And   I send a GET HTTP request to the url "http://localhost:3005/v1/applications" with the "application" id from previous execution
    Then  I receive a HTTP "200" status code from Keyrock with the body "response402-04.json" and exclusions "response402-04.excludes"

  Scenario: 05 - List all applications
    When  I set the "X-Auth-Token" header with the value "aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa"
    And   the content-type header key equal to "application/json"
    And   I send a GET HTTP request to the url "http://localhost:3005/v1/applications"
    Then  I receive a HTTP "200" status code from Keyrock with the body "response402-05.json" and exclusions "response402-05.excludes"

  Scenario: 06 - Update an application
    When  I set the "X-Auth-Token" header with the value "aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa"
    And   the content-type header key equal to "application/json"
    And   the body request described in file "request402-06.json"
    And   I send a PATCH HTTP request to the url "http://localhost:3005/v1/applications" with the "application" id from previous execution
    Then  I receive a HTTP "200" status code from Keyrock with the body "response402-06.json" and exclusions "response402-05.excludes"

  Scenario: 07 - Delete an application
    When  I set the "X-Auth-Token" header with the value "aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa"
    And   the content-type header key equal to "application/json"
    And   I send a DELETE HTTP request to the url "http://localhost:3005/v1/applications" with the "application" id from previous execution
    Then  I receive a HTTP "204" status code response

  # In order to work these permissions CRUD it is needed to have a created application previously
  # the previous operations end with the operation to delete the application therefore, the tutorial will fail
  # due to there is no application
  Scenario: 08.1 - Create the application again
    When  I set the "X-Auth-Token" header with the value "aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa"
    And   the content-type header key equal to "application/json"
    And   the body request described in file "request402-03.json"
    And   I send a POST HTTP request to "http://localhost:3005/v1/applications"
    Then  I receive a HTTP "201" status code from Keyrock with the body "response402-03.json" and exclusions "response402-03.excludes"

  Scenario: 08.2 - Create a permission
    When  I set the "X-Auth-Token" header with the value "aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa"
    And   the content-type header key equal to "application/json"
    And   the body request described in file "request402-08.json"
    And   I set the permission url with an application id
    And   I send a POST HTTP request to that url
    Then  I receive a HTTP "201" status code from Keyrock with the body "response402-08.json" and exclusions "response402-08.excludes"

  Scenario: 09 - Read permission details
    When  I set the "X-Auth-Token" header with the value "aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa"
    And   the content-type header key equal to "application/json"
    And   I set the permission url with the application and permission ids
    And   I send a GET HTTP request to that url
    Then  I receive a HTTP "200" status code from Keyrock with the body "response402-09.json" and exclusions "response402-08.excludes"

  Scenario: 10 - List permissions
    When  I set the "X-Auth-Token" header with the value "aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa"
    And   the content-type header key equal to "application/json"
    And   I set the permission url with an application id
    And   I send a GET HTTP request to that url
    Then  I receive a HTTP "200" status code from Keyrock with the body "response402-10.json" and exclusions "response402-10.excludes"

  Scenario: 11 - Update a permission
    When  I set the "X-Auth-Token" header with the value "aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa"
    And   the content-type header key equal to "application/json"
    And   the body request described in file "request402-11.json"
    And   I set the permission url with the application and permission ids
    And   I send a PATCH HTTP request to that url
    Then  I receive a HTTP "200" response code from Keyrock with the body "response402-11.json"

  Scenario: 12 - Delete a permission
    When  I set the "X-Auth-Token" header with the value "aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa"
    And   the content-type header key equal to "application/json"
    And   I set the permission url with the application and permission ids
    And   I send a DELETE HTTP request to that url
    Then  I receive a HTTP "204" status code response

  Scenario: 13 - Create a role
    When  I set the "X-Auth-Token" header with the value "aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa"
    And   the content-type header key equal to "application/json"
    And   the body request described in file "request402-13.json"
    And   I set the roles url with an application id
    And   I send a POST HTTP request to that url
    Then  I receive a HTTP "201" status code from Keyrock with the body "response402-13.json" and exclusions "response402-13.excludes"

  Scenario: 14 - Read role details
    When  I set the "X-Auth-Token" header with the value "aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa"
    And   the content-type header key equal to "application/json"
    And   I set the roles url with an application id and role id
    And   I send a GET HTTP request to that url
    Then  I receive a HTTP "200" status code from Keyrock with the body "response402-14.json" and exclusions "response402-13.excludes"

  Scenario: 15 - List roles
    When  I set the "X-Auth-Token" header with the value "aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa"
    And   the content-type header key equal to "application/json"
    And   I set the roles url with an application id
    And   I send a GET HTTP request to that url
    Then  I receive a HTTP "200" response code from Keyrock with the body "response402-15.json" and exclusions "response402-15.excludes"

  Scenario: 16 - Update a role
    When  I set the "X-Auth-Token" header with the value "aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa"
    And   the content-type header key equal to "application/json"
    And   the body request described in file "request402-16.json"
    And   I set the roles url with an application id and role id
    And   I send a PATCH HTTP request to that url
    Then  I receive a HTTP "200" response code from Keyrock with the body "response402-16.json"

  Scenario: 17 - Delete a role
    When  I set the "X-Auth-Token" header with the value "aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa"
    And   the content-type header key equal to "application/json"
    And   I set the roles url with an application id and role id
    And   I send a DELETE HTTP request to that url
    Then  I receive a HTTP "204" status code response

  # There is no details information in the tutorial regarding the role and permissions to be used
  # in the API, there is a figure that show the "Secret Viewer" and the permission "SecretViewer"
  # the previous operation finished with the delete of the role and delete of the permission therefore
  # there is no role and no permission.
  Scenario: 18.1 - Create the role again
    When  I set the "X-Auth-Token" header with the value "aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa"
    And   the content-type header key equal to "application/json"
    And   the body request described in file "request402-13.json"
    And   I set the roles url with an application id
    And   I send a POST HTTP request to that url
    Then  I receive a HTTP "201" status code from Keyrock with the body "response402-13.json" and exclusions "response402-13.excludes"

  Scenario: 18.2 - Create the permission again
    When  I set the "X-Auth-Token" header with the value "aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa"
    And   the content-type header key equal to "application/json"
    And   the body request described in file "request402-18-01.json"
    And   I set the permission url with an application id
    And   I send a POST HTTP request to that url
    Then  I receive a HTTP "201" status code from Keyrock with the body "response402-18-01.json" and exclusions "response402-08.excludes"

  Scenario: 18.3 - Add a permission to a role
    When  I set the "X-Auth-Token" header with the value "aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa"
    And   the content-type header key equal to "application/json"
    And   I set the permission to the role of an application
    And   I send a PUT HTTP request to that url
    Then  I receive a HTTP "201" status code from Keyrock with the "role_permission_assignments" with this "roleId" and "permissionId"

  Scenario: 19 - List permissions of a role
    When  I set the "X-Auth-Token" header with the value "aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa"
    And   the content-type header key equal to "application/json"
    And   I set the permissions url to the role of an application
    And   I send a GET HTTP request to that url
    Then  I receive a HTTP "200" response code from Keyrock with the body "response402-19.json" and exclusions "response402-19.excludes"

  Scenario: 20 - Remove a permission from a role
    When  I set the "X-Auth-Token" header with the value "aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa"
    And   the content-type header key equal to "application/json"
    And   I set the permission to the role of an application
    And   I send a DELETE HTTP request to that url
    Then  I receive a HTTP "204" status code response

  # At this point of the tutorial there are no application, no organization, and no role with the id described in the
  # tutorial, therefore we need to create the application, organization, and role.
  Scenario: 21.1 - Create an application again
    When  I set the "X-Auth-Token" header with the value "aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa"
    And   the content-type header key equal to "application/json"
    And   the body request described in file "request402-03.json"
    And   I send a POST HTTP request to "http://localhost:3005/v1/applications"
    Then  I receive a HTTP "201" status code from Keyrock with the body "response402-03.json" and exclusions "response402-03.excludes"

  Scenario: 21.2 - Create an organization again
    When  I set the X-Auth-Token header with the previous obtained token
    And   the content-type header key equal to "application/json"
    And   the body request described in file "request401-09.json"
    And   I send a POST HTTP request to "http://localhost:3005/v1/organizations"
    Then  I receive a HTTP "201" status code from Keyrock with the body "response401-09.json" and exclusions "response401-09.excludes"

  Scenario: 21.3 - Create the role again
    When  I set the "X-Auth-Token" header with the value "aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa"
    And   the content-type header key equal to "application/json"
    And   the body request described in file "request402-13.json"
    And   I set the roles url with an application id
    And   I send a POST HTTP request to that url
    Then  I receive a HTTP "201" status code from Keyrock with the body "response402-13.json" and exclusions "response402-13.excludes"

  Scenario: 21.4 - Grant a role to an organization
    When  I set the "X-Auth-Token" header with the value "aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa"
    And   the content-type header key equal to "application/json"
    And   I set the organization_roles url with the following data
        | application_id | organization_id | role_id | organization_role |
        | applicationId  | organizationId  | roleId  | member            |
    And   I send a PUT HTTP request to that url
    Then  I receive a HTTP "201" status code from Keyrock with the following data for an organization
        | role_organization_assignments | role_id | organization_id | oauth_client_id | role_organization |
        | any                           | roleId  | organizationId  | any             | member            |

  Scenario: 22 - List granted organization roles
    When  I set the "X-Auth-Token" header with the value "aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa"
    And   the content-type header key equal to "application/json"
    And   I set the roles url with the following data
        | application_id | organization_id |
        | applicationId  | organizationId  |
    And   I send a GET HTTP request to that url
    Then  I receive a HTTP "200" status code from Keyrock with the following data for organizations
        | role_organization_assignments | role_id | organization_id |
        | any                           | roleId  | organizationId  |

  Scenario: 23 - Revoke a role from an organization
    When  I set the "X-Auth-Token" header with the value "aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa"
    And   the content-type header key equal to "application/json"
    And   I set the organization_roles url with the following data
        | application_id | organization_id | role_id | organization_role |
        | applicationId  | organizationId  | roleId  | member            |
    And   I send a DELETE HTTP request to that url
    Then  I receive a HTTP "204" status code response

  Scenario: 24 - Grant a role to a user
    When  I set the "X-Auth-Token" header with the value "aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa"
    And   the content-type header key equal to "application/json"
    And   I set the user roles url with the following data
        | application_id | user_id                               | role_id |
        | applicationId  | bbbbbbbb-good-0000-0000-000000000000  | roleId  |
    And   I send a PUT HTTP request to that url
    Then  I receive a HTTP "201" status code from Keyrock with the following data for a role_user_assignments
        | role_user_assignments | role_id | user_id                               | oauth_client_id |
        | any                   | roleId  | bbbbbbbb-good-0000-0000-000000000000  | any             |

  Scenario: 25 - List granted user roles
    When  I set the "X-Auth-Token" header with the value "aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa"
    And   the content-type header key equal to "application/json"
    And   I set the roles url with the following data
        | application_id | user_id                               |
        | applicationId  | bbbbbbbb-good-0000-0000-000000000000  |
    And   I send a GET HTTP request to that url
    Then  I receive a HTTP "200" status code from Keyrock with the following role user data
        | role_user_assignments | user_id                               | role_id |
        | any                   | bbbbbbbb-good-0000-0000-000000000000  | roleId  |

  Scenario: 26 - Revoke a role from a user
    When  I set the "X-Auth-Token" header with the value "aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa"
    And   the content-type header key equal to "application/json"
    And   I set the user roles url with the following data
        | application_id | user_id                               | role_id |
        | applicationId  | bbbbbbbb-good-0000-0000-000000000000  | roleId  |
    And   I send a DELETE HTTP request to that url
    Then  I receive a HTTP "204" status code response

  Scenario: 27 - List authorized organizations
    When  I set the "X-Auth-Token" header with the value "aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa"
    And   the content-type header key equal to "application/json"
    And   I set the "organizations" url with the "application_id"
    And   I send a GET HTTP request to that url
    Then  I receive a HTTP "200" status code from Keyrock with the following role organization data
        | role_organization_assignments | organization_id | role_organization | role_id |
        | any                           | organizationId  | member            | roleId  |

  Scenario: 28 - List authorized users
    When  I set the "X-Auth-Token" header with the value "aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa"
    And   the content-type header key equal to "application/json"
    And   I set the "users" url with the "application_id"
    And   I send a GET HTTP request to that url
    Then  I receive a HTTP "200" response code from Keyrock with the body "response402-28.json"
