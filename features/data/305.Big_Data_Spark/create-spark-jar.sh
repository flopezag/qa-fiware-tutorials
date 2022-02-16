#!/bin/bash

# FIXME -- Just as testing environment
set > /tmp/fooox


mvn install:install-file \
  -Dfile=./orion.spark.connector-1.2.2.jar \
  -DgroupId=org.fiware.cosmos \
  -DartifactId=orion.spark.connector \
  -Dversion=1.2.2 \
  -Dpackaging=jar


mvn package

sudo chown  -R jicg.jicg /tmp/tutorial*

