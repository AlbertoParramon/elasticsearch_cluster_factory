# Basic Elasticsearch configuration for multi-node cluster
cluster.name: ${ES_CLUSTER_NAME}
node.name: ${ES_NODE_NAME}

network.host: 0.0.0.0
http.port: ${ES_HTTP_PORT}
transport.port: 9300

path.data: ${ES_DATA_PATH}
path.logs: ${ES_LOGS_PATH}

node.roles: ${ES_NODE_ROLES}

discovery.seed_hosts: ${ES_DISCOVERY_SEED_HOSTS}
cluster.initial_master_nodes: ${ES_CLUSTER_INITIAL_MASTER_NODES}

###### Security Configuration ######

# Enable X-Pack Security
xpack.security.enabled: true
xpack.security.enrollment.enabled: true

# SSL/TLS Configuration
xpack.security.transport.ssl.enabled: true
xpack.security.transport.ssl.verification_mode: certificate
xpack.security.transport.ssl.keystore.path: ${ES_CERTS_PATH}/${ES_NODE_NAME}/${ES_NODE_NAME}.p12
xpack.security.transport.ssl.truststore.path: ${ES_CERTS_PATH}/${ES_NODE_NAME}/${ES_NODE_NAME}.p12

# HTTP SSL Configuration
xpack.security.http.ssl.enabled: true
xpack.security.http.ssl.keystore.path: ${ES_CERTS_PATH}/${ES_NODE_NAME}/${ES_NODE_NAME}.p12
xpack.security.http.ssl.truststore.path: ${ES_CERTS_PATH}/${ES_NODE_NAME}/${ES_NODE_NAME}.p12

#Monitoring
xpack.monitoring.collection.enabled: true #only for users with monitoring_user role
xpack.monitoring.elasticsearch.collection.enabled: true
xpack.monitoring.exporters.local.type: local
xpack.monitoring.exporters.local.use_ingest: false

# Disable X-Pack ML for development
xpack.ml.enabled: false

# Disable memory locking to avoid memory issues
bootstrap.memory_lock: false

# Development settings
action.auto_create_index: true
logger.level: INFO

