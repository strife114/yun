# memcache

## 安装

1. 下载

   ```sh
   [root@localhost ~]# yum install -y memcached libmemcached libevent
   ```

2. 开启并设置自启

   ```sh
   [root@localhost ~]# systemctl start memcached
   [root@localhost ~]# systemctl enable memcached
   ```

3. 检测

   ```sh
   [root@localhost ~]# memcached-tool 127.0.0.1:11211  stats
   ```




## 测试

1. 安装telnet

   ```sh
   [root@localhost ~]# yum install -y telnet
   
   ```

2. 进入数据库

   ```sh
   [root@localhost ~]# telnet 127.0.0.1 11211
   ```

3. 测试

   ```sh
   [root@localhost ~]# telnet 127.0.0.1 11211
   Trying 127.0.0.1...
   Connected to 127.0.0.1.
   Escape character is '^]'.
   
   set key2 0 30 2  # 创建一个key值为3的键值对
   ab # 数据
   STORED
   
   get key2  # 获取
   VALUE key2 0 2
   ab
   END
   
   replace key2 1 300 6 # 替代
   delete key2   # 删除
   ```



## 数据导入和导出

```sh
# 导出
memcached-tool 127.0.0.1:11211 dump > data.txt
# 导入
nc 127.0.0.1 11211 < data.txt



# 注意若nc命令不存在
yum install nc -y
导出的数据是带有一个时间戳的，这个时间戳就是该条数据过期的时间点，如果当前时间已经超过该时间戳，那么是导入不进去的
```



# 安装php

1. 下载依赖

   ```sh
   [root@localhost ~]# yum install -y gcc libxml2-devel  openssl-devel libcurl-devel libjpeg libjpeg-devel libpng libpng-devel freetype freetype-devel
   
   [root@localhost ~]# wget ftp://mcrypt.hellug.gr/pub/crypto/mcrypt/libmcrypt/libmcrypt-2.5.7.tar.gz
   [root@localhost ~]# tar -zxvf libmcrypt-2.5.7.tar.gz
   [root@localhost ~]# cd libmcrypt-2.5.7
   [root@localhost ~]# ./configure
   [root@localhost ~]# make && make install
   ```

2. 脚本安装php

   ```sh
   [root@localhost php-5.4.35]# ./configure --prefix=/usr/local/php --with-config-file-path=/usr/local/php/etc --with-iconv-dir --with-freetype-dir --with-jpeg-dir --with-png-dir --with-zlib --with-libxml-dir=/usr --enable-xml --disable-rpath --enable-bcmath --enable-shmop --enable-sysvsem --enable-inline-optimization --with-curl --with-curlwrappers --enable-mbregex --enable-fpm --enable-mbstring --with-mcrypt --enable-ftp --with-gd --enable-gd-native-ttf --with-openssl --with-mhash --enable-pcntl --enable-sockets --with-xmlrpc --enable-zip --enable-soap --with-gettext --with-mysql=mysqlnd --with-mysqli=mysqlnd --with-pdo-mysql=mysqlnd
   ```

3. 编译php

   ```sh
   [root@localhost php-5.4.35]# make && make install
   ```

4. 调整配置文件

   ```sh
   [root@localhost php-5.4.35]# cp php.ini-development  /usr/local/php/etc/php.ini
   [root@localhost php-5.4.35]# mv /usr/local/php/etc/php-fpm.conf.default /usr/local/php/etc/php-fpm.conf
   ```

   

# 安装Nginx

1. 检查是否已安装服务

   ```sh
   # 查看进程
   [root@localhost ~]# ps -ef |grep nginx
   # 查看与nginx相关文件
   [root@localhost ~]# find / -name nginx
   # 卸载依赖
   [root@localhost ~]# yum remove -y nginx
   ```

2. 安装依赖包

   ```sh
   [root@localhost ~]# yum -y install gcc pcre pcre-devel zlib zlib-devel openssl openssl-devel
   ```

3. 下载安装包

   ```sh
   [root@localhost ~]# wget https://nginx.org/download/nginx-1.21.6.tar.gz
   [root@localhost ~]# tar -zxvf nginx-1.21.6.tar.gz
   [root@localhost ~]# cd nginx-1.21.6
   ```

4. 执行编译脚本

   ```sh
   [root@localhost nginx-1.21.6]# ./configure --prefix=/usr/local/nginx --with-http_stub_status_module --with-http_ssl_module
   
   [root@localhost nginx-1.21.6]# make && make install
   ```

5. 启动nginx

   ```sh
   [root@localhost nginx-1.21.6]# cd /usr/local/nginx/sbin
   [root@localhost sbin]# ./nginx
   
   
   # 停止服务
   [root@localhost sbin]# ./nginx -s stop
   
   
   # 注意
   如果出现nginx: [error] open() "/usr/local/nginx/logs/nginx.pid" failed (2: No such file or directory)
   
   1.确认安装路径
   2.创建nginx.pid文件
   3.查看主进程pid
     ps aux |grep nginx
   4.将pid输入文件
     echo pid > /usr/local/nginx/logs/nginx.pid
   ```

# php连接memcached

## 安装memcached扩展

1. 下载

   ```
   [root@localhost localhost]# cd /usr/local/src/
   [root@localhost src]# wget  https://pecl.php.net/get/memcache-2.2.3.tgz
   ```

2. 调整源码包

   ```sh
   [root@localhost src]# tar zxvf memcache-2.2.3.tgz 
   [root@localhost src]# cd memcache-2.2.3/
   [root@localhost memcache-2.2.3]# /usr/local/php/bin/phpize
   
   # 注意
   如果出现autoconf报错则安装即可
   yum install -y autoconf
   ```

3. 执行编译脚本

   ```sh
   [root@localhost memcache-2.2.3]# ./configure --with-php-config=/usr/local/php/bin/php-config
   ```

4. 编译

   ```sh
   [root@localhost memcache-2.2.3]# make && make install
   ```

5. 修改配置文件

   ```sh
   [root@localhost memcache-2.2.3]# vim  /usr/local/php/etc/php.ini
   # 随机位置添加（但不限于php声明外）
   extension=memcache.so
   ```

6. 检查配置文件

   ```sh
   [root@localhost memcache-2.2.3]# /usr/local/php/bin/php -m |grep memcache
   ```

7. 测试

   ```sh
   [root@localhost memcache-2.2.3]# cat 1.php
   111
   [root@localhost memcache-2.2.3]# /usr/local/php/bin/php 1.php start
   111
   # 注意：
   1.路径为当前目录下
   ```

   



# memcached配置session

1. 修改php配置文件

   ```sh
   [root@localhost nginx-1.21.6]# vim /usr/local/php/etc/php.ini
   # 找到下面两端，修改原位置即可
   session.save_handler = memcache
   session.save_path ="tcp://192.168.6.11:11211"
   
   
   # 注意
   1.save_path为本机ip
   ```

2. 添加网页文件

   ```sh
   [root@localhost nginx-1.21.6]# vim  /usr/local/nginx/html/session.php
   <?php
           session_start();
           $_SESSION['name']='test';
           echo session_id()."<br/>";
           echo $_SESSION['name'];
   ?>
   
   ```

3. 测试

   ```sh
   [root@localhost html]# /usr/local/php/bin/php session.php start
   2hcc3v12qi8sjxcmas8812ksad
   
   [root@localhost html]# telnet 127.0.0.1 11211
   
   get 2hcc3v12qi8sjxcmas8812ksad
   VALUE 2hcc3v12qi8sjxcmas8812ksad 0 16
   name|s:4:"test";
   END
   ```

   