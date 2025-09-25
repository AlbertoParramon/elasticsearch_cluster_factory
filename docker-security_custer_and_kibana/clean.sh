#!/bin/bash

# Clean
docker compose down --rmi all -v
docker rmi $( docker images | grep docker-security_custer_and_kibana | awk -F' ' '{print$3}') 
