#!/bin/bash

ES_PASS=example1234

# Try it
set -x
curl -k -XGET https://elastic:${ES_PASS}@localhost:9201/
curl -k -XGET https://elastic:${ES_PASS}@localhost:9202/_cluster/health?pretty
curl -k -XGET https://elastic:${ES_PASS}@localhost:9203/_cat/nodes
set +x
