Feature: test tutorial 104.Context Data and Context Providers

    This is feature file of the FIWARE step by step tutorial for Context Data and Context Providers

#
#   Parameters to be considered (aka INTERESTING_FEATURES_STRINGS)
#
    url: https://https://fiware-tutorials.readthedocs.io/en/latest/context-providers.html
    git-clone: https://github.com/FIWARE/tutorials.Context-Providers.git
    git-directory: /tmp/tutorials.Context-Providers
    docker-compose-changes: ;      - "OPENWEATHERMAP_KEY_ID=<ADD_YOUR_KEY_ID>"

    shell-commands: ./services create; ./services start
    clean-shell-commands: ./services stop


    Background:
        Given I set the tutorial 104


#
#   Request 0
#       Note: The expected body in the Tutorial, besides expecting different values,
#             misses two attributes ("machine" and "libversions", the latter being a structured attribute).
#
    Scenario: [0] Checking the Orion service health
        When  I send GET HTTP request to "http://localhost:1026/version"
        Then  I receive a HTTP "200" response code with the body equal to "response101-01.json"

#
#   Request 1
#       Note: The expected body in the Tutorial expects an attribute ("structuredValue") which is not returned.
#
    Scenario: [1] Checking the health of the Static Data Context Provider endpoint
        When  I send GET HTTP request to "http://localhost:3000/health/static"
        Then  I receive a HTTP "200" response code with the body equal to "response104-01.json"


#
#   Request 2
#       Note: This test, when checking the body, will always fail as by definition the answer is random.
#             It can only be checked the statusCode
#
    Scenario: [2] Checking the health of the Random Data Generator Context Provider endpoint
        When  I send GET HTTP request to "http://localhost:3000/health/random"
        Then  I receive a HTTP "200" response code with the body equal to "response104-02.json"


#
#   Request 4
#       Note: The expected body in the Tutorial, besides expecting different (static) values,
#             misses several attributes.
#       Note: This test, when checking the body, will always fail as by definition the answer provides actual values.
#             It can only be checked the statusCode and could be checked if the values for the attributes "temp" and "humidity"
#             have been provided.
#
    Scenario: [4] Weather API Context Provider (Health Check)
        When  I send GET HTTP request to "http://localhost:3000/health/weather"
        Then  I receive a HTTP "200" response code with the body equal to "response104-04.json"


#
#   Request 5
#
    Scenario: [5] Retrieving a Single Attribute Value
        When 104 sends a POST HTTP request to "http://localhost:3000/static/temperature/op/query"
        And  With the 104 body request described in file "request104-05.json"
        Then 104 receives a HTTP "200" response code with the body equal to "response104-05.json"


#
#   Request 6
#       Note: This test, when checking the body, will always fail as by definition the answer is either random, or
#             coming from the actual current weather conditions.
#             It can only be checked the statusCode and it could be checked if the values for the attributes "temp" and "humidity"
#             have been provided.
#
    Scenario: [6] Retrieving a Single Attribute Value
        When 104 sends a POST HTTP request to "http://localhost:3000/random/weatherConditions/op/query"
        And  With the body request described in file "request104-06.json"
        Then 104 receives a HTTP "200" response code with the body equal to "response104-06.json"


#
#   Request 7
#       Note: there are two mistakes in the tutorial:
#             1) in the tutorial request the attribute "temperature" is missing
#             2) (this is github not in readthedocs!!) in the "provider" attribute, if you want to register the openweathermap API
#                the correct statement url is: http://context-provider:3000/weather/weatherConditions
#
    Scenario Outline: [7] Registering a new Context Provider
        When I send POST HTTP request to "http://localhost:1026/v2/registrations"
        And  With the body request described in file "<file>"
        Then I receive a HTTP response with the following data
            | Status-Code | Location   | Connection | fiware-correlator |
            | 201         | Any        | Keep-Alive | Any               |

        Examples:
            | file               | location            |
            | request104-07.json | /v2/registrations/* |


#
#   Request 8
#
    Scenario: [8] New context data is included if the context of the specific entity
        When  I send GET HTTP request to "http://localhost:1026/v2/entities/urn:ngsi-ld:Store:001?type=Store"
        Then  I receive a HTTP "200" response code with the body equal to "response104-08.json"


#
#   Request 9
#       Note: The Tutorial expected value is a percentage (this is in readthedocs while in github is a number!!)
#             while the answer is a number.
#       Note: This test, when checking the body, will always fail as by definition the answer is either random, or
#             coming from the actual current weather conditions.
#             It can only be checked the statusCode and if the value returned is a number.
#
    Scenario: [9] requesting the value of a specific attribute of a specific entity
        When  104 sends a GET HTTP request to "http://localhost:1026/v2/entities/urn:ngsi-ld:Store:001/attrs/relativeHumidity/value"
        Then  104 receives a HTTP "200" response code with the body of type "int"


#
#   Request 10
#       Note: This test cannot be performed as the registration parameter changes every time.
#             A possible solution is to perform Request 11 before Request 10.
#


#
#   Request 11
#       Note: The response in the tutorial misses the attribute: 'legacyForwarding' in attribute "provider".
#
    Scenario: [11] List all registered Context Providers
        When  I send GET HTTP request to "http://localhost:1026/v2/registrations"
        Then  I receive a HTTP "200" response code with the body equal to "response104-11.json"
