#!/bin/bash  

vicIP="192.168.20.132"
vicPort="48080"
arisingTime1=$(date +%Y-%m-%d)
arisingTime2=$(date +%H:%M:%S)

#nodeKey="XM-XX-DB01"
#kpiKey="XM-Linux_P_CPU_TotalTimeUtilization"
#kv=`perl -e 'printf "%.1f", 20 + rand 15'`
#agentId="AAAATest"

while read line
do
    #去除每行首尾空格
    l=$(echo "$line")
    l=$(echo $l | awk -F"\r" '{print $1}')
    # 忽略空行
    if [[ "$l" != "" ]]; then
        nodeKey=$(echo $l | awk -F"," '{print $1}')
        # 忽略标题行，如果首行第一个字段 = nodeKey，认为是标题，忽略
        if [[ "$nodeKey" != "nodeKey" ]]; then
            kpiKey=$(echo $l | awk -F"," '{print $2}')
            agentId=$(echo $l | awk -F"," '{print $7}')
            type=$(echo $l | awk -F"," '{print $3}')
            # type=1标识数值型，type=2表示字符串
            if [[ "$type" == "1" ]]; then
                min=$(echo $l | awk -F"," '{print $4}')
                max=$(echo $l | awk -F"," '{print $5}')
                kv=$(($RANDOM%${max}+${min}))
            else
                kv=$(echo $l | awk -F"," '{print $6}')
            fi
            # 上报数据
            echo curl -H "Content-type: application/json" -X POST -d '[{"nodeKey":"'$nodeKey'","kpiKey":"'$kpiKey'","value":"'$kv'","arisingTime":"'$arisingTime1' '$arisingTime2'","agentId":"'$agentId'"}]' http://$vicIP:$vicPort/restcenter/innerKpiApi/sendNewKpi/TestKpiData
            
            curl -H "Content-type: application/json" -X POST -d '[{"nodeKey":"'$nodeKey'","kpiKey":"'$kpiKey'","value":"'$kv'","arisingTime":"'$arisingTime1' '$arisingTime2'","agentId":"'$agentId'"}]' http://$vicIP:$vicPort/restcenter/innerKpiApi/sendNewKpi/TestKpiData
            #echo "Succ:$? ; kpiKey:${kpiKey}; agentId:${agentId}; arisingTime:${arisingTime1} ${arisingTime2}, nodeKey:${nodeKey}"
            #echo "Succ:${?} ; kpiKey:${kpiKey}; agentId:${agentId};  "
        fi
    fi
done < ./KPICI.csv
