Feature: test tutorial 201.Introduction to IoT Sensors

  This is the feature file of the FIWARE Step by Step tutorial for IoT Sensors - NGSI-LD
  url: https://ngsi-ld-tutorials.readthedocs.io/en/latest/iot-agent.html
  git-clone: https://github.com/FIWARE/tutorials.IoT-Agent.git
  git-directory: /tmp/tutorials.IoT-Agent
  # services orion | scorpio
  shell-commands: git checkout NGSI-LD ; ./services create ; ./services orion
  clean-shell-commands: ./services stop


  Background:
    Given I set the tutorial 202 LD

  Scenario: Checking the IoTAGent Service health
    When  I send GET HTTP request to "http://localhost:4041/iot/about"
    Then  I receive a HTTP "200" response code from IoTAgent with the body "response202-01.json" and exclusions "01.excludes"

  Scenario Outline: Provisining a service Group
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

  Scenario: Sending some simulating it from dummy iot device - Request 4
    When I prepare a POST HTTP request to "http://localhost:7896/iot/d?k=4jggokgpepnvsb2uv4s40d59ov&i=temperature001"
    And   I set header fiware-service to openiot
    And   I set header fiware-servicepath to /
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
