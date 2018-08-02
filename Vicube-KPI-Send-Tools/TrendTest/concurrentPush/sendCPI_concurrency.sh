#!/bin/bash  

vicIP="192.168.20.132"
vicPort="48080"
MyFile="100xCPI.csv"
##预处理换行符windows 2 linux
dos2unix $MyFile 2>/dev/null
##定义字段序
F_nodeKey=1
F_kpiKey=2
F_type=3
F_range=5
F_strValue=6
F_agentId=7
F_value=8
F_time=9


arisingTime1=$(date +%Y-%m-%d)
arisingTime2=$(date +%H:%M:%S)

nr=0;
while read line
do
    let nr++
    ##剔除表头
    if [[ $nr -eq 1 ]];
    then
	continue
    fi

    echo "Begin CPI:::"$line

    nodeKey=$(echo $line | awk -v seq=$F_nodeKey -F"," 'BEGIN{RS="\r"}{print $seq}')
    kpiKey=$(echo $line | awk -v seq=$F_kpiKey -F"," 'BEGIN{RS="\r"}{print $seq}')
    agentId=$(echo $line | awk -v seq=$F_agentId -F"," 'BEGIN{RS="\r"}{print $seq}')
    type=$(echo $line | awk -v seq=$F_type -F"," 'BEGIN{RS="\r"}{print $seq}')
   ## arisingTime from csv 
   # arisingTime=$(echo $line | awk -v seq=$F_time -F"," 'BEGIN{RS="\r"}{print $seq}')
   ## arisingTime from current Time
    arisingTime=$arisingTime1" "$arisingTime2
   
    # type=1标识数值型，type=2表示字符串
    if [[ "$type" == "1" ]]; then
        kv=$(echo $line | awk -v seq=$F_value -v range=$F_range -F"," '{srand();r=int(rand()*$range*100)/100;srand();if(rand()>=.5) print $seq+r;else print $seq-r}')
	
    else
        kv=$(echo $line | awk -v seq=$F_strValue -F"," '{print $seq}')
    fi

    echo $kv
    # 上报数据
    echo "curl -s  -H 'Content-type: application/json' -X POST -d '[{\"nodeKey\":\"$nodeKey\",\"kpiKey\":\"$kpiKey\",\"value\":\"$kv\",\"arisingTime\":\"$arisingTime\",\"agentId\":\"$agentId\"}]' http://$vicIP:$vicPort/restcenter/innerKpiApi/sendNewKpi/TestKpiData"

    resp=`curl -s  -H 'Content-type: application/json' -X POST -d "[{\"nodeKey\":\"$nodeKey\",\"kpiKey\":\"$kpiKey\",\"value\":\"$kv\",\"arisingTime\":\"$arisingTime\",\"agentId\":\"$agentId\"}]" http://$vicIP:$vicPort/restcenter/innerKpiApi/sendNewKpi/TestKpiData`
    resp_code=`echo $resp |jq -r '.result'`
    # #echo "Succ:$? ; kpiKey:${kpiKey}; agentId:${agentId}; arisingTime:${arisingTime1} ${arisingTime2}, nodeKey:${nodeKey}"
    # #echo "Succ:${?} ; kpiKey:${kpiKey}; agentId:${agentId};  "
    if [[ $resp_code == "SUCCESS" ]];then
        echo "  <KPI发送成功::    $line>"
	echo "$resp"
    else
        echo "  <失败>::$resp_code::message==>"
        # echo $resp |jq -r '.message'
        echo $resp
    fi
    sleep 5.005
done < $MyFile
