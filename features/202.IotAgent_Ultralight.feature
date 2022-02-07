Feature: test tutorial 202.Introduction to IoT Agent Ultralight

    This is feature file of the FIWARE step by step tutorial for IoT Agent Ultrlight
    url: https://fiware-tutorials.readthedocs.io/en/latest/iot-agent.html
    git-clone: https://github.com/FIWARE/tutorials.IoT-Agent.git
    git-directory: /tmp/tutorials.IoT-Agent
    shell-commands: ./services create; ./services start
    clean-shell-commands: ./services stop
    NOTE_1: Scenarios 16 and 17 -- the response is not the same in tutorial as IoT agent response
    NOTE_2: Scenarios 15 -- Conflict with previous 02 scenario. Posting the same thing.
    NOTE_3: Scenarios 20 -- Conflicts with previous 07 scenario. Posting the same thing.
    NOTE_4: Scenario 21 -- As scenario 20 conflicts with 07 and the item has been used, things have changed and some attributes are wrong

    Background:
        Given I set the tutorial 202

    Scenario: 01 - Checking the IoT Agent service health
        When  I send GET HTTP request to "http://localhost:4041/iot/about"
        Then  I receive a HTTP "200" response code from IoTAgent with the body "response202-01.json" and exclusions "01.excludes"

    Scenario: 02 - Provisioning a Service Group
        When  I prepare a POST HTTP request to "http://localhost:4041/iot/services"
        And   I set header fiware-service to openiot
        And   I set header fiware-servicepath to /
        And   I set the body request as described in request202-02.json
        And   I perform the request
        Then  I receive a HTTP response with status 201 and empty dict

    Scenario: 03 - Provisioning a Sensor
        When  I prepare a POST HTTP request to "http://localhost:4041/iot/devices"
        And   I set header fiware-service to openiot
        And   I set header fiware-servicepath to /
        And   I set the body request as described in request202-03.json
        And   I perform the request
        Then  I receive a HTTP response with status 201 and empty dict

    Scenario: 04 - Simulate dummy IoT device measurement coming from the Motion Sensor
        When  I prepare a POST HTTP request to "http://localhost:7896/iot/d?k=4jggokgpepnvsb2uv4s40d59ov&i=motion001"
        And   I set the body request as described in request202-04.txt
        And   I set header Content-Type to text/plain
        And   I perform the request
        Then  I simply receive a HTTP response with status 200
        And   I wait "1" seconds

    Scenario: 05 - A measurement has been recorded, by retrieving the entity data from the context broker
        When  I prepare a GET HTTP request to "http://localhost:1026/v2/entities/urn:ngsi-ld:Motion:001"
        And   I set header fiware-service to openiot
        And   I set header fiware-servicepath to /
        And   I set the body request as described in request202-05.json
        And   I perform the query request
        Then  I receive a HTTP "200" response code from Broker with the body "response202-05.json" and exclusions "05.excludes"

    Scenario: 06 - Provisioning an actuator via command
        When  I prepare a POST HTTP request to "http://localhost:4041/iot/devices"
        And   I set header fiware-service to openiot
        And   I set header fiware-servicepath to /
        And   I set the body request as described in request202-06.json
        And   I perform the request
        Then  I receive a HTTP response with status 201 and empty dict

    Scenario: 07 - Provisioning an actuator via a bidirectional attribute
        When  I prepare a POST HTTP request to "http://localhost:4041/iot/devices"
        And   I set header fiware-service to openiot
        And   I set header fiware-servicepath to /
        And   I set the body request as described in request202-07.json
        And   I perform the request
        Then  I receive a HTTP response with status 201 and empty dict

    Scenario: 08 - Testing a command before Wire-up the Context Broker
        When  I prepare a POST HTTP request to "http://localhost:4041/v2/op/update"
        And   I set header fiware-service to openiot
        And   I set header fiware-servicepath to /
        And   I set the body request as described in request202-08.json
        And   I perform the request
        Then  I receive a HTTP response with status 204 and empty dict
        And   I wait "1" seconds

    Scenario: 09 - The result of the command to ring the bell can be read by querying the entity within the Orion Context Broker.
        When  I prepare a GET HTTP request to "http://localhost:1026/v2/entities/urn:ngsi-ld:Bell:001"
        And   I set header fiware-service to openiot
        And   I set header fiware-servicepath to /
        And   I set the body request as described in request202-09.json
        And   I perform the query request
        Then  I receive a HTTP "200" response code from Broker with the body "response202-09.json" and exclusions "09.excludes"

    Scenario: 10 - Provisioning a Smart Door
        When  I prepare a POST HTTP request to "http://localhost:4041/iot/devices"
        And   I set header fiware-service to openiot
        And   I set header fiware-servicepath to /
        And   I set the body request as described in request202-10.json
        And   I perform the request
        Then  I receive a HTTP response with status 201 and empty dict

    Scenario: 11 - Provisioning a Smart Lamp
        When  I prepare a POST HTTP request to "http://localhost:4041/iot/devices"
        And   I set header fiware-service to openiot
        And   I set header fiware-servicepath to /
        And   I set the body request as described in request202-11.json
        And   I perform the request
        Then  I receive a HTTP response with status 201 and empty dict

    Scenario: 12 - The result of the command to ring the bell can be read by querying the entity within the Orion Context Broker.
        When  I prepare a GET HTTP request to "http://localhost:4041/iot/devices"
        And   I set header fiware-service to openiot
        And   I set header fiware-servicepath to /
        And   I set the body request as described in request202-12.json
        And   I perform the query request
        Then  I receive a HTTP "200" response code from Broker with the body "response202-12.json" and exclusions "12.excludes"

    Scenario: 13 - Ringing the Bell
        When  I prepare a POST HTTP request to "http://localhost:1026/v2/entities/urn:ngsi-ld:Bell:001/attrs"
        And   I set header fiware-service to openiot
        And   I set header fiware-servicepath to /
        And   I set the body request as described in request202-13.json
        And   I perform the request
        Then  I receive a HTTP response with status 204 and empty dict

    Scenario: 14 - Opening a Smart Door
        When  I prepare a POST HTTP request to "http://localhost:1026/v2/entities/urn:ngsi-ld:Door:001/attrs"
        And   I set header fiware-service to openiot
        And   I set header fiware-servicepath to /
        And   I set the body request as described in request202-14.json
        And   I perform the request
        Then  I receive a HTTP response with status 204 and empty dict

    Scenario: 14bis - Switching on the smart lamp
        When  I prepare a POST HTTP request to "http://localhost:1026/v2/entities/urn:ngsi-ld:Lamp:001/attrs"
        And   I set header fiware-service to openiot
        And   I set header fiware-servicepath to /
        And   I set the body request as described in request202-14bis.json
        And   I perform the request
        Then  I receive a HTTP response with status 204 and empty dict

    Scenario: 15 - Creating a Service Group
        When  I prepare a POST HTTP request to "http://localhost:4041/iot/services"
        And   I set header fiware-service to openiot
        And   I set header fiware-servicepath to /
        And   I set the body request as described in request202-15.json
        And   I perform the request
        Then  I receive a HTTP response with status 201 and empty dict
        And   I wait "1" seconds
