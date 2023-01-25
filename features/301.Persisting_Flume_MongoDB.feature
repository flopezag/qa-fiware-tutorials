Feature: test tutorial 301.Persisting Context Data using Apache Flume (MongoDB)

  This is the feature file of the FIWARE Step by Step tutorial for Persisting Context Data using Apache Flume (MongoDB)
  url: https://fiware-tutorials.readthedocs.io/en/latest/historic-context-flume.html
  git-clone: https://github.com/FIWARE/tutorials.Historic-Context-Flume.git
  git-directory: /tmp/tutorials.Historic-Context-Flume
  shell-commands: ./services create; ./services mongodb
  clean-shell-commands: ./services stop


  Background:
    Given I set the tutorial 301

  ##
  # This Scenario will fail because version data is different
  ##
  @fail
  Scenario: 01 - Checking the Cygnus service health
    When  I send GET HTTP request to "http://localhost:5080/v1/version"
    Then  I receive a HTTP "200" response code from Cygnus with the body equal to "response301-01.json"

  Scenario: Getting API key for lamp and door
    Given  the fiware-service header is "openiot" and the fiware-servicepath header is "/"
    When   I send GET HTTP request to "http://localhost:4041/iot/services" with fiware-service and fiware-servicepath
    Then   I receive a HTTP "200" response code with all the services information

  Scenario Outline: Generating context data
    Given  the fiware-service header is "openiot" and the fiware-servicepath header is "/"
    When   I send PATCH HTTP request with the following data
      | Url                      | Entity_ID   | Command |
      | http://localhost:1026/v2 | <entity_id> | <command> |
    Then  I receive a HTTP "204" status code response

    Examples:
        | command | entity_id |
        | unlock  | Door:001  |
        | on      | Lamp:001  |

  Scenario: 02 - Subscribing to context changes
    Given  the fiware-service header is "openiot" and the fiware-servicepath header is "/"
    When   I send a subscription to the Url "http://localhost:1026/v2/subscriptions" and payload "request301-02.json"
    Then   I receive a HTTP "201" status code response

  ##
  # This Scenario will fail because the url of cygnus is different and there are two dictionary items
  # not presented in the tutorial 'onlyChangedAttrs' and 'attrsFormat'
  ##
  @fail
  Scenario: 03 - Get all subscriptions
    Given  the fiware-service header is "openiot" and the fiware-servicepath header is "/"
    When   I send GET HTTP request to "http://localhost:1026/v2/subscriptions" with fiware-service and fiware-servicepath
    Then   I receive a HTTP "200" response code from Broker with the body "response303-03.json" and exclusions "response303-03.excludes"

  ##
  # This Scenario will fail because there are four databases not shown in the tutorial:
  # ['config', 'session', 'sessions', 'test']
  ##
  @fail
  Scenario: 04 - Show available databases on the MongoDB server
    Given  I connect to the MongoDB with the host "localhost" and the port "27017"
    When   I request the available MongoDB databases
    Then   I obtain the following databases
      | Databases                                                                                    |
      | admin, iotagentul, local, orion, orion-openiot, sth_openiot, session, config, sessions, test |

  Scenario: 05 - Read historical context from the MongoDB server - show collections
    Given  I connect to the MongoDB with the host "localhost" and the port "27017"
    When   I request the available MongoDB collections from the database "sth_openiot"
    Then   I obtain "32" total collections from MongoDB

  Scenario: 06 - Read historical context from the MongoDB server - query some data from Door001 sensor
    Given  I connect to the MongoDB with the host "localhost" and the port "27017"
    When   I request "5" elements from the database "sth_openiot" and the collection "sth_/_Door:001_Door"
    Then   I receive a list with "5" elements
    And    with the following keys
      | Keys                                         |
      | _id, recvTime, attrName, attrType, attrValue |

  Scenario: 07 - Read historical context from the MongoDB server - query some data from Motion001 sensor
    Given  I connect to the MongoDB with the host "localhost" and the port "27017"
    When   I request information from the database "sth_openiot" and the collection "sth_/_Motion:001_Motion"
    And    with the following filter query and and filter fields, limited to "5" elements
      | Query                 | Fields                                   |
      | {"attrName": "count"} | {"_id": 0, "attrType": 0, "attrName": 0} |
    Then   I receive a non-empty list with at least one element with the following keys
      | Keys                |
      | recvTime, attrValue |
