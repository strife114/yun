# Nginx高可用

## 简介

此次实验目的是为了实现nginx高可用，防止一个nginx宕机后，无法对外提供服务

## 环境

| 主机              | IP              |
| ----------------- | --------------- |
| nginx、keepalived | 192.168.223.3   |
| nginx、keepalived | 192.168.223.4   |
| 虚拟ip            | 192.168.223.200 |



## 时间同步

1. master安装ntp服务并启动

   ```sh
   [root@master ~]# yum install -y ntp
   [root@master ~]# systemctl start ntpd
   [root@master ~]# systemctl enable ntpd
   
   ```

2. slave安装ntp但不必启动

   ```sh
   [root@slave ~]# yum install -y ntp
   [root@slave ~]# ntpdate master
   7 Mar 10:55:43 ntpdate[57576]: adjust time server 192.168.223.3 offset 0.001238 sec
    
    
   # 注意
   如果没出现此adjust不必担心，等待即可，或者直接用date命令查看两台虚拟机的时间即可
   ```



## nginx安装

1. 在master节点和slave安装

   ```sh
   [root@master ~]# rpm -Uvh http://nginx.org/packages/centos/7/noarch/RPMS/nginx-release-centos-7-0.el7.ngx.noarch.rpm
   [root@master ~]# yum  -y install  nginx
   [root@slave ~]# rpm -Uvh http://nginx.org/packages/centos/7/noarch/RPMS/nginx-release-centos-7-0.el7.ngx.noarch.rpm
   [root@slave ~]# yum  -y install  nginx
   ```



## keepalived

### 安装

1. 在master和slave上安装

   ```
   [root@master ~]# yum install -y keepalived
   [root@slave ~]# yum install -y keepalived
   ```



### 配置

1. 修改master配置文件

   ```sh
   [root@master ~]# vim /etc/keepalived/keepalived
   global_defs {
      notification_email {
           123123@qq.com
      }
      notification_email_from root@aaaaa.com
      smtp_server 127.0.0.1
      smtp_connect_timeout 30
      router_id LVS_DEVEL
   }
   
   vrrp_script chk_nginx {
       script "/usr/local/sbin/check_ng.sh"
       interval 3
       }
   
   vrrp_instance VI_1 {
       state MASTER
       interface ens33
       virtual_router_id 51
       priority 100
       advert_int 1
       authentication {
           auth_type PASS
           auth_pass 1111
       }
       virtual_ipaddress {
           192.168.223.200
       }
       track_script {
           chk_nginx
       }
   }
   ```

2. 修改salve配置文件

   ```sh
   [root@slave ~]# vim /etc/keepalived/keepalived
   global_defs {
      notification_email {
           123123@qq.com
      }
      notification_email_from root@aaaaa.com
      smtp_server 127.0.0.1
      smtp_connect_timeout 30
      router_id LVS_DEVEL
   }
   
   vrrp_script chk_nginx {
       script "/usr/local/sbin/check_ng.sh"
       interval 3
       }
   
   vrrp_instance VI_1 {
       state BACKUP
       interface ens33
       virtual_router_id 51
       priority 99
       advert_int 1
       authentication {
           auth_type PASS
           auth_pass 1111
       }
       virtual_ipaddress {
           192.168.223.200
       }
       track_script {
           chk_nginx
       }
   }
   
   ```

3. 在master和slave上编写nginx监控自启脚本

   ```sh
   [root@master ~]# vim  /usr/local/sbin/check_ng.sh
   #!/bin/bash
   #version 1
   A=`ps -C nginx --no-header |wc -l`
   if [ $A -eq 0 ];then
        systemctl start  nginx
         sleep 3
               if [ `ps -C nginx --no-header |wc -l` -eq 0 ];then
                     systemctl stop keepalived
   fi
   fi
   
   
   [root@slave ~]# vim  /usr/local/sbin/check_ng.sh
   
   #!/bin/bash
   #version 1
   A=`ps -C nginx --no-header |wc -l`
   if [ $A -eq 0 ];then
        systemctl start  nginx
         sleep 3
               if [ `ps -C nginx --no-header |wc -l` -eq 0 ];then
                     systemctl stop keepalived
   fi
   fi
   ```



