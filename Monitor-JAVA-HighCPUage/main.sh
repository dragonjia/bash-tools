#!/usr/bin/env bash

#通过vmstat 采样定义触发条件
##进程排队条件
procs_r=5
cpu_us=50
procs_cpu_usage_warning=50
#
#vminfo=`vmstat -w |awk -v r=procs_r=1 -v cpu_us=13 '{if($proces_r>0 && $cpu_us>10 ) print }'`
#if [ ! -z "$vminfo" ];
#then
#	echo "发现vmstat 进程排队>$procs_r && cpu_user% > $cpu_us ！";
#	echo $vminfo
#
#fi
#
#


##获取线程 占用top list  ##不建议使用
pids=`ps -eo pid,%cpu,ppid,cmd,%mem --sort=-%cpu |sed 's/^[ \t]*//g' | head| awk -v pid=1 -v usage=2 '{if($usage>20) print $pid}'`


##获取进程cpu占用率 toplist
#TODO: 截取第一个字段会出错，top输出结果有莫名的特殊字符 ,需要替换
typeset pids=`top -n1 -o %CPU|grep java|head -10| awk -v warningValue=$procs_cpu_usage_warning  '{cpuage=9;if($9>varningValue) print $0}'`
#typeset pids=${2:-$(pgrep -u $USER java)}
#typeset top=${1:-10}

for pid in pids
do
    typeset tmp_file=/tmp/java_${pid}_$$.trace

    jstack $pid > $tmp_file
    ps H -eo user,pid,ppid,tid,time,%cpu --sort=%cpu --no-headers\
            | tail -$top\
            | awk -v "pid=$pid" '$2==pid{print $4"\t"$6}'\
            | while read line;
            do
                typeset nid=$(echo "$line"|awk '{printf("0x%x",$1)}')
                typeset cpu=$(echo "$line"|awk '{print $2}')
                awk -v "cpu=$cpu" '/nid='"$nid"'/,/^$/{print $0"\t"(isF++?"":"cpu="cpu"%");}' $tmp_file
            done

    rm -f $tmp_file
done