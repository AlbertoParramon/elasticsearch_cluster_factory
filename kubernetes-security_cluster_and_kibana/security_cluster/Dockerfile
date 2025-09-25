# Dockerfile for Elasticsearch Cluster Factory
# Base image: Red Hat Universal Base Image 9
FROM redhat/ubi9:latest

# Environment variables
ENV ES_HOME=/home/es_user/elasticsearch 
ENV ES_DATA_PATH=${ES_HOME}/data 
ENV ES_LOGS_PATH=${ES_HOME}/logs 
ENV ES_CERTS_PATH=${ES_HOME}/config/certs 
ENV ES_VERSION=9.1.3
ENV ES_USER=es_user
ENV ES_GROUP=es_group

# Update system and install basic dependencies
RUN dnf update -y && \
    dnf install -y \
    procps-ng \
    vim \
    gettext \
    openssh-clients \
    unzip \
    hostname \
    iputils \
    && dnf clean all

# Create user and group for Elasticsearch (UID 1000)
RUN groupadd -g 1000 ${ES_GROUP} && \
    useradd -u 1000 -g ${ES_GROUP} -m -s /bin/bash ${ES_USER}

# Create directories
RUN mkdir -p ${ES_HOME} && \
    mkdir -p ${ES_HOME}/src

# Set working directory
WORKDIR ${ES_HOME}

# Download and install Elasticsearch (665MB - may take several minutes)
RUN curl -fsSL https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-${ES_VERSION}-linux-x86_64.tar.gz \
    -o elasticsearch.tar.gz  && \
    tar -xzf elasticsearch.tar.gz --strip-components=1 -C ${ES_HOME}/src && \
    rm elasticsearch.tar.gz

# Create data, logs and certs directories
RUN mkdir -p ${ES_DATA_PATH} && \
    mkdir -p ${ES_LOGS_PATH} && \
    mkdir -p ${ES_CERTS_PATH}

# Copy custom Elasticsearch configuration
COPY elasticsearch.yml.tpl ${ES_HOME}/config/elasticsearch.yml.tpl

# Copy startup script
COPY elasticsearch_start.sh ${ES_HOME}/elasticsearch_start.sh

# Set permissions
RUN chown -R ${ES_USER}:${ES_GROUP} ${ES_HOME} 

# Switch to Elasticsearch user
USER ${ES_USER}

# Expose Elasticsearch ports
EXPOSE 9200 9300

# Default command to start Elasticsearch
CMD ["/home/es_user/elasticsearch/elasticsearch_start.sh"]