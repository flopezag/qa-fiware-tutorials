Feature: Test tutorial 403.Securing application access
    This is feature file of the FIWARE step by step tutorial for securing application access
    url: https://fiware-tutorials.readthedocs.io/en/latest/securing-access.html
    git-clone: https://github.com/FIWARE/tutorials.Securing-Access.git
    git-directory: /tmp/tutorials.Securing-Access
    shell-commands: ./services create; ./services start
    clean-shell-commands: ./services stop

    Background:
        Given I set the tutorial 403

    Scenario: 00 - Generate Authorization header value
        Given I set "ClientID" to "tutorial-dckr-site-0000-xpresswebapp"
        And   I set "ClientSecret" to "tutorial-dckr-site-0000-clientsecret"
        When  I calculate the base64 of this ClientId and ClientSecret
        Then  I obtain the value "dHV0b3JpYWwtZGNrci1zaXRlLTAwMDAteHByZXNzd2ViYXBwOnR1dG9yaWFsLWRja3Itc2l0ZS0wMDAwLWNsaWVudHNlY3JldAo="

    Scenario: 01 - Logging-in with a password
        When  I set the Authorization header token with the calculated value
        And   I set the "Content-Type" header with the value "application/x-www-form-urlencoded"
        And   I set the "Accept" header with the value "application/json"
        And   I set the url to "http://localhost:3005/oauth2/token"
        And   the data equal to "username=alice-the-admin@test.com&password=test&grant_type=password"
        And   I send a POST HTTP request to that url
        Then  I receive a HTTP "200" status code from Keyrock with the following data
            | access_token | token_type | expires_in | refresh_token |
            | any          | Bearer     | 3599       | any           |

    Scenario: 02 - Retrieving user details from an access token
        When  I set the the user url with the previous access_token
        And   I send a GET HTTP request to that url with no headers
        Then  I receive a HTTP "200" response code from Keyrock with the body "response403-02.json"

    Scenario: 03 - Logging in as an application
        When  I set the Authorization header token with the calculated value
        And   I set the "Content-Type" header with the value "application/x-www-form-urlencoded"
        And   I set the "Accept" header with the value "application/json"
        And   I set the url to "http://localhost:3005/oauth2/token"
        And   the data equal to "grant_type=client_credentials"
        And   I send a POST HTTP request to that url
        Then  I receive a HTTP "200" status code from Keyrock with the following data
            | access_token | token_type | expires_in |
            | any          | Bearer     | 3599       |

    Scenario: 04 - Availability check
        When  I set the Authorization header token with the calculated value
        And   I set the "Content-Type" header with the value "application/x-www-form-urlencoded"
        And   I set the "Accept" header with the value "application/json"
        And   I set the url to "http://localhost:3005/oauth2/token"
        And   the data equal to "username=alice-the-admin@test.com&password=test&grant_type=password"
        And   I send a POST HTTP request to that url
        Then  I receive a HTTP "200" status code from Keyrock with the following data
            | access_token | token_type | expires_in | refresh_token |
            | any          | Bearer     | 3599       | any           |

    Scenario: 05 - Refresh access token
        When  I set the Authorization header token with the calculated value
        And   I set the "Content-Type" header with the value "application/x-www-form-urlencoded"
        And   I set the "Accept" header with the value "application/json"
        And   I set the url to "http://localhost:3005/oauth2/token"
        And   the data equal to refresh_token value obtained previously
        And   I send a POST HTTP request to that url
        Then  I receive a HTTP "200" status code from Keyrock with the following data
            | access_token | token_type | expires_in | refresh_token |
            | any          | Bearer     | 3599       | any           |

    # There should be clarified that Application ID is equal to Client ID in the tutorial
    # This scenario works basically because there is no response in the tutorial, therefore
    # we took the expected value as the received value from now on
    Scenario: 06 - Authentication access
        When  I set the the user url with the previous access_token and application_id
        And   I send a GET HTTP request to that url with no headers
        Then  I receive a HTTP "200" response code from Keyrock with the body "response403-06.json"

    Scenario: 07 - Basic authorization
        When  I set the user url with the following data
            | access_token | action | resource           | app_id   |
            | access_token | GET    | /app/price-change  | ClientID |
        And   I send a GET HTTP request to that url with no headers
        Then  I receive a HTTP "200" response code from Keyrock with the body "response403-07.json"

