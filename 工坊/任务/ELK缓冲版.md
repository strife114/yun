# ELK
## 环境

| IP              | 节点规划               | 主机名 |
| --------------- | ---------------------- | ------ |
| 192.168.223.100 | Elasticsearch+Kibana   | elk-1  |
| 192.168.223.101 | Elasticsearch+Logstash | elk-2  |
| 192.168.223.102 | Elasticsearch          | elk-3  |


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
   [root@elk-1 ~]# rm -f /etc/localtime && ln -s /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
   [root@elk-2 ~]# rm -f /etc/localtime && ln -s /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
   [root@elk-3 ~]# rm -f /etc/localtime && ln -s /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
   
   
   
   [root@elk-1 ~]# date
   [root@elk-2 ~]# date
   [root@elk-3 ~]# date
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









# ELK+KAFKA+ZOOKEEPER

## 环境

| IP              | 节点规划                                    | 主机名 |
| --------------- | ------------------------------------------- | ------ |
| 192.168.223.100 | Elasticsearch+Kibana+kafka+zookeeper        | elk-1  |
| 192.168.223.101 | Elasticsearch+Logstash+kafka+zookeeper+beat | elk-2  |
| 192.168.223.102 | Elasticsearch+kafka+zookeeper               | elk-3  |



## Zookeeper集群部署

### 简介

1. ZooKeeper主要有领导者（Leader）、跟随者（Follower）和观察者（Observer）三种⻆⾊。 ZooKeeper集群需要是>1的奇数节点。例如3、5、7等等。 

2. 三台机只能挂⼀台，⾄少有两台才可以正常⼯作。 三台主机都需安装zookeeper

### 部署

1. 安装(3)

   ```sh
   wget http://archive.apache.org/dist/zookeeper/zookeeper-3.5.9/apache-zookeeper-3.5.9-bin.tar.gz
   ```

2. 调整(3)

   ```sh
   tar -zxvf apache-zookeeper-3.5.9-bin.tar.gz -C /usr/local/
   mv /usr/local/apache-zookeeper-3.5.9-bin /usr/local/zookeeper
   cp /usr/local/zookeeper/conf/zoo_sample.cfg /usr/local/zookeeper/conf/zoo.cfg
   ```

3. 配置环境变量

   ```sh
   cat >> /etc/profile <<EOF
   export ZOOKEEPER_HOME=/usr/local/zookeeper
   export PATH=$ZOOKEEPER_HOME/bin:$PATH
   EOF
   # 使环境变量⽣效
   source /etc/profile
   echo $ZOOKEEPER_HOME
   ```

4. 修改配置文件(3)

   ```sh
   # cat /usr/local/zookeeper/conf/zoo.cfg
   
   
   # The number of milliseconds of each tick
   tickTime=2000 #zk之间⼼跳间隔2秒
   # The number of ticks that the initial
   # synchronization phase can take
   initLimit=10 #LF初始通信时限
   # The number of ticks that can pass between
   # sending a request and getting an acknowledgement
   syncLimit=5 #LF同步通信时限
   # the directory where the snapshot is stored.
   # do not use /tmp for storage, /tmp here is just
   # example sakes.
   dataDir=/tmp/zookeeper #Zookeeper保存数据的⽬录
   dataLogDir=/usr/local/zookeeper/logs #Zookeeper保存⽇志⽂件的⽬录
   # the port at which the clients will connect
   clientPort=2181 #客户端连接 Zookeeper 服务器的端⼝
   admin.serverPort=8888 #默认占⽤8080端⼝
   # the maximum number of client connections.
   # increase this if you need to handle more clients
   maxClientCnxns=60
   #
   # Be sure to read the maintenance section of the
   # administrator guide before turning on autopurge.
   #
   # http://zookeeper.apache.org/doc/current/zookeeperAdmin.html#sc_maintenan
   #
   # The number of snapshots to retain in dataDir
   autopurge.snapRetainCount=3
   # Purge task interval in hours
   # Set to "0" to disable auto purge feature
   autopurge.purgeInterval=1
   server.1=elk-1:2888:3888
   server.2=elk-2:2888:3888
   server.3=elk-3:2888:3888
   ```

5. 配置节点标识(3)

   ```sh
   elk-1：
   echo "1" > /tmp/zookeeper/myid
   elk-2
   echo "2" > /tmp/zookeeper/myid
   elk-3：
   echo "3" > /tmp/zookeeper/myid
   
   
   # 注意
   提前创建目录，否则会报错
   ```

6. 启动(3)

   ```sh
   zkServer.sh start
   zkServer.sh status
   
   
   [root@elk-3 ~]# lsof -i:2888
   COMMAND  PID USER   FD   TYPE DEVICE SIZE/OFF NODE NAME
   java    1954 root   58u  IPv6  28845      0t0  TCP elk-3:spcsdlobby (LISTEN)
   java    1954 root   59u  IPv6  28846      0t0  TCP elk-3:spcsdlobby->elk-1:39860 (ESTABLISHED)
   java    1954 root   60u  IPv6  28847      0t0  TCP elk-3:spcsdlobby->elk-2:41556 (ESTABLISHED)
   
   # 注意
   1. 查看ZK端⼝监听情况 losf -i:命令来查看端⼝信息 leader：如果此设备是leader，那么使⽤lo
   sf查看到的连接会是与集群内所有的follower的连接 follower：如果此设备是follower，那么
   使⽤losf查看到的连接将只会与ZK集群中的leader连接
   2. zkServer.sh start-foreground #启动并显示相关⽇志
   ```

7. 验证

   ```sh
   # 客户端连接
   [root@elk-3 ~]# zkCli.sh -server elk1:2181 
   ```

   





## Kafka集群部署

### 简介

