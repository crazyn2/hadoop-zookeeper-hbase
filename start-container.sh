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
				-e HIVE_HOME=/usr/local/hive \
                ctazyn/hadoop-hbase:2.2 \
				&> /dev/null

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
	                ctazyn/hadoop-hbase:2.2 &> /dev/null
	i=$(( $i + 1 ))
done 

# get into hadoop master container
sudo docker exec -it hadoop-master /bin/bash -c "/root/mysqlcnf.sh"
docker exec -it hadoop-master /bin/bash
# docker exec -it hadoop-master /bin/bash -c 'apt-get install -y mariadb-server mariadb-client && \
# 				echo 'PATH=$PATH:$HIVE_HOME/bin' >> /root/.bashrc && \
# 				source /root/.bashrc'
# docker cp apache-hive-3.1.2-bin.tar.gz hadoop-master:/root/
# docker exec -it hadoop-master /bin/bash 'tar -xzvf apache-hive-3.1.2-bin.tar.gz && \
#     mv apache-hive-3.1.2-bin /usr/local/hive && \
#     rm apache-hive-3.1.2-bin.tar.gz && 
# 	mv /tmp/hive-env.sh hive-site.xml hive-exec-log4j2.properties hive-log4j2.properties \
#     ${HIVE_HOME}/conf/ '