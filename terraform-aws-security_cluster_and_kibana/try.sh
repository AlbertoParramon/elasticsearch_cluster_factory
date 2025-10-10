#!/bin/bash

NS=es-secure
PASS=example1234

# Pods inside the namespace ${NS} AWS
echo "Pods inside the namespace ${NS} AWS"
kubectl get nodes,pods,svc,pvc -n ${NS} -o wide

# detail of the pods inside the namespace ${NS}
echo "# Detail of the pods inside the namespace ${NS}. Execute:"
echo "kubectl describe pod es-master-0 -n ${NS}"
echo "kubectl logs es-master-0 -n ${NS}"

# Enter in a pod inside the namespace ${NS}
echo "#Enter in a pod inside the namespace ${NS}. Execute:"
echo "kubectl exec -it es-master-0 -n ${NS} -- bash"

# pods inside the namespace default of AWS
echo "# Pods inside the namespace default of AWS"
kubectl get nodes,pods,svc,pvc  -o wide
# pods of all namespaces that run in the node
echo "# Pods of all namespaces that run in the node"
kubectl get pods -A -o wide

# Check if the elasticsearch and kibana are working
kubectl exec -it es-master-0 -n ${NS} -- curl -k -s -u elastic:${PASS} https://localhost:9200/_cluster/health?pretty
KIBANA_POD=$(kubectl get pods -n ${NS} -l app=kibana -o jsonpath='{.items[0].metadata.name}')
kubectl exec -n ${NS} ${KIBANA_POD} -- curl -k -s -o /dev/null -w "%{http_code}" https://localhost:5601/login
echo ""
KIBANA_URL=$(kubectl get service kibana -n ${NS} -o jsonpath='{.status.loadBalancer.ingress[0].hostname}')
# open in a browser:
echo "# Open in a browser: https://${KIBANA_URL}:5601"