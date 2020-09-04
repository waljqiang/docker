# cloudnetlotencode environment
# version 5.0.0
#author waljqiang<waljqiang@163.com>

#base image to use ubuntu:14.04
FROM ubuntu:14.04
MAINTAINER waljqiang <waljqiang@163.com>

WORKDIR /usr/local/docker

ENV LANG C.UTF-8

ADD ./php5.6.38/php-5.6.38.tar.gz ./php5/
COPY ./php5.6.38/php-fpm ./php5/
COPY ./php5.6.38/php-fpm.conf ./php5/
COPY ./php5.6.38/www.conf ./php5/
ADD ./php5.6.38/php-beast-master.tar.gz ../
ADD ./php7.1.20/php-7.1.20.tar.gz ./php7/
COPY ./php7.1.20/php-fpm ./php7/
COPY ./php7.1.20/php-fpm.conf ./php7/
COPY ./php7.1.20/www.conf ./php7/
ADD ./encode/encodeconf.tar.gz ./encode/

#vim
RUN apt-get update \
	&& apt-get install -y --no-install-recommends vim wget gcc make autoconf libcurl4-openssl-dev libedit-dev libsqlite3-dev libssl-dev libxml2-dev libbz2-dev libgdbm-dev libmcrypt-dev libxslt-dev libgd2-xpm-dev libgeoip-dev zlib1g-dev libpcre3 libpcre3-dev unzip build-essential g++

#php5.6.38 config
RUN echo "include /etc/ld.so.conf.d/*.conf" | sudo tee /etc/ld.so.conf \
	&& cd /etc/ld.so.conf.d \
	&& sudo ln -s `find / -name libssl.so | head -n 1` /usr/lib \
	&& echo "/usr/local/lib" | sudo tee /etc/ld.so.conf.d/libc.conf \
	&& cd /usr/local/docker/php5/php-5.6.38 \
	&& mkdir -p /etc/php/5.6/fpm/conf.d \
	&& mkdir -p /etc/php/5.6/fpm/pool.d \
	&& mkdir -p /etc/php/5.6/mods-available \
	&& mkdir -p /var/log/php \
	&& ./configure --prefix=/usr/local/php/5.6 --with-config-file-path=/etc/php/5.6 --with-config-file-scan-dir="/etc/php/5.6/mods-available" --enable-fpm --enable-bcmath --with-bz2 --enable-calendar --enable-dba --enable-exif --enable-ftp --with-png-dir --with-freetype-dir --with-jpeg-dir --with-gd --enable-gd-native-ttf --with-gettext --with-mcrypt --with-mysql --with-openssl --enable-shmop --enable-sockets --enable-sysvmsg --enable-sysvshm --enable-wddx --enable-sysvsem --enable-soap --enable-mbstring --enable-mysqlnd --enable-opcache --enable-pcntl --enable-xml --enable-zip --with-curl --with-libedit --with-mysqli --with-pdo-mysql --with-pear --with-zlib \
	&& make \
	&& make install \
	&& make clean \
	&& cp /usr/local/docker/php5/php-5.6.38/php.ini-production /etc/php/5.6/php.ini \
	&& ln -s /etc/php/5.6/php.ini /etc/php/5.6/fpm/php.ini \
	&& cp /usr/local/docker/php5/php-fpm.conf /etc/php/5.6/fpm/ \
	&& cp /usr/local/docker/php5/www.conf /etc/php/5.6/fpm/pool.d/ \
	&& echo -e "opcache.enable=1\nopcache.enable_cli=1\nzend_extension=opcache.so" | sudo tee /etc/php/5.6/mods-available/10-opcache.ini \
	&& cp /usr/local/docker/php5/php-fpm /etc/init.d/php5.6-fpm \
	&& chmod +x /etc/init.d/php5.6-fpm \
	&& update-rc.d php5.6-fpm defaults \
	&& cd /usr/local/php-beast-master \
	&& /usr/local/php/5.6/bin/phpize \
	&& ./configure --with-php-config=/usr/local/php/5.6/bin/php-config \
	&& make \
	&& make install \
	&& make clean \
	&& echo -e "; configuration for php beast module\n; priority=10\nbeast.log_file=/var/log/php/php5-beast.log\nbeast.log_level=ERROR\nextension=beast.so" | sudo tee /etc/php/5.6/mods-available/20-beast.ini 

#php7.1.20 config
RUN cd /usr/local/docker/php7/php-7.1.20 \
	&& mkdir -p /etc/php/7.1/fpm/conf.d \
	&& mkdir -p /etc/php/7.1/fpm/pool.d \
	&& mkdir -p /etc/php/7.1/mods-available \
	&& ./configure --prefix=/usr/local/php/7.1 --with-config-file-path=/etc/php/7.1 --with-config-file-scan-dir="/etc/php/7.1/mods-available" --enable-fpm --enable-bcmath --enable-mbstring --enable-mysqlnd --enable-opcache --enable-pcntl --enable-xml --enable-zip --with-curl --with-libedit --with-openssl --with-zlib --with-mysqli --with-pdo-mysql --with-pear --with-bz2 --enable-calendar --enable-dba --enable-exif --with-png-dir --with-freetype-dir --with-jpeg-dir --with-gd --enable-gd-native-ttf --with-gettext --with-mcrypt --enable-shmop --enable-sockets --enable-sysvmsg --enable-sysvshm --enable-wddx --enable-sysvsem --enable-soap \
	&& make \
	&& make install \
	&& make clean \
	&& cp /usr/local/docker/php7/php-7.1.20/php.ini-production /etc/php/7.1/php.ini \
	&& ln -s /etc/php/7.1/php.ini /etc/php/7.1/fpm/php.ini \
	&& cp /usr/local/docker/php7/php-fpm.conf /etc/php/7.1/fpm/ \
	&& cp /usr/local/docker/php7/www.conf /etc/php/7.1/fpm/pool.d/ \
	&& echo -e "opcache.enable=1\nopcache.enable_cli=1\nzend_extension=opcache.so" | sudo tee /etc/php/7.1/mods-available/10-opcache.ini \
	&& cp /usr/local/docker/php7/php-fpm /etc/init.d/php7.1-fpm \
	&& chmod +x /etc/init.d/php7.1-fpm \
	&& update-rc.d php7.1-fpm defaults \
	&& cd /usr/local/php-beast-master \
	&& /usr/local/php/7.1/bin/phpize \
	&& ./configure --with-php-config=/usr/local/php/7.1/bin/php-config \
	&& make \
	&& make install \
	&& make clean \
	&& echo -e "; configuration for php beast module\n; priority=10\nbeast.log_file=/var/log/php/php7-beast.log\nbeast.log_level=ERROR\nextension=beast.so" | sudo tee /etc/php/7.1/mods-available/20-beast.ini
#encode config
RUN cp -rp ./encode/* /usr/local/php-beast-master/tools/
#clear
RUN rm -rf /usr/local/docker \
    && rm -rf /var/lib/apt/list/* \
    && apt-get autoclean -y \
    && apt-get clean -y \
    && apt-get autoremove -y

WORKDIR /usr/local

EXPOSE 80
