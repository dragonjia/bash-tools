#!/bin/sh

#########
#  使用方式, $0 [remoteip] [remote_docker_container]
#  原理： 1）将本地build目录下的 wwwroot 静态资源、java war 包 同步到
#	  远程目标服务器；
# 	  2）调用远程shell部署到容器内部
#	  3）启动远程容器内重启命令
#########

if [[ -z "$2" ]]
then
	echo "========ERROR Parameter======="
	echo ""
	echo " USAGE: $0 [remote_IP] [container ID]"
	echo ""
	exit
fi

remote_ip=$1
##remote docker container ID
remote_dcid=$2 
remote_base=/opt/inspection
remote_deploy=${remote_base}/Deploy
remote_pub_bash=${remote_base}/Publish

buildDir="/opt/inspection/build"


scp -r ${buildDir}/server/webapps $remote_ip:${remote_deploy}
scp -r ${buildDir}/wwwroot $remote_ip:${remote_deploy}
ssh ${remote_ip} "${remote_pub_bash}/deployOnly-Server.sh ${remote_dcid} ${remote_deploy}/wwwroot"
