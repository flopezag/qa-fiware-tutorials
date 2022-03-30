Feature: test tutorial 201.Introduction to IoT Sensors

  This is the feature file of the FIWARE Step by Step tutorial for IoT Sensors - NGSI-LD
  url: https://ngsi-ld-tutorials.readthedocs.io/en/latest/iot-agent-json.html
  git-clone: https://github.com/FIWARE/tutorials.IoT-Agent-JSON.git
  git-directory: /tmp/tutorials.IoT-Agent-JSON
  shell-commands: git checkout NGSI-LD ; ./services ${CB_ENVIRONMENT:-orion}
  # clean-shell-commands -- docker kill and docker rm since the services stop not working properly and causing problems in second executions.
  clean-shell-commands: ./services stop ; sleep 2 ; docker kill fiware-iot-agent ; docker kill fiware-orion ; docker rm fiware-iot-agent ; docker rm  fiware-orion


  Background:
    Given I set the tutorial 203 LD

  # Request 1 -
  Scenario: Checking the IoTAGent Service health
    When  I send GET HTTP request to "http://localhost:4041/iot/about"
    Then  I receive a HTTP "200" response code from IoTAgent with the body "01.response.json" and exclusions "01.excludes"

  # Request 2, 3 - Provision service and provision device
  ## Modified json file -- changed /iot/d for /iot/json
  Scenario Outline: Provisining a service Group
    When  I prepare a POST HTTP request for "<description>" to "<url>"
    And   I set header fiware-service to openiot
    And   I set header fiware-servicepath to /
    And   I set the body request as described in <file>
    And   I perform the request
    Then  I receive a HTTP response with status 201 and empty dict
    And   I wait "1" seconds
    Examples:
      | url                                | file            | description         |
      | http://localhost:4041/iot/services | 02.request.json | Provision a service |
      | http://localhost:4041/iot/devices  | 03.request.json | Provision a device  |

  # Request 4 - Set some value to sensor
  Scenario: Sending some simulating it from dummy iot device - Request 4
    When I prepare a POST HTTP request to "http://localhost:7896/iot/json?k=4jggokgpepnvsb2uv4s40d59ov&i=temperature001"
    And   I set header Content-Type to application/json
    And   I set the body request as described in 04.request.json
    And   I perform the request
    Then  I receive a HTTP "200" response code
    And   I wait "1" seconds

  # Request 5
  ## ERR - The headers should be this way, not as explained in the tutorial with fiware-service and fiware-servicepath
  ## ERR - No "@context" in response => failure
  Scenario: Querying the temperature in the context Broker
    When  I prepare a GET HTTP request to "http://localhost:1026/ngsi-ld/v1/entities/urn:ngsi-ld:Device:temperature001?attrs=temperature"
    And   I set header NGSILD-Tenant to openiot
    And   I set header NGSILD-Path to /
    And   I set header Link to <http://context/ngsi-context.jsonld>; rel="http://www.w3.org/ns/json-ld#context"; type="application/ld+json"
    And   I perform the query request
    And   I wait for some debug
    Then  I receive a HTTP "200" response code from Broker with the body "05.response.json" and exclusions "05.excludes"

  Scenario: Req 6 - Create a new entity sending a meassure
    When  I prepare a POST HTTP request to "http://localhost:7896/iot/json?k=4jggokgpepnvsb2uv4s40d59ov&i=motion003"
    And   I set header Content-Type to application/json
    And   I set the body text to {"c": 1}
    And   I perform the request
    Then  I receive a HTTP "200" response code
    And   I wait "1" seconds

  ## ERR - Modified c.value in response.json from "1" to 1 (str to int)
  ## ERR - No "@context" in response => failure
  Scenario: Req 7 - Test the value of the new device
    When  I prepare a GET HTTP request to "http://localhost:1026/ngsi-ld/v1/entities/?type=Device"
    And   I set header NGSILD-Tenant to openiot
    And   I set header NGSILD-Path to /
    And   I set header Link to <http://context/ngsi-context.jsonld>; rel="http://www.w3.org/ns/json-ld#context"; type="application/ld+json"
    And   I perform the query request
    And   I filter the result with jq .[]|select(.id == "urn:ngsi-ld:Device:motion003")
    Then  I receive a HTTP "200" response code from Broker with the body "07.response.json" and exclusions "07.excludes"


  Scenario: Req 8 - Provision an actuator - Water001
    When  I prepare a POST HTTP request to "http://localhost:4041/iot/devices"
    And   I set header fiware-servicepath to /
    And   I set header fiware-service to openiot
    And   I set header Content-Type to application/json
    And   I set the body request as described in 08.request.json
    And   I perform the request
    Then  I receive a HTTP "201" response code
    And   I wait "1" seconds

  Scenario: Req 9 - Run a command in Water001 actuator
    When  I prepare a PATCH HTTP request to "http://localhost:4041/ngsi-ld/v1/entities/urn:ngsi-ld:Device:water001/attrs/on"
    And   I set header fiware-servicepath to /
    And   I set header fiware-service to openiot
    And   I set header Content-Type to application/json
    And   I set the body request as described in 09.request.json
    And   I perform the request
    Then  I receive a HTTP "204" response code
