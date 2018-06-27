
echo "restart tomcat ... "
/usr/local/tomcat/bin/catalina.sh stop
sleep 1

pids=`ps -ef|grep java|awk '{print $2}'`;
for pid in $pids;
do
        kill -9 "$pid"
done

sleep 1
/usr/local/tomcat/bin/catalina.sh start


echo "see logs with :"
echo ""
echo ""
echo "tail -2000f /usr/local/tomcat/logs/catalina.out |grep -v 'DEBUG'|grep -v 'INFO'"
echo ""
echo ""

echo ""
#echo ""
#echo " tomcat deply inspection.war..."
#cp ./build/libs/*.war /usr/local/tomcat/webapps
#echo ""
#echo " resinctl web-app-start inspection..."
#/usr/local/resin/bin/resinctl web-app-start inspection-0.0.1-SNAPSHOT
