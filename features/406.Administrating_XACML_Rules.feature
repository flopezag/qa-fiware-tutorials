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
    Then  I receive a HTTP "200" response code from AuthZForce with the body "response406-01.xml"

  Scenario: 02 - Request a decision from AuthZForce
    When  I set the "AuthZForce" to the pdp endpoint url with the "domainId"
    And   I set the "Content-Type" header with the value "application/xml"
    And   the body request described in file "request406-02.xml"
    And   I send a POST HTTP request to that url
    Then  I receive a HTTP "200" response code from AuthZForce with the body "response406-02.xml"

  Scenario: 03 - Creating an initial policy set
    When  I set the "AuthZForce" pap policies url with the "domainId"
    And   I set the "Content-Type" header with the value "application/xml"
    And   the body request described in file "request406-03.xml"
    And   I send a POST HTTP request to that url
    Then  I receive a HTTP "200" response code from AuthZForce with the body "response406-03.xml"

  Scenario: 04 - Activating the initial policy set
curl -X PUT \
  http://localhost:8080/authzforce-ce/domains/{domain-id}/pap/pdp.properties \
    When  I set the "AuthZForce" pap policies with pdp.properties url with the "domainId"
    And   I set the "Content-Type" header with the value "application/xml"
    And   the body request described in file "request406-04.xml"
    And   I send a PUT HTTP request to that url
    Then  I receive a HTTP "200" response code from AuthZForce with the body "response406-04.xml"

  Scenario: 05 - Request to access to loading in the white zone

  Scenario: 06 - Request to access to loading in the red zone

  Scenario: 07 - Updating a policy set

  Scenario: 08 - Activating an updated policy set

  Scenario: 09 - Request to access to loading in the white zone again

  Scenario: 10 - Request to access to loading in the red zone again

  Scenario: 11 - Create a token with password

  Scenario: 12 - Read a Verb-resource permission

  Scenario: 13 - Read a XACML rule permission

  Scenario: 14 - Deny access to a resource

  Scenario: 15 - Update an XACML permission

  Scenario: 16 - Passing the updated policy set to AuthZForce

  Scenario: 17 - Recreating the policy set

  Scenario: 18 - Permit access to a resource