1. Kafka是⼀个开源的分布式消息引擎/消息中间件，基于 Zookeeper 协调的分布式消息中间件系 统，它的最⼤的特性就是可以实时的处理⼤量数据以满⾜各种需求场景，⽐如基于 hadoop 的批处理系统、低延迟的实时系统、Spark/Flink 流式处理引擎，nginx 访问⽇志，消息服务等
2. 使⽤kafka集群的主要原因是由于在⾼并发环境下，同步请求来不及处理，请求往往会发⽣阻塞。 ⽐如⼤量的请求并发访问数据库，导致⾏锁表锁，最后请求线程会堆积过多，从⽽触发 too many connection 错误，引发雪崩效应。我们使⽤消息队列，通过异步处理请求，从⽽缓解系统的压⼒。消息队列常应⽤于异步处理，流量 削峰，应⽤解耦，消息通讯等场景。
3. 在Kafka集群(Cluster)中，⼀个Kafka节点就是⼀个Broker，消息由Topic来承载， 可以存储在1个或多个Partition中,Partition⽤于主题分⽚存储。 发布消息的应⽤为Producer、消费消息的应⽤为Consumer，多个Consumer可以促 成Consumer Group共同消费⼀个Topic中的消息。



### 部署

1. 安装(3)

   ```sh
   wget https://mirrors.tuna.tsinghua.edu.cn/apache/kafka/2.8.2/kafka_2.12-2.8.2.tgz
   ```

2. 调整(3)

   ```sh
   tar -zxvf kafka_2.12-2.8.1.tgz -C /usr/local/
   mv /usr/local/kafka_2.12-2.8.1 /usr/local/kafka
   cp /usr/local/kafka/config/server.properties{,.bak}
   ```

3. 修改环境变量(3)

   ```sh
   cat >> /etc/profile <<EOF
   export KAFKA_HOME=/usr/local/kafka
   export PATH=$KAFKA_HOME/bin:$PATH
   EOF
   #使环境变量⽣效
   source /etc/profile
   echo $KAFKA_HOME
   ```

4. 修改elk-1的kafka配置文件

   ```sh
   [root@elk-1 ~]# cat /usr/local/kafka/config/server.properties
   # Licensed to the Apache Software Foundation (ASF) under one or more
   # contributor license agreements.  See the NOTICE file distributed with
   # this work for additional information regarding copyright ownership.
   # The ASF licenses this file to You under the Apache License, Version 2.0
   # (the "License"); you may not use this file except in compliance with
   # the License.  You may obtain a copy of the License at
   #
   #    http://www.apache.org/licenses/LICENSE-2.0
   #
   # Unless required by applicable law or agreed to in writing, software
   # distributed under the License is distributed on an "AS IS" BASIS,
   # WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   # See the License for the specific language governing permissions and
   # limitations under the License.
   
   # see kafka.server.KafkaConfig for additional details and defaults
   
   ############################# Server Basics #############################
   
   # The id of the broker. This must be set to a unique integer for each broker.
   # 此处为唯一标识，且必须是证书
   broker.id=1
   
   ############################# Socket Server Settings #############################
   
   # The address the socket server listens on. It will get the value returned from 
   # java.net.InetAddress.getCanonicalHostName() if not configured.
   #   FORMAT:
   #     listeners = listener_name://host_name:port
   #   EXAMPLE:
   #     listeners = PLAINTEXT://your.host.name:9092
   listeners=PLAINTEXT://192.168.223.100:9092
   
   # Hostname and port the broker will advertise to producers and consumers. If not set, 
   # it uses the value for "listeners" if configured.  Otherwise, it will use the value
   # returned from java.net.InetAddress.getCanonicalHostName().
   #advertised.listeners=PLAINTEXT://your.host.name:9092
   
   # Maps listener names to security protocols, the default is for them to be the same. See the config documentation for more details
   #listener.security.protocol.map=PLAINTEXT:PLAINTEXT,SSL:SSL,SASL_PLAINTEXT:SASL_PLAINTEXT,SASL_SSL:SASL_SSL
   
   # The number of threads that the server uses for receiving requests from the network and sending responses to the network
   num.network.threads=3
   
   # The number of threads that the server uses for processing requests, which may include disk I/O
   num.io.threads=8
   
   # The send buffer (SO_SNDBUF) used by the socket server
   socket.send.buffer.bytes=102400
   
   # The receive buffer (SO_RCVBUF) used by the socket server
   socket.receive.buffer.bytes=102400
   
   # The maximum size of a request that the socket server will accept (protection against OOM)
   socket.request.max.bytes=104857600
   
   
   ############################# Log Basics #############################
   
   # A comma separated list of directories under which to store log files
   log.dirs=/usr/local/kafka/logs
   
   # The default number of log partitions per topic. More partitions allow greater
   # parallelism for consumption, but this will also result in more files across
   # the brokers.
   num.partitions=3
   
   # The number of threads per data directory to be used for log recovery at startup and flushing at shutdown.
   # This value is recommended to be increased for installations with data dirs located in RAID array.
   num.recovery.threads.per.data.dir=1
   
   ############################# Internal Topic Settings  #############################
   # The replication factor for the group metadata internal topics "__consumer_offsets" and "__transaction_state"
   # For anything other than development testing, a value greater than 1 is recommended to ensure availability such as 3.
   offsets.topic.replication.factor=1
   transaction.state.log.replication.factor=1
   transaction.state.log.min.isr=1
   
   ############################# Log Flush Policy #############################
   
   # Messages are immediately written to the filesystem but by default we only fsync() to sync
   # the OS cache lazily. The following configurations control the flush of data to disk.
   # There are a few important trade-offs here:
   #    1. Durability: Unflushed data may be lost if you are not using replication.
   #    2. Latency: Very large flush intervals may lead to latency spikes when the flush does occur as there will be a lot of data to flush.
   #    3. Throughput: The flush is generally the most expensive operation, and a small flush interval may lead to excessive seeks.
   # The settings below allow one to configure the flush policy to flush data after a period of time or
   # every N messages (or both). This can be done globally and overridden on a per-topic basis.
   
   # The number of messages to accept before forcing a flush of data to disk
   #log.flush.interval.messages=10000
   
   # The maximum amount of time a message can sit in a log before we force a flush
   #log.flush.interval.ms=1000
   
   ############################# Log Retention Policy #############################
   
   # The following configurations control the disposal of log segments. The policy can
   # be set to delete segments after a period of time, or after a given size has accumulated.
   # A segment will be deleted whenever *either* of these criteria are met. Deletion always happens
   # from the end of the log.
   
   # The minimum age of a log file to be eligible for deletion due to age
   log.retention.hours=168
   
   # A size-based retention policy for logs. Segments are pruned from the log unless the remaining
   # segments drop below log.retention.bytes. Functions independently of log.retention.hours.
   #log.retention.bytes=1073741824
   
   # The maximum size of a log segment file. When this size is reached a new log segment will be created.
   log.segment.bytes=1073741824
   
   # The interval at which log segments are checked to see if they can be deleted according
   # to the retention policies
   log.retention.check.interval.ms=300000
   
   ############################# Zookeeper #############################
   
   # Zookeeper connection string (see zookeeper docs for details).
   # This is a comma separated host:port pairs, each corresponding to a zk
   # server. e.g. "127.0.0.1:3000,127.0.0.1:3001,127.0.0.1:3002".
   # You can also append an optional chroot string to the urls to specify the
   # root directory for all kafka znodes.
   zookeeper.connect=elk-1:2181,elk-2:2181,elk-3:2181
   
   # Timeout in ms for connecting to zookeeper
   zookeeper.connection.timeout.ms=18000
   
   
   ############################# Group Coordinator Settings #############################
   
   # The following configuration specifies the time, in milliseconds, that the GroupCoordinator will delay the initial consumer rebalance.
   # The rebalance will be further delayed by the value of group.initial.rebalance.delay.ms as new members join the group, up to a maximum of max.poll.interval.ms.
   # The default value for this is 3 seconds.
   # We override this to 0 here as it makes for a better out-of-the-box experience for development and testing.
   # However, in production environments the default value of 3 seconds is more suitable as this will help to avoid unnecessary, and potentially expensive, rebalances during application startup.
   group.initial.rebalance.delay.ms=0
   ```

