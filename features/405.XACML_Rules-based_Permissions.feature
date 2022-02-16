Feature: Test tutorial 405.XACML Rules-based Permissions
  This is feature file of the FIWARE step by step tutorial for XACML rules-based permissions
  url: https://fiware-tutorials.readthedocs.io/en/latest/xacml-access-rules.html
  git-clone: https://github.com/FIWARE/tutorials.XACML-Access-Rules.git
  git-directory: /tmp/tutorials.XACML-Access-Rules
  shell-commands: ./services create; ./services start
  clean-shell-commands: ./services stop

  Background:
    Given I set the tutorial 405

  Scenario: 01 - AuthZForce - Obtain version information
    When  I set the "Accept" header with the value "application/xml"
    And   I set the url to "http://localhost:8080/authzforce-ce/version"
    And   I send a GET HTTP request to that url
    Then  I receive a HTTP "200" response code from AuthZForce with the body "response405-01.xml"

  Scenario: 02 - AuthZForce - List all domains
    When  I set the url to "http://localhost:8080/authzforce-ce/domains"
    And   I send a GET HTTP request to that url
    Then  I receive a HTTP "200" response code from AuthZForce with the body "response405-02.xml"

  Scenario: 03 - AuthZForce - Read a single domain
curl -X GET \
  http://localhost:8080/authzforce-ce/domains/gQqnLOnIEeiBFQJCrBIBDA
    When  I set the "AuthZForce" domains url with the "domainId"
    And   I send a GET HTTP request to that url
    Then  I receive a HTTP "200" response code from AuthZForce with the body "response405-03.xml"
