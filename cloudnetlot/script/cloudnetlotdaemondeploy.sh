#!/bin/bash
#$1->主机ip
if [ -z "$1" ];then
    echo 'use host ip for first params'
    exit
fi
BASE="/usr/local/cloudnetlot"
BIN_PATH=${BASE}/script
HOST="$1"
echo "------------------------------部署cloudnetlotdaemon环境-----------------------------"
if [ -f "${BASE}/cloudnetlotdaemon/php/php.tar.gz" ];then
    tar zxf ${BASE}/cloudnetlotdaemon/php/php.tar.gz -C ${BASE}/cloudnetlotdaemon/php
    rm -rf ${BASE}/cloudnetlotdaemon/php/php.tar.gz
fi
echo "------------------------------清理cloudnetlotdaemon环境缓存--------------------------"
tmp1=`docker ps | grep cloudnetlotdaemon`

if [ ! -z "$tmp1" ];then
    docker stop cloudnetlotdaemon
    docker rm cloudnetlotdaemon
fi

tmp2=`docker ps -a | grep cloudnetlotdaemon`
if [ ! -z "$tmp2" ];then
    docker rm cloudnetlotdaemon
fi

tmp3=`docker images | grep cloudnetlotdaemon | awk '{print $3}'`
if [ ! -z "$tmp3" ];then
    docker rmi "$tmp3"
fi
echo "--------------------------------获取镜像----------------------------------------"
cd ${BASE}/soft
packagename=`ls | grep 'dockercloudnetlotdaemon*'`
if [ ! -z "$packagename" ];then
    docker load < ${BASE}/soft/${packagename}
    imagename="`docker images | grep cloudnetlotdaemon | awk '{print $1}'`:`docker images | grep cloudnetlotdaemon | awk '{print $2}'`"
else
    echo "please input cloudnetlotdaemon images:"
    read imagename
    docker pull ${imagename}
fi
echo "----------------------------------运行cloudnetlotdaemon容器--------------------------"

if [ "$2" = "true" ];then
    docker run --name cloudnetlotdaemon -p 9091:9091 -p 9092:9092 -p 9093:9093 -v ${BASE}/cloudnetlotdaemon/php:/etc/php/7.1.20 -v ${BASE}/www/cloudnetlotdaemon:/usr/local/www/cloudnetlotdaemon -v /etc/localtime:/etc/localtime:ro --restart=always -it -d ${imagename}
else
    docker run --name cloudnetlotdaemon -p 9091:9091 -p 9092:9092 -p 9093:9093 -v ${BASE}/www/cloudnetlotdaemon:/usr/local/www/cloudnetlotdaemon -v /etc/localtime:/etc/localtime:ro --restart=always -it -d ${imagename}
fi
