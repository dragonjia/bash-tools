#!/bin/sh

##author alalong 2018-03-30

deployDir=/opt/deploy.build

if [ ! -d "$deployDir" ]; then
	#statements
	svn checkout http://compile@175.25.50.70:8899/svn/other/10-Online/10-Product/11-INSPECTION/deploy.build /opt/opt/deploy.build
fi

con='inspection'

echo "进入SVN deploy目录: ${deployDir}/wwwroot"
cd ${deployDir}/wwwroot

##
echo "开始拉取..."
svn up



docker cp wwwroot.tgz ${con}:/opt

#只保留最近三次备份
docker exec -i "$con" rm -rf  /opt/wwwroot.last3
docker exec -i "$con" mv /opt/wwwroot.last2 /opt/wwwroot.last3
docker exec -i "$con" mv /opt/wwwroot.last /opt/wwwroot.last2

docker exec -i "$con" mv /opt/wwwroot /opt/wwwroot.last
docker exec -i "$con" tar -zxv -C /opt -f /opt/wwwroot.tgz

echo "Done"