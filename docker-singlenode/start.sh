#!/bin/bash

# Install and start
docker build -t elasticsearch_singlenode_img .
docker run -d -p 9200:9200 -p 9300:9300 --name elasticsearch_singlenode_container elasticsearch_singlenode_img
