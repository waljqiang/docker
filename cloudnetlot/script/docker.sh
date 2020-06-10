#!/bin/bash
BASE="/usr/local/cloudnetlot"
startServer(){
    tmp=`docker ps |grep "$1"`
    if [ ! -z "$tmp" ];then
	echo "$1 is already running"
    else
	tmp=`docker ps -a | grep "$1"`
	if [ ! -z "$tmp" ];then
	    if [[ "$1" = "cloudnetlotdaemon" ]] && [[ -f "$2/www/cloudnetlotdaemon/bin/start_swoole_server.php" ]];then
		docker start $1 && docker exec -it cloudnetlotdaemon /bin/bash -c "php /usr/local/www/cloudnetlotdaemon/bin/start_swoole_server.php start -d"
	    else
	        docker start $1
	    fi
	else
	    echo "container $1 is not exists"
	fi
    fi
}

restartServer(){
    tmp=`docker ps -a |grep "$1"`
    if [ ! -z "$tmp" ];then
	tmp=`docker ps | grep "$1"`
	if [ ! -z "$tmp" ];then
	    if [[ "$1" == "cloudnetlotdaemon" ]] && [[ -f "$2/www/cloudnetlotdaemon/bin/start_swoole_server.php" ]];then
		docker restart $1 && docker exec -it cloudnetlotdaemon /bin/bash -c "php /usr/local/www/cloudnetlotdaemon/bin/start_swoole_server.php start -d"
	    else
	        docker restart $1
	    fi
	else
	    echo "$1 is not running"
	fi
    else
	echo "container $1 is not exists"
    fi
}

stopServer(){
    tmp=`docker ps -a |grep "$1"`
    if [ ! -z "$tmp" ];then
        tmp=`docker ps | grep "$1"`
        if [ ! -z "$tmp" ];then
            docker stop $1
        else
            echo "$1 is not running"
        fi
    else
        echo "container $1 is not exists"
    fi
}

if [[ "$1" != "start" ]] && [[ "$1" != "stop" ]] && [[ "$1" != "restart" ]];then
    echo "Please use start or stop or restart as first argument"
    exit
fi

SERVER=("$2" "$3" "$4" "$5" "$6" "$7")

case "$1" in
    start)
	if [[ "${SERVER[@]}" =~ "cloudnetlotdata" ]];then
            startServer "cloudnetlotdata"
	elif [[ "${SERVER[@]}" =~ "cloudnetlotdaemon" ]];then
	    startServer "cloudnetlotdaemon" "${BASE}"
	elif [[ "${SERVER[@]}" =~ "cloudnetlotvsftpd" ]];then
	    startServer "cloudnetlotvsftpd"
	elif [[ "${SERVER[@]}" =~ "cloudnetlotserver" ]];then
	    startServer "cloudnetlotserver"
	elif [[ "${SERVER[@]}" =~ "cloudnetlotencode" ]];then
	    startServer "cloudnetlotencode"
	else
	    startServer "cloudnetlotdata"
	    sleep 1
	    startServer "cloudnetlotdaemon" "${BASE}"
	    startServer "cloudnetlotvsftpd"
	    startServer "cloudnetlotserver"
	    startServer "cloudnetlotencode"
	fi
        ;;
    restart)
	if [[ "${SERVER[@]}" =~ "cloudnetlotdata" ]];then
	    restartServer "cloudnetlotdata"
	elif [[ "${SERVER[@]}" =~ "cloudnetlotdaemon" ]];then
            restartServer "cloudnetlotdaemon" "${BASE}"
        elif [[ "${SERVER[@]}" =~ "cloudnetlotvsftpd" ]];then
            restartServer "cloudnetlotvsftpd" 
        elif [[ "${SERVER[@]}" =~ "cloudnetlotserver" ]];then
            restartServer "cloudnetlotserver"
        elif [[ "${SERVER[@]}" =~ "cloudnetlotencode" ]];then
            restartServer "cloudnetlotencode"
	else
	    restartServer "cloudnetlotdata"
	    sleep 1
            restartServer "cloudnetlotdaemon" "${BASE}"
            restartServer "cloudnetlotvsftpd"
            restartServer "cloudnetlotserver"
            restartServer "cloudnetlotencode"
	fi
        ;;
    stop)
        if [[ "${SERVER[@]}" =~ "cloudnetlotdata" ]];then
            stopServer "cloudnetlotdata"
        elif [[ "${SERVER[@]}" =~ "cloudnetlotdaemon" ]];then
            stopServer "cloudnetlotdaemon"
        elif [[ "${SERVER[@]}" =~ "cloudnetlotvsftpd" ]];then
            stopServer "cloudnetlotvsftpd"
        elif [[ "${SERVER[@]}" =~ "cloudnetlotserver" ]];then
            stopServer "cloudnetlotserver"
        elif [[ "${SERVER[@]}" =~ "cloudnetlotencode" ]];then
            stopServer "cloudnetlotencode"
        else
            stopServer "cloudnetlotdata"
            stopServer "cloudnetlotdaemon"
            stopServer "cloudnetlotvsftpd"
            stopServer "cloudnetlotserver"
            stopServer "cloudnetlotencode"
        fi
	;;
    *)
	echo "Please use start or stop or restart as first argument"
	;;
esac
