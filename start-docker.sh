#!/bin/bash
echo "starting hadoop cluster..."
names=$(docker ps -a | grep 'hadoop-hbase:latest' | gawk '{print $1}')
if [ ! -n "$names" ]
then
    echo "There is no container based on hadoop-hbase:latest images."
else
    docker start $names
    docker exec -it hadoop-master /bin/bash -c "service mysql start"
    docker exec -it hadoop-master /bin/bash
fi
