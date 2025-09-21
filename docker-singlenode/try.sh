#!/bin/bash

# Try it
set -x
curl -XGET http://localhost:9200/_cluster/health?pretty
curl -XGET http://localhost:9200/
set +x
echo -e "# You can enter inside the container by executing this command:"
echo -e	"docker exec -it elasticsearch_singlenode_container bash"
