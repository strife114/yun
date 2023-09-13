# 配置镜像加速器

```
# vim /etc/docker/daemon.json
# 注意格式
{
 "registry-mirrors": ["https://b9pmyelo.mirror.aliyuncs.com"]
}

systemctl restart docker
docker info
```






# 常用镜像管理命令

```
# docker相关配置信息
docker info  


# 构建镜像
docker build

# 查看镜像历史
docker history

# 显示一个或多个镜像详细信息
docker inspect

# 从镜像仓库拉取镜像
docker pull

# 推送一个镜像到镜像仓库
docker push  

# 上传镜像必须保证这个镜像的名称前缀根仓库名称一致
# 比如要上传镜像到library库，就保证镜像名称为ip地址/library/镜像名
docker push 192.168.200.14/library/镜像名

# 删除一个或多个镜像
docker rmi

# 移除没有被标记或者没有被任何容器引用的镜像
docker prune
docker prune -a  移除所有没有被引用的镜像
# 创建一个引用镜像标记目标镜像
docker tag
docker tag ubuntu:15.10 runoob/ubuntu:v3
# 保存一个或多个镜像到一个tar归档文件
docker save 镜像名 -o 归档包名

# 加载镜像来自tar归档或标准输入
docker load -i 归档包

# 查看docker进程（查看正在运行的容器）
docker ps -a -q
-a 查看所有容器
-q 查看所有容器id
```



# 创建容器常用选项

```
docker run [可选参数] 镜像名:版本 []
选项：
--name  给容器取一个名字
-p      将容器端口映射到宿主机
-e      声明环境变量
-v      绑定挂载卷
-h      指定主机名
--ip    指定容器ip（自定义网络）
-d      后台运行容器，并返回容器ID；
-i      以交互模式运行容器，通常与 -t（伪终端） 同时使用；
--restart=always/on-failure  docker重启时是否自动拉起容器
docker run --name some-nginx -d -p 8080:80 nginx:1.22
默认情况下，容器无法通过外部网络访问。
需要使用-p参数将容器的端口映射到宿主机端口（宿主机运行端口在前，容器端口主机在后），才可以通过宿主机IP进行访问。
浏览器打开 http://ip:8080

# 因为纯净的操作系统没有主进程，可以通过it的伪终端进程，挂住容器
docker run -d centos       崩溃
docker run -it -d centos   启动

# 如果一个容器已经启动，可以使用docker exec在运行的容器中执行命令，一般配合it参数使用交互模式
docker exec -it some-mysql /bin/bash

# 性能限制
-m               多少内存
-memory-swap     允许交换到磁盘的内存量
-memory-swappiness=<0-100>  容器使用swap分区交换的百分比。默认1
--cpus           多少核
-cpuset-cpus     限制容器使用特定的cpu核心
-cpu-shares      cpu共享
```

# 容器管理命令

```
# 列出容器
docker ls

# 查看一个或多个容器详细信息
docker inspect

# 创建一个新镜像来自一个容器
docker commit 容器名 新镜像名

# 拷贝一个文件/文件夹到一个容器
docker cp 宿主机文件/目录  容器名:路径
docker cp aa.json web:/

# 查看简要端口映射
docker port 容器名

# 查看进程id
docker top 容器名

# 查看容器资源利用率
docker stats 容器名

# 启动、停止、重启、删除容器
docker start/stop/restart/rm  容器名

# 移除已停止的容器
docker prune
```



# 数据持久化（数据挂载）

Docker提供两种方式将数据从宿主机挂载到容器中：

1. columes：docker管理宿主机文件系统的一部分
2. bind mounts：将宿主机上的任意的文件或目录挂载到容器中

```
docker run -it -d --name web -v /opt/wwwroot nginx 
```



# Dockfile构建镜像

`docker build`命令用于从Dockerfile构建镜像

```shell
docker build  -t ImageName:TagName dir

-t          给镜像加一个Tag
ImageName   给镜像起的名称
TagName     给镜像的Tag名
Dir         Dockerfile所在目录
```



