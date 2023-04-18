# 监控详解

## 监控目标

明白监控的重要性以及使用监控要实现的业务目标

通常包括以下三点:

- 对目标系统进行实时监控
- 监控可以实时反馈目标系统的当前状态
  目标系统硬件、软件、业务是否正常、目前处于何种状态
- 保证目标系统可靠性，业务可以持续稳定运行
  有问题第一时间反馈出来，便于运维人员处理

## 监控方法

- 了解监控对象
  例如:CPU如何工作？
- 性能基准指标
  例如: CPU使用率、负载、用户态、内核态、上下文切换
- 报警阈值定义
  例如: CPU负载高的定义，内核态、用户态多少算高
- 故障处理流程
  如何更高效处理故障的流程

## 监控核心

- 发现问题
- 定位问题
- 解决问题
- 总结问题，对故障原因及问题防范进行归纳总结，避免以后重复出现

## 监控工具

- 老牌监控

- - Cacti
  - Nagios
  - smokeping

- 流行监控

- - Zabbix
  - OpenFalcon
  - Prometheus+Grafana
  - 滴滴开源夜莺Nightingale
  - smartping(专用于网络监控)
  - LEPUS天兔(专用于监控数据库)

- 自研

- 第三方监控

- - 监控宝
  - 听云
  - newrelic

## 监控流程

- 采集
  通过SNMP、Agent、ICMP、SSH、IPMI等对系统进行数据采集
- 存储
  各类数据库服务,MySQL、PostgreSQL
- 分析
  提供图形及时间线情况信息，方便我们定位故障所在
- 展示
  指标信息、指标趋势展示
- 报警
  电话、邮件、微信、短信、报警升级机制
- 处理
  故障级别判定，找响应人员进行快速处理

## 监控指标

- 硬件监控

