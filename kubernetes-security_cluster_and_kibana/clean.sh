#!/usr/bin/env bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
K8S_DIR="${SCRIPT_DIR}/k8s"

kubectl delete -f "${K8S_DIR}/elasticsearch-data-statefulset.yaml"
kubectl delete -f "${K8S_DIR}/elasticsearch-masters-statefulset.yaml"
kubectl delete -f "${K8S_DIR}/kibana-deployment.yaml"
kubectl delete -f "${K8S_DIR}/services.yaml"
kubectl delete -f "${K8S_DIR}/configmap.yaml"
kubectl delete -f "${K8S_DIR}/secrets.yaml"
kubectl delete -f "${K8S_DIR}/certs-pvc.yaml"
kubectl delete -f "${K8S_DIR}/namespace.yaml"

eval "$(minikube -p minikube docker-env)"
docker rmi $(docker images | grep kub_es   | awk -F' ' '{print$3}')
eval "$(minikube -p minikube docker-env -u)"

minikube stop
minikube delete --all --purge
docker rmi $(docker images | grep minikube | awk -F' ' '{print$3}')