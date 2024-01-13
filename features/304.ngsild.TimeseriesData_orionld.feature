  ## I Start the tutorial manually
  ## Cratedb needs increasing max_map_count
  ##    sudo sysctl -w vm.max_map_count=262144

Feature: test tutorial 304.Persisting and Querying timedata series (Orion-LD)

  This is the feature file of the FIWARE Step by Step tutorial Timedata Series - NGSI-LD
  # url (used): https://documenter.getpostman.com/view/513743/TWDUpxxx
  #   -- This is linked in "url" as "POSTMAN" -- It works much better than the original.
  url: https://ngsi-ld-tutorials.readthedocs.io/en/latest/time-series-data.html

  # git-clone -- As shown in the "POSTMAN" part of the tutorial.
  git-clone: https://github.com/FIWARE/tutorials.Time-Series-Data.git

  git-directory: /tmp/Time-Series-Data
  shell-commands: git checkout NGSI-LD ; /tmp/patch_crate.sh ; ./services create  ; ./services orion
  clean-shell-commands: ./services stop


  Background:
    Given I set the tutorial 304 LD - Timeseries data

  Scenario Outline: 01-02 - Registering cratedb timedata series
    When I prepare a POST HTTP request for "<description>" to "http://localhost:1026/ngsi-ld/v1/subscriptions/"
    And  I set header Content-Type to application/ld+json
    And  I set header NGSILD-Tenant to openiot
    And  I set the body request as described in <file>
    And  I perform the request
    Then I receive a HTTP "201" response code
    And  Header contains key "Location" with value "/ngsi-ld/v1/subscriptions/urn:ngsi-ld:subscription:ae0e50b6-b1f9-11ee-a013-0242ac120106"
    And  Header contains key "NGSILD-Tenant" with value "openiot"
    Examples:
        | description                | file            |
        | notify feedstock changes   | 01.request.json |
        | notify of animal locations | 02.request.json |

  # Request 3 -
  Scenario: 03 - Check the subscriptions for quantum-leap to ngsi-ld
    When I prepare a GET HTTP request for "cheking the created subscriptions" to "http://localhost:1026/ngsi-ld/v1/subscriptions/"
    And  I set header NGSILD-Tenant to openiot
    And  I perform the request
    Then I receive a HTTP "200" response code from Orion-LD with the body "03.response.json" and exclusions "03.excludes"
    And  Header contains key "Link" with value "<https://uri.etsi.org/ngsi-ld/v1/ngsi-ld-core-context-v1.6.jsonld>; rel="http://www.w3.org/ns/json-ld#context"; type="application/ld+json""
    And  Header contains key "Content-Type" with value "application/json"

  Scenario: 00 - Check the Quantum Leap Version
    When  I send GET HTTP request to "http://localhost:8668/version"
    Then  I receive a HTTP "200" response code
    And   I validate against jq '. | has("version")'

    # Somehow I need to add data to Sensors so they can add data to CrateDB
    # This is not in tutorial, but it is the way to add data without Web dashboard
    ## Example post: 12:53:47 PM HTTP POST http://iot-agent:7896/iot/d?i=filling001&k=854782081 f|0.45
  Scenario Outline: 00 - Communicating with IoT Devices: Using Actuators
    When  I prepare a POST HTTP request to "http://localhost:7896/iot/d?k=<key_value>&i=<sensor>"
    And   I set header fiware-service to openiot
    And   I set header fiware-servicepath to /
    And   I set header Content-Type to text/plain
    And   I set simple sensor values as described in "<sensor_value>"
    And   I perform the request
    Then  I receive a HTTP "<status_code>" response code
    And   I wait "1" seconds
    Examples:
        | status_code | sensor_value                                                | key_value  | sensor     |
        |         201 | f\|0.95                                                     | 854782081  | filling001 |
        |         201 | d\|AT_REST\|bpm\|61\|gps\|13.357,52.515\|s\|0               | 110990     | pig001     |
        |         201 | d\|AT_REST\|bpm\|50\|gps\|13.411,52.468\|s\|0               | 98699      | cow001     |
        |         200 | f\|0.90                                                     | 854782081  | filling001 |
        |         200 | d\|AT_REST\|bpm\|60\|gps\|13.359,52.516\|s\|0               | 110990     | pig001     |
        |         200 | d\|GRAZING\|bpm\|53\|gps\|13.41,52.467\|s\|0                | 98699      | cow001     |
        |         200 | f\|0.85                                                     | 854782081  | filling001 |
        |         200 | d\|WALLOWING\|bpm\|66\|gps\|13.359,52.514\|s\|5             | 110990     | pig001     |
        |         200 | d\|GRAZING\|bpm\|53\|gps\|13.41,52.467\|s\|0                | 98699      | cow001     |
        |         200 | f\|0.75                                                     | 854782081  | filling001 |
        |         200 | d\|AT_REST\|bpm\|66\|gps\|13.3986,52.5547\|s\|5             | 110990     | pig001     |
        |         200 | d\|AT_REST\|bpm\|53\|gps\|13.3987,52.5547\|s\|0             | 98699      | cow001     |
        |         200 | f\|0.65                                                     | 854782081  | filling001 |
        |         200 | f\|0.55                                                     | 854782081  | filling001 |
        |         200 | f\|0.70                                                     | 854782081  | filling001 |
        |         200 | f\|0.90                                                     | 854782081  | filling001 |
        |         200 | f\|0.98                                                     | 854782081  | filling001 |
        |         200 | f\|0.91                                                     | 854782081  | filling001 |

  # Request 4..11 - Fails. it gets HTTP 404 - Not Found
  Scenario Outline: 04-11 - Using Quantum Leap API list the first 3 sampled values
    When I prepare a GET HTTP request to "<url>"
    And  I set header fiware-service to openiot
    And  I set header fiware-servicepath to /
    And  I set header accept to application/json
    And  I perform the query request
    Then  I receive a HTTP "200" response code
    # Need to check the content of the response
    Examples:
      | url                                                                                            |
      | http://localhost:8668/v2/entities/urn:ngsi-ld:Device:filling001/attrs/filling?limit=3          |
      | http://localhost:8668/v2/entities/urn:ngsi-ld:Device:filling001/attrs/filling?offset=3&limit=3 |
      | http://localhost:8668/v2/entities/urn:ngsi-ld:Device:filling001/attrs/filling?lastN=3          |
      | http://localhost:8668/v2/entities/urn:ngsi-ld:Device:filling001/attrs/filling?aggrMethod=count&aggrPeriod=minute&lastN=3 |
      | http://localhost:8668/v2/entities/urn:ngsi-ld:Device:filling001/attrs/filling?aggrMethod=min&aggrPeriod=minute&lastN=3   |
      | http://localhost:8668/v2/entities/urn:ngsi-ld:Device:filling001/attrs/filling?aggrMethod=max&fromDate=2018-06-27T09:00:00&toDate=2050-06-30T23:59:59 |
      | http://localhost:8668/v2/types/Device/attrs/heartRate?lastN=4&georel=near;maxDistance:5000&geometry=point&coords=52.518,13.357                       |
      | http://localhost:8668/v2/types/Device/attrs/heartRate?lastN=4&georel=coveredBy&geometry=polygon&coords=52.5537,13.3996;52.5557,13.3996;52.5557,13.3976;52.5537,13.3976;52.5537,13.3996 |

  Scenario Outline: 12-19 -  Using Cratedb API
    When I prepare a POST HTTP request to "http://localhost:4200/_sql"
    And  I set header Content-Type to application/json
    And  I set simple sensor values as described in "<value>"
    And  I perform the request
    Then I receive a HTTP "200" response code
    # need to check the content of the response
    Examples:
      | value |
      | {"stmt":"SHOW SCHEMAS"} |
      | {"stmt":"SHOW TABLES"}  |
      | {"stmt":"SELECT * FROM mtopeniot.etFillingLevelSensor WHERE entity_id = 'urn:ngsi-ld:Device:filling001' ORDER BY time_index ASC LIMIT 3"} |
      | {"stmt":"SELECT * FROM mtopeniot.etFillingLevelSensor WHERE entity_id = 'urn:ngsi-ld:Device:filling001'  ORDER BY time_index DESC LIMIT 3"} |
      | {"stmt":"SELECT DATE_FORMAT (DATE_TRUNC ('minute', time_index)) AS minute, SUM (filling) AS sum FROM mtopeniot.etFillingLevelSensor WHERE entity_id = 'urn:ngsi-ld:Device:filling001' GROUP BY minute LIMIT 3"} |
      | {"stmt":"SELECT DATE_FORMAT (DATE_TRUNC ('minute', time_index)) AS minute, MIN (filling) AS min FROM mtopeniot.etFillingLevelSensor WHERE entity_id = 'urn:ngsi-ld:Device:filling001' GROUP BY minute"} |
      | {"stmt":"SELECT MAX(filling) AS max FROM mtopeniot.etFillingLevelSensor WHERE entity_id = 'urn:ngsi-ld:Device:filling001' and time_index >= '2022-04-01T09:00:00' and time_index < '2050-06-30T23:59:59'"} |
      | {"stmt":"SELECT MAX(filling) AS max FROM mtopeniot.etFillingLevelSensor WHERE entity_id = 'urn:ngsi-ld:Device:filling001' and time_index >= '2022-04-01T09:00:00' and time_index < NOW()"} |
