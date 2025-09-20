# Kibana configuration
server.host: 0.0.0.0
server.port: 5601

server.ssl.enabled: true
server.ssl.certificate: ${KIBANA_CERTS_PATH}/kibana/kibana.cer
server.ssl.key: ${KIBANA_CERTS_PATH}/kibana/kibana.key


# Elasticsearch configuration
elasticsearch.ssl.certificateAuthorities: ${KIBANA_CERTS_PATH}/kibana/kibana-ca.cer
elasticsearch.ssl.verificationMode: certificate
elasticsearch.username: kibana_system
elasticsearch.hosts: ${ES_ELASTICSEARCH_HOSTS}

xpack.reporting.roles.enabled: false
xpack.encryptedSavedObjects.encryptionKey: KibanaSavedObjectsEncryptionKey${ES_PASS}
xpack.security.encryptionKey: KibanaSecurityEncryptionKey${ES_PASS}
xpack.reporting.encryptionKey: KibanaReportingEncryptionKey${ES_PASS}


logging.appenders.file.type: file
logging.appenders.file.fileName: ${KIBANA_LOGS_PATH}/kibana.log
logging.appenders.file.layout.type: pattern
logging.root.appenders: [file]
