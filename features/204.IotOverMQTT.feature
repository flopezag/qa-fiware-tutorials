Feature: Test tutorial 204.IoT Agent over MQTT
    This is feature file of the FIWARE step by step tutorial for IoT Agent Ultrlight
    url: https://fiware-tutorials.readthedocs.io/en/latest/custom-iot-agent.html
    git-clone: https://github.com/FIWARE/tutorials.IoT-over-MQTT.git
    git-directory: /tmp/tutorials.IoT-over-MQTT
    shell-commands: git checkout NGSI-v2 ; ./services create; ./services start
    clean-shell-commands: ./services stop

    Background:
        Given I set the tutorial 204

    Scenario: 01 - Checking the IoT Agent service health
        When  I send GET HTTP request to "http://localhost:4041/iot/about"
        Then  I receive a HTTP "200" response code from IoTAgent with the body "response204-01.json" and exclusions "01.excludes"

    Scenario: 02 - Provisioning a Service Group
        When  I prepare a POST HTTP request to "http://localhost:4041/iot/services"
        And   I set header fiware-service to openiot
        And   I set header fiware-servicepath to /
        And   I set the body request as described in request204-02.json
        And   I perform the request
        Then  I receive a HTTP response with status 201 and empty dict

    Scenario: 03 - Provisioning a Sensor
        When  I prepare a POST HTTP request to "http://localhost:4041/iot/devices"
        And   I set header fiware-service to openiot
        And   I set header fiware-servicepath to /
        And   I set the body request as described in request204-03.json
        And   I perform the request
        Then  I receive a HTTP response with status 201 and empty dict

    Scenario: 04 - Publish data with mqtt-request
        When  I run script "command204-04.sh"
        Then  I expect exit code to be "0"

    Scenario: 05 - The Motion Sensor device with id=motion001 has been successfully identified by the IoT Agent and mapped to the entity id=urn:ngsi-ld:Motion:001
        When  I prepare a GET HTTP request to "http://localhost:1026/v2/entities/urn:ngsi-ld:Motion:001"
        And   I set header fiware-service to openiot
        And   I set header fiware-servicepath to /
        And   I set the body request as described in request204-05.json
        And   I perform the query request
        Then  I receive a HTTP "200" response code from Broker with the body "response204-05.json" and exclusions "05.excludes"

   Scenario: 06 - Provisioning an Actuator
       When  I prepare a POST HTTP request to "http://localhost:4041/iot/devices"
       And   I set header fiware-service to openiot
       And   I set header fiware-servicepath to /
       And   I set the body request as described in request204-06.json
       And   I perform the request
       Then  I receive a HTTP response with status 201 and empty dict

   Scenario: 07 - test that a command can be send to a device by making a REST request directly
       When  I prepare a POST HTTP request to "http://localhost:4041/v2/op/update"
       And   I set header fiware-service to openiot
       And   I set header fiware-servicepath to /
       And   I set the body request as described in request204-07.json
       And   I perform the request
       Then  I receive a HTTP response with status 204 and empty dict
       And   I wait "10" seconds

    Scenario: 08 - Read the result of the previous command (Ring a bell)
        When  I prepare a GET HTTP request to "http://localhost:1026/v2/entities/urn:ngsi-ld:Bell:001"
        And   I set header fiware-service to openiot
        And   I set header fiware-servicepath to /
        And   I set the body request as described in request204-08.json
        And   I perform the query request
        Then  I receive a HTTP "200" response code from Broker with the body "response204-08.json" and exclusions "08.excludes"

    Scenario: 09 - Provisioning a smart Door
        When  I prepare a POST HTTP request to "http://localhost:4041/iot/devices"
        And   I set header fiware-service to openiot
        And   I set header fiware-servicepath to /
        And   I set the body request as described in request204-09.json
        And   I perform the request
        Then  I receive a HTTP response with status 201 and empty dict

    Scenario: 10 - Provisioning a smart Lamp
        When  I prepare a POST HTTP request to "http://localhost:4041/iot/devices"
        And   I set header fiware-service to openiot
        And   I set header fiware-servicepath to /
        And   I set the body request as described in request204-10.json
        And   I perform the request
        Then  I receive a HTTP response with status 201 and empty dict

    Scenario: 11 - Quering all the devices
        When  I prepare a GET HTTP request to "http://localhost:4041/iot/devices"
        And   I set header fiware-service to openiot
        And   I set header fiware-servicepath to /
        And   I perform the query request
        Then  I receive a HTTP "200" response code from IoTAgent with the body "empty-data.json" and exclusions "11.excludes"

   Scenario: 12 - Ringing a Bell
        When  I prepare a PATCH HTTP request to "http://localhost:1026/v2/entities/urn:ngsi-ld:Bell:001/attrs"
        And   I set header fiware-service to openiot
        And   I set header fiware-servicepath to /
        And   I set the body request as described in request204-12.json
        And   I perform the request
        Then  I receive a HTTP response with status 204 and empty dict

   Scenario: 13 - Opening a Smart door
       When  I prepare a PATCH HTTP request to "http://localhost:1026/v2/entities/urn:ngsi-ld:Door:001/attrs"
       And   I set header fiware-service to openiot
       And   I set header fiware-servicepath to /
       And   I set the body request as described in request204-13.json
       And   I perform the request
       Then  I receive a HTTP response with status 204 and empty dict

   Scenario: 14 - Switching on the lamp
       When  I prepare a PATCH HTTP request to "http://localhost:1026/v2/entities/urn:ngsi-ld:Lamp:001/attrs"
       And   I set header fiware-service to openiot
       And   I set header fiware-servicepath to /
       And   I set the body request as described in request204-14.json
       And   I perform the request
       Then  I receive a HTTP response with status 204 and empty dict
