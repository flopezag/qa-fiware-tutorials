Feature: test tutorial 303 PROCESSING & HISTORY MANAGEMENT » SHORT TERM HISTORY

  This is the feature file of the FIWARE Step by Step tutorial for Time-Series for short term history
  url: https://fiware-tutorials.readthedocs.io/en/latest/short-term-history.html
  git-clone: https://github.com/FIWARE/tutorials.Historic-Context-NIFI.git
  git-directory: /tmp/tutorials.Historic-Context-NIFI
  shell-commands: ./services create; ./services mongodb
  clean-shell-commands: ./services stop

## ./services sth-comet seems to do nothing... We need to previously export
#

# STH-COMET - CHECKING SERVICE HEALTH

Background:
   Given I set the tutorial 302

Scenario:
  Given  I need to wait until things are manualy done in draco

# 1 - Request
 Scenario: Checking draco service health
   When  I prepare a GET HTTP request to "http://localhost:9090/nifi-api/system-diagnostics"
   And   I perform the query request
   Then  I receive a HTTP "200" status code response

# 2 - Request - Subscribing Draco to Context Changes
  Scenario: 2. Subscribe Draco to changes in Orion
    When  I prepare a POST HTTP request to "http://localhost:1026/v2/subscriptions/"
    And   I set header fiware-service to openiot
    And   I set header fiware-servicepath to /
    And   I set the body request as described in 02.req.subscribe.draco.json
    And   I perform the request
    Then  I receive a HTTP response with status 201 and empty dict

 # 2.5 - Request - Populate Lamp:001 history with curls
 Scenario Outline: Communicating with IoT Devices: Using Actuators
    When  I prepare a POST HTTP request to "http://localhost:7896/iot/d?k=<key_value>&i=<sensor>"
    And   I set header fiware-service to openiot
    And   I set header fiware-servicepath to /
    And   I set header Content-Type to text/plain
    And   I set simple sensor values as described in "<sensor_value>"
    And   I substitute in payload ";" for "|"
    And   I perform the request
    Then  I receive a HTTP "200" response code
    And   I wait "3" seconds
    Examples:
        | sensor_value   | key_value  | sensor    |
        | s\|ON\|l\|1750 | 3314136    | lamp001   |
        | c\|1           | 1068318794 | motion001 |
        | s\|CLOSED      | 3089326    | door1     |
        | s\|ON\|l\|1800 | 3314136    | lamp001   |
        | c\|0           | 1068318794 | motion001 |
        | s\|OPEN        | 3089326    | door1     |
        | s\|ON\|l\|1775 | 3314136    | lamp001   |
        | c\|1           | 1068318794 | motion001 |
        | s\|CLOSED      | 3089326    | door1     |
        | s\|ON\|l\|1725 | 3314136    | lamp001   |
        | c\|0           | 1068318794 | motion001 |
        | s\|LOCKED      | 3089326    | door1     |
        | s\|ON\|l\|1760 | 3314136    | lamp001   |
        | c\|1           | 1068318794 | motion001 |
        | s\|CLOSED      | 3089326    | door1     |
        | s\|ON\|l\|1790 | 3314136    | lamp001   |
        | c\|0           | 1068318794 | motion001 |
        | s\|LOCKED      | 3089326    | door1     |
        | s\|ON\|l\|1810 | 3314136    | lamp001   |
        | c\|1           | 1068318794 | motion001 |
        | s\|ON\|l\|1830 | 3314136    | lamp001   |
        | c\|0           | 1068318794 | motion001 |
        | s\|ON\|l\|1720 | 3314136    | lamp001   |
        | c\|1           | 1068318794 | motion001 |
        | s\|ON\|l\|1550 | 3314136    | lamp001   |
        | c\|0           | 1068318794 | motion001 |

 # 3 - Request - Test ORION Subsbriptions -- "The result should not be empty"
  Scenario: 4. Test that there are subscriptions in Orion
    When  I prepare a GET HTTP request to "http://localhost:1026/v2/subscriptions/"
    And   I set header fiware-service to openiot
    And   I set header fiware-servicepath to /
    And   I perform the query request
    Then  I receive a HTTP "200" response code
    And   The timesSent is bigger than 0
    And   The lastNotification should be a recent timestamp
    And   The lastSuccess should match the lastNotification date
    And   The status is "active"

  Scenario:
    Given  I need to wait until things are manualy done in draco
