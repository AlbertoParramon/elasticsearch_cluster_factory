#!/bin/bash

set -euo pipefail

NS=es-secure
K8S_DIR="./k8s"

minikube start --driver=docker

# Elasticsearch requirements in the Minikube node
minikube ssh -- 'echo "vm.max_map_count=262144" | sudo tee /etc/sysctl.d/99-elastic.conf >/dev/null'
minikube ssh -- 'sudo sysctl --system >/dev/null'

minikube image build -t kub_es_node_img security_cluster
minikube image build -t kub_es_kibana_img kibana

# Applying Manifests
kubectl apply -f "${K8S_DIR}/namespace.yaml"
kubectl apply -n "${NS}" -f "${K8S_DIR}/configmap.yaml"
kubectl apply -n "${NS}" -f "${K8S_DIR}/secrets.yaml"
kubectl apply -n "${NS}" -f "${K8S_DIR}/certs-pvc.yaml"
kubectl apply -n "${NS}" -f "${K8S_DIR}/services.yaml"
kubectl apply -n "${NS}" -f "${K8S_DIR}/elasticsearch-masters-statefulset.yaml"
kubectl apply -n "${NS}" -f "${K8S_DIR}/elasticsearch-data-statefulset.yaml"
kubectl apply -n "${NS}" -f "${K8S_DIR}/kibana-deployment.yaml"

# Final information
kubectl get pods,svc,pvc -n "${NS}" -o wide
