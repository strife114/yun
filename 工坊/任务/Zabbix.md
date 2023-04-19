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
   
   # 访问网页192.168.223.100/info.php测试
   ```

7. 测试数据库是否连接

   ```sh
   [root@server ~]# vim /usr/share/nginx/html/info.php		'//重新修改首页文件，测试数据库是否连接'
   
   <?php
    $link=mysqli_connect('127.0.0.1','root','123456');
    if ($link) echo "连接成功";
    else echo "连接失败";
   ?>
   
   
   
   # 访问网页192.168.223.100/info.php测试
   
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
    $link=mysqli_connect('127.0.0.1','zabbix','123456');
    if ($link) echo "zabbix数据库连接成功";
    else echo "连接失败";
   ?>
   
   # 访问网页【192.168.223.100/info.php】测试
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
   [root@server ~]# rm -rf /usr/share/nginx/html/*
   [root@server ~]# cp -r /usr/share/zabbix/ /usr/share/nginx/html/
   [root@server ~]# cd /usr/share/nginx/html
   [root@server html]# cd zabbix
   [root@server zabbix]# mv * ../
   [root@server zabbix]# cd ..
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
   DBPassword=123456		
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





## 部署Client代理端

1. 下载安装

   ```sh
   [root@client ~]# rpm -Uvh https://repo.zabbix.com/zabbix/4.0/rhel/7/x86_64/zabbix-release-4.0-2.el7.noarch.rpm
   
   [root@client ~]# yum -y install zabbix-agent
   ```

2. 修改zabbix代理配置文件

   ```sh
   [root@client ~]# vim /etc/zabbix/zabbix_agentd.conf		'//修改zabbix代理配置文件'
   # 98行，指向监控服务器地址
   Server=192.168.223.100
   # 139行，指向监控服务器地址
   ServerActive=192.168.223.100
   # 150行，指向client名称
   Hostname=client
   
   ```

3. 开启服务并自启

   ```sh
   [root@client ~]# systemctl start zabbix-agent.service && systemctl enable zabbix-agent.service
   
   # 查看端口
   [root@client ~]# netstat -ntap |grep 'zabbix'
   tcp        0      0 0.0.0.0:10050           0.0.0.0:*               LISTEN      11706/zabbix_agentd 
   tcp6       0      0 :::10050                :::*                    LISTEN      11706/zabbix_agentd
   ```

   





# 创建监控主机

