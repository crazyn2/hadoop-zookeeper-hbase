#!/bin/bash
# run in hadoop-master node to configure mariadb environment

# docker exec -it hadoop-master /bin/bash -c \
#     'apt-get install -y mariadb-server mariadb-client && service mysql start && \
#     wget https://mirrors.aliyun.com/apache/hive/hive-3.1.2/apache-hive-3.1.2-bin.tar.gz && \
#     mv apache-hive-3.1.2-bin /usr/local/hive && \
#     rm apache-hive-3.1.2-bin.tar.gz && \
#     wget https://downloads.mariadb.com/Connectors/java/connector-java-2.7.0/mariadb-java-client-2.7.0.jar &&\
#     mv mariadb-java-client-2.7.0.jar /usr/local/hive/lib/ && \
#     rm ${HIVE_HOME}/lib/guava-19.0.jar && \
#     cp ${HADOOP_HOME}/share/hadoop/common/lib/guava-27.0-jre.jar ${HIVE_HOME}/lib/ && \
#     mv /tmp/hive-env.sh /tmp/hive-site.xml \
#     /tmp/hive-exec-log4j2.properties /tmp/hive-log4j2.properties \
#     ${HIVE_HOME}/conf/'
docker cp apache-hive-3.1.2-bin hadoop-master:/usr/local/hive
docker cp mariadb-java-client-2.7.0.jar hadoop-master:/usr/local/hive/lib/
docker exec -it hadoop-master /bin/bash -c \
    'apt-get update && apt-get install -y mariadb-server mariadb-client && service mysql start && \
    rm ${HIVE_HOME}/lib/guava-19.0.jar && \
    cp ${HADOOP_HOME}/share/hadoop/common/lib/guava-27.0-jre.jar ${HIVE_HOME}/lib/ && \
    mv /tmp/hive-env.sh /tmp/hive-site.xml \
    /tmp/hive-exec-log4j2.properties /tmp/hive-log4j2.properties \
    ${HIVE_HOME}/conf/'