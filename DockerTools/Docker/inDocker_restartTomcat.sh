#!/bin/sh

## restart in docker container="inspection"


echo "检测是否存在docker container==inspection"

con=`docker ps|grep "inspection"`;

if [[ -z "$con" ]]
then
        echo "docker container [inspeciton] not found! "
        exit
fi

echo "开始重新启动tomcat ..."
docker exec -i inspection bash -c ". /etc/profile;cd /usr/local/tomcat/bin&&./restart.sh"
echo "tomcat已重启 "
