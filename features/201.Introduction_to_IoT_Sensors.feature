Feature: test tutorial 201.Introduction to IoT Sensors

  This is the feature file of the FIWARE Step by Step tutorial for IoT Sensors - What's Ultralight 2.0
  url: https://fiware-tutorials.readthedocs.io/en/latest/iot-sensors.html
  environment: https://raw.githubusercontent.com/FIWARE/tutorials.IoT-Sensors/NGSI-v2/.env
  git-clone: https://github.com/FIWARE/tutorials.IoT-Sensors.git
  git-directory: /tmp/tutorials.IoT-Sensors
  shell-commands: ./services create; ./services start
  clean-shell-commands: ./services stop


  Background:
    Given I set the tutorial 201


    Scenario Outline: Communicating with IoT Devices: Using Actuators
    When  I send POST HTTP IoT request for "<description>" to "http://localhost:3001"/"<location>"
    And   With the body IoT request described in "<request_file>"
    Then  I receive a HTTP "200" IoT response code with the body "<response_file>"

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
