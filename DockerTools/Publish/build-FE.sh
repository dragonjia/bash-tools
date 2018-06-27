#!/bin/sh


if [[ -z "$1" ]]
then
	echo "========ERROR Parameter======="
	echo ""
	echo " USAGE: $0 product(default)|test|dev"
	echo ""
	exit
fi


mod=$1

echo "============checkout FE code to /opt/wwwroot==========="
svn co http://175.25.50.70:8899/svn/other/10-Online/10-Product/11-INSPECTION/webContent --username compile --password '18N64gY\GsbH\q1TL73e' /opt/inspection/SVN/webContent #/opt/wwwroot

echo ""
echo ""
echo "=====checkout FE code of inspection Done! (/opt/inspection/SVN/webContent)===="
echo ""
echo "===== begin webpack FrontEnd project ====="
echo ""
cd  /opt/inspection/SVN/webContent

if [[ "$mod" == "test" ]]
then
        npm run buildtest

else
	if [[ "$mod" == "dev" ]]
	then
        npm run builddev
	else
        npm run build
    fi
fi

##Copy dist to local wwwroot & backup & backup & backup & backup
	FE_SVN_DIR=/opt/inspection/SVN/webContent
	buildDir="/opt/inspection/build"
	rm -rf  ${buildDir}/wwwroot/*
	cp -r ${FE_SVN_DIR}/dist/* $buildDir/wwwroot/
	##backup
	dayOfYear=`date +%j`
	backDir=$buildDir/wwwroot-${dayOfYear}
	rm -rf $backDir
	cp -r  $buildDir/wwwroot $backDir
##End Copy to local build dir


