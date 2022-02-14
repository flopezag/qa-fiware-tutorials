Feature: Test tutorial 404.Securing microservices with a pep proxy PEP Proxy (IoT Agent - Southport)
  This is feature file of the FIWARE step by step tutorial for securing microservices
  with a PEP Proxy (IoT Agent - Southport)
  url: https://fiware-tutorials.readthedocs.io/en/latest/pep-proxy.html
  git-clone: https://github.com/FIWARE/tutorials.PEP-Proxy.git
  git-directory: /tmp/tutorials.PEP-Proxy
  shell-commands: ./services create; ./services southport
  clean-shell-commands: ./services stop

  Background:
    Given I set the tutorial 404

  Scenario: 15 - Keyrock - IoT Sensor obtains an access token
    When  I set the "Authorization" header with the value "Basic dHV0b3JpYWwtZGNrci1zaXRlLTAwMDAteHByZXNzd2ViYXBwOnR1dG9yaWFsLWRja3Itc2l0ZS0wMDAwLWNsaWVudHNlY3JldA=="
    And   I set the "Content-Type" header with the value "application/x-www-form-urlencoded"
    And   I set the "Accept" header with the value "application/json"
    And   I set the url to "http://localhost:3005/oauth2/token"
    And   the data equal to "username=iot_sensor_00000000-0000-0000-0000-000000000000&password=test&grant_type=password"
    And   I send a POST HTTP request to that url
    Then  I receive a HTTP "200" status code from Keyrock with the following data
            | access_token | token_type | expires_in | refresh_token |
            | any          | Bearer     | 3599       | any           |

  Scenario: 16 - PEP Proxy - Accessing IoT Agent with an access token
    When  I set the X-Auth-Token header with the previous obtained token
    And   I set the "Content-Type" header with the value "text/plain"
    And   I set the url to "http://localhost:7896/iot/d?k=4jggokgpepnvsb2uv4s40d59ov&i=motion001"
    And   the data equal to "c|1"
    And   I send a POST HTTP request to that url
    Then  I receive a HTTP "201" status code from Keyrock with the following data for an iot agent
            | id  | password |
            | any | any      |
    Then  fail: DEVICE_GROUP_NOT_FOUND: Couldn't find device group for fields: ["resource", "apikey"] and values: {"resource":"/iot/d", "apikey": "4jggokgpepnvsb2uv4s40d59ov"}
