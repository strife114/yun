# ELK介绍

## 应⽤/需求前景 

1. 业务发展越来越庞⼤，服务器越来越多；
2. 各种访问⽇志、应⽤⽇志、错误⽇志量越来越多，导致运维⼈员⽆法很好的去管理⽇志； 
3. 开发⼈员排查问题，需要到服务器上查⽇志，不⽅便； 
4. 运营⼈员需要⼀些数据，需要我们运维到服务器上分析⽇志。

## 为什么要使用ELK

如果我们查看某些服务为什么错误，可以直接使⽤grep等命令进⾏查看，可是如果我们查看规模 较⼤，⽇志较多的时候，此⽅法效率就⼩了很多。现在我们对待⼤规模的⽇志，解决思路是建⽴ 集中式⽇志收集系统，将所有节点上的⽇志统⼀收集，管理，访问。 ⼀个完整的集中式⽇志系统，需要包含以下⼏个主要特点： l 收集：能够采集多种来源的⽇志数据。 l 传输：能够稳定的把⽇志数据传输到中央系统。 l 存储：如何存储⽇志数据。 l 分析：可以⽀持 UI 分析。 l 警告：能够提供错误报告，监控机制。 ⽽ELK则提供⼀整套的解决⽅案，并且都是开源软件，之间相互配合，完美衔接，⾼效的满⾜了 很多场合的应⽤。

## ELK简介

1. ELK是3个开源软件的缩写，分别为Elasticsearch 、 Logstash和Kibana , 它们都是开源软 件。不过现在还新增了⼀个Beats，它是⼀个轻量级的⽇志收集处理⼯具（Agent），Beats占⽤ 资源少，适合于在各个服务器上搜集⽇志后传输给Logstash，官⽅也推荐此⼯具，⽬前由于原本 的ELK Stack成员中加⼊了Beats⼯具所以已改名为Elastic Stack。 

2. Elasticsearch是个开源分布式搜索引擎，提供搜集、分析、存储数据3⼤功能。它的特点有： 分布式，零配置，⾃动发现，索引⾃动分⽚，索引副本机制，restful⻛格接⼝，多数据源，⾃动 搜索负载等。

3. **Logstash**主要是⽤来⽇志的搜集、分析、过滤⽇志的⼯具，⽀持⼤量的数据获取⽅式。⼀般 ⼯作⽅式为c/s架构，Client端安装在需要收集⽇志的主机上，server端负责将收到的各节点⽇志 进⾏过滤、修改等操作在⼀并发往Elasticsearch上去。

4. **Kibana**也是⼀个开源和免费的⼯具，Kibana可以为 Logstash和 ElasticSearch提供的⽇志分 析友好的 Web 界⾯，可以帮助汇总、分析和搜索重要数据⽇志。 
5. **Beats**在这⾥是⼀个轻量级⽇志采集器，其实Beats家族有6个成员，早期的ELK架构中使⽤ Logstash收集、解析⽇志，但是Logstash对内存、CPU、io等资源消耗⽐较⾼。相⽐ Logstash，Beats所占系统的CPU和内存⼏乎可以忽略不计



# 环境

| IP              | 节点规划               | 主机名 |
| --------------- | ---------------------- | ------ |
| 192.168.223.100 | Elasticsearch+Kibana   | elk-1  |
| 192.168.223.101 | Elasticsearch+Logstash | elk-2  |
| 192.168.223.102 | Elasticsearch+Beats    | elk-3  |



# ELK

## 基础环境配置

1. 修改主机名(3)

   ```sh
   elk-1节点：
   [root@localhost ~]# hostnamectl set-hostname elk-1
   [root@localhost ~]# bash
   [root@elk-1 ~]#
   elk-2节点：
   [root@localhost ~]# hostnamectl set-hostname elk-2
   [root@localhost ~]# bash
   [root@elk-2 ~]#
   elk-3节点：
   [root@localhost ~]# hostnamectl set-hostname elk-3
   [root@localhost ~]# bash
   [root@elk-3 ~]#
   ```

2. 修改域名文件(3)

   ```sh
   [root@elk-1 ~]# vi /etc/hosts
   127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4
   ::1         localhost localhost.localdomain localhost6 localhost6.localdomain6
   192.168.223.100 elk-1
   192.168.223.101 elk-2
   192.168.223.102 elk-3
   
   [root@elk-1 ~]# scp /etc/hosts 192.168.223.101:/etc/hosts
   [root@elk-1 ~]# scp /etc/hosts 192.168.223.102:/etc/hosts
   ```

3. 时间同步

   ```sh
   [root@elk-1 ~]# yum install -y ntp
   [root@elk-2 ~]# yum install -y ntp
   [root@elk-3 ~]# yum install -y ntp
   
   
   [root@elk-1 ~]# systemctl start ntpd
   [root@elk-1 ~]# systemctl enable ntpd
   [root@elk-2 ~]# ntpdate elk-1
   [root@elk-3 ~]# ntpdate elk-1
   ```

   

