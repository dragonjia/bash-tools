#!/bin/sh

#define locate of project in container
##docker webapps dir
remoteBase="/opt"
remoteWebapps="${remoteBase}/webapps"

if [[ -z "$2" ]]
then
	echo "========ERROR Parameter======="
	echo ""
	echo " USAGE: $0 [container ID] [local Dir_wwwroot]"
	echo ""
	exit
fi
container=$1
localWebapps=$2

docker exec -d "$container" rm -rf ${remoteWebapps}.last
docker exec -i "$container" mv ${remoteWebapps} ${remoteWebapps}.last
docker cp  ${localWebapps} $container:${remoteBase}
