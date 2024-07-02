Feature: test tutorial 201.Introduction to IoT Sensors

  This is the feature file of the FIWARE Step by Step tutorial for IoT Sensors - What's Ultralight 2.0
  url: https://fiware-tutorials.readthedocs.io/en/latest/iot-sensors.html
  environment: https://raw.githubusercontent.com/FIWARE/tutorials.IoT-Sensors/NGSI-v2/.env
  git-clone: https://github.com/FIWARE/tutorials.IoT-Sensors.git
  git-directory: /tmp/tutorials.IoT-Sensors
  shell-commands: git checkout NGSI-v2 ; ./services create; ./services start
  clean-shell-commands: ./services stop


  Background:
    Given I set the tutorial 201


    Scenario Outline: Communicating with IoT Devices: Using Actuators
    When  I prepare a POST HTTP request for "<description>" to "http://localhost:3001/<location>"
    And   I set header Content-Type to application/x-www-form-urlencoded
    And   I set the body request as described in <request_file>
    And   I perform the request
    Then  I receive a HTTP response with status "200" and with the body as in file "<response_file>"
    Examples:
        | request_file           | location    | response_file      | description     |
        | request201-01.txt      | iot/bell001 | response201-01.txt | ring bell       |
        | request201-02.txt      | iot/lamp001 | response201-02.txt | Switch lamp on  |
        | request201-03.txt      | iot/lamp001 | response201-03.txt | Switch lamp off |
        | request201-04.txt      | iot/lamp001 | response201-04.txt | Switch lamp on  |
        | request201-05.txt      | iot/door001 | response201-05.txt | Unlock door     |
        | request201-06.txt      | iot/door001 | response201-06.txt | Open door       |
        | request201-07.txt      | iot/door001 | response201-07.txt | Close door      |
        | request201-08.txt      | iot/door001 | response201-08.txt | Lock door       |
