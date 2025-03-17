#!/bin/bash

function core {
  echo "Orion"
  http https://api.github.com/repos/telefonicaid/fiware-orion/releases/latest | jq '{name, tag_name, published_at}'

  echo "Scorpio"
  http https://api.github.com/repos/ScorpioBroker/ScorpioBroker/releases/latest | jq '{name, tag_name, published_at}'

  echo "Orion-LD"
  http https://api.github.com/repos/FIWARE/context.Orion-LD/releases/latest | jq '{name, tag_name, published_at}'

  echo "Stellio"
  http https://api.github.com/repos/stellio-hub/stellio-context-broker/releases/latest | jq '{name, tag_name, published_at}'

  echo "Cygnus"
  http https://api.github.com/repos/telefonicaid/fiware-cygnus/releases/latest | jq '{name, tag_name, published_at}'

  echo "STH-Comet"
  http https://api.github.com/repos/telefonicaid/fiware-sth-comet/releases/latest | jq '{name, tag_name, published_at}'

  echo "Draco"
  http https://api.github.com/repos/ging/fiware-draco/releases/latest | jq '{name, tag_name, published_at}'

  echo "Cosmos Flink"
  http https://api.github.com/repos/ging/fiware-cosmos-orion-flink-connector/tree/374f83d80bbc276661718f66c3d1644f19ca1794/releases/latest | jq '{name, tag_name, published_at}'

  echo "Cosmos Spark"
  http https://api.github.com/repos/ging/fiware-cosmos-orion-spark-connector/tree/5e7cf97f4c6659e8da8af3d41e1bf10f64494046/releases/latest | jq '{name, tag_name, published_at}'

  echo "QuantumLeap"
  http https://api.github.com/repos/orchestracities/ngsi-timeseries-api/releases/latest | jq '{name, tag_name, published_at}'

  echo "Canis Major"
  http https://api.github.com/repos/FIWARE/CanisMajor/releases/latest | jq '{name, tag_name, published_at}'

  echo "NGSI-js Lib"
  http https://api.github.com/repos/ficodes/ngsijs/releases/latest | jq '{name, tag_name, published_at}'

  echo "PySpark"
  http https://api.github.com/repos/Engineering-Research-and-Development/fiware-orion-pyspark-connector/releases/latest | jq '{name, tag_name, published_at}'

  echo "Apollo"
  http https://api.github.com/repos/FIWARE/apollo/releases/latest | jq '{name, tag_name, published_at}'

  echo "O2K Connector"
  http https://api.github.com/repos/Engineering-Research-and-Development/o2k-connector/releases/latest | jq '{name, tag_name, published_at}'
}

function context {
  echo "wirecloud"
  http https://api.github.com/repos/Wirecloud/wirecloud/releases/latest | jq '{name, tag_name, published_at}'

  echo "fogflow"
  http https://api.github.com/repos/smartfog/fogflow/releases/latest | jq '{name, tag_name, published_at}'

  echo "perseo"
  http https://api.github.com/repos/telefonicaid/perseo-core/releases/latest | jq '{name, tag_name, published_at}'
  http https://api.github.com/repos/telefonicaid/perseo-fe/releases/latest | jq '{name, tag_name, published_at}'
}

function data {
  echo "coatrack"
  http https://api.github.com/repos/coatrack/coatrack/releases/latest | jq '{name, tag_name, published_at}'

  echo "endpoint-auth-service"
  http https://api.github.com/repos/FIWARE/endpoint-auth-service/releases/latest | jq '{name, tag_name, published_at}'

  echo "kong plugins"
  http https://api.github.com/repos/FIWARE/kong-plugins-fiware/releases/latest | jq '{name, tag_name, published_at}'

  echo "keyrock"
  http https://api.github.com/repos/ging/fiware-idm/releases/latest | jq '{name, tag_name, published_at}'

  echo "wilma pep proxy"
  http https://api.github.com/repos/ging/fiware-pep-proxy/releases/latest | jq '{name, tag_name, published_at}'

  echo "Authzforce"
  http https://api.github.com/repos/authzforce/server/releases/latest | jq '{name, tag_name, published_at}'

  echo "fiware true connector"
  http https://api.github.com/repos/Engineering-Research-and-Development/fiware-true-connector/releases/latest | jq '{name, tag_name, published_at}'

  echo "steelskin"
  http https://api.github.com/repos/telefonicaid/fiware-pep-steelskin/releases/latest | jq '{name, tag_name, published_at}'

  echo "keypass"
  http https://api.github.com/repos/telefonicaid/fiware-keypass/releases/latest | jq '{name, tag_name, published_at}'

  echo "keystone SCIM"
  http https://api.github.com/repos/telefonicaid/fiware-keystone-scim/releases/latest | jq '{name, tag_name, published_at}'

  echo "keystone spassword"
  http https://api.github.com/repos/telefonicaid/fiware-keystone-spassword/releases/latest | jq '{name, tag_name, published_at}'

  echo "Anubis"
  http https://api.github.com/repos/telefonicaid/fiware-keypass/releases/latest | jq '{name, tag_name, published_at}'

  echo "trusted issuers list service"
  http https://api.github.com/repos/FIWARE/trusted-issuers-list/releases/latest | jq '{name, tag_name, published_at}'

  echo "DSBA PDP"
  http https://api.github.com/repos/FIWARE/dsba-pdp/releases/latest | jq '{name, tag_name, published_at}'

  echo "VC verifier"
  http https://api.github.com/repos/FIWARE/VCVerifier/releases/latest | jq '{name, tag_name, published_at}'

  echo "keycloak vc-issuer"
  http https://api.github.com/repos/FIWARE/keycloak-vc-issuer/releases/latest | jq '{name, tag_name, published_at}'

  echo "Credentials config service"
  http https://api.github.com/repos/FIWARE/credentials-config-service/releases/latest | jq '{name, tag_name, published_at}'

  echo "trusted issuers registry"
  http https://api.github.com/repos/FIWARE/trusted-issuers-registry/releases/latest | jq '{name, tag_name, published_at}'

  echo "CKAN extensions"
  http https://api.github.com/repos/conwetlab/FIWARE-CKAN-Extensions/releases/latest | jq '{name, tag_name, published_at}'

  echo "BAE"
  http https://api.github.com/repos/FIWARE-TMForum/Business-API-Ecosystem/releases/latest | jq '{name, tag_name, published_at}'

  echo "Idra"
  http https://api.github.com/repos/OPSILab/Idra/releases/latest | jq '{name, tag_name, published_at}'
}

