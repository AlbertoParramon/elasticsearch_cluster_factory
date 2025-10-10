# Dockerfile for Kibana
FROM redhat/ubi9:latest

# Metadata
LABEL maintainer="alberto.parramon"
LABEL description="Kibana for Elasticsearch Cluster"
LABEL version="1.0"

# Environment variables
ENV KIBANA_VERSION=9.1.3
ENV KIBANA_USER=es_user
ENV KIBANA_GROUP=es_group
ENV KIBANA_CERTS_PATH=/home/es_user/elasticsearch/config/certs
ENV KIBANA_LOGS_PATH=/home/es_user/kibana/logs 
ENV KIBANA_HOME=/home/${KIBANA_USER}/kibana



# Update system and install dependencies
RUN dnf update -y && \
    dnf install -y \
    procps-ng \
    vim \
    gettext \
    openssh-clients \
    unzip \
    hostname \
    iputils \
    wget \
    && dnf clean all

# Create user and group for Kibana (UID 1000)
RUN groupadd -g 1000 ${KIBANA_GROUP} && \
    useradd -u 1000 -g ${KIBANA_GROUP} -m -s /bin/bash ${KIBANA_USER}

# Create directories
RUN mkdir -p ${KIBANA_HOME} && \
    mkdir -p ${KIBANA_HOME}/src && \
    mkdir -p ${KIBANA_LOGS_PATH}


# Set working directory
WORKDIR ${KIBANA_HOME}

# Copy Kibana configuration
COPY kibana.yml.tpl ${KIBANA_HOME}/config/kibana.yml.tpl

# Copy startup script
COPY kibana_start.sh ${KIBANA_HOME}/kibana_start.sh

# Set permissions
RUN chown -R ${KIBANA_USER}:${KIBANA_GROUP} ${KIBANA_HOME} 
RUN chown -R ${KIBANA_USER}:${KIBANA_GROUP} ${KIBANA_LOGS_PATH}

# Switch to Kibana user
USER ${KIBANA_USER}

# Download and install Kibana with retries and timeout
RUN for i in {1..3}; do \
        curl -fsSL --connect-timeout 30 --max-time 300 \
        https://artifacts.elastic.co/downloads/kibana/kibana-${KIBANA_VERSION}-linux-x86_64.tar.gz \
        -o kibana.tar.gz && break || \
        (echo "curl failed, trying wget..." && \
         wget --timeout=30 --tries=3 \
         https://artifacts.elastic.co/downloads/kibana/kibana-${KIBANA_VERSION}-linux-x86_64.tar.gz \
         -O kibana.tar.gz && break) || sleep 10; \
    done

# Verify download and extract
RUN ls -la kibana.tar.gz && \
    tar -xzf kibana.tar.gz --strip-components=1 -C ${KIBANA_HOME}/src && \
    rm kibana.tar.gz
    

# Expose Kibana port
EXPOSE 5601

# Default command to start Kibana
CMD ["/home/es_user/kibana/kibana_start.sh"]
