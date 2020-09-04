# cloudnetlotserver environment
# version 2.0.0
#author waljqiang<waljqiang@163.com>

#base image to use ubuntu:14.04
FROM ubuntu:14.04
MAINTAINER waljqiang <waljqiang@163.com>

WORKDIR /usr/local/docker

ENV LANG C.UTF-8

ADD ./nginx/nginx-1.6.2.tar.gz ./
COPY ./nginx/nginx.conf ./nginx.conf
COPY ./nginx/default.conf ./default.conf
COPY ./nginx/cloudnetlot.conf ./cloudnetlot.conf
COPY ./nginx/cloudnetlotbackend.conf ./cloudnetlotbackend.conf
COPY ./nginx/nginx ./nginx
ADD ./php/php-5.6.38.tar.gz ./
COPY ./php/php-fpm ./
COPY ./php/php-fpm.conf ./
COPY ./php/www.conf ./
COPY ./php/php.ini ./
ADD ./php/php-beast-master.tar.gz ./
ADD ./php/redis-2.2.8.tgz ./
COPY ./script/supervisord.conf /usr/local/
COPY ./script/startcloudnetlotserver.sh /usr/local/

#vim
RUN apt-get update \
	&& apt-get install -y --no-install-recommends vim wget gcc make autoconf libcurl4-openssl-dev libedit-dev libsqlite3-dev libssl-dev libxml2-dev libbz2-dev libgdbm-dev libmcrypt-dev libxslt-dev libgd2-xpm-dev libgeoip-dev zlib1g-dev libpcre3 libpcre3-dev unzip build-essential g++ supervisor

#nginx config
RUN cd ./nginx-1.6.2 \
	&& ./configure --prefix=/usr/share/nginx --conf-path=/etc/nginx/nginx.conf --http-log-path=/var/log/nginx/access.log --error-log-path=/var/log/nginx/error.log --lock-path=/var/lock/nginx.lock --pid-path=/run/nginx.pid --user=www-data --group=www-data --http-client-body-temp-path=/var/lib/nginx/body --http-fastcgi-temp-path=/var/lib/nginx/fastcgi --http-proxy-temp-path=/var/lib/nginx/proxy --http-scgi-temp-path=/var/lib/nginx/scgi --http-uwsgi-temp-path=/var/lib/nginx/uwsgi --with-debug --with-pcre-jit --with-ipv6 --with-http_ssl_module --with-http_stub_status_module --with-http_realip_module --with-http_auth_request_module --with-http_addition_module --with-http_dav_module --with-http_geoip_module --with-http_gzip_static_module --with-http_image_filter_module --with-http_spdy_module --with-http_sub_module --with-http_xslt_module --with-mail --with-mail_ssl_module \
	&& make \
	&& make install \
	&& make clean \
	&& mkdir -p /var/cache/nginx/temp \
	&& mkdir -p /var/lib/nginx/body \
	&& cd /etc/nginx \
	&& mkdir conf.d \
	&& mkdir cloudnetlot.conf \
	&& cp /usr/local/docker/nginx.conf /etc/nginx/ \
	&& cp /usr/local/docker/default.conf /etc/nginx/conf.d/ \
	&& cp /usr/local/docker/cloudnetlot.conf /etc/nginx/cloudnetlot.conf/ \
	&& cp /usr/local/docker/cloudnetlotbackend.conf /etc/nginx/cloudnetlot.conf/ \
	&& ln -s /usr/share/nginx/sbin/nginx /usr/sbin/nginx \
	&& cp /usr/local/docker/nginx /etc/init.d/nginx \
	&& chmod a+x /etc/init.d/nginx \
	&&  update-rc.d nginx defaults 

#php config
RUN echo "include /etc/ld.so.conf.d/*.conf" | sudo tee /etc/ld.so.conf \
	&& cd /etc/ld.so.conf.d \
	&& sudo ln -s `find / -name libssl.so | head -n 1` /usr/lib \
	&& echo "/usr/local/lib" | sudo tee /etc/ld.so.conf.d/libc.conf \
	&& cd /usr/local/docker/php-5.6.38 \
	&& mkdir -p /etc/php/5.6/fpm/conf.d \
	&& mkdir -p /etc/php/5.6/fpm/pool.d \
	&& mkdir -p /etc/php/5.6/mods-available \
	&& mkdir -p /var/log/php \
	&& ./configure --prefix=/usr/local/php/5.6 --with-config-file-path=/etc/php/5.6 --with-config-file-scan-dir="/etc/php/5.6/mods-available" --enable-fpm --enable-bcmath --with-bz2 --enable-calendar --enable-dba --enable-exif --enable-ftp --with-png-dir --with-freetype-dir --with-jpeg-dir --with-gd --enable-gd-native-ttf --with-gettext --with-mcrypt --with-mysql --with-openssl --enable-shmop --enable-sockets --enable-sysvmsg --enable-sysvshm --enable-wddx --enable-sysvsem --enable-soap --enable-mbstring --enable-mysqlnd --enable-opcache --enable-pcntl --enable-xml --enable-zip --with-curl --with-libedit --with-mysqli --with-pdo-mysql --with-pear --with-zlib \
	&& make \
	&& make install \
	&& make clean \
	&& ln -s /usr/local/php/5.6/bin/php /usr/local/bin/ \
	&& ln -s /usr/local/php/5.6/bin/phpize /usr/local/bin/ \
	&& ln -s /usr/local/php/5.6/bin/php-config /usr/local/bin/ \
	&& ln -s /usr/local/php/5.6/bin/pecl /usr/local/bin/ \
	&& ln -s /usr/local/php/5.6/bin/php-config /us \
	&& cp /usr/local/docker/php.ini /etc/php/5.6/php.ini \
	&& ln -s /etc/php/5.6/php.ini /etc/php/5.6/fpm/php.ini \
	&& cp /usr/local/docker/php-fpm.conf /etc/php/5.6/fpm/ \
	&& cp /usr/local/docker/www.conf /etc/php/5.6/fpm/pool.d/ \
	&& echo -e "opcache.enable=1\nopcache.enable_cli=1\nzend_extension=opcache.so" | sudo tee /etc/php/5.6/mods-available/10-opcache.ini \
	&& cp /usr/local/docker/php-fpm /etc/init.d/php-fpm \
	&& chmod +x /etc/init.d/php-fpm \
	&& update-rc.d php-fpm defaults \
	&& cd /usr/local/docker/php-beast-master \
	&& phpize \
	&& ./configure --with-php-config=php-config \
	&& make \
	&& make install \
	&& make clean \
	&& echo -e "; configuration for php beast module\n; priority=10\nbeast.log_file=/var/log/php/php-beast.log\nbeast.log_level=ERROR\nextension=beast.so" | sudo tee /etc/php/5.6/mods-available/20-beast.ini \
	&& cd /usr/local/docker/redis-2.2.8 \
	&& phpize \
	&& ./configure --with-php-config=php-config \
	&& make \
	&& make install \
	&& make clean \
	&& echo -e "; configuration for php redis module\n; priority=10\nextension=redis.so" | sudo tee /etc/php/5.6/mods-available/20-redis.ini \
	&& chmod 755 /usr/local/startcloudnetlotserver.sh

#clear
RUN rm -rf /usr/local/docker \
    && rm -rf /var/lib/apt/list/* \
    && apt-get autoclean -y \
    && apt-get clean -y \
    && apt-get autoremove -y

WORKDIR /usr/local/www

EXPOSE 80

ENTRYPOINT ["/bin/bash", "/usr/local/startcloudnetlotserver.sh"]
