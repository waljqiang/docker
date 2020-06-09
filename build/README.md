# Docker常用命令

## 启动

* 启动命令

    ```
    docker run --name yuncoredaemon -p 9091:9091 -p 9092:9092 -p 9093:9093 -v /usr/local/yuncore/yuncoredaemon/php:/etc/php/7.1.20 -v /usr/local/yuncore/www/yuncoredaemon:/usr/local/www/yuncoredaemon --restart=no -it -d waljqiang/yuncoredaemon:1.0.0
    
    restart(重启策略)
        no,容器退出时不重启容器
        on-failure:n,只有在非0状态下退出重启容器n次
        always,无论退出状态如何，都重启容器
    ```

* 镜像制作
    
    ```
        docker build -t waljqiang/yuncoredaemon:1.0.0  ./
    ```

* 查看docker占用磁盘大小

    ```
    docker system df
    ```

* 清除无用镜像和容器

    ```
    docker system prune(清除悬空镜像)
    docker system prune -a(清除悬空和未被使用的镜像)
    ```

## 常见问题

* docker pull慢

    需要做镜像加速,修改/etc/docker/daemon.json文件，增加以下内容

    ```
    {
        "registry-mirrors":[
            "https://registry.docker-cn.com",//中国dockerhub镜像加速
            "https://docker.mirrors.ustc.edu.cn",//华中科技大学加速
            "https://hub-mirror.c.163.com",//网易加速
            "https://reg-mirror.qiniu.com"//七牛加速
        ]

    }
    ```

* Dockerfile build后容器内中文乱码

    在Dockerfile中添加如下一行：
    
    ```
    ENV LANG C.UTF-8
    ```

## yuncoredaemon

* tag命名
 
    yuncoredaemon镜像以1.x.y命名；x表示大版本，y表示小版本

* build镜像
 
    如果要改动镜像，修改Dockerfile文件，然后从新执行build命令即可。

    ```
    docker build -t waljqiang/yuncoredaemon:1.0.0  ./
    ```

    Dockerfile的from可以基于已有的yuncoredaemon镜像基础做修改,build命令注意镜像的tag需要改动.

* 说明
 
    1.镜像包括以下软件:

        ```
        php7.1.20
        swoole4.1.0 
        hiredis0.13.3 
        phpredis3.1.6
        phpinotify2.0.0
        ```

    2.可运行swooledistributed3.7.4框架开发的应用

    3.对外端口

    | 端口| 服务|
    |:---:|:---:|
    |9091|TCP|
    |9092|HTTP|
    |9093|WEBSOCKET|

* 运行镜像

    ```
    docker run --name yuncoredaemon -p 9091:9091 -p 9092:9092 -p 9093:9093 -v /usr/local/yuncore/yuncoredaemon/php:/etc/php/7.1.20 -v /usr/local/yuncore/www/yuncoredaemon:/usr/local/www/yuncoredaemon -v /etc/localtime:/etc/localtime:ro --restart=always -it -d waljqiang/yuncoredaemon:1.0.0
    ```

## yuncoreserver

* tag命名
 
    yuncoreserver镜像以2.x.y命名；x表示大版本，y表示小版本

* build镜像
 
    如果要改动镜像，修改Dockerfile文件，然后从新执行build命令即可。

    ```
    docker build -t waljqiang/yuncoreserver:2.0.0  ./
    ```

    Dockerfile的from可以基于已有的yuncoredaemon镜像基础做修改,build命令注意镜像的tag需要改动.

* 说明
 
    1.镜像包括以下软件:

        ```
        nginx1.6.2
        php5.6.38 
        php扩展
            beast
            redis
        ```

    2.对外端口

    | 端口| 服务|
    |:---:|:---:|
    |80|nginx|

* 运行镜像

    ```
    docker run --name yuncoreserver -p 9090:80 -v /usr/local/yuncore/yuncoreserver/nginx:/etc/nginx -v /usr/local/yuncore/yuncoreserver/php:/etc/php/5.6 -v /usr/local/yuncore/www:/usr/local/www -v /etc/localtime:/etc/localtime:ro --restart=always -it -d waljqiang/yuncoreserver:2.0.0
    ```

## yuncoredata

* tag命名
 
    yuncoredata镜像以3.x.y命名；x表示大版本，y表示小版本

* build镜像
 
    如果要改动镜像，修改Dockerfile文件，然后从新执行build命令即可。

    ```
    docker build -t waljqiang/yuncoredata:3.0.0  ./
    ```

    Dockerfile的from可以基于已有的yuncoredaemon镜像基础做修改,build命令注意镜像的tag需要改动.

