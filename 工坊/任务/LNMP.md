# Mysql

## Mysql(5.6.45)

# 下载

1. 下载解压

   ```
   cd /usr/local/src
   wget -c -t 0 https://dev.mysql.com/get/Downloads/MySQL-5.6/mysql-5.6.45-linux-glibc2.12-x86_64.tar.gz 
   
   tar -zxvf mysql-5.6.45-linux-glibc2.12-x86_64.tar.gz
   ```

2. 建立用户并配置文件权限

   ```
   useradd -s /sbin/nologin mysql
   mkdir -p /data/mysql
   chown -R mysql.mysql /data/mysql
   
   # 检测是否有mysql目录，如果没有则不执行
   [ -d /usr/local/mysql ] && mv /usr/local/mysql /usr/local/mysql_old
   
   mv mysql-5.6.45-linux-glibc2.12-x86_64 /usr/local/mysql
   
   ```

3. 安装

   ```
   cd /usr/local/mysql
   
   # --user表示定义数据库的以哪个用户的身份运
   # --datadir表示定义数据库的安装目录
   ./scripts/mysql_install_db --user=mysql --datadir=/data/mysql
   
   cp support-files/my-default.cnf /etc/my.cnf
   cp support-files/mysql.server /etc/init.d/mysql
   
   chmod 755 /etc/init.d/mysql
   ```

4. 修改配置文件

   ```
   vim /etc/init.d/mysql
   
   datadir=/data/mysql
   ```

5. 设置自启

   ```
   chkconfig mysql on
   ```

6. 验证

   ```
   cd /etc/init.d
   ./mysql start
   ```

7. 配置环境变量

   ```
   vim /etc/profile
   # 执行文件在/usr/local/mysql/bin下
   export PATH=/usr/local/mysql/bin:/usr/local/mysql/lib:$PATH
   
   # 生效
   source /etc/profile
   ```

8. 设置密码

   ```
   vim /etc/my.cnf
   
   skip-grant-tables
   
   # 直接回车
   mysql -uropt =p
   
   alter user 'root'@'localhost' identified by '123456';
   或
   set password for 'root'@'localhost'=password('1qaz!QAZ');   修改密码
   
   flush privileges;
   ```
   
   



# PHP

## 下载

1. 下载

   ```
   # cd /usr/local/src
   
   # wget http://nginx.org/download/nginx-1.10.3.tar.gz
   # tar -zxvf php-7.1.4.tar.gz
   ```

2. 下载依赖包

   ```
   # yum install -y gcc
   # yum install -y libxml2
   # yum install -y libxml2-devel
   # yum install -y openssl openssl-devel
   # yum install -y bzip2 bzip2-devel
   # yum install -y libpng libpng-devel
   # yum install -y freetype freetype-devel
   # yum install -y epel-release
   # yum install -y libmcrypt-devel
   # yum -y install libjpeg-devel
   # yum install -y libcurl-devel
   
   ```

3. 创建用户

   ```
   # useradd -s /sbin/nologin php-fpm
   ```

4. 编译

   ```
   cd /php-7.1.4
   ./configure --prefix=/usr/local/php-fpm --with-config-file-path=/usr/local/php-fpm/etc --enable-fpm --with-fpm-user=php-fpm --with-fpm-group=php-fpm --with-mysql=/usr/local/mysql --with-mysql-sock=/tmp/mysql.sock --with-libxml-dir --with-gd --with-jpeg-dir --with-png-dir --with-freetype-dir --with-iconv-dir --with-zlib-dir --with-mcrypt --enable-soap --enable-gd-native-ttf --enable-ftp --enable-mbstring --enable-exif --disable-ipv6 --with-pear --with-curl --with-openssl
   
   make && make install
   
   cp php.ini-production /usr/local/php-fpm/etc/php.ini
   
   
   ```

5. 修改/usr/local/php-fpm/etc/php-fpm.conf

   ```
   vim /usr/local/php-fpm/etc/php-fpm.conf
   
   [global]
   pid = /usr/local/php-fpm/var/run/php-fpm.pid
   error_log = /usr/local/php-fpm/var/log/php-fpm.log
   [www]
   listen = /tmp/php-fcgi.sock
   listen.mode = 666
   user = php-fpm
   group = php-fpm
   pm = dynamic
   pm.max_children = 50
   pm.start_servers = 20
   pm.min_spare_servers = 5
   pm.max_spare_servers = 35
   pm.max_requests = 500
   rlimit_files = 1024
   
   # 验证配置文件是否成功
   /usr/local/php-fpm/sbin/php-fpm -t
   tset is successful
   ```