## JDK安装

1. 安装(3)

   ```sh
   # 请在三节点下安装
   yum install -y java-1.8.0-openjdk java-1.8.0-openjdk-devel
   
   # 检查
   java -version
   ```



## Elasticserach部署

### Elasticserach安装

1. 下载(3)

   ```sh
   wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-6.0.0.rpm
   ```

2. 安装(3)

   ```sh
   rpm -ivh elasticsearch-6.0.0.rpm
   ```



### Elasticserach配置

#### elk-1

```yaml
[root@elk-1 elasticsearch]# cat /etc/elasticsearch/elasticsearch.yml
# ======================== Elasticsearch Configuration =========================
#
# NOTE: Elasticsearch comes with reasonable defaults for most settings.
#       Before you set out to tweak and tune the configuration, make sure you
#       understand what are you trying to accomplish and the consequences.
#
# The primary way of configuring a node is via this file. This template lists
# the most important settings you may want to configure for a production cluster.
#
# Please consult the documentation for further information on configuration options:
# https://www.elastic.co/guide/en/elasticsearch/reference/index.html
#
# ---------------------------------- Cluster -----------------------------------
#
# Use a descriptive name for your cluster:
#
cluster.name: ELK
#
# ------------------------------------ Node ------------------------------------
#
# Use a descriptive name for the node:
#
node.name: elk-1
# Add custom attributes to the node:
#
node.master: true
node.data: true
#node.attr.rack: r1
#
# ----------------------------------- Paths ------------------------------------
#
# Path to directory where to store the data (separate multiple locations by comma):
#
path.data: /var/lib/elasticsearch
#
# Path to log files:
#
path.logs: /var/log/elasticsearch
#
# ----------------------------------- Memory -----------------------------------
#
# Lock the memory on startup:
#
#bootstrap.memory_lock: true
#
# Make sure that the heap size is set to about half the memory available
# on the system and that the owner of the process is allowed to use this
# limit.
#
# Elasticsearch performs poorly when the system is swapping the memory.
#
# ---------------------------------- Network -----------------------------------
#
# Set the bind address to a specific IP (IPv4 or IPv6):
#
network.host: 192.168.223.100
#
# Set a custom port for HTTP:
#
http.port: 9200
#
# For more information, consult the network module documentation.
#
# --------------------------------- Discovery ----------------------------------
#
# Pass an initial list of hosts to perform discovery when new node is started:
# The default list of hosts is ["127.0.0.1", "[::1]"]
#
discovery.zen.ping.unicast.hosts: ["elk-1", "elk-2","elk-3"]
#
# Prevent the "split brain" by configuring the majority of nodes (total number of master-eligible nodes / 2 + 1):
#
#discovery.zen.minimum_master_nodes: 3
#
# For more information, consult the zen discovery module documentation.
#
# ---------------------------------- Gateway -----------------------------------
#
# Block initial recovery after a full cluster restart until N nodes are started:
#
#gateway.recover_after_nodes: 3
#
# For more information, consult the gateway module documentation.
#
# ---------------------------------- Various -----------------------------------
#
# Require explicit names when deleting indices:
#
#action.destructive_requires_name: true
```

#### elk-2

```yaml
[root@elk-2 elasticsearch]# cat /etc/elasticsearch/elasticsearch.yml
# ======================== Elasticsearch Configuration =========================
#
# NOTE: Elasticsearch comes with reasonable defaults for most settings.
#       Before you set out to tweak and tune the configuration, make sure you
#       understand what are you trying to accomplish and the consequences.
#
# The primary way of configuring a node is via this file. This template lists
# the most important settings you may want to configure for a production cluster.
#
# Please consult the documentation for further information on configuration options:
# https://www.elastic.co/guide/en/elasticsearch/reference/index.html
#
# ---------------------------------- Cluster -----------------------------------
#
# Use a descriptive name for your cluster:
#
cluster.name: ELK
#
# ------------------------------------ Node ------------------------------------
#
# Use a descriptive name for the node:
#
node.name: elk-2
# Add custom attributes to the node:
#
node.master: true
node.data: true
#node.attr.rack: r1
#
# ----------------------------------- Paths ------------------------------------
#
# Path to directory where to store the data (separate multiple locations by comma):
#
path.data: /var/lib/elasticsearch
#
# Path to log files:
#
path.logs: /var/log/elasticsearch
#
# ----------------------------------- Memory -----------------------------------
#
# Lock the memory on startup:
#
#bootstrap.memory_lock: true
#
# Make sure that the heap size is set to about half the memory available
# on the system and that the owner of the process is allowed to use this
# limit.
#
# Elasticsearch performs poorly when the system is swapping the memory.
#
# ---------------------------------- Network -----------------------------------
#
# Set the bind address to a specific IP (IPv4 or IPv6):
#
network.host: 192.168.223.101
#
# Set a custom port for HTTP:
#
http.port: 9200
#
# For more information, consult the network module documentation.
#
# --------------------------------- Discovery ----------------------------------
#
# Pass an initial list of hosts to perform discovery when new node is started:
# The default list of hosts is ["127.0.0.1", "[::1]"]
#
discovery.zen.ping.unicast.hosts: ["elk-1", "elk-2","elk-3"]
#
# Prevent the "split brain" by configuring the majority of nodes (total number of master-eligible nodes / 2 + 1):
#
#discovery.zen.minimum_master_nodes: 3
#
# For more information, consult the zen discovery module documentation.
#
# ---------------------------------- Gateway -----------------------------------
#
# Block initial recovery after a full cluster restart until N nodes are started:
#
#gateway.recover_after_nodes: 3
#
# For more information, consult the gateway module documentation.
#
# ---------------------------------- Various -----------------------------------
#
# Require explicit names when deleting indices:
#
#action.destructive_requires_name: true
```

