#!/bin/bash  

vicIP="192.168.20.132"
vicPort="48080"
MyFile="KPICI-manual.csv"
##预处理换行符windows 2 linux
dos2unix $MyFile 2>/dev/null
##定义字段序
F_nodeKey=1
F_kpiKey=2
F_type=3
F_strValue=6
F_agentId=7
F_value=8
F_time=9


flast="last.no"
last=`cat $flast`
if [[ $last -lt 2 ]]; then 
        last=2; 
else
    last=`expr $last + 1`
fi
arisingTime1=$(date +%Y-%m-%d)
arisingTime2=$(date +%H:%M:%S)

#获取下一行数据
line=`cat $MyFile|awk -v lno=$last '{if(NR==lno) print }'`


##如果文件读取结束，提示
cat $MyFile|awk -v lno=$last '{}END{if(FNR<lno) printf("\r\n文件读取结束(%d/%d)，若重新发送请删除last.no文件！\r\n\r\n",lno,NR) }'
##如果不为空行
if [[ "$line" != "" ]]; then

    echo 1 |awk -v last=$last '{printf("当前处理第 %d 行.....",last)}'

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
        kv=$(echo $line | awk -v seq=$F_value -F"," '{print $seq}')
    else
        kv=$(echo $line | awk -v seq=$F_strValue -F"," '{print $seq}')
    fi
    # 上报数据
    echo "curl -s  -H 'Content-type: application/json' -X POST -d '[{\"nodeKey\":\"$nodeKey\",\"kpiKey\":\"$kpiKey\",\"value\":\"$kv\",\"arisingTime\":\"$arisingTime\",\"agentId\":\"$agentId\"}]' http://$vicIP:$vicPort/restcenter/innerKpiApi/sendNewKpi/TestKpiData"
    resp=`curl -s  -H 'Content-type: application/json' -X POST -d "[{\"nodeKey\":\"$nodeKey\",\"kpiKey\":\"$kpiKey\",\"value\":\"$kv\",\"arisingTime\":\"$arisingTime\",\"agentId\":\"$agentId\"}]" http://$vicIP:$vicPort/restcenter/innerKpiApi/sendNewKpi/TestKpiData`
    resp_code=`echo $resp |jq -r '.result'`
    # #echo "Succ:$? ; kpiKey:${kpiKey}; agentId:${agentId}; arisingTime:${arisingTime1} ${arisingTime2}, nodeKey:${nodeKey}"
    # #echo "Succ:${?} ; kpiKey:${kpiKey}; agentId:${agentId};  "
    if [[ $resp_code == "SUCCESS" ]];then
        echo "  <KPI发送成功::    $line>"
	echo "$resp"
        echo $last > $flast
    else
        echo "  <失败>::$resp_code::message==>"
        # echo $resp |jq -r '.message'
        echo $resp
    fi
fi