1. 点击右上角用户图标，设置中文显示

   ![](https://gitee.com/fan-dongyuan/ty-gallery/raw/master/%E5%B7%A5%E5%9D%8A%E5%9B%BE/zabbix/zhuji1.png)

   ![](https://gitee.com/fan-dongyuan/ty-gallery/raw/master/%E5%B7%A5%E5%9D%8A%E5%9B%BE/zabbix/zhuji2.png)

2. 创建主机

   ![](https://gitee.com/fan-dongyuan/ty-gallery/raw/master/%E5%B7%A5%E5%9D%8A%E5%9B%BE/zabbix/zhuji3.png)

3. 链接监控模板

   ![](https://gitee.com/fan-dongyuan/ty-gallery/raw/master/%E5%B7%A5%E5%9D%8A%E5%9B%BE/zabbix/zhuji4.png)

   ![](https://gitee.com/fan-dongyuan/ty-gallery/raw/master/%E5%B7%A5%E5%9D%8A%E5%9B%BE/zabbix/zhuji5.png)

4. 查看主机列表

   ![](https://gitee.com/fan-dongyuan/ty-gallery/raw/master/%E5%B7%A5%E5%9D%8A%E5%9B%BE/zabbix/zhuji6.png)

5. 查看监控数据

   ![](https://gitee.com/fan-dongyuan/ty-gallery/raw/master/%E5%B7%A5%E5%9D%8A%E5%9B%BE/zabbix/zhuji7.png)

   



# 邮箱告警

## 邮件部署

1. 下载

   ```sh
   [root@server ~]# yum install -y mailx
   ```

2. 修改配置文件

   ```sh
   [root@server ~]# vim /etc/mail.rc
   # 在文件末尾添加
   set bsdcompat
   set from=1272776782@qq.com
   set smtp=smtp.qq.com
   set smtp-auth-user=1272776782@qq.com
   set smtp-auth-password=授权码
   set smtp-auth=login
   
   ```

3. 测试

   ```sh
   [root@server ~]# echo "hello world" | mail -s "testmail" 1272776782@qq.com
   
   # 注意
   1. 会在自己的邮箱中出现信息
   ```

4. 编写脚本发送邮件

   ```sh
   [root@server ~]# cd /usr/lib/zabbix/alertscripts
   [root@server ~]# cat mailx.sh
   #!/bin/bash
   #send mail
   
   messages=`echo $3 | tr '\r\n' '\n'`
   subject=`echo $2 | tr '\r\n' '\n'`
   echo "${messages}" | mail -s "${subject}" $1 >>/tmp/mailx.log 2>&1
   
   
   
   # 创建日志并赋权
   [root@server alertscripts]# touch /tmp/mailx.log
   [root@server alertscripts]# chown -R zabbix.zabbix  /tmp/mailx.log
   [root@server alertscripts]# chmod +x /usr/lib/zabbix/alertscripts/mailx.sh
   [root@server alertscripts]# chown -R zabbix.zabbix /usr/lib/zabbix/
   
   
   # 测试
   ./mailx.sh 1272776782@qq.com "主题" "内容"
   ./mailx.sh 1272776782@qq.com "2020" "jiayou wuhan"
   ```

   





# zabbix邮箱脚本告警

1. 管理 -----> 报警媒体类型 -----> 创建媒体类型 ----->

   ```
   名称：Mail-Test
   类型：脚本
   脚本名称：mailx.sh
   脚本参数：
   {ALERT.SENDTO}
   {ALERT.SUBJECT}
   {ALERT.MESSAGE}
   ```

   ![](https://gitee.com/fan-dongyuan/ty-gallery/raw/master/%E5%B7%A5%E5%9D%8A%E5%9B%BE/zabbix/youxiang1.png)

2. 管理 -----> 用户 -----> 点击Admin -----> 报警媒介

   ```
   类型：Mail-Test //调用上面的脚本
   收件人：1272776782@qq.com
   其它默认-添加
   ```

   ![](https://gitee.com/fan-dongyuan/ty-gallery/raw/master/%E5%B7%A5%E5%9D%8A%E5%9B%BE/zabbix/youxiang2.png)

   ![](https://gitee.com/fan-dongyuan/ty-gallery/raw/master/%E5%B7%A5%E5%9D%8A%E5%9B%BE/zabbix/youxiang3.png)

3. 配置 -----> 动作 -----> 创建动作 -----> 删除默认标签，修改触发条件

   ```
   名称：Mailx
   条件 A 主机群组=Linux servers
   ```

   ![](https://gitee.com/fan-dongyuan/ty-gallery/raw/master/%E5%B7%A5%E5%9D%8A%E5%9B%BE/zabbix/youxiang4.png)

4. 操作 -----> 如下配置

   ```
   默认操作步骤持续时间 60
   默认信息：
   
   告警主机：{HOST.NAME}
   告警  IP：{HOST.IP}
   告警时间：{EVENT.DATE}-{EVENT.TIME}
   告警等级：{TRIGGER.SEVERITY}
   告警信息：{TRIGGER.NAME}:{ITEM.VALUE}
   事件  ID：{EVENT.ID}
   
   ```

   ![](https://gitee.com/fan-dongyuan/ty-gallery/raw/master/%E5%B7%A5%E5%9D%8A%E5%9B%BE/zabbix/youxiang5.png)

   ![](https://gitee.com/fan-dongyuan/ty-gallery/raw/master/%E5%B7%A5%E5%9D%8A%E5%9B%BE/zabbix/youxiang6.png)

5. 恢复操作

   ![](https://gitee.com/fan-dongyuan/ty-gallery/raw/master/%E5%B7%A5%E5%9D%8A%E5%9B%BE/zabbix/youxiang7.png)

6. 重启server服务

   ```sh
   [root@server ~]# systemctl restart zabbix-server
   [root@server ~]# systemctl restart zabbix-agent.service
   ```

7. 在 web界面中，监控主机上模板中选择一个 Zabbix Agent 选项

   ![](https://gitee.com/fan-dongyuan/ty-gallery/raw/master/%E5%B7%A5%E5%9D%8A%E5%9B%BE/zabbix/youxiang8.png)

8. 在被监控主机上关闭服务等待邮件即可





# Nginx自动化流量监控以及告警自启

## nginx部署

1. 下载安装

   ```sh
   [root@client ~]# vim /etc/yum.repos.d/nginx.repo
   [nginx-stable]
   name=nginx stable repo
   baseurl=http://nginx.org/packages/centos/$releasever/$basearch/
   gpgcheck=0
   enabled=1
   
   
   [root@client ~]# yum install -y nginx
   [root@client ~]# systemctl start nginx && systemctl enable nginx
   ```

2. 修改配置文件

   ```sh
   [root@client scripts]# cat  /etc/nginx/conf.d/default.conf
   server {
       listen       80;
       server_name  localhost;
   
       #access_log  /var/log/nginx/host.access.log  main;
   
       location / {
           root   /usr/share/nginx/html;
           index  index.html index.htm;
       }
       # 添加此处
       location /nginx_status {
   	stub_status on;
   	access_log off;
       }	
       #error_page  404              /404.html;
   
       # redirect server error pages to the static page /50x.html
       #
       error_page   500 502 503 504  /50x.html;
       location = /50x.html {
           root   /usr/share/nginx/html;
       }
   
       # proxy the PHP scripts to Apache listening on 127.0.0.1:80
       #
       #location ~ \.php$ {
       #    proxy_pass   http://127.0.0.1;
       #}
   
       # pass the PHP scripts to FastCGI server listening on 127.0.0.1:9000
       #
       #location ~ \.php$ {
       #    root           html;
       #    fastcgi_pass   127.0.0.1:9000;
       #    fastcgi_index  index.php;
       #    fastcgi_param  SCRIPT_FILENAME  /scripts$fastcgi_script_name;
       #    include        fastcgi_params;
       #}
   
       # deny access to .htaccess files, if Apache's document root
       # concurs with nginx's one
       #
       #location ~ /\.ht {
       #    deny  all;
       #}
   }
   
   ```

3. 重启服务

   ```sh
   [root@client ~]# systemctl restart nginx
   ```

4. 浏览器访问

   ```sh
   http://192.168.223.7/nginx_status/
   Active connections: 1 
   server accepts handled requests
    138 138 126 
   Reading: 0 Writing: 1 Waiting: 0 
   
   # 内容信息如下：
   Active connections：当前活动的客户端连接数，包括Waiting连接数
   accepts：接受的客户端连接总数
   handled：已处理的连接总数
   requests：客户端请求总数
   Reading：Nginx正在读取请求头的当前连接数
   Writing：请求已经接收完成，处于响应过程的连接数
   Waiting：保持连接模式，处于活动状态的连接数
   ```

   

## 编写监控脚本

1. 在clinent中编写脚本

   ```sh
   [root@client ~]# mkdir /home/scripts
   [root@client ~]# vim /home/scripts/nginx_status.sh
   #! /bin/bash
   #date: 2020-01-18
   # Description：Zabbix4.0监控Nginx1.16.1性能以及进程状态
   # Note：此脚本需要配置在被监控端
   
   HOST="192.168.223.7"
   PORT="80"
   
   # 检测Nginx进程是否存在
   function ping {
       /sbin/pidof nginx | wc -l
   }
   
   # 检测Nginx性能
   function active {
       /usr/bin/curl "http://$HOST:$PORT/nginx_status/" 2>/dev/null| grep 'Active' | awk '{print $NF}'
   }
   function reading {
       /usr/bin/curl "http://$HOST:$PORT/nginx_status/" 2>/dev/null| grep 'Reading' | awk '{print $2}'
   }
   function writing {
       /usr/bin/curl "http://$HOST:$PORT/nginx_status/" 2>/dev/null| grep 'Writing' | awk '{print $4}'
   }
   function waiting {
       /usr/bin/curl "http://$HOST:$PORT/nginx_status/" 2>/dev/null| grep 'Waiting' | awk '{print $6}'
   }
   function accepts {
       /usr/bin/curl "http://$HOST:$PORT/nginx_status/" 2>/dev/null| awk NR==3 | awk '{print $1}'
   }
   function handled {
       /usr/bin/curl "http://$HOST:$PORT/nginx_status/" 2>/dev/null| awk NR==3 | awk '{print $2}'
   }
   function requests {
       /usr/bin/curl "http://$HOST:$PORT/nginx_status/" 2>/dev/null| awk NR==3 | awk '{print $3}'
   }
   
   $1
   ```

2. 赋予执行权限

   ```
   [root@client ~]# chmod 755 /home/scripts/nginx_status.sh
   ```

3. 本地测试

   ```sh
   [root@client ~]# sh /home/scripts/nginx_status.sh active
   1
   
   ```

4. 定义监控脚本key

   ```sh
   [root@client ~]# vim /etc/zabbix/zabbix_agentd.conf
   # 找到如下类似的变量，并手动添加
   UnsafeUserParameters=1
   UserParameter=nginx.status[*],/home/scripts/nginx_status.sh $1
   
   ```

5. 重启zabbix agent

   ```sh
   [root@client ~]# systemctl restart zabbix-agent
   ```

6. 服务端获取数据

   ```sh
   [root@server scripts]# zabbix_get -s 192.168.223.7 -k nginx.status[active]
   1
   
   
   # 注意
   1.如果没有命令则下载
     [root@server scripts]# rpm -Uvh https://repo.zabbix.com/zabbix/5.0/rhel/7/x86_64/zabbix-release-5.0-1.el7.noarch.rpm
     [root@server scripts]# yum clean all
     [root@server scripts]# yum install zabbix-get
   ```

   

## 创建nginx模板

1. 创建模板

   配置  ----->> 模板 ---->> 创建模板

   ![](https://gitee.com/fan-dongyuan/ty-gallery/raw/master/%E5%B7%A5%E5%9D%8A%E5%9B%BE/zabbix/nginxjk1.png)

   返回模板页已经看到创建的模板已经生成，这时创建的模板是空模板，要在这个模板中创建应用集，监控项等，点击下图中的应用集就可以直接创建

   ![](https://gitee.com/fan-dongyuan/ty-gallery/raw/master/%E5%B7%A5%E5%9D%8A%E5%9B%BE/zabbix/nginxjk2.png)

2. 创建应用集

   ![](https://gitee.com/fan-dongyuan/ty-gallery/raw/master/%E5%B7%A5%E5%9D%8A%E5%9B%BE/zabbix/nginxjk3.png)

   ![](https://gitee.com/fan-dongyuan/ty-gallery/raw/master/%E5%B7%A5%E5%9D%8A%E5%9B%BE/zabbix/nginxjk4.png)

3. 创建监控项

   ![](https://gitee.com/fan-dongyuan/ty-gallery/raw/master/%E5%B7%A5%E5%9D%8A%E5%9B%BE/zabbix/nginxjk5.png)

   创建监控项要注意命名方式，能够见名知意，最关键的是键值 ，这里的键值一点要和agent端的配置文件中定义的键值一致

   ![](https://gitee.com/fan-dongyuan/ty-gallery/raw/master/%E5%B7%A5%E5%9D%8A%E5%9B%BE/zabbix/nginxjk6.png)

   在监控脚本中一共定义了七个监控项，所以这里需要创建七个，重复上方步骤即可

4. 创建图形

   这里顺便可以显示每个监控项的参数

   ![](https://gitee.com/fan-dongyuan/ty-gallery/raw/master/%E5%B7%A5%E5%9D%8A%E5%9B%BE/zabbix/nginxjk7.png)

   ![](https://gitee.com/fan-dongyuan/ty-gallery/raw/master/%E5%B7%A5%E5%9D%8A%E5%9B%BE/zabbix/nginxjk8.png)

5. 为监控的主机添加模板

   ![](https://gitee.com/fan-dongyuan/ty-gallery/raw/master/%E5%B7%A5%E5%9D%8A%E5%9B%BE/zabbix/nginxjk9.png)

6. 查看最新数据

   ![](https://gitee.com/fan-dongyuan/ty-gallery/raw/master/%E5%B7%A5%E5%9D%8A%E5%9B%BE/zabbix/nginxjk10.png)

7. 查看图形

   ![](https://gitee.com/fan-dongyuan/ty-gallery/raw/master/%E5%B7%A5%E5%9D%8A%E5%9B%BE/zabbix/nginxjk11.png)









## 设置nginx邮件告警

1. client安装killall工具

   ```sh
   [root@client ~]# yum install -y psmisc
   [root@client ~]# chmod 755 /usr/bin/killall
   ```

2. 编辑脚本

   ```sh
   [root@client sh]# cat 1.sh 
   #!/bin/bash
   fdy=`ps -ef |grep nginx|grep -v grep|wc -l`
   if [ $fdy -eq 2 ];then
   	echo 1
   else
   	echo 0
   fi
   
   ```
   
3. 配置zabbix_agent.conf

   ```sh
   [root@client scripts]# vim /etc/zabbix/zabbix_agentd.conf 
   UnsafeUserParameters=1
   ### Option: UserParameter
   #       User-defined parameter to monitor. There can be several user-defined parameters.
   #       Format: UserParameter=<key>,<shell command>
   #       See 'zabbix_agentd' directory for examples.
   #
   # Mandatory: no
   # Default:
   UserParameter=nginx.killall, sh /data/sh/1.sh
   ```
   
4. 重启服务

   ```sh
   [root@client scripts]# systemctl restart zabbix-agent
   ```

5. server段测试

   ```sh
   [root@server scripts]# zabbix_get -s 192.168.223.7 -k "nginx.killall"
   1
   ```

6. 注意！

   因为这里本人实验重置了，没有按照上面的实验继续，实验环境的位置在（zabbix邮箱脚本告警）

7. 修改主机名与客户端主机名一致

   ![](https://gitee.com/fan-dongyuan/ty-gallery/raw/master/%E5%B7%A5%E5%9D%8A%E5%9B%BE/zabbix/nginxgj1.png)

8. 在client主机上添加监控项（先添加应用集）

   ![](https://gitee.com/fan-dongyuan/ty-gallery/raw/master/%E5%B7%A5%E5%9D%8A%E5%9B%BE/zabbix/nginxgj2.png)

   ![](https://gitee.com/fan-dongyuan/ty-gallery/raw/master/%E5%B7%A5%E5%9D%8A%E5%9B%BE/zabbix/nginxgj3.png)

   ![](https://gitee.com/fan-dongyuan/ty-gallery/raw/master/%E5%B7%A5%E5%9D%8A%E5%9B%BE/zabbix/nginxgj4.png)

9. 创建触发器

   ![](https://gitee.com/fan-dongyuan/ty-gallery/raw/master/%E5%B7%A5%E5%9D%8A%E5%9B%BE/zabbix/nginxgj5.png)

   ![](https://gitee.com/fan-dongyuan/ty-gallery/raw/master/%E5%B7%A5%E5%9D%8A%E5%9B%BE/zabbix/nginxgj6.png)

10. 在Mailx上添加额外动作

    ![](https://gitee.com/fan-dongyuan/ty-gallery/raw/master/%E5%B7%A5%E5%9D%8A%E5%9B%BE/zabbix/nginxgj7.png)

11. 关闭客户端nginx服务等待邮件通知





## 设置nginx宕机自启

1. 在Mailx的动作中设置额外操作

   ![](https://gitee.com/fan-dongyuan/ty-gallery/raw/master/%E5%B7%A5%E5%9D%8A%E5%9B%BE/zabbix/nginxzq1.png)

2. 验证

   ![](https://gitee.com/fan-dongyuan/ty-gallery/raw/master/%E5%B7%A5%E5%9D%8A%E5%9B%BE/zabbix/nginxzq2.png)









# MySQL自动化状态监控以及告警

## MySQL主从部署

1. 详细请看https://gitee.com/fan-dongyuan/yun/blob/master/%E5%B7%A5%E5%9D%8A/%E4%BB%BB%E5%8A%A1/MySQL.md

2. 做到读写分离前即可

3. 测试拉取主从状态值

   ```sh
   [root@slave ~]# mysql -u root -p123456 -e "show slave status\G" | grep "Running" |awk "{print $2}" | grep -c "Yes"   
   mysql: [Warning] Using a password on the command line interface can be insecure.
   2
   
   
   # 注意
   1. 出现mysql: [Warning] Using a password on the command line interface can be insecure.的警告，说明密码已在日志中显示，我们在以后的工作中不能这样子，这会加大密码泄露的风险
      解决方式
      [root@slave ~]# vim /etc/my.passwd
      [client]
      user=root
      password=123456
      host=localhost
      [root@slave ~]# mysql --defaults-extra-file=/etc/my.passwd  -e "show slave status\G" | grep "Running" |awk "{print $2}" |    grep -c "Yes"   
      2
   ```

   

