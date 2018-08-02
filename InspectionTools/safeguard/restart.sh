#!/usr/bin/env bash

PWD=`pwd`

echo "  #########restart webcontent (nginx)##############"

/usr/local/nginx/sbin/nginx -s stop
/usr/local/nginx/sbin/nginx -s stop
sleep 3
/usr/local/nginx/sbin/nginx -s stop
sleep 1
/usr/local/nginx/sbin/nginx
echo "  #########webcontent (nginx) Done! ##############"


echo "  #########restart appJava (tomcat)##############"
cd /usr/local/tomcat/bin/
sh shutdown.sh
sleep 5
sh shutdown.sh
sleep 1
./catalina.sh stop
sleep 5
./catalina.sh start


sleep 10
echo "  #########restart imageServer (go)##############"
cd /opt/go-SimpleHTTPServer
sh restart.sh
sleep 1
echo "  #########restart imageupload (go)##############"
cd /opt/go-imageupload
sh restart.sh
sleep 1
/usr/local/nginx/sbin/nginx

cd $PWD