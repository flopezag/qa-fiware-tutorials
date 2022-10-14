#!/bin/bash -e

cd $WORKING_DIR

export JAVA_HOME=/opt/jdk1.8.0_333

if [ ! -d /tmp/spark_connector ]; then
mkdir /tmp/spark_connector

mvn install:install-file \
  -Dfile=./orion.spark.connector-1.2.2.jar \
  -DgroupId=org.fiware.cosmos \
  -DartifactId=orion.spark.connector \
  -Dversion=1.2.2 \
  -Dpackaging=jar

mvn package

   cp target/*.jar /tmp/spark_connector
else 
   mkdir target
   cp /tmp/spark_connector/*jar target
fi