5. 配置elk-2的kafka的配置文件

   ```sh
   [root@elk-2 log]# cat /usr/local/kafka/config/server.properties
   # Licensed to the Apache Software Foundation (ASF) under one or more
   # contributor license agreements.  See the NOTICE file distributed with
   # this work for additional information regarding copyright ownership.
   # The ASF licenses this file to You under the Apache License, Version 2.0
   # (the "License"); you may not use this file except in compliance with
   # the License.  You may obtain a copy of the License at
   #
   #    http://www.apache.org/licenses/LICENSE-2.0
   #
   # Unless required by applicable law or agreed to in writing, software
   # distributed under the License is distributed on an "AS IS" BASIS,
   # WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   # See the License for the specific language governing permissions and
   # limitations under the License.
   
   # see kafka.server.KafkaConfig for additional details and defaults
   
   ############################# Server Basics #############################
   
   # The id of the broker. This must be set to a unique integer for each broker.
   broker.id=2
   
   ############################# Socket Server Settings #############################
   
   # The address the socket server listens on. It will get the value returned from 
   # java.net.InetAddress.getCanonicalHostName() if not configured.
   #   FORMAT:
   #     listeners = listener_name://host_name:port
   #   EXAMPLE:
   #     listeners = PLAINTEXT://your.host.name:9092
   listeners=PLAINTEXT://192.168.223.101:9092
   
   # Hostname and port the broker will advertise to producers and consumers. If not set, 
   # it uses the value for "listeners" if configured.  Otherwise, it will use the value
   # returned from java.net.InetAddress.getCanonicalHostName().
   #advertised.listeners=PLAINTEXT://your.host.name:9092
   
   # Maps listener names to security protocols, the default is for them to be the same. See the config documentation for more details
   #listener.security.protocol.map=PLAINTEXT:PLAINTEXT,SSL:SSL,SASL_PLAINTEXT:SASL_PLAINTEXT,SASL_SSL:SASL_SSL
   
   # The number of threads that the server uses for receiving requests from the network and sending responses to the network
   num.network.threads=3
   
   # The number of threads that the server uses for processing requests, which may include disk I/O
   num.io.threads=8
   
   # The send buffer (SO_SNDBUF) used by the socket server
   socket.send.buffer.bytes=102400
   
   # The receive buffer (SO_RCVBUF) used by the socket server
   socket.receive.buffer.bytes=102400
   
   # The maximum size of a request that the socket server will accept (protection against OOM)
   socket.request.max.bytes=104857600
   
   
   ############################# Log Basics #############################
   
   # A comma separated list of directories under which to store log files
   log.dirs=/usr/local/kafka/logs
   
   # The default number of log partitions per topic. More partitions allow greater
   # parallelism for consumption, but this will also result in more files across
   # the brokers.
   num.partitions=3
   
   # The number of threads per data directory to be used for log recovery at startup and flushing at shutdown.
   # This value is recommended to be increased for installations with data dirs located in RAID array.
   num.recovery.threads.per.data.dir=1
   
   ############################# Internal Topic Settings  #############################
   # The replication factor for the group metadata internal topics "__consumer_offsets" and "__transaction_state"
   # For anything other than development testing, a value greater than 1 is recommended to ensure availability such as 3.
   offsets.topic.replication.factor=1
   transaction.state.log.replication.factor=1
   transaction.state.log.min.isr=1
   
   ############################# Log Flush Policy #############################
   
   # Messages are immediately written to the filesystem but by default we only fsync() to sync
   # the OS cache lazily. The following configurations control the flush of data to disk.
   # There are a few important trade-offs here:
   #    1. Durability: Unflushed data may be lost if you are not using replication.
   #    2. Latency: Very large flush intervals may lead to latency spikes when the flush does occur as there will be a lot of data to flush.
   #    3. Throughput: The flush is generally the most expensive operation, and a small flush interval may lead to excessive seeks.
   # The settings below allow one to configure the flush policy to flush data after a period of time or
   # every N messages (or both). This can be done globally and overridden on a per-topic basis.
   
   # The number of messages to accept before forcing a flush of data to disk
   #log.flush.interval.messages=10000
   
   # The maximum amount of time a message can sit in a log before we force a flush
   #log.flush.interval.ms=1000
   
   ############################# Log Retention Policy #############################
   
   # The following configurations control the disposal of log segments. The policy can
   # be set to delete segments after a period of time, or after a given size has accumulated.
   # A segment will be deleted whenever *either* of these criteria are met. Deletion always happens
   # from the end of the log.
   
   # The minimum age of a log file to be eligible for deletion due to age
   log.retention.hours=168
   
   # A size-based retention policy for logs. Segments are pruned from the log unless the remaining
   # segments drop below log.retention.bytes. Functions independently of log.retention.hours.
   #log.retention.bytes=1073741824
   
   # The maximum size of a log segment file. When this size is reached a new log segment will be created.
   log.segment.bytes=1073741824
   
   # The interval at which log segments are checked to see if they can be deleted according
   # to the retention policies
   log.retention.check.interval.ms=300000
   
   ############################# Zookeeper #############################
   
   # Zookeeper connection string (see zookeeper docs for details).
   # This is a comma separated host:port pairs, each corresponding to a zk
   # server. e.g. "127.0.0.1:3000,127.0.0.1:3001,127.0.0.1:3002".
   # You can also append an optional chroot string to the urls to specify the
   # root directory for all kafka znodes.
   zookeeper.connect=elk-1:2181,elk-2:2181,elk-3:2181
   
   # Timeout in ms for connecting to zookeeper
   zookeeper.connection.timeout.ms=18000
   
   
   ############################# Group Coordinator Settings #############################
   
   # The following configuration specifies the time, in milliseconds, that the GroupCoordinator will delay the initial consumer rebalance.
   # The rebalance will be further delayed by the value of group.initial.rebalance.delay.ms as new members join the group, up to a maximum of max.poll.interval.ms.
   # The default value for this is 3 seconds.
   # We override this to 0 here as it makes for a better out-of-the-box experience for development and testing.
   # However, in production environments the default value of 3 seconds is more suitable as this will help to avoid unnecessary, and potentially expensive, rebalances during application startup.
   group.initial.rebalance.delay.ms=0
   ```

