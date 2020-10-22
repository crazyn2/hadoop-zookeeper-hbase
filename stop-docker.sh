#!/bin/bash
echo "stopping hadoop cluster..."
docker stop $(docker ps | grep 'hadoop-hbase:2.0' | gawk '{print $1}')
echo ""