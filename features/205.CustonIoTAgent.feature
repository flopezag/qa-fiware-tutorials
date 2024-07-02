Feature: Test tutorial 205.IoT Agent Custom (XML)
    This is feature file of the FIWARE step by step tutorial for IoT Agent Ultrlight
    url: https://fiware-tutorials.readthedocs.io/en/latest/custom-iot-agent.html
    git-clone: https://github.com/FIWARE/tutorials.Custom-IoT-Agent.git
    git-directory: /tmp/tutorials.Custom-IoT-Agent
    shell-commands: git checkout NGSI-v2 ; docker rm fiware-iot-agent ; ./services create; ./services start
    clean-shell-commands: ./services stop ;docker rm fiware-iot-agent

    Background:
        Given I set the tutorial 205

    Scenario: 01 - Check the Custom IoT Agent is running
        When  I send GET HTTP request to "http://localhost:4041/iot/about"
        Then  I receive a HTTP "200" response code from IoTAgent with the body "response205-01.json" and exclusions "01.excludes"

    Scenario: 02 - Provisioning a Service Group
        When  I prepare a POST HTTP request to "http://localhost:4041/iot/services"
        And   I set header fiware-service to openiot
        And   I set header fiware-servicepath to /
        And   I set the body request as described in request205-02.json
        And   I perform the request
        Then  I receive a HTTP response with status 201 and empty dict

    Scenario: 03 - Provisioning a Sensor
        When  I prepare a POST HTTP request to "http://localhost:4041/iot/devices"
        And   I set header fiware-service to openiot
        And   I set header fiware-servicepath to /
        And   I set the body request as described in request205-03.json
        And   I perform the request
        Then  I receive a HTTP response with status 201 and empty dict

   Scenario: 04 - Providing a value to the xml sensor
       When  I prepare a POST HTTP request to "http://localhost:7896/iot/xml"
       And   I set payload as in file "request205-04.xml"
       And   I set the header "Content-Type" to "application/xml"
       And   I perform the request

   Scenario: 05 - The Motion Sensor device with id=motion001 has been successfully identified by the IoT Agent and mapped to the entity id=urn:ngsi-ld:Motion:001
        When  I prepare a GET HTTP request to "http://localhost:1026/v2/entities/urn:ngsi-ld:Motion:001?type=Motion"
        And   I set header fiware-service to openiot
        And   I set header fiware-servicepath to /
        And   I perform the query request
        Then  I receive a HTTP "200" response code from Broker with the body "response205-05.json" and exclusions "05.excludes"

   Scenario: 06 - Provisioning an Actuator
       When  I prepare a POST HTTP request to "http://localhost:4041/iot/devices"
       And   I set header fiware-service to openiot
       And   I set header fiware-servicepath to /
       And   I set the body request as described in request205-06.json
       And   I perform the request
       Then  I receive a HTTP response with status 201 and empty dict

   Scenario: 07 - test that a command can be send to a device by making a REST request directly to the IoT Agent's North Port
       When  I prepare a POST HTTP request to "http://localhost:4041/v2/op/update/"
       And   I set header fiware-service to openiot
       And   I set header fiware-servicepath to /
       And   I set the body request as described in request205-07.json
       And   I perform the request
       Then  I receive a HTTP response with status 204 and empty dict
       And   I wait "1" seconds

   Scenario: 08 - Read the result of the previous command (Ring a bell)
       When  I prepare a GET HTTP request to "http://localhost:1026/v2/entities/urn:ngsi-ld:Bell:001?type=Bell&options=keyValues"
       And   I set header fiware-service to openiot
       And   I set header fiware-servicepath to /
       And   I perform the query request
       Then  I receive a HTTP "200" response code from Broker with the body "response205-08.json" and exclusions "05.excludes"
