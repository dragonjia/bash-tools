#!/bin/sh

## author: alalong  2018-03-28


echo "准备重新启动 go-imageupload 服务..."

cd /opt/go-imageupload/
cd examples/save;go build ; cd -
./restart.sh

echo "重启完成!"
echo ""
echo "准备重新启动 go-SimpleHTTPServer 服务..."

cd /opt/go-SimpleHTTPServer
go build
./restart.sh

echo "重启完成!"
