Feature: test tutorial 202.Introduction to IoT Sensors

  This is the feature file of the FIWARE Step by Step tutorial for IoT Sensors - NGSI-LD
  url: https://ngsi-ld-tutorials.readthedocs.io/en/latest/iot-agent.html
  git-clone: https://github.com/FIWARE/tutorials.IoT-Agent.git
  git-directory: /tmp/tutorials.IoT-Agent
  # services orion | scorpio
  shell-commands: git checkout NGSI-LD ; ./services create ; ./services ${CB_ENVIRONMENT:-orion}
  clean-shell-commands: ./services stop


  Background:
    Given I set the tutorial 202 LD

  Scenario: Checking the IoTAGent Service health
    When  I send GET HTTP request to "http://localhost:4041/iot/about"
    Then  I receive a HTTP "200" response code from IoTAgent with the body "response202-01.json" and exclusions "01.excludes"

  Scenario Outline: Provisioning a service Group and a device
    When  I prepare a POST HTTP request for "<description>" to "<url>"
    And   I set header fiware-service to openiot
    And   I set header fiware-servicepath to /
    And   I set the body request as described in <file>
    And   I perform the request
    Then  I receive a HTTP response with status 201 and empty dict
    Examples:
      | url                                | file            | description         |
      | http://localhost:4041/iot/services | 02.request.json | Provision a service |
      | http://localhost:4041/iot/devices  | 03.request.json | Provision a device  |

  Scenario: Simulate a dummy IoT device measurement coming from the Temperature Sensor device  - Request 4
    When I prepare a POST HTTP request to "http://localhost:7896/iot/d?k=4jggokgpepnvsb2uv4s40d59ov&i=temperature001"
    And   I set header Content-Type to text/plain
    And   I set the body text to t|3
    And   I perform the request
    Then  I receive a HTTP "200" response code
    And   I wait "1" seconds

  Scenario: Querying the temperature in the context Broker
    When  I prepare a GET HTTP request to "http://localhost:1026/ngsi-ld/v1/entities/urn:ngsi-ld:Device:temperature001?attrs=temperature"
    And   I set header fiware-service to openiot
    And   I set header fiware-servicepath to /
    And   I set header Link to <http://context/ngsi-context.jsonld>; rel="http://www.w3.org/ns/json-ld#context"; type="application/ld+json"
    And   I perform the query request
    Then  I receive a HTTP "200" response code from Broker with the body "05.response.json" and exclusions "05.excludes"

  Scenario: Req 6 - Create a new entity sending a meassure
    When  I prepare a POST HTTP request to "http://localhost:7896/iot/d?k=4jggokgpepnvsb2uv4s40d59ov&i=motion003"
    And   I set header Content-Type to text/plain
    And   I set the body text to c|1
    And   I perform the request
    Then  I receive a HTTP "200" response code
    And   I wait "1" seconds

  Scenario: Req 7 - Test the value of the new device
    When  I prepare a GET HTTP request to "http://localhost:1026/ngsi-ld/v1/entities/?type=Device"
    And   I set header fiware-service to openiot
    And   I set header fiware-servicepath to /
    And   I set header Link to <http://context/ngsi-context.jsonld>; rel="http://www.w3.org/ns/json-ld#context"; type="application/ld+json"
    And   I perform the query request
    And   I filter the result with jq '.[]|select(.id == "urn:ngsi-ld:Device:motion003")'
    Then  I receive a HTTP "200" response code from Broker with the body "07.response.json" and exclusions "07.excludes"

  Scenario: Req 8 - Providing an actuator - water001 device
    When  I prepare a POST HTTP request to "http://localhost:4041/iot/devices"
    And   I set header fiware-service to openiot
    And   I set header fiware-servicepath to /
    And   I set the body request as described in 08.request.json
    And   I perform the request
    Then  I receive a HTTP response with status 201 and empty dict
    And   I wait "1" seconds

  Scenario: Req 9 -- Test the configuration for new Water001 device
    When  I prepare a PATCH HTTP request to "http://localhost:4041/ngsi-ld/v1/entities/urn:ngsi-ld:Device:water001/attrs/on"
    And   I set header fiware-service to openiot
    And   I set header fiware-servicepath to /
    And   I set the body request as described in activate.things.request.json
    And   I perform the request
    Then  I receive a HTTP response with status 204 and empty dict

  # Fail Dictionary comparison... properties "on" and "off" are different in tutorial than softw.
  Scenario: Req 10 -- Read the result of the command by querying the CB
    When  I prepare a GET HTTP request to "http://localhost:1026/ngsi-ld/v1/entities/urn:ngsi-ld:Device:water001"
    And   I set header Accept to application/json
    And   I set header NGSILD-Tenant to openiot
    And   I set header Link to <http://context/ngsi-context.jsonld>; rel="http://www.w3.org/ns/json-ld#context"; type="application/ld+json"
    And   I perform the query request
    Then  I receive a HTTP "200" response code from Broker with the body "10.response.json" and exclusions "10.excludes"

  Scenario Outline: Req 11, 12 - Provisioning filling station and tractor
    When  I prepare a POST HTTP request for "<description>" to "http://localhost:4041/iot/devices"
    And   I set header fiware-service to openiot
    And   I set header fiware-servicepath to /
    And   I set the body request as described in <file>
    And   I perform the request
    Then  I receive a HTTP response with status 201 and empty dict
    Examples:
      | url                                | file            | description                 |
      | http://localhost:4041/iot/services | 11.request.json | Provision a filling station |
      | http://localhost:4041/iot/devices  | 12.request.json | Provision a tractor         |

  Scenario: Req 13 - Querying devices
    Given I wait "2" seconds
    When  I prepare a GET HTTP request to "http://localhost:4041/iot/devices"
    And   I set header fiware-service to openiot
    And   I set header fiware-servicepath to /
    And   I perform the query request
    Then  I receive a HTTP "200" response code


  Scenario Outline: Req 14, 15, 16 - Activating things with actuators
    When  I prepare a PATCH HTTP request for "<description>" to "http://localhost:1026/ngsi-ld/v1/entities/urn:ngsi-ld:Device:<device>/attrs/<attr>"
    And   I set header content-type to application/json
    And   I set header NGSILD-Tenant to openiot
    And   I set header Link to <http://context/ngsi-context.jsonld>; rel="http://www.w3.org/ns/json-ld#context"; type="application/ld+json"
    And   I set header fiware-service to openiot
    And   I set header fiware-servicepath to /
    And   I set the body request as described in <file>
    And   I perform the request
    Then  I receive a HTTP response with status 204 and empty dict
    Examples:
      | file                         | device     | attr  | description            |
      | activate.things.request.json | water001   | on    | Act. irrigation system |
      | activate.things.request.json | tractor001 | start | Act. tractor           |
      | activate.things.request.json | filling001 | add   | Act. filling system    |

  ###
  ###   Service Group CRUD Actions

  ## Will fail 409 - Conflict since the service is already provisioned
  Scenario: Req 17 - Provisining a service Group for CRUD operations
    When  I prepare a POST HTTP request to "http://localhost:4041/iot/services"
    And   I set header fiware-service to openiot
    And   I set header fiware-servicepath to /
    And   I set the body request as described in 17.request
    And   I perform the request
    Then  I receive a HTTP response with status 201 and empty dict

  Scenario Outline: Req 18 and 19 - Read service group details
    When  I prepare a GET HTTP request to "http://localhost:4041/iot/<what>"
    And   I set header fiware-service to openiot
    And   I set header fiware-servicepath to /
    And   I perform the query request
    Then  I receive a HTTP "200" response code from IoTA with the body "<response_file>" and exclusions "<excludes_file>"
    Examples:
      | what                     | response_file    | excludes_file |
      | services?resource=/iot/d | 18.response.json | 18.excludes   |
      | services                 | 19.response.json | 19.excludes   |

  Scenario: Req 20 - Update a service Group
    When  I prepare a PUT HTTP request to "http://localhost:4041/iot/services?resource=/iot/d&apikey=4jggokgpepnvsb2uv4s40d59ov"
    And   I set header fiware-service to openiot
    And   I set header fiware-servicepath to /
    And   I set the body request as described in 20.request.json
    And   I perform the request
    Then  I receive a HTTP response with status 204 and empty dict

  Scenario: Req 21 - Delete a service Group
    When  I prepare a DELETE HTTP request to "http://localhost:4041/iot/services?resource=/iot/d&apikey=4jggokgpepnvsb2uv4s40d59ov"
    And   I set header fiware-service to openiot
    And   I set header fiware-servicepath to /
    And   I perform the query request
    Then  I receive a HTTP response with status 204 and empty dict

  Scenario: Req 22 - Creating a provisioned device Water002
    When  I prepare a POST HTTP request to "http://localhost:4041/iot/devices"
    And   I set header fiware-service to openiot
    And   I set header fiware-servicepath to /
    And   I set the body request as described in 22.request.json
    And   I perform the request
    Then  I receive a HTTP response with status 201 and empty dict

  Scenario: Req 23 - Querying devices
    Given I wait "2" seconds
    When  I prepare a GET HTTP request to "http://localhost:4041/iot/devices/water002"
    And   I set header fiware-service to openiot
    And   I set header fiware-servicepath to /
    And   I perform the query request
    Then  I receive a HTTP "200" response code from IoTA with the body "23.response.json" and exclusions "23.excludes"

  Scenario: Req 24 - List all provisioned devices
    Given I wait "2" seconds
    When  I prepare a GET HTTP request to "http://localhost:4041/iot/devices"
    And   I set header fiware-service to openiot
    And   I set header fiware-servicepath to /
    And   I perform the query request
    Then  I receive a HTTP "200" status code response
    And   I validate against jq '.count>=5'

  # Strange error 200-ok with message:
  # {"name":"ENTITY_GENERIC_ERROR","message":"Error accesing entity data for device: water002 of type: IoT-Device"}
  Scenario: Req 25 - Update a provisioned device
    When  I prepare a PUT HTTP request to "http://localhost:4041/iot/devices/water002"
    And   I set header fiware-service to openiot
    And   I set header fiware-servicepath to /
    And   I set the body request as described in 25.request.json
    And   I perform the request
    Then  I receive a HTTP response with status 200 and empty dict

  Scenario: Req 26 - Delete a provisioned device
    When  I prepare a DELETE HTTP request to "http://localhost:4041/iot/devices/water002"
    And   I set header fiware-service to openiot
    And   I set header fiware-servicepath to /
    And   I perform the query request
    Then  I receive a HTTP response with status 204 and empty dict
