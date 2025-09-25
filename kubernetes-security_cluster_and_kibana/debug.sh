#!/bin/bash

NS="es-secure"

echo "You can inspect your cluster with the following commands:"
echo "---------------------------------------------------------"
echo "# This first commands you can execute at every moment"
set -x

minikube image ls

kubectl get pv,pvc -A

echo "you can see the minikube cluster running on your machine with docker"
docker ps -a | grep minikube
docker images | grep minikube

set +x


echo "---------------------------------------------------------"
echo "minikube ssh #to ssh into minikube"
echo "# Inside minikube, you can inspect the cluster with the following commands:"
echo "docker ps -a #to see containers inside minikube"
echo "docker images #to see images inside minikube"

echo "# If something is not working, you can inspect that:"
echo "docker exec -it elasticsearch-master-1 bash"
echo "docker logs elasticsearch-master-1"


echo "---------------------------------------------------------"
echo "# Outside minikube, you can inspect the cluster with the following command:"
echo "NS='es-secure'"
echo "kubectl get nodes,pods,svc,pvc -n ${NS} -o wide"
echo "# If something is not working, you can inspect that:"
echo "kubectl describe pod kibana-59bcc8c645-6tgqc -n ${NS}"


