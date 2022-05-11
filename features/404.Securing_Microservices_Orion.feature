Feature: Test tutorial 404.Securing microservices with a PEP Proxy (Orion)
  This is feature file of the FIWARE step by step tutorial for securing microservices
  with a PEP Proxy (Orion)
  url: https://fiware-tutorials.readthedocs.io/en/latest/pep-proxy.html
  git-clone: https://github.com/FIWARE/tutorials.PEP-Proxy.git
  git-directory: /tmp/tutorials.PEP-Proxy
  shell-commands: ./services create; ./services orion
  clean-shell-commands: ./services stop

  Background:
    Given I set the tutorial 404

  Scenario: 01 - Create token with password
    When   I define the body request described in file "request404-01.json"
    And    the content-type header key equal to "application/json"
    And    I send a POST HTTP request to "http://localhost:3005/v1/auth/tokens"
    Then   I receive a HTTP response with the following data in header and payload
      | Status-Code | X-Subject-Token                      | Connection | data                | excluded                |
      | 201         | any                                  | keep-alive | response404-01.json | response404-01.excludes |

  Scenario: 02 - Get token info
    When  I set the "X-Auth-Token" header with the value "aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa"
    And   I set the "X-Subject-token" header with the value "aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa"
    And   the content-type header key equal to "application/json"
    And   I send a GET HTTP request to the url "http://localhost:3005/v1/auth/tokens"
    Then  I receive a HTTP "200" status code from Keyrock with the body "response404-02.json" and exclusions "response404-02.excludes"

  # {'error': {'message': 'Pep Proxy already registered', 'code': 409, 'title': 'Conflict'}}
  Scenario: 03 - Create a PEP Proxy
    When  I set the "X-Auth-Token" header with the value "aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa"
    And   I set the "Content-Type" header with the value "application/json"
    And   I set the application_id equal to "tutorial-dckr-site-0000-xpresswebapp"
    And   I set the "pep_proxies" url with the "application_id"
    And   I do not specify any payload
    And   I send a POST HTTP request to that url
    Then  I receive a HTTP "200" status code from Keyrock with the following data for a pep proxy
            | id  | password |
            | any | any      |

  Scenario: 04 - Read PEP Proxy details
    When  I set the "X-Auth-Token" header with the value "aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa"
    And   I set the "pep_proxies" url with the "application_id"
    And   I send a GET HTTP request to that url
    Then  I receive a HTTP "200" status code from Keyrock with the following data for a pep proxy
            | id  | oauth_client_id |
            | any | any             |

  Scenario: 05 - Reset password of a PEP Proxy
    When  I set the "X-Auth-Token" header with the value "aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa"
    And   I set the "Content-Type" header with the value "application/json"
    And   I set the "pep_proxies" url with the "application_id"
    And   I do not specify any payload
    And   I send a PATCH HTTP request to that url
    Then  I receive a HTTP "200" status code from Keyrock with the new password

  Scenario: 06 - Delete a PEP Proxy
    When  I set the "X-Auth-Token" header with the value "aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa"
    And   I set the "Content-Type" header with the value "application/json"
    And   I set the "pep_proxies" url with the "application_id"
    And   I send a DELETE HTTP request to that url
    Then  I receive a HTTP "204" status code response

  Scenario: 07 - Create an IoT Agent
    When  I set the "X-Auth-Token" header with the value "aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa"
    And   I set the "Content-Type" header with the value "application/json"
    And   I set the "iot_agents" url with the "application_id"
    And   I do not specify any payload
    And   I send a POST HTTP request to that url
    Then  I receive a HTTP "201" status code from Keyrock with the following data for an iot agent
            | id  | password |
            | any | any      |
    Then  fail: the key received is iot_agent and not iot

  Scenario: 08 - Read IoT Agent details
    When  I set the "X-Auth-Token" header with the value "aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa"
    And   I set the "iot_agents" url with the "application_id" and "iot_agent_id"
    And   I send a GET HTTP request to that url
    Then  I receive a HTTP "200" status code from Keyrock with the following data for an iot agent
            | id  | oauth_client_id |
            | any | any             |

  Scenario: 09 - List IoT Agents
    When  I set the "X-Auth-Token" header with the value "aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa"
    And   I set the "iot_agents" url with the "application_id"
    And   I send a GET HTTP request to that url
    Then  I receive a HTTP "200" status code from Keyrock with the list of iot agents

  Scenario: 10 - Reset password of an IoT Agent
    When  I set the "X-Auth-Token" header with the value "aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa"
    And   I set the "Content-Type" header with the value "application/json"
    And   I set the "iot_agents" url with the "application_id" and "iot_agent_id"
    And   I do not specify any payload
    And   I send a PATCH HTTP request to that url
    Then  I receive a HTTP "200" status code from Keyrock with the new password

  Scenario: 11 - Delete and IoT Agent
    When  I set the "X-Auth-Token" header with the value "aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa"
    And   I set the "iot_agents" url with the "application_id" and "iot_agent_id"
    And   I send a DELETE HTTP request to that url
    Then  I receive a HTTP "204" status code response

  Scenario: 12 - PEP Proxy - No access to orion without an access token
    When  I set the url to "http://localhost:1027/v2/entities/urn:ngsi-ld:Store:001?options=keyValues"
    And   I send a GET HTTP request to that url with no headers
    Then  I receive a HTTP "401" status code response and the following message
            | message                                |
            | Auth-token not found in request header |

  Scenario: 13 - Keyrock - User obtains an access token
    When  I set the "Authorization" header with the value "Basic dHV0b3JpYWwtZGNrci1zaXRlLTAwMDAteHByZXNzd2ViYXBwOnR1dG9yaWFsLWRja3Itc2l0ZS0wMDAwLWNsaWVudHNlY3JldA=="
    And   I set the "Content-Type" header with the value "application/x-www-form-urlencoded"
    And   I set the "Accept" header with the value "application/json"
    And   I set the url to "http://localhost:3005/oauth2/token"
    And   the data equal to "username=alice-the-admin@test.com&password=test&grant_type=password"
    And   I send a POST HTTP request to that url
    Then  I receive a HTTP "200" status code from Keyrock with the following data
            | access_token | token_type | expires_in | refresh_token |
            | any          | Bearer     | 3599       | any           |

  Scenario: 14 - PEP Proxy accessing Orion with an access token
    When  I set the X-Auth-Token header with the previous obtained token
    And   I set the url to "http://localhost:1027/v2/entities/urn:ngsi-ld:Store:001?options=keyValues"
    And   I send a GET HTTP request to that url
    Then  I receive a HTTP "200" response code from Keyrock with the body "response404-14.json"
