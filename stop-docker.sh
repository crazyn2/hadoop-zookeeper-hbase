#!/bin/bash
echo "stopping hadoop cluster..."
docker stop $(docker ps | grep 'hadoop-hbase:1.0' | gawk '{print $1}')
echo ""