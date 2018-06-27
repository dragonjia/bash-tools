#!/bin/sh


if [ -z "$1" ];
then
	echo ""
	echo "Usage $0 ContainerID"
	echo ""
	echo ""
	exit 1;
fi


pubBaseDir="/opt/inspection"
pubBashDir=${pubBaseDir}/bin
container=$1
svnBaseDir="${pubBaseDir}/SVN"
svnDir="${svnBaseDir}/inspection"

buildDir="${pubBaseDir}/build/server"
dayOfYear=`date +%j`
cd $svnBaseDir


echo "SVN checkout...."
svn co http://175.25.50.70:8899/svn/other/10-Online/10-Product/11-INSPECTION/project/inspection/ --username compile --password '18N64gY\GsbH\q1TL73e'

cd $svnDir

echo "clear war..."
rm -rf ./build/libs/*
rm -rf ${buildDir}/webapps


echo "gradle build..."
gradle build


echo "deploy to local <$buildDir>...& backup..."
mkdir -p ${buildDir}/webapps
cp ./build/libs/*.war ${buildDir}/webapps/

echo "backup by date, max 366"
mkdir -p ${buildDir}/webapps-${dayOfYear}
cp ./build/libs/*.war ${buildDir}/webapps-${dayOfYear}

echo "deploy to docker container...<$container>..."
sh ${pubBashDir}/deployOnly-Server.sh $container ${buildDir}/webapps


echo "重启Docker's Tomcat...."
sleep 2
sh /opt/Docker/inDocker_restartTomcat.sh  $container