6. 修改elk-3的kafka的配置文件

   ```sh
   [root@elk3 ~]# cat /usr/local/kafka/config/server.properties
   # Licensed to the Apache Software Foundation (ASF) under one or more
   # contributor license agreements.  See the NOTICE file distributed with
   # this work for additional information regarding copyright ownership.
   # The ASF licenses this file to You under the Apache License, Version 2.0
   # (the "License"); you may not use this file except in compliance with
   # the License.  You may obtain a copy of the License at
   #
   #    http://www.apache.org/licenses/LICENSE-2.0
   #
   # Unless required by applicable law or agreed to in writing, software
   # distributed under the License is distributed on an "AS IS" BASIS,
   # WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   # See the License for the specific language governing permissions and
   # limitations under the License.
   
   # see kafka.server.KafkaConfig for additional details and defaults
   
   ############################# Server Basics #############################
   
   # The id of the broker. This must be set to a unique integer for each broker.
   broker.id=3
   
   ############################# Socket Server Settings #############################
   
   # The address the socket server listens on. It will get the value returned from 
   # java.net.InetAddress.getCanonicalHostName() if not configured.
   #   FORMAT:
   #     listeners = listener_name://host_name:port
   #   EXAMPLE:
   #     listeners = PLAINTEXT://your.host.name:9092
   listeners=PLAINTEXT://192.168.223.102:9092
   
   # Hostname and port the broker will advertise to producers and consumers. If not set, 
   # it uses the value for "listeners" if configured.  Otherwise, it will use the value
   # returned from java.net.InetAddress.getCanonicalHostName().
   #advertised.listeners=PLAINTEXT://your.host.name:9092
   
   # Maps listener names to security protocols, the default is for them to be the same. See the config documentation for more details
   #listener.security.protocol.map=PLAINTEXT:PLAINTEXT,SSL:SSL,SASL_PLAINTEXT:SASL_PLAINTEXT,SASL_SSL:SASL_SSL
   
   # The number of threads that the server uses for receiving requests from the network and sending responses to the network
   num.network.threads=3
   
   # The number of threads that the server uses for processing requests, which may include disk I/O
   num.io.threads=8
   
   # The send buffer (SO_SNDBUF) used by the socket server
   socket.send.buffer.bytes=102400
   
   # The receive buffer (SO_RCVBUF) used by the socket server
   socket.receive.buffer.bytes=102400
   
   # The maximum size of a request that the socket server will accept (protection against OOM)
   socket.request.max.bytes=104857600
   
   
   ############################# Log Basics #############################
   
   # A comma separated list of directories under which to store log files
   log.dirs=/usr/local/kafka/logs
   
   # The default number of log partitions per topic. More partitions allow greater
   # parallelism for consumption, but this will also result in more files across
   # the brokers.
   num.partitions=3
   
   # The number of threads per data directory to be used for log recovery at startup and flushing at shutdown.
   # This value is recommended to be increased for installations with data dirs located in RAID array.
   num.recovery.threads.per.data.dir=1
   
   ############################# Internal Topic Settings  #############################
   # The replication factor for the group metadata internal topics "__consumer_offsets" and "__transaction_state"
   # For anything other than development testing, a value greater than 1 is recommended to ensure availability such as 3.
   offsets.topic.replication.factor=1
   transaction.state.log.replication.factor=1
   transaction.state.log.min.isr=1
   
   ############################# Log Flush Policy #############################
   
   # Messages are immediately written to the filesystem but by default we only fsync() to sync
   # the OS cache lazily. The following configurations control the flush of data to disk.
   # There are a few important trade-offs here:
   #    1. Durability: Unflushed data may be lost if you are not using replication.
   #    2. Latency: Very large flush intervals may lead to latency spikes when the flush does occur as there will be a lot of data to flush.
   #    3. Throughput: The flush is generally the most expensive operation, and a small flush interval may lead to excessive seeks.
   # The settings below allow one to configure the flush policy to flush data after a period of time or
   # every N messages (or both). This can be done globally and overridden on a per-topic basis.
   
   # The number of messages to accept before forcing a flush of data to disk
   #log.flush.interval.messages=10000
   
   # The maximum amount of time a message can sit in a log before we force a flush
   #log.flush.interval.ms=1000
   
   ############################# Log Retention Policy #############################
   
   # The following configurations control the disposal of log segments. The policy can
   # be set to delete segments after a period of time, or after a given size has accumulated.
   # A segment will be deleted whenever *either* of these criteria are met. Deletion always happens
   # from the end of the log.
   
   # The minimum age of a log file to be eligible for deletion due to age
   log.retention.hours=168
   
   # A size-based retention policy for logs. Segments are pruned from the log unless the remaining
   # segments drop below log.retention.bytes. Functions independently of log.retention.hours.
   #log.retention.bytes=1073741824
   
   # The maximum size of a log segment file. When this size is reached a new log segment will be created.
   log.segment.bytes=1073741824
   
   # The interval at which log segments are checked to see if they can be deleted according
   # to the retention policies
   log.retention.check.interval.ms=300000
   
   ############################# Zookeeper #############################
   
   # Zookeeper connection string (see zookeeper docs for details).
   # This is a comma separated host:port pairs, each corresponding to a zk
   # server. e.g. "127.0.0.1:3000,127.0.0.1:3001,127.0.0.1:3002".
   # You can also append an optional chroot string to the urls to specify the
   # root directory for all kafka znodes.
   zookeeper.connect=elk-1:2181,elk-2:2181,elk-3:2181
   
   # Timeout in ms for connecting to zookeeper
   zookeeper.connection.timeout.ms=18000
   
   
   ############################# Group Coordinator Settings #############################
   
   # The following configuration specifies the time, in milliseconds, that the GroupCoordinator will delay the initial consumer rebalance.
   # The rebalance will be further delayed by the value of group.initial.rebalance.delay.ms as new members join the group, up to a maximum of max.poll.interval.ms.
   # The default value for this is 3 seconds.
   # We override this to 0 here as it makes for a better out-of-the-box experience for development and testing.
   # However, in production environments the default value of 3 seconds is more suitable as this will help to avoid unnecessary, and potentially expensive, rebalances during application startup.
   group.initial.rebalance.delay.ms=0
   ```

