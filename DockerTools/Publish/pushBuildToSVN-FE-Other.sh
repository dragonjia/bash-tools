#!/bin/sh

#推送前端编译代码至svn
# from build/wwwroot  -- 最新、编译通过的版本

baseDir=/opt/inspection

cd $baseDir

#第一次需要co svn
if [[ -d ${baseDir}/deploy.build/wwwrootOther ]]; then
	#statements
	echo "svn has checkouted,skip."
else
	echo "svn  checkouted"
	cd ${baseDir}/deploy.build/
	svn checkout http://compile@175.25.50.70:8899/svn/other/10-Online/10-Product/11-INSPECTION/deploy.build/wwwrootOther
fi

##将当前FE版本推送到SVN
cd /opt/inspection/SVN
svn co http://compile@175.25.50.70:8899/svn/other/10-Online/10-Product/11-INSPECTION/project/wwwrootOther 

tar -zc wwwrootOther > ../deploy.build/wwwrootOther/wwwrootOther.tgz 
cd ../deploy.build/wwwrootOther &&  svn commit -m "deploy.build" || svn add wwwrootOther.tgz

echo "发布成功，svn位置:svn/other/10-Online/10-Product/11-INSPECTION/deploy.build/wwwrootOther/wwwrootOther.tgz"
