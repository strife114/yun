# MySQL主从同步

## 简介

实现MySQL主从配置，用于实现数据同步

## 环境

| 角色名 |      ip       |
| :----: | :-----------: |
| mysql1 | 192.168.223.3 |
| mysql2 | 192.168.223.4 |

## 主从同步

1. 卸载防火墙并清除规则(2)

   ```shell
   yum remove -y NetworkManager firewalld
   yum install -y iptables-services
   iptables -F
   iptables -X
   iptables -Z
   services iptables save
   ```

2. 建立互信(master)

   ```shell
   vim /etc/hosts
   192.168.223.3 master
   192.168.223.4 slave
   
   ssh-keygen
   ssh-copy-id slave
   
   ```

3. 时间同步(master)

   ```shell
   yum install -y ntp
   systemctl start ntpd
   systemctl enable ntpd
   
   
   # 测试
   [root@slave ~]# ntpdate master
   ```



## 主从配置

1. 卸载自带数据库(2)

   ```shell
   rpm -qa |grep mariadb
   rpm -e --nodeps mariadb-libs
   ```

2. 安装并设置(2)

   ```shell
   wget http://dev.mysql.com/get/mysql57-community-release-el7-8.noarch.rpm
   yum localinstall mysql57-community-release-el7-8.noarch.rpm -y
   yum install mysql-community-server -y --nogpgcheck   
    
   # 开启数据库并自启
    systemctl start mysqld
    systemctl enable mysqld
   # 查看初始化密码
    grep 'temporary password' /var/log/mysqld.log
   # 修改密码
    set password for 'root'@'localhost'=password('123456');
    或
    ALTER USER USER() IDENTIFIED BY '123456';
   # 赋权
    grant all privileges on *.* to 'root'@'%' identified by '123456' with grant option;
   # 生效权限
    flush privileges;
    
   
   
   注意：
   # 修改密码规则
   # 设置密码的验证强度等级(LOW)
    set global validate_password_policy=LOW;
   # 设置密码长度
    set global validate_password_length=6;
    
   # 若出现GPG Keys are configured as: file:///etc/pki/rpm-gpg/RPM-GPG-KEY-mysql 报错信息，需要更新MySQL的GPG，需要更新
   rpm --import https://repo.mysql.com/RPM-GPG-KEY-mysql-2022
   # 或者下载的时候直接不启动gpg认证
   yum install -y *** --nogpgcheck  (不校验数字签名)
   ```

3. 修改配置文件(2)

   [master]

   ```shell
   # For advice on how to change settings please see
   # http://dev.mysql.com/doc/refman/5.7/en/server-configuration-defaults.html
   
   [mysqld]
   #
   # Remove leading # and set to the amount of RAM for the most important data
   # cache in MySQL. Start at 70% of total RAM for dedicated server, else 10%.
   # innodb_buffer_pool_size = 128M
   #
   # Remove leading # to turn on a very important data integrity option: logging
   # changes to the binary log between backups.
   # log_bin
   datadir=/var/lib/mysql
   socket=/var/lib/mysql/mysql.sock
   log-bin = master-bin  #二进制日志文件 master-bin可以自己设置
   server-id = 1         #服务器的id号，用于区别
   log-slave-updates=true #开启从服务器更新日志功能（结合复制流程连接）
   max_connections = 1000
   max_connect_errors = 1000
   gtid_mode=on
   enforce-gtid-consistency=true
   log-slave-updates=on
   binlog_format=row
   # Remove leading # to set options mainly useful for reporting servers.
   # The server defaults are faster for transactions and fast SELECTs.
   # Adjust sizes as needed, experiment to find the optimal values.
   # join_buffer_size = 128M
   # sort_buffer_size = 2M
   # read_rnd_buffer_size = 2M
   #datadir=/var/lib/mysql
   #socket=/var/lib/mysql/mysql.sock
   
   # Disabling symbolic-links is recommended to prevent assorted security risks
   symbolic-links=0
   
   log-error=/var/log/mysqld.log
   pid-file=/var/run/mysqld/mysqld.pid
   ```

   [slave]

   ```shell
   # For advice on how to change settings please see
   # http://dev.mysql.com/doc/refman/5.7/en/server-configuration-defaults.html
   
   [mysqld]
   #
   # Remove leading # and set to the amount of RAM for the most important data
   # cache in MySQL. Start at 70% of total RAM for dedicated server, else 10%.
   # innodb_buffer_pool_size = 128M
   #
   # Remove leading # to turn on a very important data integrity option: logging
   # changes to the binary log between backups.
   # log_bin
   datadir=/var/lib/mysql
   socket=/var/lib/mysql/mysql.sock
   server-id=2  #开启二进制日志
   log-bin=master-bin  #使用中继日志进行同步
   relay-log=relay-log-bin
   relay-log-index=slave-relay-bin.index
   master_info_repository=TABLE
   slave-parallel-type=LOGICAL_CLOCK
   slave-parallel-workers=16
   relay_log_info_repository=TABLE
   relay_log_recovery=ON
   skip-name-resolve
   gtid_mode=on  #开启GITD复制模式
   enforce-gtid-consistency=true
   log-slave-updates=on  
   binlog_format=row
   # Remove leading # to set options mainly useful for reporting servers.
   # The server defaults are faster for transactions and fast SELECTs.
   # Adjust sizes as needed, experiment to find the optimal values.
   # join_buffer_size = 128M
   # sort_buffer_size = 2M
   # read_rnd_buffer_size = 2M
   #datadir=/var/lib/mysql
   #socket=/var/lib/mysql/mysql.sock
   
   # Disabling symbolic-links is recommended to prevent assorted security risks
   symbolic-links=0
   
   log-error=/var/log/mysqld.log
   pid-file=/var/run/mysqld/mysqld.pid
   ```

