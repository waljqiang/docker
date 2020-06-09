#!/bin/bash
echo '检测Docker......'
docker -v

if [ $? -eq 0 ];then
    echo 'docker已经安装'
else
    echo '安装docker环境'
    curl -sSL https://get.daocloud.io/docker | sh
    cp -p ./daemon.json /etc/docker/daemon.json
fi
