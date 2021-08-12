Feature: Test tutorial 203.Why are muliple IoT Agents Needed?
    This is feature file of the FIWARE step by step tutorial for IoT Agent Ultrlight
    url: https://fiware-tutorials.readthedocs.io/en/latest/iot-agent-json.html
    git-clone: https://github.com/FIWARE/tutorials.IoT-Agent-JSON.git
    git-directory: /tmp/tutorials.IoT-Agent-JSON
    shell-commands: ./services create; ./services start
    clean-shell-commands: ./services stop

    Background:
        Given I set the tutorial 203

    Scenario: 01 - Checking the IoT Agent service health
        When  I send GET HTTP request to "http://localhost:4041/iot/about"
        Then  I receive a HTTP "200" response code with the body "response203-01.json" and exclusions "01.excludes"

    Scenario: 02 - Provisioning a Service Group
        When  I send POST HTTP request to "http://localhost:4041/iot/services"
        And  With body request and headers described in file "request203-02.json" and headers fiware-service "openiot" and fiware-servicepath "/"
        Then  I receive an HTTP response with the code "201" and empty dict

    Scenario: 03 - Provisioning a Sensor
        When  I send POST HTTP request to "http://localhost:4041/iot/devices"
        And  With body request and headers described in file "request203-03.json" and headers fiware-service "openiot" and fiware-servicepath "/"
        Then  I receive an HTTP response with the code "201" and empty dict
        And   I wait "1" seconds

    Scenario: 04 - Simulate a dummy IoT device measurement coming from the Motion Sensor
        When  I send POST HTTP request to "http://localhost:7896/iot/json?k=4jggokgpepnvsb2uv4s40d59ov&i=motion001"
        And  With the body request described in file "request203-04.json"
        Then  I receive an HTTP response with the code "200" and empty dict

    Scenario: 05 - The Motion Sensor device with id=motion001 has been successfully identified by the IoT Agent and mapped to the entity id=urn:ngsi-ld:Motion:001
        When  I send IoT "GET" HTTP request with data to "http://localhost:1026/v2/entities/urn:ngsi-ld:Motion:001?type=Motion" With headers fiware-service "openiot" and fiware-servicepath "/" and data is "empty-data.json"
        Then I receive a HTTP "200" response code with the body "response203-05.json" and exclusions "05.excludes"

    Scenario: 06 - Provisioning an Actuator
        When  I send POST HTTP request to "http://localhost:4041/iot/devices"
        And   With body request and headers described in file "request203-06.json" and headers fiware-service "openiot" and fiware-servicepath "/"
        Then  I receive an HTTP response with the code "201" and empty dict

    Scenario: 07 - test that a command can be send to a device by making a REST request directly to the IoT Agent's North Port
        When  I send POST HTTP request to "http://localhost:4041/v2/op/update"
        And   With body request and headers described in file "request203-07.json" and headers fiware-service "openiot" and fiware-servicepath "/"
        Then  I receive an HTTP response with the code "204" and empty dict


    ##
    # This Scenario will fail with a minimal error due to a typo:
    #
    # Field "ring_info" should be " ring OK" ; "ring_info" is "OK"
    #
    Scenario: 08 - Read the result of the previous command (Ring a bell)
        When  I send IoT "GET" HTTP request with data to "http://localhost:1026/v2/entities/urn:ngsi-ld:Bell:001?type=Bell&options=keyValues" With headers fiware-service "openiot" and fiware-servicepath "/" and data is "empty-data.json"
        Then I receive a HTTP "200" response code with the body "response203-08.json" and exclusions "08.excludes"

    Scenario: 09 - Provisioning a smart Door
        When  I send POST HTTP request to "http://localhost:4041/iot/devices"
        And   With body request and headers described in file "request203-09.json" and headers fiware-service "openiot" and fiware-servicepath "/"
        Then  I receive an HTTP response with the code "201" and empty dict

    Scenario: 10 - Provisioning a smart Lamp
        When  I send POST HTTP request to "http://localhost:4041/iot/devices"
        And   With body request and headers described in file "request203-10.json" and headers fiware-service "openiot" and fiware-servicepath "/"
        Then  I receive an HTTP response with the code "201" and empty dict

    Scenario: 11 - Quering all the devices
        When  I send IoT "GET" HTTP request with data to "http://localhost:4041/iot/devices" With headers fiware-service "openiot" and fiware-servicepath "/" and data is "empty-data.json"
        Then  I receive a HTTP "200" response code with the body "empty-data.json" and exclusions "11.excludes"