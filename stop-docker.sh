#!/bin/bash -x
echo "stopping hadoop cluster..."
names=$(docker ps | grep 'hadoop-hbase:2.0' | gawk '{print $1}')

if [ -z $names ]
then 
    echo "There is no running containers."
else
    docker stop $names
fi
echo ""