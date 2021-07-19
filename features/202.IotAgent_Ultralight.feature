Feature: test tutorial 202.Introduction to IoT Agent Ultralight

    This is feature file of the FIWARE step by step tutorial for IoT Agent Ultrlight
    url: https://fiware-tutorials.readthedocs.io/en/latest/iot-agent.html
    git-clone: https://github.com/FIWARE/tutorials.IoT-Agent.git
    git-directory: /tmp/tutorials.IoT-Agent
    shell-commands: ./services create; ./services start
    clean-shell-commands: ./services stop

    Background:
        Given I set the tutorial 202

    Scenario: 01 - Checking the IoT Agent service health
        When  I send GET HTTP request to "http://localhost:4041/iot/about"
        Then  I receive a HTTP "200" response code with the body "response202-01.json"

    Scenario: 02 - Provisioning a Service Group
        When  I send POST HTTP request to "http://localhost:4041/iot/services"
        And  With body request and headers described in file "request202-02.json" and headers fiware-service "openiot" and fiware-servicepath "/"
        Then  I receive an HTTP response with the code "201" and empty dict

    Scenario: 03 - Provisioning a Sensor
        When  I send POST HTTP request to "http://localhost:4041/iot/devices"
        And  With body request and headers described in file "request202-03.json" and headers fiware-service "openiot" and fiware-servicepath "/"
        Then  I receive an HTTP response with the code "201" and empty dict

    Scenario: 04 - Simulate dummy IoT device measurement coming from the Motion Sensor
        When  I send POST HTTP IoT dummy request to "http://localhost:7896/iot/d?k=4jggokgpepnvsb2uv4s40d59ov&i=motion001"
        And   With dummy body request in file "request202-04.txt"
        Then  I receive a HTTP "200" IoT response from dummy device

    Scenario: 05 - A measurement has been recorded, by retrieving the entity data from the context broker
        When  I send IoT GET HTTP request with data to "http://localhost:1026/v2/entities/urn:ngsi-ld:Motion:001" With headers fiware-service "openiot" and fiware-servicepath "/" and data is "request202-05.txt"
        Then  I receive a HTTP "200" response code with the body "response202-05.json" and exclusions "05.excludes"
