#!/usr/bin/env bash

file='/usr/local/nginx/logs/pv_access.log'
lastFile="last.log"
outfile=pingback_json.log

lastTime=`cat $lastFile`
if [[ -z $lastTime ]];
then
    lastTime=0
fi

echo $lastTime

tail -100000 $file |awk -v lastTime=$lastTime 'function urlDecode(url) {
    for (i = 0x20; i < 0x40; ++i) {
        repl = sprintf("%c", i);
        if ((repl == "&") || (repl == "\\")) {
            repl = "\\" repl;
        }
        url = gensub(sprintf("%%%02X", i), repl, "g", url);
        url = gensub(sprintf("%%%02x", i), repl, "g", url);
    }
    return url;
}

BEGIN{

}
{
time=$3;
ip=$1;
req=$7;
if(time>lastTime){
    split(req,m,"=");
    for(i=1;i<10;i+=2){
        if(index(m[i],"pvInsightObj")>0){
            print urlDecode(m[i+1])
            break;
        }
    }
}
}END{
  print time > "'$lastFile'"
}' > ${outfile}.new


##back up json data
newTime=`cat $lastFile`
##如果没有新的日志变化，则不生产数据json
hasNew=`echo 1|awk -v last=$lastTime -v new=$newTime '{printf("%d"),new*1000-last*1000}'`
if [[ $hasNew -gt 0 ]]
then
    mv ${outfile}.new ${outfile}.${newTime}
    echo "new json created: ${outfile}.${newTime} "

else
    echo "no change detected"

fi

echo "开始解析pingback json..."

while read json
do
    printf $(echo -n  $json | sed 's/\\/\\\\/g;s/\(%\)\([0-9a-fA-F][0-9a-fA-F]\)/\\x\2/g')"\n"|jq -r '.'

done<  ${outfile}.${newTime}