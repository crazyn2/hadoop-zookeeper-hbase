#!/bin/bash

# the default node number is 3
N=${1:-3}
echo -e "It will delete containers named hadoop-spark-master,hadoop-spark-slave1,hadoop-spark-slave2\n\
If you still have vital data in them, please backup them first which is hard to be recovered by \
excellent disk recovery tools."
# read -r -p	"Are you sure to delete those containers?[Y/n]" choice
# case $choice in
# 	[Yy])
# 		echo "executing...";;
# 	[Nn])
# 		echo "aborted."
# 		exit 0;;
# 	*)
# 		echo -e "invalid input...\nexiting"
# 		exit 1;;
# esac

# start hadoop master container
sudo docker rm -f hadoop-spark-master &> /dev/null
echo "start hadoop-spark-master container..."
sudo docker run -itd \
                --net=hadoop \
                -p 9870:9870/tcp \
                -p 8088:8088/tcp \
				-p 16010:16010/tcp \
				-p 19888:19888/tcp \
				-p 19888:19888/udp \
                --name hadoop-spark-master \
                --hostname hadoop-spark-master \
				-e MYID=1 \
				-e HIVE_HOME=/usr/local/hive \
				-e TERM=xterm-256color \
				-v $PWD/docker-workspace:/root/workspace \
                ctazyn/hadoop-spark-hbase:latest \
				&> /dev/null

# start hadoop slave container
i=1
while [ $i -lt $N ]
do
	sudo docker rm -f hadoop-spark-slave$i &> /dev/null
	echo "start hadoop-spark-slave$i container..."
	myid=`expr $i + 1`
	sudo docker run -itd \
	                --net=hadoop \
	                --name hadoop-spark-slave$i \
	                --hostname hadoop-spark-slave$i \
					-e MYID=$myid \
	                ctazyn/hadoop-spark-hbase:latest &> /dev/null
	i=$(( $i + 1 ))
done 

# get into hadoop master container
./mysqlm-spark.sh
sudo docker exec -it hadoop-spark-master /bin/bash -c "service mysql start && /root/mysqlcnf.sh"
docker exec -it hadoop-spark-master /bin/bash

# docker cp apache-hive-3.1.2-bin.tar.gz hadoop-master:/root/
# docker exec -it hadoop-master /bin/bash 'tar -xzvf apache-hive-3.1.2-bin.tar.gz && \
#     mv apache-hive-3.1.2-bin /usr/local/hive && \
#     rm apache-hive-3.1.2-bin.tar.gz && 
# 	mv /tmp/hive-env.sh hive-site.xml hive-exec-log4j2.properties hive-log4j2.properties \
#     ${HIVE_HOME}/conf/ '