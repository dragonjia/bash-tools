#!/usr/bin/env bash

file='/usr/local/nginx/logs/pv_access_log'
lastTime=`cat last.log`
if [[ -z $lastTime ]];
then
    lastTime=0
fi

echo $lastTime

tail -100f ../logs/pv_access.log |awk -v lastTime=$lastTime '
function urlDecode(url) {
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
    #FS="\""
}
{
time=$3;
ip=$1;
if(time>lastTime){
    split($7,m,"=");
    for(i=1;i<10;i+=2){
        if(index(m[i],"pvInsightObj")>0){
            print urlDecode(m[i+1])
        }
    }
}
}END{
}'