#### elk-3

```yaml
[root@elk-3 elasticsearch]# cat /etc/elasticsearch/elasticsearch.yml
# ======================== Elasticsearch Configuration =========================
#
# NOTE: Elasticsearch comes with reasonable defaults for most settings.
#       Before you set out to tweak and tune the configuration, make sure you
#       understand what are you trying to accomplish and the consequences.
#
# The primary way of configuring a node is via this file. This template lists
# the most important settings you may want to configure for a production cluster.
#
# Please consult the documentation for further information on configuration options:
# https://www.elastic.co/guide/en/elasticsearch/reference/index.html
#
# ---------------------------------- Cluster -----------------------------------
#
# Use a descriptive name for your cluster:
#
cluster.name: ELK
#
# ------------------------------------ Node ------------------------------------
#
# Use a descriptive name for the node:
#
node.name: elk-3
# Add custom attributes to the node:
#
node.master: true
node.data: true
#node.attr.rack: r1
#
# ----------------------------------- Paths ------------------------------------
#
# Path to directory where to store the data (separate multiple locations by comma):
#
path.data: /var/lib/elasticsearch
#
# Path to log files:
#
path.logs: /var/log/elasticsearch
#
# ----------------------------------- Memory -----------------------------------
#
# Lock the memory on startup:
#
#bootstrap.memory_lock: true
#
# Make sure that the heap size is set to about half the memory available
# on the system and that the owner of the process is allowed to use this
# limit.
#
# Elasticsearch performs poorly when the system is swapping the memory.
#
# ---------------------------------- Network -----------------------------------
#
# Set the bind address to a specific IP (IPv4 or IPv6):
#
network.host: 192.168.223.102
#
# Set a custom port for HTTP:
#
http.port: 9200
#
# For more information, consult the network module documentation.
#
# --------------------------------- Discovery ----------------------------------
#
# Pass an initial list of hosts to perform discovery when new node is started:
# The default list of hosts is ["127.0.0.1", "[::1]"]
#
discovery.zen.ping.unicast.hosts: ["elk-1", "elk-2","elk-3"]
#
# Prevent the "split brain" by configuring the majority of nodes (total number of master-eligible nodes / 2 + 1):
#
#discovery.zen.minimum_master_nodes: 3
#
# For more information, consult the zen discovery module documentation.
#
# ---------------------------------- Gateway -----------------------------------
#
# Block initial recovery after a full cluster restart until N nodes are started:
#
#gateway.recover_after_nodes: 3
#
# For more information, consult the gateway module documentation.
#
# ---------------------------------- Various -----------------------------------
#
# Require explicit names when deleting indices:
#
#action.destructive_requires_name: true
```



### Elasticserach检测

1. 开启并设置自启(3)

   ```sh
   systemctl start elasticsearch
   systemctl enable elasticsearch
   ```

2. 查看进程

   ```sh
   ps -ef |grep elasticsearch
   netstat -lntp
   
   
   # 注意
   看到有9200和9300即算是成功
   ```

3. 检测集群状态

   ```sh
   [root@elk-1 ~]# curl '192.168.223.100:9200/_cluster/health?pretty'
   {
     "cluster_name" : "ELK",
     # 值为green则没问题
     "status" : "green",
     # 是否超时
     "timed_out" : false,
     # 集群中的节点数量
     "number_of_nodes" : 3,
     # 集群中的data节点数量
     "number_of_data_nodes" : 3,
     "active_primary_shards" : 14,
     "active_shards" : 28,
     "relocating_shards" : 0,
     "initializing_shards" : 0,
     "unassigned_shards" : 0,
     "delayed_unassigned_shards" : 0,
     "number_of_pending_tasks" : 0,
     "number_of_in_flight_fetch" : 0,
     "task_max_waiting_in_queue_millis" : 0,
     "active_shards_percent_as_number" : 100.0
   }
   
   
   ```



## Kibana部署

### Kibana安装

1. 下载

   ```sh
   [root@elk-1 ~]# wget https://artifacts.elastic.co/downloads/kibana/kibana-6.0.0-x86_64.rpm
   ```

2. 安装

   ```sh
   [root@elk-1 ~]# rpm -ivh kibana-6.0.0-x86_64.rpm
   ```



