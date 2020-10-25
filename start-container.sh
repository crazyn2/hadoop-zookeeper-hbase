#!/bin/bash

# the default node number is 3
N=${1:-3}


# start hadoop master container
sudo docker rm -f hadoop-master &> /dev/null
echo "start hadoop-master container..."
sudo docker run -itd \
                --net=hadoop \
                -p 9870:9870 \
                -p 8088:8088 \
				-p 16010:16010 \
				-p 19888:19888 \
                --name hadoop-master \
                --hostname hadoop-master \
				-e MYID=1 \
                ctazyn/hadoop-hbase:2.1 &> /dev/null


# start hadoop slave container
i=1
while [ $i -lt $N ]
do
	sudo docker rm -f hadoop-slave$i &> /dev/null
	echo "start hadoop-slave$i container..."
	myid=`expr $i + 1`
	sudo docker run -itd \
	                --net=hadoop \
	                --name hadoop-slave$i \
	                --hostname hadoop-slave$i \
					-e MYID=$myid \
	                ctazyn/hadoop-hbase:2.1 &> /dev/null
	i=$(( $i + 1 ))
done 

# get into hadoop master container
sudo docker exec -it hadoop-master /bin/bash -c "start-all.sh"
docker exec -it hadoop-master /bin/bash
