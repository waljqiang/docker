# cloudnetlot

* cloudnetlot用户自建项目部署

## 目录说明

```
--script--------------------------------执行脚本
--soft-------------------------------镜像存放目录
--www--------------------------------代码存放目录
--cloudnetlotdaemon----------------------cloudnetlotdaemon服务器相关
------php----------------------------cloudnetlotdaemon服务器的php配置
--cloudnetlotdata------------------------cloudnetlotdata服务器相关
------emqx-------------------------cloudnetlotdata服务器中emqx配置
------mysql--------------------------
-----------conf----------------------cloudnetlotdata服务器中mysql配置
-----------data----------------------cloudnetlotdata服务器中mysql数据
------redis--------------------------cloudnetlotdata服务器中redis配置
--cloudnetlotencode----------------------cloudnetlotencode服务器相关
------php5---------------------------cloudnetlotencode服务器中php5配置
------php7---------------------------cloudnetlotencode服务器中php7配置
------phpbeast-----------------------cloudnetlotencode服务器中php-beast配置
--cloudnetlotserver----------------------cloudnetlotserver服务器相关
------nginx--------------------------cloudnetlotserver服务器中nginx配置
------php----------------------------cloudnetlotserver服务器中php配置
--cloudnetlotvsftpd----------------------cloudnetlotvsftpd服务器配置相关
--README.md
```

## 备注

* 作为用户自建使用，该目录下所有文件统一压缩成.tar.gz文件，上传到用户服务器下,注意各服务器配置文件改动时，需要上传到linux上先解压再改动，然后打包成压缩文件再放入对应目录下，不然会丢失文件中的符号链接文件。

## 项目部署

* 将压缩包上传到用户服务器(/usr/local目录为例,用户服务器地址为192.168.111.100)并解压到当前目录

* 进入到/usr/local/cloudnetlot/script目录,并执行下面命令

```
    ./install.sh [服务器IP] [服务名] [configmap]
```
    服务器IP为用户服务器地址。

    服务名可以写多个，中间用空格隔开，脚本只会部署此处填写的服务，具体服务名与服务器对应关系请参阅服务容器与服务名对应关系一节。

    configmap为固定字符串，如果有此字符串，则会将各容器中各应用的配置文件映射到宿主机中，否则，不会将容器中各应用配置文件映射到宿主机。

     此脚本命令必须要两个参数，第一个参数固定为用户服务器IP地址，第二个参数当仅两个参数时必须为服务容器名，当参数个数大于两个后，从第二个参数开始依次为服务容器名或configmap，configmap如果存在，则在启动容器时会将各容器中服务的配置文件映射到宿主机的对应目录.系统只会搭建命令中指定的服务容器。

示例：
```
    ./install.sh 192.168.111.100 cloudnetlotdata cloudnetlotvsftpd cloudnetlotdaemon cloudnetlotserver cloudnetlotencode configmap
```
    

* 服务容器名与服务名对应关系
```
    cloudnetlotserver----------------云平台应用服务器
    cloudnetlotdaemon----------------云平台daemon服务器
    cloudnetlotdata------------------云平台数据层服务器
    cloudnetlotvsftpd----------------云平台vsftpd服务器
    cloudnetlotencode----------------加密代码服务器
```

* 各服务容器中软件说明

    ```
    cloudnetlotdata
        mysql5.7.22(root/admin@123)
        redis4.0.8(1f494c4e0df9b837dbcc82eebed35ca3f2ed3fc5f6428d75bb542583fda2170f)
        emqx4.0.0(admin/public)(admin/123456)
    cloudnetlotdaemon
        php7.1.20
        swoole4.1.0 
        hiredis0.13.3 
        phpredis3.1.6
        phpinotify2.0.0
    cloudnetlotvsftpd
        vsftpd3.0(ftpuser/123456)
    cloudnetlotserver
        nginx1.6.2
        php5.6.38 
    cloudnetlotencode
        php5.6.38
        php7.1.20
        php-beast-master
    ```


* 各容器与宿主机端口映射关系

    | 服务容器名| 宿主机端口|容器端口|服务|
    |:---:|:---:|:---:|:---:|
    |cloudnetlotdata|9094|3306|mysql5.7.22|
    ||9095|6379|redis4.0.8|
    ||9096|1883|emqttd2.3.11:tcp|
    ||9097|8084|emqttd2.3.11:wss|
    ||9098|8083|emqttd2.3.11:ws|
    ||9099|18083|emqttd2.3.11:dashboard:http|
    |cloudnetlotvsftpd|20|20||
    ||21|21||
    ||21100|21100||
    ||21101|21101||
    ||21102|21102||
    ||21103|21103||
    ||21104|21104||
    ||21105|21105||
    ||21106|21106||
    ||21107|21107||
    ||21108|21108||
    ||21109|21109||
    ||21110|21110||
    |cloudnetlotdaemon|9091|9091|sd:tcp|
    ||9092|9092|sd:http|
    ||9093|9093|sd:websocket|
    |cloudnetlotserver|9090|80|nginx1.6.2:http|
    |cloudnetlotencode||||

* 各服务容器与宿主机目录映射关系(宿主机上的目录为相对目录)

    | 服务容器名| 宿主机中目录|容器中目录|
    |:---:|:---:|:---:|
    |cloudnetlotdata|cloudnetlotdata/mysql/conf|/etc/mysql|
    ||cloudnetlotdata/mysql/data|/var/lib/mysql|
    ||cloudnetlotdata/redis|/etc/redis|
    ||cloudnetlotdata/emqttd|/etc/emqttd|
    ||/etc/localtime|/etc/localtime|
    |cloudnetlotvsftpd|/home/vsftpd|/home/vsftpd|
    ||cloudnetlotvsftpd|/etc/vsftpd|
    ||/etc/localtime|/etc/localtime|
    |cloudnetlotdaemon|cloudnetlotdaemon/php|/etc/php/7.1.20|
    ||www/cloudnetlotdaemon|/usr/local/www/cloudnetlotdaemon|
    ||/etc/localtime|/etc/localtime|
    |cloudnetlotserver|cloudnetlotserver/nginx|/etc/nginx|
    ||cloudnetlotserver/php|/etc/php/5.6|
    ||www|/usr/local/www|
    ||/etc/localtime|/etc/localtime|
    |cloudnetlotencode|cloudnetlotencode/php5|/etc/php/5.6|
    ||cloudnetlotencode/php7|/etc/php/7.1|
    ||cloudnetlotencode/phpbeast|/usr/local/php-beast-master/tools|
    ||/etc/localtime|/etc/localtime|
