FROM ubuntu:20.04

LABEL maintainer="crazyn"

WORKDIR /root
# change the image source to aliyun
ADD sources.list /etc/apt/sources.list


# install openssh-server, openjdk 
# the aliyun image source can't accept more than three
# applications installation requests from terminal computer or 
# give back an error without mercy. 
RUN apt-get update && \
    # apt-get install -y sudo apt-utils dialog && \
    apt-get install -y openssh-server && \
    apt-get install -y openjdk-11-jdk && \
    apt-get install -y maven && \
    apt-get install -y openjdk-8-jdk 
    # apt-get install -y mariadb-server mariadb-client

COPY config/* /tmp/
COPY spark-3.0.1-bin-without-hadoop.tgz /root/
# install hadoop 2.7.2
COPY *.tar.gz /root/
RUN tar -xzvf hadoop-3.3.0.tar.gz && \
    mv hadoop-3.3.0 /usr/local/hadoop && \
    rm hadoop-3.3.0.tar.gz && \
    tar -xzvf hbase-1.4.13-bin.tar.gz && \
    mv hbase-1.4.13 /usr/local/hbase && \
    rm hbase-1.4.13-bin.tar.gz && \
    tar -xzvf apache-zookeeper-3.5.8-bin.tar.gz && \
    mv apache-zookeeper-3.5.8-bin /usr/local/zookeeper && \
    rm apache-zookeeper-3.5.8-bin.tar.gz && \
    tar -xzvf apache-hive-3.1.2-bin.tar.gz && \
    mv apache-hive-3.1.2-bin /usr/local/hive && \
    rm apache-hive-3.1.2-bin.tar.gz &&\
    tar -xzvf spark-3.0.1-bin-without-hadoop.tgz && \
    mv spark-3.0.1-bin-without-hadoop /usr/local/spark && \
    rm spark-3.0.1-bin-without-hadoop.tgz
    # rm *.tar.gz
# set environment variable
ENV HADOOP_HOME=/usr/local/hadoop 
ENV HBASE_HOME=/usr/local/hbase
ENV HIVE_HOME=/usr/local/hive
# ENV GRADLE_HOME=/opt/gradle
ENV SPARK_HOME=/usr/local/spark
ENV PATH=$PATH:/usr/local/hadoop/bin:/usr/local/hadoop/sbin:${HIVE_HOME}/bin:${HBASE_HOME}/bin:${SPARK_HOME}/bin
# :${GRADLE_HOME}/bin
COPY run.sh /root/run.sh
# ssh without key
# sync the guava version between hadoop and hive or get an error 
RUN ssh-keygen -t rsa -f ~/.ssh/id_rsa -P '' && \
    cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys && \
    mkdir -p ~/hdfs/namenode && \ 
    mkdir -p ~/hdfs/datanode && \
    mkdir $HADOOP_HOME/logs && \
    mv /tmp/ssh_config ~/.ssh/config && \
    mv /tmp/mysqlcnf.sh /root/ && \
    chmod +x ~/mysqlcnf.sh && \
    mv /tmp/sql.txt /root/ &&\
    mv /tmp/hadoop-env.sh /usr/local/hadoop/etc/hadoop/hadoop-env.sh && \
    mv /tmp/hdfs-site.xml $HADOOP_HOME/etc/hadoop/hdfs-site.xml && \ 
    mv /tmp/core-site.xml $HADOOP_HOME/etc/hadoop/core-site.xml && \
    mv /tmp/mapred-site.xml $HADOOP_HOME/etc/hadoop/mapred-site.xml && \
    mv /tmp/yarn-site.xml $HADOOP_HOME/etc/hadoop/yarn-site.xml && \
    # mv /tmp/slaves $HADOOP_HOME/etc/hadoop/slaves && \
    mv /tmp/workers $HADOOP_HOME/etc/hadoop/workers && \
    mv /tmp/start-hadoop.sh ~/start-hadoop.sh && \
    mv /tmp/run-wordcount.sh ~/run-wordcount.sh && \
    mv /tmp/zoo.cfg /usr/local/zookeeper/conf/ && \
    mv /tmp/hbase-site.xml $HBASE_HOME/conf/ && \
    mv /tmp/regionservers $HBASE_HOME/conf/ && \
    mv /tmp/hbase-env.sh $HBASE_HOME/conf/ && \
    mv /tmp/Shanghai /etc/localtime &&\
    mv /tmp/slaves $SPARK_HOME/conf/ && \
    mv /tmp/spark-env.sh ${SPARK_HOME}/conf/ && \
    chmod +x ~/start-hadoop.sh && \
    chmod +x ~/run-wordcount.sh && \
    chmod +x $HADOOP_HOME/sbin/start-dfs.sh && \
    chmod +x $HADOOP_HOME/sbin/start-yarn.sh && \
    chmod +x ~/run.sh && \
    chmod 600 ~/.ssh/config && \
    /usr/local/hadoop/bin/hdfs namenode -format     

# format namenode
# RUN /usr/local/hadoop/bin/hdfs namenode -format
CMD ["/root/run.sh"]
#CMD [ "sh", "-c", "service ssh start; bash"]

