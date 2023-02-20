LAMP(Linux+Apache+Mysql+PHP)

Wget http://mirrors.sohu.com/mysql/MySQL-5.6/mysql-5.6.35-linux-glibc2.5-x86_64.tar.gz

# 安装mysql（编译）

1. 下载rpm包

   ```
   
   ```

2. 解压

   ```
   tar -xvf mysql-8.0.13-linux-glibc2.12-x86_64.tar.xz
   ```

3. 将其剪切到/var/local，并重命名为mysql

   ```
   mv mysql-8.0.13-linux-glibc2.12-x86_64  /usr/local/
   mv mysql-8.0.13-linux-glibc2.12-x86_64  mysql
   ```

4. 删除centos自带的mariadb

   ```
   rpm -qa | grep mariadb
   #删除对应的数据库
   rpm -e 包名
   ```

5. 添加命令到系统变量

   ```
   vim /etc/profile
   #找到export标记
   export PATH=$PATH:/usr/local/mysql/bin
   export PATH=$PATH:/usr/local/mysql/support-files
   
   #生效
   source /etc/profile
   ```

6. 创建用户以及用户组

   ```
   groupadd mysql
   useradd -g mysql mysql
   ```

7. 授权

   ```
   chown -R mysql.mysql /usr/local/mysql
   mkdir /usr/local/mysql/data
   ```

8. 在mysql下初始化

   ```
   mysqld --initialize --user=mysql --basedir=/usr/local/mysql --datadir=/usr/local/mysql/data
   
   #初始化后里面有数据库密码信息
   A temporary password is generated for root@localhost: ?ydDe--Nl1u8
   ```

9. 启动服务

   ```
      自启动方式：
   #拷贝配置文件mysql.server
   [root@localhost mysql]# cp support-files/mysql.server  /etc/init.d/mysqld
   #修改mysqld的配置文件
   basedir=/usr/local/mysql
   datadir=/usr/local/mysql/data
   #设置自启
   chkconfig --add mysqld
   chkconfig  mysqld on


   cd /etc/init.d/
   ./mysqld start
   
   
   

   ```

10. 登录

    ```
    mysql -uroot -p
    
    输入先前提示密码
    ```

11. 修改密码

    ```
    alter user 'root'@'localhost' identified by '123456';
    
    ```
    
12. 补充

    ```
    mysql> set password for 'root'@'localhost'=password('1qaz!QAZ');   修改密码
    mysql> grant all privileges on *.* to 'root'@'%' identified by '1qaz!QAZ' with grant option;   开放远程登录
    mysql> flush privileges; 保存然后退出 
    ```

    

# 安装apache

## 2.1 yum安装

1. 查看是否有原装apache

   ```
   rpm -qa | grep httpd
   
   卸载：
   rpm -e 软件包名
   ```

2. 下载

   ```
   yum -y install httpd
   ```

3. 查看apache工作状态

   ```
   systemctl status httpd
   ```

4. 激活apache

   ```
   systemctl start httpd
   ```

