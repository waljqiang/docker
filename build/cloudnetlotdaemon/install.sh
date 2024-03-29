#!/bin/bash
#sd安装脚本
set -e
pwd=`pwd`
php_version="7.1.20"
php_dir="/usr/local/php/${php_version}"
php_ini_dir="/etc/php/${php_version}/cli"
hiredis_version="0.13.3"
phpredis_version="3.1.6"
phpds_version="1.2.4"
phpinotify_version="2.0.0"
swoole_version="4.1.0"
sd_version="3.7.4"
swoole_configure="--enable-async-redis --enable-openssl --enable-coroutine"

command_exists() {
	command -v "$@" > /dev/null 2>&1
}

set_ldconf() {
    echo "include /etc/ld.so.conf.d/*.conf" | sudo tee /etc/ld.so.conf
    if ! [ -d "/etc/ld.so.conf.d" ] ;then
        mkdir /etc/ld.so.conf.d
    fi
    cd /etc/ld.so.conf.d
    echo "/usr/local/lib" | sudo tee /etc/ld.so.conf.d/libc.conf
    ldconfig -v
}

set_php() {
    init_file=`echo '<?php $command=$argv[1]??null;ob_start();phpinfo(INFO_GENERAL);$result=ob_get_contents();ob_clean();$ini_files="";$info=explode("\n\n",$result)[1];$info2=explode("\n",$info);foreach($info2 as $value){$info3=explode("=>",$value);if($info3[0]=="Scan this dir for additional .ini files "){$ini_files = trim($info3[1]);break;}}echo $ini_files;' | php`
}

do_install_ex() {
    php_m=`php -m`
    if ! [[ $php_m =~  "bcmath" ]] ; then
        echo "缺少必要bcmath扩展，请安装或者卸载php版本后重新运行本命令"
        exit
    fi
    if ! [[ $php_m =~  "mbstring" ]] ; then
        echo "缺少必要mbstring扩展，请安装或者卸载php版本后重新运行本命令"
        exit
    fi
    if ! [[ $php_m =~  "pdo_mysql" ]] ; then
        echo "缺少必要pdo_mysql扩展，请安装或者卸载php版本后重新运行本命令"
        exit
    fi
    if ! [[ $php_m =~  "posix" ]] ; then
        echo "缺少必要posix扩展，请安装或者卸载php版本后重新运行本命令"
        exit
    fi


    if ! [[ $php_m =~  "swoole" ]] ; then
        do_install_swoole
    fi

    if ! [[ $php_m =~  "redis" ]] ; then
        do_install_redis
    fi

    if ! [[ $php_m =~  "ds" ]] ; then
        do_install_ds
    fi

    if ! [[ $php_m =~  "inotify" ]] ; then
        do_install_inotify
    fi
}


do_install_inotify() {
    cd ${pwd};
    if [ ! -f "${phpinotify_version}.tar.gz" ] ;then
        echo "[inotify] 开始下载"
        wget https://github.com/arnaud-lb/php-inotify/archive/${phpinotify_version}.tar.gz
    fi

    if [ -d "php-inotify-${phpinotify_version}" ] ;then
        sudo rm -rf php-inotify-${phpinotify_version}
    fi
    tar -xzvf ${phpinotify_version}.tar.gz > /dev/null
    echo "[inotify] 开始编译"
    cd ${pwd}/php-inotify-${phpinotify_version}
    phpize
    ./configure
    make clean > /dev/null
    make -j
    sudo make install
    make clean > /dev/null
    echo "extension=inotify.so" | sudo tee ${init_file}/inotify.ini
    #sudo rm -f ${pwd}/${phpinotify_version}.tar.gz
    sudo rm -rf ${pwd}/php-inotify-${phpinotify_version}
}

