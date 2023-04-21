# Redis

## 介绍

1. Redis 是一个使用 C 语言写成的，开源的、key-value 结构的、非关系型数据库。它支持存储的 value 类型相对较多，有 String(字符串)、List(列表)、Set(集合)、Sorted Set(有序集合) 和 Hash(哈希)，这些操作都是原子性的。在此基础上，Redis 支持各种不同方式的排序。与memcached一样，为了保证效率，数据都是缓存在内存中。区别是Redis 可以周期性的把更新的数据写入磁盘或者把修改操作写入追加的记录文件，并在此基础上实现了master-slave(主从)同步。
2. Redis的出现，很大程度上补偿了memcached这类key/value存储的不足，在部分场合可以对关系数据库起到很好的补充作用。



## Redis安装

1. 下载

   ```sh
   [root@redis ~]# cd /usr/local/src/
   [root@redis src]# wget http://download.redis.io/releases/redis-4.0.1.tar.gz
   ```

2. 解压

   ```sh
   [root@redis src]# tar zxvf redis-4.0.1.tar.gz
   ```

3. 编译安装

   ```sh
   [root@redis src]# cd redis-4.0.1
   [root@redis src]# yum install -y gcc
   # make MALLOC=libc 就是指定内存分配器为 libc 
   [root@redis redis-4.0.1]# make MALLOC=libc
   [root@redis redis-4.0.1]# make && make install
   ```

4. 调整配置文件

   ```sh
   [root@redis redis-4.0.1]# cp redis.conf /etc/redis.conf
   [root@redis redis-4.0.1]# vi /etc/redis.conf
   # 修改配置文件
   daemonize yes
   # 指定日志文件，方便排查问题
   logfile "/var/log/redis.log"     
   dir /data/redis_data/
   # 持久化
   appendonly yes
   [root@redis redis-4.0.1]# mkdir -p /data/redis_data
   ```

5. 系统调优

   ```sh
   # Linux操作系统对大部分申请内存的请求都回复yes， 以便能运行更多的程序。 因为申请内存后， 并不会马上使用内存， 这种技术叫做overcommit。 如果Redis在启动时有上面的日志， 说明vm.overcommit_memory=0， Redis提示把它设置为1
   [root@redis redis-4.0.1]# sysctl vm.overcommit_memory=1
   
   [root@redis redis-4.0.1]# echo never > /sys/kernel/mm/transparent_hugepage/enabled
   # 参数说明：
   never 关闭，不使用透明内存
   alway 尽量使用透明内存，扫描内存，有512个 4k页面可以整合，就整合成一个2M的页面
   madvise 避免改变内存占用
   ```

6. 开启服务

   ```sh
   [root@redis redis-4.0.1]# redis-server /etc/redis.conf
   ```

   



## PHP安装

1. 下载

   ```sh
   [root@redis src]# cd /usr/local/src
   [root@redis src]# wget http://jp1.php.net/distributions/php-5.4.35.tar.gz
   ```

2. 解压并安装

   ```sh
   [root@redis src]# tar -zxvf php-5.4.35.tar.gz
   [root@redis src]# cd php-5.4.35
   
   # 安装依赖
   [root@redis php-5.4.35]# yum install gcc libxml2-devel openssl-devel libcurl-devel libjpeg libjpeg-devel  libpng libpng-devel freetype freetype-devel
   # 安装libmcrypt
   [root@redis php-5.4.35]# cd /usr/local/src
   [root@redis src]# wget ftp://mcrypt.hellug.gr/pub/crypto/mcrypt/libmcrypt/libmcrypt-2.5.7.tar.gz
   [root@redis src]# tar -zxvf libmcrypt-2.5.7.tar.gz
   [root@redis src]# cd libmcrypt-2.5.7
   [root@redis libmcrypt-2.5.7]# ./configure
   [root@redis libmcrypt-2.5.7]# make
   [root@redis libmcrypt-2.5.7]#  make install
   # 安装php
   [root@redis libmcrypt-2.5.7]# cd ..
   [root@redis src]# cd php-5.4.35
   [root@redis php-5.4.35]# ./configure --prefix=/usr/local/php --with-config-file-path=/usr/local/php/etc --with-iconv-dir --with-freetype-dir --with-jpeg-dir --with-png-dir --with-zlib --with-libxml-dir=/usr --enable-xml --disable-rpath --enable-bcmath --enable-shmop --enable-sysvsem --enable-inline-optimization --with-curl --with-curlwrappers --enable-mbregex --enable-fpm --enable-mbstring --with-mcrypt --enable-ftp --with-gd --enable-gd-native-ttf --with-openssl --with-mhash --enable-pcntl --enable-sockets --with-xmlrpc --enable-zip --enable-soap --with-gettext --with-mysql=mysqlnd --with-mysqli=mysqlnd --with-pdo-mysql=mysqlnd
   [root@redis php-5.4.35]# make && make install
   ```

3. 调整配置文件

   ```sh
   [root@redis php-5.4.35]# cp php.ini-development  /usr/local/php/etc/php.ini
   [root@redis php-5.4.35]# mv /usr/local/php/etc/php-fpm.conf.default /usr/local/php/etc/php-fpm.conf
   ```

4. 查看版本

   ```sh
   [root@redis php-5.4.35]# /usr/local/php/bin/php --version
   ```



## 安装apache

