# Loki简介

Loki相比EFK/ELK，它不对原始日志进行索引，只对日志的标签进行索引，而日志通过压缩进行存储，通常是文件系统存储，所以其操作成本更低，数量级效率更高

由于Loki的存储都是基于文件系统的，所以它的日志搜索时基于内容即日志行中的文本，所以它的查询支持LogQL，在搜索窗口中通过过滤标签的方式进行搜索和查询

Loki分两部分，Loki是日志引擎部分，Promtail是收集日志端，然后通过Grafana进行展示

> Promtail: 代理，负责收集日志并将其发送给 loki
>
> Loki: 日志记录引擎，负责存储日志和处理查询
>
> Grafana: UI 界面



# 环境

| IP              | 节点规划                | 实验身份   |
| --------------- | ----------------------- | ---------- |
| 192.168.223.100 | loki、grafana、promtail | 主控节点   |
| 192.168.223.7   | promtail                | 被监控节点 |



# 下载安装loki、grafana、promtail

```sh
[root@master ~]# curl -O -L "https://github.com/grafana/loki/releases/download/v1.5.0/loki-linux-amd64.zip" 
[root@master ~]# curl -O -L "https://github.com/grafana/loki/releases/download/v1.5.0/promtail-linux-amd64.zip"
[root@master ~]# wget https://dl.grafana.com/oss/release/grafana-6.7.4-1.x86_64.rpm

[root@master ~]# yum install -y unzip
[root@master ~]# unzip loki-linux-amd64.zip
[root@master ~]# unzip promtail-linux-amd64.zip
[root@master ~]# rpm -ivh grafana-6.7.4-1.x86_64.rpm



# 注意
1. 出现缺少fontconfig和urw-fonts依赖包
# 解决方法
1. yum install -y fontconfig urw-fonts
```





# 自定义Loki配置文件

```yaml
[root@master ~]# cat loki.yaml
auth_enabled: false

server:
  http_listen_port: 3100

ingester:
  lifecycler:
    address: 127.0.0.1
    ring:
      kvstore:
        store: inmemory
      replication_factor: 1
    final_sleep: 0s
  chunk_idle_period: 5m
  chunk_retain_period: 30s

schema_config:
  configs:
    - from: 2018-04-15
      store: boltdb
      object_store: filesystem
      schema: v9
      index:
        prefix: index_
        period: 168h

storage_config:
  boltdb:
    directory: /tmp/loki/index

  filesystem:
    directory: /tmp/loki/chunks

limits_config:
  enforce_metric_name: false
  reject_old_samples: true
  reject_old_samples_max_age: 168h

#chunk_store_config:
##  max_look_back_period: 0
#
##table_manager:
##  chunk_tables_provisioning:
##    inactive_read_throughput: 0
##    inactive_write_throughput: 0
##    provisioned_read_throughput: 0
##    provisioned_write_throughput: 0
##  index_tables_provisioning:
##    inactive_read_throughput: 0
##    inactive_write_throughput: 0
##    provisioned_read_throughput: 0
##    provisioned_write_throughput: 0
##  retention_deletes_enabled: false
##  retention_period: 0

```





# 自定义Promtail配置文件

```yaml
[root@master ~]# cat promtail.yaml 
server:
  http_listen_port: 9080
  grpc_listen_port: 0

positions:
  filename: /tmp/positions.yaml

# Loki服务器地址
clients:
  - url: http://127.0.0.1:3100/loki/api/v1/push

scrape_configs:
  - job_name: linux
    static_configs:
      - targets:
          - localhost
        labels:
           job: messages
           host: localhost
           __path__: /var/log/messages*





# 注意：
1.关键词为scrape_configs下的所有参数
```



# Grafana安装

```sh
#安装依赖
[root@master ~]# yum install initscripts fontconfig  
[root@master ~]# yum install freetype
[root@master ~]# yum install urw-fonts

#安装
[root@master ~]# rpm -ivh grafana-6.7.4-1.x86_64.rpm
```



# Loki服务启动

```sh
[root@master ~]# systemctl start grafana-server.service
```



# Loki组件启动

```sh
[root@master ~]# nohup ./loki-linux-amd64 -config.file=/root/loki.yaml & 

# 检测
[root@master ~]# netstat -lntp
# 有3100即可
Active Internet connections (only servers)
Proto Recv-Q Send-Q Local Address           Foreign Address         State       PID/Program name    
tcp        0      0 127.0.0.1:25            0.0.0.0:*               LISTEN      1244/master         
tcp        0      0 0.0.0.0:22              0.0.0.0:*               LISTEN      991/sshd            
tcp6       0      0 :::3000                 :::*                    LISTEN      2163/grafana-server 
tcp6       0      0 ::1:25                  :::*                    LISTEN      1244/master         
tcp6       0      0 :::3100                 :::*                    LISTEN      2040/./loki-linux-a 
tcp6       0      0 :::9095                 :::*                    LISTEN      2040/./loki-linux-a 
tcp6       0      0 :::45579                :::*                    LISTEN      2143/./promtail-lin 
tcp6       0      0 :::22                   :::*                    LISTEN      991/sshd 
```



# Promtail组件启动

