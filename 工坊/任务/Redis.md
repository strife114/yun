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

   



# Redis伪集群分布

## 简介

1. 伪分布集群：即一台服务器六个redis

## 实验要求

1. 伪分布集群至少需要三个节点，运维投票容错机制要求超过
2. 半数节点才能认为某个节点挂掉
3. 要保证集群的高可用，需要每个节点都要有从节点，所以redis集群至少需要六台服务器
4. 安装ruba



## 部署

### redis安装

1. 下载安装包

   ```sh
   [root@localhost ~]# cd /usr/local/src/
   [root@localhost src]# wget http://download.redis.io/releases/redis-4.0.1.tar.gz
   
   
   
   
   
   
   #查找文件在哪里
   [root@localhost redis-4.0.1]# find / -name redis-trib.rb
   /usr/local/src/redis-4.0.1/src/redis-trib.rb
   [root@localhost src]# cp redis-trib.rb /usr/bin/
   ```

2. 解压

   ```sh
   [root@localhost src]# tar -zxvf redis-4.0.1.tar.gz
   [root@localhost src]# cd redis-4.0.1/
   ```

3. 编译安装

   ```sh
   # 安装gcc编译器
   [root@localhost redis-4.0.1]# yum -y install gcc
   # 可以同时进行多个进程服务
   [root@localhost redis-4.0.1]# make -j 4
   [root@localhost redis-4.0.1]# make install PREFIX=/usr/local/redis
   [root@localhost redis-4.0.1]# cp redis-trib.rb /usr/bin
   
   
   
   
   # 注意
   1. redis-trib.rb是官方提供的Redis Cluster的管理工具，在src目录下，但该工具是用ruby开发的，所以需要准备相关的依赖环境。
   2. cp: 无法获取"redis-trib.rb" 的文件状态(stat): 没有那个文件或目录
   
   # 解决方法
   2. [root@localhost redis-4.0.1]# find / -name redis-trib.rb
       /usr/local/src/redis-4.0.1/src/redis-trib.rb
      [root@localhost src]# cp redis-trib.rb /usr/bin/
   
   ```

   

### ruby安装

#### 部署要求

1. 需要的ruby环境版本应该在2.3.0版本以上，若出现提示版本太低，进行升级即可

   ```sh
   # redis requires Ruby version >= 2.3.0.
   ```

   

#### 安装

1. 下载并解压安装包

   ```sh
   [root@localhost ~]# cd /usr/local/src/
   [root@localhost src]# wget https://cache.ruby-lang.org/pub/ruby/2.5/ruby-2.5.5.tar.gz
   [root@localhost src]# tar -zxvf ruby-2.5.5.tar.gz
   [root@localhost src]# cd ruby-2.5.5
   ```

2. 编译安装

   ```sh
   [root@localhost ruby-2.5.5]# ./configure --prefix=/usr/local/ruby --enable-shared
   [root@localhost ruby-2.5.5]# make -j 4 ;make install
   ```

3. 添加环境变量

   ```sh
   [root@localhost ~]# vim /etc/profile
   # 在最后一行添加内容
   export RUBY_HOME=/usr/local/ruby
   export PATH=$RUBY_HOME/bin:$RUBY_HOME/lib:$PATH
   
   
   # 生效
   [root@localhost ~]# source /etc/profile
   ```

4. 查看版本信息

   ```sh
   # 查看ruby版本
   [root@localhost ~]# ruby -v
   ruby 2.5.5p157 (2019-03-15 revision 67260) [x86_64-linux]
   # Gem 是Ruby 中的包,其中包含包信息,以及用于安装的文件。
   [root@localhost ~]# gem -v     
   2.7.6.2
   ```
   
5. 编译准备

   ```sh
   # 进入源码包（zlib是一个库）
   [root@localhost ruby-2.5.5]# cd ext/zlib/   
   [root@localhost zlib]# pwd
   /usr/local/src/ruby-2.5.5/ext/zlib
   [root@localhost zlib]# yum install zlib-devel openssl-devel -y
   
   # 执行其修改Makefile文件
   [root@localhost zlib]# ruby extconf.rb
   checking for deflateReset() in -lz... yes
   checking for zlib.h... yes
   
   [root@localhost zlib]# vim Makefile
   # 修改内容
   将zlib.o: $(top_srcdir)/include/ruby.h改为zlib.o: ../../include/ruby.h
   
   [root@localhost zlib]# make -j 4;make install
   [root@localhost zlib]# cd ../openssl/
   [root@localhost openssl]# pwd
   /usr/local/src/ruby-2.5.5/ext/openssl
   [root@localhost openssl]# ruby extconf.rb
   [root@localhost openssl]# vim Makefile
   #在开头添加
   top_srcdir = ../..   //增加一行定义变量
   ```

6. 编译安装

   ```sh
   [root@localhost openssl]# make -j 4;make install
   [root@localhost openssl]# gem install redis  #安装redis接口包
   ```

   

## 集群部署

### 集群建立

