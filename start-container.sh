#!/bin/bash

# the default node number is 3
N=${1:-3}
echo -e "It will delete containers named hadoop-master,hadoop-slave1,hadoop-slave2\n\
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
sudo docker rm -f hadoop-master &> /dev/null
echo "start hadoop-master container..."
sudo docker run -itd \
                --net=hadoop \
                -p 9870:9870/tcp \
                -p 8088:8088/tcp \
				-p 16010:16010/tcp \
				-p 19888:19888/tcp \
                --name hadoop-master \
                --hostname hadoop-master \
				-e MYID=1 \
				-e HIVE_HOME=/usr/local/hive \
				-e TERM=xterm-256color \
				-v $PWD/docker-workspace:/root/workspace \
                ctazyn/hadoop-hbase:latest \
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
	                ctazyn/hadoop-hbase:latest&> /dev/null
	i=$(( $i + 1 ))
done 

# get into hadoop master container
./mysqlm.sh
sudo docker exec -it hadoop-master /bin/bash -c "/root/mysqlcnf.sh"
docker exec -it hadoop-master /bin/bash

# docker cp apache-hive-3.1.2-bin.tar.gz hadoop-master:/root/
# docker exec -it hadoop-master /bin/bash 'tar -xzvf apache-hive-3.1.2-bin.tar.gz && \
#     mv apache-hive-3.1.2-bin /usr/local/hive && \
#     rm apache-hive-3.1.2-bin.tar.gz && 
# 	mv /tmp/hive-env.sh hive-site.xml hive-exec-log4j2.properties hive-log4j2.properties \
#     ${HIVE_HOME}/conf/ '
# docker run -itd  --net=hadoop -p 9870:9870/tcp -p 8088:8088/tcp -p 16010:16010/tcp -p 19888:19888/tcp --name hadoop-master --hostname hadoop-master -e MYID=1 -e HIVE_HOME=/usr/local/hive -v $PWD/docker-workspace:/root/ ctazyn/hadoop-hbase:2.3