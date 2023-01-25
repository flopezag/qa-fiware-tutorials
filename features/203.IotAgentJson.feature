Feature: Test tutorial 203.Why are multiple IoT Agents Needed?
    This is feature file of the FIWARE step by step tutorial for IoT Agent Ultralight
    url: https://fiware-tutorials.readthedocs.io/en/latest/iot-agent-json.html
    git-clone: https://github.com/FIWARE/tutorials.IoT-Agent-JSON.git
    git-directory: /tmp/tutorials.IoT-Agent-JSON
    shell-commands: docker rm fiware-iot-agent ; ./services create; ./services start
    clean-shell-commands: ./services stop ; docker rm fiware-iot-agent

    Background:
        Given I set the tutorial 203

    Scenario: 01 - Checking the IoT Agent service health
        When  I send GET HTTP request to "http://localhost:4041/iot/about"
        Then  I receive a HTTP "200" response code from IoTAgent with the body "response203-01.json" and exclusions "01.excludes"

    Scenario: 02 - Provisioning a Service Group
        When  I prepare a POST HTTP request to "http://localhost:4041/iot/services"
        And   I set header fiware-service to openiot
        And   I set header fiware-servicepath to /
        And   I set the body request as described in request203-02.json
        And   I perform the request
        Then  I receive a HTTP response with status 201 and empty dict

    Scenario: 03 - Provisioning a Sensor
        When  I prepare a POST HTTP request to "http://localhost:4041/iot/devices"
        And   I set header fiware-service to openiot
        And   I set header fiware-servicepath to /
        And   I set the body request as described in request203-03.json
        And   I perform the request
        Then  I receive a HTTP response with status 201 and empty dict

#        When  I send POST HTTP request to "http://localhost:4041/iot/devices"
#        And  With body request and headers described in file "request203-03.json" and headers fiware-service "openiot" and fiware-servicepath "/"
#        Then  I receive an HTTP response with the code "201" and empty dict
#        And   I wait "1" seconds

    Scenario: 04 - Simulate a dummy IoT device measurement coming from the Motion Sensor
        When  I prepare a POST HTTP request to "http://localhost:7896/iot/json?k=4jggokgpepnvsb2uv4s40d59ov&i=motion001"
        And   I set the body request as described in request203-04.json
        And   I perform the request
        Then  I simply receive a HTTP response with status 200
        And   I wait "1" seconds
#        When  I send POST HTTP request to "http://localhost:7896/iot/json?k=4jggokgpepnvsb2uv4s40d59ov&i=motion001"
#        And  With the body request described in file "request203-04.json"
#        Then  I receive an HTTP response with the code "200" and empty dict

    Scenario: 05 - The Motion Sensor device with id=motion001 has been successfully identified by the IoT Agent and mapped to the entity id=urn:ngsi-ld:Motion:001
        When  I prepare a GET HTTP request to "http://localhost:1026/v2/entities/urn:ngsi-ld:Motion:001?type=Motion"
        And   I set header fiware-service to openiot
        And   I set header fiware-servicepath to /
        And   I perform the query request
        Then  I receive a HTTP "200" response code from Broker with the body "response203-05.json" and exclusions "05.excludes"

#        When  I send IoT "GET" HTTP request with data to "http://localhost:1026/v2/entities/urn:ngsi-ld:Motion:001?type=Motion" With headers fiware-service "openiot" and fiware-servicepath "/" and data is "empty-data.json"
#        Then I receive a HTTP "200" response code from Broker with the body "response203-05.json" and exclusions "05.excludes"


    Scenario: 06 - Provisioning an Actuator
        When  I prepare a POST HTTP request to "http://localhost:4041/iot/devices"
        And   I set header fiware-service to openiot
        And   I set header fiware-servicepath to /
        And   I set the body request as described in request203-06.json
        And   I perform the request
        Then  I receive a HTTP response with status 201 and empty dict
