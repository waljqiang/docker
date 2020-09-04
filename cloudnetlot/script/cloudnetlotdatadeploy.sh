#!/bin/bash
#$1->主机ip
if [ -z "$1" ];then
    echo 'use host ip for first params'
    exit
fi

BASE="/usr/local/cloudnetlot"
BIN_PATH=${BASE}/script
HOST="$1"
echo "------------------------------部署cloudnetlotdata环境-----------------------------"
if [ -f "${BASE}/cloudnetlotdata/mysql/conf/mysqlconf.tar.gz" ];then
    tar zxf ${BASE}/cloudnetlotdata/mysql/conf/mysqlconf.tar.gz -C ${BASE}/cloudnetlotdata/mysql/conf/
    rm -rf ${BASE}/cloudnetlotdata/mysql/conf/mysqlconf.tar.gz
fi
if [ -f "${BASE}/cloudnetlotdata/mysql/data/mysqldata.tar.gz" ];then
    tar zxf ${BASE}/cloudnetlotdata/mysql/data/mysqldata.tar.gz -C ${BASE}/cloudnetlotdata/mysql/data/
    rm -rf ${BASE}/cloudnetlotdata/mysql/data/mysqldata.tar.gz
fi
if [ -f "${BASE}/cloudnetlotdata/emqx/emqxconf.tar.gz" ];then
    tar zxf ${BASE}/cloudnetlotdata/emqx/emqxconf.tar.gz -C ${BASE}/cloudnetlotdata/emqx/
    rm -rf ${BASE}/cloudnetlotdata/emqx/emqxconf.tar.gz
fi
echo "------------------------------清理cloudnetlotdata环境缓存--------------------------"
tmp1=`docker ps | grep cloudnetlotdata`

if [ ! -z "$tmp1" ];then
    docker stop cloudnetlotdata
    docker rm cloudnetlotdata
fi

tmp2=`docker ps -a | grep cloudnetlotdata`
if [ ! -z "$tmp2" ];then
    docker rm cloudnetlotdata
fi

tmp3=`docker images | grep cloudnetlotdata | awk '{print $3}'`
if [ ! -z "$tmp3" ];then
    docker rmi "$tmp3"
fi
echo "--------------------------------获取镜像----------------------------------------"
cd ${BASE}/soft
packagename=`ls | grep 'dockercloudnetlotdata*'`
if [ ! -z "$packagename" ];then
    docker load < ${BASE}/soft/${packagename}
    imagename="`docker images | grep cloudnetlotdata | awk '{print $1}'`:`docker images | grep cloudnetlotdata | awk '{print $2}'`"
else
    echo "please input cloudnetlotdata images:"
    read imagename
    docker pull ${imagename}
fi
echo "----------------------------------运行cloudnetlotdata容器--------------------------"
echo ${imagename}
if [ "$2" = "true" ];then
    docker run --name cloudnetlotdata -p 9094:3306 -p 9095:6379 -p 9096:1883 -p 9097:8084 -p 9098:8083 -p 9099:18083 -v ${BASE}/cloudnetlotdata/mysql/conf:/etc/mysql -v ${BASE}/cloudnetlotdata/mysql/data:/var/lib/mysql -v ${BASE}/cloudnetlotdata/redis/:/etc/redis -v ${BASE}/cloudnetlotdata/emqx:/etc/emqx -v /etc/localtime:/etc/localtime:ro --restart=no -it -d ${imagename} && docker exec -it cloudnetlotdata /bin/bash -c 'sleep 20 && emqx_ctl admins passwd admin 123456 && emqx_ctl plugins reload emqx_auth_mysql'
else
    docker run --name cloudnetlotdata -p 9094:3306 -p 9095:6379 -p 9096:1883 -p 9097:8084 -p 9098:8083 -p 9099:18083 -v ${BASE}/cloudnetlotdata/mysql/data:/var/lib/mysql -v /etc/localtime:/etc/localtime:ro --restart=no -it -d ${imagename} && docker exec -it cloudnetlotdata /bin/bash -c 'sleep 20 && emqx_ctl admins passwd admin 123456 && emqx_ctl plugins reload emqx_auth_mysql'
fi