## 测试

1. 关闭master服务检查vip是否滑动
2. 浏览器访问vip是否有欢迎界面





# Nginx负载均衡

## 简介

此实验主要目的根据调度器实现负载均衡，避免一个服务器因访问量过大导致宕机

## 环境

| 主机   | IP              |
| ------ | --------------- |
| 调度器 | 192.168.223.5   |
| web1   | 192.168.223.3   |
| web2   | 192.168.223.4   |
| 虚拟ip | 192.168.223.200 |



## DR调度器

### 安装

1. 安装keepalived

   ```sh
   [root@dir ~]# yum -y install keepalived
   [root@dir ~]# yum -y install ipvsadm
   ```

### 配置

1. 编写初始化脚本

   ```sh
   [root@dir ~]# vim /usr/local/sbin/lvs_rs.sh 
   #! /bin/bash
   echo 1 > /proc/sys/net/ipv4/ip_forward
   ipv=/usr/sbin/ipvsadm
   vip=192.168.223.200
   rs1=192.168.223.3
   rs2=192.168.223.4
   #注意这里的网卡名字
   ifconfig ens33:2 $vip broadcast $vip netmask 255.255.255.255 up
   route add -host $vip dev ens33:2
   $ipv -C
   $ipv -A -t $vip:80 -s wrr
   $ipv -a -t $vip:80 -r $rs1:80 -g -w 1
   $ipv -a -t $vip:80 -r $rs2:80 -g -w 
   ```

2. 执行初始化脚本

   ```sh
   [root@dir ~]# sh -x /usr/local/sbin/lvs_rs.sh 
   ```

3. 编写keepalived配置文件

   ```sh
   [root@dir ~]# vim /etc/keepalived/keepalived.conf
   vrrp_instance VI_1 {
       state MASTER
       interface ens33
       virtual_router_id 51
       priority 100
       advert_int 1
       authentication {
           auth_type PASS
           auth_pass 1111
       }
       virtual_ipaddress {
           192.168.223.200
       }
   }
   
   virtual_server 192.168.223.200 80 {		#VIP
       delay_loop 10		#每隔10秒查询realserver状态
       lb_algo wlc					#lvs算法
       lb_kind DR					#DR模式
       persistence_timeout 60		    #(同一IP的连接60秒内被分配到同一台realserver)
       protocol TCP		#用TCP协议检查realserver状态
   
       real_server 192.168.223.3 80 {		#真实服务器ip
           weight 100		#权重
           TCP_CHECK {
               connect_timeout 10		# 10秒无响应超时（连接超时时间）
               nb_get_retry 3			#失败重试次数
               delay_before_retry 3	#失败重试的间隔时间
               connect_port 80		#连接的后端端口
           }
   }
        real_server 192.168.223.4 80 {
           weight 100
           TCP_CHECK {
               connect_timeout 10
               nb_get_retry 3
               delay_before_retry 3
               connect_port 80
           }
       }
   }
   
   ```



## web服务器

### 安装

1. 安装nginx

   ```sh
   [root@dir ~]# systemctl start keepalived
   [root@web1 ~]# systemctl start nginx
   [root@web2 ~]# systemctl start  nginx
   ```

### 配置