### Kibana配置

1. 下载nginx

   ```sh
   [root@elk-1 ~]#  rpm -Uvh http://nginx.org/packages/centos/7/noarch/RPMS/nginx-release-centos-7-0.el7.ngx.noarch.rpm
   [root@elk-1 ~]# yum install -y nginx
   
   
   # 设置自启
   [root@elk-1 ~]# systemctl start nginx
   [root@elk-1 ~]# systemctl enable nginx
   ```

2. 修改nginx配置文件

   ```sh
   [root@elk-1 log]# vim /etc/nginx/nginx.conf
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
   log_format main2 '$http_host $remote_addr - $remote_user [$time_local]
   "$request" '
                         '$status $body_bytes_sent "$http_referer" '
                         '"$http_user_agent" "$upstream_addr" $request_time';
      
       access_log  /var/log/nginx/access.log  main2;
   
       #gzip  on;
       upstream  elasticsearch{
       server  192.168.223.100:9200;
       server  192.168.223.101:9200;
       server  192.168.223.102:9200;
   }
   server {
       listen  8080;
       server_name   192.168.223.100;
       location / {
       proxy_pass  http://elasticsearch;
       proxy_redirect off;
       proxy_set_header Host %host;
       proxy_set_header X-Real-IP $remote_addr;
       proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
   }
   }
       access_log /var/log/es_access.log;
   }
   ```

3. 修改Kibana配置文件

   ```sh
   [root@elk-1 log]# cat /etc/kibana/kibana.yml |grep -v ^#
   server.port: 5601
   server.host: "192.168.223.100"
   elasticsearch.url: "http://192.168.223.100:8080"
   ```

4. 启动kibana

   ```sh
   [root@elk-1 ~]# systemctl start kibana
   ```

5. 查看进程

   ```sh
   [root@elk-1 ~]# ps -ef |grep kibana
   ```

6. 检测

   ```
   浏览器访问：
   192.168.223.100:5601
   ```



## Logstash部署

### Logstash安装

1. 下载

   ```sh
   [root@elk-2 ~]# wget https://artifacts.elastic.co/downloads/logstash/logstash-6.0.0.rpm
   ```

2. 安装

   ```sh
   [root@elk-2 ~]# rpm -ivh logstash-6.0.0.rpm
   ```

   

### Logstash配置