1. 下载

   ```sh
   [root@redis ~]# yum install -y httpd
   ```

2. 开启并设置自启

   ```sh
   [root@redis ~]# systemctl start httpd && systemctl enable httpd
   ```

   

## 安装redis扩展模块

1. 下载

   ```sh
   [root@redis ~]# cd /usr/local/src
   [root@redis src]# wget https://pecl.php.net/get/redis-4.0.1.tgz
   
   ```

2. 解压

   ```sh
   [root@redis src]# tar -zxvf redis-4.0.1.tgz
   ```

3. 写入configure

   ```sh
   [root@redis src]# cd redis-4.0.1
   [root@redis redis-4.0.1]# /usr/local/php/bin/phpize
   
   
   
   # 注意
   1. 可能会报错没有autoconf的信息
   Configuring for:
   PHP Api Version:         20100412
   Zend Module Api No:      20100525
   Zend Extension Api No:   220100525
   Cannot find autoconf. Please check your autoconf installation and the
   $PHP_AUTOCONF environment variable. Then, rerun this script.
     # 只需要安装autoconf即可
     [root@redis redis-4.0.1]# yum install -y autoconf
     # 安装完之后需要重新执行/usr/local/php/bin/phpize，将configure录入信息
   ```

4. 编译安装

   ```sh
   [root@redis redis-4.0.1]# ./configure --with-php-config=/usr/local/php/bin/php-config
   [root@redis redis-4.0.1]# make && make install
   ```

5. 调整配置文件

   ```sh
   [root@redis ~]# vim /usr/local/php/etc/php.ini
   添加extension=redis.so(在[PHH]和[END]标签之间)
   # 查看是否有redis模块后的查看结果
   [root@redis ~]# /usr/local/php/bin/php -m |grep redis
   redis
   # 查看php服务是否开启有误
   [root@redis ~]# /usr/local/php/sbin/php-fpm -t
   [16-Mar-2023 09:46:46] NOTICE: configuration file /usr/local/php/etc/php-fpm.conf test is successful
   
   ```



## session存储

1. 修改php配置文件

   ```sh
   [root@redis ~]# vim /usr/local/php/etc/php.ini
   session.save_handler = "redis" 
   session.save_path = "tcp://127.0.0.1:6379"
   
   # php介绍
   1. php.ini配置文件，就是是指php运行环境的配置文件，主要是用来设置php可以使用的功能配置参数页，每次 PHP 初始化都要读取 php.ini 文件。
   ```

2. 测试

   ```sh
   # 创建测试文件
   [root@redis ~]# cat /var/www/html/session.php 
   <?php
           session_start();
           $_SESSION['name']='test';        
           echo session_id()."<br/>";        
           echo $_SESSION['name'];
   ?>
   
   [root@redis ~]# cd /var/ww/html
   [root@redis html]# /usr/local/php/bin/php session.php
   t985j9ecknsqdkunihd2rigr82<br/>test
   [root@redis html]# redis-cli
   127.0.0.1:6379> get "PHPREDIS_SESSION:t985j9ecknsqdkunihd2rigr82"
   "name|s:4:\"test\";
   ```



## redis主从配置

### 环境

| 主机  | ip              | 节点规划                  |
| ----- | --------------- | ------------------------- |
| redis | 192.168.223.100 | redis-server、redis-slave |

### 主从配置

1. 设置第二台redis

   ```sh
   [root@redis html]# cp /etc/redis.conf /etc/redis2.conf
   [root@redis html]# vim /etc/redis2.conf
   # 修改
   port 6380
   dir /data/redis_data2
   pidfile /var/run/redis_6380.pid
   logfile "/var/log/redis2.log"
   # 添加（搜索slaveof，找到# slaveof <masterip> <masterport>）
   # slaveof 主库IP 主库redis端口号
   slaveof 127.0.0.1 6379          
   ```

2. 创建新目录

   ```sh
   [root@redis ~]# mkdir /data/redis_data2
   ```

3. 启动从服务

   ```
   [root@redis ~]# redis-server /etc/redis2.conf
   [root@redis ~]# redis-server --port 6380
   5095:C 16 Mar 14:37:28.325 # oO0OoO0OoO0Oo Redis is starting oO0OoO0OoO0Oo
   5095:C 16 Mar 14:37:28.325 # Redis version=4.0.1, bits=64, commit=00000000, modified=0, pid=5095, just started
   5095:C 16 Mar 14:37:28.325 # Configuration loaded
   5095:M 16 Mar 14:37:28.326 * Increased maximum number of open files to 10032 (it was originally set to 1024).
   5095:M 16 Mar 14:37:28.326 # Creating Server TCP listening socket *:6380: bind: Address already in use
   [root@redis ~]# redis-cli -p 6380
   127.0.0.1:6380> 
   ```

4. 测试

   ```sh
   [root@localhost html]# redis-cli -p 6380
   127.0.0.1:6380> 
   [root@localhost html]# redis-cli -p 6379
   127.0.0.1:6379> set keyt1 aaa
   OK
   127.0.0.1:6379> get key1
   (nil)
   127.0.0.1:6379> get keyt1
   "aaa"
   127.0.0.1:6379> exit
   [root@localhost html]# redis-cli -p 6380
   127.0.0.1:6380> get keyt1
   "aaa"
   127.0.0.1:6380> 
   ```

   