do_install_ds() {
    cd ${pwd};
    if [ ! -f "v${phpds_version}.tar.gz" ] ;then
        echo "[ds] 开始下载"
        wget https://github.com/php-ds/extension/archive/v${phpds_version}.tar.gz
    fi

    if [ -d "ext-ds-${phpredis_version}" ] ;then
        sudo rm -rf ext-ds-${phpredis_version}
    fi
    tar -xzvf v${phpds_version}.tar.gz > /dev/null
    echo "[ds] 开始编译"
    cd ${pwd}/ext-ds-${phpds_version}
    phpize
    ./configure
    make clean > /dev/null
    make -j
    sudo make install
    make clean > /dev/null
    echo "extension=ds.so" | sudo tee ${init_file}/ds.ini
    #sudo rm -f ${pwd}/v${phpds_version}.tar.gz
    sudo rm -rf ${pwd}/ext-ds-${phpds_version}
}

do_install_redis() {
    cd ${pwd};
    if [ ! -f "${phpredis_version}.tar.gz" ] ;then
        echo "[redis] 开始下载"
        wget https://github.com/phpredis/phpredis/archive/${phpredis_version}.tar.gz
    fi
    
    if [ -d "redis-${phpredis_version}" ] ;then
          sudo rm -rf redis-${phpredis_version}
    fi
    tar -xzvf ${phpredis_version}.tar.gz > /dev/null
    echo "[redis] 开始编译"
    cd ${pwd}/phpredis-${phpredis_version}
    phpize
    ./configure
    make clean > /dev/null
    make -j
    sudo make install
    make clean > /dev/null
    echo "extension=redis.so" | sudo tee ${init_file}/redis.ini
    #sudo rm -f ${pwd}/${phpredis_version}.tar.gz
    sudo rm -rf ${pwd}/phpredis-${phpredis_version}
}

do_install_swoole() {
    cd ${pwd};
    if [ ! -f "v${swoole_version}.tar.gz" ] ;then
        echo "[swoole] 开始下载"
        wget https://github.com/swoole/swoole-src/archive/v${swoole_version}.tar.gz
    fi
    if [ ! -f "v${hiredis_version}.tar.gz" ] ;then
        echo "[hiredis] 开始下载"
        wget https://github.com/swoole/swoole-src/archive/v${swoole_version}.tar.gz https://github.com/redis/hiredis/archive/v${hiredis_version}.tar.gz
    fi

    if [ -d "swoole-src-${swoole_version}" ] ;then
        sudo rm -rf swoole-src-${swoole_version}
    fi
    if [ -d "hiredis-${hiredis_version}" ] ;then
        sudo rm -rf hiredis-${hiredis_version}
    fi
    tar -xzvf v${swoole_version}.tar.gz > /dev/null
    tar -xzvf v${hiredis_version}.tar.gz > /dev/null
    echo "[swoole] 开始编译"
    cd ${pwd}/hiredis-${hiredis_version}
    make clean > /dev/null
    make -j
    sudo make install
    make clean > /dev/null
    sudo ldconfig
    cd ${pwd}/swoole-src-${swoole_version}
    phpize
    ./configure ${swoole_configure}
    make clean > /dev/null
    make -j
    sudo make install
    make clean > /dev/null
    echo "extension=swoole.so" | sudo tee ${init_file}/swoole.ini
    #sudo rm -f ${pwd}/v${swoole_version}.tar.gz
    #sudo rm -f ${pwd}/v${hiredis_version}.tar.gz
    sudo rm -rf ${pwd}/swoole-src-${swoole_version}
    sudo rm -rf ${pwd}/hiredis-${hiredis_version}
}

install_wget()
{
    if command_exists apt ; then
        sudo apt install wget
    fi
}

