#!/usr/bin/env bash

file='/usr/local/nginx/logs/pv_access.log'
lastFile="last.log"
outfile=pingback_json.log

lastTime=`cat $lastFile`
if [[ -z $lastTime ]];
then
    lastTime=0
fi



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
    split(req,m,"pvInsightObj=");
    if(index(m[1],"/pv.gif")>-1){
        print urlDecode(m[2])
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
    echo "开始解析pingback json..."
    while read json
    do
#        printf $(echo -n  $json | sed 's/\\/\\\\/g;s/\(%\)\([0-9a-fA-F][0-9a-fA-F]\)/\\x\2/g')"\n"|jq -r '.'
        click=`echo "$json" | jq -r '.ck'`
        clickName=`printf $(echo -n  $click | sed 's/\\/\\\\/g;s/\(%\)\([0-9a-fA-F][0-9a-fA-F]\)/\\x\2/g')"\n"`
        echo "$json"|
          jq "map(if .ck != ''
                then  . + {\"click\":\"$clickName\"}
                else .
                end)"


    done<  ${outfile}.${newTime}

else
    echo "no change detected (上次断点id=$lastTime)"

fi
