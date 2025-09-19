# Elasticsearch Cluster Factory

This project provides Docker containers for running Elasticsearch in both single-node and multi-node cluster configurations.

## Single Node Setup

### Prerequisites
- Docker installed and running
- At least 2GB of available RAM
- Ports 9200 and 9300 available on your host

### Quick Start (Single Node)

#### 1. Clean Environment (Optional)
```bash
# Stop all running containers
docker stop $(docker ps -a -q)

# Remove all containers
docker rm $(docker ps -a -q)

# Remove dangling images
docker rmi $(docker images | grep none | awk -F' ' '{print$3}')
```

#### 2. Build and Run
```bash
# Build the single-node Elasticsearch image
docker build -f Dockerfile_single -t elasticsearch-cluster-factory .

# Run the container
docker run -d -p 9200:9200 -p 9300:9300 --name elasticsearch_single_node elasticsearch-cluster-factory
```

#### 3. Verify Installation
```bash
# Access the container
docker exec -it elasticsearch_single_node bash

# Test Elasticsearch (from inside the container)
curl -XGET http://localhost:9200/

# Or test from host
curl -XGET http://localhost:9200/
```