* 说明
 
    1.镜像包括以下软件:

        ```
        mysql5.7.22(root/admin@123)
        redis4.0.8(1f494c4e0df9b837dbcc82eebed35ca3f2ed3fc5f6428d75bb542583fda2170f)
        emqttd2.3.11(admin/public)
        ```

    2.对外端口：

    | 端口| 服务|
    |:---:|:---:|
    |3306|mysql|
    |6379|redis|
    |8080|mqtt:api|
    |8083|mqtt:ws|
    |8084|mqtt:wss|
    |8883|mqtt:ssl|
    |1883|mqtt:tcp|
    |127.0.0.1:11883|mqtt:tcp|
    |18083|dashboard:http|

* 运行镜像

    ```
    docker run --name yuncoredata -p 9094:3306 -p 9095:6379 -p 9096:1883 -p 9097:8084 -p 9098:8083 -p 9099:18083 -v /usr/local/yuncore/yuncoredata/mysql/conf:/etc/mysql -v /usr/local/yuncore/yuncoredata/mysql/data:/var/lib/mysql -v /usr/local/yuncore/yuncoredata/redis/:/etc/redis -v /usr/local/yuncore/yuncoredata/emqttd:/etc/emqttd -v /etc/localtime:/etc/localtime:ro --restart=always -it -d waljqiang/yuncoredata:3.0.0
    ```

* 备注
  mysql安装包由于太大没有上传，请自行下载mysql-server_5.7.22-1ubuntu14.04_amd64.deb-bundle.tar

## yuncorevsftpd

* tag命名
 
    yuncorevsftpd镜像以4.x.y命名；x表示大版本，y表示小版本

* build镜像
 
    如果要改动镜像，修改Dockerfile文件，然后从新执行build命令即可。

    ```
    docker build -t waljqiang/yuncorevsftpd:4.0.0  ./
    ```

    yuncorevsftpd,build命令注意镜像的tag需要改动.

* 说明
 
    1.镜像包括以下软件:

        ```      
        fauria/vsftpd base image.
        vsftpd 3.0
        Virtual users
        Passive mode
        Logging to a file or STDOUT.
        ```

* 详细说明:

    https://hub.docker.com/r/fauria/vsftpd

* 运行镜像

    ```
    docker run -d --name yuncorevsftpd -p 20:20 -p 21:21 -p 21100-21110:21100-21110 -v /home/vsftpd:/home/vsftpd -v /usr/local/yuncore/yuncorevsftpd:/etc/vsftpd -v /etc/localtime:/etc/localtime:ro -e FTP_USER=ftpuser -e FTP_PASS=123456 -e PASV_ADDRESS=$1 -e PASV_MIN_PORT=21100 -e PASV_MAX_PORT=21110  --restart=always waljqiang/yuncorevsftpd:4.0.0
    ```

## yuncoreencode

* tag命名
 
    yuncoreencode镜像以5.x.y命名；x表示大版本，y表示小版本

* build镜像
 
    如果要改动镜像，修改Dockerfile文件，然后从新执行build命令即可。

    ```
    docker build -t waljqiang/yuncoreencode:5.0.0  ./
    ```

    Dockerfile的from可以基于已有的yuncoredaemon镜像基础做修改,build命令注意镜像的tag需要改动.

* 说明
 
    1.镜像包括以下软件:

        ```
        php5.6.38
        php7.1.20
        php-beast-master
        ```

    2.对外端口：

    | 端口| 服务|
    |:---:|:---:|
    |80|--|

* 运行镜像

    ```
    docker run --name yuncoreencode -v /usr/local/yuncore/yuncoreencode/php5:/etc/php/5.6 -v /usr/local/yuncore/yuncoreencode/php7:/etc/php/7.1 -v /usr/local/yuncore/yuncoreencode/phpbeast:/usr/local/php-beast-master/tools -v /etc/localtime:/etc/localtime:ro --restart=always -it -d waljqiang/yuncoreencode:5.0.0
    ```

* 使用

    php5代码加密,将源代码放入php-beast-master配置文件中指定的源目录中,执行
    ```
    /usr/local/php/5.6/bin/php /usr/local/php-beast-master/tools/encode_files.php
    ```

    php7代码加密,将源代码放入php-beast-master配置文件中指定的源目录中,执行
    ```
    /usr/local/php/7.1/bin/php /usr/local/php-beast-master/tools/encode_files.php
    ```