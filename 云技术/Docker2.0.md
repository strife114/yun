# 配置镜像加速器

```sh
# vim /etc/docker/daemon.json
# 注意格式
{
 "registry-mirrors": ["https://b9pmyelo.mirror.aliyuncs.com"]
}

systemctl restart docker
docker info
```






# 常用镜像管理命令

```sh
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

```sh
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

1. 数据卷：将宿主机上的任意的文件或目录挂载到容器中

   ```
   docker run -it -d --name web -v /opt/wwwroot nginx 
   ```

2. 数据卷容器：其他容器挂载数据卷容器来实现

### 基本命令

>docker inspect          数据卷看数据卷信息
>
>docker run -itd -v     数据卷:容器内目录 使用某个数据卷
>
>docker volume ls      列出所有数据卷
>
>docker volume rm    数据卷删除某个数据卷

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