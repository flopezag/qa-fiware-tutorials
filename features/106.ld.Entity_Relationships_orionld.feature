Feature: test tutorial 106 NGSI-LD Entity Relationships (Orion-LD)
    This is feature file of the FIWARE step by step tutorial for Entity RelationshipsPayloads (Orion-LD)

    #
    #   Parameters to be considered
    #
    url: https://ngsi-ld-tutorials.readthedocs.io/en/latest/entity-relationships.html
    git-clone: https://github.com/FIWARE/tutorials.Entity-Relationships.git
    git-directory: /tmp/tutorials.Entity-Relationships

    shell-commands: git checkout NGSI-LD; ./services create; ./services orion
    clean-shell-commands: ./services stop

    Background:
        Given I set the tutorial 106.NGSI-LD

    Scenario: [106.1] Create Multiple TemperatureSensor Entities
      When  I prepare a POST HTTP request for "creating multiple TemperatureSensor entities" to "http://localhost:1026/ngsi-ld/v1/entityOperations/upsert"
      And   I set header Content-Type to application/json
      And   I set header Link to <http://context/user-context.jsonld>; rel="http://www.w3.org/ns/json-ld#context"; type="application/ld+json"
      And   I set header Accept to application/ld+json
      And   I set the body request as described in "request106_01_create_temp_sensors.json"
      And   I perform the request
      Then  I receive a HTTP response with the following orion-ld data
            | Status-Code |
            | 201         |

    Scenario: [106.2] Create Multiple FillingLevelSensor Entities
      When  I prepare a POST HTTP request for "creating multiple FillingLevelSensor entities" to "http://localhost:1026/ngsi-ld/v1/entityOperations/upsert"
      And   I set header Content-Type to application/json
      And   I set header Link to <http://context/user-context.jsonld>; rel="http://www.w3.org/ns/json-ld#context"; type="application/ld+json"
      And   I set the body request as described in "request106_02_create_fill_sensors.json"
      And   I perform the request
      Then  I receive a HTTP response with the following orion-ld data
            | Status-Code |
            | 201         |

    Scenario: [106.3] Get All TemperatureSensor and FillingLevelSensor Entities
      When  I prepare a GET HTTP request for "getting all TemperatureSensor and FillingLevelSensor entities" to "http://localhost:1026/ngsi-ld/v1/entities/"
      And   I set header Link to <http://context/user-context.jsonld>; rel="http://www.w3.org/ns/json-ld#context"; type="application/ld+json"
      And   I set the params equal to "type=TemperatureSensor,FillingLevelSensor"
      And   I set the params equal to "options=keyValues"
      And   I perform the request
      Then  I receive from Orion-LD "200" response code with the body equal to "response106_03_get_all_sensors.json"

    Scenario: [106.4] Update Existing Sensors with controlledAsset Relationship (Batch)
      When  I prepare a POST HTTP request for "batch updating sensors with controlledAsset" to "http://localhost:1026/ngsi-ld/v1/entityOperations/update"
      And   I set header Content-Type to application/json
      And   I set header Link to <http://context/user-context.jsonld>; rel="http://www.w3.org/ns/json-ld#context"; type="application/ld+json"
      And   I set the params equal to "options=update"
      And   I set the body request as described in "request106_04_update_sensors_relationship.json"
      And   I perform the request
      Then  I receive a HTTP response with the following orion-ld data
            | Status-Code |
            | 204         |

    Scenario: [106.5] Get a Specific TemperatureSensor (to see controlledAsset)
      When  I prepare a GET HTTP request for "getting specific TemperatureSensor" to "http://localhost:1026/ngsi-ld/v1/entities/urn:ngsi-ld:TemperatureSensor:001"
      And   I set header Link to <http://context/user-context.jsonld>; rel="http://www.w3.org/ns/json-ld#context"; type="application/ld+json"
      And   I set the params equal to "options=keyValues"
      And   I perform the request
      Then  I receive from Orion-LD "200" response code with the body equal to "response106_05_get_temp_sensor_001.json"

    Scenario: [106.6] Get controlledAsset from a Specific TemperatureSensor
      When  I prepare a GET HTTP request for "getting controlledAsset from TemperatureSensor" to "http://localhost:1026/ngsi-ld/v1/entities/urn:ngsi-ld:TemperatureSensor:001"
      And   I set header Link to <http://context/user-context.jsonld>; rel="http://www.w3.org/ns/json-ld#context"; type="application/ld+json"
      And   I set header Accept to application/json
      And   I set the params equal to "options=keyValues"
      And   I set the params equal to "attrs=controlledAsset"
      And   I perform the request
      Then  I receive from Orion-LD "200" response code with the body equal to "response106_06_get_sensor_controlled_asset.json"

    Scenario: [106.7] Query Devices by controlledAsset (Parent to Child)
      When  I prepare a GET HTTP request for "querying devices by controlledAsset" to "http://localhost:1026/ngsi-ld/v1/entities/"
      And   I set header Link to <http://context/user-context.jsonld>; rel="http://www.w3.org/ns/json-ld#context"; type="application/ld+json"
      And   I set the params equal to "q=controlledAsset==\"urn:ngsi-ld:Building:farm001\""
      And   I set the params equal to "options=keyValues"
      And   I perform the request
      Then  I receive from Orion-LD "200" response code with the body equal to "response106_07_query_devices_by_asset.json"

    Scenario: [106.8] Count Devices by controlledAsset
      When  I prepare a GET HTTP request for "counting devices by controlledAsset" to "http://localhost:1026/ngsi-ld/v1/entities/"
      And   I set header Link to <http://context/user-context.jsonld>; rel="http://www.w3.org/ns/json-ld#context"; type="application/ld+json"
      And   I set the params equal to "q=controlledAsset==\"urn:ngsi-ld:Building:farm001\""
      And   I set the params equal to "options=keyValues"
      And   I set the params equal to "count=true"
      And   I set the params equal to "limit=0"
      And   I perform the request
      Then  I receive a HTTP response with the following orion-ld data
            | Status-Code | NGSILD-Results-Count |
            | 200         | 2                    |

    Scenario: [106.9] Create a Task Entity (Many-to-Many)
      When  I prepare a POST HTTP request for "creating a Task entity" to "http://localhost:1026/ngsi-ld/v1/entities/"
      And   I set header Content-Type to application/json
      And   I set header Link to <http://context/user-context.jsonld>; rel="http://www.w3.org/ns/json-ld#context"; type="application/ld+json"
      And   I set the body request as described in "request106_09_create_task.json"
      And   I perform the request
      Then  I receive a HTTP response with the following orion-ld data
            | Status-Code | Location             |
            | 201         | urn:ngsi-ld:Task:001 |

    Scenario: [106.10] Query Tasks by field (Reading from Bridge Table)
      When  I prepare a GET HTTP request for "querying tasks by field" to "http://localhost:1026/ngsi-ld/v1/entities/"
      And   I set header Link to <http://context/user-context.jsonld>; rel="http://www.w3.org/ns/json-ld#context"; type="application/ld+json"
      And   I set header Accept to application/json
      And   I set the params equal to "type=Task"
      And   I set the params equal to "q=field==\"urn:ngsi-ld:PartField:002\""
      And   I set the params equal to "options=keyValues"
      And   I set the params equal to "attrs=worker"
      And   I perform the request
      Then  I receive from Orion-LD "200" response code with the body equal to "response106_10_query_tasks_by_field.json"

    Scenario: [106.11] Query Tasks by product (Reading from Bridge Table)
      When  I prepare a GET HTTP request for "querying tasks by product" to "http://localhost:1026/ngsi-ld/v1/entities/"
      And   I set header Link to <http://context/user-context.jsonld>; rel="http://www.w3.org/ns/json-ld#context"; type="application/ld+json"
      And   I set header Accept to application/json
      And   I set the params equal to "type=Task"
      And   I set the params equal to "q=product==\"urn:ngsi-ld:Herbicide:001\""
      And   I set the params equal to "options=keyValues"
      And   I set the params equal to "attrs=field"
      And   I perform the request
      Then  I receive from Orion-LD "200" response code with the body equal to "response106_11_query_tasks_by_product.json"

    Scenario: [106.12] Get temperature from a Building (Relationship of Property)
      When  I prepare a GET HTTP request for "getting temperature from Building" to "http://localhost:1026/ngsi-ld/v1/entities/urn:ngsi-ld:Building:farm001"
      And   I set header Link to <http://context/user-context.jsonld>; rel="http://www.w3.org/ns/json-ld#context"; type="application/ld+json"
      And   I set header Accept to application/json
      And   I set the params equal to "attrs=temperature"
      And   I perform the request
      Then  I receive from Orion-LD "200" response code with the body equal to "response106_12_get_building_temperature.json"