6. 设置配置文件

   ```
   cp /usr/local/src/php-7.1.4/sapi/fpm/init.d.php-fpm /etc/init.d/php-fpm
   chmod 755 /etc/init.d/php-fpm
   service php-fpm start
   chkconfig php-fpm on
   
   ```

7. 测试

   ```
   ps aux | grep php-fpm
   ```

   



# Nginx

## 下载

1. 下载

   ```
   cd /usr/local/src
    tar zxf nginx-1.10.3.tar.gz 
   ```

2. 编译

   ```
   cd nginx-1.10.3/
   ./configure --prefix=/usr/local/nginx
   make && make install
   vi /etc/init.d/nginx
   
   
   #!/bin/bash
   # chkconfig: - 30 21
   # description: http service.
   # Source Function Library
   . /etc/init.d/functions
   # Nginx Settings
   NGINX_SBIN="/usr/local/nginx/sbin/nginx"
   NGINX_CONF="/usr/local/nginx/conf/nginx.conf"
   NGINX_PID="/usr/local/nginx/logs/nginx.pid"
   RETVAL=0
   prog="Nginx"
   start() 
   {
   echo -n $"Starting $prog: "
   mkdir -p /dev/shm/nginx_temp
   daemon $NGINX_SBIN -c $NGINX_CONF
   RETVAL=$?
   echo
   return $RETVAL
   }
   stop() 
   {
   echo -n $"Stopping $prog: "
   killproc -p $NGINX_PID $NGINX_SBIN -TERM
   rm -rf /dev/shm/nginx_temp
   RETVAL=$?
   echo
   return $RETVAL
   }
   reload()
   {
   echo -n $"Reloading $prog: "
   killproc -p $NGINX_PID $NGINX_SBIN -HUP
   RETVAL=$?
   echo
   return $RETVAL
   }
   restart()
   {
   stop
   start
   }
   configtest()
   {
   $NGINX_SBIN -c $NGINX_CONF -t
   return 0
   }
   case "$1" in
   start)
   start
   ;;
   stop)
   stop
   ;;
   reload)
   reload
   ;;
   restart)
   restart
   ;;
   configtest)
   configtest
   ;;
   *)
   echo $"Usage: $0 {start|stop|reload|restart|configtest}"
   RETVAL=1
   esac
   exit $RETVAL
   
   ```

3. 赋权

   ```
   chmod 755 /etc//init.d/nginx 
   chkconfig --add nginx
   chkconfig nginx on
   > /usr/local/nginx/conf/nginx.conf
   
   # 修改配置文件
   vim /usr/local/nginx/conf/nginx.conf
   
   user nobody nobody;
   worker_processes 2;
   error_log /usr/local/nginx/logs/nginx_error.log crit;
   pid /usr/local/nginx/logs/nginx.pid;
   worker_rlimit_nofile 51200;
   events
   {
   use epoll;
   worker_connections 6000;
   }
   http
   {
   include mime.types;
   default_type application/octet-stream;
   server_names_hash_bucket_size 3526;
   server_names_hash_max_size 4096;
   log_format combined_realip '$remote_addr $http_x_forwarded_for [$time_local]'
   ' $host "$request_uri" $status'
   ' "$http_referer" "$http_user_agent"';
   sendfile on;
   tcp_nopush on;
   keepalive_timeout 30;
   client_header_timeout 3m;
   client_body_timeout 3m;
   send_timeout 3m;
   connection_pool_size 256;
   client_header_buffer_size 1k;
   large_client_header_buffers 8 4k;
   request_pool_size 4k;
   output_buffers 4 32k;
   postpone_output 1460;
   client_max_body_size 10m;
   client_body_buffer_size 256k;
   client_body_temp_path /usr/local/nginx/client_body_temp;
   proxy_temp_path /usr/local/nginx/proxy_temp;
   fastcgi_temp_path /usr/local/nginx/fastcgi_temp;
   fastcgi_intercept_errors on;
   tcp_nodelay on;
   gzip on;
   gzip_min_length 1k;
   gzip_buffers 4 8k;
   gzip_comp_level 5;
   gzip_http_version 1.1;
   gzip_types text/plain application/x-javascript text/css text/htm
   application/xml;
   server
   {
   listen 80;
   server_name localhost;
   index index.html index.htm index.php;
   root /usr/local/nginx/html;
   location ~ \.php$
   {
   include fastcgi_params;
   fastcgi_pass unix:/tmp/php-fcgi.sock;
   fastcgi_index index.php;
   fastcgi_param SCRIPT_FILENAME /usr/local/nginx/html$fastcgi_script_name;
   }
   }
   }
   
   /usr/local/nginx/sbin/nginx -t
   ```