4. 创建同步账号(master)

   ```shell
   grant replication slave on *.* to 'myslave'@'192.168.223.%' identified by '123456';
   # master and slave
   systemctl restart mysqld
   systemctl restart mysqld
   ```

5. 连接

   ```shell
   # 从连主
   CHANGE MASTER TO MASTER_HOST='192.168.223.132', MASTER_USER='myslave', MASTER_PASSWORD='123456', MASTER_LOG_FILE='master-bin.000002', MASTER_LOG_POS=154;start slave;
   ```





## 主从测试

1. 测试1

   ```shell
   # master
   mysql> show master status \G
   # slave
   mysql> show slave status \G
   
   
   # 如果出现Slave_IO_Running: No/connecting
   stop slave;
   reset slave; #重启
   stop slave;
   #接着让从库连接主库
   CHANGE MASTER TO MASTER_HOST='192.168.223.4', MASTER_USER='myslave', MASTER_PASSWORD='123456', MASTER_LOG_FILE='master-bin.000002', MASTER_LOG_POS=154;start slave;
   ```

2. 测试2

   ```shell
   # master
   mysql> create database test;   
   Query OK, 1 row affected (0.00 sec)
   # 查看数据库是否创建成功
   mysql> show databases;   
   +--------------------+
   | Database           |
   +--------------------+
   | information_schema |
   | mysql              |
   | performance_schema |
   | sys                |
   | test               |
   +--------------------+
   5 rows in set (0.00 sec)
   
   # slave
   # 查看数据库是否同步
   mysql> show databases;   
   +--------------------+
   | Database           |
   +--------------------+
   | information_schema |
   | mysql              |
   | performance_schema |
   | sys                |
   | test               |
   +--------------------+
   5 rows in set (0.00 sec)
   ```
   
   





# MySQL读写分离

## 简介

mycat是数据库中间件，介于数据库与应用之间，进行数据处理与交互的中间件服务

## 环境

| 角色名 |      ip       |
| :----: | :-----------: |
| mycat1 | 192.168.223.5 |
| mycat2 | 192.168.223.6 |
| mysql1 | 192.168.223.3 |
| mysql2 | 192.168.223.4 |

## jdk安装

1. 下载

   ```shell
   # 查看是否已有java
   rpm -qa | grep java
   # noarch文件可不删除
   rpm -e --nodeps java-1.7.0-openjdk-headless  java-1.7.0-openjdk
   
   # 下载压缩包
    http://www.codebaoku.com/jdk/jdk-oracle-jdk1-8.html
   ```

