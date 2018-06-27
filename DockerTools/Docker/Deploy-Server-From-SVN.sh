#!/bin/sh

##author alalong 2018-03-30


deployDir=/opt/deploy.build


if [ ! -d "$deployDir" ]; then
	#statements
	svn checkout http://compile@175.25.50.70:8899/svn/other/10-Online/10-Product/11-INSPECTION/deploy.build /opt/deploy.build	
fi

echo "进入SVN deploy目录: ${deployDir}/webapps"
cd ${deployDir}/webapps

##
echo "开始拉取..."
svn up


##开始部署到Docker 容器: inspection
con='inspection'


docker exec -i "$con" rm -rf /opt/webapps.last
docker exec -i "$con" mv /opt/webapps /opt/webapps.last
docker exec -i "$con" mkdir -p /opt/webapps
docker cp ${deployDir}/webapps/inspection-0.0.1-SNAPSHOT.war ${con}:/opt/webapps


echo "Done"