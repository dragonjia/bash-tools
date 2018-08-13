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
    #FS="\""
}
{
time=$3;
ip=$1;
req=$7;
if(time>lastTime){
    split($req,m,"=");
    for(i=1;i<10;i+=2){
        if(index(m[i],"pvInsightObj")>0){
            print urlDecode(m[i+1])
        }
    }
}
}END{svn
  print time > "'$lastFile'"
}' > ${outfile}.new


##back up json data
newTime=`cat $lastFile`
##如果没有新的日志变化，则不生产数据json
if [ `echo "$lastTime < $newTime"|bc` -eq 1 ] ; then
    mv ${outfile}.new ${outfile}.${newTime}
    echo "new json created: ${outfile}.${newTime} "

else
    echo "no change detected"

fi