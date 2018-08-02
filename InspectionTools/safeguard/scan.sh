#!/usr/bin/env bash

echo
pid=`ps -ef | grep "java"|grep "tomcat"|grep -v grep|awk '{print $2}'`
if [ ${#pid} -ne 0 ]; then
   echo "Inspection Main(java) ..........has Started! ${pid}"
else
   echo "Inspection Main(java) ..........has Stopped!"
fi

pid=`ps -ef | grep "nginx: master process"|grep -v grep|awk '{print $2}'`
if [ ${#pid} -ne 0 ]; then
   echo "webcontent(nginx)     ..........has Started! ${pid}"
else
   echo "webcontent(nginx)     ..........has Stopped!"
fi

pid=`ps -ef | grep "go-SimpleHTTPServer"|grep -v grep|awk '{print $2}'`
if [ ${#pid} -ne 0 ]; then
   echo "Image Server ...................has Started! ${pid}"
else
   echo "Image Server ...................has Stopped!"
fi

pid=`ps -ef | grep "./save"|grep -v grep|awk '{print $2}'`
if [ ${#pid} -ne 0 ]; then
   echo "Image Upload ...................has Started! ${pid}"
else
   echo "Image Upload ...................has Stopped!"
fi

pid=`ps -ef | grep "redis-server"|grep -v grep|awk '{print $2}'`
if [ ${#pid} -ne 0 ]; then
   echo "redis...........................has Started! ${pid}"
else
   echo "redis...........................has Stopped!"
fi


STATUS=`crontab -l|grep "go-syncUserGroupInfo"|awk '{if(index($1,"#")!=1) print 1}'`
if [ $STATUS -eq 1 ];then
   echo "SyncUser(Crontab)...............OK"
else
   echo "SyncUser(Crontab)...............Failed"
fi
echo
echo