2. 调试配置

   ```shell
   # 解压并调整位置
   tar -zxvf  jdk-8u91-linux-x64.tar.gz
   mv jdk1.8.0_91 /usr/local/java
   
   # 添加环境变量
   # vim /etc/profile
   export JAVA_HOME=/usr/local/java/jdk1.8.0_91
   export CLASSPATH=:$JAVA_HOME/jre/lib/rt.jar:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar
   export PATH=$PATH:$JAVA_HOME/bin
   
   source /etc/profile
   ```

3. 测试

   ```shell
   java -version
   ```

   

## Mycat

### 安装

1. 下载

   ```shell
   wget  http://dl.mycat.org.cn/1.6.7.6/20220524101549/Mycat-server-1.6.7.6-release-20220524173810-linux.tar.gz
   ```

2. 调试配置

   ```shell
   tar -zxvf Mycat-server-1.6.7.6-release-20220524173810-linux.tar.gz  -C /usr/local/
   cd /usr/local/mycat
   
   # 添加环境变量
   # vim /etc/profile
   export MYCAT_HOME=/usr/local/mycat
   # 与上面的环境变量呼应
   export PATH=$PATH:$JAVA_HOME/bin:$MYCAT_HOME/bin
   
   
   source /etc/profile
   ```

### 配置

