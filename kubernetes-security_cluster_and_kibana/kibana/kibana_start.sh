#!/bin/bash
wait_for_node_certs() {       
    while true; do
        echo "Waiting for certificates for node: $ES_NODE_NAME..."
        if [ -f "$KIBANA_CERTS_PATH/kibana/kibana.p12" ]; then
            echo "Certificates for kibana are ready"
            return 0
        fi
        sleep 5
    done
}
generate_config() {
    echo "Generating kibana configuration..."

    ES_ELASTICSEARCH_HOSTS="[ \"https://${ES_HTTP_SERVICE}:${ES_HTTP_PORT}\" ]"
    export ES_ELASTICSEARCH_HOSTS
    echo "ES_ELASTICSEARCH_HOSTS: ${ES_ELASTICSEARCH_HOSTS}"

    envsubst < ${KIBANA_HOME}/config/kibana.yml.tpl > ${KIBANA_HOME}/config/kibana.yml

    echo "Configuring kibana_keystore with elasticsearch.password:"
    KBN_PATH_CONF="${KIBANA_HOME}/config" ${KIBANA_HOME}/src/bin/kibana-keystore create
    
    # Add password to keystore using --stdin to avoid TTY issues
    echo "${ES_PASS}" | KBN_PATH_CONF="${KIBANA_HOME}/config" ${KIBANA_HOME}/src/bin/kibana-keystore add elasticsearch.password --stdin
}

wait_for_cluster_ready() {
    echo "Waiting for elasticsearch to be ready... "
    CLUSTER_READY=0
    while [[ $CLUSTER_READY == 0 ]]; do
      aux=$(curl -k -X GET "https://elastic:${ES_PASS}@${ES_HTTP_SERVICE}:${ES_HTTP_PORT}/_cluster/health?pretty")
      aux2=$(echo $aux | grep green | wc -l)
      if [[ "$aux2" == "1" ]]; then
        CLUSTER_READY=1
        echo $aux
      else
        echo $aux
        echo "Continue waiting for cluster to be ready, retrying in 5 seconds"
        sleep 5
      fi
    done
}

wait_for_node_certs
generate_config
wait_for_cluster_ready

echo "Starting Kibana:"
KBN_PATH_CONF="${KIBANA_HOME}/config" ${KIBANA_HOME}/src/bin/kibana -c ${KIBANA_HOME}/config/kibana.yml  &


sleep infinity

