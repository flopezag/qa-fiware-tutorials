Feature: Test tutorial 207.IoT over IOTA tangle
    This is feature file of the FIWARE step by step tutorial for IoT Agent Ultrlight
    url: https://fiware-tutorials.readthedocs.io/en/latest/iot-over-iota-tangle.html
    git-clone: https://github.com/FIWARE/tutorials.IoT-over-IOTA.git
    git-directory: /tmp/tutorials.IoT_IoTA_Tangle
    shell-commands: git checkout NGSI-v2 ; docker build iota-gateway/ ; ./services start
    # shell-commands: git checkout NGSI-v2 ; docker build iota-gateway/ ; docker compose up -d --remove-orphans
    # shell-commands: git checkout NGSI-v2 ; ./services create ; services start
    clean-shell-commands: ./services stop

    # There are some problems building iota-gateway:latest -- It should be built but it is not...
    # I had to modify the steps to set up the tutorial.
    Background:
        Given I set the tutorial 206


    # Error - json line 5 and line 25 --
    #  "cbroker":     "'"http://orion:1026"'",   ---- Syntax Error json file
    #
    # Scenario 01.1 and Scenario 02.2 fails since data is already loaded from "services start"
    # Can be tested:
    #    curl "http://localhost:4041/iot/services"  -H 'fiware-service: openiot'   -H 'fiware-servicepath: /'  | \
    #    jq ".services[] | select(.apikey==\"1068318794\")"
    Scenario: 01.1 - Provisioning services, previous to provision device.
      When  I prepare a POST HTTP request to "http://localhost:4041/iot/services"
      And   I set header fiware-service to openiot
      And   I set header fiware-servicepath to /
      And   I set the body request as described in 01.request207-01_1.json
      And   I perform the request
      Then  I receive a HTTP response with status 409 and empty dict
      And   I wait "1" seconds

    Scenario: 01.2 - Provisioning devices, after service provisioning
      When  I prepare a POST HTTP request to "http://localhost:4041/iot/devices"
      And   I set header fiware-service to openiot
      And   I set header fiware-servicepath to /
      And   I set the body request as described in 01.request207-01_2.json
      And   I perform the request
      Then  I receive a HTTP response with status 409 and empty dict
      And   I wait "1" seconds

    Scenario: 02.prev - Terminal for iota gateway
        When  I open a new shell terminal iota-gateway and run "docker logs -f iota-gateway"
        Then  everything is ok

    Scenario: 02.prev - Terminal for iota gateway
        When  I open a new shell terminal fiware-tutorial and run "docker logs -f fiware-tutorial"
        Then  everything is ok

     Scenario: 02.1 - Check stderr logs from iota-gateway
        When  I Compare next lines in terminal iota-gateway are like in filename 02.expected_on_terminal.txt
        Then  All lines must have matched

    Scenario: 02.1 - Check stderr logs from iota-gateway
        When  I Compare next lines in terminal fiware-tutorial are like in filename 03.expected_on_terminal.txt
        Then  All lines must have matched

    Scenario: 04.1 - Sending Commands. Ring a bell
      When  I prepare a PATCH HTTP request to "http://localhost:1026/v2/entities/urn:ngsi-ld:Bell:001/attrs"
      And   I set header fiware-service to openiot
      And   I set header fiware-servicepath to /
      And   I set the body request as described in request207-04.json
      And   I perform the request
      Then  I receive a HTTP response with status 204 and empty dict
      And   I wait "3" seconds

    Scenario: 04.2 - Test the 1st terminal result
      When  I Compare next lines in terminal iota-gateway are like in filename 04.02.expected_on_terminal.txt
      Then  All lines must have matched

    Scenario: 04.3 - Display the Dummy Device logs (2nd terminal)
      When  I Compare next lines in terminal fiware-tutorial are like in filename 04.03.expected_on_terminal.txt
      Then  All lines must have matched

    Scenario: 05 - Request info about device motion001
       When  I prepare a GET HTTP request to "http://localhost:1026/v2/entities/urn:ngsi-ld:Motion:001?options=keyValues"
       And   I set header fiware-service to openiot
       And   I set header fiware-servicepath to /
       And   I perform the query request
       Then  I receive a HTTP "200" response code from Broker with the body "response207-05.json" and exclusions "05.excludes"
