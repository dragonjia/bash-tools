#!/bin/sh

##author alalong 2018-03-30

deployDir=/opt/deploy.build

if [ ! -d "${deployDir}/wwwrootOther" ]; then
        #statements
        echo "Not Find ${deployDir}/wwwrootOther ,creating..."
        
        mkdir -p ${deployDir}/wwwrootOther
        cd ${deployDir}
        
        svn checkout http://compile@175.25.50.70:8899/svn/other/10-Online/10-Product/11-INSPECTION/deploy.build/wwwrootOther
fi

con='inspection'

echo "进入SVN deploy目录: ${deployDir}/wwwrootOther"
cd ${deployDir}/wwwrootOther

##
echo "开始拉取..."
svn up

# cd ..
# tar -zc wwwrootOther > wwwrootOther.tgz

echo "推送至Docker,并解压缩...."
docker cp wwwrootOther.tgz ${con}:/opt

docker exec -i "$con" rm -rf /opt/wwwrootOther.last
docker exec -i "$con" mv /opt/wwwrootOther /opt/wwwrootOther.last
docker exec -i "$con" tar -zxv -C /opt -f /opt/wwwrootOther.tgz


echo "Done"