1. 编写初始化脚本

   ```sh
   [root@web1 ~]# vim /usr/local/sbin/lvs_rs.sh 
   #/bin/bash
   vip=192.168.223.200
   #把vip绑定在lo上，是为了实现rs直接把结果返回给客户端
   ifconfig lo:0 $vip broadcast $vip netmask 255.255.255.255 up
   route add -host $vip lo:0
   #以下操作为更改arp内核参数，目的是为了让rs顺利发送mac地址给客户端
   echo "1" >/proc/sys/net/ipv4/conf/lo/arp_ignore
   echo "2" >/proc/sys/net/ipv4/conf/lo/arp_announce
   echo "1" >/proc/sys/net/ipv4/conf/all/arp_ignore
   echo "2" >/proc/sys/net/ipv4/conf/all/arp_announce
   
   
   
   [root@web2 ~]# vim /usr/local/sbin/lvs_rs.sh 
   #/bin/bash
   vip=192.168.223.200
   #把vip绑定在lo上，是为了实现rs直接把结果返回给客户端
   ifconfig lo:0 $vip broadcast $vip netmask 255.255.255.255 up
   route add -host $vip lo:0
   #以下操作为更改arp内核参数，目的是为了让rs顺利发送mac地址给客户端
   echo "1" >/proc/sys/net/ipv4/conf/lo/arp_ignore
   echo "2" >/proc/sys/net/ipv4/conf/lo/arp_announce
   echo "1" >/proc/sys/net/ipv4/conf/all/arp_ignore
   echo "2" >/proc/sys/net/ipv4/conf/all/arp_announce
   ```

2. 执行脚本

   ```sh
   [root@web1 ~]# sh -x /usr/local/sbin/lvs_rs.sh 
   [root@web2 ~]# sh -x /usr/local/sbin/lvs_rs.sh 
   ```



## 测试

1. 启动所有服务

   ```sh
   [root@dir ~]# systemctl start keepalived
   [root@web1 ~]# systemctl start nginx
   [root@web2 ~]# systemctl start nginx
   ```

2. 查看lvs连接情况

   ```
   [root@dir ~]#ipvsadm -ln
   ```

3. 访问

   ```sh
   [root@localhost ~]# curl 192.168.223.200
   <h1>111</h1>
   [root@localhost ~]# curl 192.168.223.200
   <h1>222</h1>
   [root@localhost ~]# curl 192.168.223.200
   <h1>111</h1>
   [root@localhost ~]# curl 192.168.223.200
   <h1>222</h1>
   [root@localhost ~]# curl 192.168.223.200
   <h1>111</h1>
   [root@localhost ~]# curl 192.168.223.200
   <h1>222</h1>
   [root@localhost ~]# curl 192.168.223.200
   <h1>111</h1>
   ```

   





# Nginx反向代理

## 简介

此实验主要部署两台apache，两台代理，同时代理实现高可用,通过访问代理虚拟ip成功轮询两台apache

## 环境

| 主机              | IP              |
| ----------------- | --------------- |
| nginx、keepalived | 192.168.223.3   |
| nginx、keepalived | 192.168.223.4   |
| apache1           | 192.168.223.5   |
| apache2           | 192.168.223.6   |
| 虚拟ip            | 192.168.223.200 |



## keepalived、nginx、apache安装

1. keepalived安装

   ```sh
   [root@master ~]# yum install -y keepalived
   [root@slave ~]# yum install -y keepalived
   ```

2. nginx安装

   ```sh
   [root@master ~]# rpm -Uvh http://nginx.org/packages/centos/7/noarch/RPMS/nginx-release-centos-7-0.el7.ngx.noarch.rpm
   [root@master ~]# yum  -y install  nginx
   [root@slave ~]# rpm -Uvh http://nginx.org/packages/centos/7/noarch/RPMS/nginx-release-centos-7-0.el7.ngx.noarch.rpm
   [root@slave ~]# yum  -y install  nginx
   ```

3. apache安装

   ```sh
   [root@apache1 ~]# yum install -y httpd
   [root@apache2 ~]# yum install -y httpd
   ```

   

## nginx代理配置

### 配置

