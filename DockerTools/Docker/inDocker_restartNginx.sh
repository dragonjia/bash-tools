#!/bin/sh

## for restart nginx in docker container="inspection"

#docker exec -i inspection bash -c "cd /usr/local/tomcat/bin&&./restart.sh"

echo "检测是否存在docker container==inspection"

con=`docker ps|grep "inspection"`;

if [[ -z "$con" ]]
then
        echo "docker container [inspeciton] not found! "
        exit
fi

echo "开始重新启动nginx ..."
docker exec -i inspection bash -c "cd /usr/local/nginx/sbin && ./restart.sh"
echo "nginx已重启 "
