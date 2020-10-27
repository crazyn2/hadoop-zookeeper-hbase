#!/bin/bash
echo "stopping hadoop cluster..."
names=$(docker ps | grep 'hadoop-hbase:2.2' | gawk '{print $1}')
echo $name
if [ -z "$names" ]
then 
    echo "There is no running containers."
else
    docker stop $names
fi
echo ""
