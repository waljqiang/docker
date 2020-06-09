#!/bin/bash
#$1->主机ip
if [ -z "$1" ];then
    echo 'use host ip for first params'
    exit
fi

BASE="/usr/local/cloudnetlot"
BIN_PATH=${BASE}/script
HOST="$1"
echo "------------------------------部署cloudnetlotencode环境-----------------------------"
if [ -f "${BASE}/cloudnetlotencode/php5/php5.tar.gz" ];then
    tar zxf ${BASE}/cloudnetlotencode/php5/php5.tar.gz -C ${BASE}/cloudnetlotencode/php5/
    rm -rf ${BASE}/cloudnetlotencode/php5/php5.tar.gz
fi

if [ -f "${BASE}/cloudnetlotencode/php7/php7.tar.gz" ];then
    tar zxf ${BASE}/cloudnetlotencode/php7/php7.tar.gz -C ${BASE}/cloudnetlotencode/php7/
    rm -rf ${BASE}/cloudnetlotencode/php7/php7.tar.gz
fi

if [ -f "${BASE}/cloudnetlotencode/phpbeast/encodeconf.tar.gz" ];then
    tar zxf ${BASE}/cloudnetlotencode/phpbeast/encodeconf.tar.gz -C ${BASE}/cloudnetlotencode/phpbeast/
    rm -rf ${BASE}/cloudnetlotencode/phpbeast/encodeconf.tar.gz
fi

echo "------------------------------清理cloudnetlotencode环境缓存--------------------------"
tmp1=`docker ps | grep cloudnetlotencode`

if [ ! -z "$tmp1" ];then
    docker stop cloudnetlotencode
    docker rm cloudnetlotencode
fi

tmp2=`docker ps -a | grep cloudnetlotencode`
if [ ! -z "$tmp2" ];then
    docker rm cloudnetlotencode
fi

tmp3=`docker images | grep cloudnetlotencode | awk '{print $3}'`
if [ ! -z "$tmp3" ];then
    docker rmi "$tmp3"
fi
echo "--------------------------------获取镜像----------------------------------------"
cd ${BASE}/soft
packagename=`ls | grep 'dockercloudnetlotencode*'`
if [ ! -z "$packagename" ];then
    docker load < ${BASE}/soft/${packagename}
    imagename="`docker images | grep cloudnetlotencode | awk '{print $1}'`:`docker images | grep cloudnetlotencode | awk '{print $2}'`"
else
    echo "please input cloudnetlotencode images:"
    read imagename
    docker pull ${imagename}
fi
echo "----------------------------------运行cloudnetlotencode容器--------------------------"
if [ "$2" = "true" ];then
    docker run --name cloudnetlotencode -v ${BASE}/cloudnetlotencode/php5:/etc/php/5.6 -v ${BASE}/cloudnetlotencode/php7:/etc/php/7.1 -v ${BASE}/cloudnetlotencode/phpbeast:/usr/local/php-beast-master/tools -v /etc/localtime:/etc/localtime:ro --restart=always -it -d ${imagename}
else
    docker run --name cloudnetlotencode -v /etc/localtime:/etc/localtime:ro --restart=always -it -d ${imagename}
fi
