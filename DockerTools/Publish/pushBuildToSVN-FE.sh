#!/bin/sh

#推送前端编译代码至svn
# from build/wwwroot  -- 最新、编译通过的版本

baseDir=/opt/inspection

cd $baseDir

#第一次需要co svn
##svn checkout http://compile@175.25.50.70:8899/svn/other/10-Online/10-Product/11-INSPECTION/deploy.build


##将当前FE版本推送到SVN
cd build
tar -zc wwwroot > ../deploy.build/wwwroot/wwwroot.tgz 
cd ../deploy.build/wwwroot && svn commit -m "deploy.build"
