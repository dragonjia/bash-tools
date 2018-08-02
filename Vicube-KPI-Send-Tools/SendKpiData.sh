#!/bin/bash  

vicIP="192.168.20.132"
vicPort="48080"
nodeKey="FinancialSystem_Test10"
kpiKey="Application_P_Transcation_Amount"
kv=`perl -e 'printf "%.1f", 20 + rand 15'`
arisingTime1=$(date +%Y-%m-%d)
arisingTime2=$(date +%H:%M:%S)
agentId="aaaatest"


curl -H "Content-type: application/json" -X POST -d '[{"nodeKey":"'$nodeKey'","kpiKey":"'$kpiKey'","value":"'$kv'","arisingTime":"'$arisingTime1' '$arisingTime2'","agentId":"'$agentId'"}]' http://$vicIP:$vicPort/restcenter/innerKpiApi/sendNewKpi/TestKpiData