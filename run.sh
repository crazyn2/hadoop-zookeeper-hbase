#!/bin/sh
mkdir -p /usr/local/zookeeper/data/ /usr/local/zookeeper/logs
echo ${MYID} > /usr/local/zookeeper/data/myid
bash /usr/local/zookeeper/bin/zkServer.sh start
service ssh start
tail -f /dev/null
# tail -f /var/log/dmesg