function iot {
  echo "Kurento"
  http https://api.github.com/repos/Kurento/kurento-media-server/releases/latest | jq '{name, tag_name, published_at}'

  echo "OpenVidu"
  http https://api.github.com/repos/OpenVidu/openvidu/releases/latest | jq '{name, tag_name, published_at}'

  echo "IoTAgent Node Lib"
  http https://api.github.com/repos/telefonicaid/iotagent-node-lib/releases/latest | jq '{name, tag_name, published_at}'

  echo "IoTAgent JSON"
  http https://api.github.com/repos/telefonicaid/iotagent-json/releases/latest | jq '{name, tag_name, published_at}'

  echo "IoTAgent LWM2M"
  http https://api.github.com/repos/telefonicaid/lightweightm2m-iotagent/releases/latest | jq '{name, tag_name, published_at}'

  echo "IoTAgent UL"
  http https://api.github.com/repos/telefonicaid/iotagent-ul/releases/latest | jq '{name, tag_name, published_at}'

  echo "IoTAgent LoRaWAN"
  http https://api.github.com/repos/Atos-Research-and-Innovation/IoTagent-LoRaWAN/releases/latest | jq '{name, tag_name, published_at}'

  http https://api.github.com/repos/Engineering-Research-and-Development/iotagent-opcua/releases/latest | jq '{name, tag_name, published_at}'

  echo "IoTAgent Sigfox"
  http https://api.github.com/repos/telefonicaid/sigfox-iotagent/releases/latest | jq '{name, tag_name, published_at}'

  echo "IoTAgent ISOXML"
  http https://api.github.com/repos/FIWARE/iotagent-isoxml/releases/latest | jq '{name, tag_name, published_at}'

  echo "OpenMTC"
  http https://api.github.com/repos/OpenMTC/OpenMTC/releases/latest | jq '{name, tag_name, published_at}'

  echo "Fast DDS"
  http https://api.github.com/repos/eProsima/Fast-RTPS/releases/latest | jq '{name, tag_name, published_at}'

  echo "Micro XRCE-DDS"
  http https://api.github.com/repos/eProsima/Micro-XRCE-DDS/releases/latest | jq '{name, tag_name, published_at}'

  echo "IoTAgent AAS"
  http https://api.github.com/repos/Engineering-Research-and-Development/iotagent-aas/releases/latest | jq '{name, tag_name, published_at}'

  echo "Web UI for IoTAgent"
  http https://api.github.com/repos/Engineering-Research-and-Development/iotagent-ui/releases/latest | jq '{name, tag_name, published_at}'

  echo "FIROS"
  http https://api.github.com/repos/iml130/firos/releases/latest | jq '{name, tag_name, published_at}'

  echo "Domibus"
  #http https://ec.europa.eu/digital-building-blocks/wikis/display/DIGITAL/eDelivery/releases/latest | jq '{name, tag_name, published_at}'

  echo "Oliot"
  http https://api.github.com/repos/yalewkidane/FIWARE_EPCIS_Mediation_Gateway/releases/latest | jq '{name, tag_name, published_at}'
}

function all {
  echo "all"
}



# print the different options
echo "Select one option:"
echo "1) Execute core analysis"
echo "2) Execute context processing analysis"
echo "3) Execute data/api management analysis"
echo "4) Execute iot analysis"
echo "5) Execute all tests"
echo

# Read the number from the user
read -p "Enter a number (1-5): " num

# Call the appropriate function based on the number
case $num in
  1) time core ;;
  2) time context ;;
  3) time data ;;
  4) time iot ;;
  5) time all ;;
  *) echo "Invalid number entered" ;;
esac
