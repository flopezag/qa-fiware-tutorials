#!/bin/bash

echo "... running the other script....."

docker exec -i spark-worker-1 /spark/bin/spark-submit  \
--class  org.fiware.cosmos.tutorial.FeedbackLD \
--master  spark://spark-master:7077 \
--deploy-mode client /home/cosmos-examples/target/cosmos-examples-1.2.2.jar \
--conf "spark.driver.extraJavaOptions=-Dlog4jspark.root.logger=WARN,console"
