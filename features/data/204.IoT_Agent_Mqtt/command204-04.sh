#!/bin/bash

docker run -i --rm --name mqtt-publisher --network \
  fiware_default efrecon/mqtt-client pub -h mosquitto -m "c|1" \
  -t "/4jggokgpepnvsb2uv4s40d59ov/motion001/attrs"
