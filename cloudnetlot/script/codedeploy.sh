#!/bin/bash
root_path="/usr/local/cloudnetlot/www"
cloudnetlot=`find $root_path -name 'cloudnetlot-*.tar.gz'`
cloudnetlotdaemon=`find $root_path -name 'cloudnetlotdaemon-*.tar.gz'`
cloudnetlotjava=`find $root_path -name 'cloudnetlotjava-*.tar.gz'`

if [ ! -z "$cloudnetlot" ];then
    echo "************************部署云平台代码***************************"
    if [ ! -d $root_path/cloudnetlot ];then
	mkdir $root_path/cloudnetlot
    fi
    tar zxf $cloudnetlot -C $root_path/cloudnetlot
    chown -R www-data:www-data $root_path/cloudnetlot
    chmod -R 755 $root_path/cloudnetlot
    rm -f $cloudnetlot
    /usr/local/cloudnetlot/script/dockerserver restart cloudnetlotserver
    docker exec -it cloudnetlotserver /bin/bash -c 'cd /usr/local/www/cloudnetlot/backend && php artisan migrate'
    docker exec -it cloudnetlotserver /bin/bash -c 'cd /usr/local/www/cloudnetlot/backend && php artisan db:seed'
fi

if [ ! -z "$cloudnetlotdaemon" ];then
    echo "************************部署云平台服务层代码**********************"
    if [ ! -d $root_path/cloudnetlotdaemon ];then
	mkdir $root_path/cloudnetlotdaemon
    fi
    tar zxf $cloudnetlotdaemon -C $root_path/cloudnetlotdaemon
    chown -R www-data:www-data $root_path/cloudnetlotdaemon
    chmod -R 755 $root_path/cloudnetlotdaemon
    rm -f $cloudnetlotdaemon
    /usr/local/cloudnetlot/script/dockerserver restart cloudnetlotdaemon
fi

if [ ! -z "$cloudnetlotjava" ];then
    echo "**********************部署云平台服务层java服务代码******************"
    if [ ! -d $root_path/service_Subscriber ];then
	mkdir $root_path/service_Subscriber
    fi
    tar zxf $cloudnetlotjava -C $root_path/service_Subscriber
    rm -f $cloudnetlotjava
    /usr/local/cloudnetlot/script/dockerserver restart cloudnetlotjava
    docker exec -it cloudnetlotjava /bin/bash -c '/etc/init.d/java_server start'
fi

echo "SUCCESS"