1. **FROM  镜像**	指定新镜像所基于的镜像，第一条指令必须为FROM指令，每创建一个镜像就需要一条FROM指令
2. **MAINTAINER  名字**	说明新镜像的维护人信息
3. **RUN 命令**	相当于在容器中执行命令
4. **CMD[“要运行的程序”，“参数1”，“参数2”]**	指令启动容器时要运行的命令或脚本，Dockerfile只能有一条CMD指令，如果要指定多条则只能最后一条执行
5. **EXPOSE 端口号**	指定新镜像加载到Docker时要开启端口
6. **ENV 环境变量 变量值**	设置一个环境变量的值，会被后面的RUN使用
7. **ADD** 源文件/目录 目标文件/目录	功能和用法与COPY指令基本相同，不同在于使用ADD指令拷贝时，**如果拷贝的是压缩文件，拷贝到容器中时会自动解压为目录**
8. COPY 源文件/目录 目标文件/目录	用于拷贝宿主机的源目录/文件到容器内的某个目录。接受两个参数，源目录路径和容器内目录路径。
9. **VOLUME[“目录”]**	在容器中创建一个挂载点，用于让你的容器访问宿主机上的目录。一般用来存放数据库和需要保持的数据等
10. **USER 用户名/UID**	指定运行容器时的用户
11. **WORKDIR 路径**	为后续的RUN、CMD、ENTRYPOINT指定工作目录
12. ONBUILD命令	指定所生成的镜像作为一个基础镜像时所要运行的命令
13. HEALTHCHECK	健康检查

14. USER   用于设置运行容器的UID

15. ENTRYPOINT  指定这个容器启动的时候要运行的命令，可以追加命令，与cmd的区别就是创建容器的参数不能被指定

## 构建基础centos

```
FROM centos
MAINTAINER cool
ENV MYPATH /usr/local
WORKDIR $MYPATH
RUN yum -y install vim && yum -y install net-tools
EXPOSE 80
CMD echo $MYPATH
CMD echo "successs------ok"
CMD /bin/bash
```





## 构建redis

```
FROM centos:centos7.5.1804
MAINTAINER redis
RUN rm -rf /etc/yum.repos.d/*
ADD mall-repo /opt/mall-repo
ADD local.repo /etc/yum.repos.d/
RUN yum clean all
RUN yum -y install redis
RUN sed -i -e 's/bind 127.0.0.1/bind 0.0.0.0/g' /etc/redis.conf
RUN sed -i -e 's/protected-mode yes/protected-mode no/g' /etc/redis.conf
EXPOSE 6379
ENTRYPOINT ["redis-server","/etc/redis.conf"]
                                      




# 指定基于镜像和选定创建者
# 配置yum源
# 安装redis
# 开放端口
# 修改绑定ip地址
RUN sed -i -e 's@bind 127.0.0.1@bind 0.0.0.0@g' /etc/redis.conf
# 关闭保护模式
RUN sed -i -e 's@protected-mode yes@protected-mode no@g' /etc/redis.conf
# 启动
ENTRYPOINT ["/usr/bin/redis-server","/etc/redis.conf"]
entrypoint
```

## 构建mariadb

### 1

db_init.sh

```
#!/bin/bash
mysql_install_db --user=mysql
sleep 3
mysqld_safe &
sleep 3
mysql -e "grant all on *.* to root@'%' identified by '123456';"



```

Dockerfile

```
FROM centos:centos7.5.1804
MAINTAINER FDY
RUN yum clean all
RUN yum list
RUN yum install mariadb-server -y
ADD db_init.sh /root/
RUN chmod +x /root/db_init.sh && bash /root/db_init.sh
EXPOSE 3306
CMD ["mysqld_safe"]

# yum源有问题，无法解决，只能使用自带的yum源下载安装
```



### chinaskillmall

db_init.sh

```
#!/bin/bash
mysql_install_db --user=root
sleep 3
mysqld_safe --user=root &
sleep 3
mysqladmin -u "$MARIADB_USER" password "$MARIADB_PASS"
mysql -uroot -p123456 -e "use mysql; grant all privileges on *.* to '$MARIADB_USER'@'%' identified by '$MARIADB_PASS' with grant option;"
mysql -uroot -p123456 -e "use mysql; source /root/mall.sql;"

# 编写初始化脚本
# 指定数据库以哪个用户运行
# 启动数据库
# 设置用户和密码
# 以命令交互式执行数据库命令
  进入数据库，
  修改密码
  使用mall.sql恢复数据
  
  
  


```

Dockerfile-mariadb

