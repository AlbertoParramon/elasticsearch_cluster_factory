# Elasticsearch Cluster Factory

This project provides Docker containers for running Elasticsearch in both single-node and multi-node cluster configurations. We use docker, docker-compose, kubernetes and terraform.

## Prerequisites
- Docker installed and running
- At least 2GB of available RAM
- Ports 9200 and 9300 available on your host

### My prerequisites installation
```bash
TO DO
# For docker-multinode
sudo sysctl -w vm.max_map_count=262144
```

## Quick Start

### docker-singlenode and docker-multinode
```bash
# 1. Clone the repository and enter in docker-singlenode/docker-multinode directory
# 2. Execute start.sh script
./start.sh

# 3. After a few seconds execute try.sh script to test it
sleep 30
./try.sh

# 4. Clean container and image
./clean.sh
```

### docker-security\_cluster\_and\_kibana
It works the same way as docker-singlenode and docker-multinode. Also you can open the following link in your browser: [https://localhost:5601](https://localhost:5601)

