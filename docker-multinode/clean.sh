#!/bin/bash

# Clean
docker compose down --rmi all -v
docker rmi $( docker images | grep docker-multinode | awk -F' ' '{print$3}') 