7. 启动(3)

   ```sh
   kafka-server-start.sh -daemon /usr/local/kafka/config/server.properties
   nohup kafka-server-start.sh /usr/local/kafka/config/server.properties >> /var/log/kafka-server.log 2>&1 &
   
   
   
   # 注意
   1. 关闭命令
       kafka-server-stop.sh
   2. kafka节点默认需要的内存为1G，在⼯作中可能会调⼤该参数，可修改kafka-server-start.sh的配置项。找到KAFKA_HEAP_OPTS配置项，例如修改为：export KAFKA_HEAP_OPTS="-Xmx2G -Xms2G"。
   ```

8. 测试

   ```sh
   # 创建Topic：
   # 在kf1(Broker)上创建测试Tpoic：test-ken,这⾥我们指定了3个副本Broker、test-ken有2个
   分区
   [root@elk-1 ~]# kafka-topics.sh --create --bootstrap-server elk-1:9092 --replication-factor 3 --partitions 2 --topic test-ken
   选项解释：
   --create：             创建新的Topic
   --bootstrap-server：   指定要哪台Kafka服务器上创建Topic，主机加端⼝，指定的主机地址⼀定要和配置⽂件中的listeners⼀致
   --zookeeper：          指定要哪台zookeeper服务器上创建Topic，主机加端⼝，指定的主机地址⼀定要和配置⽂件中的listeners⼀致
   --replication-factor： 创建Topic中的每个分区(partition)中的复制因⼦数量，即为Topic的副本数量，建议和Broker节点数量⼀致，如果复制因⼦超出Broker节点将⽆法创建
   --partitions：         创建该Topic中的分区(partition)数量
   --topic：              指定Topic名称
   
   
   # 查看Topic:
   # Topic在kf1上创建后也会同步到集群中另外两个副本Broker：kf2、kf3,通过以下命令列出指定Broker的topic信息
   [root@elk-1 ~]# kafka-topics.sh --list --bootstrap-server elk-2:9092
   test-ken
   
   
   # 查看Topic详情：
   [root@elk-3 ~]# kafka-topics.sh --describe --bootstrap-server elk-1:9092 --topic test-ken
   Topic: test-ken TopicId: h6UxRKILTpaDE3U0CZbLAg PartitionCount: 2 Replicat
   ionFactor: 3 Configs: segment.bytes=1073741824
   Topic: test-ken Partition: 0 Leader: 2 Replicas: 2,3,1 Isr: 2,3,1
   Topic: test-ken Partition: 1 Leader: 3 Replicas: 3,1,2 Isr: 3,1,2
   # 解释：
   Topic:kafka_data：topic名称
   PartitionCount:2：分⽚数量
   ReplicationFactor:3：Topic副本数量
   
   
   
   
   
   
   发送消息：
   向Broker(id=1)的Topic=test-ken发送消息
   [root@elk-1 config]# kafka-console-producer.sh --broker-list elk-1:9092 --topic test-ken
   >this is test
   >bye
   
   
   从开始位置消费(所有节点均能收到)
   [root@elk-1 config]# kafka-console-consumer.sh --bootstrap-server elk-2:9092 --topic test-ken --from-beginning
   this is test
   bye
   从最新位置消费
   [root@elk-1 config]# kafka-console-consumer.sh --bootstrap-server elk-1:9092 --topic test-ken
   
   
   
   
   
   
   
   消费者组：
   ⼀个Consumer group,多个consumer进程,数量⼩于等于partition分区的数量
   test-ken只有2个分区，只能有两个消费者consumer进程去轮询消费消息
   [root@elk-1 config]# kafka-console-consumer.sh --bootstrap-server elk-1:909
   2 --topic test-ken --group testgroup_ken
   [root@elk-1 config]# kafka-console-consumer.sh --bootstrap-server elk-1:909
   2 --topic test-ken --group testgroup_ken
   [root@elk-1 config]#
   删除Topic：
   [root@elk-3 ~]# kafka-topics.sh --delete --bootstrap-server elk-1:9092 --top
   ic test-ken
   查看删除信息:
   [root@elk-3 ~]# kafka-topics.sh --list --bootstrap-server elk-2:9092
   
   
   
   
   
   
   
   
   #查看当前服务器中的所有topic
   kafka-topics.sh --list --zookeeper elk-1:2181,192.elk-2:2181,elk-3:2181
   #查看某个topic的详情
   kafka-topics.sh --describe --zookeeper elk-1:2181,192.elk-2:2181,elk-3:2181
   #发布消息
   kafka-console-producer.sh --broker-list elk-1:9092,elk-2:9092,elk-3:9092 --topic test
   #消费消息
   kafka-console-consumer.sh --bootstrap-server elk-1:9092,elk-2:9092,elk-3:9092 --topic test --from-beginning
   --from-beginning 会把主题中以往所有的数据都读取出来
   #修改分区数
   kafka-topics.sh --zookeeper elk-1:2181,192.elk-2:2181,elk-3:2181 --alter --topic test --partitions 6
   #删除topic
   kafka-topics.sh --delete --zookeeper elk-1:2181,192.elk-2:2181,elk-3:2181 --topic test
   
   ```



