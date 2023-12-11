Feature: Test tutorial 407.Securing_Access_OpenID_Connect
  This is feature file of the FIWARE step by step tutorial for Securing Access with OpenID Connect
  url: https://fiware-tutorials.readthedocs.io/en/latest/open-id-connect.html
  git-clone: https://github.com/FIWARE/tutorials.Securing-Access-OpenID-Connect.git
  git-directory: /tmp/tutorials.Securing-Access-OpenID-Connect
  shell-commands: ./services create; ./services start
  clean-shell-commands: ./services stop

  Background:
    Given I set the tutorial 407

  Scenario: 00 - Create token with password
    When   I define the body request described in file "request407-00-00.json"
    And    the content-type header key equal to "application/json"
    And    I send a POST HTTP request to "http://localhost:3005/v1/auth/tokens"
    Then   I receive a HTTP response with the following data in header and payload
      | Status-Code | X-Subject-Token | Connection | data                   | excluded                   |
      | 201         | any             | keep-alive | response407-00-00.json | response407-00-00.excludes |

  Scenario: 00 - Creating an application
curl -iX POST \
  'http://localhost:3005/v1/applications' \
  -H 'Content-Type: application/json' \
  -H 'X-Auth-token: aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa' \
#    When   I set the "Content-Type" header with the value "application/json"
#    And    I set the "X-Auth-token" header with the value "aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa"
    When   I set the X-Auth-Token header with the previous obtained token
    And    I set the "Content-Type" header with the value "application/json"
    And    the body request described in file "request407-00-01.json"
    And    I set the url to "http://localhost:3005/v1/applications"
    And    I send a POST HTTP request to that url
    Then   I receive a HTTP "201" status code from Keyrock with the body "response407-00-01.json" and exclusions "response407-00-01.excludes"
    Then   fail: {'error': {'message': 'Token "aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa" has expired', 'code': 401, 'title': 'Unauthorized'}}

  Scenario: 00 - Enabling OIDC
curl -X PATCH \
  'http://localhost:3005/v1/applications/{{application-id}}' \
  -H 'Content-Type: application/json' \
  -H 'X-Auth-token: aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa' \
  -d '{
  "application": {
    "scope": "openid"
  }
}'
#    When   I set the "Content-Type" header with the value "application/json"
#    And    I set the "X-Auth-token" header with the value "aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa"
    When   I set the X-Auth-Token header with the previous obtained token
    And    I set the "Content-Type" header with the value "application/json"
    And    the body request described in file "request407-00-02.json"
    And    I set the application url with an application id
    And    I send a PATCH HTTP request to that url
    Then   I receive a HTTP "200" response code from Keystone with the body equal to "response407-00-02.json"
    Then   fail: {'error': {'message': 'Token "aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa" has expired', 'code': 401, 'title': 'Unauthorized'}}