```
FROM centos:centos7.5.1804
MAINTAINER mariadb
RUN rm -rf /etc/yum.repos.d/*
ADD local.repo /etc/yum.repos.d/
ADD mall-repo /opt/mall-repo
ADD mall.sql  /root/
ENV MARIADB_USER root
ENV MARIADB_PASS 123456

ENV LC_ALL en_US.UTF8
ADD db_init.sh /root/
RUN chmod 755 /root/db_init.sh
RUN yum install -y mariadb-server
RUN sh -x /root/db_init.sh
EXPOSE 3306
CMD ["mysqld_safe","--user=root"]               




# 指定基本镜像源和创建者
# 上传mall镜像源
# 配置yum源
# 安装mariadb
# 上传db_init.sh
# 赋权db_init.sh
# 执行初始化脚本
# 指定编码格式
# 指定端口
# 开启执行mysqld_safe
# 设置自启
```

local.repo

```
[mall]
name=mall
baseurl=file:///opt/mall-repo
gpgcheck=0
enabled=1

```

### mall-admin

db_init.sh

```
#!/bin/bash
mysql_install_db --user=root
mysqld_safe --user=root &
sleep 8
mysqladmin -u root password 'root'
mysql -uroot -proot -e "grant all on *.* to 'reader'@'%' identified by '123456'; flush privileges;"
mysql -uroot -proot -e "create database mall; use mall; source /opt/mall.sql;"
```

Dockerfile-mariadb

```
FROM centos:centos7.5.1804
MAINTAINER mysql
RUN rm -rf /etc/yum.repos.d/*
COPY local.repo /etc/yum.repos.d/
COPY mall-repo /opt/mall-repo
COPY mall.sql /opt/
COPY db_init.sh /opt/
ENV LC_ALL en_US.UTF-8
RUN yum -y install mariadb-server && bash /opt/db_init.sh
EXPOSE 3306
CMD ["mysqld_safe","--user=root"]

```



## 构建mysql

db_init.sh

```
#!/bin/bash
sed -i '$a\skip-grant-tables' /etc/my.cnf
systemctl restart  mysqld
mysql -uroot -e "update mysql.user set authentication_string=password('3edc#EDC') where user='root' and Host = 'localhost';flush privileges;\q"
sed -i '$d' /etc/my.cnf
systemctl restart  mysqld
mysqladmin -uroot -p'3edc#EDC' password '3edc#EDC'
mysql -uroot -p'3edc#EDC' -e "grant all privileges on *.* to 'root'@'%' identified by '3edc#EDC' with grant option;flush privileges;\q"
```



## 构建nacos镜像

### 简介

1. Nacos 帮助您更敏捷和容易地构建、交付和管理微服务平台。 Nacos 是构建以“服务”为中心的现代应用架构 (例如微服务范式、云原生范式) 的服务基础设施。
2. Nacos 提供对服务的实时的健康检查，阻止向不健康的主机或服务实例发送请求
3. 动态配置服务可以让您以中心化、外部化和动态化的方式管理所有环境的应用配置和服务配置
4. 动态 DNS 服务支持权重路由，让您更容易地实现中间层负载均衡、更灵活的路由策略、流量控制以及数据中心内网的简单DNS解析服务



Dockerfile-nacos

```
FROM centos:centos7.5.1804
MAINTAINER nacos

COPY local.repo /etc/yum.repos.d/
COPY mall-repo /opt/mall-repo
COPY nacos-start.sh /opt

ADD jdk-8u121-linux-x64.tar.gz /usr/local/bin
ADD nacos-server-1.1.0.tar.gz /usr/local/bin
ENV JAVA_HOME /usr/local/bin/jdk1.8.0_121

EXPOSE 8848
CMD ["/bin/bash","/opt/nacos-start.sh"]

```

nacos-start.sh

```
#!/bin/bash
/usr/local/bin/nacos/bin/startup.sh -m standalone
tail -f /usr/local/bin/nacos/logs/start.out
```



## 构建rabbitmq镜像

### 简介

