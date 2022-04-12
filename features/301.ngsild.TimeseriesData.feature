Feature: test tutorial 301.Persisting and Querying timedata series

  This is the feature file of the FIWARE Step by Step tutorial Timedata Series - NGSI-LD
  url: https://ngsi-ld-tutorials.readthedocs.io/en/latest/time-series-data.html
#   git-clone: https://github.com/FIWARE/tutorials.IoT-Sensors.git
#   git-directory: /tmp/tutorials.IoT-Sensors
#   shell-commands: git checkout NGSI-LD ; ./services start
#   clean-shell-commands: ./services stop

  ## I Start the tutorial manually
  ## Cratedb needs increasing max_map_count
  ##    sudo sysctl -w vm.max_map_count=262144

  Background:
    Given I set the tutorial 301 LD - Timedata series

    Scenario Outline: Registering cratedb timedata series
    When I prepare a POST HTTP request for "<description>" to "http://localhost:1026/ngsi-ld/v1/subscriptions/"
    And  I set header Content-Type to application/ld+json
    And  I set header NGSILD-Tenant to openiot
    And  I set the body request as described in <file>
    And  I perform the request
    Then  I receive a HTTP "201" response code
    Examples:
        | description                | file            |
        | notify feedstock changes   | 01.request.json |
        | notify of animal locations | 02.request.json |

    # Request 3 -
    Scenario: Check the subscriptions for quantum-leap to ngsi-ld
    When  I send GET HTTP request to "http://localhost:1026/ngsi-ld/v1/subscriptions/"
    And   I set header NGSILD-Tenant to openiot
    Then  I receive a HTTP "200" response code


    # Somehow I need to add data to Sensors so they can add data to Cratedb
    ## Example post: 12:53:47 PM HTTP POST http://iot-agent:7896/iot/d?i=filling001&k=854782081 f|0.45
    Scenario Outline: Communicating with IoT Devices: Using Actuators
    When  I prepare a POST HTTP request to "http://localhost:7896/iot/d?k=<key_value>&i=<sensor>"
    And   I set header fiware-service to openiot
    And   I set header fiware-servicepath to /
    And   I set header Content-Type to text/plain
    And   I set simple sensor values as described in "<sensor_value>"
    And   I perform the request
    Then  I receive a HTTP "200" response code
    And   I wait "5" seconds
    Examples:
        | sensor_value   | key_value  | sensor     |
        | f\|0.95        | 854782081  | filling001 |
        | f\|0.90        | 854782081  | filling001 |
        | f\|0.85        | 854782081  | filling001 |
        | f\|0.75        | 854782081  | filling001 |
        | f\|0.65        | 854782081  | filling001 |
        | f\|0.55        | 854782081  | filling001 |
        | f\|0.70        | 854782081  | filling001 |
        | f\|0.90        | 854782081  | filling001 |
        | f\|0.98        | 854782081  | filling001 |
        | f\|0.91        | 854782081  | filling001 |

    # Request 4..11 - Fails. it gets HTTP 404 - Not Found
    Scenario Outline: Using Quantum Leap API list the first 3 sampled values
    When I prepare a GET HTTP request to "<url>"
    And  I set header fiware-service to openiot
    And  I set header fiware-servicepath to /
    And  I set header accept to application/json
    And  I perform the query request
    Then  I receive a HTTP "200" response code
    Examples:
      | url                                                                                            |
      | http://localhost:8668/v2/entities/urn:ngsi-ld:Device:filling001/attrs/filling?limit=3          |
      | http://localhost:8668/v2/entities/urn:ngsi-ld:Device:filling001/attrs/filling?offset=3&limit=3 |
      | http://localhost:8668/v2/entities/urn:ngsi-ld:Device:filling001/attrs/filling?lastN=3          |
      | http://localhost:8668/v2/entities/urn:ngsi-ld:Device:filling001/attrs/filling?aggrMethod=count&aggrPeriod=minute&lastN=3 |
      | http://localhost:8668/v2/entities/urn:ngsi-ld:Device:filling001/attrs/filling?aggrMethod=min&aggrPeriod=minute&lastN=3   |
      | http://localhost:8668/v2/entities/urn:ngsi-ld:Device:filling001/attrs/filling?aggrMethod=max&fromDate=2018-06-27T09:00:00&toDate=2018-06-30T23:59:59 |
      | http://localhost:8668/v2/types/Device/attrs/heartRate?lastN=4&georel=near;maxDistance:5000&geometry=point&coords=52.518,13.357                       |
      | http://localhost:8668/v2/types/Device/attrs/heartRate?lastN=4&georel=coveredBy&geometry=polygon&coords=52.5537,13.3996;52.5557,13.3996;52.5557,13.3976;52.5537,13.3976;52.5537,13.3996 |

    Scenario Outline: Using Cratedb API
      When I prepare a POST HTTP request to "http://localhost:4200/_sql"
      And  I set header content-type to application/json
      And  I set simple sensor values as described in "<value>"
      And  I perform the request
      Then I receive a HTTP "200" response code
    Examples:
      | value |
      | {"stmt":"SHOW SCHEMAS"} |
      | {"stmt":"SHOW TABLES"}  |
      | {"stmt":"SELECT * FROM etFillingLevelSensor WHERE entity_id = 'urn:ngsi-ld:Device:filling001' ORDER BY time_index ASC LIMIT 3"} |
      | {"stmt":"SELECT * FROM etFillingLevelSensor WHERE entity_id = 'urn:ngsi-ld:Device:filling001'  ORDER BY time_index DESC LIMIT 3"} |
      | {"stmt":"SELECT DATE_FORMAT (DATE_TRUNC ('minute', time_index)) AS minute, SUM (filling) AS sum FROM etFillingLevelSensor WHERE entity_id = 'urn:ngsi-ld:Device:filling001' GROUP BY minute LIMIT 3"} |
      | {"stmt":"SELECT DATE_FORMAT (DATE_TRUNC ('minute', time_index)) AS minute, MIN (filling) AS min FROM etFillingLevelSensor WHERE entity_id = 'urn:ngsi-ld:Device:filling001' GROUP BY minute"} |
      | {"stmt":"SELECT MAX(filling) AS max FROM etFillingLevelSensor WHERE entity_id = 'urn:ngsi-ld:Device:filling001' and time_index >= '2022-04-01T09:00:00' and time_index < '2025-06-30T23:59:59'"} |
