#!/bin/bash
echo "stopping hadoop cluster..."
names=$(docker ps | grep 'ctazyn/hadoop-hbase:latest' | gawk '{print $1}')
echo $name
if [ -z "$names" ]
then 
    echo "There is no running containers based on ctazyn/hadoop-hbase:latest"
else
    docker stop $names
fi
echo ""