1. 修改schema.xml配置文件

   ```xml
   # vim schema.xml
   <?xml version="1.0"?>
   <!DOCTYPE mycat:schema SYSTEM "schema.dtd">
   <mycat:schema xmlns:mycat="http://io.mycat/">
   
   
       <!-- 配置2个逻辑库-->
           <schema name="zz" checkSQLschema="true" sqlMaxLimit="100" dataNode="zz"></schema>
           <schema name="test" checkSQLschema="true" sqlMaxLimit="100" dataNode="test"></schema>
   
                    <!--schema name： 逻辑库名称可以任取-->
                    <!--checkSQLschema：是否校验语法，-->
                    <!--sqlMaxLimit：语法最大长度为100个字符-->
                    <!--dataNode：     真实数据节点-->
                    <!--一个schema代表映射了一个逻辑库-->
   
       <!-- 逻辑库对应的真实数据库-->
           <dataNode name="zz" dataHost="localhost" database="zx" />
           <dataNode name="test" dataHost="localhost" database="test" />
   
                    <!--dataHost： 真实主机 192.168.42.128-->
                    <!--database： 真实的库 scada -->
   
   
       <!--真实数据库所在的服务器地址，这里配置了1主1从-->
           <dataHost name="localhost" maxCon="1000" minCon="10" balance="3" writeType="0" dbType="mysql" dbDriver="native" switchType="1"  slaveThreshold="100">
                   <heartbeat>select user()</heartbeat>
                   <writeHost host="hostM1" url="192.168.223.3:3306" user="root" password="123456" >
                   <readHost host="hostS1" url="192.168.223.4:3306" user="root" password="123456" />
           </writeHost>
           </dataHost>
   
   </mycat:schema>
   ```

   ![0cfd239761d3913194fd796be72fb6c.png](https://gitee.com/fan-dongyuan/ty-gallery/raw/master/工坊图/mycat(schema.xml))

2. 修改server.xml配置文件

   ```xml
   <?xml version="1.0" encoding="UTF-8"?>
   <!DOCTYPE mycat:server SYSTEM "server.dtd">
   <mycat:server xmlns:mycat="http://io.mycat/">
           <system>
           <property name="useSqlStat">0</property>  <!-- 1为开启实时统计、0为关闭 -->
           <property name="useGlobleTableCheck">0</property>  <!-- 1为开启全加班一致性检测、0为关闭 -->
           <property name="sequnceHandlerType">2</property>
                   <property name="processorBufferPoolType">0</property>
                   <property name="handleDistributedTransactions">0</property>
                   <property name="useOffHeapForMerge">1</property>
                   <property name="memoryPageSize">1m</property>
                   <property name="spillsFileBufferSize">1k</property>
                   <property name="useStreamOutput">0</property>
                   <property name="systemReserveMemorySize">384m</property>
           </system>
           <user name="root">
                   <property name="password">123456</property>
                   <property name="schemas">zx,test</property>
           </user>
           <user name="zx">
                   <property name="password">zx123</property>
                   <property name="schemas">zx</property>
                   <property name="readOnly">true</property>
           </user>
           <user name="test">
                   <property name="password">tx123</property>
                   <property name="schemas">test</property>
                   <property name="readOnly">true</property>
           </user>
   
   </mycat:server>
   
   ```

   ![](https://gitee.com/fan-dongyuan/ty-gallery/raw/master/工坊图/mycat(server.xml).png)

3. 启动

   ```shell
   mycat start
   mycat status
   mycat restart
   ```



## 安装MySQL-client

```shell
 wget  http://dev.mysql.com/get/mysql57-community-release-el7-8.noarch.rpm
 yum localinstall mysql57-community-release-el7-8.noarch.rpm -y
 rpm --import https://repo.mysql.com/RPM-GPG-KEY-mysql-2022
 yum install mysql-community-client.x86_64 -y
```



## 测试

### 数据同步测试

1. 主库创建test和zx库

   ```shell
   # master
   mysql> create database test;
   mysql> create database zx;
   mysql> show databases;
   
   ```

2. 从库查看

   ```shell
   # slave
   mysql> show databases;
   ```

3. 在mycat登录自身数据库查看

   ```shell
   # mysql -h127.0.0.1 -uroot -p123456 -P8066 
   mysql> show databases;
   
   
   
   
   # 注意
   出现服务无法启动、端口无法开启，原因是因为内存性能不足，导致无法在请求超时的时间内完成启动导致报错并关闭服务，在wrapper.conf下设置超时时间可解决
   vim /usr/local/mycat/conf/wrapper.conf
   # 在倒数第二行插入
   wrapper.startup.timeout=300
   ```
   
   

### 读写分离测试

1. 在mycat创建一个表

   ```shell
   mysql> CREATE TABLE `student` (  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键ID',  `contact` varchar(15) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT '联系人姓名', `addressDesc` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT '收货地址明细',  `postCode` varchar(15) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT '邮编', `tel` varchar(20) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT '联系人电话',  `createdBy` bigint(20) DEFAULT NULL COMMENT '创建者', `creationDate` datetime DEFAULT NULL COMMENT '创建时间', `modifyBy` bigint(20) DEFAULT NULL COMMENT '修改者', `modifyDate` datetime DEFAULT NULL COMMENT '修改时间',  `userId` bigint(20) DEFAULT NULL COMMENT '用户ID',  PRIMARY KEY (`id`) )  ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
   
   mysql>  insert  into `student`(`id`,`contact`,`addressDesc`,`postCode`,`tel`,`createdBy`,`creationDate`,
       ->  `modifyBy`,`modifyDate`,`userId`) values 
       -> (1,'张三','郑州市','100010','13689999',1,'2016-04-13 00:00:00',NULL,NULL,1),
       -> (2,'李四','郑州市','100000','185672312',2,'2016-04-13 00:00:00',NULL,NULL,1),
       -> (3,'王五','郑州市','100021','133876742',3,'2016-04-13 00:00:00',NULL,NULL,1);
       
   mysql> flush privileges;
   ```

2. 查询表中信息

   ```shell
   mysql> select * from student;
   ```

3. 测试读写分离次数

   ```shell
   [root@mycat conf]#  mysql  -h 127.0.0.1 -P 9066 -uroot -p123456 -e 'show @@datasource'
   mysql: [Warning] Using a password on the command line interface can be insecure.
   +----------+--------+-------+---------------+------+------+--------+------+------+---------+-----------+------------+
   | DATANODE | NAME   | TYPE  | HOST          | PORT | W/R  | ACTIVE | IDLE | SIZE | EXECUTE | READ_LOAD | WRITE_LOAD |
   +----------+--------+-------+---------------+------+------+--------+------+------+---------+-----------+------------+
   | zz       | hostM1 | mysql | 192.168.223.3 | 3306 | W    |      0 |   10 | 1000 |    2702 |         0 |          4 |
   | zz       | hostS1 | mysql | 192.168.223.4 | 3306 | R    |      0 |   10 | 1000 |    2698 |         3 |          0 |
   | test     | hostM1 | mysql | 192.168.223.3 | 3306 | W    |      0 |   10 | 1000 |    2702 |         0 |          4 |
   | test     | hostS1 | mysql | 192.168.223.4 | 3306 | R    |      0 |   10 | 1000 |    2698 |         3 |          0 |
   +----------+--------+-------+---------------+------+------+--------+------+------+---------+-----------+------------+
   [root@mycat conf]#  mysql  -h 127.0.0.1 -P 9066 -uroot -p123456 -e 'show @@datasource'
   mysql: [Warning] Using a password on the command line interface can be insecure.
   +----------+--------+-------+---------------+------+------+--------+------+------+---------+-----------+------------+
   | DATANODE | NAME   | TYPE  | HOST          | PORT | W/R  | ACTIVE | IDLE | SIZE | EXECUTE | READ_LOAD | WRITE_LOAD |
   +----------+--------+-------+---------------+------+------+--------+------+------+---------+-----------+------------+
   | zz       | hostM1 | mysql | 192.168.223.3 | 3306 | W    |      0 |   10 | 1000 |    2705 |         0 |          4 |
   | zz       | hostS1 | mysql | 192.168.223.4 | 3306 | R    |      0 |   10 | 1000 |    2701 |         3 |          0 |
   | test     | hostM1 | mysql | 192.168.223.3 | 3306 | W    |      0 |   10 | 1000 |    2705 |         0 |          4 |
   | test     | hostS1 | mysql | 192.168.223.4 | 3306 | R    |      0 |   10 | 1000 |    2701 |         3 |          0 |
   +----------+--------+-------+---------------+------+------+--------+------+------+---------+-----------+------------+
   
   ```

   



# Mycat高可用

## 简介

高可用主要是通过keepalived来进行高可用，当第一台mycat宕机时，第二胎及时补上并配置读写分离

## 环境

| 角色名 |       ip        |
| :----: | :-------------: |
| mycat1 |  192.168.223.5  |
| mycat2 |  192.168.223.6  |
| mysql1 |  192.168.223.3  |
| mysql2 |  192.168.223.4  |
|  VIP   | 192.168.223.200 |



## keepalived

### 安装

1. 在mycat上安装keepalived

   ```shell
   # mycat1
   yum install -y keepalived
   cp  /etc/keepalived/keepalived.conf   /etc/keepalived/keeplived.conf.bak
   # mycat2
   yum install -y keepalived
   cp  /etc/keepalived/keepalived.conf   /etc/keepalived/keeplived.conf.bak
   ```

2. 清空配置文件

   ```shell
   # mycat1
   > /etc/keepalived/keealived.conf
   # mycat2
   > /etc/keepalived/keealived.conf
   
   ```

### 配置

1. 配置主配置文件

   ```shell
   # vim /etc/keepalived/keepalived.conf
   ! Configuration File for keepalived
   global_defs {
           # keepalived 自带的邮件提醒需要开启 sendmail 服务。 建议用独立的监控或第三方 SMTP
           router_id pc3                           # 标识本节点的字条串，通常为 hostname
           script_user root
           enable_script_security
   }
   # keepalived 会定时执行脚本并对脚本执行的结果进行分析，动态调整 vrrp_instance 的优先级。如果脚本执行结果为 0，并且 weight 配置的值大于 0，则优先级相应的增加>。如果脚本>执行>结果非 0，并且 weight配置的值小于 0，则优先级相应的减少。其他情况，维持原本配置的优先级，即配置文件中 priority 对应的值。
   vrrp_script chk_mycat {
           script "/etc/keepalived/mycat_check.sh"   # 检测 mycat 状态的脚本路径
           interval 2                              # 检测时间间隔
           #weight -20                              # 如果条件成立，权重-20
           #fall 3                                  #检测几次失败才为失败，整数
           #rise 2                                  #检测几次状态为正常的，才确认正常，整数
   }
   # 定义虚拟路由， VI_1 为虚拟路由的标示符，自己定义名称
   vrrp_instance VI_1 {
           state MASTER                            # 主节点为 MASTER， 对应的备份节点为 BACKUP
           interface ens33                         # 绑定虚拟 IP 的网络接口，与本机 IP 地址所在的网络接口相同， 我的是 eth0
           virtual_router_id 88                    # 虚拟路由的 ID 号， 两个节点设置必须一样， 可选 IP 最后一段使用, 相同的 VRID 为一个组，他将决定多播的 MAC 地址
           mcast_src_ip 192.168.223.5                  # 本机 IP 地址
           priority 100                            # 节点优先级， 值范围 0-254， MASTER 要比 BACKUP 高
           #nopreempt                               # 优先级高的设置 nopreempt 解决异常恢复后再次抢占的问题
           advert_int 1                            # 组播信息发送间隔，两个节点设置必须一样， 默认 1s
           # 设置验证信息，两个节点必须一致
           authentication {
                   auth_type PASS
                   auth_pass 123456              # 真实生产，按需求对应该过来
           }
           # 虚拟 IP 池, 两个节点设置必须一样
           virtual_ipaddress {
                   192.168.223.200                       # 虚拟 ip，可以定义多个
           }
           # 将 track_script 块加入 instance 配置块
           track_script {
                   chk_mycat                       # 执行 mycat 监控的服务
           }
   }
   
   ```

2. 配置备配置文件

   ```shell
   # vim /etc/keepalived/keepalived.conf
   ! Configuration File for keepalived
   global_defs {
           # keepalived 自带的邮件提醒需要开启 sendmail 服务。 建议用独立的监控或第三方 SMTP
           router_id pc4                           # 标识本节点的字条串，通常为 hostname
           script_user root
   
   }
   # keepalived 会定时执行脚本并对脚本执行的结果进行分析，动态调整 vrrp_instance 的优先级。如果脚本执行结果为 0，并且 weight 配置的值大于 0，则优先级相应的增加>。如果脚本>执行>结果非 0，并且 weight配置的值小于 0，则优先级相应的减少。其他情况，维持原本配置的优先级，即配置文件中 priority 对应的值。
   vrrp_script chk_mycat {
           script "/etc/keepalived/mycat_check.sh"   # 检测 mycat 状态的脚本路径
           interval 2                              # 检测时间间隔
           #weight -20                              # 如果条件成立，权重-20
           #fall 3                                  #检测几次失败才为失败，整数
           #rise 2                                  #检测几次状态为正常的，才确认正常，整数
   }
   # 定义虚拟路由， VI_1 为虚拟路由的标示符，自己定义名称
   vrrp_instance VI_1 {
           state BACKUP                            # 主节点为 MASTER， 对应的备份节点为 BACKUP
           interface ens33                         # 绑定虚拟 IP 的网络接口，与本机 IP 地址所在的网络接口相同， 我的是 eth0
           virtual_router_id 88                    # 虚拟路由的 ID 号， 两个节点设置必须一样， 可选 IP 最后一段使用, 相同的 VRID 为一个组，他将决定多播的 MAC 地址
           mcast_src_ip 192.168.223.6                  # 本机 IP 地址
           priority 99                            # 节点优先级， 值范围 0-254， MASTER 要比 BACKUP 高
           #nopreempt                               # 优先级高的设置 nopreempt 解决异常恢复后再次抢占的问题
           advert_int 1                            # 组播信息发送间隔，两个节点设置必须一样， 默认 1s
           # 设置验证信息，两个节点必须一致
           authentication {
                   auth_type PASS
                   auth_pass 123456              # 真实生产，按需求对应该过来
           }
           # 虚拟 IP 池, 两个节点设置必须一样
           virtual_ipaddress {
                   192.168.223.200                       # 虚拟 ip，可以定义多个
           }
           # 将 track_script 块加入 instance 配置块
           track_script {
                   chk_mycat                       # 执行 mycat 监控的服务
           }
   }
   
   ```

3. 配置mycat监控脚本

   ```shell
   # vim /etc/keepalived/mycat_check.sh
   #!/bin/bash
     #时间变量，用于记录日志
   d=`date --date today +%Y%m%d_%H:%M:%S`
   #计算nginx进程数量  
     n=`/usr/local/mycat/bin/mycat status |grep 'Mycat-server is running'| wc -l`
   #如果进程为0，则启动mycat，并且再次检测mycat进程数量    
     if [ $n -eq "0" ]; then
             /usr/local/mycat/bin/mycat start
             n2=`/usr/local/mycat/bin/mycat status |grep 'Mycat-server is running'| wc -l`
   #如果还为0，说明mycat无法启动，此时需要关闭keepalived
             if [ $n2 -eq "0"  ]; then
                     systemctl stop keepalived
             fi
    fi
   ```

4. 启动keepalived和mycat服务

   ```sh
   # mycat1
   systemctl start keepalived
   mycat start
   
   # mycat2
   systemctl start keepalived
   mycat start
   
   
   # 查看服务状态
   systemctl status keepalived
   mycat status
   ```

   



## 测试

### mycat测试宕机自启

1. 关闭主中间件mycat服务

   ```sh
   mycat stop
   ```

2. 查看服务是否自启成功

   ```sh
   mycat status
   Mycat-server is running (116270).
   ```

   

### keepalived测试VIP转移

1. 关闭主中间件的keepalived服务

   ```sh
   systemctl stop keepalived
   ```

2. 在备中间件查看vip

   ```sh
   # ip ad
   1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
       link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
       inet 127.0.0.1/8 scope host lo
          valid_lft forever preferred_lft forever
       inet6 ::1/128 scope host 
          valid_lft forever preferred_lft forever
   2: ens33: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
       link/ether 00:0c:29:e5:54:2c brd ff:ff:ff:ff:ff:ff
       inet 192.168.223.6/24 brd 192.168.223.255 scope global ens33
          valid_lft forever preferred_lft forever
       inet 192.168.223.200/32 scope global ens33
          valid_lft forever preferred_lft forever
       inet6 fe80::20c:29ff:fee5:542c/64 scope link 
          valid_lft forever preferred_lft forever
   
   ```

3. 重新开启主中间件服务并查看vip是否转移

   ```sh
   systemctl start keepalived
   
   
   
   # ip ad
   1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
       link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
       inet 127.0.0.1/8 scope host lo
          valid_lft forever preferred_lft forever
       inet6 ::1/128 scope host 
          valid_lft forever preferred_lft forever
   2: ens33: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
       link/ether 00:0c:29:f6:d8:e3 brd ff:ff:ff:ff:ff:ff
       inet 192.168.223.5/24 brd 192.168.223.255 scope global ens33
          valid_lft forever preferred_lft forever
       inet 192.168.223.200/32 scope global ens33
          valid_lft forever preferred_lft forever
       inet6 fe80::20c:29ff:fef6:d8e3/64 scope link 
          valid_lft forever preferred_lft forever
   ```

   



# Mycat负载均衡

## 简介

主要实现mycat的负载均衡，避免其在一个mycat处理的请求过多

## 环境

|          角色名           |       ip        |
| :-----------------------: | :-------------: |
| mycat1、keepalived1、lvs1 |  192.168.223.5  |
| mycat2、keepalived2、lvs2 |  192.168.223.6  |
|          mysql1           |  192.168.223.3  |
|          mysql2           |  192.168.223.4  |
|            VIP            | 192.168.223.200 |



## LVS

### 安装

1. 下载

   ```sh
   yum install -y ipvsadm
   ```

### 配置

1. 修改主配置文件

   ```sh
   # vim /etc/keepalived/keepalived.conf
   router_id lvs1       # 为本机取一个唯一的id
       vrrp_iptables        # 自动开启iptables放行规则
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
            192.168.223.200 # vip地址，与web服务器的vip一致
        }
    }
   # 以下为keepalived配置lvs的规则  WEB服务器池配置
    virtual_server 192.168.223.200 8066 {   # 声明虚拟服务器地址
        delay_loop 6     # 健康检查延迟6秒开始
       lb_algo rr      # 调度算法为wrr
        lb_kind DR       # 工作模式为DR
      #  persistence_timeout 0  # 0秒内相同客户端调度到相同服务器
        protocol TCP     # 协议是TCP
   
        real_server 192.168.223.5 8066 {   # 声明真实服务器
            weight 1          # 权重
            TCP_CHECK {       # 通过TCP协议对真实服务器做健康检查
                connect_timeout 3 # 连接超时时间为3秒
                nb_get_retry 3    # 3次访问失败则认为真实服务器故障
                delay_before_retry 3  # 两次检查时间的间隔3秒
            }
        }
        real_server 192.168.223.6 8066 {
            weight  1
            TCP_CHECK {
                connect_timeout 3
                nb_get_retry 3
                delay_before_retry 3
            }
        }
    }
   
   ```

2. 修改备配置文件

   ```
   router_id lvs2       # 为本机取一个唯一的id
       vrrp_iptables        # 自动开启iptables放行规则
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
            192.168.223.200 # vip地址，与web服务器的vip一致
        }
    }
   # 以下为keepalived配置lvs的规则  WEB服务器池配置
    virtual_server 192.168.223.200 8066 {   # 声明虚拟服务器地址
        delay_loop 6     # 健康检查延迟6秒开始
       lb_algo rr      # 调度算法为wrr
        lb_kind DR       # 工作模式为DR
      #  persistence_timeout 0  # 0秒内相同客户端调度到相同服务器
        protocol TCP     # 协议是TCP
   
        real_server 192.168.223.5 8066 {   # 声明真实服务器
            weight 1          # 权重
            TCP_CHECK {       # 通过TCP协议对真实服务器做健康检查
                connect_timeout 3 # 连接超时时间为3秒
                nb_get_retry 3    # 3次访问失败则认为真实服务器故障
                delay_before_retry 3  # 两次检查时间的间隔3秒
            }
        }
        real_server 192.168.223.6 8066 {
            weight  1
            TCP_CHECK {
                connect_timeout 3
                nb_get_retry 3
                delay_before_retry 3
            }
        }
    }
   ```

3. 在主备上编写DR初始化脚本

   ```sh
   # vim dr_init.sh
   #!/bin/bash
   #Desc: LVS_DR Real Server in the lo configuration VIP
   # 需要修改虚拟ip的地址
   vip=192.168.223.200
   mask='255.255.255.255'
   
   case $1 in
   start)
           echo 1 > /proc/sys/net/ipv4/conf/all/arp_ignore
           echo 1 > /proc/sys/net/ipv4/conf/lo/arp_ignore
           echo 2 > /proc/sys/net/ipv4/conf/all/arp_announce
           echo 2 > /proc/sys/net/ipv4/conf/lo/arp_announce
   
           ifconfig lo:0 $vip netmask $mask broadcast $vip up
           route add -host $vip dev lo:0
           ;;
   stop)
           ifconfig lo:0 down
   
           echo 0 > /proc/sys/net/ipv4/conf/all/arp_ignore
           echo 0 > /proc/sys/net/ipv4/conf/lo/arp_ignore
           echo 0 > /proc/sys/net/ipv4/conf/all/arp_announce
           echo 0 > /proc/sys/net/ipv4/conf/lo/arp_announce
   
           ;;
   *)
           echo "Usage $(basename $0) start|stop"
           exit 1
           ;;
   esac
   
   
   exit 0
   
   
   
   ```

4. 执行DR初始化脚本

   ```
   # 修改内核参数
   sh -x dr_init.sh start
   # 恢复内核参数
   ```

5. 启动所有服务

   ```sh
   # lvs1
   systemctl start keepalived
   mycat start
   # lvs2
   systemctl start keepalived
   mycat start
   
   
   # 启动mycat请等待一分钟
   ```

   



## 测试

### lvs映射测试

1. 查看映射关系

   ```sh
   ipvsadm -Ln
   ```

   

### lvs调度测试

1. 使用测试机访问调度器vip

   ```sh
   mysql -h192.168.223.200 -P8066 -uroot -p123456  -e 'select @@hostname'
   
   
   # 注意
   请输入四次进行测试
   ```

2. 查看mycat访问次数

   ```sh
   # ipvsadm -Ln
   IP Virtual Server version 1.2.1 (size=4096)
   Prot LocalAddress:Port Scheduler Flags
     -> RemoteAddress:Port           Forward Weight ActiveConn InActConn
   TCP  192.168.223.200:8066 rr
     -> 192.168.223.5:8066           Route   1      0          3         
     -> 192.168.223.6:8066           Route   1      0          3
   ```

   