4. 测试

   ```
   service nginx start
   ps aux| grep nginx
   
   vim /usr/local/nginx/html/2.php
   <?php
     echo "111";
   ?>
   
   
   curl localhost/2.php
   
   ```

   

## 配置

### 虚拟主机

1. 修改nginx配置文件

   ```
   vim /usr/local/nginx/conf/nginx.conf
   
   最后一行}前加一行配置：
   # 在/usr/local/nginx/conf/host下面的所有以.conf结尾的文件都被加载
   include vhost/*.conf;
   
   ```

2. 创建目录

   ```
   mkdir /usr/local/nginx/conf/vhost
   cd /usr/local/nginx/conf/vhost
   
   
   ```

3. 配置vhost文件

   ```
   vim default.conf
   
   server
   {
       listen 80 default_server;
       server_name aaa.com;
       index index.html index.htm index.php;
       root /data/nginx/default;
   }
   
   # 测试
    /usr/local/nginx/sbin/nginx -t
    
   # 重启
     /usr/local/nginx/sbin/nginx -s reload
     
   ```

4. 创建虚拟主机目录

   ```
   mkdir -p /data/nginx/default
   touch /data/nginx/default/index.html
   # 创建索引页
   echo "default_server" > /data/nginx/default/index.html
   ```

5. 测试

   ```
   # curl -x127.0.0.1:80 aaa.com
   //访问aaa.com
   default_server
   # curl -x127.0.0.1:80 1212.com
   //访问一个没有定义过的域名，也会访问aaa.com
   default_server
   ```



### 用户认证

1. 配置

   ```
   cd /usr/local/nginx/conf/vhost
   vim test.com.conf
   
   server
   {
       listen 80;
       server_name test.com;
       index index.html index.htm index.php;
       root /data/nginx/test.com;
       location /
       {
       auth_basic "Auth";
       #打开认证
       auth_basic_user_file /usr/local/nginx/conf/htpasswd;
       #指定用户密码文件
       }
   }
   ```

2. 安装httpd

   ```
   yum install -y httpd
   ```

3. 设置用户密码

   ```
   htpasswd -c /usr/local/nginx/conf/htpasswd lnmp_test
   new password：
   re-type new password：
   Adding password for user lnmp_test
   
   ```

4. 重启

   ```
   /usr/local/nginx/sbin/nginx -s reload
   ```

5. 配置http

   ```
   mkdir /data/nginx/test.com
   echo "test.com" > /data/nginx/test.com/index.html
   ```

6. 测试

   ```
   curl -I -x127.0.0.1:80 test.com -ulnmp_test:000000 -I
   状态码200
   
   ```



#### 附属

针对目录做用户认证则要修改location后面的路径

```
server
{
    listen 80;
    server_name test.com;
    index index.html index.htm index.php;
    root /data/nginx/test.com;
    location /admin/
    {
    auth_basic "Auth";
    #打开认证
    auth_basic_user_file /usr/local/nginx/conf/htpasswd;
    #指定用户密码文件
    }
}

```



### 域名重定向

1. 配置

   ```
   vim /usr/local/nginx/conf/vhost/test.com.conf
   
   
   server
   {
       listen 80;
       server_name test.com test1.com test2.com;
       #是server_name后面可以跟多个域名
       index index.html index.htm index.php;
       root /data/nginx/test.com;
   
       if ($host != 'test.com' ){
           rewrite ^(.*)$ http://test.com/$1 permanent;
           #permanent为永久重定向，相当于httpd的R=301
       }
   }
   
   ```

