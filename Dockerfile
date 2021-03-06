FROM openjdk:8
LABEL mantainer "https://github.com/cloudopsengineer"
LABEL author "Giuseppe Iannelli"
LABEL description "Docker image for CMAK (Cluster Manager for Apache Kafka, previously known as Kafka Manager. Developed by yahoo https://github.com/yahoo/CMAK)"

ARG KM_VERSION=2.0.0.2
ENV KAFKA_MANAGER_AUTH_ENABLED "true"
ENV KAFKA_MANAGER_USERNAME admin
ENV KAFKA_MANAGER_PASSWORD p4ssw0rd
ENV ZK_HOSTS zookeeper:2181
ENV KAFKA_NUMBER_OF_BROKERS 3
ENV KAFKA_TOTAL_PARTITIONS_NUMBER 100

WORKDIR /tmp


RUN curl https://codeload.github.com/yahoo/CMAK/tar.gz/${KM_VERSION} -o CMAK-${KM_VERSION}.tar.gz

RUN tar xzf CMAK-${KM_VERSION}.tar.gz

WORKDIR /tmp/CMAK-${KM_VERSION}

RUN ./sbt clean dist

RUN unzip -d /opt ./target/universal/kafka-manager-${KM_VERSION}.zip \
    && mv /opt/kafka-manager-${KM_VERSION} /opt/CMAK \
    && chown -R 1000:100 /opt/CMAK \
    && chmod -R 775 /opt/CMAK 

RUN rm -rf /tmp/CMAK-${KM_VERSION}.tar.gz /tmp/CMAK-${KM_VERSION}  $HOME/.sbt $HOME/.ivy2 

COPY container-entrypoint.sh /usr/local/bin/container-entrypoint.sh

EXPOSE 8080

WORKDIR /opt/CMAK
USER 1000

ENTRYPOINT ["/bin/sh", "/usr/local/bin/container-entrypoint.sh"]
CMD ["-Dhttp.port=8080"]

