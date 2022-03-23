Feature: test tutorial 303 PROCESSING & HISTORY MANAGEMENT » SHORT TERM HISTORY

  This is the feature file of the FIWARE Step by Step tutorial for Time-Series for short term history
  url: https://fiware-tutorials.readthedocs.io/en/latest/short-term-history.html
  git-clone: https://github.com/FIWARE/tutorials.Short-Term-History.git
  git-directory: /tmp/tutorials.Short-Term-History
  shell-commands: ./services create; export $(cat .env | grep '#' -v) && ./services sth-comet
  clean-shell-commands: ./services stop

## ./services sth-comet seems to do nothing... We need to previously export
#

# STH-COMET - CHECKING SERVICE HEALTH

Background:
   Given I set the tutorial 303


# STH-Comet - Checking Service Health
# 1 - Request
 Scenario: Checking sth service health
   When  I prepare a GET HTTP request to "http://localhost:8666/version"
   And   I perform the query request
   Then  I receive a HTTP "200" status code response

# Minimal mode - Subscribing STH-Comet to Context Changes
# 2 - Request - Subscribing STH Coment to Context Changes
  Scenario: 2. Subscribe sht-comet to changes in Orion
    When  I prepare a POST HTTP request to "http://localhost:1026/v2/subscriptions/"
    And   I set header fiware-service to openiot
    And   I set header fiware-servicepath to /
    And   I set the body request as described in 02.req.SubsbribeSthComent.json
    And   I perform the request
    Then  I receive a HTTP response with status 201 and empty dict

# 3 - Request - Subscribing STH Coment to Lamp luminosity
  Scenario: 3. Subscribe sht-comet to changes in luminosity
    When  I prepare a POST HTTP request to "http://localhost:1026/v2/subscriptions/"
    And   I set header fiware-service to openiot
    And   I set header fiware-servicepath to /
    And   I set the body request as described in 03.req.SubscribeSthLampLuminosity.json
    And   I perform the request
    Then  I receive a HTTP response with status 201 and empty dict

 # 4 - Request - Test ORION Subsbriptions -- "The result should not be empty"
  Scenario: 4. Test that there are subscriptions in Orion
    When  I prepare a GET HTTP request to "http://localhost:1026/v2/subscriptions/"
    And   I set header fiware-service to openiot
    And   I set header fiware-servicepath to /
    And   I perform the query request
    Then  I receive a HTTP "200" response code


 # 4.5 - Request - Populate Lamp:001 history with curls
 Scenario Outline: Communicating with IoT Devices: Using Actuators
    # When  I prepare a POST HTTP request to "http://localhost:7896/iot/d?k=3314136&i=lamp001"
    When  I prepare a POST HTTP request to "http://localhost:7896/iot/d?k=<key_value>&i=<sensor>"
    And   I set header fiware-service to openiot
    And   I set header fiware-servicepath to /
    And   I set header Content-Type to text/plain
    And   I set simple sensor values as described in "<sensor_value>"
    And   I perform the request
    Then  I receive a HTTP "200" response code
    And   I wait "5" seconds
    Examples:
        | sensor_value   | key_value  | sensor    |
        | s\|ON\|l\|1750 | 3314136    | lamp001   |
        | c\|1           | 1068318794 | motion001 |
        | s\|ON\|l\|1800 | 3314136    | lamp001   |
        | c\|0           | 1068318794 | motion001 |
        | s\|ON\|l\|1775 | 3314136    | lamp001   |
        | c\|1           | 1068318794 | motion001 |
        | s\|ON\|l\|1725 | 3314136    | lamp001   |
        | c\|0           | 1068318794 | motion001 |
        | s\|ON\|l\|1760 | 3314136    | lamp001   |
        | c\|1           | 1068318794 | motion001 |
        | s\|ON\|l\|1790 | 3314136    | lamp001   |
        | c\|0           | 1068318794 | motion001 |
        | s\|ON\|l\|1810 | 3314136    | lamp001   |
        | c\|1           | 1068318794 | motion001 |
        | s\|ON\|l\|1830 | 3314136    | lamp001   |
        | c\|0           | 1068318794 | motion001 |
        | s\|ON\|l\|1720 | 3314136    | lamp001   |
        | c\|1           | 1068318794 | motion001 |
        | s\|ON\|l\|1550 | 3314136    | lamp001   |
        | c\|0           | 1068318794 | motion001 |

 Scenario: Just wait for a while -- Let's complet a minute
   Given I wait "30" seconds

# Request - Test lamp and motion sensors 5 y 6
  Scenario Outline: Test Lamp and motion history. After 1 minute
    When  I prepare a GET HTTP request to "http://localhost:8666/STH/v1/contextEntities/type/<type>/id/<sensor>/attributes/<attribute>?hLimit=<hlimit>&hOffset=<offset>"
    And   I set header fiware-service to openiot
    And   I set header fiware-servicepath to /
    And   I perform the query request
    Then  I receive a HTTP "200" response code
    And   I validate against JQ <jqExpr>
    # TODO - Test the results with json
    Examples:
      | type   | attribute  | sensor     | hlimit | offset | jqExpr |
      | Lamp   | luminosity | Lamp:001   | 3      | 0      | .contextResponses[0].contextElement.attributes[] \| select(.name == "luminosity").values \| length == 3  |
      | Motion | count      | Motion:001 | 3      | 3      | .contextResponses[0].contextElement.attributes[] \| select(.name == "count").values \| length == 3       |

# Request 7 -- List the latest N elements (3 in this case)
  Scenario Outline: List the latest elements
    When  I prepare a GET HTTP request to "http://localhost:8666/STH/v1/contextEntities/type/<type>/id/<sensor>/attributes/<attribute>?lastN=<lastN>"
    And   I set header fiware-service to openiot
    And   I set header fiware-servicepath to /
    And   I perform the query request
    Then  I receive a HTTP "200" response code
    And   I validate against JQ <jqExpr>
    # TODO - Test the results with json
    Examples:
      | type   | attribute  | sensor     | lastN | jqExpr |
      | Motion | count      | Motion:001 | 3     | .contextResponses[0].contextElement.attributes[] \| select(.name == "count").values \| length == 3 |

# Request 8 & 9 -- Aggregation over a perid (minute)
# Request 10 & 11 -- Min and Max over a period (minute)
  Scenario Outline: List the latest elements
    When  I prepare a GET HTTP request to "http://localhost:8666/STH/v1/contextEntities/type/<type>/id/<sensor>/attributes/<attribute>?aggrMethod=<aggrMethod>&aggrPeriod=<aggrPeriod>"
    And   I set header fiware-service to openiot
    And   I set header fiware-servicepath to /
    And   I perform the query request
    Then  I receive a HTTP "200" response code
    And   I validate against JQ <jqExpr>
    # TODO - Test the results with json
    Examples:
      | type   | attribute  | sensor     | aggrMethod | aggrPeriod | jqExpr |
      | Motion | count      | Motion:001 | sum        | minute     | [.contextResponses[0].contextElement.attributes[0].values[].points[].samples] \| add == 10 |
      | Lamp   | luminosity | Lamp:001   | sum        | minute     | [.contextResponses[0].contextElement.attributes[0].values[].points[].samples] \| add == 10 |
      | Lamp   | luminosity | Lamp:001   | max        | minute     | [.contextResponses[0].contextElement.attributes[0].values[].points[].max] \| max == 1830  |
      | Lamp   | luminosity | Lamp:001   | min        | minute     | [.contextResponses[0].contextElement.attributes[0].values[].points[].min] \| min == 1550   |
