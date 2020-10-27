#!/bin/bash
echo "starting hadoop cluster..."
names=$(docker ps -a | grep 'hadoop-hbase:2.2' | gawk '{print $1}')
if [ ! -n "$names" ]
then
    echo "There is no container based on hadoop-hbase:2.2 images."
else
    docker start $names
    # docker exec -it hadoop-master /bin/bash -c "start-all.sh"
    docker exec -it hadoop-master /bin/bash
fi
