#!/bin/bash
#$1->主机ip
if [ -z "$1" ];then
    echo 'use host ip for first params'
    exit
fi

BASE="/usr/local/cloudnetlot"
BIN_PATH=${BASE}/script
HOST="$1"
echo "------------------------------部署cloudnetlotserver环境-----------------------------"
if [ -f "${BASE}/cloudnetlotserver/nginx/nginx.tar.gz" ];then
    tar zxf ${BASE}/cloudnetlotserver/nginx/nginx.tar.gz -C ${BASE}/cloudnetlotserver/nginx/
    rm -rf ${BASE}/cloudnetlotserver/nginx/nginx.tar.gz
fi
if [ -f "${BASE}/cloudnetlotserver/php/php.tar.gz" ];then
    tar zxf ${BASE}/cloudnetlotserver/php/php.tar.gz -C ${BASE}/cloudnetlotserver/php
    rm -rf ${BASE}/cloudnetlotserver/php/php.tar.gz
fi
echo "------------------------------清理cloudnetlotserver环境缓存--------------------------"
tmp1=`docker ps | grep cloudnetlotserver`

if [ ! -z "$tmp1" ];then
    docker stop cloudnetlotserver
    docker rm cloudnetlotserver
fi

tmp2=`docker ps -a | grep cloudnetlotserver`
if [ ! -z "$tmp2" ];then
    docker rm cloudnetlotserver
fi

tmp3=`docker images | grep cloudnetlotserver | awk '{print $3}'`
if [ ! -z "$tmp3" ];then
    docker rmi "$tmp3"
fi
echo "--------------------------------获取镜像----------------------------------------"
cd ${BASE}/soft
packagename=`ls | grep 'dockercloudnetlotserver*'`
if [ ! -z "$packagename" ];then
    docker load < ${BASE}/soft/${packagename}
    imagename="`docker images | grep cloudnetlotserver | awk '{print $1}'`:`docker images | grep cloudnetlotserver | awk '{print $2}'`"
else
    echo "please input cloudnetlotserver images:"
    read imagename
    docker pull ${imagename}
fi
echo "----------------------------------运行cloudnetlotserver容器--------------------------"

if [ "$2" = "true" ];then
    docker run --name cloudnetlotserver -p 9090:80 -p 7777:7777 -v ${BASE}/cloudnetlotserver/nginx:/etc/nginx -v ${BASE}/cloudnetlotserver/php:/etc/php/5.6 -v ${BASE}/www:/usr/local/www -v /etc/localtime:/etc/localtime:ro --restart=no -it -d ${imagename}
else
    docker run --name cloudnetlotserver -p 9090:80 -p 7777:7777 -v ${BASE}/www:/usr/local/www -v /etc/localtime:/etc/localtime:ro --restart=no -it -d ${imagename}
fi