### 扩展

1. zookeeper使用

   ```sh
   1、broker在zk中注册
   kafka的每个broker（相当于⼀个节点，相当于⼀个机器）在启动时，都会在zk中注册，告诉zk其b
   rokerid，在整个的集群中，broker.id/brokers/ids，当节点失效时，zk就会删除该节点，就
   很⽅便的监控整个集群broker的变化，及时调整负载均衡。
   [root@elk-3 ~]# zkCli.sh -server elk1:2181
   WatchedEvent state:SyncConnected type:None path:null
   [zk: elk-1:2181(CONNECTED) 0] ls /brokers/
   ids seqid topics 
   [zk: elk-1:2181(CONNECTED) 0] ls /brokers/ids
   [1, 2, 3]
   [zk: elk-1:2181(CONNECTED) 1]
   
   2、topic在zk中注册
   在kafka中可以定义很多个topic，每个topic⼜被分为很多个分区。⼀般情况下，每个分区独⽴在
   存在⼀个broker上，所有的这些topic和broker的对应关系都有zk进⾏维护
   [zk: elk-1:2181(CONNECTED) 1] ls /brokers/topics/test-ken/partitions
   [0, 1]
   
   3、consumer(消费者)在zk中注册
   注意：从kafka-0.9版本及以后，kafka的消费者组和offset信息就不存zookeeper了，⽽是存到
   broker服务器上。
   所以，如果你为某个消费者指定了⼀个消费者组名称（group.id），那么，⼀旦这个消费者启动，
   这个消费者组名和它要消费的那个topic的offset信息就会被记录在broker服务器上。，但是zook
   eeper其实并不适合进⾏⼤批量的读写操作，尤其是写操作。因此kafka提供了另⼀种解决⽅案：增
   加__consumeroffsets topic，将offset信息写⼊这个topic
   [zk: elk-1:2181(CONNECTED) 2] ls /brokers/topics/__consumer_offsets/partiti
   ons
   [0, 1, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 2, 20, 21, 22, 23, 24, 25,
   26, 27, 28, 29, 3, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 4, 40, 41, 42,
   43, 44, 45, 46, 47, 48, 49, 5, 6, 7, 8, 9]
   ```

2. 配置文件详解

   ```sh
   broker.id=1 #每⼀个broker在集群中的唯⼀表示，要求是正数
   listeners=PLAINTEXT://10.1.1.10:9092 #监控的kafka端⼝
   num.network.threads=3 #broker处理消息的最⼤线程数，⼀般情况下不需要去修改
   num.io.threads=8 #broker处理磁盘IO的线程数，数值应该⼤于你的硬盘数
   socket.send.buffer.bytes=102400 #socket的发送缓冲区
   socket.receive.buffer.bytes=102400 #socket的接受缓冲区
   socket.request.max.bytes=104857600 #socket请求的最⼤字节数
   log.dirs=/usr/local/kafka/logs #kafka数据的存放地址,多个地址⽤逗号分割,多个⽬录分
   布在不同磁盘上可以提⾼读写性能 /tmp/kafka-log,/tmp/kafka-log2
   num.partitions=3 #设置partitions 的个数
   num.recovery.threads.per.data.dir=1
   offsets.topic.replication.factor=1
   transaction.state.log.replication.factor=1
   transaction.state.log.min.isr=1
   log.retention.hours=168 #数据⽂件保留多⻓时间,此处为168h,粒度还可设置为分钟,或按照
   ⽂件⼤⼩
   log.segment.bytes=1073741824 #topic的分区是以⼀堆segment⽂件存储的,这个控制每个s
   egment的⼤⼩,会被topic创建时的指定参数覆盖
   log.retention.check.interval.ms=300000
   zookeeper.connect=elk1:2181,elk2:2181,elk3:2181 #zookeeper集群地址
   zookeeper.connection.timeout.ms=6000 #kafka连接Zookeeper的超时时间
   group.initial.rebalance.delay.ms=0
   ```







