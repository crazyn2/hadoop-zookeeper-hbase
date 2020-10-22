#!/bin/bash
echo "starting hadoop cluster..."
docker start $(docker ps -a | grep 'hadoop-hbase:2.0' | gawk '{print $1}')
docker exec -it hadoop-master /bin/bash