2. 验证配置文件是否有误

   ```
   /usr/local/nginx/sbin/nginx -t
   /usr/local/nginx/sbin/nginx -s reload
   
   
   ```

3. 验证

   ```
   curl -x127.0.0.1:80 test1.com/123.txt -I
   
   状态码301
   ```

   

### Nginx的访问日志

1. 查看nginx的日志文件

   ```
   grep -A2 log_format /usr/local/nginx/conf/nginx.conf
   
   log_format combined_realip 
   '$remote_addr 
   $http_x_forwarded_for [$time_local]'
   ' $host "$request_uri" $status'
   ' "$http_referer" "$http_user_agent"';
   
   combined_realip为日志格式名字
   $remote_addr为网站的用户的出口IP；
   $http_x_forwarded_for 为代理服务器的IP，如果使用了代理，则会记录IP
   $time_local为当前时间；
   $host为主机名；
   $request_uri为访问的URL地址
   $status为状态码，
   $http_referer为referer地址，
   $http_user_agent为user_agent
   
   ```

2. 修改配置文件

   ```
   # vi /usr/local/nginx/conf/vhost/test.com.conf
   server
   {
       listen 80;
       server_name test.com;
       index index.html index.htm index.php;
       root /data/nginx/test.com;
       if ($host != 'test.com' ){
               rewrite ^/(.*)$ http://test.com/$1 permanent;
       }
           access_log /tmp/1.log combined_realip;
   }#使用access_log来指定日志的存储路径，最后面为日志的格式名字
   
   ```

3. 检测配置文件是否有误

   ```
   # /usr/local/nginx/sbin/nginx -t
   # /usr/local/nginx/sbin/nginx -s reload
   ```

4. 测试

   ```
   # curl -x127.0.0.1:80 test.com/111
   状态码404
   #cat /tmp/1.log
   127.0.0.1 ~~~~~~~~~~~~~~~~~
   
   ```

   

#### 日志切割

Nginx的日志很简单，不像httpd还带切割工具，在下面提供一个Nginx的日志切割脚本

```
vim /usr/local/sbin/nginx_log_rotate.sh
#!/bin/bash
##假设nignx的日志存放路径为/data/logs/
d=`date -d "-1 day" +%Y%m%d`
logdir="/usr/local/nginx/logs"
nginx_pid="/usr/local/nginx/logs/nginx.pid"
cd $logdirfor log in `ls *.log`
do
mv $log $log-$d
done
/bin/kill -HUP `cat $nginx_pid`

```



### 配置静态文件（不记录日志并添加过期时间）

1. 设置配置文件

   ```
   vim /usr/local/nginx/conf/chost/test.com.conf
   
   server
   {
       listen 80;
       server_name test.com test1.com test2.com;
       index index.html index.htm index.php;
       root /data/nginx/test.com;
       if ($host != 'test.com' ) {
           rewrite ^/(.*)$ http://test.com/$1 permanent;
       }
       location ~ .*\.(gif|jpg|jpeg|png|bmp|swf)$
       {
       expires 7d;
       access_log off;
       }
       location ~ .*\.(js|css)$
       {
       expires 12h;
       }
       access_log /tmp/1.log combined_realip;
   }
   
   ```

2. 创建测试文件

   ```
   # /usr/local/nginx/sbin/nginx -t
   nginx: the configuration file /usr/local/nginx/conf/nginx.conf syntax is ok
   nginx: configuration file /usr/local/nginx/conf/nginx.conf test is successful
   //创建js文件
   # echo "11111" > /data/nginx/test.com/1.js
   //创建jpg文件
   # echo "22222" > /data/nginx/test.com/2.jpg
   //创建一个对比的文件
   # touch /data/nginx/test.com/1.jss
   
   
   ```

3. 测试

   ```
   # curl -I -x127.0.0.1:80 test.com/1.js
   状态码200
   # curl -I -x127.0.0.1:80 test.com/2.jpg
   状态码200
   # curl -I -x127.0.0.1:80 test.com/1.jss
   状态码200
   # cat /tmp/1.log
   
   ```



### 防盗链

