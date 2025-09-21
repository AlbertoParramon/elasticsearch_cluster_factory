#!/bin/bash

# Clean
docker stop elasticsearch_singlenode_container
docker rm   elasticsearch_singlenode_container
docker rmi  elasticsearch_singlenode_img