1. 修改master和slave的nginx配置文件

   ```sh
   # 添加apache的ip地址
       upstream  apacheserver{
       server  192.168.223.5;
       server  192.168.223.6;
   }
   server{
       listen  80;
       server_name   www.123.com;
       location  / {
       proxy_pass  http://apacheserver;
       root   html;
       index  index.html  index.htm;
   }
   }
   ```

   ```shell
   # vim /etc/nginx/nginx.conf
   user  nginx;
   worker_processes  auto;
   
   error_log  /var/log/nginx/error.log notice;
   pid        /var/run/nginx.pid;
   
   
   events {
       worker_connections  1024;
   }
   
   
   http {
       include       /etc/nginx/mime.types;
       default_type  application/octet-stream;
   
       log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
                         '$status $body_bytes_sent "$http_referer" '
                         '"$http_user_agent" "$http_x_forwarded_for"';
   
       access_log  /var/log/nginx/access.log  main;
   
       sendfile        on;
       #tcp_nopush     on;
   
       keepalive_timeout  65;
   
       #gzip  on;
       upstream  apacheserver{
       server  192.168.223.5;
       server  192.168.223.6;
   }
   server{
       listen  80;
       server_name   www.123.com;
       location  / {
       proxy_pass  http://apacheserver;
       root   html;
       index  index.html  index.htm;
   }
   }
       include /etc/nginx/conf.d/*.conf;
   }
   ```

   

### 测试

1. 重启服务

   ```sh
   systemctl restart nginx
   ```

2. 浏览器访问master和slave的ip（可轮询）



## nginx高可用

### 配置

1. 修改master配置文件

   ```sh
   [root@master ~]# cp /etc/keepalived/keepalived.conf /etc/keepalived/keepalived.conf.bak
   [root@master ~]# vim /etc/keepalived/keepalived.conf
   global_defs {
       notification_email {   # keepalived服务宕机异常出现的时候，发送通知邮件 可以是多个
         acassen@firewall.loc  #  收件人邮箱1
         failover@firewall.loc   #  收件人邮箱2
         sysadmin@firewall.loc   #  收件人邮箱3
       }
       notification_email_from Alexandre.Cassen@firewall.loc   #邮件发件人
       smtp_ server 192.168.223.3  #主服务器的ip地址。邮件服务器地址
       smtp_connect_timeout 30    # 超时时间
       router_id LVS_DEVEL    # 机器标识 局域网内唯一即可。 LVS_DEVEL这字段在/etc/hosts文件中看；通过它访问到主机
   }
   vrrp_script chk_http_ port {
       script "/usr/local/src/nginx_check.sh"   #检测脚本存放的路径
       interval 2   # 检测脚本执行的间隔，即检测脚本每隔2s会自动执行一次
       weight 2  #权重，如果这个脚本检测为真，服务器权重+2
   }
   vrrp_instance VI_1 {
       state MASTER    # 指定keepalived的角色，MASTER为主，BACKUP为备。备份服务器上需将MASTER 改为BACKUP
       interface ens33  # 通信端口 通过ip addr可以看到，根据自己的机器配置
       virtual_router_id 51 # vrrp实例id  keepalived集群的实例id必须一致，即主、备机的virtual_router_id必须相同
       priority 100         #优先级，数值越大，获取处理请求的优先级越高。主、备机取不同的优先级，主机值较大，备份机值较小
       advert_int 1    #心跳间隔，默认为1s。keepalived多机器集群 通过心跳检测当前服务器是否还正常工作，如果发送心跳没反应，备份服务器就会立刻接管；
       authentication {     # 服务器之间通信密码
           auth type PASS   #设置验证类型和密码，MASTER和BACKUP必须使用相同的密码才能正常通信
           auth pass 1111
       }
       virtual_ipaddress {
           192.168.223.200  # 定义虚拟ip(VIP)，可多设，每行一个
       }
   }
   
   ```

