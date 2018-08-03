#!/usr/bin/env bash

#author by alalong 2018.8.2


#目的，自动检测相关服务是否可用
#检测项目：

##1. vicube  （host中设置） 是否可达、端口服务是否可用
##2. 是否正确配置了【生产】环境参数 （位于/etc/profile）
##3. redis是否启动
##4. postgres 是否配置正确


##1. vicube  （host中设置） 是否可达、端口服务是否可用
vicube_ip=`awk '{if(substr( $0, 1, 1)!="#"){ if($2=="vicube") ip=$1}}END{print ip}' /etc/hosts`
vicube_port=48080
ping -c1 $vicube_ip 1>/dev/null 2>/dev/null
SUCCESS=$?
#ping -c 1 vicube
if [ $SUCCESS -eq 0 ]
then
    echo ""
    #继续检测 端口是否可用
    r=$(bash -c 'exec 3<> /dev/tcp/'$vicube_ip'/'$vicube_port';echo $?' 2>/dev/null)
    if [ "$r" = "0" ]; then
         echo "OK , vicube  配置正确  (/etc/hosts)！ &&  $vicube_ip@$vicube_port 端口可达 "
    else
         echo "错误，vicube  配置正确  (/etc/hosts)！ &&  $vicube_ip@$vicube_port 端口不可达 "
         exit 1 # To force fail result in ShellScript
    fi
else
  echo "OK , Vicube($vicube_ip) 不可达"
fi




DeployWhich=`grep SPRING_PROFILES_ACTIVE /etc/profile|awk -F'=' '{print $2}'`

if [[ abc$DeployWhich != abc"product" ]]
then
    echo "Warning : 未正确配置【生产环境参数]! 请检查 /etc/profile ,正确添加一行：\
        export SPRING_PROFILES_ACTIVE=product"

fi

prod_conf="/opt/webapps/ROOT/WEB-INF/classes/application-${DeployWhich}.properties"

##2. 是否正确配置了【生产】环境参数 （位于/etc/profile）
#echo "检测主配置文件：$prod_conf"
    dbip=`cat $prod_conf|grep "jdbc:postgresql"|awk -F'/' '{print $3}'|cut -d ':' -f1`
    dbport=`cat $prod_conf|grep "jdbc:postgresql"|awk -F'/' '{print $3}'|cut -d ':' -f2`

    ip=$dbip;port=$dbport
    ip=`echo $ip|tr -d \r`
    port=`echo $port|tr -d \r`
    #检测 DB是否可用
    r=$(bash -c 'exec 3<> /dev/tcp/'$ip'/'$port';echo $?' 2>/dev/null)
    if [ "$r" = "0" ]; then
         echo "OK , postgreDB $ip@$port 端口可达 "
    else
         echo "Warning , postgreDB $ip@$port 端口不可达！ "
    fi

##3. redis是否启动
    #先从当前启用的配置文件中提取配置信息
    redisip=`cat $prod_conf|grep -v "#"|grep ".redis.host"|awk -F'=' '{print $2}'`
    redisport=`cat $prod_conf|grep -v "#"|grep ".redis.port"|awk -F'=' '{print $2}'`

    ip=$redisip;port=$redisport
    ip=`echo $ip|tr -d \r|tr -d \n|sed 's/
//g'`
    port=`echo $port|tr -d \r|tr -d \n|sed 's/
//g'`
    #检测 DB是否可用
    r=$(bash -c 'exec 3<> /dev/tcp/'$ip'/'$port';echo $?' 2>/dev/null)
    if [ "$r" = "0" ]; then
         echo "OK , redis $ip:$port 端口可达 "
    else
         echo "Warning , redis $ip:$port 端口不可达！ "
    fi


##4. postgres 是否配置正确