# Beats部署采集日志

1. 安装

   ```sh
   [root@elk-2 ~]# wget https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-6.0.0-x86_64.rpm
   [root@elk-2 ~]# rpm -ivh filebeat-6.0.0-x86_64.rpm
   ```

2. 编辑抓取文件

   ```sh
   [root@elk2 log]# cat /etc/filebeat/filebeat.yml 
   ###################### Filebeat Configuration Example #########################
   
   # This file is an example configuration file highlighting only the most common
   # options. The filebeat.reference.yml file from the same directory contains all the
   # supported options with more comments. You can use it as a reference.
   #
   # You can find the full configuration reference here:
   # https://www.elastic.co/guide/en/beats/filebeat/index.html
   
   # For more available modules and options, please see the filebeat.reference.yml sample
   # configuration file.
   
   #=========================== Filebeat prospectors =============================
   
   filebeat.prospectors:
   
   # Each - is a prospector. Most options can be set at the prospector level, so
   # you can use different prospectors for various configurations.
   # Below are the prospector specific configurations.
   
   - type: log
   
     # Change to true to enable this prospector configuration.
     enabled: true
   
     # Paths that should be crawled and fetched. Glob based paths.
     paths:
       - /var/log/httpd/access_log
       #- c:\programdata\elasticsearch\logs\*
   
     # Exclude lines. A list of regular expressions to match. It drops the lines that are
     # matching any regular expression from the list.
     #exclude_lines: ['^DBG']
   
     # Include lines. A list of regular expressions to match. It exports the lines that are
     # matching any regular expression from the list.
     #include_lines: ['^ERR', '^WARN']
   
     # Exclude files. A list of regular expressions to match. Filebeat drops the files that
     # are matching any regular expression from the list. By default, no files are dropped.
     #exclude_files: ['.gz$']
   
     # Optional additional fields. These fields can be freely picked
     # to add additional information to the crawled log files for filtering
     #fields:
     #  level: debug
     #  review: 1
   
     ### Multiline options
   
     # Mutiline can be used for log messages spanning multiple lines. This is common
     # for Java Stack Traces or C-Line Continuation
   
     # The regexp Pattern that has to be matched. The example pattern matches all lines starting with [
     #multiline.pattern: ^\[
   
     # Defines if the pattern set under pattern should be negated or not. Default is false.
     #multiline.negate: false
   
     # Match can be set to "after" or "before". It is used to define if lines should be append to a pattern
     # that was (not) matched before or after or as long as a pattern is not matched based on negate.
     # Note: After is the equivalent to previous and before is the equivalent to to next in Logstash
     #multiline.match: after
   
   
   #============================= Filebeat modules ===============================
   
   filebeat.config.modules:
     # Glob pattern for configuration loading
     path: ${path.config}/modules.d/*.yml
   
     # Set to true to enable config reloading
     reload.enabled: false
   
     # Period on which files under path should be checked for changes
     #reload.period: 10s
   
   #==================== Elasticsearch template setting ==========================
   
   setup.template.settings:
     index.number_of_shards: 3
     #index.codec: best_compression
     #_source.enabled: false
   
   #================================ General =====================================
   
   # The name of the shipper that publishes the network data. It can be used to group
   # all the transactions sent by a single shipper in the web interface.
   #name:
   
   # The tags of the shipper are included in their own field with each
   # transaction published.
   #tags: ["service-X", "web-tier"]
   
   # Optional fields that you can specify to add additional information to the
   # output.
   #fields:
   #  env: staging
   
   
   #============================== Dashboards =====================================
   # These settings control loading the sample dashboards to the Kibana index. Loading
   # the dashboards is disabled by default and can be enabled either by setting the
   # options here, or by using the `-setup` CLI flag or the `setup` command.
   #setup.dashboards.enabled: false
   
   # The URL from where to download the dashboards archive. By default this URL
   # has a value which is computed based on the Beat name and version. For released
   # versions, this URL points to the dashboard archive on the artifacts.elastic.co
   # website.
   #setup.dashboards.url:
   
   #============================== Kibana =====================================
   
   # Starting with Beats version 6.0.0, the dashboards are loaded via the Kibana API.
   # This requires a Kibana endpoint configuration.
   setup.kibana:
   
     # Kibana Host
     # Scheme and port can be left out and will be set to the default (http and 5601)
     # In case you specify and additional path, the scheme is required: http://localhost:5601/path
     # IPv6 addresses should always be defined as: https://[2001:db8::1]:5601
     #host: "localhost:5601"
   
   #============================= Elastic Cloud ==================================
   
   # These settings simplify using filebeat with the Elastic Cloud (https://cloud.elastic.co/).
   
   # The cloud.id setting overwrites the `output.elasticsearch.hosts` and
   # `setup.kibana.host` options.
   # You can find the `cloud.id` in the Elastic Cloud web UI.
   #cloud.id:
   
   # The cloud.auth setting overwrites the `output.elasticsearch.username` and
   # `output.elasticsearch.password` settings. The format is `<user>:<pass>`.
   #cloud.auth:
   
   #================================ Outputs =====================================
   
   # Configure what output to use when sending the data collected by the beat.
   
   #-------------------------- Elasticsearch output ------------------------------
   output.kafka:
     # Array of hosts to connect to.
     enabled: true
     hosts: ["elk-1:9092","elk-2:9092","elk-3:9092"]
     topic: httpd
     keep_alive: 10s
     # Optional protocol and basic auth credentials.
     #protocol: "https"
     #username: "elastic"
     #password: "changeme"
   
   #----------------------------- Logstash output --------------------------------
   #output.logstash:
     # The Logstash hosts
     #hosts: ["localhost:5044"]
   
     # Optional SSL. By default is off.
     # List of root certificates for HTTPS server verifications
     #ssl.certificate_authorities: ["/etc/pki/root/ca.pem"]
   
     # Certificate for SSL client authentication
     #ssl.certificate: "/etc/pki/client/cert.pem"
   
     # Client Certificate Key
     #ssl.key: "/etc/pki/client/cert.key"
   
   #================================ Logging =====================================
   
   # Sets log level. The default log level is info.
   # Available log levels are: critical, error, warning, info, debug
   #logging.level: debug
   
   # At debug level, you can selectively enable logging only for some components.
   # To enable all selectors use ["*"]. Examples of other selectors are "beat",
   # "publish", "service".
   #logging.selectors: ["*"]
   
   ```

