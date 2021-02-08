FROM openjdk:11

LABEL maintainer="github.com/lucas-fs"

ENV DEBIAN_FRONTEND noninteractive
ENV YCSB_VERSION 0.18.0
ENV YCSB_HOME /opt/ycsb
ENV JDBC_HOME /opt/ycsb/jdbc-binding

RUN curl --progress-bar -Lo /tmp/ycsb-${YCSB_VERSION}.tar.gz https://github.com/lucas-fs/YCSB/releases/download/${YCSB_VERSION}/ycsb-${YCSB_VERSION}.tar.gz \
    && cd /opt \
    && tar -xvf /tmp/ycsb-${YCSB_VERSION}.tar.gz \
    && mv ycsb-${YCSB_VERSION}-SNAPSHOT /opt/ycsb \
    && curl --progress-bar -Lo ${YCSB_HOME}/slf4j-api-1.7.30.jar https://repo1.maven.org/maven2/org/slf4j/slf4j-api/1.7.30/slf4j-api-1.7.30.jar \
    && curl --progress-bar -Lo ${YCSB_HOME}/slf4j-simple-1.7.30.jar https://repo1.maven.org/maven2/org/slf4j/slf4j-simple/1.7.30/slf4j-simple-1.7.30.jar \
	&& curl --progress-bar -Lo ${JDBC_HOME}/lib/postgresql-42.2.14.jar https://jdbc.postgresql.org/download/postgresql-42.2.14.jar \
    && rm -rf /tmp/ycsb-${YCSB_VERSION}.tar.gz 

RUN set -eux; \
	apt-get update; \
	apt-get install -y --no-install-recommends \
	nano \
	wget \
	ssh \	
	git \
	postgresql-client-11 \
	python2.7 \
	python-setuptools \
	python-pip \
	; \
	rm -rf /var/lib/apt/lists/*

RUN pip install cqlsh

RUN echo 'alias ycsb="$YCSB_HOME/bin/ycsb"' >> /root/.bashrc
ENV CLASSPATH=$YCSB_HOME/slf4j-api-1.7.30.jar:$YCSB_HOME/slf4j-simple-1.7.30.jar:$JDBC_HOME/lib/postgresql-42.2.14.jar

RUN mkdir /ycsb_output \
	&& chmod 777 /ycsb_output

VOLUME /ycsb_outputs
VOLUME /scripts

# COPY cassandra_run.sh /
# COPY cassandra_load.sh /
# COPY postgres_run.sh /
# COPY postgres_load.sh /

# RUN chmod +x /cassandra_run.sh
# RUN chmod +x /cassandra_load.sh
# RUN chmod +x /postgres_run.sh
# RUN chmod +x /postgres_load.sh
