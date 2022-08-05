#!/bin/bash -x

# Quit on error
set -e

#!/bin/bash -e

cd $WORKING_DIR

export JAVA_HOME=/opt/openjdk-8u332


mvn install:install-file \
  -Dfile=./orion.flink.connector-1.2.4.jar \
  -DgroupId=org.fiware.cosmos \
  -DartifactId=orion.flink.connector \
  -Dversion=1.2.4 \
  -Dpackaging=jar

mvn package

filename=$(curl -v -X POST -H "Expect:" -F "jarfile=@target/cosmos-examples-1.2.jar" http://localhost:8081/jars/upload | jq -r .filename)

fnid=$(basename $filename)

# curl -X POST "http://localhost:8081/jars/${fnid}/run?entry-class=org.fiware.cosmos.tutorial.FeedbackLD"
curl -X POST "http://localhost:8081/jars/${fnid}/run?entry-class=org.fiware.cosmos.tutorial.LoggerLD"
