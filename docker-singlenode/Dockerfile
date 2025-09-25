# Dockerfile for Elasticsearch Single Node
FROM redhat/ubi9:latest

# Environment variables for Elasticsearch
ENV ES_VERSION=9.1.3
ENV ES_USER=es_user
ENV ES_GROUP=es_group
ENV ES_HOME=/home/${ES_USER}/elasticsearch
ENV ES_JAVA_OPTS="-Xms512m -Xmx1g"

# Update system and install basic dependencies
RUN dnf update -y && \
    dnf install -y \
    procps-ng \
    vim \
    && dnf clean all

# Create user and group for Elasticsearch (UID 1000)
RUN groupadd -g 1000 ${ES_GROUP} && \
    useradd -u 1000 -g ${ES_GROUP} -m -s /bin/bash ${ES_USER}

# Set working directory
RUN mkdir -p ${ES_HOME}
RUN mkdir -p ${ES_HOME}/src
RUN mkdir -p ${ES_HOME}/data
RUN mkdir -p ${ES_HOME}/logs
WORKDIR ${ES_HOME}

# Download and install Elasticsearch (665MB - may take several minutes)
RUN curl -fsSL https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-${ES_VERSION}-linux-x86_64.tar.gz \
    -o elasticsearch.tar.gz  && \
    tar -xzf elasticsearch.tar.gz --strip-components=1 -C ${ES_HOME}/src && \
    rm elasticsearch.tar.gz

# Copy custom Elasticsearch configuration
COPY elasticsearch.yml ${ES_HOME}/src/config/elasticsearch.yml

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