5. 修改配置文件(找到 #ServerName www.example.com:80 这一行，把它修改成： ServerName localhost:80)

   ```
   vim /etc/httpd/conf/httpd.conf
   ```

6. 查看执行是否正确

   ```
   httpd -t
   
   正常：
   SyntaxOK
   ```

7. 重载apache配置文件（不关闭情况下）

   ```
   systemctl reload httpd
   ```

8. 开机自启

   ```
   systemctl enable httpd
   ```

9. 测试

   ```
   本机访问localhost
   ```






**配置文件默认在 /etc/httpd 目录下：**

/etc/httpd/conf.d：自己设定apache的参数信息，里面的文件应以xxx.conf结尾的文件，当apache启动的时候，这个文件会自动被读入到主要配置文件当中；

/etc/httpd/modules：存放httpd的模块；

/etc/httpd/log：记录apache的所有的日志；

**/etc/httpd/conf/httpd.conf**：配置Apache主要权限和功能的文件，是最重要的配置文件；

**etc/init.d/httpd** ：启动文件；

 

**存放网页的文件默认在/var/www 目录下：**

**/var/www/html**：首页文件存放的目录（/etc/httpd/conf/httpd.conf中默认的目录 DocumentRoot=/var/www/html）；

/var/www/error：错误信息处理的文件(主机设置错误或者浏览器客户端要求的数据错误，浏览器上显示的错误信息)；

/var/www/icons：存放(apache、tomcat)网页的图片；

/var/www/cgi-bin:  存放可执行的CGI（网页程序）程序；

 

**/var/log/httpd/access_log**：默认访问Apache日志文件；

**/var/log/httpd/error_log**：错误日志文件；

 

/usr/sbin/apachectl：这个apachectl是文件，是apache的主要执行文件，它可以主动检测系统上的一些设置值，可以使启动apache时更简单，相当于apache 的一些管理工具；

/usr/bin/htpasswd：登陆网页的时候，会提示输入账号和密码，而apache本身就提供一个最基本的密码保护方式，该密码的产生就是通过这个指令实现的

**/usr/share/doc/httpd-2.4.6/httpd-vhosts.conf**:虚拟主机配置文件

## 2.2 编译安装

1. 准备

   ```
   ps -ef |grep httpd
   #如果有执行
   kill -9 pid（逐个删除）
   
   chkconfig --list httpd 
   #如果有执行
   chkconfig httpd off
   
   rpm -qa | grep httpd
   #如果有执行
   rpm -e 包全名
   
   yum list httpd
   #如果有执行
   yum remove httpd
   
   find / -name httpd
   #如果有执行
   rm -rf /xxx/xxx/httpd
   ```

2. 安装httpd、apr、apr-util、pcre

   ```
   必须按照gcc/gcc-c++
   
   gcc -v
   yum install gcc-c++
   
   ```

3. 创建目录

   ```
   mkdir /usr/local/apche/httpd
   mkdir /usr/local/apche/apr
   mkdir /usr/local/apche/apr-util
   mkdir /usr/local/apche/pcre
   ```

4. 解压

   ```
   tar -zxvf apr-1.5.2.tar.gz
   tar -zxvf apr-util-1.5.4.tar.gz
   tar -zxvf pcre-8.38.tar.gz
   tar -zxvf httpd-2.4.18.tar.gz
   ```

5. 编译

   ```
   cd apr-1.5.2
   ./configure --prefix=/usr/local/apache/apr
   make
   make install
   
   cd ../apr-util-1.5.4
   ./configure --prefix=/usr/local/apache/apr-util --with-apr=/usr/local/apache/apr/bin/apr-1-config
   make
    make instal
   
   cd ../pcre-8.38
   ./configure --prefix=/usr/local/apache/pcre --with-apr=/usr/local/apache/apr/bin/apr-1-config
   make
   make install
   
   在进行http编译前，设置pcre的环境变量，因为系统无法指定到pcre的bin目录
   vim /etc/profile
   export PATH=$PATH:/usr/local/apche/pcre/bin
   
   
   cd ../httpd-2.4.18
   ./configure --prefix=/usr/local/apache/httpd --with-pcre=/usr/local/apache/pcre --with-apr=/usr/local/apache/apr --with-apr-util=/usr/local/apache/apr-util
   make
   make install
   ```

6. 设置开机自启

   ```
   cp /usr/local/apche/httpd/bin/apachectl /etc/rc.d/init.d/httpd
   
   vim /etc/rc.d/init.d/httpd
   
   #!/bin/sh
   # chkconfig:35 61 61
   # description:Apache
   
   
   
   chkconfig --add httpd
   
   
   
   意义如下
   35：在3级别和5级别（级别见文末TIPS）启动httpd
   61：启动顺序为61号，S61
   61：关闭顺序为61号，K61
   当进行chkconfig --add httpd操作时，如果没有指定level那么就会来这个注释中取值
   
   1. chkconfig有0-6总共7个等级：
   0：表示关机 
   1：单用户模式 
   2：无网络连接的多用户命令行模式 
   3：有网络连接的多用户命令行模式 
   4：不可用 
   5：带图形界面的多用户模式 
   6：重新启动
   ```

7. 测试

   ```
   localhost
   
   is works！
   ```

   



# 安装php

## 3.1 yum安装

1. 修改yum源（yum下载）

   ```
   cd /etc/yum.repos.d
   
   mv CentOS-Base.repo CentOS-Base.repo.back
   
   wget http://mirrors.163.com/.help/CentOS7-Base-163.repo
   mv CentOS7-Base-163.repo CentOS-Base.repo
   ```

2. yum下载

   ```
   yum install -y php
   ```

3. 验证

   ```
   # cd /var/www/html
   # touch index.php
   # vi index.php
   写入<?php phpinfo(); ?>
   # systemctl restart httpd
   
   ```

4. 网址localhost/index.php

5. 注意，此方式是将apache和php一起下载



## 3.2 编译安装

1. 下载php

2. 解压

   ```
   tar -zxvf php.8.1.2.tar.gz
   ```

3. 安装依赖包

   ```
   # yum install -y libxml2-devel
   # yum install -y openssl openssl-devel
   # yum install -y bzip2 bzip2-devel
   # yum install -y libpng libpng-devel
   # yum install -y freetype freetype-devel
   # yum install -y epel-release
   # yum install -y libmcrypt-devel
   # yum install -y sqlite-devel
   ```

4. 编译安装

   ```
   cd php.8.1.2
   
   ./configure --prefix=/usr/local/php --with-apxs2=/usr/local/apache2.4/bin/apxs --with-config-file-path=/usr/local/php/etc --with-mysql=/usr/local/mysql --with-libxml-dir--with-gd --with-jpeg-dir --with-png-dir--with-freetype-dir --with-iconv-dir--with-zlib-dir --with-bz2 --with-openssl--with-mcrypt --enable-soap--enable-gd-native-ttf  --enable-mbstring--enable-sockets --enable-exif
   ```

5. httpd解析

   ```
   # vim /usr/local/apache/httpd/conf/httpd.con
   ```

6. 搜索ServerName，把ServerName www.example.com:80前#去掉

7. ```
   <Directory />
       AllowOverride none
       Require all denied
   </Directory>
   
   改成：
   <Directory />
       AllowOverride none  
       Require all granted
   </Directory>    //目的允许所有请求访问
   ```

8. 搜索AddType application/x-gzip .gz .tgz，在下面添加一行 AddType application/x-httpd-php .php

9. ```
   <IfModule dir_module>
       DirectoryIndex index.html 
   </IfModule>
   
   改成：
   <IfModule dir_module>
       DirectoryIndex index.html index.php
   </IfModule>
   ```

10. 测试

    ```
    /usr/local/apache/httpd/bin/apachectl -t
    //检验配置文件是否正确：Syntax OK
    curl localhost/1.php
    
    ```

    



# Apache配置

## 4.0 apachectl（/usr/local/apache/httpd/bin/apachectl）

```
apachectl(Apache control interface) 
参数：
fullstatus     显示服务器完整的状态信息。
graceful       重新启动 Apache 服务器，但不会中断原有的连接。用于修改了配置文件后进行重新读 取配置文件。
help           显示帮助信息。
restart        重新启动 Apache 服务器。 = httpd -k restart start          启动 Apache 服务器。
status         显示服务器摘要的状态信息。
stop           停止 Apache 服务器。
```



## 4.1 虚拟主机

专业来讲，虚拟主机是**使用特殊的软硬件技术，把一台计算机主机分成一台台“虚拟”的主机**，每一台虚拟主机都具有独立的域名和IP地址（或共享的IP地址），具有完整的Internet服务器功能。

### 4.1.1 配置文件激活

1. 在apache配置文件中搜索httpd-vhost，去掉#

2. vim extra/httpd-vhosts.conf  

3. 如下图

   ```
   <VirtuaHost*:80>
    ServerAdmin   //指定管理员邮箱
    DocumentRoot  //为该虚拟主机站点的根目录
    ServerName    //为网站的域名
    ServerAlias   //为网站的别名（第二域名）
    ErrorLog      //为站点的错误日志
    CustomLog     //为站点的访问日志
    <VirtuaHost>
   ```

   ![1](D:\学习\web\1.png)

4. 创造根目录

   ```
   cd /usr/local/apache/httpd/docs/
   
   mkdir abc.com
   mdkir 111.com
   
   cd abc.com
   vim index.html  
   www.abc.com
   
   cd ../111.com
   vim index.html
   www.111.com
   ```

   

5. 重启apache

   ```
   /usr/local/apache/httpd/bin/apachectl -t
   /usr/local/apache/httpd/bin/apachectl graceful
   ```

   

6. 验证

   ```
   curl -x127.0.0.1:80 www.abc.com
   ```

7. 网页解析

   ```
   vim /etc/hosts
   
   127.0.0.1 www.abc.com
   127.0.0.1 www.fdy.com
   ```


### 4.1.2 用户认证

```
vim /usr/local/apache/httpd/conf/extra/httpd-vhosts.conf

<VirtuaHost*:80>
 ServerAdmin   //指定管理员邮箱
 DocumentRoot  //为该虚拟主机站点的根目录
 ServerName    //为网站的域名
 ServerAlias   //为网站的别名（第二域名）
 ErrorLog      //为站点的错误日志
 CustomLog     //为站点的访问日志
 <Directory /usr/local/apache/httpd/docs/abc.com> //指定认证目录
  AllowOverride AuthConfig  //相当于打开认证的开关
  AuthName "abc.com user auth" //自定义认证名
  AuthType Basic //认证类型，一般为basic
  AuthUserFile /data/.htpasswd //指定密码文件所在位置
  </Directory>
 </VirtuaHost>
```

创建用户：

```
# /usr/local/apache/httpd/bin/htpasswd -cm /data/.htpasswd test

//htpasswd 为创建用户的够久
//-c 为creat，-m为指定密码加密方式（md5）
//data/.htpasswd为密码文件
//aming为创建的用户，第一次执行需要加-c
```

测试：

```
usr/local/apache/httpd/bin/apachectl -t
curl -x 127.0.0.1:80 www.abc.com  //状态码401
curl -x 127.0.0.1:80 -uytl:passwd  www.abc.com //状态码200
```



### 4.1.3 域名跳转

```
<VirtuaHost*:80>
  <ifModele mod_rewrite.c> //需要mod_rewrite模块支持
  RewriteEngine on //打开rewrite功能
  RewriteCond %{HTTP_HOST}!^WWW.abc.com$ //定义rewrite条件，主机名（域名）不是www.abc.com满足条件
  RewriteRule ^/(.*)$http://www.abc.com/$1[R=301,L] //定义rewrite规则，当满足上面条件时，这条规则才会执行
  </ifModule>
 </VirtuaHost>
 
 RewriteRule后面分为三部分，第一部分为当前网址^/(.*)，第二部分为要跳转的网址http://www.abc.com/，第三部分为选项$1[R=301,L]，需要括号括起来
```

测试：

```
/usr/local/apache/httpd/bin/apachectl - M|grep -i rewrite //若无该模块，需要编辑配置文件httpd.conf，删除rewrite_module (shared)前面的#

curl -x 127.0.0.1:80 -l abc.com
```



### 4.1.4 访问日志

```
vim /usr/local/apache/httpd/conf/httpd.conf
```

![image-20221222082412304](D:\自诩\yun\web服务器架构搭建与配置\访问日志)



### 4.1.5 访问日志不记录指定类型的文件

![image-20221222083127928](D:\自诩\yun\web服务器架构搭建与配置\类型文件)



### 4.1.6 访问日志切割

![image-20221222083500609](D:\自诩\yun\web服务器架构搭建与配置\切割)



### 4.1.7 配置静态元素过期时间

![image-20221222083806847](D:\自诩\yun\web服务器架构搭建与配置\expires模块)

![image-20221222083830663](D:\自诩\yun\web服务器架构搭建与配置\过期时间)

```
curl -x127.0.0.1:80 www.abc.com/aming.txt
curl -x127.0.0.1:80 www.abc.com/aming.jpg
max-age=86400说明将缓存86400秒
```



### 4.1.8 配置防盗链

![image-20221222084505909](D:\自诩\yun\web服务器架构搭建与配置\防盗链)

```
curl -x127.0.0.1:80 -I -e "http://www.abc.com/abc.txt" http://abc.com/aming.jpg
curl -x127.0.0.1:80 -I -e "http://www.111.com/111.txt" http://111.com/index.html
状态码200
```



### 4.1.9 访问控制

#### **白名单**

![image-20221222085315255](D:\自诩\yun\web服务器架构搭建与配置\白名单)

![image-20221222085418747](D:\自诩\yun\web服务器架构搭建与配置\白名单验证)

针对文件位置：

```
<Directory>
<Filesmatch "admin.php(.*)">
 Order deny,allow
 Deny from all
 Allow from 127.0.0.1
</Filesmatch>
</Directory>
```

验证：

```
curl -x127.0.0.1:80 www.abc.com/admin/admin.php -I
//200
```



#### 禁止解析php

![image-20221222090950332](D:\自诩\yun\web服务器架构搭建与配置\php解析)

```
测试返回源代码，未解析
```



#### user_agent

user_agent是指用户浏览器端的信息，比如你是用ie海瑟Firefox浏览器的，有些网站会根据这个来调整打开网站的类型，如是收集就打开wap，现实非手机就打开pc常规页面

![image-20221222092130335](D:\自诩\yun\linux\user_agent)

![image-20221222092154168](D:\自诩\yun\linux\user_agent验证)

```
curl -A "123123"用于指定user_agent
```



# 关系型数据库日常管理

## 5.1 root密码配置

1. 创建root初始密码

   ```
   mysqladmin -uroot password '123456'
   ```

2. 密码登录

   ```
   mysql -uroot -p123456
   ```

3. 密码重置

   ```
   修改配置文件/etc/my.cnf
   在mysqld配置段增加字段 skip-grant
   
   修改完成后重启：/etc/init.d/mysqld restart
   使用命令登入mysql（忽略授权直接登入）
   ```

   ![image-20221229093745614](D:\自诩\yun\web服务器架构搭建与配置\密码重置)

4. 修改密码

   ```
   1. 移动到mysql库，更新user表
   update user set password=password('aminglinux')where user='root'
   
   2. set password for 'root'@'localhost'=password('1qaz!QAZ');   修改密码
   ```



## 5.2 连接mysql

1. 连接mysql

   ```
   mysql -uroot -p123456
   ```

2. 远程连接

   ```
   mysql -uroot -p123456 -h127.0.0.1 -P3306
   ```

3. mysql -uroot -p123456 -S/tmp/mysql.sock

4. 直接查看数据库

   ```
   mysql -uroot -p123456 -e "show databases"
   ```



## 5.3 常用命令

1. **查询库**

   ```
   show databases;
   ```

2. **切换库**

   ```
   use mysql;
   ```

3. **查看库里表**

   ```
   show tables;
   ```

4. **查看表里字段**

   ```
   desc user;
   ```

5. **查看建表语句**

   ```
   show create table user\G;
   ```

6. **查看当前用户**

   ```
   select user();
   ```

7. **查看当前使用的数据库**

   ```
   select database();
   ```

8. **创建库**

   ```
   create database db1;
   ```

9. **创建表**

   ```
   use db1; create table t1(`id` int(4),`name` char(40));
   ```

10. 查看当前数据库版本

    ```
    select version();
    ```

11. 查看当前数据库状态

    ```
    show status;
    ```

12.  查看各参数 

    ```
    show variables; show variables like 'max_connect%';
    ```

13. 修改参数

    ```
    set global max_connect_errors=1000;
    ```

14. 查看队列

    ```
    show processlist; show full processlist;
    ```



## 5.4 mysql创建用户以及授权

```
grant all on *.* to 'user1' identified by 'passwd';
grant SELECT,UPDATE,INSERT on db1.* to 'user2'@'192.168.133.1' identified by 'passwd';
grant all on db1.* to 'user3'@'%'identified by 'passwd';
```

查看授权表

```
show grants;

show grants for user2@192.168.133.1;
```





## 5.5 常用sql语句

1. 查看user表内行数

   ```
   select count(*)from mysql.user;
   ```

2. 查看db表内的内容

   ```
   select * from mysql.db;
   ```

3. 查看db表内含有db字段的内容

   ```
   select db from mysql.db;
   ```

4. 搜索查看多个字段

   ```
   select db,user from mysql.db;
   ```

5. 查看host为127.0的内容

   ```
   select * from mysql.db where host like '127.0.%'\G;
   ```

6. 插入（向db1.t1中插入内容）

   ```
   insert into db1.t1 values(1,'abc');
   ```

7. 更新（把id=1的字段内容更新成aaa）

   ```
   update db1.t1 set name='aaa' where id=1
   ```

8. 清空（清空db1.t1表内的内容）

   ```
   truncate table db1.t1;
   
   select * from db1.t1;
   ```

9. 删除（删除db1.t1表内内容）

   ```
   drop table db1.t1;
   
   desc db1.t1;
   注意：清空后连同表结构一同删除
   
   # 删除db1数据库
   drop database db1;
   ```



## 5.6 mysql备份与恢复

1. 备份库

   ```
   mysqldump -uroot -p123456 mysql > /tmp/mysql.sql
   
   ```

2. 恢复库

   ```
   mysql -uroot -p123456 mysql < /tmp/mysql.sql
   ```

3. 备份表

   ```
   mysqldump -uroot -p123456 mysql user > /tmp/user.sql
   ```

4. 恢复表

   ```
   mysql -uroot -p123456 mysql < /tmp/user.sql
   ```

5. 备份所有库

   ```
   mysqldumo -uroot -p -A >/tmp/123.sql
   ```

6. 只备份表结构

   ```
   mysqldump -uroot -p123456 -d mysql >/tmp/mysql.sql
   ```




# Linux集群架构

## 6.1 高可用集群概念

1. **高可用集群**，又称“**HA集群**”，也称“双机热备”，用于关键业务，常见软件有heartbeat和**keepalived**，keepalived还有**负载均衡**的功能，这两个软件类似，核心原理都是通过**心跳线**连接两台服务器，正常情况下由一台服务器提供服务，当这台服务器宕机，备用服务器顶替。
2. VRRP（虚拟路由冗余协议），是实现路由高可用的一种通信协议，在这个协议里会将多台功能相同的路由器组成一个小组，小组中有一个**master**和N个backup。工作时，master会通过组播形式向各个backup发送vrrp协议的数据包，当backup收不到master1发来的vrrp数据包时，就会认为master宕机，此时会根据各个backup的优先级决定谁成为新的master。
3. keepalived采用这种**vrrp协议实现的高可用**，其有三个模块，分别是core、check、vrrp，其中**core为核心模块**，负责主进程的启动、维护以及全局配置文件的加载和解析；check模块负责健康检查；vrrp模块用来实现vrrp协议。



## 6.2 安装

```
yum install -y keepalived
```





## 6.3 keepalived+Nginx实现Web高可用

提前安装keepalived和nginx

1. 编辑master的keepalived的配置文件

   ```
   # 全局配置标识，表明这个区域{}时全局配置
   global_defs{
    notification_email{
      111111111@qq.com  # 表示发送通知邮件时邮件源地址是谁
   }
    notification_email_from root@aaa.com  # 表示keepalived在发生诸如切换操作时需要发送email通知，以及email发送给哪些邮件地址，邮件地址可以多个，每行一个
    smtp_server 127.0.0.1  # 表示发送email时使用的smtp服务器地址，这里可以用本地sendmail实现
    smtp_connect_timeout 30  # 连接smtp连接超时时间
    router_id LVS_DEVEL  # 机器标识
   }
   
   vrrp_script chk_nginx{
    script "/usr/local/sbin/check_ng.sh" # 检查服务是否正常，通过写脚本实现脚本检查服务健康状态
    interval 3    # 检查时间间断是3秒
   }
   
   # VRRP配置标识，VI_1是实例名称
   vrrp_instance VI_1{
    state MASTER  # 定义master相关
    interface ens33  # 通过vrrp协议去通信、广播，此为网卡名
    virtual_router_id 51  # 定义路由器ID，配置时候与从机器一致
    priority 100  # 权重，主角色和从角色的权重不同，一般主比从大
    advert_int 1  # 设定MASTER与BACKUP主机质检同步检查的时间间隔，单位秒
    
    # 认证相关信息
    authentication{
     auth_type PASS   # 认证类型
     auth_pass 5201314>g  # 密码形式为字符串
    }
    
    # 设置虚拟ip（VIP）
    virtual_ipaddress{
      192.168.1.6
    }
    
    # 加载脚本
    track_script{
     chk_nginx
    }
   }
   
   ```

2. 配置监控nginx服务的脚本（自动启动脚本）

   ```
   # vim /usr/local/sbin/check_ng.sh
   
   #!/bin/bash
    # 时间变量，用于记录日志
    d=`date --date today+%Y%m%d_%H:%M:%s`
    # 计算nginx进程数量
    n=`ps -C nginx --no-heading|wc -l`
    # 如果进程为0，则启动nginx，并且再次检测nginx进程数量
    if[$n -eq "0"]; then
     /etc/init.d/nginx start
     n2=`ps -C nginx --no-heading|wc -l`
     #如果还为0，说明nginx无法启动，此时需要关闭keepalived
     if[$n2 -eq "0"]; then
      echo "$d nginx down,keepalived will stop"  >> /var/log/check_ng.log
      systemctl stop keepalived
      fi
     fi
   ```

3. 给予脚本权限

   ```
   chmod 764 /usr/local/sbin/check_ng.sh
   ```

4. 启动keepalived

   ```
   # systemctl start keepalived
   # ip add
   
   ```

5. 查看nginx是否启动

   ```
   ps aux | grep nginx
   ```

6. 设置backup与上述一致

7. 测试

   ```
   # curl -I master的ip/backup的ip
   # curl -I VIP
   
   # 测试nginx是否自动开启
   # netstat -nltp | grep nginx
   # /etc/init.d/nginx stop
   # netstat -nltp | grep nginx
   
   # 片刻后
   # netstat -nltp | grep nginx
   
   
   # 模拟宕机
   # iptables -I OUTPUT -p vrrp -j DROP
   # 去backup看是否被设置了vip
   # ip addr
   # 预防脑裂的方式是直接关闭master的keepalived服务
   # systemctl stop keepalived
   # curl -I VIP
   
   ```

   

## 6.4 负载均衡集群概念

1. 负载均衡简单来说就是让多台服务器均衡地去承载压力。实现负载均衡集群的开源软件有LVS、keepalived、haproxy、Nginx等，也有优秀的商业负载均衡设比如F5、NetScaler等。商业的负载均衡解决方案稳定性没得说，但成本昂贵，所以以LVS为主

2. LVS(Linux Virtual Server)又称Linux虚拟服务器，是一个虚拟的服务器集群系统，使用[负载均衡](https://so.csdn.net/so/search?q=负载均衡&spm=1001.2101.3001.7020)技术将多台服务器组成一个虚拟的服务器集群是由国内大牛章文嵩开发，这款软件的流行度不亚于Aoache的httpd，是一款**四层负载均衡软件**，是针对tcp/ip做的转发和路由，所以稳定性和效率相当高，其架构有一个核心角色叫调度器，用于分发用户请求们还有诸多的真实服务器，也就是处理用户请求的服务器。

3. LVS根据其实现方式不同，分为三种类型：nat模式、IPTunnel(ip隧道)模式、DR模式，nat比较节省公网ip，TUN和DR相差不大，都能支撑较大规模的集群，但缺点是浪费公网ip。nat模式缺点是调度器容易成为瓶颈

   

## 6.5 LVS调度算法

1. **轮询调度**

   ```
   按顺序把请求均衡地分发给后端的服务器，它不管后端服务器的处理速度和响应时间，当后端服务器性能不一时，这种算法不太合适
   ```

2. **带权重的轮询调度**

   ```
   权重越高的服务器被分配到的请求就越多，解决后端服务器性能不一时，延迟问题
   ```

3. **最小连接调度**

   ```
   根据各真实服务器上的连接数来决定把新的请求分配给谁，连接数少说明服务器时空闲的，这样把新的请求分配到空闲服务器上才更加合理
   ```

4. **带权重最小连接调度**

   ```
   可以人为控制哪些服务器多分配请求
   ```

5. 基于局部性的最少链接调度

   ```
   简称LBLC，这是针对请求报文的目标ip地址的负载均衡调度，目前主要用于Cache集群系统，因为在Cache集群中客户请求报文的目标ip地址时变化的。算法的设计目标实在服务器的负载基本平衡的情况下，将相同目标ip地址的请求调度到同一台服务器，来提高各台服务器的访问局部性和主存Cache命中率。
   ```

6. 带复制的基于局部性最少链接调度

   ```
   简称LBLCR，与LBLC不同之处是它要维护从一个目标ip地址到一组服务器的映射，而LBLC算法是维护从一个目标ip地址到一台服务器的映射。LBLCR根据请求的目标ip找出该目标ip地址对应的服务器组，按最小链接原则从该服务器组选出一台服务器，若服务器没有超载，则将请求发送到该服务器，若服务器超载，则按最小路径原则从整个集群中选出一台服务器，将其加入服务器组，将请求发送到该服务器。同时，当该服务器组有一段时间没有被修改，将最忙的服务器从组中删除，以降低复制的程度。
   ```

7. 目标地址散列调度

   ```
   针对目标ip的负载均衡，但它是一种静态映射算法，通过一个散列函数将一个目标ip地址映射到一台服务器。算法是根据请求的目标ip地址，作为散列键从静态分配的散列表找出对应的服务器，若该服务器可用未超载，将请求发送到该服务器，否则返回空。
   ```

8. 源地址散列调度

   ```
   根据请求的源ip，作为散列键从静态分配的散列表找出对应的服务器，若该服务器可用未超载，将请求发送到该服务器，否则返回空，
   ```




## 6.6  NAT模式搭建

实验环境：三台虚拟机，一个调度器dir（两台网卡，一张内网ip、一张公网ip），两台真实服务器（内网ip）

公网ip：192.168.147.144

内网ip：192.168.200.130-132

把真实服务器上的把内网的网关设置为dir的内网ip

```
# route add default gw 192.168.200.130
// 永久生效
# vim/etc/sysconfig/network

 GATEWAY=192.168.101.254
 
// 删除默认网关
route del default gw 192.168.200.130


// 更改掩码
ifconfig eth0 netmask 255.255.0.0
```



1. 清空三台虚拟机的iptables规则

   ```
   # iptables -F; iptables -t nat -F; service iptables save
   ```

2. 在dir上安装ipvsadm，其是实现LVS的核心工具

   ```
   # yum install -y ipvsadm
   ```

3. 在dir上编写一个脚本

   ```
   # vim /usr/local/sbin/lvs_nat.sh
   
   #!/bin/bash
   
    # director服务器上开启路由转发共功能
    echo 1>/proc/sys/net/ipv4/ip_forward
    
    # 关闭icmp的重定向
    echo 0>/proc/sys/net/ipv4/conf/all/send_redirects
    echo 0>/proc/sys/net/ipv4/conf/default/send_redirects
    
    # 注意区分网卡名字
     echo 0>/proc/sys/net/ipv4/conf/ens33/send_redirects
      echo 0>/proc/sys/net/ipv4/conf/ens34/send_redirects
      
    
    # director 设置nat防火墙
    iptables -t nat -F
    iptables -t nat -X
    iptables -t nat -A POSTROUTING -s 192.168.200.0/24  -j MASQUERADE
    
    # director 设置ipvsadm
    IPVSADM='usr/sbin/ipvsadm'
    $IPVSADM -C
    $IPVSADM -A -t 192.168.147.144:80 -s wlc -p 300
    $IPVSADM -a -t 192.168.147.144:80 -r 192.168.200.131:80 -m -w 1 
    $IPVSADM -a -t 192.168.147.144:80 -r 192.168.200.132:80 -m -w 1
   ```

4. 执行代码

   ```
   # bash /usr/local/sbin/lvs_nat.sh
   ```

5. 测试LVS（如果dir有nginx服务器需将其关闭，否则影响实验效果）

   ```
   # killall nginx
   ```

   ```
   //方便区别
   # echo "rs1" > /usr/share/nginx/html/index.html
   # echo "rs2" > /usr/local/nginx/html/index.html
   ```

   ```
   # curl 192.168.200.131
   rs1
   # curl 192.168.200.132
   rs2
   
   # curl 192.168.147.144
   rs2
   # curl 192.168.147.144
   rs2
   # curl 192.168.147.144
   rs2
   
   // 连续多次访问都为rs2.因为脚本中有-p 300参数，理论会在300秒后更换。重新编辑脚本把-p参数去除再次测试
   # curl 192.168.147.144
   rs2
   # curl 192.168.147.144
   rs1
   # curl 192.168.147.144
   rs2
   # curl 192.168.147.144
   rs1
   ```



## 6.7 DR模式搭建

实验环境：三台虚拟机，都有公网ip，一台dir，两台rs，一个vip，并把两台rs的网关改成原始网关，不能继续设置为dir的内网ip

1. 在dir编写一个脚本

   ```
   # vim /usr/local/sbin/lvs_dr.sh
   
   #!/bin/bash
    echo 1>/proc/sys/net/ipv4/ip_forward
    ipv=/usr/sbin/ipvsadm
    vip=192.168.200.110
    rs1=192.168.200.131
    rs2=192.168.200.132
    # 注意这里的网卡名字哦
    ifconfig ens33:2 $vip broadcast $vip netmask 255.255.255.255 up
    route add -host $vip dev ens33:2
    $ipv -C
    $ipv -A -t $vip:80 -s wrr
    $ipv -a -t $vip:80 -r $rs1:80 -g -w 1
    $ipv -a -t $vip:80 -r $rs2:80 -g -w 1
   ```

2. 两台rs编写脚本一致

   ```
   # vim /usr/local/sbin/lvs_rs.sh
   #!/bin/bash
    vip=192.168.200.100
    # 把vip绑定在lo上，是为了实现rs直接把结果返回给客户端
    ifconfig lo:0 $vip broadcast $vip netmask 255.255.255.255 up
    route add -host $vip lo:0
    
    # 一下操作为更改arp内核参数，目的是为了让rs顺利发送mac地址给客户端
    echo "1" >/proc/sys/net/ipv4/conf/lo/arp_ignore
    echo "2" >/proc/sys/net/ipv4/conf/lo/arp_announce
    echo "1" >/proc/sys/net/ipv4/conf/all/arp_ignore
    echo "2" >/proc/sys/net/ipv4/conf/all/arp_announce
   ```

3. 三台机器上执行各自脚本

   ```
   # bash 脚本路径
   ```

4. 测试

   ```
   在浏览器上输入192.168.200.131
   rs1
   在浏览器上输入192.168.200.132
   rs2
   
   在浏览器上输入192.168.200.110
   rs2
   在浏览器上输入192.168.200.110
   rs1
   ```

   

## 6.8 keepalived+LVS集群

实验环境：keepalived可以解决后端rs宕机时，请求转换的问题，其不仅仅有高可用功能，更有负载均衡功能，也就是说，在调度器上安装了keepalived，就不用再安装ipvsadm，也不要编写LVS相关的脚本，也就是说keepalived已经嵌入了LVS功能，完整的keepalived+LVS架构需要两台调度器实现高可用，提供调度服务器的只需要一台

一台主keepalived，备用暂时省略，两台真实服务器

调度器：192.168.200.130

rs1：192.168.200.131

rs2：192.168.200.132

1. 编辑keepalived配置文件

   ```
   //清空配置文件
   # > /etc/keepalived/keepalived.conf
   # vim /etc/keepalived/keepalived.conf
   
    vrrp_instance VI_1{
     state MASTER
     interface ens33
     virtual_router_id 51
     priority 100
     advert_int 1
     authentication{
       auth_type PASS
       auth_pass 1111
     }
     virtual_ipaddress{
       192.168.200.110
     }
    }
    # VIP
    virtual_server 192.168.200.110 80{
       delay_loop 10    # 每隔10秒查询realserver状态
       lb_algo wlc      # lvs算法
       lb_kind DR       # DR模式
       persistence_timeout 60  # 同一 ip的连接60秒内被分配到同一台realserver
       protocol TCP   # 用TCP协议简称realserver状态
     # 真实服务器ip
     real_server 192.168.200.131 80 {
        weight 100   # 权重
        TCP_CHECK{
          connect_timeout 10  # 10秒无响应超时
          nb_get_retry 3      # 失败重试次数
          delay_before_retry 3  # 失败重试的间隔时间
          connect_port 80    # 连接的后端端口
        }
    }
     real_server 192.168.200.132 80 {
        weight 100   # 权重
        TCP_CHECK{
          connect_timeout 10 
          nb_get_retry 3      
          delay_before_retry 3 
          connect_port 80    
        }
    }
    }
   ```

2. 清除之前的规则和vip

   ```
   ipvsadm -C
   systemctl restart network
   ```

3. 因为lvs模式为dr模式，所以再两台rs上执行脚本

   ```
   # vim /usr/local/sbin/lvs_rs.sh
   #!/bin/bash
    vip=192.168.200.100
    # 把vip绑定在lo上，是为了实现rs直接把结果返回给客户端
    ifconfig lo:0 $vip broadcast $vip netmask 255.255.255.255 up
    route add -host $vip lo:0
    
    # 一下操作为更改arp内核参数，目的是为了让rs顺利发送mac地址给客户端
    echo "1" >/proc/sys/net/ipv4/conf/lo/arp_ignore
    echo "2" >/proc/sys/net/ipv4/conf/lo/arp_announce
    echo "1" >/proc/sys/net/ipv4/conf/all/arp_ignore
    echo "2" >/proc/sys/net/ipv4/conf/all/arp_announce
   ```

4. 启动keepalived服务

   ```
   # systemctl start keepalived
   # ps aux | grep keepalived
   ```

5. 测试1

   ```
   直接在浏览器访问vip，然后故意停掉一台rs的ngxin服务（killall nginx），然后刷新页面（ctrk+F5）
   ```

6. 测试2

   ```
   在调度器上执行命令ipvsadm -ln 查看连接数
   ```

   



# 非关系型数据库日常管理

## 非关系型数据库（NOSQL）:

### 什么是（NOSQL）非关系型数据库：

>  非关系型数据库又被称为 NoSQL（Not Only SQL )，意为不仅仅是 SQL。通常指数据以对象的形式存储在数据库中，而对象之间的关系通过每个对象自身的属性来决定，常用于存储非结构化的数据。 

### 常见的NOSQL数据库：

1.  键值数据库：Redis、Memcached、Riak 
2.  列族数据库：Bigtable、[HBase](https://cloud.tencent.com/product/hbase?from=10680)、Cassandra 
3.  文档数据库：MongoDB、CouchDB、MarkLogic 
4.  图形数据库：Neo4j、InfoGrid

### 形式

1. k-v形式

   > memcached、redis适合存储用户信息、比如会话、配置文件、参数、购物车等等，这些信息一般都和id挂钩，这种情况下键值数据库是个很好的选择

2. 文档数据库

   > mongodb将数据以文档的形式储存，每个文档都是一系列数据项的集合，每个数据项都有一个名称与对应的值，值既可以使简单的数据类型，也可以使复杂的类型，比如有序列表和关联对象，数据存储的最小单位是文档，同一个表中存储的文档属性可以是不同的，数据可以使用XML、JSON、JSONB等多种形式存储

3. 列存储Hbase

   > Infinite GFraph、OrinentDB

## Memcached

是一套分布式的高速缓存系统，是一套开放源代码软件，以BBSD license授权发布

因为缺乏认证以及安全管制，这代表应该将memcached服务器放置在防火墙后

### 存储方式

>为了提高性能，memcached会将保存的数据存储在memcached内置的内存存储空间中，因为数据存储在内存中，重启后数据会全部丢失。另外，内容容量达到指定值之后，基于LRU（最近最少使用页面置换）算法自动删除不使用的缓存

### Slab Allocation原理

> 1. 将分配的内存分割成各种尺寸的块（chunk），并把尺寸相同的块分成组（chunk的集合），每个chunk集合称为slab
> 2. memcached的内存分配以page为单位，page默认值为1m，可以在启动时通过-I参数来指定
> 3. slab是由多个page组成，page按照只当大小切割成多个chunk
> 4. memcached在启动时通过-f选项可以指定Growth Factor 因子，该值控制chunk大小的差异，默认值为1.25
> 5. 通过memcached-tool命令查看你指定memecached实例的不通顺slab状态，可以看到各itme所占大小（chunk大小）差距为1.25





# Ansible自动化运维

### 介绍

> 1. Ansible不需要安装客户端，通过sshd去通信（无密钥登陆）
> 2. Ansible基于模块工作，模块可以由任何语言开发
> 3. Ansible不仅支持命令行使用模块，也支持便谢谢Yaml格式的playbook，易于编写和阅读
> 4. Ansible安装十分简单，Centos可直接yum安装
> 5. Ansible有提供UI（浏览器图形化）
>
> 