#        When  I send POST HTTP request to "http://localhost:4041/iot/devices"
#        And   With body request and headers described in file "request203-06.json" and headers fiware-service "openiot" and fiware-servicepath "/"
#        Then  I receive an HTTP response with the code "201" and empty dict

    Scenario: 07 - test that a command can be send to a device by making a REST request directly to the IoT Agent's North Port
        When  I prepare a POST HTTP request to "http://localhost:4041/v2/op/update"
        And   I set header fiware-service to openiot
        And   I set header fiware-servicepath to /
        And   I set the body request as described in request203-07.json
        And   I perform the request
        Then  I receive a HTTP response with status 204 and empty dict

#        When  I send POST HTTP request to "http://localhost:4041/v2/op/update"
#        And   With body request and headers described in file "request203-07.json" and headers fiware-service "openiot" and fiware-servicepath "/"
#        Then  I receive an HTTP response with the code "204" and empty dict


    ##
    # This Scenario will fail with a minimal error due to a typo:
    #
    # Field "ring_info" should be " ring OK" ; "ring_info" is "OK"
    #
    Scenario: 08 - Read the result of the previous command (Ring a bell)
        When  I prepare a GET HTTP request to "http://localhost:1026/v2/entities/urn:ngsi-ld:Bell:001?type=Bell&options=keyValues"
        And   I set header fiware-service to openiot
        And   I set header fiware-servicepath to /
        And   I set the body request as described in request203-09.json
        And   I perform the query request
        Then  I receive a HTTP "200" response code from Broker with the body "response203-08.json" and exclusions "08.excludes"

 #       When  I send IoT "GET" HTTP request with data to "http://localhost:1026/v2/entities/urn:ngsi-ld:Bell:001?type=Bell&options=keyValues" With headers fiware-service "openiot" and fiware-servicepath "/" and data is "empty-data.json"
 #       Then I receive a HTTP "200" response code from Broker with the body "response203-08.json" and exclusions "08.excludes"

    Scenario: 09 - Provisioning a smart Door
        When  I prepare a POST HTTP request to "http://localhost:4041/iot/devices"
        And   I set header fiware-service to openiot
        And   I set header fiware-servicepath to /
        And   I set the body request as described in request203-09.json
        And   I perform the request
        Then  I receive a HTTP response with status 201 and empty dict
 #       When  I send POST HTTP request to "http://localhost:4041/iot/devices"
 #       And   With body request and headers described in file "request203-09.json" and headers fiware-service "openiot" and fiware-servicepath "/"
 #       Then  I receive an HTTP response with the code "201" and empty dict

    Scenario: 10 - Provisioning a smart Lamp
        When  I prepare a POST HTTP request to "http://localhost:4041/iot/devices"
        And   I set header fiware-service to openiot
        And   I set header fiware-servicepath to /
        And   I set the body request as described in request203-10.json
        And   I perform the request
        Then  I receive a HTTP response with status 201 and empty dict
 #       When  I send POST HTTP request to "http://localhost:4041/iot/devices"
 #       And   With body request and headers described in file "request203-10.json" and headers fiware-service "openiot" and fiware-servicepath "/"
 #       Then  I receive an HTTP response with the code "201" and empty dict

    Scenario: 11 - Quering all the devices
        When  I prepare a GET HTTP request to "http://localhost:4041/iot/devices"
        And   I set header fiware-service to openiot
        And   I set header fiware-servicepath to /
        And   I perform the query request
        Then  I receive a HTTP "200" response code from IoTAgent with the body "empty-data.json" and exclusions "11.excludes"

 #       When  I send IoT "GET" HTTP request with data to "http://localhost:4041/iot/devices" With headers fiware-service "openiot" and fiware-servicepath "/" and data is "empty-data.json"
 #       Then  I receive a HTTP "200" response code from IoTAgent with the body "empty-data.json" and exclusions "11.excludes"