1. RabbitMQ是一个由[erlang](https://so.csdn.net/so/search?q=erlang&spm=1001.2101.3001.7020)开发的AMQP（Advanced Message Queue 高级消息队列协议 ）的开源实现，能够实现异步消息处理
2. RabbitMQ是一个消息代理：它接受和转发消息

Dockerfile-rabbitmq

```
FROM centos:centos7.5.1804
MAINTAINER rabbitmq
RUN rm -rf /etc/yum.repos.d/*
COPY local.repo /etc/yum.repos.d/
COPY rabbitmq-user.sh /opt/rabbitmq-user.sh
COPY mall-repo /opt/mall-repo

RUN yum -y install rabbitmq-server

EXPOSE 5672 15672
CMD ["/bin/bash","/opt/rabbitmq-user.sh"]

```

rabbitmq-user.sh

```
#!/bin/bash
/usr/lib/rabbitmq/bin/rabbitmq-server restart
sleep 8
/usr/lib/rabbitmq/bin/rabbitmqctl add_vhost mall
/usr/lib/rabbitmq/bin/rabbitmqctl add_user mall mall
/usr/lib/rabbitmq/bin/rabbitmqctl set_user_tags mall administrator
/usr/lib/rabbitmq/bin/rabbitmqctl set_permissions -p mall mall '.*' '.*' '.*'
/usr/lib/rabbitmq/bin/rabbitmq-plugins enable rabbitmq_management
/usr/lib/rabbitmq/bin/rabbitmq-server restart
```



## 构建Piq镜像

启动脚本

```
#!/bin/bash
sleep 60
nohup java -jar /root/pig-register.jar  $JAVA_OPTS  >/dev/null 2>&1 &
sleep 60
nohup java -jar /root/pig-gateway.jar  $JAVA_OPTS >/dev/null 2>&1 &
sleep 20
nohup java -jar /root/pig-auth.jar  $JAVA_OPTS >/dev/null 2>&1 &
sleep 20
nohup java -jar /root/pig-upms-biz.jar  $JAVA_OPTS >/dev/null 2>&1 &
sleep 20
```

Dockerfile-Pig

```
FROM centos:centos7.5.1804
MAINTAINER Chinaskills
COPY service /root
ADD yum /root/yum
RUN rm -rfv /etc/yum.repos.d/*
COPY local.repo /etc/yum.repos.d/local.repo
RUN yum install -y java-1.8.0-openjdk java-1.8.0-openjdk-devel
COPY pig-start.sh /root
RUN chmod +x /root/pig-start.sh
EXPOSE 8848 9999 3000 4000
CMD ["/bin/bash","/root/pig-start.sh"]
```



## 构建nginx镜像

### 生成前端文件

```
[root@master mall-swarm]# tar -zxvf mall-admin-web.tar.gz
[root@master mall-swarm]# cd mall-admin-web
[root@master mall-admin-web]# vi config/prod.env.js
'use strict'
module.exports = {
  NODE_ENV: '"production"',
  BASE_API: '"http://10.24.2.156:8201/mall-admin"'  #修改为本机IP
}


```

### 生成dist目录

```
[root@masster mall-admin-web]# cd ../
[root@ mall-swarm]# tar zxvf node-v6.17.1-linux-x64.tar.gz
[root@ mall-swarm]# mv node-v6.17.1-linux-x64 /usr/local/node
# vim /etc/profile
export NODE_HOME=/usr/local/node
export PATH=$NODE_HOME/bin:$PATH
[root@ mall-swarm]# source /etc/profile
[root@ mall-swarm]# node -v
v6.17.1
[root@ mall-swarm]# npm -v
3.10.10
[root@ mall-swarm]# cd mall-admin-web
[root@master mall-admin-web]# npm run build
[root@master mall-admin-web]# mv dist/ ../
[root@master mall-admin-web]# cd ../

```

### Dockerfile-nginx

```
# 负载均衡项目
FROM centos:centos7.5.1804
MAINTAINER nginx
RUN rm -rf /etc/yum.repos.d/*
ADD local.repo /etc/yum.repos.d/
ADD mall-repo /opt/mall-repo
ADD *.jar /root/
ADD setup.sh /root/
RUN yum install -y nginx java-1.8.0-openjdk java-1.8.0-openjdk-devel \
 && sed -i '1a location /shopping { proxy_pass http://127.0.0.1:8081;}' /etc/nginx/conf.d/default.conf \
 && sed -i '2a location /usr { proxy_pass http://127.0.0.1:8082;}' /etc/nginx/conf.d/default.conf \
 && sed -i '3a location /cashier { proxy_pass http://127.0.0.1:8083;}' /etc/nginx/conf.d/default.conf \
 && chmod +x /root/setup.sh
 && rm -rf /usr/share/nginx/html/*
EXPOSE 80 8081 8082 8083
ADD dist/* /usr/share/nginx/html/
CMD ["nginx","-g","daemon off;"]



# mall-admin项目
FROM centos:centos7.5.1804
MAINTAINER nginxfdy
RUN rm -rf /etc/yum.repos.d/*
ADD local.repo /etc/yum.repos.d/
ADD mall-repo /opt/mall-repo
RUN yum clean all
RUN yum install -y nginx
ADD dist/ /usr/share/nginx/html/
EXPOSE 80
 CMD ["nginx","-g","daemon off;"]
```

### set.up

```
#!/bin/bash
nohup java -jar /root/shopping-provider-0.0.1-SNAPSHOT.jar &
sleep 5
nohup java -jar /root/user-provider-0.0.1-SNAPSHOT.jar &
sleep 5
nohup java -jar /root/gpmall-shopping-0.0.1-SNAPSHOT.jar &
sleep 5
nohup java -jar /root/gpmall-user-0.0.1-SNAPSHOT.jar &
sleep 5
```

### local.repo

```
[mall]
name=mall
baseurl=file:///opt/mall-repo
gpgcheck=0
enabled=1
```





## 构建zookeeper镜像

### 简介

1. ZooKeeper主要**服务于分布式系统**，可以用ZooKeeper来做：统一配置管理、统一命名服务、分布式锁、集群管理。



local1.repo

```
[mall]
name=mall
baseurl=file:///opt/gpmall
gpgcheck=0
enabled=1
[local]
name=local
baseurl=file:///opt/mall-repo
gpgcheck=0
enabled=1
       
```

Dockerfile-zookeeper

```
# vim Dockerfile-zookeeper
FROM centos:centos7.5.1804
MAINTAINER Chinaskill

# 配置yum源
ADD gpmall.tar /opt
RUN rm -rfv /etc/yum.repos.d/*
ADD local.repo /etc/yum.repos.d/
ADD mall-repo /opt/mall-repo

# 安装JDK
RUN yum install -y java-1.8.0-openjdk java-1.8.0-openjdk-devel

ENV work_path /usr/local

WORKDIR $work_path

# 安装ZooKeeper
ADD zookeeper-3.4.14.tar.gz /usr/local
ENV ZOOKEEPER_HOME /usr/local/zookeeper-3.4.14

# PATH
ENV PATH $PATH:$JAVA_HOME/bin:$JRE_HOME/bin:$ZOOKEEPER_HOME/bin
RUN cp $ZOOKEEPER_HOME/conf/zoo_sample.cfg $ZOOKEEPER_HOME/conf/zoo.cfg

EXPOSE 2181

# 设置开机自启
CMD $ZOOKEEPER_HOME/bin/zkServer.sh start-foreground

```


## 构建kafka镜像

### 简介

1. Kafka 是一种分布式的，基于发布 / 订阅的消息系统



Dockerfile-kafaka

```
FROM centos:centos7.5.1804
MAINTAINER mall-kafka

RUN rm -rf /etc/yum.repos.d/*
ADD local1.repo /etc/yum.repos.d/
ADD gpmall.tar /opt/
ADD mall-repo /opt/mall-repo

ADD kafka_2.11-1.1.1.tgz /usr/local/
ADD zookeeper-3.4.14.tar.gz /usr/local/
RUN yum install -y java java-devel  java-1.8.0-openjdk  java-1.8.0-openjdk-devel
RUN mv /usr/local/zookeeper-3.4.14/conf/zoo_sample.cfg /usr/local/zookeeper-3.4.14/conf/zoo.cfg
EXPOSE 9092

CMD ["sh","-c","/usr/local/zookeeper-3.4.14/bin/zkServer.sh start && /usr/local/kafka_2.11-1.1.1/bin/kafka-server-start.sh /usr/local/kafka_2.11-1.1.1/config/server.properties" ]
       
```



# 编排部署

## 导入镜像

```
[root@master mall-swarm]# docker load -i images/mall_mall-admin_1.0-SNAPSHOT.tar 
[root@master mall-swarm]# docker load -i images/mall_mall-auth_1.0-SNAPSHOT.tar 
[root@master mall-swarm]# docker load -i images/mall_mall-gateway_1.0-SNAPSHOT.tar
```

## docker-compose.yaml

```yaml
version: '3'
services:
  mysql.mall:
    image: chinaskill-mariadb:v1.1
    container_name: mall-mariadb
    restart: always
    ports:
      - "3306:3306"
  redis.mall:
    image: chinaskill-redis:v1.1
    container_name: mall-redis
    restart: always
    ports:
      - "6379:6379"
  zookeeper.mall:
    image: chinaskill-zookeeper:v1.1
    container_name: mall-zookeeper
    restart: always
    ports:
      - "2128:2128"
  kafka.mall:
    image: chinaskill-kafka:v1.1
    container_name: mall-kafka
    restart: always
    ports:
      - "9092:9092"
  mall:
    image: chinaskill-nginx:v1.1
    container_name: mall-nginx
    restart: always
    ports:
      - "81:80"
      - "1443:443"
    depends_on:
      - mysql.mall
      - redis.mall
      - zookeeper.mall
      - kafka.mall


```





## 补充

```yaml
version: '3'
services:
  mysql.mall:
    image: chinaskill-mariadb:v1.1
    container_name: mall-mariadb
    restart: always
    ports:
      - "3306:3306"
  redis.mall:
    image: chinaskill-redis:v1.1
    container_name: mall-redis
    restart: always
    ports:
      - "6379:6379"
  zookeeper.mall:
    image: chinaskill-zookeeper:v1.1
    container_name: mall-zookeeper
    restart: always
    ports:
      - "2128:2128"
  nacos.mall:
    image: chinaskill-nacos:v1.1
    container_name: mall-nacos
    restart: always
    ports:
      - "8848:8848"
  kafka.mall:
    image: chinaskill-kafka:v1.1
    container_name: mall-kafka
    restart: always
    ports:
      - "9092:9092"
  mall:
    image: chinaskill-nginx:v1.1
    container_name: mall-nginx
    restart: always
    ports:
      - "81:80"
      - "1443:443"
    depends_on:
      - mysql.mall
      - redis.mall
      - zookeeper.mall
      - kafka.mall
  mall-admin:
    image: mall/mall-admin:1.0-SNAPSHOT
    container_name: mall-admin
    ports:
      - 8080:8080
    links:
      - mysql.mall:db
  mall-gateway:
    image: mall/mall-gateway:1.0-SNAPSHOT
    container_name: mall-gateway
    ports:
      - 8201:8201
    links:
      - redis.mall:redis
      - nacos.mall:nacos-registry
  mall-auth:
    image: mall/mall-auth:1.0-SNAPSHOT
    container_name: mall-auth
    ports:
      - 8401:8401
    links:
      - nacos.mall:nacos-registry
```



## mall-admin

```yaml
version: '3'
services:
  mysql:
    image: mall-mysql:v1.0
    container_name: mysql
    restart: always
    ports:
      - 3306:3306
  redis:
    image: mall-redis:v1.0
    container_name: redis
    ports:
      - 6379:6379
  nginx:
    image: mall-nginx:v1.0
    container_name: nginx
    ports:
      - 8888:80
  rabbitmq:
    image: mall-rabbit:v1.0
    container_name: rabbitmq
    ports:
      - 5672:5672
      - 15672:15672
  nacos-registry:
    image: mall-nacos:v1.0
    container_name: nacos-registry
    ports:
      - 8848:8848
  mall-admin:
    image: mall/mall-admin:1.0-SNAPSHOT
    container_name: mall-admin
    ports:
      - 8080:8080
    links:
      - mysql:db
  mall-gateway:
    image: mall/mall-gateway:1.0-SNAPSHOT
    container_name: mall-gateway
    ports:
      - 8201:8201
    links:
      - redis:redis
      - nacos-registry:nacos-registry
  mall-auth:
    image: mall/mall-auth:1.0-SNAPSHOT
    container_name: mall-auth
    ports:
      - 8401:8401
    links:
      - nacos-registry:nacos-registry

```







## Pig

```yaml
version: '2'
services:
  pig-mysql:
    environment:
      MYSQL_ROOT_PASSWORD: root
    restart: always
    container_name: pig-mysql
    image: pig-mysql:v1.0
    ports:
      - 3306:3306
    links:
      - pig-service:pig-register
  pig-redis:
    image: pig-redis:v1.0
    ports:
      - 6379:6379
    restart: always
    container_name: pig-redis
    hostname: pig-redis
    links:
      - pig-service:pig-register
  pig-service:
    ports:
      - 8848:8848
      - 9999:9999
    restart: always
    container_name: pig-service
    hostname: pig-service
    image: pig-service:v1.0
    extra_hosts:
      - pig-register:127.0.0.1
      - pig-upms:127.0.0.1
      - pig-gateway:127.0.0.1
      - pig-auth:127.0.0.1
      - pig-hou:127.0.0.1
    stdin_open: true
    tty: true
    privileged: true
  pig-ui:
    restart: always
    container_name: pig-ui
    image: pig-ui:v1.0
    ports:
      - 8888:80
    links:
      - pig-service:pig-gateway
```

