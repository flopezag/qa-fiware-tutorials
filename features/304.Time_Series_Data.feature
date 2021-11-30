Feature: test tutorial 304.Time-Series Data with QuantumLeap

  This is the feature file of the FIWARE Step by Step tutorial for Time-Series Data with QuantumLeap
  url: https://fiware-tutorials.readthedocs.io/en/latest/time-series-data.html
  git-clone: https://github.com/FIWARE/tutorials.Time-Series-Data.git
  git-directory: tutorials.Time-Series-Data
  shell-commands: ./services create; ./services start
  clean-shell-commands: ./services stop


  Background:
    Given I set the tutorial 304

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
  # This Scenario fails the response content received from CB is not the expected one shown in the tuturial
  # dictionary_item_added': root[0]['notification']['onlyChangedAttrs'],
  #                         root[0]['notification']['metadata'],
  #                         root[0]['notification']['lastSuccessCode'],
  #                         root[1]['notification']['onlyChangedAttrs'],
  #                         root[1]['notification']['metadata'],
  #                         root[1]['notification']['lastSuccessCode']],
  # iterable_item_added':   root[1]['notification']['attrs'][1]": 'location'
  ##
  @fail
  Scenario: 03 - Checking Subscription for QuantumLeap
    Given  the fiware-service header is "openiot" and the fiware-servicepath header is "/"
    When   I send GET HTTP request to "http://localhost:1026/v2/subscriptions" with fiware-service and fiware-servicepath
    Then   I receive a HTTP "200" response code from Broker with the body "response304-03.json" and exclusions "response304-03.excludes"

  ##
  # This scenario fails basically because the tutorial say that the response of QuantumLeap should be:
  # {
  #  "data": {
  #      ...
  #  }
  # }
  #
  # But the response of the current version of QuantumLeap is without this "data"
  ##
  @fail
  Scenario: 04 - List the first N sampled values
    Given  the fiware-service header is "openiot", the fiware-servicepath header is "/", and the accept is "application/json"
    When   I send GET HTTP request to "http://localhost:8668/v2/entities/Lamp:001/attrs/luminosity?limit=3" with fiware-service and fiware-servicepath
    Then   I receive a HTTP "200" response code from QuantumLeap with the body "response304-04.json"

  ##
  # This scenario fails basically because the tutorial say that the response of QuantumLeap should be:
  # {
  #  "data": {
  #      ...
  #  }
  # }
  #
  # But the response of the current version of QuantumLeap is without this "data"
  ##
  @fail
  Scenario: 05 - List N sampled values ar an offset
    Given  the fiware-service header is "openiot", the fiware-servicepath header is "/", and the accept is "application/json"
    When   I send GET HTTP request to "http://localhost:8668/v2/entities/Motion:001/attrs/count?offset=3&limit=3" with fiware-service and fiware-servicepath
    Then   I receive a HTTP "200" response code from QuantumLeap with the body "response304-05.json"

  ##
  # This scenario fails basically because the tutorial say that the response of QuantumLeap should be:
  # {
  #  "data": {
  #      ...
  #  }
  # }
  #
  # But the response of the current version of QuantumLeap is without this "data"
  ##
  @fail
  Scenario: 06 - List the last N sampled values
    Given  the fiware-service header is "openiot", the fiware-servicepath header is "/", and the accept is "application/json"
    When   I send GET HTTP request to "http://localhost:8668/v2/entities/Motion:001/attrs/count?lastN=3" with fiware-service and fiware-servicepath
    Then   I receive a HTTP "200" response code from QuantumLeap with the body "response304-06.json"

  Scenario: Get QuantumLeap version data
    When  I send GET HTTP request to "http://localhost:8668/version"
    Then  I receive a HTTP "200" response code from QuantumLeap with the body "response304-version.json"

  ##
  # This scenario fails basically because the tutorial say that the response of QuantumLeap should be:
  # {
  #  "data": {
  #      ...
  #  }
  # }
  #
  # But the response of the current version of QuantumLeap is without this "data"
  ##
  @fail
  Scenario: 07 - List the sum of values grouped by a time period
    Given  the fiware-service header is "openiot", the fiware-servicepath header is "/", and the accept is "application/json"
    When   I send GET HTTP request to "http://localhost:8668/v2/entities/Motion:001/attrs/count?aggrMethod=count&aggrPeriod=minute&lastN=3" with fiware-service and fiware-servicepath
    Then   I receive a HTTP "200" response code from QuantumLeap with the body "response304-07.json"

  ##
  # This scenario fails basically because the tutorial say that the response of QuantumLeap should be:
  # {
  #  "data": {
  #      ...
  #  }
  # }
  #
  # But the response of the current version of QuantumLeap is without this "data"
  ##
  @fail
  Scenario: 08 - List the minimum values grouped by a time period
    Given  the fiware-service header is "openiot", the fiware-servicepath header is "/", and the accept is "application/json"
    When   I send GET HTTP request to "http://localhost:8668/v2/entities/Lamp:001/attrs/luminosity?aggrMethod=min&aggrPeriod=minute&lastN=3" with fiware-service and fiware-servicepath
    Then   I receive a HTTP "200" response code from QuantumLeap with the body "response304-08.json"

  ##
  # This scenario fails basically because the tutorial say that the response of QuantumLeap should be:
  # {
  #  "data": {
  #      ...
  #  }
  # }
  #
  # But the response of the current version of QuantumLeap is without this "data"
  ##
  @fail
  Scenario: 10 - List the latest N sampled values of devices near a point
    Given  the fiware-service header is "openiot", the fiware-servicepath header is "/", and the accept is "application/json"
    When   I send GET HTTP request to "http://localhost:8668/v2/types/Lamp/attrs/luminosity?lastN=4&georel=near;maxDistance:5000&geometry=point&coords=52.5547,13.3986" with fiware-service and fiware-servicepath
    Then   I receive a HTTP "200" response code from QuantumLeap with the body "response304-10.json"

  ##
  # This scenario fails basically because the tutorial say that the response of QuantumLeap should be:
  # {
  #  "data": {
  #      ...
  #  }
  # }
  #
  # But the response of the current version of QuantumLeap is without this "data"
  ##
  @fail
  Scenario: 11 - List the latest N sampled values of devices in an area
    Given  the fiware-service header is "openiot", the fiware-servicepath header is "/", and the accept is "application/json"
    When   I send GET HTTP request to "http://localhost:8668/v2/types/Lamp/attrs/luminosity?lastN=4&georel=coveredBy&geometry=polygon&coords=52.5537,13.3996;52.5557,13.3996;52.5557,13.3976;52.5537,13.3976;52.5537,13.3996" with fiware-service and fiware-servicepath
    Then   I receive a HTTP "200" response code from QuantumLeap with the body "response304-11.json"

  ##
  # This multiple scenario fails because:
  # reques304-12
  #   values_changed': root['cols'][0]: new_value: 'schema_name',
  #                                   old_value: 'table_schema'
  #                  root['rows'][1][0]: {'new_value': 'doc', 'old_value': 'information_schema'},
  #                  root['rows'][2][0]: {'new_value': 'information_schema', 'old_value': 'sys'}},
  #   iterable_item_added: root['rows'][5]: ['sys']
  # request304-14, request304-15, request304-16
  #   need to be checked the answer
  Scenario Outline: 12 - Checking data persistence in CrateDB
    Given  the payload request described in "<file-request>"
    When   I send a POST HTTP request to "http://localhost:4200/_sql" with content type "application/json"
    Then   I receive a HTTP "200" response code from CrateDB with the body "<file-response>" and exclusions "<file-exclusion>"

    Examples:
     | file-request       | file-response       | file-exclusion               |
     | request304-12.json | response304-12.json | response304-cratedb.excludes |
     | request304-13.json | response304-13.json | response304-cratedb.excludes |
     | request304-14.json | response304-14.json | response304-17.excludes      |
     | request304-15.json | response304-15.json | response304-17.excludes      |
     | request304-16.json | response304-16.json | response304-17.excludes      |
     | request304-17.json | response304-17.json | response304-17.excludes      |
     | request304-18.json | response304-18.json | response304-17.excludes      |

  # Temporal queries need to be adapted to the execution date and time
  @ongoing
  Scenario: 19 - Checking data persistence in CrateDB (temporal queries)
    Given  the payload request described in "request304-19.json"
    And    the date and time are around today
    When   I send a POST HTTP request to "http://localhost:4200/_sql" with content type "application/json"
    Then   I receive a HTTP "200" response code from CrateDB with the body "response304-19.json" and exclusions "response304-cratedb.excludes"

  ##
  # This scenario fails basically because the tutorial say that the response of QuantumLeap should be:
  # {
  #  "data": {
  #      ...
  #  }
  # }
  #
  # But the response of the current version of QuantumLeap is without this "data"
  ##
  @fail @ongoing
  Scenario: 09 - List the maximum value over a time period (QuantumLeap)
    Given  the fiware-service header is "openiot", the fiware-servicepath header is "/", and the accept is "application/json"
    When   I send GET HTTP request to "http://localhost:8668/v2/entities/Lamp:001/attrs/luminosity?aggrMethod=max" with from and to date 2 days from now
    And    using fiware-service and fiware-servicepath header keys
    Then   I receive a HTTP "200" response code from QuantumLeap with the body "response304-09.json"

