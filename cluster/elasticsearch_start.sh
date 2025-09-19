#!/bin/bash

envsubst < src/config/elasticsearch.yml.tpl > src/config/elasticsearch.yml
src/bin/elasticsearch -d &> logs/elasticsearch_start.log 
sleep infinity