1. 新建目录

   ```sh
   [root@localhost openssl]# mkdir /usr/local/cluster
   [root@localhost local]# cp -r /usr/local/redis/bin/ /usr/local/cluster/redis7000
   [root@localhost local]# cp /usr/local/src/redis-4.0.1/redis.conf  /usr/local/cluster/redis7000/
   [root@localhost local]# cd cluster/
   ```

2. 修改配置文件

   ```sh
   [root@localhost cluster]# cd redis7000/
   [root@localhost cluster]# vim /usr/local/cluster/redis7000/redis.conf
   # 修改里面的配置，后面的每个redis7001,2等等都要修改
   
   port 7000
   bind 127.0.0.1
   daemonize yes
   pidfile /var/run/redis_7000.pid
   # 集群开关，默认是no
   cluster-enabled yes
   # 集群配置文件名
   cluster-config-file nodes_7000.conf
   # 节点之间相互连接的超时时间
   cluster-node-timeout 15000
   appendonly yes
   ```

3. 构建集群

   ```sh
   #更改里面不同的参数
   [root@localhost cluster]# cp -r /usr/local/cluster/redis7000/ /usr/local/cluster/redis7001
   [root@localhost cluster]# cp -r /usr/local/cluster/redis7000/ /usr/local/cluster/redis7002
   [root@localhost cluster]# cp -r /usr/local/cluster/redis7000/ /usr/local/cluster/redis7003
   [root@localhost cluster]# cp -r /usr/local/cluster/redis7000/ /usr/local/cluster/redis7004
   [root@localhost cluster]# cp -r /usr/local/cluster/redis7000/ /usr/local/cluster/redis7005
   [root@localhost cluster]# ls
   redis7000  redis7001  redis7002  redis7003  redis7004  redis7005
   
   
   # 构建集群1
   [root@localhost cluster]# cd redis7001
   [root@localhost redis7001]# sed -i 's/7000/7001/g' redis.conf
   [root@localhost redis7001]# cd ..
   
   # 构建集群2
   [root@localhost cluster]# cd redis7002
   [root@localhost redis7002]# sed -i 's/7000/7002/g' redis.conf
   以此类推，一直改完redis7005的redis.conf
   ```

4. 开启redis服务

   ```sh
   # 手动开启
   [root@localhost cluster]# cd redis7000
   [root@localhost redis7000]# ./redis-server redis.conf 
   24640:C 17 Mar 17:07:54.202 # oO0OoO0OoO0Oo Redis is starting oO0OoO0OoO0Oo
   24640:C 17 Mar 17:07:54.202 # Redis version=4.0.1, bits=64, commit=00000000, modified=0, pid=24640, just started
   24640:C 17 Mar 17:07:54.202 # Configuration loaded
   # 7000开启成功，7001，2，3，4，5均按此方法开启
   
   # 脚本开启
   [root@localhost cluster]# vim start-all.sh
   #!/bin/bash
   cd redis7000
   ./redis-server redis.conf
   cd ..
   cd redis7001
   ./redis-server redis.conf
   cd ..
   cd redis7002
   ./redis-server redis.conf
   cd ..
   cd redis7003
   ./redis-server redis.conf
   cd ..
   cd redis7004
   ./redis-server redis.conf
   cd ..
   cd redis7005
   ./redis-server redis.conf
   cd ..
   
   # 更改权限
   [root@localhost cluster]# chmod +x start-all.sh
   # 开启服务
   [root@localhost cluster]# ./start-all.sh
   ```

5. 查看端口

   ```sh
   [root@localhost cluster]# ps -ef |grep redis
   root      24641      1  0 17:07 ?        00:00:00 ./redis-server 127.0.0.1:7000 [cluster]
   root      24730      1  0 17:09 ?        00:00:00 ./redis-server 127.0.0.1:7001 [cluster]
   root      24745      1  0 17:09 ?        00:00:00 ./redis-server 127.0.0.1:7002 [cluster]
   root      24766      1  0 17:09 ?        00:00:00 ./redis-server 127.0.0.1:7003 [cluster]
   root      24805      1  0 17:10 ?        00:00:00 ./redis-server 127.0.0.1:7004 [cluster]
   root      24821      1  0 17:10 ?        00:00:00 ./redis-server 127.0.0.1:7005 [cluster]
   root      24848   2659  0 17:10 pts/0    00:00:00 grep --color=auto redis
   ```

6. 建立集群连接

   ```sh
   [root@localhost cluster]# redis-trib.rb create --replicas 1 127.0.0.1:7000 127.0.0.1:7001 127.0.0.1:7002 127.0.0.1:7003 127.0.0.1:7004 127.0.0.1:7005
   
   # 参数解释
   --replicas  参数指定集群中每个主节点配备几个从节点，这里设置为1，即三主三从成功界面
   ```

