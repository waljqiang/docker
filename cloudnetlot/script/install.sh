#!/bin/bash
#$1->主机ip
if [ -z "$1" ];then
    echo 'use host ip for first params'
    exit
fi

if [ -z "$2" ];then
    echo 'server name must be'
    exit
fi

BASE="/usr/local/cloudnetlot"
BIN_PATH=${BASE}/script
HOST="$1"

dos2unix -V
if [ $? -eq 0 ];then
    echo 'dos2unix已经安装'
else
    echo '安装dos2unix环境'
    apt-get install dos2unix > /dev/null
fi

echo '-----------------安装docker---------------------'
${BIN_PATH}/dockerinstall.sh

echo '-----------------部署环境-----------------------'
${BIN_PATH}/dockerdeploy.sh "$1" "$2" "$3" "$4" "$5" "$6" "$7"
