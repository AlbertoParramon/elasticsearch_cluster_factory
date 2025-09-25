#!/bin/bash

ES_PASS=example1234

echo "# You need to open the port and then you can open a browser and go to http://localhost:5601"
echo "kubectl port-forward -n es-secure svc/kibana 5601:5601"

echo "# You need to open the port and then you can make a request to the cluster with the following command:"
kubectl port-forward -n es-secure svc/elasticsearch-http 9200:9200 &
sleep 3
curl -k https://elastic:${ES_PASS}@localhost:9200/
kill %1

