FROM openjdk:11

MAINTAINER Lucas Ferreira da Silva

ENV DEBIAN_FRONTEND noninteractive
ENV YCSB_VERSION 0.17.0
ENV YCSB_HOME /opt/ycsb

RUN curl --progress-bar -Lo /tmp/ycsb-${YCSB_VERSION}.tar.gz https://github.com/brianfrankcooper/YCSB/releases/download/${YCSB_VERSION}/ycsb-${YCSB_VERSION}.tar.gz \
    && cd /opt \
    && tar -xvf /tmp/ycsb-${YCSB_VERSION}.tar.gz \
    && mv ycsb-${YCSB_VERSION} /opt/ycsb \
    && curl --progress-bar -Lo /opt/ycsb/slf4j-api-1.7.30.jar https://repo1.maven.org/maven2/org/slf4j/slf4j-api/1.7.30/slf4j-api-1.7.30.jar \
    && curl --progress-bar -Lo /opt/ycsb/slf4j-simple-1.7.30.jar https://repo1.maven.org/maven2/org/slf4j/slf4j-simple/1.7.30/slf4j-simple-1.7.30.jar \
    && rm -rf /tmp/ycsb-${YCSB_VERSION}.tar.gz \
    && ln -s /opt/ycsb/bin/ycsb /usr/local/bin/ycsb 

