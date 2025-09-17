# Dockerfile para Elasticsearch Cluster Factory
# Imagen base: Red Hat Universal Base Image 9
FROM redhat/ubi9:latest

# Metadatos de la imagen
LABEL maintainer="alberto.parramon"
LABEL description="Elasticsearch Cluster Factory - Red Hat UBI 9"
LABEL version="1.0"

# Variables de entorno para Elasticsearch
ENV ES_VERSION=9.1.3
ENV ES_USER=es_user
ENV ES_GROUP=es_group
ENV ES_HOME=/home/${ES_USER}/elasticsearch
ENV ES_JAVA_OPTS="-Xms512m -Xmx1g"


# Actualizar el sistema e instalar dependencias básicas
RUN dnf update -y && \
    dnf install -y \
    procps-ng \
    vim \
    && dnf clean all

# Crear usuario y grupo para Elasticsearch (UID 1000)
RUN groupadd -g 1000 ${ES_GROUP} && \
    useradd -u 1000 -g ${ES_GROUP} -m -s /bin/bash ${ES_USER}

# Establecer directorio de trabajo
RUN mkdir -p ${ES_HOME}
RUN mkdir -p ${ES_HOME}/src
WORKDIR ${ES_HOME}

# Descargar e instalar Elasticsearch (665MB - puede tardar varios minutos)
RUN curl -fsSL https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-${ES_VERSION}-linux-x86_64.tar.gz \
    -o elasticsearch.tar.gz  && \
    tar -xzf elasticsearch.tar.gz --strip-components=1 -C ${ES_HOME}/src && \
    rm elasticsearch.tar.gz

# Copiar configuración personalizada de Elasticsearch
COPY elasticsearch.yml ${ES_HOME}/src/config/elasticsearch.yml

# Copiar script de inicio
COPY elasticsearch_start.sh ${ES_HOME}/elasticsearch_start.sh

# Configurar permisos
RUN chown -R ${ES_USER}:${ES_GROUP} ${ES_HOME} 


# Cambiar al usuario de Elasticsearch
USER ${ES_USER}

RUN mkdir -p ${ES_HOME}/data
RUN mkdir -p ${ES_HOME}/logs

# Exponer puertos de Elasticsearch
EXPOSE 9200 9300

# Comando por defecto para iniciar Elasticsearch
CMD ["/home/es_user/elasticsearch/elasticsearch_start.sh"]
#CMD ["/bin/bash"]