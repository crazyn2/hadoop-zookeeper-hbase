FROM ubuntu:18.04

LABEL maintainer="crazyn"

WORKDIR /root
ADD sources.list /etc/apt/sources.list


# install openssh-server, openjdk and wget
RUN apt-get update && \
    apt-get install -y sudo apt-utils dialog && \
    apt-get install -y openssh-server && \
    apt-get install -y openjdk-8-jdk
# COPY *.tar.gz /root/
COPY config/* /tmp/

# install hadoop 2.7.2
# RUN tar -xzvf hadoop-3.2.1.tar.gz && \
#     mv hadoop-3.2.1 /usr/local/hadoop && \
#     rm hadoop-3.2.1.tar.gz && \
#     tar -xzvf hbase-1.4.13-bin.tar.gz && \
#     mv hbase-1.4.13 /usr/local/hbase && \
#     rm hbase-1.4.13-bin.tar.gz && \
#     tar -xzvf apache-zookeeper-3.5.8-bin.tar.gz && \
#     mv apache-zookeeper-3.5.8-bin /usr/local/zookeeper && \
#     rm apache-zookeeper-3.5.8-bin.tar.gz && \
#     rm *.tar.gz

RUN wget https://mirrors.aliyun.com/apache/hadoop/common/stable/hadoop-3.2.1.tar.gz && \
    tar -xzvf hadoop-3.2.1.tar.gz && \
    mv hadoop-3.2.1 /usr/local/hadoop && \
    rm hadoop-3.2.1.tar.gz && \
    wget https://mirrors.aliyun.com/apache/hbase/1.4.13/hbase-1.4.13-bin.tar.gz && \
    tar -xzvf hbase-1.4.13-bin.tar.gz && \
    mv hbase-1.4.13 /usr/local/hbase && \
    rm hbase-1.4.13-bin.tar.gz && \
    wget https://mirrors.aliyun.com/apache/zookeeper/stable/apache-zookeeper-3.5.8.tar.gz && \
    tar -xzvf apache-zookeeper-3.5.8.tar.gz && \
    mv apache-zookeeper-3.5.8 /usr/local/zookeeper && \
    rm apache-zookeeper-3.5.8.tar.gz

# set environment variable
ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64 
ENV HADOOP_HOME=/usr/local/hadoop 
ENV HBASE_HOME=/usr/local/hbase
ENV PATH=$PATH:/usr/local/hadoop/bin:/usr/local/hadoop/sbin 
COPY run.sh /root/run.sh
# ssh without key
RUN ssh-keygen -t rsa -f ~/.ssh/id_rsa -P '' && \
    cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys && \
    mkdir -p ~/hdfs/namenode && \ 
    mkdir -p ~/hdfs/datanode && \
    mkdir $HADOOP_HOME/logs && \
    mv /tmp/ssh_config ~/.ssh/config && \
    mv /tmp/hadoop-env.sh /usr/local/hadoop/etc/hadoop/hadoop-env.sh && \
    mv /tmp/hdfs-site.xml $HADOOP_HOME/etc/hadoop/hdfs-site.xml && \ 
    mv /tmp/core-site.xml $HADOOP_HOME/etc/hadoop/core-site.xml && \
    mv /tmp/mapred-site.xml $HADOOP_HOME/etc/hadoop/mapred-site.xml && \
    mv /tmp/yarn-site.xml $HADOOP_HOME/etc/hadoop/yarn-site.xml && \
    mv /tmp/slaves $HADOOP_HOME/etc/hadoop/slaves && \
    mv /tmp/start-hadoop.sh ~/start-hadoop.sh && \
    mv /tmp/run-wordcount.sh ~/run-wordcount.sh && \
    mv /tmp/zoo.cfg /usr/local/zookeeper/conf/ && \
    mv /tmp/hbase-site.xml $HBASE_HOME/conf/ && \
    mv /tmp/regionservers $HBASE_HOME/conf/ && \
    mv /tmp/hbase-env.sh $HBASE_HOME/conf/ && \
    chmod +x ~/start-hadoop.sh && \
    chmod +x ~/run-wordcount.sh && \
    chmod +x $HADOOP_HOME/sbin/start-dfs.sh && \
    chmod +x $HADOOP_HOME/sbin/start-yarn.sh && \
    chmod +x ~/run.sh && \
    /usr/local/hadoop/bin/hdfs namenode -format     

# format namenode
# RUN /usr/local/hadoop/bin/hdfs namenode -format
CMD ["/root/run.sh"]
#CMD [ "sh", "-c", "service ssh start; bash"]

