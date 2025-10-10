# Elasticsearch Cluster Factory

In this project, you can practice creating custom images for Elasticsearch and deploying them in clusters using Docker, Kubernetes, Terraform, and AWS.
The code in the subdirectories is partially repeated, but we have kept it that way intentionally to allow gradual learning — starting with simpler setups (docker-singlenode) and progressing to more complex ones (terraform-aws-cluster).

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

###################################################
# For kubernetes-security_cluster_and_kibana
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube
minikube start --driver=docker

curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x kubectl
sudo mv kubectl /usr/local/bin/
kubectl version --client

###################################################
# For terraform-aws-security_cluster_and_kibana
# Install terraform in Linux
curl -fsSL https://releases.hashicorp.com/terraform/$(curl -s https://checkpoint-api.hashicorp.com/v1/check/terraform | jq -r .current_version)/terraform_$(curl -s https://checkpoint-api.hashicorp.com/v1/check/terraform | jq -r .current_version)_linux_amd64.zip -o terraform.zip
unzip terraform.zip
sudo mv terraform /usr/local/bin/
terraform -v

# Open an AWS account

# Install AWS CLI
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
aws --version
	
# Configure IAM ROLE inside AWS console
# IAM -> users -> Create user with AdministratorAccess
# Obtain access key ID and secret access key -> Click in "Create access key", and typing a name
Access key: *************
Secret access key: **********

# Configure AWS CLI
aws configure
# Fill it with access key, secret access key, eu-west-1 and json
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

### terraform-aws-security\_cluster\_and\_kibana
It works the same way as  kubernetes-security\_cluster\_and\_kibana. But we recommend waiting at least 3 minutes after running ./start.sh before executing ./try.sh.

Observation: We could have used ECK, but in this case, we decided to take a different approach in order to learn more about AWS.

You can expect an output like this:
<img width="1574" height="469" alt="terminal1" src="https://github.com/user-attachments/assets/9dc93c10-34be-42a9-b1c6-4b902a3010d8" />


You can also check te AWS console

<img width="1514" height="694" alt="aws1" src="https://github.com/user-attachments/assets/295b1cb3-21af-47d2-91a3-e6277504fc01" />

<img width="1539" height="771" alt="aws2" src="https://github.com/user-attachments/assets/9f18d4c4-9d8c-4049-805a-1a0d6edbd95f" />
