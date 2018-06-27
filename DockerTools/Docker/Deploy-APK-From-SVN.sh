#!/bin/sh

##author alalong 2018-04-16

deployDir=/opt/deploy.build

if [ ! -d "${deployDir}/apkdownload" ]; then
        #statements
        echo "Not Find ${deployDir}/apkdownload ,creating..."
        
        #mkdir -p ${deployDir}/apkdownload
        cd ${deployDir}
        
        svn checkout http://compile@175.25.50.70:8899/svn/other/10-Online/10-Product/11-INSPECTION/deploy.build/apkdownload
fi

con='inspection'

echo "进入SVN deploy目录: ${deployDir}/apkdownload"
cd ${deployDir}/apkdownload

##
echo "开始拉取..."
svn up

docker exec -i "$con" rm -rf /opt/apkdownload/apk
echo "若，docker没有目标目录，则创建...."

docker exec -i "$con" mkdir -p /opt/apkdownload/apk
docker exec -i "$con" rm -rf /opt/apkdownload/apk
docker cp ./ ${con}:/opt/apkdownload/apk

echo "更新完成，结果如下：@docker:/opt/apkdownload/apk/ "

docker exec -i "$con" ls /opt/apkdownload/apk/ -Sstl

echo "Done"