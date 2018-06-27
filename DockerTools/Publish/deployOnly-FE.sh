#!/bin/sh


if [[ -z "$2" ]]
then
	echo "========ERROR Parameter======="
	echo ""
	echo " USAGE: $0 [container ID] [local Dir_wwwroot]"
	echo ""
	exit
fi

docker exec -i "$1" rm -rf /opt/wwwroot.last
docker exec -i "$1" mv /opt/wwwroot /opt/wwwroot.last
docker cp  $2 $1:/opt/
