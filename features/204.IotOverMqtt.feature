Feature: Test tutorial 204.IoT Agent over MQTT
    This is feature file of the FIWARE step by step tutorial for IoT Agent Ultrlight
    url: https://fiware-tutorials.readthedocs.io/en/latest/iot-over-mqtt.html
    git-clone: https://github.com/FIWARE/tutorials.IoT-over-MQTT.git
    git-directory: /tmp/tutorials.IoT-over-MQTT
    shell-commands: ./services create; ./services start
    clean-shell-commands: ./services stop

    Background:
        Given I set the tutorial 204

    Scenario: 01 - Checking the IoT Agent service health
        When  I send GET HTTP request to "http://localhost:4041/iot/about"
        Then  I receive a HTTP "200" response code with the body "response204-01.json" and exclusions "01.excludes"

    Scenario: 02 - Provisioning a Service Group
        When  I send POST HTTP request to "http://localhost:4041/iot/services"
        And  With body request and headers described in file "request204-02.json" and headers fiware-service "openiot" and fiware-servicepath "/"
        Then  I receive an HTTP response with the code "201" and empty dict


    Scenario: 03 - Provisioning a Sensor
        When  I send POST HTTP request to "http://localhost:4041/iot/devices"
        And  With body request and headers described in file "request204-03.json" and headers fiware-service "openiot" and fiware-servicepath "/"
        Then  I receive an HTTP response with the code "201" and empty dict
        # And   I wait "1" seconds

    Scenario: 04 - Publish data with mqtt-request
        When  I run script "command204-04.sh"
        Then  I expect exit code to be "0"

    Scenario: 05 - The Motion Sensor device with id=motion001 has been successfully identified by the IoT Agent and mapped to the entity id=urn:ngsi-ld:Motion:001
        When  I send IoT "GET" HTTP request with data to "http://localhost:1026/v2/entities/urn:ngsi-ld:Motion:001" With headers fiware-service "openiot" and fiware-servicepath "/" and data is "request204-05.json"
        Then I receive a HTTP "200" response code with the body "response204-05.json" and exclusions "05.excludes"

    Scenario: 06 - Provisioning an Actuator
        When  I send POST HTTP request to "http://localhost:4041/iot/devices"
        And   With body request and headers described in file "request204-06.json" and headers fiware-service "openiot" and fiware-servicepath "/"
        Then  I receive an HTTP response with the code "201" and empty dict

    Scenario: 07 - test that a command can be send to a device by making a REST request directly
        When  I send POST HTTP request to "http://localhost:4041/v2/op/update"
        And   With body request and headers described in file "request204-07.json" and headers fiware-service "openiot" and fiware-servicepath "/"
        Then  I receive an HTTP response with the code "204" and empty dict
        And   I wait "1" seconds

     Scenario: 08 - Read the result of the previous command (Ring a bell)
        When  I send IoT "GET" HTTP request with data to "http://localhost:1026/v2/entities/urn:ngsi-ld:Bell:001" With headers fiware-service "openiot" and fiware-servicepath "/" and data is "request204-08.json"
        Then I receive a HTTP "200" response code with the body "response204-08.json" and exclusions "08.excludes"

     Scenario: 09 - Provisioning a smart Door
        When  I send POST HTTP request to "http://localhost:4041/iot/devices"
        And   With body request and headers described in file "request204-09.json" and headers fiware-service "openiot" and fiware-servicepath "/"
        Then  I receive an HTTP response with the code "201" and empty dict

     Scenario: 10 - Provisioning a smart Lamp
        When  I send POST HTTP request to "http://localhost:4041/iot/devices"
        And   With body request and headers described in file "request204-10.json" and headers fiware-service "openiot" and fiware-servicepath "/"
        Then  I receive an HTTP response with the code "201" and empty dict

     Scenario: 11 - Quering all the devices
        When  I send IoT "GET" HTTP request with data to "http://localhost:4041/iot/devices" With headers fiware-service "openiot" and fiware-servicepath "/" and data is "empty-data.json"
        Then  I receive a HTTP "200" response code with the body "empty-data.json" and exclusions "11.excludes"

    Scenario: 12 - Ringing a Bell
        When  I send POST HTTP request to "http://localhost:1026/v2/entities/urn:ngsi-ld:Bell:001/attrs"
        And  using "PATCH" HTTP method
        And  With body request and headers described in file "request204-12.json" and headers fiware-service "openiot" and fiware-servicepath "/"
        Then  I receive an HTTP response with the code "204" and empty dict

    Scenario: 13 - Opening a Smart door
        When  I send POST HTTP request to "http://localhost:1026/v2/entities/urn:ngsi-ld:Door:001/attrs"
        And  using "PATCH" HTTP method
        And  With body request and headers described in file "request204-13.json" and headers fiware-service "openiot" and fiware-servicepath "/"
        Then  I receive an HTTP response with the code "204" and empty dict

    Scenario: 14 - Switching on the lamp
        When  I send POST HTTP request to "http://localhost:1026/v2/entities/urn:ngsi-ld:Lamp:001/attrs"
        And  using "PATCH" HTTP method
        And  With body request and headers described in file "request204-14.json" and headers fiware-service "openiot" and fiware-servicepath "/"
        Then  I receive an HTTP response with the code "204" and empty dict
