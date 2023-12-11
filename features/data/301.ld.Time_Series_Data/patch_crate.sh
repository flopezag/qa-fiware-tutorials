#!/bin/bash

cat << EOT > /tmp/crate_db_config.yml
# Crate Configuration

network.host: _eth0_

# Paths
path:
  logs: /data/log
  data: /data/data
blobs:
  path: /data/blobs
EOT


sed -i '181 a\ \ \ \ \ \ - /tmp/crate_db_config.yml:/crate/config/crate.yml' /tmp/Time-Series-Data/docker-compose/common.yml
