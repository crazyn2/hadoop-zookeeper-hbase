#!/bin/bash
echo "starting hadoop cluster..."
names=$(docker ps -a | grep 'hadoop-spark-hbase:latest' | gawk '{print $1}')
if [ ! -n "$names" ]
then
    echo "There is no container based on hadoop-spark-hbase:latest images."
else
    docker start $names
    # docker exec -it hadoop-spark-master /bin/bash -c "service mysql start"
    docker exec -it hadoop-spark-master /bin/bash
fi
