#!/bin/bash
echo "starting hadoop cluster..."
names=$(docker ps -a | grep 'ctazyn/hadoop-hbase:2.3' | gawk '{print $1}')
if [ ! -n "$names" ]
then
    echo "There is no container based on ctazyn/hadoop-hbase:2.3 images."
else
    docker start $names
    docker exec -it hadoop-master /bin/bash -c "start-all.sh && service mysql start"
    docker exec -it hadoop-master /bin/bash
fi