install_php()
{
    cd ${pwd};
    if command_exists apt ; then
        sudo apt-get install -y --no-install-recommends \
        wget \
        gcc \
        make \
        autoconf \
		libcurl4-openssl-dev \
		libedit-dev \
		libsqlite3-dev \
		libssl-dev \
		libxml2-dev \
		zlib1g-dev \
        libbz2-dev \
        libgdbm-dev \
        libmcrypt-dev \
        libxslt-dev \
        libgd2-xpm-dev \
        libgeoip-dev \
		libpcre3 \
		libpcre3-dev\
		unzip\
		build-essential\
		g++ 	
    fi

    if ! [ -f "/usr/lib/libssl.so" ] ;then
        openssl_dir=`find / -name libssl.so | head -n 1`
        sudo ln -s ${openssl_dir} /usr/lib
    fi

    echo "[php] 开始下载"
    if [ -f "php-${php_version}.tar.gz" ] ;then
          #sudo rm -f php-${php_version}.tar.gz
	echo "文件已存在"
    else
    	wget -O php-${php_version}.tar.gz https://secure.php.net/get/php-${php_version}.tar.gz/from/this/mirror
    	if [ -d "php-${php_version}" ] ;then
            sudo rm -rf php-${php_version}
    	fi
    fi

    tar -xzvf php-${php_version}.tar.gz > /dev/null
    echo "[php] 开始编译"
    cd ${pwd}/php-${php_version}
    ./configure --prefix=${php_dir} \
    --with-config-file-path=${php_ini_dir} \
	--with-config-file-scan-dir="${php_ini_dir}/conf.d" \
    --enable-fpm \
    --enable-bcmath \
    --enable-mbstring \
    --enable-mysqlnd \
    --enable-opcache \
    --enable-pcntl \
    --enable-xml \
    --enable-zip \
    --with-curl \
    --with-libedit \
    --with-openssl \
    --with-zlib \
    --with-mysqli \
    --with-pdo-mysql \
    --with-pear \
    --with-bz2 \
    --enable-calendar \
    --enable-dba \
    --enable-exif \
    --with-png-dir \
    --with-freetype-dir \
    --with-jpeg-dir \
    --with-gd \
    --enable-gd-native-ttf \
    --with-gettext \
    --with-mcrypt \
    --enable-shmop \
    --enable-sockets \
    --enable-sysvmsg \
    --enable-sysvshm \
    --enable-wddx \
    --enable-sysvsem \
    --enable-soap
    make clean > /dev/null
    make -j
    set +e
    sudo make install
    make clean > /dev/null
    set -e
    ln -s ${php_dir}/bin/php /usr/local/bin/
    ln -s ${php_dir}/bin/phpize /usr/local/bin/
    ln -s ${php_dir}/bin/pecl /usr/local/bin/
    ln -s ${php_dir}/bin/php-config /usr/local/bin/
    sudo mkdir -p ${php_ini_dir}/conf.d
    cp ${pwd}/php-${php_version}/php.ini-production ${php_ini_dir}/php.ini
    echo -e "opcache.enable=1\nopcache.enable_cli=1\nzend_extension=opcache.so" | sudo tee ${php_ini_dir}/conf.d/10-opcache.ini
    #sudo rm -f ${pwd}/php-${php_version}.tar.gz
    sudo rm -rf ${pwd}/php-${php_version}
}

do_install_sd(){
    echo "[SD] 开始安装"
    if [ ! -d "$sd_dir" ];then
        mkdir $sd_dir
    fi
    cd ${sd_dir}
    if [ ! -f "$sd_dir/composer.json" ];then
        echo "
        {
            \"require\": {
                \"tmtbe/swooledistributed\":\"=${sd_version}\"
            },
            \"autoload\": {
                \"psr-4\": {
                    \"app\\\\\": \"src/app\",
                    \"test\\\\\": \"src/test\"
                }
            }
        }" > composer.json
    fi
    composer update
    php vendor/tmtbe/swooledistributed/src/Install.php -y
    echo "框架安装完毕,项目目录：$sd_dir"
}

do_install_composer(){
    if ! command_exists composer ; then
        cd ${pwd}
        if [ ! -f composer.phar ];then
            echo "[composer] 开始下载"
            curl -sS https://getcomposer.org/installer | php
            sudo mv composer.phar /usr/local/bin/composer
        fi
    fi
    composer config -g repo.packagist composer https://packagist.laravel-china.org
}

do_install(){
    set_ldconf
    if ! command_exists php ; then
        install_php
    fi
    if ! command_exists wget ; then
        install_wget
    fi
    php_version=`php -v`
    if ! [[ "$php_version" =~  "PHP 7" ]] ; then
        echo "PHP版本不对，请卸载php后重新运行此命令"
    fi
    set_php
    do_install_ex
    do_install_composer
    #do_install_sd
}

if command_exists apt ; then
    if ! command_exists sudo ; then
        set +e
        apt update
        set -e
        apt-get install -y sudo
    else
        set +e
        sudo apt update
        set -e
    fi
fi

do_install