1. 修改配置文件

   ```
   vi /usr/local/nginx/conf/vhost/test.com.conf
   
   
   
   # 服务器获取用户提交的网站地址，和真正的服务器地址比较，如果不是则视为盗链
   server
   {
       listen 80;
       server_name test.com test1.com test2.com;
       index index.html index.htm index.php;
       root /data/nginx/test.com;
       if ($host != 'test.com' ) {
          rewrite ^/(.*)$ http://test.com/$1 permanent;
       }
       location ~* ^.+\.(gif|jpg||png|swf|flv|rar|zip|doc|pdf|gz|bz2|jpeg|bmp|xls)$
       {
        valid_referers none blocked server_names *.test.com;
        if ($invalid_referer) {
            return 403;
        }
   } 
   }
   ```
2. 重启并测试
   
   ```
   /usr/local/nginx/sbin/nginx -t
   /usr/local/nginx/sbin/nginx -s reload
   ```
   
   
   

### 访问控制

1. 修改配置文件

   ```
   # vi /usr/local/nginx/conf/vhost/test.com.conf
   
   
   
   # 设置/data/nginx/test.com下的admin目录
   server
   {
       listen 80;
       server_name test.com test1.com test2.com;
       index index.html index.htm index.php;
       root /data/nginx/test.com;
       #使访问admin目录下只允许192.168.188.1和127.0.0.1访问
       location /admin/
      {
         
           allow 192.168.188.1;
           allow 127.0.0.1;
           deny all;
       }
   }
   ```

2. 测试配置文件是否有误

   ```
   /usr/local/nginx/sbin/nginx -t
   ```

3. 测试

   ```
   # curl -x127.0.0.1:80 test.com/admin/1.html
   123
   # curl -x192.168.188.128:80 test.com/admin/1.html
   状态码403
   
   ```



### Nginx解析PHP

#### 简介

1. php-fpm的出现是为了**更好的管理php-fastcgi**而实现的一个程序
2. php-fastcgi只是一个**cgi程序**，只会**解析php请求**，并且返回结果，**不会管理**（所有出现了php-fpm）
3. 所以要php-fpm就是来**管理启动一个master进程和多个worker进程**的程序，php-fpm会创建一个主进程，用于控制何时以及如何将http请求转发给一个或多个子进程处理
4. php-fpm主进程还控制着什么时候**创建**（处理web应用更多的流量）和**销毁**（子进程运行时间太久或不再需要）php子进程，php-fpm进程池中的每个进程存在的时间都比单个http请求长，可以处理10、50、100、500或更多的http请求

1. 修改配置文件

   ```
   # vi /usr/local/nginx/conf/vhost/test.com.conf
   
   server
   {
       listen 80;
       server_name test.com test1.com test2.com;
       index index.html index.htm index.php;
       root /data/nginx/test.com;
       if ($host != 'test.com' ) {
           rewrite ^/(.*)$ http://test.com/$1 permanent;
       }
      location ~ \. php$
       {
       #fastcgi_pass用来指定php-fpm的地址
       include fastcgi_params;
       fastcgi_pass unix:/tmp/php-fcgi.sock;
       fastcgi_index index.php;
       fastcgi_param SCRIPT_FILENAME           /data/nginx/test.com$fastcgi_script_name;
     }
     access_log /tmp/1.log combined_realip;
   }
   
   
   ```

