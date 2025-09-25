# Elasticsearch Cluster Factory

This project provides Docker containers for running Elasticsearch in both single-node and multi-node cluster configurations. We use docker, docker-compose, kubernetes and terraform.

## Prerequisites
- Docker, docker-compose and Kubernetes installed and running
- At least 2GB of available RAM
- Ports 9200 and 9300 available on your host

### My prerequisites installation
```bash
# Basic requirements: docker and docker-compose
sudo apt-get update
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc
   
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
   
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

sudo usermod -aG docker $USER
sudo systemctl start docker
sudo systemctl enable docker

# For docker-multinode
sudo sysctl -w vm.max_map_count=262144

# For kubernetes-security_cluster_and_kibana
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube
minikube start --driver=docker

curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x kubectl
sudo mv kubectl /usr/local/bin/
kubectl version --client

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
It works the same way as docker-singlenode and docker-multinode. Also you can open the following link in your browser: 

[https://localhost:5601](https://localhost:5601)

<img width="720" height="272" alt="docker" src="https://github.com/user-attachments/assets/9a87f915-e5a8-47cb-82c4-b0ad19357c3a" />

### kubernetes-security\_cluster\_and\_kibana
It works the same way as docker-security\_cluster\_and\_kibana. Also you have the debug.sh for more details about the deployment
```bash
# 3bis. Execute debug.sh to see some details about the deployment
./debug.sh
```

