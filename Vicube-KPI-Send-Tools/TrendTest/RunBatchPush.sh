#!/bin/bash

##重置：最后一次运行条数的指针
sh clearLast.no.sh
if [[ -z $1 ]];
then
	stime=0
	echo ""
	echo "Usage: $0 Time-Interval"
	echo ""
	exit
else
	stime=$1
fi

##检查是否已经存在运行中进程，存在则kill掉
pids=`ps -ef|grep SendKpiData |grep -v 'grep'|awk '{print $2}'`;

for pid in $pids;
do 
	echo "Find Running Proccess:"$pid",killing...";
	kill $pid
done

cnt=`wc -l KPICI-manual.csv|awk '{print $1}'`
echo "total= $cnt"



n=1
while [ $n -le $cnt ]
do
    sh SendKpiData-v2.2.sh
    let n++    #或者写作n=$(( $n + 1 ))
    echo "sleep $stime secs"
    sleep $stime
done