1. 修改配置文件

   ```sh
   [root@elk-2 ~]# cat /etc/logstash/logstash.yml 
   # Settings file in YAML
   #
   # Settings can be specified either in hierarchical form, e.g.:
   #
   #   pipeline:
   #     batch:
   #       size: 125
   #       delay: 5
   #
   # Or as flat keys:
   #
   #   pipeline.batch.size: 125
   #   pipeline.batch.delay: 5
   #
   # ------------  Node identity ------------
   #
   # Use a descriptive name for the node:
   #
   # node.name: test
   #
   # If omitted the node name will default to the machine's host name
   #
   # ------------ Data path ------------------
   #
   # Which directory should be used by logstash and its plugins
   # for any persistent needs. Defaults to LOGSTASH_HOME/data
   #
   path.data: /var/lib/logstash
   #
   # ------------ Pipeline Settings --------------
   #
   # Set the number of workers that will, in parallel, execute the filters+outputs
   # stage of the pipeline.
   #
   # This defaults to the number of the host's CPU cores.
   #
   # pipeline.workers: 2
   #
   # How many workers should be used per output plugin instance
   #
   # pipeline.output.workers: 1
   #
   # How many events to retrieve from inputs before sending to filters+workers
   #
   # pipeline.batch.size: 125
   #
   # How long to wait before dispatching an undersized batch to filters+workers
   # Value is in milliseconds.
   #
   # pipeline.batch.delay: 5
   #
   # Force Logstash to exit during shutdown even if there are still inflight
   # events in memory. By default, logstash will refuse to quit until all
   # received events have been pushed to the outputs.
   #
   # WARNING: enabling this can lead to data loss during shutdown
   #
   # pipeline.unsafe_shutdown: false
   #
   # ------------ Pipeline Configuration Settings --------------
   #
   # Where to fetch the pipeline configuration for the main pipeline
   #
   path.config: /etc/logstash/conf.d/*.conf
   #
   # Pipeline configuration string for the main pipeline
   #
   # config.string:
   #
   # At startup, test if the configuration is valid and exit (dry run)
   #
   # config.test_and_exit: false
   #
   # Periodically check if the configuration has changed and reload the pipeline
   # This can also be triggered manually through the SIGHUP signal
   #
   # config.reload.automatic: false
   #
   # How often to check if the pipeline configuration has changed (in seconds)
   #
   # config.reload.interval: 3s
   #
   # Show fully compiled configuration as debug log message
   # NOTE: --log.level must be 'debug'
   #
   # config.debug: false
   #
   # When enabled, process escaped characters such as \n and \" in strings in the
   # pipeline configuration files.
   #
   # config.support_escapes: false
   #
   # ------------ Module Settings ---------------
   # Define modules here.  Modules definitions must be defined as an array.
   # The simple way to see this is to prepend each `name` with a `-`, and keep
   # all associated variables under the `name` they are associated with, and 
   # above the next, like this:
   #
   # modules:
   #   - name: MODULE_NAME
   #     var.PLUGINTYPE1.PLUGINNAME1.KEY1: VALUE
   #     var.PLUGINTYPE1.PLUGINNAME1.KEY2: VALUE
   #     var.PLUGINTYPE2.PLUGINNAME1.KEY1: VALUE
   #     var.PLUGINTYPE3.PLUGINNAME3.KEY1: VALUE
   #
   # Module variable names must be in the format of 
   #
   # var.PLUGIN_TYPE.PLUGIN_NAME.KEY
   #
   # modules:
   #
   # ------------ Cloud Settings ---------------
   # Define Elastic Cloud settings here.
   # Format of cloud.id is a base64 value e.g. dXMtZWFzdC0xLmF3cy5mb3VuZC5pbyRub3RhcmVhbCRpZGVudGlmaWVy
   # and it may have an label prefix e.g. staging:dXMtZ...
   # This will overwrite 'var.elasticsearch.hosts' and 'var.kibana.host'
   # cloud.id: <identifier>
   #
   # Format of cloud.auth is: <user>:<pass>
   # This is optional
   # If supplied this will overwrite 'var.elasticsearch.username' and 'var.elasticsearch.password'
   # If supplied this will overwrite 'var.kibana.username' and 'var.kibana.password'
   # cloud.auth: elastic:<password>
   #
   # ------------ Queuing Settings --------------
   #
   # Internal queuing model, "memory" for legacy in-memory based queuing and
   # "persisted" for disk-based acked queueing. Defaults is memory
   #
   # queue.type: memory
   #
   # If using queue.type: persisted, the directory path where the data files will be stored.
   # Default is path.data/queue
   #
   # path.queue:
   #
   # If using queue.type: persisted, the page data files size. The queue data consists of
   # append-only data files separated into pages. Default is 250mb
   #
   # queue.page_capacity: 250mb
   #
   # If using queue.type: persisted, the maximum number of unread events in the queue.
   # Default is 0 (unlimited)
   #
   # queue.max_events: 0
   #
   # If using queue.type: persisted, the total capacity of the queue in number of bytes.
   # If you would like more unacked events to be buffered in Logstash, you can increase the
   # capacity using this setting. Please make sure your disk drive has capacity greater than
   # the size specified here. If both max_bytes and max_events are specified, Logstash will pick
   # whichever criteria is reached first
   # Default is 1024mb or 1gb
   #
   # queue.max_bytes: 1024mb
   #
   # If using queue.type: persisted, the maximum number of acked events before forcing a checkpoint
   # Default is 1024, 0 for unlimited
   #
   # queue.checkpoint.acks: 1024
   #
   # If using queue.type: persisted, the maximum number of written events before forcing a checkpoint
   # Default is 1024, 0 for unlimited
   #
   # queue.checkpoint.writes: 1024
   #
   # If using queue.type: persisted, the interval in milliseconds when a checkpoint is forced on the head page
   # Default is 1000, 0 for no periodic checkpoint.
   #
   # queue.checkpoint.interval: 1000
   #
   # ------------ Dead-Letter Queue Settings --------------
   # Flag to turn on dead-letter queue.
   #
   # dead_letter_queue.enable: false
   
   # If using dead_letter_queue.enable: true, the maximum size of each dead letter queue. Entries
   # will be dropped if they would increase the size of the dead letter queue beyond this setting.
   # Default is 1024mb
   # dead_letter_queue.max_bytes: 1024mb
   
   # If using dead_letter_queue.enable: true, the directory path where the data files will be stored.
   # Default is path.data/dead_letter_queue
   #
   # path.dead_letter_queue:
   #
   # ------------ Metrics Settings --------------
   #
   # Bind address for the metrics REST endpoint
   #
   # 修改此处为本机ip
   http.host: "192.168.223.101"
   #
   # Bind port for the metrics REST endpoint, this option also accept a range
   # (9600-9700) and logstash will pick up the first available ports.
   #
   # http.port: 9600-9700
   #
   # ------------ Debugging Settings --------------
   #
   # Options for log.level:
   #   * fatal
   #   * error
   #   * warn
   #   * info (default)
   #   * debug
   #   * trace
   #
   # log.level: info
   path.logs: /var/log/logstash
   #
   # ------------ Other Settings --------------
   #
   # Where to find custom plugins
   # path.plugins: []
   
   ```

2. 赋权

   ```sh
   [root@elk-2 ~]# chmod 644 /var/log/messages
   [root@elk-2 ~]# chown -R logstash:logstash /var/log/logstash
   ```

