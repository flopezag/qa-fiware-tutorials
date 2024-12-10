Feature: Test tutorial 405.XACML Rules-based Permissions
  This is feature file of the FIWARE step by step tutorial for XACML rules-based permissions
  url: https://fiware-tutorials.readthedocs.io/en/latest/xacml-access-rules.html
  git-clone: https://github.com/FIWARE/tutorials.XACML-Access-Rules.git
  git-directory: /tmp/tutorials.XACML-Access-Rules
  shell-commands: git checkout NGSI-v2 ; ./services create ; ./services start
  clean-shell-commands: ./services stop

  Background:
    Given I set the tutorial 405

  Scenario: 01 - AuthZForce - Obtain version information
    When  I set the "Accept" header with the value "application/xml"
    And   I set the url to "http://localhost:8080/authzforce-ce/version"
    And   I send a GET HTTP request to that url
    Then  I receive a HTTP "200" response code from AuthZForce with the body equal to "response405-01.json"

  Scenario: 02 - AuthZForce - List all domains
    When  I set the url to "http://localhost:8080/authzforce-ce/domains"
    And   I send a GET HTTP request to that url
    Then  I receive a HTTP "200" response code from AuthZForce with the body equal to "response405-02.json"

  Scenario: 03 - AuthZForce - Read a single domain
    When  I set the "AuthZForce" domains url with the "domainId"
    And   I send a GET HTTP request to that url
    Then  I receive a HTTP "200" response code from AuthZForce with the body equal to "response405-03.json"

  Scenario: 04 - AuthZForce - List all PolicySets available within a domain
    When  I set the "AuthZForce" pap policies url with the "domainId"
    And   I send a GET HTTP request to that url
    Then  I receive a HTTP "200" response code from AuthZForce with the body equal to "response405-04.json"

  Scenario: 05 - AuthZForce - List the available revisions of a policyset
    When  I set the "AuthZForce" a pap policy set url with the "domainId" and "policyId"
    And   I send a GET HTTP request to that url
    Then  I receive a HTTP "200" response code from AuthZForce with the body equal to "response405-05.xml"

  Scenario: 06 - AuthZForce - Read a single version of a PolicySet
    When  I set the "AuthZForce" to a single version of a pap policy set url with the "domainId" and "policyId"
    And   I send a GET HTTP request to that url
    Then  I receive a HTTP "200" response code from AuthZForce with the body equal to "response405-06.xml"

  Scenario: 07 - AuthZForce - Permit access to a resource
    When  I set the "AuthZForce" to the pdp endpoint url with the "domainId"
    And   I set the "Content-Type" header with the value "application/xml"
    And   the body request described in file "request405-07.xml"
    And   I send a POST HTTP request to that url
    Then  I receive a HTTP "200" response code from AuthZForce with the body equal to "response405-07.xml"

  Scenario: 08 - AuthZForce - Deny access to a resource
    When  I set the "AuthZForce" to the pdp endpoint url with the "domainId"
    And   I set the "Content-Type" header with the value "application/xml"
    And   the body request described in file "request405-08.xml"
    And   I send a POST HTTP request to that url
    Then  I receive a HTTP "200" response code from AuthZForce with the body equal to "response405-08.xml"

  Scenario: 09 - Keystone - User obtain an access token
    When  I set the "Authorization" header with the value "Basic dHV0b3JpYWwtZGNrci1zaXRlLTAwMDAteHByZXNzd2ViYXBwOnR1dG9yaWFsLWRja3Itc2l0ZS0wMDAwLWNsaWVudHNlY3JldA=="
    And   I set the "Content-Type" header with the value "application/x-www-form-urlencoded"
    And   I set the "Accept" header with the value "application/json"
    And   I set the url to "http://localhost:3005/oauth2/token"
    And   the data equal to "username=bob-the-manager@test.com&password=test&grant_type=password"
    And   I send a POST HTTP request to that url
    Then  I receive a HTTP "200" status code from Keyrock with the following data
            | access_token | token_type | scope         |
            | any          | Bearer     | ["permanent"] |

  Scenario: 10 - Keystone - Obtain roles and domain
    When  I set the user url to obtain roles and domain with the following data
            | access_token | app_id                               |
            | access_token | tutorial-dckr-site-0000-xpresswebapp |
    And   I send a GET HTTP request to that url with no headers
    Then  I receive a HTTP "200" response code from Keyrock with the body equal to "response405-10.json"

  Scenario: 11 - AuthZForce - Apply a policy to a request
    When  I set the "AuthZForce" to the pdp endpoint url with the "domainId"
    And   I set the "Content-Type" header with the value "application/xml"
    And   the body request described in file "request405-11.xml"
    And   I send a POST HTTP request to that url
    Then  I receive a HTTP "200" response code from AuthZForce with the body equal to "response405-11.xml"
