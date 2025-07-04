#!/bin/bash

function get_last_tag {
  REPO="$1"
  PER_PAGE=100
  PAGE=1
  GITHUB_API="https://api.github.com"
  TAGS=()

  while :; do
    RESP=$(curl -s "$GITHUB_API/repos/$REPO/tags?per_page=$PER_PAGE&page=$PAGE")
    COUNT=$(echo "$RESP" | jq length)
    if [ "$COUNT" -eq 0 ]; then
      break
    fi

    TAGS+=($(echo "$RESP" | jq -r '.[] | @base64'))
    PAGE=$((PAGE + 1))
  done

  if [ "${#TAGS[@]}" -eq 0 ]; then
    echo "No tags found for $REPO."
    exit 1
  fi

  LATEST_DATE=""
  LATEST_TAG=""

  for encoded_tag in "${TAGS[@]}"; do
    TAG=$(echo "$encoded_tag" | base64 --decode)
    NAME=$(echo "$TAG" | jq -r '.name')
    SHA=$(echo "$TAG" | jq -r '.commit.sha')

    COMMIT_DATA=$(curl -s "$GITHUB_API/repos/$REPO/commits/$SHA")
    DATE=$(echo "$COMMIT_DATA" | jq -r '.commit.committer.date')

    if [ -z "$LATEST_DATE" ] || [[ "$DATE" > "$LATEST_DATE" ]]; then
      LATEST_DATE="$DATE"
      LATEST_TAG="$NAME"
    fi
  done

  # Extract and clean the repo name
  RAW_NAME=$(echo "$REPO" | cut -d'/' -f2)
  CLEAN_NAME=$(echo "$RAW_NAME" | sed 's/-/ /g')

  echo $CLEAN_NAME
  # Output JSON
  jq -n \
    --arg name "$LATEST_TAG" \
    --arg tag_name "$LATEST_TAG" \
    --arg published_at "$LATEST_DATE" \
    '{name: $name, tag_name: $tag_name, published_at: $published_at}'
}

function get_latest_bitbucked {
  #!/bin/bash

  BASE_URL="https://ec.europa.eu/digital-building-blocks/code"
  PROJECT="EDELIVERY"
  REPO="domibus"

  TAGS_API="$BASE_URL/rest/api/1.0/projects/$PROJECT/repos/$REPO/tags"
  COMMITS_API="$BASE_URL/rest/api/1.0/projects/$PROJECT/repos/$REPO/commits"

  # Accumulator for tag info
  declare -A TAG_DATES

  # Pagination
  START=0
  IS_LAST_PAGE=false

  while [ "$IS_LAST_PAGE" = false ]; do
    RESP=$(curl -s "$TAGS_API?limit=100&start=$START")

    TAGS=$(echo "$RESP" | jq -c '.values[]')

    while IFS= read -r tag; do
      NAME=$(echo "$tag" | jq -r '.displayId')
      COMMIT=$(echo "$tag" | jq -r '.latestCommit')

      # Get commit date
      COMMIT_INFO=$(curl -s "$COMMITS_API/$COMMIT")
      DATE=$(echo "$COMMIT_INFO" | jq -r '.authorTimestamp')

      # Store timestamp → tag mapping
      TAG_DATES["$DATE"]="$NAME"
    done <<< "$TAGS"

    IS_LAST_PAGE=$(echo "$RESP" | jq -r '.isLastPage')
    START=$(echo "$RESP" | jq -r '.nextPageStart')
  done

  # Find the latest date
  LATEST_TIMESTAMP=$(printf "%s\n" "${!TAG_DATES[@]}" | sort -nr | head -n1)
  LATEST_TAG=${TAG_DATES[$LATEST_TIMESTAMP]}

  # Convert milliseconds to ISO date
  LATEST_DATE=$(date -u -d @"$((LATEST_TIMESTAMP / 1000))" --iso-8601=seconds)

  # Print data
  CLEAN_NAME=$(echo "$REPO" | sed 's/-/ /g')
  jq -n \
    --arg name "$CLEAN_NAME" \
    --arg tag_name "$LATEST_TAG" \
    --arg published_at "$LATEST_DATE" \
    '{name: $name, tag_name: $tag_name, published_at: $published_at}'
}

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
  http https://api.github.com/repos/ging/fiware-cosmos-orion-flink-connector/releases/latest | jq '{name, tag_name, published_at}'

  echo "Cosmos Spark"
  http https://api.github.com/repos/ging/fiware-cosmos-orion-spark-connector/releases/latest | jq '{name, tag_name, published_at}'

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

  # Keystone SCIM has no versions only tags
  echo "keystone SCIM"
  # http https://api.github.com/repos/telefonicaid/fiware-keystone-scim/releases/latest | jq '{name, tag_name, published_at}'
  get_last_tag "telefonicaid/fiware-keystone-scim"

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

  echo "BAE Framework APIs"
  http https://api.github.com/repos/FIWARE-TMForum/Business-API-Ecosystem/releases/latest | jq '{name, tag_name, published_at}'

  echo "BAE Charging Backend"
  http https://api.github.com/repos/FIWARE-TMForum/business-ecosystem-charging-backend/releases/latest | jq '{name, tag_name, published_at}'

  echo "BAE Logic Proxy"
  http https://api.github.com/repos/FIWARE-TMForum/business-ecosystem-logic-proxy/releases/latest | jq '{name, tag_name, published_at}'

  echo "BAE Revenue Sharing"
  http https://api.github.com/repos/FIWARE-TMForum/business-ecosystem-rss/releases/latest | jq '{name, tag_name, published_at}'

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
  http https://api.github.com/repos/eProsima/Fast-DDS/releases/latest | jq '{name, tag_name, published_at}'

  echo "Micro XRCE-DDS"
  http https://api.github.com/repos/eProsima/Micro-XRCE-DDS/releases/latest | jq '{name, tag_name, published_at}'

  echo "IoTAgent AAS"
  http https://api.github.com/repos/Engineering-Research-and-Development/iotagent-aas/releases/latest | jq '{name, tag_name, published_at}'

  echo "Web UI for IoTAgent"
  http https://api.github.com/repos/Engineering-Research-and-Development/iotagent-ui/releases/latest | jq '{name, tag_name, published_at}'

  echo "FIROS"
  http https://api.github.com/repos/iml130/firos/releases/latest | jq '{name, tag_name, published_at}'

  # Domibus is in Bitbucked
  echo "Domibus"
  get_latest_bitbucked

  echo "Oliot"
  http https://api.github.com/repos/yalewkidane/FIWARE_EPCIS_Mediation_Gateway/releases/latest | jq '{name, tag_name, published_at}'
}


# print the different options
echo "Select one option:"
echo "1) Execute core analysis"
echo "2) Execute context processing analysis"
echo "3) Execute data/api management analysis"
echo "4) Execute iot analysis"
echo

# Read the number from the user
read -p "Enter a number (1-4): " num

# Call the appropriate function based on the number
case $num in
  1) time core ;;
  2) time context ;;
  3) time data ;;
  4) time iot ;;
  *) echo "Invalid number entered" ;;
esac
