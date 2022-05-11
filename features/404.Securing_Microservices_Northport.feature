Feature: Test tutorial 404.Securing microservices with a PEP Proxy (IoT Agent - Northport)
  This is feature file of the FIWARE step by step tutorial for securing microservices
  with a PEP Proxy (IoT Agent - Northport)
  url: https://fiware-tutorials.readthedocs.io/en/latest/pep-proxy.html
  git-clone: https://github.com/FIWARE/tutorials.PEP-Proxy.git
  git-directory: /tmp/tutorials.PEP-Proxy
  shell-commands: ./services create; ./services northport
  clean-shell-commands: ./services stop

  Background:
    Given I set the tutorial 404

  Scenario: 17 - Keyrock - Obtaining a permanent token
    When  I set the "Authorization" header with the value "Basic dHV0b3JpYWwtZGNrci1zaXRlLTAwMDAteHByZXNzd2ViYXBwOnR1dG9yaWFsLWRja3Itc2l0ZS0wMDAwLWNsaWVudHNlY3JldA=="
    And   I set the "Content-Type" header with the value "application/x-www-form-urlencoded"
    And   I set the "Accept" header with the value "application/json"
    And   I set the url to "http://localhost:3005/oauth2/token"
    And   the data equal to "username=alice-the-admin@test.com&password=test&grant_type=password&scope=permanent"
    And   I send a POST HTTP request to that url
    Then  I receive a HTTP "200" status code from Keyrock with the following data
            | access_token | token_type | scope         |
            | any          | Bearer     | ["permanent"] |
    Then  fail: Invalid request: content must be application/x-www-form-urlencoded, but was missing

  Scenario: 18 - IoT Agent - Provisioning a trusted service group
    When  I set the "Content-Type" header with the value "application/json"
    And   I set the "fiware-service" header with the value "openiot"
    And   I set the "fiware-servicepath" header with the value "/"
    And   I set the url to "http://localhost:4041/iot/services?resource=/iot/d&apikey=1068318794"
    And   the provisioning data with the previous access token (trust token) value
    And   I send a PUT HTTP request to that url
    Then  I receive a HTTP "204" status code response

  Scenario: 19 - IoT Agent - Provisioning a sensor
    When  I set the "Content-Type" header with the value "application/json"
    And   I set the "fiware-service" header with the value "openiot"
    And   I set the "fiware-servicepath" header with the value "/"
    And   I set the url to "http://localhost:4041/iot/devices"
    And   the body request described in file "request404-19.json"
    And   I send a POST HTTP request to that url
    Then  fail: SECURITY_INFORMATION_MISSING, Some security information was missing for device type:Motion. Message: {"name":"ENTITY_GENERIC_ERROR","message":"Error accesing entity data for device: motion001 of type: Motion"}
    Then  I receive a HTTP "204" status code from Keyrock with the following data
            | id  | password |
            | any | any      |
