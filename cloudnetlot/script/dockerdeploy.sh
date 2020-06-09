#!/bin/bash
#$1->主机ip
if [ -z "$1" ];then
    echo 'use host ip for first params'
    exit
fi

BASE="/usr/local/cloudnetlot"
BIN_PATH=${BASE}/script
HOST="$1"

SERVER=("$2" "$3" "$4" "$5" "$6" "$7")

if [[ "${SERVER[@]}" =~ "configmap" ]];then
    CONFIGMAP=true
else
    CONFIGMAP=false
fi

#yuncoredata
if [[ "${SERVER[@]}" =~ "cloudnetlotdata" ]];then
    ${BIN_PATH}/cloudnetlotdatadeploy.sh "$1" "$CONFIGMAP"
fi
#yuncoredaemon
if [[ "${SERVER[@]}" =~ "cloudnetlotdaemon" ]];then
    ${BIN_PATH}/cloudnetlotdaemondeploy.sh "$1" "$CONFIGMAP"
fi
#yuncorevsftpd
if [[ "${SERVER[@]}" =~ "cloudnetlotvsftpd" ]];then
    ${BIN_PATH}/cloudnetlotvsftpddeploy.sh "$1" "$CONFIGMAP"
fi
#yuncoreserver
if [[ "${SERVER[@]}" =~ "cloudnetlotserver" ]];then
    ${BIN_PATH}/cloudnetlotserverdeploy.sh "$1" "$CONFIGMAP"
fi
#yuncoreencode
if [[ "${SERVER[@]}" =~ "cloudnetlotencode" ]];then
    ${BIN_PATH}/cloudnetlotencodedeploy.sh "$1" "$CONFIGMAP"
fi