3. 安装apache

   ```
   [root@elk-2 ~]# yum install -y httpd
   [root@elk-2 ~]# systemctl start httpd
   
   # 注意
   1. 记得浏览器访问ip让其生成日志文件
   ```

4. 配置logstash抓取文件

   ```sh
   [root@elk2 ~]# cat /etc/logstash/conf.d/httpd.conf 
   # Settings file in YAML
   input {
    kafka {
    bootstrap_servers => "192.168.223.100:9092,192.168.223.101:9092,192.168.223.102:9092"
    group_id => "logstash"
    auto_offset_reset => "earliest"
    decorate_events => true
    topics => "httpd"
    type => "messages"
    }
   }
   output {
   if [type] == "messages" {
    elasticsearch {
    hosts => ["elk-1:9200","elk-2:9200","elk-3:9200"]
    index => "httpd-%{+YYYY-MM-dd}"
    }
    }
   }
   
   
   # 检测是否有问题
   [root@elk2 ~]# logstash --path.settings /etc/logstash/ -f /etc/logstash/conf.d/syslog.conf --config.test_and_exit
   ```

5. 重启logstash和beat

   ```
   [root@elk-2 ~]# systemctl restart logstash
   [root@elk-2 ~]# systemclt restart beat
   ```

6. 测试

   ```sh
   # 测试beat和Kafka之间的传输
   [root@elk-2 ~]# kafka-topics.sh --list --zookeeper 192.168.223.101:2181,192.168.223.100:2181,192.168.223.102:2181
   __consumer_offsets
   es_access
   httpd
   test-ken
   
   
   # 测试kafka和es之间的传输（通过logstash）
   # 在这里出现后也就可以在图形化界面操作索引了
   [root@elk-2 ~]# curl '192.168.223.100:9200/_cat/indices?v'
   health status index                 uuid                   pri rep docs.count docs.deleted store.size pri.store.size
   green  open   httpd-2023-04-15      e0QBovfATUqrzd9GEVJQzA   5   1         25            0     71.9kb         35.9kb
   green  open   system-log-2023.04.15 iD6RRmlqTB6ACi350m9XWw   5   1       9338            0        4mb            2mb
   green  open   .kibana               lWGYNXjGQMCIapARlSQwWg   1   1          3            0     24.4kb         12.2kb
   
   
   
   
   
   # 注意
   1. 如果出现logstash只能input而无法output，则可能是指定日志文件的权限问题，建议将其所属者和执行权限全部放开，我这里是全部放开
   [root@elk2 log]# ll
   total 1588
   drwxr-xr-x. 2 logstash root              204 Apr 12 09:45 anaconda
   drwx------. 2 logstash root               23 Apr 12 09:47 audit
   -rw-------. 1 logstash root            17929 Apr 15 12:29 boot.log
   -rw-------. 1 logstash utmp                0 Apr 12 09:43 btmp
   drwxr-xr-x. 2 logstash chrony              6 Aug  8  2019 chrony
   -rw-------. 1 logstash root             2033 Apr 15 14:03 cron
   -rw-r--r--  1 logstash root           125217 Apr 15 12:29 dmesg
   -rw-r--r--. 1 logstash root           125482 Apr 12 09:47 dmesg.old
   drwxr-x---  2 logstash elasticsearch     122 Apr 15 12:39 elasticsearch
   drwxr-x---  2 logstash root               40 Apr 15 13:41 filebeat
   -rw-r-----. 1 logstash root              186 Apr 12 09:47 firewalld
   -rw-r--r--. 1 logstash root              193 Apr 12 09:43 grubby_prune_debug
   drwxrwxrwx  2 root     root               41 Apr 15 13:39 httpd
   -rw-r--r--  1 logstash root            32803 Apr 15 13:13 kafka-server.log
   -rw-r--r--. 1 logstash root           292000 Apr 15 14:52 lastlog
   drwxrwxrwx  2 logstash logstash           32 Apr 15 12:45 logstash
   -rw-------. 1 logstash root              396 Apr 15 12:29 maillog
   -rw-r--r--. 1 logstash root          1016856 Apr 15 14:52 messages
   drwxr-xr-x. 2 logstash root                6 Apr 12 09:45 rhsm
   -rw-------. 1 logstash root            13024 Apr 15 14:52 secure
   -rw-------. 1 logstash root                0 Apr 12 09:43 spooler
   -rw-------. 1 logstash root            64000 Apr 15 13:39 tallylog
   drwxr-xr-x. 2 logstash root               23 Apr 12 09:47 tuned
   -rw-------. 1 logstash root              719 Apr 12 09:47 vmware-network.1.log
   -rw-------  1 logstash root              719 Apr 15 12:29 vmware-network.log
   -rw-------. 1 logstash root             2782 Apr 15 12:29 vmware-vgauthsvc.log.0
   -rw-------. 1 logstash root           146899 Apr 15 14:52 vmware-vmsvc-root.log
   -rw-------. 1 logstash root              348 Apr 15 12:29 vmware-vmtoolsd-root.log
   -rw-rw-r--. 1 logstash utmp             5760 Apr 15 14:52 wtmp
   -rw-------. 1 logstash root             6578 Apr 15 13:39 yum.log
   [root@elk2 log]# ll httpd/
   total 12
   -rwxrwxrwx 1 logstash root 6390 Apr 15 13:39 access_log
   -rwxrwxrwx 1 logstash root 1689 Apr 15 13:39 error_log
   
   ```
   
   

