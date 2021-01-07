#!/bin/bash

echo ""

echo -e "\nbuild docker hadoop image\n"
sudo docker build -t ctazyn/hadoop-hbase:latest .

echo ""