3. 配置logstash收集syslog日志

   ```sh
   [root@elk-2 ~]# cat /etc/logstash/conf.d/syslog.conf
   input {
    file {
    	path => "/var/log/messages"
    	type => "systemlog"
    	start_position => "beginning"
    	stat_interval => "3"
    }
   }
   output {
    elasticsearch {
    	hosts => ["192.168.223.100:9200","192.168.223.101:9200","192.168.223.102:9200"]
    	index => "system-log-%{+YYYY.MM.dd}"
    }
    }
   ```
   
4. 检测配置文件

   ```sh
   # 设置软链接
   [root@elk-2 ~]# ln -s /usr/share/logstash/bin/logstash /usr/bin
   [root@elk-2 ~]# logstash --path.settings /etc/logstash/ -f /etc/logstash/conf.d/syslog.conf --config.test_and_exit
   Sending Logstash's logs to /var/log/logstash which is now configured via l
   og4j2.properties
   Configuration OK
   
   参数解释：
   	--path.settings: 用于指定logstash的配置文件所在目录
   	-f: 指定需求被检测的配置文件的路径
   	--config.test_and_exit: 检测完后退出
   ```

5. 启动

   ```sh
   [root@elk-2 ~]# systemctl start logstash
   ```

6. 查看进程

   ```sh
   [root@elk-2 ~]# ps -ef |grep logstash
   logstash  14066      1  4 02:15 ?        00:04:29 /bin/java -XX:+UseParNewGC -XX:+UseConcMarkSweepGC -XX:CMSInitiatingOccupancyFraction=75 -XX:+UseCMSInitiatingOccupancyOnly -XX:+DisableExplicitGC -Djava.awt.headless=true -Dfile.encoding=UTF-8 -XX:+HeapDumpOnOutOfMemoryError -Xmx1g -Xms256m -Xss2048k -Djffi.boot.library.path=/usr/share/logstash/vendor/jruby/lib/jni -Xbootclasspath/a:/usr/share/logstash/vendor/jruby/lib/jruby.jar -classpath : -Djruby.home=/usr/share/logstash/vendor/jruby -Djruby.lib=/usr/share/logstash/vendor/jruby/lib -Djruby.script=jruby -Djruby.shell=/bin/sh org.jruby.Main /usr/share/logstash/lib/bootstrap/environment.rb logstash/runner.rb --path.settings /etc/logstash
   root      14522   1488  0 03:47 pts/0    00:00:00 grep --color=auto logstash
   
   
   [root@elk-2 ~]# netstat -lntp
   Active Internet connections (only servers)
   Proto Recv-Q Send-Q Local Address           Foreign Address         State       PID/Program name    
   tcp        0      0 127.0.0.1:25            0.0.0.0:*               LISTEN      1166/master         
   tcp        0      0 0.0.0.0:80              0.0.0.0:*               LISTEN      14027/nginx: master 
   tcp        0      0 0.0.0.0:22              0.0.0.0:*               LISTEN      959/sshd            
   tcp6       0      0 ::1:25                  :::*                    LISTEN      1166/master         
   tcp6       0      0 192.168.223.101:9600    :::*                    LISTEN      14066/java          
   tcp6       0      0 :::80                   :::*                    LISTEN      14027/nginx: master 
   tcp6       0      0 192.168.223.101:9200    :::*                    LISTEN      1840/java           
   tcp6       0      0 192.168.223.101:9300    :::*                    LISTEN      1840/java           
   tcp6       0      0 :::22                   :::*                    LISTEN      959/sshd 
   
   
   
   
   # 注意
   1.启动服务后，有进程但是没有9600端口
     # 可能是权限问题，查看权限
     [root@elk-2 ~]# ll /var/lib/logstash/
     # 因为之前我们以root的身份在终端启动过Logstash，所以产⽣的相关⽂件的权限⽤户和权限组都是root
     # 修改/var/lib/logstash/⽬录的所属者为logstash，并重启服务
     [root@elk-2 ~]# chown -R logstash /var/lib/logstash/
     # 重启服务
     [root@elk-2 ~]# systemctl restart logstash
   ```

7. 在elk-1查看日志

   ```sh
   [root@elk-1 log]# curl '192.168.223.100:9200/_cat/indices?v'
   health status index                     uuid                   pri rep docs.count docs.deleted store.size pri.store.size
   green  open   .kibana                   yGqeNHh7SSidv1PxOUXWTw   1   1          4            0     50.2kb         25.1kb
   green  open   system-log-2023.04.10     _o_1SpYmT6y-KwjGzETqjA   5   1      18203            0      6.2mb            3mb
   
   
   # 获取/删除指定索引详细信息：
   [root@elk-1 ~]# curl -XGET/DELETE '192.168.223.100:9200/system-log-2022.03.0
   9?pretty'
   ```
   


### Web界面配置索引

