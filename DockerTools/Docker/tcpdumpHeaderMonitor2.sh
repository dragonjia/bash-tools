 #!/bin/bash


##for more info: https://www.cnblogs.com/ggjucheng/archive/2012/01/14/2322659.html
 #tcpdump -i eno16777984 -vvvs 1024 -l -A host 192.168.20.222 | grep -B3 -A10 "GET /api/"
tcpdump -i eno16777984 -A -s 0 'tcp port 80 and (((ip[2:2] - ((ip[0]&0xf)<<2)) - ((tcp[12]&0xf0)>>2)) != 0)'


##打印所有源或目的端口是48080, 网络层协议为IPv4, 并且含有数据,而不是SYN,FIN以及ACK-only等不含数据的数据包.(ipv6的版本的表达式可做练习)
tcpdump -A -s 0 'tcp port 48080 and (((ip[2:2] - ((ip[0]&0xf)<<2)) - ((tcp[12]&0xf0)>>2)) != 0)'

