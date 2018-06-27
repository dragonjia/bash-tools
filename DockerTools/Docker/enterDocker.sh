#!/bin/bash
#Des：enter docker container by pid
#Auther: wen
#Date: 2017/06/30

enter_docker() {
    container_ID=$1
    PID=`docker inspect -f "{{.State.Pid}}" $container_ID`
    nsenter -t $PID -m -u -i  -n -p
}

sudo_enter_docker() {
    container_ID=$1
    PID=`docker inspect -f "{{.State.Pid}}" $container_ID`
    sudo nsenter -t $PID -m -u -i  -n -p
}

if [[ -z $1 ]]
then
	con="inspection"
	sudo_enter_docker $con
else
	con=$1
	enter_docker "$con"
fi




