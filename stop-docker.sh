#!/bin/bash
echo "stopping hadoop cluster..."
names=$(docker ps | grep 'hadoop-spark-hbase:latest' | gawk '{print $1}')
echo $name
if [ -z "$names" ]
then 
    echo "There is no running containers."
else
    docker stop $names
fi
echo ""