2. php-fpm

   ```
   php-fpm 的配置文件都放在/usr/local/php-fpm/etc/php-fpm php-fpm.conf内
   Nginx可以配置多个主机，php-fpm也可以配置多个pool
   首先对php-fpm.conf做一个修改
   
    php-fpm的Pool池是支持定义多个pool的。每个pool可以监听不同的sock、tcp/ip。那nginx有好几个站点，每个站点可以使用一个pool。这样做的好处是当其中的一个php502（可能是php资源不够）了。如果所有的网站使用同一个池，那其中一个网站发生一些故障，比如程序员写的一些程序有问题，就会把php资源耗尽，这样的结果就是其他站点的php也会502。所以有必要把每一个站点隔离开，每个pool的名字要唯一。
   
   vim /usr/local/php-fpm/etc/php-fpm.conf
   
   [global]
   pid = /usr/local/php-fpm/var/run/php-fpm.pid
   error_log = /usr/local/php-fpm/var/log/php-fpm.log
   # include比较特殊，后面路径必须写上etc目录
   include = etc/php-fpm.d/*.conf
   
   
   # 创建配置文件目录和子配置文件
   # mkdir /usr/local/php-fpm/etc/php-fpm.d
   # cd /usr/local/php-fpm/etc/php-fpm.d
   
   
   # vim www.conf
   
   [www]
   listen = /tmp/www.sock
   listen.mode=666
   user = php-fpm
   group = php-fpm
   pm = dynamic
   pm.max_children=50
   pm.start_servers=20
   pm.min_spare_servers=5
   pm.max_spare_servers=35
   pm.max_requests=500
   rlimit_files=1024
   
   # 编写lmp_test.conf
   
   [aming]
   listen = /tmp/aming.sock
   listen.mode=666
   user = php-fpm
   group = php-fpm
   pm = dynamic
   pm.max_children=50
   pm.start_servers=20
   pm.min_spare_servers=5
   pm.max_spare_servers=35
   pm.max_requests=500
   rlimit_files=1024
   
   
   # 验证
   # /usr/local/php-fpm/sbin/php-fpm -t
   然后来重启一下php-fpm服务
   # /etc/init.d/php-fpm restart
   再来查看一下/tmp/*.sock
   # ls /tmp/*.sock
   
   ```

3. php-fpm的慢执行日志

   ```
   # vim /usr/local/php-fpm/etc/php-fpm.d/www.conf
   
   
   #第一行定义超时时间，即超过一秒就会被记录日志
   request_slowlog_timeout =1
   #第二行定义慢执行日志的路径和名字
   slowlog=/usr/local/php-fpm/var/log/www-slow.log
   
   ```

4. php-fpm定义open_basedir

   ```
   open_basedir目的就是安全，httpd可以针对每个虚拟机设置一个open_basedir
   php-fpm同样也可以对不同的pool设置的不同的open_basedir
   
   # vim /usr/local/php-fpm/etc/php-fpm.d/lnmp_test.conf
   
   # 最后一行加入
   php_admin_value[open_basedir]=/data/www/:/tmp/
   ```

5. php-fpm进程管理

   ```
   #第一行定义php-fpm的子进程启动模式，dynamic为动态模式
   pm=dynamic
   #第二行定义动态增加或减少的量不会超过设定的值
   pm.max_children=50
   #第三行是针对dynamic模式，他定义php-fpm服务在启动服务时产生的子进程数量
   pm.min_spare_servers=5
   #第四行是针对dynamic模式，他定义空闲时子进程数最少数量，若达到数值会派生新的子进程
   pm.max_spare_servers=35
   #第五行是针对dynamic模式，他定义空闲时子进程数最多数量，若高于数值会开始清理空闲的子进程
   pm.max_requests=500
   
   ```

   

# LNMP+WordPress部署

## 简介

1. WordPress是使用**PHP语言开发**的博客平台，用户可以在支**持PHP和MySQL数据库**的服务器上架设属于自己的网站。也可以把 WordPress当作一个内容管理系统（CMS）来使用。

2. WordPress是一款**个人博客系统**，并逐步演化成一款**内容管理系统**软件，它是使用PHP语言和MySQL数据库开发的，用户可以在支持 PHP 和 MySQL数据库的服务器上使用自己的博客。

3. WordPress有许多第三方开发的免费模板，安装方式简单易用。不过要做一个自己的模板，则需要你有一定的专业知识。比如你至少要懂的**标准通用标记语言**下的一个应用HTML代码、CSS、PHP等相关知识。

4. WordPress官方支持中文版，同时有爱好者开发的第三方中文语言包，如wopus中文语言包。WordPress拥有成千上万个各式插件和不计其数的主题模板样式。 

## 部署

### 安装nginx

1. 设置yum源

   ```
   vi /etc/yum.repos.d/nginx.repo
   
   [nginx]
   name = nginx repo
   baseurl = https://nginx.org/packages/mainline/centos/7/$basearch/
   gpgcheck = 0
   enabled = 1
   
   ```

2. 安装

   ```
   yum install -y nginx
   ```

