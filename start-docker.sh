#!/bin/bash
echo "starting hadoop cluster..."
names=$(docker ps -a | grep 'hadoop-hbase:2.0' | gawk '{print $1}')
if [ ! -n "$names" ]
then
    echo "There is no container based on hadoop-hbase:2.0 images."
else
    docker start $names
    docker exec -it hadoop-master /bin/bash -c "./start-hadoop.sh"
    docker exec -it hadoop-master /bin/bash
fi
