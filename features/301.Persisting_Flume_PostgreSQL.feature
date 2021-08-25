Feature: test tutorial 301.Persisting Context Data using Apache Flume (PostgreSQL)

  This is the feature file of the FIWARE Step by Step tutorial for Persisting Context Data using Apache Flume (PostgreSQL)
  url: https://fiware-tutorials.readthedocs.io/en/latest/historic-context-flume.html
  git-clone: https://github.com/FIWARE/tutorials.Historic-Context-Flume.git
  git-directory: /tmp/tutorials.Historic-Context-Flume
  shell-commands: ./services create; ./services postgres
  clean-shell-commands: ./services stop


  Background:
    Given I set the tutorial 301

  ##
  # This Scenario will fail because version data is different
  ##
  @fail
  Scenario: 01 - Checking the Cygnus service health
    When  I send GET HTTP request to "http://localhost:5080/v1/version"
    Then  I receive a HTTP "200" response code from Cygnus with the body "response301-01.json"

  Scenario: Getting API key for lamp and door
    Given  the fiware-service header is "openiot" and the fiware-servicepath header is "/"
    When   I send GET HTTP request to "http://localhost:4041/iot/services" with fiware-service and fiware-servicepath
    Then   I receive a HTTP "200" response code with all the services information

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

  Scenario: 02 - Subscribing to context changes
    Given  the fiware-service header is "openiot" and the fiware-servicepath header is "/"
    When   I send a subscription to the Url "http://localhost:1026/v2/subscriptions" and payload "request301-02-psql.json"
    Then   I receive a HTTP "201" response

  ##
  # This Scenario will fail because the there is missing 'lastSuccessCode' property in the JSON response
  ##
  @fail
  Scenario: 03 - Get all subscription
    Given  the fiware-service header is "openiot" and the fiware-servicepath header is "/"
    When   I send GET HTTP request to "http://localhost:1026/v2/subscriptions" with fiware-service and fiware-servicepath
    Then   I receive a HTTP "200" response code from Broker with the body "response303-03-psql.json" and exclusions "response303-03.excludes"

  Scenario: 04 - Show available databases on the PostgreSQL server
    Given  I connect to the PostgreSQL with the following data
      | User     | Password | Host      | Port |
      | postgres | password | localhost | 5432 |
    When   I request the available PostgreSQL databases
    Then   I obtain the following databases from PostgreSQL
      | Databases                      |
      | postgres, template1, template0 |

  Scenario: 05 - Show available schemas on the PostgreSQL server
    Given  I connect to the PostgreSQL with the following data
      | User     | Password | Host      | Port | Database |
      | postgres | password | localhost | 5432 | postgres |
    When   I request the available PostgreSQL schemas
    Then   I obtain the following schemas from PostgreSQL
      | Schemas         |
      | openiot, public |

  Scenario: 06 - Read historical context from the PostgreSQL server - show table schema and table name
    Given  I connect to the PostgreSQL with the following data
      | User     | Password | Host      | Port | Database |
      | postgres | password | localhost | 5432 | postgres |
    When   I request the available table_schema and table_name from PostgreSQL when table_schema is "openiot"
    Then   I obtain "16" total tables from PostgreSQL

  Scenario: 07 - Read historical context from the PostgreSQL server - query some data from Motion001 sensor
    Given  I connect to the PostgreSQL with the following data
      | User     | Password | Host      | Port | Database |
      | postgres | password | localhost | 5432 | postgres |
    When   I request "10" elements from the table "openiot.motion_001_motion"
    Then   I receive a non-empty list with "9" columns

  Scenario: 08 - Read historical context from the PostgreSQL server - query accumulation Motion001 sensor
    Given  I connect to the PostgreSQL with the following data
      | User     | Password | Host      | Port | Database |
      | postgres | password | localhost | 5432 | postgres |
    When   I request recvtime, attrvalue from the table "openiot.motion_001_motion" limited to "10" registers
    Then   I receive a non-empty list with "2" columns
