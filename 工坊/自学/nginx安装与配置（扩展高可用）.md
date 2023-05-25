# 安装nginx



1. 下载

   ```
   # cd /usr/local/src/
   # wget http://nginx.org/download/nginx-1.13.0.tar.gz
   ```

2. 编译安装

   ```
   # 安装之前下载依赖包
   
   #安装gcc环境
   yum install gcc-c++
   #安装pcre-deve
   yum install pcre-devel
   #安装zlib
   yum install -y zlib zlib-devel
   #安装OpenSSL
   yum install -y openssl openssl-devel
   #安装wget
   yum install wget
   
   
   # cd /usr/local/src/
   # tar -zxvf nginx-1.13.0.tar.gz
   # cd nginx-1.13.0
   # ./configure --prefix=/usr/local/nginx
   # make && make install
   ```

3. 配置nginx

   ```
   # vi /usr/local/nginx/conf/nginx.conf
   ```

   ```
   user root;
   worker_processes 1;
   #error_log logs/error.log;
   #error_log logs/error.log notice;
   #error_log logs/error.log info;
   #pid logs/nginx.pid;
   events {
   	worker_connections 1024;
   }
   http {
   	include mime.types;
   	default_type application/octet-stream;
   	#log_format main '$remote_addr - $remote_user [$time_local] "$request" '
   	# '$status $body_bytes_sent "$http_referer" '
   	# '"$http_user_agent" "$http_x_forwarded_for"';
   	#access_log logs/access.log main;
   	sendfile on;
   	#tcp_nopush on;
   	#keepalive_timeout 0;
   	keepalive_timeout 65;
   	#gzip on;
   	server {
   	    # 监听端口
   		listen 80;
   		server_name localhost;
   		#charset koi8-r;
   		#access_log logs/host.access.log main;
   		location / {
   			root html;
   			index index.html index.htm;
   		}
   		#error_page 404 /404.html;
   		# redirect server error pages to the static page /50x.html
   		error_page 500 502 503 504 /50x.html;
   		location = /50x.html {
   			root html;
   		}
   	}
   }
   ```

4. 测试

   ```
   # /usr/local/nginx/sbin/nginx -t
   nginx: the configuration file /usr/local/nginx/conf/nginx.conf syntax is ok
   nginx: configuration file /usr/local/nginx/conf/nginx.conf test is successful
   ```

5. 修改文件名

   ```
   vim /usr/local/nginx/html/index.html
   ```

   

6. 设置自启

   ```
   cd /etc/systemd/system
   ```

   ```
   vi nginx.service
   ```

   ```
   [Unit]
   Description=nginx service
   After=network.target
   
   [Service]
   Type=forking
   ExecStart=/usr/local/nginx/sbin/nginx
   ExecReload=/usr/local/nginx/sbin/nginx -s reload
   ExecStop=/usr/local/nginx/sbin/nginx -s quit
   PrivateTmp=true
   
   [Install]
   WantedBy=multi-user.target
   
   
   ```

   ```
   systemctl enable nginx
   ```

7. 启动

   ```
   systemctl start nginx.service
   ```

   



# keepalived+nginx实现高可用

1. 安装keepalived

   ```
   yum install -y keepalived
   ```

2. 设置自启

   ```
   chkconfig keepalived on
   ```

3. 修改主配置文件

   ```
   vi /etc/keepalived/keepalived.conf
   
   ```

   ```
   ! Configuration File for keepalived
   
   global_defs {
      notification_email {
        acassen@firewall.loc
        failover@firewall.loc
        sysadmin@firewall.loc
      }
      notification_email_from Alexandre.Cassen@firewall.loc
      smtp_server 192.168.200.1
      smtp_connect_timeout 30
      router_id LVS_DEVEL
   }
   
   #keepalived会定时执行脚本并对脚本执行的结果进行分析，动态调整vrrp_instance的优先级。
   vrrp_script chk_nginx {
       #运行脚本，脚本内容下面有，就是起到一个nginx宕机以后，自动开启服务
       script "/etc/keepalived/nginx_check.sh" 
       interval 1 #检测时间间隔
       weight -2 #如果条件成立的话，则权重 -2
   }
   
   vrrp_instance VI_1 {
       state MASTER #来决定主从 
       interface ens33 # 绑定 IP 的网卡口，根据自己的机器填写    （修）
       virtual_router_id 120 # 虚拟路由的 ID 号， 两个节点设置必须一样
       mcast_src_ip 192.168.52.136 #填写本机ip    （修）
       priority 100 # 节点优先级,主要比从节点优先级高
       advert_int 1 # 组播信息发送间隔，两个节点设置必须一样，默认 1s
       authentication {
           auth_type PASS
           auth_pass 1111
       }
       # 将 track_script 块加入 instance 配置块
       track_script {
           chk_nginx #执行 Nginx 监控的服务
       }
   
       virtual_ipaddress {
           192.168.52.120/24 # 虚拟ip，通过虚拟Ip切换进行nginx主备切换功能（修）
       }
   }
   
   ```

4. 辅配置文件

   ```
   ! Configuration File for keepalived
   
   vrrp_script chk_nginx {
       script "/etc/keepalived/nginx_check.sh" #运行脚本，脚本内容下面有，就是起到一个nginx宕机以后，自动开启服务
       interval 1 #检测时间间隔
       weight -2 #如果条件成立的话，则权重 -20
   }
   
   vrrp_instance VI_1 {
       state BACKUP #来决定主从
       interface ens33 # 绑定 IP 的网卡名称，根据自己的机器填写
       virtual_router_id 120 # 虚拟路由的 ID 号， 两个节点设置必须一样
       mcast_src_ip 192.168.52.130 #填写本机ip
       priority 99 # 节点优先级,主要比从节点优先级高
       advert_int 1 # 组播信息发送间隔，两个节点设置必须一样，默认 1s
       #nopreempt #设置为不抢夺VIP
       authentication {
           auth_type PASS
           auth_pass 1111
       }
       # 将 track_script 块加入 instance 配置块
       track_script {
           chk_nginx #执行 Nginx 监控的服务
       }
   
       virtual_ipaddress {
           192.168.52.120/24 # 虚拟ip
       }
   }
   
   ```

5. 设置nginx检查脚本

   ```
   vi /etc/keepalived/nginx_check.sh
   chmod 755 /etc/keepalived/nginx_check.sh
   
   ```

   ```
   NGINXPID="/usr/local/nginx/logs/nginx.pid"
   if [ ! -f $NGINXPID  ];then
       /usr/local/nginx/sbin/nginx
       sleep 2
       NGINXPID="/usr/local/nginx/logs/nginx.pid"
       if [ ! -f $NGINXPID ];then
           killall keepalived
       fi
   fi
   
   ```

6. 启动

   ```
   service keepalived start | stop | restart
   ```

7. 查看ip

8. 使用浏览器访问虚拟IP

9. 关掉master的keepalived和nginx

10. 使用浏览器访问虚拟ip