1. 配置索引

   ![image-20230410160031137](https://gitee.com/fan-dongyuan/ty-gallery/raw/master/%E5%B7%A5%E5%9D%8A%E5%9B%BE/ELK/kibana(system-log)_)

2. 选择Discover,进入页面后，如果出现一下界面则是无法查找到日志

   ![Kibana(时间同步)](https://gitee.com/fan-dongyuan/ty-gallery/raw/master/%E5%B7%A5%E5%9D%8A%E5%9B%BE/ELK/Kibana(%E6%97%B6%E9%97%B4%E5%90%8C%E6%AD%A5).jpeg)

3. 单击右上角切换成查看当天的日志信息

   ![image-20230410161601812](https://gitee.com/fan-dongyuan/ty-gallery/raw/master/%E5%B7%A5%E5%9D%8A%E5%9B%BE/ELK/Kibana(%E6%97%B6%E9%97%B4%E4%BF%AE%E6%94%B9))

4. 现在显示正常了

   ![image-20230410161704988](https://gitee.com/fan-dongyuan/ty-gallery/raw/master/%E5%B7%A5%E5%9D%8A%E5%9B%BE/ELK/Kibana(%E6%97%B6%E9%97%B4%E6%AD%A3%E5%B8%B8))







## Logstash收集nginx日志

### Nginx安装

1. 下载yum源

   ```sh
   [root@elk-2 ~]# curl -o /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-7.repo
   ```

2. 安装

   ```
   [root@elk-2 ~]# yum install -y nginx
   ```

   

### Nginx配置

1. 修改nginx配置文件

   ```sh
   [root@elk-2 ~]# cat /etc/nginx/nginx.conf
   # For more information on configuration, see:
   #   * Official English Documentation: http://nginx.org/en/docs/
   #   * Official Russian Documentation: http://nginx.org/ru/docs/
   
   user nginx;
   worker_processes auto;
   error_log /var/log/nginx/error.log;
   pid /run/nginx.pid;
   
   # Load dynamic modules. See /usr/share/doc/nginx/README.dynamic.
   include /usr/share/nginx/modules/*.conf;
   
   events {
       worker_connections 1024;
   }
   
   http {
       log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
                         '$status $body_bytes_sent "$http_referer" '
                         '"$http_user_agent" "$http_x_forwarded_for"';
   
       access_log  /var/log/nginx/access.log  main;
   
       sendfile            on;
       tcp_nopush          on;
       tcp_nodelay         on;
       keepalive_timeout   65;
       types_hash_max_size 4096;
   
       include             /etc/nginx/mime.types;
       default_type        application/octet-stream;
       # 添加此东西
   log_format main2 '$http_host $remote_addr - $remote_user [$time_local] "$request" '
                         '$status $body_bytes_sent "$http_referer" '
                         '"$http_user_agent" "$upstream_addr" $request_time';
      
       access_log  /var/log/nginx/access2.log  main2;
       # Load modular configuration files from the /etc/nginx/conf.d directory.
       # See http://nginx.org/en/docs/ngx_core_module.html#include
       # for more information.
       include /etc/nginx/conf.d/*.conf;
   
       server {
           listen       80;
           listen       [::]:80;
           server_name  _;
           root         /usr/share/nginx/html;
   
           # Load configuration files for the default server block.
           include /etc/nginx/default.d/*.conf;
   
           error_page 404 /404.html;
           location = /404.html {
           }
   
           error_page 500 502 503 504 /50x.html;
           location = /50x.html {
           }
       }
   
   # Settings for a TLS enabled server.
   #
   #    server {
   #        listen       443 ssl http2;
   #        listen       [::]:443 ssl http2;
   #        server_name  _;
   #        root         /usr/share/nginx/html;
   #
   #        ssl_certificate "/etc/pki/nginx/server.crt";
   #        ssl_certificate_key "/etc/pki/nginx/private/server.key";
   #        ssl_session_cache shared:SSL:1m;
   #        ssl_session_timeout  10m;
   #        ssl_ciphers HIGH:!aNULL:!MD5;
   #        ssl_prefer_server_ciphers on;
   #
   #        # Load configuration files for the default server block.
   #        include /etc/nginx/default.d/*.conf;
   #
   #        error_page 404 /404.html;
   #            location = /40x.html {
   #        }
   #
   #        error_page 500 502 503 504 /50x.html;
   #            location = /50x.html {
   #        }
   #    }
   
   }
   ```

2. 编辑监听nginx日志配置文件

   ```sh
   [root@elk-2 ~]# # vim /etc/nginx/conf.d/elk.conf
   server {
         listen 80;
         server_name elk.test.com;
         location / {
             proxy_pass      http://192.168.223.100:5601;
             proxy_set_header Host   $host;
             proxy_set_header X-Real-IP      $remote_addr;
             proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
   }
         access_log  /var/log/nginx/elk_access.log main2;
   }
   
   ```

   

### Logstash配置

1. 编辑nginx的日志文件

   ```sh
   [root@elk-2 fdy]# cat /etc/logstash/conf.d/nginx.conf
   input {
    file {
    # 修改此路径
    path => "/var/log/nginx/elk_access.log"
    start_position => "beginning"
    type => "nginx"
    }
   }
   filter {
    grok {
    match => { "message" => "%{IPORHOST:http_host} %{IPORHOST:clienti
   p} - %{USERNAME:remote_user} \[%{HTTPDATE:timestamp}\] \"(?:%{WORD:http_ve
   rb} %{NOTSPACE:http_request}(?: HTTP/%{NUMBER:http_version})?|%{DATA:raw_h
   ttp_request})\" %{NUMBER:response} (?:%{NUMBER:bytes_read}|-) %{QS:referre
   r} %{QS:agent} %{QS:xforwardedfor} %{NUMBER:request_time:float}"}
    }
    geoip {
    source => "clientip"
    }
   }
   output {
    stdout { codec => rubydebug }
    elasticsearch {
    hosts => ["192.168.223.101:9200"]
   index => "nginx-test-%{+YYYY.MM.dd}"
    }
   }
   
   ```

2. 重启nginx、logstash服务

   ```sh
   [root@elk-2 nginx]# systemctl restart logstash
   [root@elk-2 nginx]# systemctl restart nginx
   ```

   

3. elk-1检测索引

   ```sh
   [root@elk-1 log]# curl '192.168.223.100:9200/_cat/indices?v'
   health status index                     uuid                   pri rep docs.count docs.deleted store.size pri.store.size
   green  open   .kibana                   yGqeNHh7SSidv1PxOUXWTw   1   1          4            0     50.2kb         25.1kb
   green  open   nginx-test-2023.04.10     r4D06ju7TveIuK0yChnmOA   5   1       8764            0      2.1mb            1mb
   green  open   system-log-2023.04.10     _o_1SpYmT6y-KwjGzETqjA   5   1      19956            0      6.7mb          3.3mb
   ```

   

### Web界面配置

1. 浏览器访问192.168.223.100:5601，到Kibana上配置索引,点击index patterns

   ![image-20230410164244260](https://gitee.com/fan-dongyuan/ty-gallery/raw/master/%E5%B7%A5%E5%9D%8A%E5%9B%BE/ELK/nginx-test(1))

2. 点击Create Index Pattern 进入创建

   ![image-20230410164508676](https://gitee.com/fan-dongyuan/ty-gallery/raw/master/%E5%B7%A5%E5%9D%8A%E5%9B%BE/ELK/nginx-test(2))

3. 选择discover，选择中间左侧system-log





## 使用Beat采集日志

### Beat安装

1. 下载

   ```sh
   [root@elk-3 ~]# wget https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-6.0.0-x86_64.rpm
   ```

2. 安装

   ```sh
   [root@elk-3 ~]# rpm -ivh filebeat-6.0.0-x86_64.rpm
   ```

   

### Beat配置

1. 修改配置文件

   ```sh
   vim /etc/filebeat/filebeat.yml
   # 找到下面的参数
   filebeat.prospectors:
   enabled: true
   paths:
    # 暂时只能使用自带的ELK.log
    - /var/log/elasticsearch/ELK.log //此处可⾃⾏改为想要监听的⽇志⽂件
   output.elasticsearch:
    hosts: ["elk-2:9200","elk-1:9200","elk-3:9200"]
   ```

2. 开启并设置自启

   ```sh
   [root@elk-3 ~]# systemctl start filebeat
   [root@elk-3 ~]# systemctl enable filebeat
   
   ```

3. elk-1检测

   ```sh
   [root@elk-1 log]# curl '192.168.223.100:9200/_cat/indices?v'
   health status index                     uuid                   pri rep docs.count docs.deleted store.size pri.store.size
   green  open   .kibana                   yGqeNHh7SSidv1PxOUXWTw   1   1          4            0     50.2kb         25.1kb
   green  open   nginx-test-2023.04.10     r4D06ju7TveIuK0yChnmOA   5   1       8764            0      2.1mb            1mb
   green  open   filebeat-6.0.0-2023.04.10 Y2zwhBwbTquOutGDY-K90g   3   1        482            0    250.6kb        109.8kb
   green  open   system-log-2023.04.10     _o_1SpYmT6y-KwjGzETqjA   5   1      19956            0      6.7mb          3.3mb
   ```

   

### Web界面配置

1. 操作步骤按Logstash即可，(index pattern：filebeat*   time filter field name： @timestamp)







# 生产环境建议

1. 建议集群中设置3台以上的节点作为master节点【node.master: true node.data: false】 这些节点只负责成为主节点，维护整个集群的状态。
2. 再根据数据量设置⼀批data节点【node.master: false node.data: true】 这些节点只负责存储数据，后期提供建⽴索引和查询索引的服务，这样的话如果⽤户请求⽐较频繁，这 些节点的压⼒也会⽐较⼤，所以在集群中建议再设置⼀批client节点【node.master: false node.data:false】，这些节点只负责处理⽤户请求，实现请求转发，负载均衡等功能。
3. master节点：普通服务器即可(CPU 内存 消耗⼀般) 
4. data节点：主要消耗磁盘，内存 
5. client节点：普通服务器即可(如果要进⾏分组聚合操作的话，建议这个节点内存也分配多⼀点