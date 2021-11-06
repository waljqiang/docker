# cloudnetlotjava environment
# version 6.0.0
#author waljqiang<waljqiang@163.com>

#base image to use ubuntu:14.04
FROM ubuntu:14.04
MAINTAINER waljqiang <waljqiang@163.com>

WORKDIR /usr/local/java

ENV LANG C.UTF-8

ADD jdk-8u301-linux-x64.tar.gz ./

ENV JAVA_HOME /usr/local/java/jdk1.8.0_301
ENV JRE_HOME ${JAVA_HOME}/jre
ENV CLASSPATH .:${JAVA_HOME}/lib:${JRE_HOME}/lib
ENV PATH ${JAVA_HOME}/bin:$PATH

RUN apt-get update \
    && apt-get install -y vim curl lrzsz \
    && update-alternatives --install /usr/bin/java java /usr/local/java/jdk1.8.0_301/bin/java 300 \
    && update-alternatives --install /usr/bin/javac javac /usr/local/java/jdk1.8.0_301/bin/javac 300 \
    && update-alternatives --install /usr/bin/jar jar /usr/local/java/jdk1.8.0_301/bin/jar 300 \
    && update-alternatives --install /usr/bin/javah javah /usr/local/java/jdk1.8.0_301/bin/javah 300 \
    && update-alternatives --install /usr/bin/javap javap /usr/local/java/jdk1.8.0_301/bin/javap 300 \
    && update-alternatives --config java

WORKDIR /usr/local/cloudnetlot/www
