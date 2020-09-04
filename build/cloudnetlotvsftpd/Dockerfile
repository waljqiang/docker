# cloudnetlotvsftpd environment
# version 4.0.0
#author waljqiang<waljqiang@163.com>

#base image to use fauria/vsftpd
FROM fauria/vsftpd
MAINTAINER waljqiang <waljqiang@163.com>

WORKDIR /home/vsftpd

ENV LANG C.UTF-8

ADD ./vsftpdconf.tar.gz /etc/vsftpd
ADD ./run-vsftpd.sh ./

RUN mv /home/vsftpd/run-vsftpd.sh /usr/sbin/run-vsftpd.sh \
    && chmod +x /usr/sbin/run-vsftpd.sh