- - 机器硬件:CPU温度、物理磁盘、虚拟磁盘、主板温度、磁盘阵列
  - IPMI工具无法获取到硬件的状态，可以借助MegaCli工具探测Raid磁盘队列状态
  - [https://www.ibm.com/developerworks/cn/linux/l-ipmi/](https://link.zhihu.com/?target=https%3A//www.ibm.com/developerworks/cn/linux/l-ipmi/)

- 系统监控

- - 主机存活
  - CPU、内存、硬盘、使用率
  - inode
  - 负载
  - 网卡出入带宽
  - TCP连接数
  - 磁盘读写、只读

- 应用监控

- - MySQL

  - - 服务可用性
    - 内存使用率
    - 磁盘使用
    - 主从不同步及延迟
    - 备份情况
    - 连接数

  - Redis、Redis Cluster

  - - 负载
    - 内存使用率
    - 连接数量
    - qps

  - Nginx

  - - 状态码
    - 连接状态信息

  - RabbitMQ

  - PHP-FPM

  - OpenLDAP

  - - 接入IP
    - 调用次数

  - Zimbra

  - OpenVPN

  - - 版本信息、当前在线
    - 用户、分配IP、客户端连接IP、通过IP获取地址位置、接收发送流量 连接时间 时长 连接ID

  - ELK

  - Graylog

  - GitLab

  - Jenkins

  - MongoDB

  - HAproxy

- 网络监控

- - 网络质量
  - 公网出口
  - 专线带宽
  - 网络设备

- 流量分析

- 日志监控

- 安全监控

- URL、API监控

- - [https://github.com/brotandgames/ciao](https://link.zhihu.com/?target=https%3A//github.com/brotandgames/ciao) 简单易用
  - [https://github.com/710leo/urlooker](https://link.zhihu.com/?target=https%3A//github.com/710leo/urlooker)
  - 自研
  - 阿里云方案

- 性能监控(APM)java|php|go|nodejs|分布式链路追踪

- - PinPoint
  - Zipkin
  - SkyWalking
  - CAT、Jaeger

- 业务监控

- - 电商业务为例

  - - 每分钟产生多少订单
    - 每分钟注册多少用户
    - 每分钟多少活跃用户
    - 每天有多少推广活动
    - 推广活动引入多少用户
    - 推广活动引入多少流量
    - 推广活动引入多少利润

- 其他

- - SSL证书监控
  - 存活性 进程是否还在，端口监听、Log滚动
  - 健康指标 MQ消息堆积量
  - 接口监控 API成功率，延迟情况，QPS等等

## 监控报警

- 邮件
- 短信
- 钉钉、微信、企业微信等其他即时通信软件
- 电话

## 报警处理

- 故障自愈: 服务器宕机自动启动。利用软件机制supervisor,systemd或者自定义脚本实现

## 综合监控

- 硬件监控
  通过SNMP来进行路由器交换机的监控、其他内容使用IPMI实现。如果都是公有云，可以忽略这部分内容。案例:[Open-Falcon监控H3C-ER3260G2路由器](https://link.zhihu.com/?target=https%3A//www.mdslq.cn/archives/186e54d8.html)

- 系统监控

- 服务监控

- - 服务自带

  - - Nginx自带status模块
    - PHP相应status模块
    - MySQL利用percona官方工具进行监控

  - 通过自定义方法获取数据

  - - MySQL show global status xxx;
    - Redis info指令信息

- 网络监控(混合云架构)

- - smokeping
  - smartping

- 安全监控

- - 云服务直接用云安全组即可，或者补充本机iptables
  - 硬件防火墙
  - Web服务使用Nginx+Lua实现Web层面的防火墙，或者Openresty

- 日志监控
  ELK、Graylog实现异常日志，错误日志关键字的监控

- 业务监控
  确定监控指标，监控起来，业务不同各不相同

- 流量分析
  建议使用百度统计，google统计，商业，研发嵌入代码实现。或者使用[piwik](https://link.zhihu.com/?target=http%3A//www.piwik.cn/)

- 可视化
  dashboard

- 自动化监控
  通过API,批量操作

## 监控总结

完整的监控系统，需要对业务有详尽的了解，软件只是手段。





# 实验环境

| 主机   | IP              | 节点规划       |
| ------ | --------------- | -------------- |
| Server | 192.168.223.100 | LNMP、Zabbix   |
| Client | 192.168.223.7   | Zabbix被监控机 |



# 部署zabbix环境

## 部署LNMP

### Nginx

1. 添加nginx的yum源

   ```sh
   [root@server ~]# vim /etc/yum.repos.d/nginx.repo
   [nginx-stable]
   name=nginx stable repo
   baseurl=http://nginx.org/packages/centos/$releasever/$basearch/
   gpgcheck=0
   enabled=1
   ```

2. 清除缓存并下载nginx，然后开启服务并设置自启

   ```sh
   [root@server ~]# yum clean all && yum makecache fast
   [root@server ~]# yum install -y nginx
   [root@server ~]# systemctl start nginx.service && systemctl enable nginx.service
   ```

3. 浏览器访问本机ip测试



### Mariadb

1. 下载mariadb

   ```
   [root@server ~]# yum -y install mariadb-server mariadb
   ```

2. 开启服务并自启

   ```sh
   [root@server ~]# systemctl start mariadb.service && systemctl enable mariadb.service
   
   
   # 验证
   [root@server ~]# netstat -lntp
   Active Internet connections (only servers)
   Proto Recv-Q Send-Q Local Address           Foreign Address         State       PID/Program name    
   tcp        0      0 0.0.0.0:3306            0.0.0.0:*               LISTEN      1906/mysqld         
   tcp        0      0 0.0.0.0:80              0.0.0.0:*               LISTEN      2762/nginx: master  
   tcp        0      0 0.0.0.0:22              0.0.0.0:*               LISTEN      970/sshd            
   tcp        0      0 127.0.0.1:25            0.0.0.0:*               LISTEN      1179/master         
   tcp6       0      0 :::22                   :::*                    LISTEN      970/sshd            
   tcp6       0      0 ::1:25                  :::*                    LISTEN      1179/master         
   ```

3. 执行mysql安装配置向导

   ```sh
   [root@server ~]# mysql_secure_installation
   
   NOTE: RUNNING ALL PARTS OF THIS SCRIPT IS RECOMMENDED FOR ALL MariaDB
         SERVERS IN PRODUCTION USE!  PLEASE READ EACH STEP CAREFULLY!
   
   In order to log into MariaDB to secure it, we'll need the current
   password for the root user.  If you've just installed MariaDB, and
   you haven't set the root password yet, the password will be blank,
   so you should just press enter here.
   
   Enter current password for root (enter for none): 		'//回车'
   OK, successfully used password, moving on...
   
   Setting the root password ensures that nobody can log into the MariaDB
   root user without the proper authorisation.
   
   Set root password? [Y/n] y		'//设置密码'
   New password: 
   Re-enter new password: 		'//确认密码'
   Password updated successfully!
   Reloading privilege tables..
    ... Success!
   
   
   By default, a MariaDB installation has an anonymous user, allowing anyone
   to log into MariaDB without having to have a user account created for
   them.  This is intended only for testing, and to make the installation
   go a bit smoother.  You should remove them before moving into a
   production environment.
   
   Remove anonymous users? [Y/n] y		'//是否删除匿名用户'
    ... Success!
   
   Normally, root should only be allowed to connect from 'localhost'.  This
   ensures that someone cannot guess at the root password from the network.
   
   Disallow root login remotely? [Y/n] y		'//是否禁止root远程登录'
    ... Success!
   
   By default, MariaDB comes with a database named 'test' that anyone can
   access.  This is also intended only for testing, and should be removed
   before moving into a production environment.
   
   Remove test database and access to it? [Y/n] n		'//是否删除test数据库'
    ... skipping.
   
   Reloading the privilege tables will ensure that all changes made so far
   will take effect immediately.
   
   Reload privilege tables now? [Y/n] y		'//是否重新加载权限表'
    ... Success!
   
   Cleaning up...
   
   All done!  If you've completed all of the above steps, your MariaDB
   installation should now be secure.
   
   Thanks for using MariaDB!
   ```

4. 测试登录

   ```sh
   [root@server ~]# mysql -uroot -p123456
   ```



### PHP

1. 下载安装

   ```sh
   [root@server ~]# rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
   [root@server ~]# rpm -Uvh https://mirror.webtatic.com/yum/el7/webtatic-release.rpm
   [root@server ~]# yum -y install php72w php72w-devel php72w-fpm php72w-gd php72w-mbstring php72w-mysql
   
   # 查看版本
   [root@server ~]# php -v		
   ```

2. 修改php网页文件

   ```sh
   [root@server ~]# vim /etc/php-fpm.d/www.conf
   # 第8行，修改
   user = nginx
   # 第10行，修改
   group = nginx
   
   ```

3. 修改nginx配置文件

   ```sh
   [root@server ~]# vim /etc/nginx/conf.d/default.conf
   
   # 第10行，添加index.php文件
   index  index.html index.htm index.php;
   # 31-37行，取消注释并修改，配置php请求传送到后端的php-fpm模块的配置
   location ~ \.php$ {
       # 修改站点目录
   	root           /usr/share/nginx/html;
   	fastcgi_pass   127.0.0.1:9000;
   	fastcgi_index  index.php
   	# 将fastcgi_param中的/scripts改为$document_root，root是配置php程序纺织的根目录
   	fastcgi_param  SCRIPT_FILENAME  $document_root$fastcgi_script_name;	
   	include        fastcgi_params;
   }
   ```

4. 优化php配置文件

   ```sh
   [root@server ~]# vim /etc/php.ini
   
   # 202行改为On，支持php短标签
   short_open_tag = On
   # 359修改为Off，隐藏php版本
   expose_php = Off
   
   # 以下都是zabbix的配置要求
   # 368行，执行时间，在一个程序执行的过程中能够等待的执行时间，执行时间过程中如果没有执行完会结束该程序，以防出现卡死，默认30秒'
   max_execution_time = 300
   # 378行，接受数据的等待时间
   max_input_time = 300
   # 389行，每个脚本的占用内存限制
   memory_limit = 128M
   # 656行，post数据的最大限制
   post_max_size = 16M
   # 799，下载文件的大小限制
   upload_max_filesize = 2M
   # 800行添加此句，可以用$HTTP_RAW_POST_DATA接受post raw data（原始未处理数据）
   always_populate_raw_post_data = -1
   # 878行，修改时区为上海
   date.timezone = Asia/Shanghai
   ```

5. 启动服务并设置自启

   ```sh
   [root@server ~]#  systemctl start php-fpm && systemctl enable php-fpm && systemctl restart nginx
   
   # 查看端口
   [root@server ~]# netstat -natp|grep 9000
   ```

6. 测试

   ```sh
   [root@server ~]# vim /usr/share/nginx/html/info.php	
   
   <?php
    phpinfo();
   ?>
   
   # 访问网页192.168.126.11/info.php测试
   ```

7. 测试数据库是否连接

   ```sh
   [root@server ~]# vim /usr/share/nginx/html/info.php		'//重新修改首页文件，测试数据库是否连接'
   
   <?php
    $link=mysqli_connect('127.0.0.1','root','123456');
    if ($link) echo "连接成功";
    else echo "连接失败";
   ?>
   
   
   
   # 访问网页192.168.126.11/info.php测试
   
   ```

8. 创建zabbix数据库

   ```sh
   [root@server ~]# mysql -uroot -p123456
   mysql> CREATE DATABASE zabbix character set utf8 collate utf8_bin;
   mysql> GRANT all privileges ON *.* TO 'zabbix'@'%' IDENTIFIED BY '123456';
   mysql> flush privileges;
   mysql> exit;
   
   
   [root@server ~]# vim /usr/share/nginx/html/info.php
   <?php
    $link=mysqli_connect('127.0.0.1','zabbix','123123');
    if ($link) echo "zabbix数据库连接成功";
    else echo "连接失败";
   ?>
   
   # 访问网页【192.168.126.11/info.php】测试
   ```

   



## 部署Zabbix Server

1. 下载安装

   ```sh
   # 安装升级zabbix存储库
   [root@server ~]# rpm -Uvh https://repo.zabbix.com/zabbix/4.0/rhel/7/x86_64/zabbix-release-4.0-2.el7.noarch.rpm
   [root@server ~]# yum clean all
   # 安装Zabbix server，Web前端，agent
   [root@server ~]# yum -y install zabbix-server-mysql zabbix-web-mysql zabbix-agent
   ```

2. 配置数据库

   ```sh
   # 导入初始架构和数据
   [root@server ~]# zcat /usr/share/doc/zabbix-server-mysql-4.0.45/create.sql.gz | mysql -uzabbix -p123456 zabbix
   [root@server ~]# mysql -uroot -p123456
   mysql> show databases;
   mysql> use zabbix;
   mysql> show tables;
   
   # 将zabbix配置文件复制
   [root@server ~]# cp -r /usr/share/zabbix/ /usr/share/nginx/html/
   [root@server ~]# rm -rf /usr/share/nginx/html/*
   [root@server ~]# cd /usr/share/nginx/html
   [root@server html]# cd zabbix
   [root@server zabbix]# mv * ../
   [root@server html]# rm -rf zabbix
   ```

3. 赋权

   ```sh
   [root@server ~]# chown -R zabbix:zabbix /etc/zabbix
   [root@server ~]# chown -R zabbix:zabbix /usr/share/nginx/
   [root@server ~]# chown -R zabbix:zabbix /usr/lib/zabbix/
   
   [root@server ~]# chmod -R 755 /etc/zabbix/web/
   [root@server ~]# chmod -R 777 /var/lib/php/session/
   
   ```

4. 优化配置文件

   ```sh
   [root@server ~]# vim /etc/zabbix/zabbix_server.conf
   # 91行，取消注释
   DBHost=localhost		
   # 124行，设置密码
   DBPassword=123123		
   ```

5. 开启服务并设置自启

   ```sh
   [root@server ~]# systemctl start zabbix-server.service && systemctl enable zabbix-server.service 
   [root@server ~]# systemctl start zabbix-agent.service && systemctl enable zabbix-agent.service
   
   # 查看端口
   [root@server ~]# netstat -natp|grep 10051
   [root@server ~]# netstat -natp|grep 'zabbix'
   ```

6. 重启php和nginx

   ```sh
   [root@server ~]# systemctl restart php-fpm.service && systemctl restart nginx
   ```

7. 浏览器访问ip，用户名：Admin，密码：zabbix



## zabbix初始化

![](https://gitee.com/fan-dongyuan/ty-gallery/raw/master/%E5%B7%A5%E5%9D%8A%E5%9B%BE/zabbix/chushihua1.png)

![](https://gitee.com/fan-dongyuan/ty-gallery/raw/master/%E5%B7%A5%E5%9D%8A%E5%9B%BE/zabbix/chushihua2.png)

![](https://gitee.com/fan-dongyuan/ty-gallery/raw/master/%E5%B7%A5%E5%9D%8A%E5%9B%BE/zabbix/chushihua3.png)

![](https://gitee.com/fan-dongyuan/ty-gallery/raw/master/%E5%B7%A5%E5%9D%8A%E5%9B%BE/zabbix/chushihua4.png)

![](https://gitee.com/fan-dongyuan/ty-gallery/raw/master/%E5%B7%A5%E5%9D%8A%E5%9B%BE/zabbix/chushihua5.png)

![](https://gitee.com/fan-dongyuan/ty-gallery/raw/master/%E5%B7%A5%E5%9D%8A%E5%9B%BE/zabbix/chushihua6.png)

![](https://gitee.com/fan-dongyuan/ty-gallery/raw/master/%E5%B7%A5%E5%9D%8A%E5%9B%BE/zabbix/chushihua7.png)

![](https://gitee.com/fan-dongyuan/ty-gallery/raw/master/%E5%B7%A5%E5%9D%8A%E5%9B%BE/zabbix/chushihua8.png)