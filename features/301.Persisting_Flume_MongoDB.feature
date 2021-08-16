Feature: test tutorial 301.Persisting Context Data using Apache Flume (MongoDB)

  This is the feature file of the FIWARE Step by Step tutorial for Persisting Context Data using Apache Flume (MongoDB, MySQL, PostgreSQL)
  url: https://fiware-tutorials.readthedocs.io/en/latest/historic-context-flume.html
  git-clone: https://github.com/FIWARE/tutorials.Historic-Context-Flume.git
  git-directory: /tmp/tutorials.Historic-Context-Flume
  shell-commands: ./services create; ./services mongodb
  clean-shell-commands: ./services stop


  Background:
    Given I set the tutorial 301


  Scenario: 01 - Checking the Cygnus service health
    When  I send GET HTTP request to "http://localhost:5080/v1/version"
    Then  I receive a HTTP "200" response code with the body "response301-01.json"

  Scenario: Getting API key for lamp and door
    Given  The fiware-service header is "openiot" and the fiware-servicepath header is "/"
    When   I send GET HTTP request to "http://localhost:4041/iot/services" with fiware-service and fiware-servicepath
    Then  I receive a HTTP "200" response code with all the services information

  Scenario Outline: Generating context data
    Given  The fiware-service header is "openiot" and the fiware-servicepath header is "/"
    When   I send PATCH HTTP request with the following data
      | Url                      | Entity_ID   | Command |
      | http://localhost:1026/v2 | <entity_id> | <command> |
    Then  I receive a HTTP "204" response

    Examples:
        | command | entity_id |
        | unlock  | Door:001  |
        | on      | Lamp:001  |

  Scenario: 02 - Subscribing to context changes
    Given  The fiware-service header is "openiot" and the fiware-servicepath header is "/"
    When   I send a subscription to the Url "http://localhost:1026/v2/subscriptions" and payload "request301-02.json"
    Then   I receive a HTTP "201" response

  Scenario: 03 - Get all subscription
    Given  The fiware-service header is "openiot" and the fiware-servicepath header is "/"
    When   I send GET HTTP request to "http://localhost:1026/v2/subscriptions" with fiware-service and fiware-servicepath
    Then   I receive a HTTP "200" response code with the body "response303-03.json" and exclusions "03.excludes"

  Scenario: 04 - Show available databases on the MongoDB server
    Given  We connect to the MongoDB with the host "localhost" and the port "27017"
    When   We request the available MongoDB databases
    Then   We obtain the following databases
      | Databases                                                   |
      | admin, iotagentul, local, orion, orion-openiot, sth_openiot |

  Scenario: 05 - Read historical context from the MongoDB server - show collections
    Given  We connect to the MongoDB with the host "localhost" and the port "27017"
    When   We request the available MongoDB collections from the database "sth_openiot"
    Then   We obtain "32" total collections from MongoDB

  Scenario: 06 - Read historical context from the MongoDB server - query some data from Door001 sensor
    Given  We connect to the MongoDB with the host "localhost" and the port "27017"
    When   We request "5" elements from the database "sth_openiot" and the collection "sth_/_Door:001_Door"
    Then   I receive a list with "5" elements
    And    With the following keys
      | Keys                                         |
      | _id, recvTime, attrName, attrType, attrValue |

  Scenario: 07 - Read historical context from the MongoDB server - query some data from Motion001 sensor
    Given  We connect to the MongoDB with the host "localhost" and the port "27017"
    When   We request information from the database "sth_openiot" and the collection "sth_/_Motion:001_Motion"
    And    With the following filter query and and filter fields, limited to "5" elements
      | Query                 | Fields                                   |
      | {"attrName": "count"} | {"_id": 0, "attrType": 0, "attrName": 0} |

    Then   I receive a list with "5" elements
    And    With the following keys
      | Keys                |
      | recvTime, attrValue |