#
    Scenario: 16 - Read the service group details
        When  I prepare a GET HTTP request to "http://localhost:4041/iot/services"
        And   I set header fiware-service to openiot
        And   I set header fiware-servicepath to /
        And   I set the body request as described in request202-16.json
        And   I perform the query request
        Then  I receive a HTTP "200" response code from Broker with the body "response202-16.json" and exclusions "16.excludes"

    Scenario: 17 - List all service groups
        When  I prepare a GET HTTP request to "http://localhost:4041/iot/services"
        And   I set header fiware-service to openiot
        And   I set header fiware-servicepath to /
        And   I set the body request as described in request202-17.json
        And   I perform the query request
        Then  I receive a HTTP "200" response code from Broker with the body "response202-17.json" and exclusions "17.excludes"

    Scenario: 18 - Update a Service Group
        When  I prepare a PUT HTTP request to "http://localhost:4041/iot/services?resource=/iot/d&apikey=4jggokgpepnvsb2uv4s40d59ov"
        And   I set header fiware-service to openiot
        And   I set header fiware-servicepath to /
        And   I set the body request as described in request202-18.json
        And   I break here
        And   I perform the request
        Then  I receive a HTTP response with status 204 and empty dict

    Scenario: 19 - Delete a Service Group
        When  I prepare a DELETE HTTP request to "http://localhost:4041/iot/services/?resource=/iot/d&apikey=4jggokgpepnvsb2uv4s40d59ov"
        And   I set header fiware-service to openiot
        And   I set header fiware-servicepath to /
        And   I perform the query request
        Then  I receive a HTTP response with status 204 and empty dict

    Scenario: 20 - Creating a Provisioned Device
        When  I prepare a PUT HTTP request to "http://localhost:4041/iot/devices"
        And   I set header fiware-service to openiot
        And   I set header fiware-servicepath to /
        And   I set the body request as described in request202-20.json
        And   I perform the request
        Then  I receive a HTTP response with status 201 and empty dict

    Scenario: 21 - Read the provisioned device details
        When  I prepare a GET HTTP request to "http://localhost:4041/iot/devices/bell002"
        And   I set header fiware-service to openiot
        And   I set header fiware-servicepath to /
        And   I perform the query request
        Then  I receive a HTTP "200" response code from Broker with the body "response202-21.json" and exclusions "21.excludes"

    Scenario: 22 - List all provisioned devices
        When  I prepare a GET HTTP request to "http://localhost:4041/iot/devices"
        And   I set header fiware-service to openiot
        And   I set header fiware-servicepath to /
        And   I perform the query request
        Then  I receive a HTTP "200" response code from IoTAgent with the body "response202-22.json" and exclusions "22.excludes"

    Scenario: 23 - Update a Provisioned Device
        When  I prepare a PUT HTTP request to "http://localhost:4041/iot/devices/bell002"
        And   I set header fiware-service to openiot
        And   I set header fiware-servicepath to /
        And   I set the body request as described in request202-23.json
        And   I perform the request
        Then  I receive a HTTP response with status 204 and empty dict

    Scenario: 24 - Delete a Provisioned Device
        When  I prepare a DELETE HTTP request to "http://localhost:4041/iot/devices/bell002"
        And   I set header fiware-service to openiot
        And   I set header fiware-servicepath to /
        And   I perform the query request
        Then  I receive a HTTP response with status 204 and empty dict
