#!/bin/bash

git clone https://github.com/FIWARE/tutorials.IoT-Agent.git /tmp/tutorials.IoT-Agent
cd /tmp/tutorials.IoT-Agent
./services create
./services start


curl -vX GET \
  'http://localhost:4041/iot/about'


curl -viX POST \
  'http://localhost:4041/iot/services' \
  -H 'Content-Type: application/json' \
  -H 'fiware-service: openiot' \
  -H 'fiware-servicepath: /' \
  -d '{
 "services": [
   {
     "apikey":      "4jggokgpepnvsb2uv4s40d59ov",
     "cbroker":     "http://orion:1026",
     "entity_type": "Thing",
     "resource":    "/iot/d"
   }
 ]
}'


curl -viX POST \
  'http://localhost:4041/iot/devices' \
  -H 'Content-Type: application/json' \
  -H 'fiware-service: openiot' \
  -H 'fiware-servicepath: /' \
  -d '{
 "devices": [
   {
     "device_id":   "motion001",
     "entity_name": "urn:ngsi-ld:Motion:001",
     "entity_type": "Motion",
     "timezone":    "Europe/Berlin",
     "attributes": [
       { "object_id": "c", "name": "count", "type": "Integer" }
     ],
     "static_attributes": [
       { "name":"refStore", "type": "Relationship", "value": "urn:ngsi-ld:Store:001"}
     ]
   }
 ]
}
'

curl -iX POST \
  'http://localhost:7896/iot/d?k=4jggokgpepnvsb2uv4s40d59ov&i=motion001' \
  -H 'Content-Type: text/plain' \
  -d 'c|1'


curl -vG -X GET \
  'http://localhost:1026/v2/entities/urn:ngsi-ld:Motion:001' \
  -d 'type=Motion' \
  -H 'fiware-service: openiot' \
  -H 'fiware-servicepath: /'
