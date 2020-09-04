# cloudnetlotdata environment
# version 3.0.0
#author waljqiang<waljqiang@163.com>

#base image to use ubuntu:14.04
FROM ubuntu:14.04
MAINTAINER waljqiang <waljqiang@163.com>

WORKDIR /usr/local/docker

ENV LANG C.UTF-8

ADD ./mysql/mysql-server_5.7.22-1ubuntu14.04_amd64.deb-bundle.tar ./mysql
COPY ./mysql/mysqlconf.tar.gz ./mysql
COPY ./mysql/mysqldata.tar.gz ./mysql
ADD ./redis/redis-4.0.8.tar.gz ./redis
ADD ./redis/jemalloc-4.2.1.tar.bz2 ./
COPY ./redis/redis.conf ./redis
COPY ./redis /etc/init.d/
COPY ./emqx/emqx-debian8-v4.0.0_amd64.deb ./emqx/
COPY ./emqx/emqxconf.tar.gz ./emqx/
COPY ./script/supervisord.conf /usr/local/
COPY ./script/start.sh /usr/local/

#vim
RUN apt-get update \
	&& apt-get install -y --no-install-recommends vim supervisor libaio1 libnuma1 psmisc libmecab2 make gcc make autoconf g++

#mysql
RUN cd ./mysql \
	&& dpkg -i mysql-common_*.deb \
	&& dpkg -i mysql-community-client_*.deb \
	&& dpkg -i mysql-client_*.deb \
	&& dpkg -i mysql-community-server_*.deb \
	&& dpkg -i mysql-server_*.deb \
	&& tar zvxf ./mysqlconf.tar.gz -C /etc/mysql \
	&& tar zvxf ./mysqldata.tar.gz -C /var/lib/mysql \
	&& chown -R mysql:mysql /var/lib/mysql

#redis
RUN	cd /usr/local/docker/jemalloc-4.2.1 \
	&& ./configure \
	&& make \
	&& make install \
	&& make clean \
	&& cd /usr/local/docker/redis/redis-4.0.8 \
	&& make \
	&& cd ./src \
	&& make install PREFIX=/usr/local/redis-4.0.8 \
	&& cd ../ \
	&& make clean \
	&& mkdir -p /etc/redis \
	&& cp /usr/local/docker/redis/redis.conf /etc/redis/redis.conf \
	&& ln -s /usr/local/redis-4.0.8/bin/redis-server /usr/bin/redis-server \
	&& ln -s /usr/local/redis-4.0.8/bin/redis-cli /usr/bin/redis-cli \
	&& chmod +x /etc/init.d/redis

#emqx
RUN cd ./emqx \
	&& dpkg -i  emqx-debian8-v4.0.0_amd64.deb \
	&& tar zvxf /usr/local/docker/emqx/emqxconf.tar.gz -C /etc/emqx \
	&& /etc/init.d/emqx start \
	&& sleep 1 \
	&& emqx_ctl plugins reload emqx_auth_username 

#clear
RUN rm -rf /usr/local/docker \
    && rm -rf /var/lib/apt/list/* \
    && apt-get autoclean -y \
    && apt-get clean -y \
    && apt-get autoremove -y \
    && chmod 755 /usr/local/start.sh

WORKDIR /usr/local

EXPOSE 3306 6379 8080 8083 8084 8883 1883 11883 18083

ENTRYPOINT ["/bin/bash", "/usr/local/start.sh"]
