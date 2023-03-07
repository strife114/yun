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

15. ENTRYPOINT  指定这个容器启动的时候要运行的命令，可以追加命令

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



# 编排部署ChinaSkillsMall商城

## 构建redis

```
FROM centos:centos7.5.1804
MAINTAINER Chinaskill
ADD local.repo /etc/yum.repos.d/
RUN yum clean all
RUN yum -y install redis
RUN sed -i -e 's@bind 127.0.0.1@bind 0.0.0.0@g' /etc/redis.conf
RUN sed -i -e 's@protected-mode yes@protected-mode no@g' /etc/redis.conf
RUN sed -i -e 's@daemonize yes@daemonize no@g' /etc/redis.conf
EXPOSE 6379
ENTRYPOINT redis-server /etc/redis.conf



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



### 2

db_init.sh

```
#!/bin/bash
mysql_install_db --user=mysql
sleep 3
mysqld_safe &
sleep 3
mysqladmin -u "$MARvimIADB_USER" password "$MARIADB_PASS"
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
MAINTAINER FDY
RUN rm -rf /etc/yum.repos.d/*
ADD local.repo /etc/yum.repos.d/
ADD mall-repo /opt/mall-repo
ADD mall.sql  /root/
ENV MARIADB_USER root
ENV MARIADB_PASS 123456

ENV LC_ALL en_US.UTF8
ADD mall.sql /root/
ADD db_init.sh /root/
RUN chmod 755 /root/db_init.sh
RUN yum install -y mariadb-server
RUN sh -x /root/db_init.sh
EXPOSE 3306
CMD ["mysqld_safe"]               




# 几率报错，重新构建就行

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

### 3

db_init.sh

```
  
#!/bin/bash
mysql_install_db --user=mysql
sleep 3
mysqld_safe &
sleep 3
mysqladmin -u "$MARIADB_USER" password "$MARIADB_PASS"
mysql -uroot -p12345678 -e "use mysql; grant all privileges on *.* to '$MARIADB_USER'@'%' identified by '$MARIADB_PASS' with grant option;"
mysql -uroot -p12345678 -e "use mysql; source /root/mall.sql;"
```

Dockerfile-mariadb

```


FROM centos:centos7.5.1804
MAINTAINER fdy
RUN rm -rf /etc/yum.repos.d/*
ADD local.repo /etc/yum.repos.d/
ADD db_init.sh /root/
ADD mall-repo  /opt/mall-repo
ADD mall.sql   /root/

ENV LC_ALL en_US.UTF8
ENV MARIADB_USER root
ENV MARIADB_PASS 12345678
RUN yum clean all
RUN yum install -y mariadb-server
RUN chmod 755 /root/db_init.sh
RUN sh -x  /root/db_init.sh
EXPOSE 3306
CMD ["mysqld_safe"]

```







## 构建nacos镜像

```
FROM centos:cenots7.5.1804
MAINTAINER chinaskill
ADD local.repo /etc/yum.repos.d/
ADD nacos-server-1.1.0.tar.gz /usr/local/
ADD jdk-8u121-linux-x64.tar.gz /usr/local/
ENV NACOS_HOME /usr/local/nacos
ENV JAVA_HOME /usr/local/jdk1.8.0_121
ENV PATH $PATH:$NACOS_HOME/bin:$JAVA_HOME/bin
EXPOSE 8848
CMD startup.sh -m standalone && tail -f $NACOS_HOME/logs/start.out
```





## 构建nginx镜像

```
FROM centos:centos7.5.1804
MAINTAINER chinaskill
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


```

set.up

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

local.repo

```
[mall]
name=mall
baseurl=file:///opt/mall-repo
gpgcheck=0
enabled=1
```

