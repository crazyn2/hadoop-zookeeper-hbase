#!/bin/bash
start_container(){
    names=$(docker ps -a | grep $1 | gawk '{print $1}')
    if [ ! -n "$names" ]
    then
        echo "There is no container $1."
    else
        docker start $names
        if [ $1 = "hadoop-master" ]
        then
            docker exec -it hadoop-master /bin/bash -c "start-all.sh && service mysql start" 
            docker exec -it hadoop-master /bin/bash
        fi
    fi
}
stop_container(){
    names=$(docker ps | grep $1 | gawk '{print $1}')
    echo $name
    if [ -z "$names" ]
    then 
        echo "There is no running containers."
    else
        docker stop $names
    fi
    # echo ""
}
lists=("hadoop-slave1" "hadoop-slave2" "hadoop-master")
# for list in ${lists[@]}
# do 
#     if [ $list = "hadoop-master" ]
#     then
#         echo $list
#     fi
# done
case $1 in 
    start)
        for list in ${lists[@]}
        do 
            echo $list
            start_container $list
        done
    ;;
    stop)
        for list in ${lists[@]}
        do 
            echo $list
            stop_container $list
        done
    ;;
esac