2. 修改slave配置文件

   ```sh
   [root@slave ~]# cp /etc/keepalived/keepalived.conf /etc/keepalived/keepalived.conf.bak
   [root@slave ~]# vim /etc/keepalived/keepalived.conf
   global_defs {
       notification_email {
         acassen@firewall.loc
         failover@firewall.loc
         sysadmin@firewall.loc
       }
       notification_email_from Alexandre.Cassen@firewall.loc
       smtp_ server 192.168.223.4    #备份服务器的ip地址
       smtp_connect_timeout 30
       router_id LVS_DEVEL    # LVS_DEVEL这字段在/etc/hosts文件中看；通过它访问到主机
   }
   vrrp_script chk_http_ port {
       script "/usr/local/src/nginx_check.sh"   #检测脚本
       interval 2   # (检测脚本执行的间隔)2s
       weight 2  #权重，如果这个脚本检测为真，服务器权重+2
   }
   vrrp_instance VI_1 {
       state BACKUP    # 指定keepalived的角色，MASTER为主，BACKUP为备。备份服务器上需将MASTER 改为BACKUP
       interface ens33 # 当前进行vrrp通讯的网络接口卡(当前centos的网卡) 用ifconfig查看你具体的网卡
       virtual_router_id 51 # 虚拟路由编号，主、备机的virtual_router_id必须相同
       priority 90         #优先级，数值越大，获取处理请求的优先级越高。主、备机取不同的优先级，主机值较大，备份机值较小
       advert_int 1    # 检查间隔，默认为1s(vrrp组播周期秒数)，每隔1s发送一次心跳
       authentication {     # 校验方式， 类型是密码，密码1111
           auth type PASS   #设置验证类型和密码，MASTER和BACKUP必须使用相同的密码才能正常通信
           auth pass 1111
       }
       virtual_ipaddress {  # 虛拟ip
           192.168.223.200  # 定义虚拟ip(VIP)，可多设，每行一个
       }
   }
   ```

3. 在master和slave编写nginx监控自启脚本

   ```sh
   [root@master ~]# vim  /usr/local/sbin/check_ng.sh
   #! /bin/bash
   #检测nginx是否启动了
   A=`ps -C nginx –no-header |wc -l`
   if [ $A -eq 1];then    #如果nginx没有启动就启动nginx 
       /usr/sbin/nginx    #通过Nginx的启动脚本来重启nginx
       sleep 2
       if [`ps -C nginx –no-header |wc -l` -eq 1 ];then   #如果nginx重启失败，则下面就会停掉keepalived服务，进行VIP转移
           killall keepalived
       fi
   fi
   
   
   
   [root@slave ~]# vim  /usr/local/sbin/check_ng.sh
   #! /bin/bash
   #检测nginx是否启动了
   A=`ps -C nginx –no-header |wc -l`
   if [ $A -eq 1];then    #如果nginx没有启动就启动nginx 
       /usr/sbin/nginx    #通过Nginx的启动脚本来重启nginx
       sleep 2
       if [`ps -C nginx –no-header |wc -l` -eq 1 ];then   #如果nginx重启失败，则下面就会停掉keepalived服务，进行VIP转移
           killall keepalived
       fi
   fi
   
   
   
   
   
   
   # 脚本测试
   # 如果值为1，即代表服务未启动
   # 如果值大于1，即代表服务已启动
   ps -C nginx --no-header|wc -l
   
   
   # 注意
   如果脚本不可用，请使用下方脚本
   #!/bin/bash
   #version 1
   A=`ps -C nginx --no-header |wc -l`
   if [ $A -eq 0 ];then
        systemctl start  nginx
         sleep 3
               if [ `ps -C nginx --no-header |wc -l` -eq 0 ];then
                     systemctl stop keepalived
   fi
   fi
   ```

   

### 测试

1. 开启master和slave服务

   ```sh
   [root@master ~]# systemctl  restart   keepalived
   [root@master ~]# systemctl  restart   nginx
   
   [root@slave ~]# systemctl  restart   keepalived
   [root@slave ~]# systemctl  restart   nginx
   ```

2. 通过浏览器访问虚拟ip

3. 关闭master服务并在slave查看虚拟ip