7. 测试

   ```sh
   [root@localhost cluster]# redis7000/redis-cli -p 7000 -c  {加上-c，节点之间是可自动跳转，不加，则不能跳转}
   127.0.0.1:7000>                                              
   127.0.0.1:7000> set key1 6
   -> Redirected to slot [9189] located at 127.0.0.1:7001
   OK
   127.0.0.1:7001>
   -> Redirected to slot [9189] located at 127.0.0.1:7001
   OK
   127.0.0.1:7001>
   # 集群之间在一定的时间之后会相互随机转换
   ```

   



# Redis哨兵

## 简介

1. 哨兵模式是Redis的高可用方式，哨兵节点是特殊的redis服务，不提供读写服务，主要用来监控redis实例节点
2. 在主从模式下，master节点负责写请求，然后异地同步给slave节点，从节点负责处理读请求。如果master宕机了，需要手动将从节点晋升为主节点，并且还要切换客户端的连接数据源。这就无法达到高可用，而通过哨兵模式就可以解决这一问题。

## 作用

1. 监控（哨兵会不断就见擦汗你都master和slave是否运作正常）
2. 告警（当被监控的某个redis节点出现问题时，哨兵可以通过API向管理员或者其他应用程序发送通知）
3. 故障自适应迁移（当一个master不能工作室，哨兵会将失效的master的其中一个slave升级为新的master，当客户端试图连接失效的master时，集群也会向客户端返回新的master地址，使得集群可以使用新的master代替失效的master）



## redis服务安装（3）

1. 下载并安装

   ```sh
   # cd /usr/local/src/
   # wget http://download.redis.io/releases/redis-4.0.1.tar.gz
   # tar -zxvf  redis-4.0.1.tar.gz
   # cd redis-4.0.1
   # yum install -y gcc
   # make MALLOC=libc
   # make && make install
   # cp redis.conf /etc/redis.conf
   ```

2. 修改配置文件

   ```sh
   # vim /etc/redis.conf
   # 找到以下参数
   
   daemonize yes
   # 指定日志文件
   logfile "/var/log/redis.log"
   dir /data/redis_data/
   # 持久化
   appendonly yes
   ```

3. 调整redis相关事务

   ```sh
   # mkdir -p /data/redis_data
   # mkdir /var/log/redis.log
   # sysctl vm.overcommit_memory=1
   # echo never > /sys/kernel/mm/transparent_hugepage/enabled
   # redis-server /etc/redis.conf
   ```



## 搭建一主两从

1. 修改主配置文件

   ```sh
   # vim /etc/redis.conf
   # 注释这个参数
   bind 127.0.0.1
   # 修改这个参数
   protected-mode no
   ```

2. 配置两台从配置文件

   ```sh
   # vim /etc/redis.conf
   # 注释
   bind 127.0.0.1
   # 修改
   protected-mode no
   
   # 修改为主机ip
   slaveof 192.168.23.4 6379
   ```

3. 启动所有机器服务

   ```sh
   # redis-server /etc/redis.conf
   ```

4. 查看是否启动

   ```sh
   # ps -ef |grep redis
   root       8219      1  0 09:33 ?        00:00:00 redis-server 0.0.0.0:6379
   root       11244   2538  0 09:33 pts/0    00:00:00 grep --color=auto redis
   ```

5. 测试

   ```sh
   # 在master查看主从关系
   127.0.0.1:6379> info replication
   # 看到这个参数
   role:master
   connected_slaves:2
   
   
   # 在salve查看主从关系
   127.0.0.1:6379> info replication
   # 看到这个参数
   role:slave
   ```

6. 测试哨兵服务

   ```sh
   #可登录任何一台进行查看
   # redis-cli -h 192.168.223.4 -p 26379
   192.168.223.4:26379> info sentinel
   # Sentinel
   sentinel_masters:1
   sentinel_tilt:0
   sentinel_running_scripts:0
   sentinel_scripts_queue_length:0
   sentinel_simulate_failure_flags:0
   master0:name=mymaster,status=ok,address=192.168.223.3:6379,slaves=2,sentinels=3
   ```

   ```sh
   # 关闭主节点服务，测试主节点移动
   # redis-cli
   127.0.0.1:6379> shutdown
   not connected>
   # ps -ef | grep redis
   root       7219      1  0 08:38 ?        00:00:00 redis-server *:6379
   root       3521   2448  0 08:46 pts/0    00:00:00 grep --color=auto redis
   # kill -9 7219
   # ps -ef | grep redis
   root       3521   2448  0 08:46 pts/0    00:00:00 grep --color=auto redis
   
   
   
   # 在从节点上查看到
   # redis-cli
   127.0.0.1:6379> info replication
   # Replication
   role:master
   connected_slaves:1
   slave0:ip=192.168.223.4,port=6379,state=online,offset=151006,lag=0
   master_replid:cd6a813ba949330ae57ba7ff97d9e037dc5eab32
   master_replid2:69cfe36d88780aa382bc584588d75eb498ad37f1
   master_repl_offset:151006
   second_repl_offset:137995
   repl_backlog_active:1
   repl_backlog_size:1048576
   repl_backlog_first_byte_offset:15
   repl_backlog_histlen:150992
   ```

   