3. 修改default.conf文件

   ```
    vi /etc/nginx/conf.d/default.conf
    
    server {
    listen 80;
    root /usr/share/nginx/html;
    server_name localhost;
    #charset koi8-r;
    #access_log /var/log/nginx/log/host.access.log main;
    #
    location / {
    index index.php index.html index.htm;
    }
    #error_page 404 /404.html;
    #redirect server error pages to the static page /50x.html
    #
    error_page 500 502 503 504 /50x.html;
    location = /50x.html {
    root /usr/share/nginx/html;
    }
    #pass the PHP scripts to FastCGI server listening on 127.0.0.1:9000
    #
    location ~ .php$ {
    fastcgi_pass 127.0.0.1:9000;
    fastcgi_index index.php;
    fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
    include fastcgi_params;
    }
   }
   
   ```

4. 设置启动和自启

   ```
   systemctl start nginx
   systemctl enable nginx
   ```

5. 浏览器访问虚拟机ip



### 安装Mariadb

1. 查看是否安装

   ```
   rpm -qa |grep -i mariadb
   
   
   # 如果有就删除
   yum remove -y mariadb-libs
   ```

2. 设置yum源

   ```
   vi /etc/yum.repos.d/MariaDB.repo
   
   [mariadb]
   name = MariaDB
   baseurl = https://mirrors.cloud.tencent.com/mariadb/yum/10.4/centos7-amd64
   gpgkey=https://mirrors.cloud.tencent.com/mariadb/yum/RPM-GPG-KEY-MariaDB
   gpgcheck=1
   
   ```

3. 下载

   ```
   yum -y install  MariaDB-client MariaDB-server
   ```

4. 启动并自启

   ```
   systemctl start mariadb
   systemctl enable mariadb
   
   ```

5. 测试

   ```
   mysql
   ```

   



### 安装PHP

1. 更新yum中php软件源

   ```
   rpm -Uvh https://mirrors.cloud.tencent.com/epel/epel-release-latest-7.noarch.rpm
   
   rpm -Uvh https://mirror.webtatic.com/yum/el7/webtatic-release.rpm
   
   ```

2. 下载

   ```
   yum -y install mod_php72w.x86_64 php72w-cli.x86_64 php72w-common.x86_64 php72w-mysqlnd php72w-fpm.x86_64
   ```

3. 启动并自启

   ```
   systemctl start php-fpm
   systemctl enable php-fpm
   ```

4. 创建文件

   ```
   vim /usr/share/nginx/html/index.php
   
   <?php
   phpinfo();
   ?>
   ```

5. 重启

   ```
   systemctl restart nginx
   ```

6. 测试

   ```
   ip/index.php
   ```





### 搭建Wordpress

1. 进入mysql服务器内创建一个名为wordpress的数据库并授权

   ```
   mysql -uroot -p000000
   
   # 创建数据库
   create database wordpress;
   # 赋权
   grant all privileges on *.* to "wordpress"@"localhost" identified by '000000';
   # 更新权限
   flush privileges;
   
   # 重启
   systemctl restart mariadb
   ```

2. 删除nginx的html下的所有文件

   ```
   rm -rf /usr/local/nginx/html/*
   ```

3. 上传解压wordpress安装包

4. 复制系统文件到网页解析目录下

   ```
   # 强制复制wordpress下的所有东西到/usr/share/nginx/html/下
   cp -rf wordpress/*   /usr/share/nginx/html/
   
   cd /usr/share/nginx/html/
   ```
   
5. 部署wordpress

   ```
   # 备份
   cp wp-config-sample.php wp-config.php
   vim wp-config.php
   
   21 // ** MySQL
    22 /** WordPress
    23 define('DB_NAME', 'wordpress');
    24
    25 /** MySQL数据库⽤户名 */
    26 define('DB_USER', 'wordpress');
    27
    28 /** MySQL数据库密码 */
    29 define('DB_PASSWORD', '000000');
    30
    31 /** MySQL主机 */
    32 define('DB_HOST', 'localhost');
    33
    34 /** 创建数据表时默认的⽂字编码 */
    35 define('DB_CHARSET', 'utf8');
    
   ```

6. 赋权

   ```
   chmod -R 777 /usr/share/nginx/html/
   ```

7. 查看端口

   ```
   netstat -ntlp 
   ```

8. 打开浏览器输入虚拟机ip



   





