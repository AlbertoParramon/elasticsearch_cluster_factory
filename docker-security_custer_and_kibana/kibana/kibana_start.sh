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

    IFS=',' read -r -a CONTAINERS <<< "$ES_ALL_NODES_CONTAINERS_NAMES"
    HOSTS=()
    for NODE in "${CONTAINERS[@]}"; do
      HOSTS+=("\"https://${NODE}:9200\"")
    done
    ES_ELASTICSEARCH_HOSTS="[${HOSTS[*]}]"
    ES_ELASTICSEARCH_HOSTS="${ES_ELASTICSEARCH_HOSTS// /, }"
    export ES_ELASTICSEARCH_HOSTS
    echo "ES_ELASTICSEARCH_HOSTS: ${ES_ELASTICSEARCH_HOSTS}"

    envsubst < ${KIBANA_HOME}/config/kibana.yml.tpl > ${KIBANA_HOME}/config/kibana.yml

    echo "Configuring kibana_keystore with elasticsearch.password:"
    KBN_PATH_CONF="${KIBANA_HOME}/config" ${KIBANA_HOME}/src/bin/kibana-keystore create
    
    # Add password to keystore using --stdin to avoid TTY issues
    echo "${ES_PASS}" | KBN_PATH_CONF="${KIBANA_HOME}/config" ${KIBANA_HOME}/src/bin/kibana-keystore add elasticsearch.password --stdin
}

wait_for_node_certs
generate_config

sleep 60

echo "Starting Kibana:"
KBN_PATH_CONF="${KIBANA_HOME}/config" ${KIBANA_HOME}/src/bin/kibana -c ${KIBANA_HOME}/config/kibana.yml  &


sleep infinity

