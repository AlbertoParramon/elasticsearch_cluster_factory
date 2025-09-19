#!/bin/bash

# Load variables
#source docker-vars.env

# Clean
docker stop $(docker ps -a  -q)
docker rm $(docker ps -a  -q)
docker-compose down --volumes --remove-orphans

# Start
docker-compose up --build -d
