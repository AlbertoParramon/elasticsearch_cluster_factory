# Basic Elasticsearch configuration for multi-node cluster
cluster.name: ${ES_CLUSTER_NAME}
node.name: ${ES_NODE_NAME}

network.host: 0.0.0.0
http.port: ${ES_HTTP_PORT}
transport.port: 9300

path.data: /home/es_user/elasticsearch/data
path.logs: /home/es_user/elasticsearch/logs

node.roles: ${ES_NODE_ROLES}

discovery.seed_hosts: ${ES_DISCOVERY_SEED_HOSTS}
cluster.initial_master_nodes: ${ES_CLUSTER_INITIAL_MASTER_NODES}

###### Development configuration ######

# Security configuration (disabled for development)
xpack.security.enabled: false
xpack.security.enrollment.enabled: false

# Disable X-Pack ML for development
xpack.ml.enabled: false

# Disable memory locking to avoid memory issues and ulimit memory configuration
bootstrap.memory_lock: false

action.auto_create_index: true
logger.level: INFO