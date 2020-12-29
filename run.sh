#!/bin/sh
mkdir -p /usr/local/zookeeper/data/ /usr/local/zookeeper/logs
echo ${MYID} > /usr/local/zookeeper/data/myid
bash /usr/local/zookeeper/bin/zkServer.sh start
service ssh start
start-all.sh
$SPARK_HOME/sbin/start-all.sh
tail -f /dev/null
# tail -f /var/log/dmesg
