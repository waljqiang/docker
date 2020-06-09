#!/bin/bash
#$1->主机ip
if [ -z "$1" ];then
    echo 'use host ip for first params'
    exit
fi

BASE="/usr/local/cloudnetlot"
BIN_PATH=${BASE}/script
HOST="$1"
echo "------------------------------部署cloudnetlotvsftpd环境-----------------------------"
if [ -f "${BASE}/cloudnetlotvsftpd/vsftpdconf.tar.gz" ];then
    tar zxf ${BASE}/cloudnetlotvsftpd/vsftpdconf.tar.gz -C ${BASE}/cloudnetlotvsftpd/
    rm -rf ${BASE}/cloudnetlotvsftpd/vsftpdconf.tar.gz
fi
echo "------------------------------清理cloudnetlotvsftpd环境缓存--------------------------"
tmp1=`docker ps | grep cloudnetlotvsftpd`

if [ ! -z "$tmp1" ];then
    docker stop cloudnetlotvsftpd
    docker rm cloudnetlotvsftpd
fi

tmp2=`docker ps -a | grep cloudnetlotvsftpd`
if [ ! -z "$tmp2" ];then
    docker rm cloudnetlotvsftpd
fi

tmp3=`docker images | grep cloudnetlotvsftpd | awk '{print $3}'`
if [ ! -z "$tmp3" ];then
    docker rmi "$tmp3"
fi
echo "--------------------------------获取镜像----------------------------------------"
cd ${BASE}/soft
packagename=`ls | grep 'dockercloudnetlotvsftpd*'`
if [ ! -z "$packagename" ];then
    docker load < ${BASE}/soft/${packagename}
    imagename="`docker images | grep cloudnetlotvsftpd | awk '{print $1}'`:`docker images | grep cloudnetlotvsftpd | awk '{print $2}'`"
else
    echo "please input cloudnetlotvsftpd images:"
    read imagename
    docker pull ${imagename}
fi
echo "----------------------------------运行cloudnetlotvsftpd容器--------------------------"
if [ ! -d "/home/vsftpd" ];then
    mkdir -p /home/vsftpd
fi
egrep "^ftpgroups" /etc/group >& /dev/null
if [ $? -ne 0 ];then
    groupadd ftpgroups
fi
egrep "^ftpuser" /etc/passwd >& /dev/null
if [ $? -ne 0 ];then
    useradd -d /home/vsftpd/ftpuser -g ftpgroups ftpuser
fi
echo '123456' | passwd ftpuser --stdin  &>/dev/null

if [ "$2" = "true" ];then
    docker run -d --name cloudnetlotvsftpd -p 20:20 -p 21:21 -p 21100-21110:21100-21110 -v /home/vsftpd:/home/vsftpd -v ${BASE}/cloudnetlotvsftpd:/etc/vsftpd -v /etc/localtime:/etc/localtime:ro -e FTP_USER=ftpuser -e FTP_PASS=123456 -e PASV_ADDRESS=$1 -e PASV_MIN_PORT=21100 -e PASV_MAX_PORT=21110  --restart=always ${imagename}
else
    docker run -d --name cloudnetlotvsftpd -p 20:20 -p 21:21 -p 21100-21110:21100-21110 -v /home/vsftpd:/home/vsftpd -v /etc/localtime:/etc/localtime:ro -e FTP_USER=ftpuser -e FTP_PASS=123456 -e PASV_ADDRESS=$1 -e PASV_MIN_PORT=21100 -e PASV_MAX_PORT=21110  --restart=always ${imagename}
fi
