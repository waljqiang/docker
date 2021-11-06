#!/bin/bash
#$1->主机ip
if [ -z "$1" ];then
    echo 'use host ip for first params'
    exit
fi
BASE="/usr/local/cloudnetlot"
BIN_PATH=${BASE}/script
HOST="$1"
echo "------------------------------部署cloudnetlotjava环境-----------------------------"
echo "------------------------------清理cloudnetlotjava环境缓存--------------------------"
tmp1=`docker ps | grep cloudnetlotjava`

if [ ! -z "$tmp1" ];then
    docker stop cloudnetlotjava
    docker rm cloudnetlotjava
fi

tmp2=`docker ps -a | grep cloudnetlotjava`
if [ ! -z "$tmp2" ];then
    docker rm cloudnetlotjava
fi

tmp3=`docker images | grep cloudnetlotjava | awk '{print $3}'`
if [ ! -z "$tmp3" ];then
    docker rmi "$tmp3"
fi
echo "--------------------------------获取镜像----------------------------------------"
cd ${BASE}/soft
packagename=`ls | grep 'dockercloudnetlotjava*'`
if [ ! -z "$packagename" ];then
    docker load < ${BASE}/soft/${packagename}
    imagename="`docker images | grep cloudnetlotjava | awk '{print $1}'`:`docker images | grep cloudnetlotjava | awk '{print $2}'`"
else
    echo "please input cloudnetlotjava images:"
    read imagename
    docker pull ${imagename}
fi
echo "----------------------------------运行cloudnetlotjava容器--------------------------"

if [ "$2" = "true" ];then
    docker run --name cloudnetlotjava -v ${BASE}/www/service_Subscriber:/usr/local/cloudnetlot/www/service_Subscriber -v /etc/localtime:/etc/localtime:ro --restart=no -it -d ${imagename}
else
    docker run --name cloudnetlotjava -v ${BASE}/www/service_Subscriber:/usr/local/cloudnetlot/www/service_Subscriber -v /etc/localtime:/etc/localtime:ro --restart=no -it -d ${imagename}
fi
