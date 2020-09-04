# cloudnetlotdaemon environment
# version 1.0.0
#author waljqiang<waljqiang@163.com>

#base image to use ubuntu:14.04
FROM ubuntu:14.04
MAINTAINER waljqiang <waljqiang@163.com>

WORKDIR /usr/local/docker

ENV LANG C.UTF-8

COPY 2.0.0.tar.gz ./2.0.0.tar.gz
COPY 3.1.6.tar.gz ./3.1.6.tar.gz
COPY php-7.1.20.tar.gz ./php-7.1.20.tar.gz
COPY v0.13.3.tar.gz ./v0.13.3.tar.gz
COPY v1.2.4.tar.gz ./v1.2.4.tar.gz
COPY v2.1.1.tar.gz ./v2.1.1.tar.gz
COPY v4.1.0.tar.gz ./v4.1.0.tar.gz
COPY install.sh ./install.sh
COPY php.ini ./php.ini
ADD php-beast-master.tar.gz ./
RUN apt-get update \
    && apt-get install -y vim curl\
    && chmod +x /usr/local/docker/install.sh \
    && /usr/local/docker/install.sh \
	&& cd /usr/local/docker/php-beast-master \
	&& phpize \
	&& ./configure --with-php-config=php-config \
	&& make clean \
	&& make \
	&& make install \
	&& make clean \
	&& cp /usr/local/docker/php.ini /etc/php/7.1.20/cli \
	&& echo -e "; configuration for php beast module\n; priority=10\nbeast.log_file=/var/log/php7-beast.log\nbeast.log_level=ERROR\nextension=beast.so" | sudo tee /etc/php/7.1.20/cli/conf.d/20-beast.ini \
    && rm -rf /usr/local/docker \
    && rm -rf /var/lib/apt/list/* \
    && apt-get autoclean -y \
    && apt-get clean -y \
    && apt-get autoremove -y

WORKDIR /usr/local/www

EXPOSE 9091 9092 9093
