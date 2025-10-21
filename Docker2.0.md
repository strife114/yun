

# Docker历史

1. **Docker** 最初是 `dotCloud` 公司创始人 [Solomon Hykes](https://github.com/shykes) 在法国期间发起的一个公司内部项目，它是基于 `dotCloud` 公司多年云服务技术的一次革新，并于 [2013 年 3 月以 Apache 2.0 授权协议开源](https://en.wikipedia.org/wiki/Docker_(software))，主要项目代码在 [GitHub](https://github.com/moby/moby) 上进行维护。`Docker` 项目后来还加入了 Linux 基金会，并成立推动 [开放容器联盟（OCI）](https://opencontainers.org/)。

2. **Docker** 自开源后受到广泛的关注和讨论，至今其 [GitHub 项目](https://github.com/moby/moby) 已经超过 5 万 7 千个星标和一万多个 `fork`。甚至由于 `Docker` 项目的火爆，在 `2013` 年底，[dotCloud 公司决定改名为 Docker](https://www.docker.com/blog/dotcloud-is-becoming-docker-inc/)。`Docker` 最初是在 `Ubuntu 12.04` 上开发实现的；`Red Hat` 则从 `RHEL 6.5` 开始对 `Docker` 进行支持；`Google` 也在其 `PaaS` 产品中广泛应用 `Docker`。

3. **Docker** 使用 `Google` 公司推出的 [Go 语言](https://golang.google.cn/) 进行开发实现，基于 `Linux` 内核的 [cgroup](https://zh.wikipedia.org/wiki/Cgroups)，[namespace](https://en.wikipedia.org/wiki/Linux_namespaces)，以及 [OverlayFS](https://docs.docker.com/storage/storagedriver/overlayfs-driver/) 类的 [Union FS](https://en.wikipedia.org/wiki/Union_mount) 等技术，对进程进行封装隔离，属于 [操作系统层面的虚拟化技术](https://en.wikipedia.org/wiki/Operating-system-level_virtualization)。由于隔离的进程独立于宿主和其它的隔离的进程，因此也称其为容器。最初实现是基于 [LXC](https://linuxcontainers.org/lxc/introduction/)，从 `0.7` 版本以后开始去除 `LXC`，转而使用自行开发的 [libcontainer](https://github.com/docker/libcontainer)，从 `1.11` 版本开始，则进一步演进为使用 [runC](https://github.com/opencontainers/runc) 和 [containerd](https://github.com/containerd/containerd)。

# Docker简介

>1. Dcker是一个开源的容器引擎(容器化平台)，让开发者可以打包他们的应用以及依赖包到一个可移植的容器中，然后发布到任何流行的Linux机器上，也可以实现虚拟化
>
>2. 容器是完全使用沙箱机制，相互之间不会有任何接口（类似于iphone的app），几乎没有性能开销，可以很容易在机器和数据中心中运行，最重要的是，他们不依赖于任何语言、框架或包括系统
>
>3. 容器使用**基于image镜像**的部署模式，image中包含了运行应用程序所需的一切：代码、运行时、系统工具、系统库和配置文件。无论是单个程序还是多个程序组成的复杂服务，或者分布式系统，都可以使用docker run或docker compose up命令一键部署，省去了大量搭建、配置环境、调试和排查错位的时间
>
>4. docker为容器创建了行业标准，使容器成为了软件交付过程中的一种标准化格式，将软件打包成容器镜（image），能够使软件在不同的下运行一致，应用程序可以快速可靠地从一个环境移植到另一个环境，并确保所有的部署目标（例如开发、测试、生产环境）上的都按预期运行，从而避免了“在我的电脑上是好的，在你的电脑上就运行不了”的问题
>
>5. 为什么使用Docker？
>
> >1. docker容器的启动可以在秒级实现，相比于传统的虚拟机方式快得多
> >2. 对系统资源的利用率高，一台主机上可以同时运行数千个docker容器
> >3. 容器除了运行其中应用外，基本不消耗额外的系统资源，使得应用的性能很高，同时系统开销量小
> >4. 传统虚拟机方式运行10个不同的应用就要起10个虚拟机，而docker只需要启动10个隔离的应用即可
> >
>
>4. docker镜像是一个不包含Linux内核而又精简的Linux操作系统
>
>5. docker hub是由docker公司负责维护的公共注册中心，包含大量的容器镜像，docker工具默认从这个公共镜像库下载镜像，网址为：https://hub.docker.com/explore
>
>6. 容器与虚拟机的关系
>
>  >容器包括应用程序及其所有依赖项。容器运行时，与宿主机共享操作系统内核，容器在linux内核层面（使用 [Cgroups](https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/6/html/Resource_Management_Guide/ch01.html) 和 [namespaces](https://lwn.net/Articles/528078/)）来实现进程间的隔离，容器在主机操作系统上的用户空间中作为独立进程运行。
>  >
>  >因此，容器相比于虚拟机更加轻量化，它体积小，启动快，占用资源少，性能好。
>  >
>  >虚拟机使用虚拟化技术，应用程序运行在完整的操作系统（OS）之上，因此占用的资源更多，安装更复杂。
>  >
>  >但是由于容器与宿主机共享内核，所以在隔离性和安全性方面不如虚拟机。
>
>  ![容器与虚拟机关系.png (2320×1384) (gitee.com)](https://gitee.com/fan-dongyuan/ty-gallery/raw/master/%E5%B7%A5%E5%9D%8A%E5%9B%BE/web/%E5%AE%B9%E5%99%A8%E4%B8%8E%E8%99%9A%E6%8B%9F%E6%9C%BA%E5%85%B3%E7%B3%BB.png)

## 主要特点

 Docker 的一些主要特点：

1. **轻量级**：由于Docker使用操作系统级别的虚拟化技术，它可以更有效地使用系统资源，减少内存和磁盘空间的使用。因此，Docker显著提高了应用程序的可移植性和部署速度。
2. **可移植性**：Docker允许你在不同的平台、操作系统和云服务上构建和部署相同的应用程序。这意味着你可以在本地计算机上构建应用程序，并将其部署到生产环境中而无需修改代码或配置。
3. **环境隔离**：Docker容器提供了一个隔离环境，使应用程序能够独立运行和交互，并避免与其它应用程序冲突或影响。这种隔离性还提供了更好的安全性和可靠性，使应用程序更加健壮和安全。
4. **开放性**：Docker使用开放的标准和API，这意味着你可以自由地选择不同的工具和技术来构建、部署和管理Docker容器。此外，Docker社区提供了大量的插件和扩展，可以进一步增强Docker的功能和灵活性。
5. **可扩展性**：Docker容器可以很容易地在不同的环境中进行部署和扩展，例如在云服务上自动扩展容器数量。Docker还提供了内置的集群管理工具，使容器化的应用程序能够轻松地在多个节点上运行和通信。

总之，Docker是一种流行的容器化技术，它提供了许多功能和工具，可以帮助开发者更轻松地构建、部署和管理应用程序，并提高系统的可移植性、环境隔离性、开放性和可扩展性。



![容器镜像](https://gitee.com/fan-dongyuan/ty-gallery/raw/master/%E5%B7%A5%E5%9D%8A%E5%9B%BE/web/%E5%AE%B9%E5%99%A8%E9%95%9C%E5%83%8F)





# docker官网

```sh
# docker官方镜像仓库
https://hub.docker.com/

# docker官网
https://www.docker.com/
```



# docker安装

## 旧版安装

```sh
# 更新yum源
yum  update
# 安装docker存储库
yum -y install yum-utils  device-mapper-persisten-data  lvm2
# 设置稳定的存储库
yum-config-manager  --add-repo  https://download.docker.com/linux/centos/docker-ce.repo
# 安装docker
yum -y install docker
# docker版本检测
docker version
# 启动服务并设置自启
systemctl start docker && systemctl enable docker
```

## 新版安装

```sh
# 安装最新版的Docker引擎，docker-ce还需要添加Docker官方的YUM源
yum  update
yum -y install yum-utils  device-mapper-persisten-data  lvm2
yum-config-manager  --add-repo  https://download.docker.com/linux/centos/docker-ce.repo
yum -y install docker-ce

#docker版本检测
docker  -v


# 启动服务并设置自启
systemctl start docker && systemctl enable docker
```

## 一键部署

```sh
curl -fsSL https://get.docker.com | bash -s docker --mirror Aliyun
```







# 配置镜像加速器

```sh
mkdir -p /etc/docker
tee /etc/docker/daemon.json <<-'EOF'
{
  "registry-mirrors": ["https://i6500m23.mirror.aliyuncs.com"]
}
EOF

# 重启服务
sudo systemctl daemon-reload
sudo systemctl restart docker


# 验证
docker info
```






# 常用镜像管理命令

```sh
# docker相关配置信息
docker info  

# 查看镜像
docker images

# 构建镜像
docker build 镜像名/镜像id

# 查看镜像历史
docker history 镜像名/镜像id

# 显示一个或多个镜像详细信息
docker inspect  镜像名/镜像id

# 从镜像仓库拉取镜像
# 默认拉取最新版本
docker pull 镜像名
# 拉取指定版本
docker pull 镜像名:版本

# 推送一个镜像到镜像仓库
docker push  镜像名

# 上传镜像必须保证这个镜像的名称前缀根仓库名称一致
# 比如要上传镜像到library库，就保证镜像名称为ip地址/library/镜像名
docker push 192.168.200.14/library/镜像名

# 删除一个或多个镜像
docker rmi 镜像id/镜像名

# 移除没有被标记或者没有被任何容器引用的镜像（但实际上并未删除什么，就算没有被引用的也未删除）
docker image prune
# 删除所有没有被任何容器使用镜像以及悬挂的镜像和未使用的构建缓存
docker image prune -a

# 创建一个引用镜像标记目标镜像
docker tag  源镜像名/源镜像id  镜像名/镜像id
docker tag centos:7.9.2009 centos:1

# 保存一个镜像到一个归档文件
docker save 镜像名 -o 归档包名
# 保存多个镜像到一个归档文件
docker save 镜像名1 镜像名2 -o 归档包名
# 加载镜像来自tar归档或标准输入
docker load -i 归档包

# 查看docker进程（查看正在运行的容器）
docker ps
# 查看正在运行的容器id
docker container ls
docker ps -q
# 查看所有容器
dockers ps -a
# 查看所有容器id
docker ps -a -q



# 注意
1. 保存归档包的时候不能指定镜像id，因为这样会无法保存镜像名，导致加载归档包的时候没有相应的镜像名数据
```



# 创建容器常用选项

```sh
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


# 注意
# 因为纯净的操作系统没有主进程，可以通过it的伪终端进程，挂住容器
docker run -d centos       崩溃
docker run -it -d centos   启动

# 前台启动的话可以直接通过run进入
docker run -ti mysql:latest some-mysql /bin/bash
# 如果一个容器已经启动(后台)，可以使用docker exec在运行的容器中执行命令，一般配合it参数使用交互模式
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

```sh
# 列出容器
docker ps
# 列出所有容器
docker ps -a
# 列出所有容器id
docker ps -a -q


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

# 停止所有容器
docker stop $(docker ps -a -q)
```





# docker-compose命令

```sh
# 后台启动，如果容器不存在根据镜像⾃动创建
docker-compose up -d
# 停⽌容器并删除容器
docker-compose down
# 启动容器，容器不存在就⽆法启动，不会⾃动创建镜像
docker-compose start
# 停⽌容器
docker-compose stop

停⽌服务： docker-compose stop
开始服务： docker-compose start
重启服务：docker-compose restart
停⽌服务并删除容器：docker-compose down
启动服务并运⾏容器：docker-compose up
```



# 数据持久化（数据挂载）

Docker提供两种方式将数据从宿主机挂载到容器中：

1. 数据卷：将宿主机上的任意的文件或目录挂载到容器中

2. 数据卷容器：其他容器挂载数据卷容器来实现

### 基本命令

```sh
docker inspect  容器名              数据卷看数据卷信息
docker run -itd -v                 数据卷:容器内目录 使用某个数据卷
docker volume ls                   列出所有数据卷容器id
docker volume rm                   删除某个数据卷容器
```

注意：

**将数据存储在容器中，一旦容器被删除，数据也会被删除。同时也会使容器变得越来越大，不方便恢复和迁移。**

将数据存储到容器之外，这样删除容器也不会丢失数据。一旦容器故障，我们可以重新创建一个容器，将数据挂载到容器里，就可以快速的恢复。

### **数据卷**

就是**将宿主机的某个目录，映射到容器中**，两方同时进行存储

作用：

1. 可以在容器之间共享和重用，本地与容器间传递数据更高效
2. 对数据卷的修改会立马有效，容器内部与本地目录均可
3. 对数据卷的更新不会影响镜像，对数据与应用进行了解耦操作
4. 数据卷默认会一直存在，即使容器被删除

```sh
docker run -dti --name [容器名] -v [宿主机目录]:[容器目录][镜像名][命令]


docker run -e MYSQL_ROOT_PASSWORD=123456 \
           -v /home/mysql/mysql.cnf:/etc/mysql/conf.d/mysql.cnf:ro  \
           -v /home/mysql/data:/var/lib/mysql  \
           -d mysql:5.7
```

注意：

1. Docker挂载数据卷的默认读写权限，用户可通过ro设置为只读，格式：**[宿主机文件]:[容器文件]:ro**
2. 如果直接挂载一个文件到容器，使用文件工具进行编辑，可能会造成文件的改变，从docker1.1.0起，这回导致报错误信息，所以推荐的方式是直接**挂载文件所在的目录**
3. 绑定挂载将主机上的目录或文件装载到容器中，绑定挂载会覆盖容器中的目录或文件，如果宿主机目录不存在则自动创建，但不能自动创建文件

### 数据卷容器

数据卷容器需要在多个容器之间共享一些出持续更新的数据，最简单的方式是使用数据卷容器，**数据卷容器也是一个容器，但是其目的是专门用来提供数据卷供其他容器挂载。**

使用特定容器维护数据卷，简单来说就是为其他容器提供数据交互存储的容器

操作流程：

1. 创建数据卷容器
2. 其他容器挂载数据卷容器

**注意：数据卷容器自身并不需要启动，但是启动的时候仍然可以进行数据卷容器的工作**

1. 创建数据卷容器

   ```sh
   docker create -v [容器数据卷目录] --name[容器名][镜像名]
   
   docker create -v /data1 --name v-data1 nginx
   ```

2. 创建两个容器

   ```sh
   docker run --volumes-from[数据卷容器id/name] -dti --name [容器名] [镜像名] [命令]
   
   docker run --volumes-from v-data1 -dti --name v1 nginx
   docker run --volumes-from v-data1 -dti --name v2 nginx
   ```

3. 确认数据卷容器共享

   ```sh
   # 进入v1操作数据卷容器
   docker exec -it 1390a43c879a /bin/bash
   ls /data1
   echo 'v11' > /data1/v01.txt
   exit
   
   # 进入v2操作数据卷容器
   docker exec -it 154684ds54as /bin/bash
   ls /data
   echo 'v22' >/data1/v02.txt
   exit
   ```

注：db_data这个数据卷容器不能随便关，如果关了，其他挂载了db_data里面数据卷的容器就会用不了





# Dockfile构建镜像

`docker build`命令用于从Dockerfile构建镜像

```shell
docker build  -t ImageName:TagName dir

-t          给镜像加一个Tag
ImageName   给镜像起的名称
TagName     给镜像的Tag名
Dir         Dockerfile所在目录
-f          指定文件名
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

15. **ENTRYPOINT**  指定这个容器启动的时候要运行的命令，可以追加命令，与cmd的区别就是创建容器的参数不能被指定























# MySQL+Wordpress实验

## MySQL+Wordpress

### 简介

1. 传统的使用wordpress搭建网站，意味着你需要搭建以下四个环境

   php、nginx/apache、mysql、wordpress

2. 而对于docker来说就是两个容器的事情，当然，wordpress里也有内置的web服务和php服务

### 实践

1. 在已有docker的环境下拉去mysql:5.7的镜像

   ```sh
   [root@docker ~]# docker pull mysql:5.7
   ```

2. 启动mysql镜像构建容器

   ```sh
   [root@docker ~]#docker container run \
     -d \
     --rm \
     --name wordpressdb \
     --env MYSQL_ROOT_PASSWORD=123456 \
     --env MYSQL_DATABASE=wordpress \
     mysql:5.7
   
   
   
   
   参数解释：
   -d：                                      以后台模式运行容器
   --rm                                     容器停止运行时，自动删除该容器
   --name wordpressdb                         为容器指定名称 "wordpressdb"
   --env MYSQL_ROOT_PASSWORD=123456     向容器进程传入一个环境变量MYSQL_ROOT_PASSWORD，该变量会被用作 MySQL 的根密码。
   --env MYSQL_DATABASE=wordpress       向容器进程传入一个环境变量MYSQL_DATABASE，容器里面的 MySQL 会根据该变量创建一个wordpress数据库
   ```

3. 拉取wordpress:6.2.1镜像

   ```sh
   [root@docker ~]# docker pull wordpress:6.2.1
   ```

   

4. 启动wordpress并构建容器

   ```sh
   [root@docker ~]# docker container run \
     -d \
     -p 8080:80 \
     --rm \
     --name wordpress \
     --env WORDPRESS_DB_PASSWORD=123456 \
     --link wordpressdb:mysql \
     --volume "$PWD/wordpress":/var/www/html \
     wordpress:6.2.1
     
     
   参数解释：
   -d：                                      以后台模式运行容器
   -ti                                      让Docker分配一个伪终端（pseudo-TTY）并保持标准输入（stdin）打开（这里可以不用使用）
   -p 8080:80                               将主机（Host）的 8080 端口映射到容器的 80 端口上，使得可以通过浏览器访问容器内的 WordPress
   --rm                                     容器停止运行时，自动删除该容器
   --name wordpress                         为容器指定名称 "wordpress"
   --env WORDPRESS_DB_PASSWORD=123456       设置 WordPress 数据库密码为 "123456"
   --link wordpressdb:mysql                 将容器 wordpress连接到另一个容器 wordpressdb 上，并且在 wordpress 容器内创建一个别名为 mysql的环境变量，用于访问 wordpressdb 容器中的 MySQL 数据库
   --volume "$PWD/wordpress"/var/www/html   将当前目录下名为 "wordpress" 的文件夹挂载到容器内的 /var/www/html 目录上，以便在容器内部访问和修改 WordPress 文件（如果当前目录并不存在wordpress，则会自动创建）
   wordpress:6.2.1                                是容器镜像的名称，代表了要启动的应用程序。如果该镜像不存在，则会先从 Docker Hub 中下载该镜像
   ```

5. 修改容器配置文件

   ```sh
   [root@docker ~]# cd wordpress
   [root@docker wordpress]# vim wp-config.php
   define( 'DB_NAME', getenv_docker('WORDPRESS_DB_NAME', 'wordpress') );
   
   /** Database username */
   define( 'DB_USER', getenv_docker('WORDPRESS_DB_USER', 'root') );
   
   /** Database password */
   define( 'DB_PASSWORD', getenv_docker('WORDPRESS_DB_PASSWORD', '123456') );
   ```

6. 浏览器访问

   ```sh
   ip:8080
   ```




## MySQL+Wordpress(构建)

1. 使用MySQL5.7镜像构建容器

   ```sh
   [root@docker ~]#docker container run \
     -d \
     --name wordpressdb \
     --env MYSQL_ROOT_PASSWORD=123456 \
     --env MYSQL_DATABASE=wordpress \
     mysql:5.7
   ```

2. 构建的准备工作

   创建apache的wordpress配置文件

   ```sh
   [root@docker ~]# cat wordpress.conf 
   <VirtualHost *:80>
       ServerAdmin webmaster@localhost
       DocumentRoot /var/www/html/
       <Directory /var/www/html/>
           Options FollowSymLinks
           AllowOverride All
           Require all granted
       </Directory>
   </VirtualHost>
   ```

   创建wp-config.php配置文件

   ```sh
   [root@docker ~]# cat wp-config.php 
   <?php
   /**
    * The base configuration for WordPress
    *
    * The wp-config.php creation script uses this file during the installation.
    * You don't have to use the web site, you can copy this file to "wp-config.php"
    * and fill in the values.
    *
    * This file contains the following configurations:
    *
    * * Database settings
    * * Secret keys
    * * Database table prefix
    * * ABSPATH
    *
    * This has been slightly modified (to read environment variables) for use in Docker.
    *
    * @link https://wordpress.org/documentation/article/editing-wp-config-php/
    *
    * @package WordPress
    */
   
   // IMPORTANT: this file needs to stay in-sync with https://github.com/WordPress/WordPress/blob/master/wp-config-sample.php
   // (it gets parsed by the upstream wizard in https://github.com/WordPress/WordPress/blob/f27cb65e1ef25d11b535695a660e7282b98eb742/wp-admin/setup-config.php#L356-L392)
   
   // a helper function to lookup "env_FILE", "env", then fallback
   if (!function_exists('getenv_docker')) {
   	// https://github.com/docker-library/wordpress/issues/588 (WP-CLI will load this file 2x)
   	function getenv_docker($env, $default) {
   		if ($fileEnv = getenv($env . '_FILE')) {
   			return rtrim(file_get_contents($fileEnv), "\r\n");
   		}
   		else if (($val = getenv($env)) !== false) {
   			return $val;
   		}
   		else {
   			return $default;
   		}
   	}
   }
   
   // ** Database settings - You can get this info from your web host ** //
   /** The name of the database for WordPress */
   define( 'DB_NAME', getenv_docker('WORDPRESS_DB_NAME', 'wordpress') );
   
   /** Database username */
   define( 'DB_USER', getenv_docker('WORDPRESS_DB_USER', 'root') );
   
   /** Database password */
   define( 'DB_PASSWORD', getenv_docker('WORDPRESS_DB_PASSWORD', '123456') );
   
   /**
    * Docker image fallback values above are sourced from the official WordPress installation wizard:
    * https://github.com/WordPress/WordPress/blob/1356f6537220ffdc32b9dad2a6cdbe2d010b7a88/wp-admin/setup-config.php#L224-L238
    * (However, using "example username" and "example password" in your database is strongly discouraged.  Please use strong, random credentials!)
    */
   
   /** Database hostname */
   define( 'DB_HOST', getenv_docker('WORDPRESS_DB_HOST', 'mysql') );
   
   /** Database charset to use in creating database tables. */
   define( 'DB_CHARSET', getenv_docker('WORDPRESS_DB_CHARSET', 'utf8') );
   
   /** The database collate type. Don't change this if in doubt. */
   define( 'DB_COLLATE', getenv_docker('WORDPRESS_DB_COLLATE', '') );
   
   /**#@+
    * Authentication unique keys and salts.
    *
    * Change these to different unique phrases! You can generate these using
    * the {@link https://api.wordpress.org/secret-key/1.1/salt/ WordPress.org secret-key service}.
    *
    * You can change these at any point in time to invalidate all existing cookies.
    * This will force all users to have to log in again.
    *
    * @since 2.6.0
    */
   define( 'AUTH_KEY',         getenv_docker('WORDPRESS_AUTH_KEY',         'e803ed486850d3df2bc44add699d4caa25179aa4') );
   define( 'SECURE_AUTH_KEY',  getenv_docker('WORDPRESS_SECURE_AUTH_KEY',  '473a7e1b9a5bbffb84750c22f951da76a10c9963') );
   define( 'LOGGED_IN_KEY',    getenv_docker('WORDPRESS_LOGGED_IN_KEY',    'd0e3975079193572b5aa8e8bddc3ca156924407a') );
   define( 'NONCE_KEY',        getenv_docker('WORDPRESS_NONCE_KEY',        '233a9393a4bafac0f23af1f85a1d4a1f7bb4d377') );
   define( 'AUTH_SALT',        getenv_docker('WORDPRESS_AUTH_SALT',        '5d2b9ea178d3317f2062246bf440f04198cd6cfe') );
   define( 'SECURE_AUTH_SALT', getenv_docker('WORDPRESS_SECURE_AUTH_SALT', 'f442354b052e67e5ea47af4f395825f742e83e60') );
   define( 'LOGGED_IN_SALT',   getenv_docker('WORDPRESS_LOGGED_IN_SALT',   'ea3f0d6a7c1a77e09edb78fb1f5eb7e363a7f81c') );
   define( 'NONCE_SALT',       getenv_docker('WORDPRESS_NONCE_SALT',       'f258c606c96ac5da468e61b1c10f421ac7d59f6d') );
   // (See also https://wordpress.stackexchange.com/a/152905/199287)
   
   /**#@-*/
   
   /**
    * WordPress database table prefix.
    *
    * You can have multiple installations in one database if you give each
    * a unique prefix. Only numbers, letters, and underscores please!
    */
   $table_prefix = getenv_docker('WORDPRESS_TABLE_PREFIX', 'wp_');
   
   /**
    * For developers: WordPress debugging mode.
    *
    * Change this to true to enable the display of notices during development.
    * It is strongly recommended that plugin and theme developers use WP_DEBUG
    * in their development environments.
    *
    * For information on other constants that can be used for debugging,
    * visit the documentation.
    *
    * @link https://wordpress.org/documentation/article/debugging-in-wordpress/
    */
   define( 'WP_DEBUG', !!getenv_docker('WORDPRESS_DEBUG', '') );
   
   /* Add any custom values between this line and the "stop editing" line. */
   
   // If we're behind a proxy server and using HTTPS, we need to alert WordPress of that fact
   // see also https://wordpress.org/support/article/administration-over-ssl/#using-a-reverse-proxy
   if (isset($_SERVER['HTTP_X_FORWARDED_PROTO']) && strpos($_SERVER['HTTP_X_FORWARDED_PROTO'], 'https') !== false) {
   	$_SERVER['HTTPS'] = 'on';
   }
   // (we include this by default because reverse proxying is extremely common in container environments)
   
   if ($configExtra = getenv_docker('WORDPRESS_CONFIG_EXTRA', '')) {
   	eval($configExtra);
   }
   
   /* That's all, stop editing! Happy publishing. */
   
   /** Absolute path to the WordPress directory. */
   if ( ! defined( 'ABSPATH' ) ) {
   	define( 'ABSPATH', __DIR__ . '/' );
   }
   
   /** Sets up WordPress vars and included files. */
   require_once ABSPATH . 'wp-settings.php';
   ```

   

3. 构建wordpress镜像

   ```sh
   [root@docker ~]# cat dockerfile-wordpress 
   FROM centos:7.9.2009
   MAINTAINER 123
   
   RUN yum update -y  && \
       yum install epel-release yum-utils -y && \
       yum -y install https://rpms.remirepo.net/enterprise/remi-release-7.rpm && \
       yum-config-manager --enable remi-php80 && \
       yum install php php-cli php-fpm php-mysqlnd php-zip php-devel php-gd php-mbstring php-curl php-xml php-pear php-bcmath php-json php-redis -y && \
       yum install -y httpd mariadb mariadb-server  wget unzip && \
       yum clean all
   
   RUN ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
   
   RUN wget https://wordpress.org/latest.tar.gz && \
       tar -xzvf latest.tar.gz -C /var/www/html/ && \
       rm -rf latest.tar.gz && \
       mv /var/www/html/wordpress/* /var/www/html/ && \
       rmdir /var/www/html/wordpress/
   
   COPY wp-config.php /var/www/html/wp-config.php
   COPY wordpress.conf /etc/httpd/conf.d/wordpress.conf
   EXPOSE 80
   CMD ["/usr/sbin/httpd", "-DFOREGROUND"]
   ```

4. 执行构建

   ```sh
   [root@docker ~]# docker build -t wordpress2:6.2.2 -f dockerfile-wordpress .
   ```

5. 使用构建的wordpress2来构建容器

   ```sh
   [root@docker ~]# docker container run \
     -d \
     -p 8080:80 \
     --rm \
     --name wordpress \
     --env WORDPRESS_DB_PASSWORD=123456 \
     --link wordpressdb:mysql \
     wordpress2:6.2.2
   ```

6. 浏览器测试

   ```sh
   ip:8080
   
   
   # 注意：
   1. 因为这里的6.2.2是官方的安装包，所以没有中文选项，会直接进入初始化
   ```

   





# Harbor仓库本机部署实验

## Harbor1.1.2

1. 下载部署docker-compose

   ```sh
   [root@docker ~]# curl -SL https://github.com/docker/compose/releases/download/v2.17.2/docker-compose-linux-x86_64 -o /usr/local/bin/docker-compose
   
   # 赋权
   [root@docker ~]# chmod 755 /usr/loca/bin/docker-compose
   ```

2. 下载harbor

   ```sh
   [root@docker ~]# wget https://github.com/vmware/harbor/releases/download/v1.1.2/harbor-offline-installer-v1.1.2.tgz
   ```

3. 创建目录并解压

   ```sh
   [root@docker ~]# mkdir /data
   [root@docker ~]# tar zxvf harbor-offline-installer-v1.1.2.tgz -C /data/
   ```

4. 设置配置文件

   ```sh
   root@docker /]# cd /data/harbor/
   [root@docker harbor]# ls
   common  docker-compose.notary.yml  docker-compose.yml  harbor_1_1_0_template  harbor.cfg  harbor.v1.1.2.tar.gz  install.sh  LICENSE  NOTICE  prepare  upgrade
   [root@docker harbor]# vim harbor.cfg
   # 修改此值，其他默认即可
   hostname = 192.168.6.4
   ```

5. 启动

   ```sh
   [root@docker harbor]# ./install.sh
   
   
   # 查看docker
   [root@docker harbor]# docker ps
   CONTAINER ID   IMAGE                              COMMAND                  CREATED         STATUS         PORTS                                                                                                                 NAMES
   727e2b9ed5a3   vmware/harbor-jobservice:v1.1.2    "/harbor/harbor_jobs…"   8 minutes ago   Up 8 minutes                                                                                                                         harbor-jobservice
   a6042454318a   vmware/nginx:1.11.5-patched        "nginx -g 'daemon of…"   8 minutes ago   Up 8 minutes   0.0.0.0:80->80/tcp, :::80->80/tcp, 0.0.0.0:443->443/tcp, :::443->443/tcp, 0.0.0.0:4443->4443/tcp, :::4443->4443/tcp   nginx
   f988f5162a1c   vmware/harbor-ui:v1.1.2            "/harbor/harbor_ui"      8 minutes ago   Up 8 minutes                                                                                                                         harbor-ui
   17c2b1caf8fb   vmware/registry:2.6.1-photon       "/entrypoint.sh serv…"   8 minutes ago   Up 8 minutes   5000/tcp                                                                                                              registry
   7dceb936065b   vmware/harbor-db:v1.1.2            "docker-entrypoint.s…"   8 minutes ago   Up 8 minutes   3306/tcp                                                                                                              harbor-db
   4ea635b3b04e   vmware/harbor-adminserver:v1.1.2   "/harbor/harbor_admi…"   8 minutes ago   Up 8 minutes                                                                                                                         harbor-adminserver
   c0351e60a56c   vmware/harbor-log:v1.1.2           "/bin/sh -c 'crond &…"   8 minutes ago   Up 8 minutes   127.0.0.1:1514->514/tcp                                                                                               harbor-log
   
   ```

6. 浏览器访问

   ```
   192.168.6.4
   
   默认用户名：admin
   默认密码：Harbor12345
   ```

   



## Harbor2.4.0

1. 下载部署Harbor2.4.0

   ```sh
   # 链接已失效，请自行寻找软件包下载
   [root@docker ~]# mkdir /data1
   [root@docker ~]# tar zxf harbor-offline-installer-v2.4.0.tgz -C /data1
   [root@docker harbor]# cd /data1/harbor/
   [root@docker harbor]# cp harbor.yml.tmpl harbor.yml
   ```

2. 编辑配置文件

   ```sh
   [root@docker harbor]# vim harbor.yml
   # 修改hostname
   hostname 192.168.6.4
   
   # 注释https服务
   #https:
     # https port for harbor, default is 443
    # port: 443
     # The path of cert and key files for nginx
     #certificate: /your/certificate/path
    # private_key: /your/private/key/path
   
   
   # 更改数据源
   data_volume: /data1
   ```

3. 运行配置文件更新脚本

   ```sh
   [root@docker harbor]# ./prepare
   ```

4. 执行编排脚本

   ```sh
   [root@docker harbor]# ./install.sh
   ```

5. web界面访问

   ```sh
   ip
   默认用户名：admin
   默认用户密码：Harbor12345
   ```

6. 新建名为fdy的项目，并设置访问级别为公开

   ![](https://gitee.com/Strife-Dispute/ty-gallery/raw/master/%E5%B7%A5%E5%9D%8A%E5%9B%BE/docker/harbor1.png)

7. 本机上传镜像

    ```sh
      # 修改docker配置
      [root@docker harbor]# cat /etc/docker/daemon.json 
      {
           "registry-mirrors": ["https://registry.docker-cn.com"],
           "insecure-registries" : ["192.168.6.4:80"]
      }
      
      # 重启docker
      [root@docker harbor]# systemctl restart docker
      [root@docker harbor]# docker-compose down
      [root@docker harbor]# ./install
      
      # 登陆本机仓库
      [root@docker harbor]# docker login 192.168.6.4:80
      Authenticating with existing credentials...
      WARNING! Your password will be stored unencrypted in /root/.docker/config.json.
      Configure a credential helper to remove this warning. See
      https://docs.docker.com/engine/reference/commandline/login/#credentials-store
      
      Login Succeeded
      
      
      # 注意
      1. 重启docker服务后harbor的相关容器会掉线或出现意外情况
      # 解决方法
      1. 使用docker-compose命令卸载harbor并重新安装
         docker-compose down
         ./install.sh
    ```

      ```sh
      # 给MySQL打标签
      [root@docker harbor]# docker tag mysql:5.7 192.168.6.4:80/fdy/mysql:5.7
      [root@docker harbor]# docker images
      REPOSITORY                         TAG               IMAGE ID       CREATED         SIZE
      wordpress2                         6.2.2             4fca88a1dc7d   3 days ago      787MB
      wordpress                          6.2.1             b8ee07adfa91   7 days ago      616MB
      wordpress                          latest            c3c92cc3dcb1   17 months ago   616MB
      192.168.6.4:80/fdy/mysql           5.7               c20987f18b13   17 months ago   448MB
      mysql                              5.7               c20987f18b13   17 months ago   448MB
      goharbor/harbor-exporter           v2.4.0            4c61c8b7a70c   19 months ago   82MB
      goharbor/chartmuseum-photon        v2.4.0            67b824008b50   19 months ago   173MB
      goharbor/redis-photon              v2.4.0            8db1d1af9272   19 months ago   155MB
      goharbor/trivy-adapter-photon      v2.4.0            bfd73a656727   19 months ago   148MB
      goharbor/notary-server-photon      v2.4.0            f07f3e0c3bea   19 months ago   110MB
      goharbor/notary-signer-photon      v2.4.0            dd4d5090ab32   19 months ago   107MB
      goharbor/harbor-registryctl        v2.4.0            7cb8dd808259   19 months ago   136MB
      goharbor/registry-photon           v2.4.0            928dc0fba05c   19 months ago   78.5MB
      goharbor/nginx-photon              v2.4.0            a2592618911d   19 months ago   45MB
      goharbor/harbor-log                v2.4.0            a54fed3c39f6   19 months ago   159MB
      goharbor/harbor-jobservice         v2.4.0            cd119b9530dd   19 months ago   220MB
      goharbor/harbor-core               v2.4.0            3399864a55e2   19 months ago   197MB
      goharbor/harbor-portal             v2.4.0            f585c7a62e69   19 months ago   54MB
      goharbor/harbor-db                 v2.4.0            de4b1b67e241   19 months ago   228MB
      goharbor/prepare                   v2.4.0            5216fde1e4e8   19 months ago   254MB
      centos                             7.9.2009          eeb6ee3f44bd   20 months ago   204MB
      centos                             latest            5d0da3dc9764   20 months ago   231MB
      vmware/harbor-jobservice           v1.1.2            ac332f9bd31c   5 years ago     163MB
      vmware/harbor-ui                   v1.1.2            803897be484a   5 years ago     183MB
      vmware/harbor-adminserver          v1.1.2            360b214594e7   5 years ago     142MB
      vmware/harbor-db                   v1.1.2            6f71ee20fe0c   5 years ago     329MB
      vmware/registry                    2.6.1-photon      0f6c96580032   6 years ago     150MB
      vmware/harbor-notary-db            mariadb-10.1.10   64ed814665c6   6 years ago     324MB
      vmware/nginx                       1.11.5-patched    8ddadb143133   6 years ago     199MB
      vmware/notary-photon               signer-0.5.0      b1eda7d10640   6 years ago     156MB
      vmware/notary-photon               server-0.5.0      6e2646682e3c   6 years ago     157MB
      vmware/harbor-log                  v1.1.2            9c46a7b5e517   6 years ago     192MB
      photon                             1.0               e6e4e4a2ba1b   6 years ago     128MB
      
      
      # 推送镜像到本地harbor仓库的fdy项目
      [root@docker harbor]# docker push 192.168.6.4:80/fdy/mysql:5.7
      
      
      
      
      # 给wordpress打标签
      [root@docker harbor]# docker tag wordpress:6.2.1 192.168.6.4:80/library/wordpress:6.2.1
      [root@docker harbor]# docker images
      REPOSITORY                         TAG               IMAGE ID       CREATED         SIZE
      wordpress2                         6.2.2             4fca88a1dc7d   3 days ago      787MB
      192.168.6.4:80/library/wordpress   6.2.1             b8ee07adfa91   7 days ago      616MB
      wordpress                          6.2.1             b8ee07adfa91   7 days ago      616MB
      wordpress                          latest            c3c92cc3dcb1   17 months ago   616MB
      192.168.6.4:80/fdy/mysql           5.7               c20987f18b13   17 months ago   448MB
      mysql                              5.7               c20987f18b13   17 months ago   448MB
      goharbor/harbor-exporter           v2.4.0            4c61c8b7a70c   19 months ago   82MB
      goharbor/chartmuseum-photon        v2.4.0            67b824008b50   19 months ago   173MB
      goharbor/redis-photon              v2.4.0            8db1d1af9272   19 months ago   155MB
      goharbor/trivy-adapter-photon      v2.4.0            bfd73a656727   19 months ago   148MB
      goharbor/notary-server-photon      v2.4.0            f07f3e0c3bea   19 months ago   110MB
      goharbor/notary-signer-photon      v2.4.0            dd4d5090ab32   19 months ago   107MB
      goharbor/harbor-registryctl        v2.4.0            7cb8dd808259   19 months ago   136MB
      goharbor/registry-photon           v2.4.0            928dc0fba05c   19 months ago   78.5MB
      goharbor/nginx-photon              v2.4.0            a2592618911d   19 months ago   45MB
      goharbor/harbor-log                v2.4.0            a54fed3c39f6   19 months ago   159MB
      goharbor/harbor-jobservice         v2.4.0            cd119b9530dd   19 months ago   220MB
      goharbor/harbor-core               v2.4.0            3399864a55e2   19 months ago   197MB
      goharbor/harbor-portal             v2.4.0            f585c7a62e69   19 months ago   54MB
      goharbor/harbor-db                 v2.4.0            de4b1b67e241   19 months ago   228MB
      goharbor/prepare                   v2.4.0            5216fde1e4e8   19 months ago   254MB
      centos                             7.9.2009          eeb6ee3f44bd   20 months ago   204MB
      centos                             latest            5d0da3dc9764   20 months ago   231MB
      vmware/harbor-jobservice           v1.1.2            ac332f9bd31c   5 years ago     163MB
      vmware/harbor-ui                   v1.1.2            803897be484a   5 years ago     183MB
      vmware/harbor-adminserver          v1.1.2            360b214594e7   5 years ago     142MB
      vmware/harbor-db                   v1.1.2            6f71ee20fe0c   5 years ago     329MB
      vmware/registry                    2.6.1-photon      0f6c96580032   6 years ago     150MB
      vmware/harbor-notary-db            mariadb-10.1.10   64ed814665c6   6 years ago     324MB
      vmware/nginx                       1.11.5-patched    8ddadb143133   6 years ago     199MB
      vmware/notary-photon               signer-0.5.0      b1eda7d10640   6 years ago     156MB
      vmware/notary-photon               server-0.5.0      6e2646682e3c   6 years ago     157MB
      vmware/harbor-log                  v1.1.2            9c46a7b5e517   6 years ago     192MB
      photon                             1.0               e6e4e4a2ba1b   6 years ago     128MB
      
      
      # 推送wordpress镜像到本地library仓库
      [root@docker harbor]# docker push 192.168.6.4:80/library/wordpress:6.2.1
      ```

8. 验证

   ![](https://gitee.com/Strife-Dispute/ty-gallery/raw/master/%E5%B7%A5%E5%9D%8A%E5%9B%BE/docker/harbor2.png)

   ![](https://gitee.com/Strife-Dispute/ty-gallery/raw/master/%E5%B7%A5%E5%9D%8A%E5%9B%BE/docker/harbor3.png)

   

  

# 可道云容器部署实验

## 本地部署

1. 配置yum源

   ```sh
   rm -rf /etc/yum.repos.d/*
   wget -O /etc/yum.repos.d/CentOS-Base.repo https://mirrors.aliyun.com/repo/Centos-7.repo
   wget -O /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-7.repo
   ```

2. 安装依赖包

   ```sh
   yum install nginx net-tools php-cli php-fpm unzip php-gd php-mbstring vim -y
   ```

3. 修改php配置文件

   ```sh
   vim /etc/php-fpm.d/www.conf
   39:user = nginx
   41:group = nginx
   
   # 启动服务
   systemctl start php-fpm
   ```

4. 配置nginx支持php

   ```sh
   [root@docker kodexporer]# cat /etc/nginx/conf.d/kodexporer.conf 
   server {
    listen 80;
    server_name kodexporer.com;
    location / {
    root /data/kodexporer;
    index index.php index.html;
    }
    location ~ \.php$ {
    root /data/kodexporer;
    fastcgi_pass 127.0.0.1:9000;
    fastcgi_index index.php;
    fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
    include fastcgi_params;
    }
   }
   
   # 检测配置
   nginx -t
   # 启动服务
   systemctl start nginx
   ```

5. 下载可道云压缩包

   ```sh
   wget http://static.kodcloud.com/update/download/kodexplorer4.37.zip
   mv kodexplorer4.37.zip /data/kodexporer/
   cd /data/kodexporer/
   unzip kodexplorer4.37.zip
   chown -R nginx:nginx /data/kodexporer/
   ```

6. 浏览器访问ip:80



## 容器部署

1. 准备配置文件

   ```sh
   [root@docker kodexporer]# cat kodexporer.conf 
   server {
    listen 80;
    server_name kodexporer.com;
    location / {
    root /data/kodexporer;
    index index.php index.html;
    }
    location ~ \.php$ {
    root /data/kodexporer;
    fastcgi_pass 127.0.0.1:9000;
    fastcgi_index index.php;
    fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
    include fastcgi_params;
    }
   }
   
   
   [root@docker kodexporer]# cat init.sh 
   #!/bin/bash
   /usr/sbin/php-fpm &
   nginx -g 'daemon off;'
   
   
   # 下载可道云压缩包
   [root@docker kodexporer]# curl -o kodexplorer.zip http://static.kodcloud.com/update/download/kodexplorer4.37.zip
   ```

2. 编写dockerfile文件

   ```sh
   [root@docker kodexporer]# cat dockerfile-kode 
   FROM centos:7.9.2009
   RUN rm -rf /etc/yum.repos.d/*
   RUN curl -o /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-7.repo ;curl -o /etc/yum.repos.d/CentOS-Base.repo https://mirrors.aliyun.com/repo/Centos-7.repo
   RUN yum -y install nginx php-fpm php-cli lrzsz vim unzip php-gd php-mbstring
   RUN cd /etc/nginx/conf.d/ && rename .conf .off *
   ADD kodexporer.conf /etc/nginx/conf.d/
   RUN mkdir /data/kodexporer -p
   ADD kodexplorer.zip /data/kodexporer/
   RUN cd /data/kodexporer && unzip kodexplorer.zip && chown -R nginx:nginx /data/
   RUN sed -ri 's/apache/nginx/g' /etc/php-fpm.d/www.conf
   ADD init.sh /root/init.sh
   CMD ["/bin/bash","/root/init.sh"]
   ```

3. 构建

   ```sh
   [root@docker kodexporer]# docker build -t kode1:v1 -f dockerfile-kode .
   ```

4. 启动容器

   ```sh
   [root@docker kodexporer]# docker run -ti -d --name kkk1 -p 85:80 kode1:v1
   ```

5. 访问web

   ```sh
   ip:85
   ```

   

