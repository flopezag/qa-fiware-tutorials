Feature: test tutorial 201.Introduction to IoT Sensors

  This is the feature file of the FIWARE Step by Step tutorial for IoT Sensors - NGSI-LD
  url: https://ngsi-ld-tutorials.readthedocs.io/en/latest/iot-sensors.html
  git-clone: https://github.com/FIWARE/tutorials.IoT-Sensors.git
  git-directory: /tmp/tutorials.IoT-Sensors
  shell-commands: git checkout NGSI-LD ; ./services start
  clean-shell-commands: ./services stop


  Background:
    Given I set the tutorial 201 LD

    Scenario Outline: Communicating with IoT Devices: Using Actuators
    When  I prepare a POST HTTP request for "<description>" to "http://localhost:3001/iot/<location>"
    And   I set header Content-Type to text/plain
    And   I set the body text to <request_data>
    And   I perform the request
    Then I receive a HTTP "200" response code
    And  I have a text response as <response_data>
    Examples:
        | request_data                         | location   | response_data                                    | description           |
        | urn:ngsi-ld:Device:water001@on       | water001   | urn:ngsi-ld:Device:water001@on\| on OK           | On Irrigation system  |
        | urn:ngsi-ld:Device:water001@off      | water001   | urn:ngsi-ld:Device:water001@off\| off OK         | Off Irrigation system |
        | urn:ngsi-ld:Device:tractor001@start  | tractor001 | urn:ngsi-ld:Device:tractor001@start\| start OK   | start tractor         |
        | urn:ngsi-ld:Device:tractor001@stop   | tractor001 | urn:ngsi-ld:Device:tractor001@stop\| stop OK     | stop tractor          |
        | urn:ngsi-ld:Device:filling001@remove | filling001 | urn:ngsi-ld:Device:filling001@remove\| remove OK | Remove Hay from Barn  |


    Scenario: Sending measures
      When I prepare a POST HTTP request to "http://localhost:7896/iot/d?k=4jggokgpepnvsb2uv4s40d59ov&i=humidity001"
      And   I set header fiware-service to openiot
      And   I set header fiware-servicepath to /
      And   I set header Content-Type to text/plain
      And   I set the body text to h|20
      And   I perform the request
      Then  I receive a HTTP "201" response code
