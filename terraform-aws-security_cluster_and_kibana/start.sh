#!/bin/bash

set -euo pipefail

AWS_ZONE=eu-west-1
AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
ELASTICSEARCH_IMG=${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_ZONE}.amazonaws.com/aws-es-node-img-repository:latest
KIBANA_IMG=${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_ZONE}.amazonaws.com/aws-es-kibana-img-repository:latest

# Initialize Terraform
terraform init
terraform apply -auto-approve

# Get EFS file system ID and update storage-class.yaml
EFS_FILE_SYSTEM_ID=$(terraform output -raw efs_file_system_id)
sed -i "s/fileSystemId: .*/fileSystemId: $EFS_FILE_SYSTEM_ID/" k8s/storage-class.yaml

# Configure kubectl to use the new cluster
aws eks update-kubeconfig --region ${AWS_ZONE} --name elasticsearch-cluster

# Build Docker images
docker build -t aws-es-node-img security_cluster/
docker build -t aws-es-kibana-img kibana/

# Create ECR repositories
aws ecr create-repository --repository-name aws-es-node-img-repository
aws ecr create-repository --repository-name aws-es-kibana-img-repository

# Tag and push images to ECR
docker tag aws-es-node-img:latest   ${ELASTICSEARCH_IMG}
docker tag aws-es-kibana-img:latest ${KIBANA_IMG}
sed -i "s|image: .*|image: ${ELASTICSEARCH_IMG}|" k8s/elasticsearch-masters-statefulset.yaml
sed -i "s|image: .*|image: ${ELASTICSEARCH_IMG}|" k8s/elasticsearch-data-statefulset.yaml
sed -i "s|image: .*|image: ${KIBANA_IMG}|" k8s/kibana-deployment.yaml
aws ecr get-login-password --region ${AWS_ZONE} | docker login --username AWS --password-stdin ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_ZONE}.amazonaws.com
docker push ${ELASTICSEARCH_IMG}
docker push ${KIBANA_IMG}

# Apply kubernetesmanifests
kubectl apply -f "k8s/namespace.yaml"
kubectl apply -f "k8s/storage-class.yaml"
kubectl apply -f "k8s/configmap.yaml"
kubectl apply -f "k8s/secrets.yaml"
kubectl apply -f "k8s/certs-pvc.yaml"
kubectl apply -f "k8s/services.yaml"
kubectl apply -f "k8s/elasticsearch-masters-statefulset.yaml"
kubectl apply -f "k8s/elasticsearch-data-statefulset.yaml"
kubectl apply -f "k8s/kibana-deployment.yaml"

# Apply EFS CSI driver
kubectl apply -k "github.com/kubernetes-sigs/aws-efs-csi-driver/deploy/kubernetes/overlays/stable/?ref=release-1.7"
kubectl annotate serviceaccount efs-csi-controller-sa \
  -n kube-system \
  eks.amazonaws.com/role-arn=arn:aws:iam::${AWS_ACCOUNT_ID}:role/elasticsearch-cluster-efs-csi-driver
kubectl rollout restart deployment/efs-csi-controller -n kube-system