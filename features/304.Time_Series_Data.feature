Feature: test tutorial 304.Time-Series Data with QuantumLeap

  This is the feature file of the FIWARE Step by Step tutorial for Time-Series Data with QuantumLeap
  url: https://fiware-tutorials.readthedocs.io/en/latest/time-series-data.html
  git-clone: https://github.com/FIWARE/tutorials.Time-Series-Data.git
  git-directory: tutorials.Time-Series-Data
  shell-commands: ./services create; ./services start
  clean-shell-commands: ./services stop


  Background:
    Given I set the tutorial 304

  ##
  # This Scenario will fail because version data is different
  ##
  @ongoing
  Scenario Outline: Generating context data
    Given  the fiware-service header is "openiot" and the fiware-servicepath header is "/"
    When   I send PATCH HTTP request with the following data
      | Url                      | Entity_ID   | Command |
      | http://localhost:1026/v2 | <entity_id> | <command> |
    Then  I receive a HTTP "204" response

    Examples:
        | command | entity_id |
        | unlock  | Door:001  |
        | on      | Lamp:001  |

  @ongoing
  Scenario Outline: 02 - Subscribing to context changes
    Given  the fiware-service header is "openiot" and the fiware-servicepath header is "/"
    When   I send a subscription to the Url "http://localhost:1026/v2/subscriptions" and payload "<file>"
    Then   I receive a HTTP "201" response

    Examples:
     | file               |
     | request304-01.json |
     | request304-02.json |

  ##
  # This Scenario will fail because the url of cygnus is different and there are two dictionary items
  # not presented in the tutorial 'onlyChangedAttrs' and 'attrsFormat'
  ##
  @fail
  Scenario: 03 - Checking Subscription for QuantumLeap
    Given  the fiware-service header is "openiot" and the fiware-servicepath header is "/"
    When   I send GET HTTP request to "http://localhost:1026/v2/subscriptions" with fiware-service and fiware-servicepath
    Then   I receive a HTTP "200" response code from Broker with the body "response304-03.json" and exclusions "response304-03.excludes"

  Scenario: 04 - List the first N sampled values
    Given  the fiware-service header is "openiot", the fiware-servicepath header is "/", and the accept is "application/json"
    When   I send GET HTTP request to "http://localhost:8668/v2/entities/Lamp:001/attrs/luminosity?limit=3" with fiware-service and fiware-servicepath
    Then   I receive a HTTP "200" response code from QuantumLeap with the body "response304-04.json"

  Scenario: 05 - List N sampled values ar an offset
    Given  the fiware-service header is "openiot", the fiware-servicepath header is "/", and the accept is "application/json"
    When   I send GET HTTP request to "http://localhost:8668/v2/entities/Motion:001/attrs/count?offset=3&limit=3" with fiware-service and fiware-servicepath
    Then   I receive a HTTP "200" response code from QuantumLeap with the body "response304-05.json"

  Scenario: 06 - List the last N sampled values
    Given  the fiware-service header is "openiot", the fiware-servicepath header is "/", and the accept is "application/json"
    When   I send GET HTTP request to "http://localhost:8668/v2/entities/Motion:001/attrs/count?lastN=3" with fiware-service and fiware-servicepath
    Then   I receive a HTTP "200" response code from QuantumLeap with the body "response304-06.json"

  Scenario: Get QuantumLeap version data
    When  I send GET HTTP request to "http://localhost:8668/version"
    Then  I receive a HTTP "200" response code from QuantumLeap with the body "response304-version.json"

  Scenario: 07 - List the sum of values grouped by a time period
    Given  the fiware-service header is "openiot", the fiware-servicepath header is "/", and the accept is "application/json"
    When   I send GET HTTP request to "http://localhost:8668/v2/entities/Motion:001/attrs/count?aggrMethod=count&aggrPeriod=minute&lastN=3" with fiware-service and fiware-servicepath
    Then   I receive a HTTP "200" response code from QuantumLeap with the body "response304-07.json"

  Scenario: 08 - List the minimum values grouped by a time period
    Given  the fiware-service header is "openiot", the fiware-servicepath header is "/", and the accept is "application/json"
    When   I send GET HTTP request to "http://localhost:8668/v2/entities/Lamp:001/attrs/luminosity?aggrMethod=min&aggrPeriod=minute&lastN=3" with fiware-service and fiware-servicepath
    Then   I receive a HTTP "200" response code from QuantumLeap with the body "response304-08.json"

  # Fail we need to do something different dates
  @fail
  Scenario: 09 - List the maximum value over a time period
    Given  the fiware-service header is "openiot", the fiware-servicepath header is "/", and the accept is "application/json"
    When   I send GET HTTP request to "http://localhost:8668/v2/entities/Lamp:001/attrs/luminosity?aggrMethod=max&fromDate=2018-06-27T09:00:00&toDate=2018-06-30T23:59:59" with fiware-service and fiware-servicepath
    Then   I receive a HTTP "200" response code from QuantumLeap with the body "response304-09.json"

  Scenario: 10 - List the latest N sampled values of devices near a point
    Given  the fiware-service header is "openiot", the fiware-servicepath header is "/", and the accept is "application/json"
    When   I send GET HTTP request to "http://localhost:8668/v2/types/Lamp/attrs/luminosity?lastN=4&georel=near;maxDistance:5000&geometry=point&coords=52.5547,13.3986" with fiware-service and fiware-servicepath
    Then   I receive a HTTP "200" response code from QuantumLeap with the body "response304-10.json"

  Scenario: 11 - List the latest N sampled values of devices in an area
    Given  the fiware-service header is "openiot", the fiware-servicepath header is "/", and the accept is "application/json"
    When   I send GET HTTP request to "http://localhost:8668/v2/types/Lamp/attrs/luminosity?lastN=4&georel=coveredBy&geometry=polygon&coords=52.5537,13.3996;52.5557,13.3996;52.5557,13.3976;52.5537,13.3976;52.5537,13.3996" with fiware-service and fiware-servicepath
    Then   I receive a HTTP "200" response code from QuantumLeap with the body "response304-11.json"

  @ongoing
  Scenario Outline: 12 - Checking data persistence in CrateDB
    Given  the payload request described in "<file-request>"
    When   I send a POST HTTP request to "http://localhost:4200/_sql" with content type "application/json"
    Then   I receive a HTTP "200" response code from CrateDB with the body "<file-response>" and exclusions "<file-exclusion>"

    Examples:
     | file-request       | file-response       | file-exclusion          |
     | request304-12.json | response304-12.json | response304-12.excludes |
     | request304-13.json | response304-13.json | response304-13.excludes |
