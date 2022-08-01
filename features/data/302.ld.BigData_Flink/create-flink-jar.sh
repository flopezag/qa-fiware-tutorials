#!/bin/bash -x

# Quit on error
set -e
#
#cd /tmp/tutorials.Big-Data-Flink/cosmos-examples
#
#mvn install:install-file \
#  -Dfile=./orion.flink.connector-1.2.4.jar \
#  -DgroupId=org.fiware.cosmos \
#  -DartifactId=orion.flink.connector \
#  -Dversion=1.2.4 \
#  -Dpackaging=jar
#
# mvn package

DIRNAME=$(dirname $0)

cp $DIRNAME/cosmos-examples-1.2.jar /tmp

curl -v -X POST -H "Expect:" -F "jarfile=@/tmp/cosmos-examples-1.2.jar" http://localhost:8081/jars/upload

