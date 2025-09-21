#!/bin/bash

# Try it
set -x
curl -XGET http://localhost:9200/
curl -XGET http://localhost:9201/_cluster/health?pretty
curl -XGET http://localhost:9203/_cat/nodes?pretty
set +x
