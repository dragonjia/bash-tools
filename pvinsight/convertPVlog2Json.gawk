#!/bin/igawk -f

#@include awkfun/func.awk

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
ip=$1;
split($7,m,"=");
for(i=1;i<10;i+=2){
    if(index(m[i],"pvInsightObj")>0){
        print urlDecode(m[i+1])
    }
}

}END{
}
