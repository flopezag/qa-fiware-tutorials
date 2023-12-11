Feature: Test tutorial 406.Administrating_XACML_Rules
  This is feature file of the FIWARE step by step tutorial for Administrating XACML rules
  url: https://fiware-tutorials.readthedocs.io/en/latest/administrating-xacml.html
  git-clone: https://github.com/FIWARE/tutorials.Administrating-XACML.git
  git-directory: /tmp/tutorials.Administrating-XACML
  shell-commands: ./services create; ./services start
  clean-shell-commands: ./services stop

  Background:
    Given I set the tutorial 406

  Scenario: 01 - Creating a new domain
    When  I set the url to "http://localhost:8080/authzforce-ce/domains"
    And   I set the "Content-Type" header with the value "application/xml"
    And   the body request described in file "request406-01.xml"
    And   I send a POST HTTP request to that url
    Then  I receive a HTTP "200" response code from AuthZForce with the body equal to "response406-01.xml"

  Scenario: 02 - Request a decision from AuthZForce
    When  I set the "AuthZForce" to the pdp endpoint url with the "domainId"
    And   I set the "Content-Type" header with the value "application/xml"
    And   the body request described in file "request406-02.xml"
    And   I send a POST HTTP request to that url
    Then  I receive a HTTP "200" response code from AuthZForce with the body equal to "response406-02.xml"

  Scenario: 03 - Creating an initial policy set
    When  I set the "AuthZForce" pap policies url with the "domainId"
    And   I set the "Content-Type" header with the value "application/xml"
    And   the body request described in file "request406-03.xml"
    And   I send a POST HTTP request to that url
    Then  I receive a HTTP "200" response code from AuthZForce with the body equal to "response406-03.xml"

  Scenario: 04 - Activating the initial policy set
    When  I set the "AuthZForce" pap policies with pdp.properties url with the "domainId"
    And   I set the "Content-Type" header with the value "application/xml"
    And   the body request described in file "request406-04.xml"
    And   I send a PUT HTTP request to that url
    Then  I receive a HTTP "200" response code from AuthZForce with the body equal to "response406-04.xml"

  Scenario: 05 - Request to access to loading in the white zone
    When  I set the "AuthZForce" to the pdp endpoint url with the "domainId"
    And   I set the "Content-Type" header with the value "application/xml"
    And   the body request described in file "request406-05.xml"
    And   I send a POST HTTP request to that url
    Then  I receive a HTTP "200" response code from AuthZForce with the body equal to "response406-05.xml"

  Scenario: 06 - Request to access to loading in the red zone
    When  I set the "AuthZForce" to the pdp endpoint url with the "domainId"
    And   I set the "Content-Type" header with the value "application/xml"
    And   the body request described in file "request406-06.xml"
    And   I send a POST HTTP request to that url
    Then  I receive a HTTP "200" response code from AuthZForce with the body equal to "response406-06.xml"

  Scenario: 07 - Updating a policy set
    When  I set the "AuthZForce" pap policies url with the "domainId"
    And   I set the "Content-Type" header with the value "application/xml"
    And   the body request described in file "request406-07.xml"
    And   I send a POST HTTP request to that url
    Then  I receive a HTTP "200" response code from AuthZForce with the body equal to "response406-07.xml"


  Scenario: 08 - Activating an updated policy set
    When  I set the "AuthZForce" pap policies with pdp.properties url with the "domainId"
    And   I set the "Content-Type" header with the value "application/xml"
    And   the body request described in file "request406-08.xml"
    And   I send a PUT HTTP request to that url
    Then  I receive a HTTP "200" response code from AuthZForce with the body equal to "response406-08.xml"

  Scenario: 09 - Request to access to loading in the white zone again
    When  I set the "AuthZForce" to the pdp endpoint url with the "domainId"
    And   I set the "Content-Type" header with the value "application/xml"
    And   the body request described in file "request406-09.xml"
    And   I send a POST HTTP request to that url
    Then  I receive a HTTP "200" response code from AuthZForce with the body equal to "response406-09.xml"

  Scenario: 10 - Request to access to loading in the red zone again
    When  I set the "AuthZForce" to the pdp endpoint url with the "domainId"
    And   I set the "Content-Type" header with the value "application/xml"
    And   the body request described in file "request406-10.xml"
    And   I send a POST HTTP request to that url
    Then  I receive a HTTP "200" response code from AuthZForce with the body equal to "response406-10.xml"

  Scenario: 11 - Create a token with password
    When   I define the body request described in file "request406-11.json"
    And    I set the "Content-Type" header with the value "application/json"
    And    I set the "Accept" header with the value "application/json"
    And    I send a POST HTTP request to "http://localhost:3005/v1/auth/tokens"
    Then   I receive a HTTP response with the following data in header and payload
      | Status-Code | X-Subject-Token | Connection | data                | excluded                |
      | 201         | any             | keep-alive | response406-11.json | response406-11.excludes |

  Scenario: 12 - Read a Verb-resource permission
    When   I set the "Content-Type" header with the value "application/json"
    And    I set the "X-Auth-token" header with the value "aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa"
    And    I set the url to "http://localhost:3005/v1/applications/tutorial-dckr-site-0000-xpresswebapp/permissions/entrance-open-0000-0000-000000000000"
    And    I send a GET HTTP request to that url
    Then   I receive a HTTP "200" response code from Keystone with the body equal to "response406-12.json"

  Scenario: 13 - Read a XACML rule permission
    When   I set the "Content-Type" header with the value "application/json"
    And    I set the "X-Auth-token" header with the value "aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa"
    And    I set the url to "http://localhost:3005/v1/applications/tutorial-dckr-site-0000-xpresswebapp/permissions/alrmbell-ring-24hr-xaml-000000000000"
    And    I send a GET HTTP request to that url
    Then   I receive a HTTP "200" response code from Keystone with the body equal to "response406-13.json"

  Scenario: 14 - Deny access to a resource
    When  I set the "AuthZForce" to the pdp endpoint url with the "domainId"
    And   I set the "Content-Type" header with the value "application/xml"
    And   the body request described in file "request406-14.xml"
    And   I send a POST HTTP request to that url
    Then  I receive a HTTP "200" response code from AuthZForce with the body equal to "response406-14.xml"

  Scenario: 15 - Update an XACML permission
    When   I set the "Content-Type" header with the value "application/json"
    And    I set the "X-Auth-token" header with the value "aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa"
    And    the body request described in file "request406-15.json"
    And    I set the url to "http://localhost:3005/v1/applications/tutorial-dckr-site-0000-xpresswebapp/permissions/alrmbell-ring-24hr-xaml-000000000000"
    And    I send a PATCH HTTP request to that url
    Then   I receive a HTTP "200" response code from Keystone with the body equal to "response406-15.json"

  Scenario: 16 - Passing the updated policy set to AuthZForce, delete an association
    When   I set the "Content-Type" header with the value "application/json"
    And    I set the "X-Auth-token" header with the value "aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa"
    And    I set the url to "http://localhost:3005/v1/applications/tutorial-dckr-site-0000-xpresswebapp/roles/security-role-0000-0000-000000000000/permissions/alrmbell-ring-24hr-xaml-000000000000"
    And    I send a DELETE HTTP request to that url
    Then   I receive a HTTP "204" status code response

  Scenario: 17 - Passing the updated policy set to AuthZForce, recreating the policy set
    When   I set the "Content-Type" header with the value "application/json"
    And    I set the "X-Auth-token" header with the value "aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa"
    And    I set the url to "http://localhost:3005/v1/applications/tutorial-dckr-site-0000-xpresswebapp/roles/security-role-0000-0000-000000000000/permissions/alrmbell-ring-24hr-xaml-000000000000"
    And    I do not specify any payload
    And    I send a POST HTTP request to that url
    Then   I receive a HTTP "201" response code from Keystone with the body equal to "response406-17.json"

  Scenario: 18 - Permit access to a resource
    When  I set the "AuthZForce" to the pdp endpoint url with the "domainId"
    And   I set the "Content-Type" header with the value "application/xml"
    And   the body request described in file "request406-18.xml"
    And   I send a POST HTTP request to that url
    Then  I receive a HTTP "200" response code from AuthZForce with the body equal to "response406-18.xml"