```sh
[root@master ~]# nohup ./promtail-linux-amd64 -config.file=/root/promtail.yaml &


# 检测
[root@master ~]# netstat -lntp
# 有9080即可
[root@master ~]# netstat -lntp
Active Internet connections (only servers)
Proto Recv-Q Send-Q Local Address           Foreign Address         State       PID/Program name    
tcp        0      0 127.0.0.1:25            0.0.0.0:*               LISTEN      1244/master         
tcp        0      0 0.0.0.0:22              0.0.0.0:*               LISTEN      991/sshd            
tcp6       0      0 :::3000                 :::*                    LISTEN      2163/grafana-server 
tcp6       0      0 :::9080                 :::*                    LISTEN      2143/./promtail-lin 
tcp6       0      0 ::1:25                  :::*                    LISTEN      1244/master         
tcp6       0      0 :::3100                 :::*                    LISTEN      2040/./loki-linux-a 
tcp6       0      0 :::9095                 :::*                    LISTEN      2040/./loki-linux-a 
tcp6       0      0 :::45579                :::*                    LISTEN      2143/./promtail-lin 
tcp6       0      0 :::22                   :::*                    LISTEN      991/sshd 
```





# Loki服务重启

```sh
[root@master ~]# systemctl restart grafana-server.service
```







# Web界面操作
浏览器访问本机ip:3000

admin:admin

password:admin

## Data sources创建

1. 点击data sources

   ![image-20230411100718960](https://gitee.com/fan-dongyuan/ty-gallery/raw/master/%E5%B7%A5%E5%9D%8A%E5%9B%BE/LOKI/data1)

2. 点击add data source后，选择Loki

   ![image-20230411100846582](https://gitee.com/fan-dongyuan/ty-gallery/raw/master/%E5%B7%A5%E5%9D%8A%E5%9B%BE/LOKI/data2)

3. 配置参数，点击save & test保存

   ![image-20230411100935749](https://gitee.com/fan-dongyuan/ty-gallery/raw/master/%E5%B7%A5%E5%9D%8A%E5%9B%BE/LOKI/data3)







## Explore操作(Linux)

1. 点击左侧的exploe

2. 在log labels输入参数

   ![image-20230411101232438](https://gitee.com/fan-dongyuan/ty-gallery/raw/master/%E5%B7%A5%E5%9D%8A%E5%9B%BE/LOKI/explore1)

3. 可以对照master节点的/var/log/messages.log文件内容

   ```sh
   [root@master ~]# cat /var/log/messages 
   
   
   # 如果promtail的配置文件指定了次此文件，所以图形化界面能够检查到
   scrape_configs:
     - job_name: linux
       static_configs:
         - targets:
             - localhost
           labels:
              job: messages
              host: localhost
              __path__: /var/log/messages*
   ```



注意：

1. 在log labels输入参数时不要手写，直接引入自带的格式(下拉框)即可





# Apache采集日志测试

## Apache部署

1. 安装

   ```sh
   [root@test ~]# yum install -y httpd
   
   # 设置开启并设置自启
   [root@test ~]# systemctl start httpd
   [root@test ~]# systemctl enable httpd
   ```

   

## Promtail部署

1. 下载安装

   ```sh
   [root@test ~]# curl -O -L "https://github.com/grafana/loki/releases/download/v1.5.0/promtail-linux-amd64.zip"
   [root@test ~]# yum install -y unzip
   [root@test ~]# unzip promtail-linux-amd64.zip
   
   ```

2. 自定义promtail配置文件

   ```sh
   [root@test ~]# cat promtail.yaml 
   server:
     http_listen_port: 9080
     grpc_listen_port: 0
   
   positions:
     filename: /tmp/positions.yaml
   
   clients:
     - url: http://192.168.223.100:3100/loki/api/v1/push
   
   scrape_configs:
     - job_name: WEB
       static_configs:
         - targets:
             - localhost
           labels:
              job: apache
              host: localhost
              __path__: /var/log/httpd/*_log
   
   ```

3. 启动

   ```sh
   [root@test ~]# nohup ./promtail-linux-amd64 -config.file=/root/promtail.yaml &
   
   # 检测
   [root@test ~]# netstat -lntp
   Active Internet connections (only servers)
   Proto Recv-Q Send-Q Local Address           Foreign Address         State       PID/Program name    
   tcp        0      0 0.0.0.0:22              0.0.0.0:*               LISTEN      926/sshd            
   tcp        0      0 127.0.0.1:25            0.0.0.0:*               LISTEN      1162/master         
   tcp6       0      0 :::80                   :::*                    LISTEN      1531/httpd          
   tcp6       0      0 :::39796                :::*                    LISTEN      1940/./promtail-lin 
   tcp6       0      0 :::22                   :::*                    LISTEN      926/sshd            
   tcp6       0      0 :::9080                 :::*                    LISTEN      1940/./promtail-lin 
   tcp6       0      0 ::1:25                  :::*                    LISTEN      1162/master 
   ```

4. 在master节点重启grafana

   ```sh
   [root@master ~]# systemctl start grafana-server.service
   ```

   

## Web界面测试

前提：

1. 先去访问apache网页生成日志(http://192.168.223.7)

![image-20230411104106588](https://gitee.com/fan-dongyuan/ty-gallery/raw/master/%E5%B7%A5%E5%9D%8A%E5%9B%BE/LOKI/apache1)

![image-20230411104132183](https://gitee.com/fan-dongyuan/ty-gallery/raw/master/%E5%B7%A5%E5%9D%8A%E5%9B%BE/LOKI/apache2)

![image-20230411104201781](https://gitee.com/fan-dongyuan/ty-gallery/raw/master/%E5%B7%A5%E5%9D%8A%E5%9B%BE/LOKI/apache3)