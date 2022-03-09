Feature: Test tutorial 205.IoT Agent Custom (XML)
    This is feature file of the FIWARE step by step tutorial for IoT Agent Ultrlight
    url: https://fiware-tutorials.readthedocs.io/en/latest/custom-iot-agent.html
    git-clone: https://github.com/FIWARE/tutorials.Custom-IoT-Agent.git
    git-directory: /tmp/tutorials.Custom-IoT-Agent
    shell-commands: ./services create; ./services start
    clean-shell-commands: ./services stop

    Background:
        Given I set the tutorial 205

    Scenario: 01 - Check the Custom IoT Agent is running
        When  I send GET HTTP request to "http://localhost:4041/iot/about"
        Then  I receive a HTTP "200" response code from IoTAgent with the body "response205-01.json" and exclusions "01.excludes"

    Scenario: 02 - Provisioning a Service Group
       When  I send POST HTTP request to "http://localhost:4041/iot/services"
        And   With body request and headers described in file "request205-02.json" and headers fiware-service "openiot" and fiware-servicepath "/"
        Then  I receive an HTTP response with the code "201" and empty dict

    Scenario: 03 - Provisioning a Sensor
        When  I send POST HTTP request to "http://localhost:4041/iot/devices"
        And  With body request and headers described in file "request205-03.json" and headers fiware-service "openiot" and fiware-servicepath "/"
        Then  I receive an HTTP response with the code "201" and empty dict

    Scenario: 04 - Providing a value to the xml sensor
        When  I prepare a "POST" HTTP request to "http://localhost:7896/iot/xml"
        And   I set payload as in file "request205-04.xml"
        And   I set the header "Content-Type" to "application/xml"
        And   I perform the request

    Scenario: 05 - The Motion Sensor device with id=motion001 has been successfully identified by the IoT Agent and mapped to the entity id=urn:ngsi-ld:Motion:001
        When  I send IoT "GET" HTTP request with data to "http://localhost:1026/v2/entities/urn:ngsi-ld:Motion:001?type=Motion" With headers fiware-service "openiot" and fiware-servicepath "/" and data is "empty-data.json"
        Then I receive a HTTP "200" response code from Broker with the body "response205-05.json" and exclusions "05.excludes"

    Scenario: 06 - Provisioning an Actuator
        When  I send POST HTTP request to "http://localhost:4041/iot/devices"
        And   With body request and headers described in file "request205-06.json" and headers fiware-service "openiot" and fiware-servicepath "/"
        Then  I receive an HTTP response with the code "201" and empty dict

    Scenario: 07 - test that a command can be send to a device by making a REST request directly to the IoT Agent's North Port
        When  I send POST HTTP request to "http://localhost:4041/v2/op/update"
        And   With body request and headers described in file "request205-07.json" and headers fiware-service "openiot" and fiware-servicepath "/"
        Then  I receive an HTTP response with the code "204" and empty dict

    Scenario: 08 - Read the result of the previous command (Ring a bell)
        When  I send IoT "GET" HTTP request with data to "http://localhost:1026/v2/entities/urn:ngsi-ld:Bell:001?type=Bell&options=keyValues" With headers fiware-service "openiot" and fiware-servicepath "/" and data is "empty-data.json"
        And   I wait "1" seconds
        Then I receive a HTTP "200" response code from Broker with the body "response205-08.json" and exclusions "08.excludes"
