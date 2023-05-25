# SCP、SSHPASS、CRONTAB、tar





# SCP（远程传输）

## 简介

> 1. **scp**就是secure copy，是用来进行**远程文件拷贝**的。数据传输使用 ssh，并且和**ssh** 使用相同的认证方式，提供相同的安全保证 。
>
> 2. **scp**不需要安装额外的软件，使用起来简单方便，安全可靠且支持限速参数但是它不支持排除目录

## 命令格式

```
scp [参数] <文件路径>  <目的地址（用户名 @IP 地址或主机名）>:<文件路径> 

例：scp /fdy.tar.gz  root@10.1.1.88:/
   scp /test/*   root@10.1.1.88:/

参数:
 -r  传输文件夹
 -v  显示传输详细
```



# sshpass

> sshpass是一款凡是为凡是使用ssl方式访问的操作提供一个**免输入密码的非交互式**操作，以便于在脚本中执行ssl操作，如ssh，scp等

## 下载

```
yum intall -y sshpass
```





# crontab定时任务

## 常用命令

```
crontab [参数]
参数：
    -e      编辑工作表
    -l      列出工作表里的命令
    -r      删除工作表
```

## 时间格式

> 1. 定时任中的时间的说明，时间的格式大概是这样的* * * * * 五个*号代表的意思分别是分，时，日，月，周的顺序来排列的
>
> 2. 如果想每分钟都执行一次的话就采用默认的 * * * * *，如果想每五分钟执行一次可以 */5 * * * * ，如果是每两个小时执行一次的话那就是 *  */2 * * *来设置; 

## 日志位置

，日志存放在：/var/log/cron文件

# tar压缩

## 命令格式

```
# tar [选项] [压缩包名]  源文件或目录
选项：
 -z   压缩和解压tar.gz格式
 -j   压缩和解压tar.bz2格式
 
 -c   打包（压缩目录和文件）
 -x   解打包
 -t   查看包
 
 -f   指定压缩包文件名
 -v   显示打包过程
 
 
一般格式：
tar -zcvf 111.tar.gz  /111
tar -zxvf 111.tar.gz

# 指定压缩包解压到tmp目录下
tar -zxvf 111.tar.gz -C /tmp
```



# 实验1

实验环境：

 主机1：192.168.223.5

 主机2：192.168.223.4

1. 安装sshpass

   ```
   yum install -y sshpass
   ```

2. 创建目录和文件

   ```
   mkdir fdy
   touch /fdy/1 /fdy/2
   ```

3. 创建脚本

   ```
   # vim s1.sh
   
   
   tar -zcvf /fdy.tar.gz /fdy
   sshpass -p "root" scp /fdy.tar.gz root@192.168.6.137:/
   
   ```

4. 赋权

   ```
   chmod 755 s1.sh
   
   # 4 = r = 读
   # 2 = w = 写
   # 1 = x = 执
   
   ```

5. 向另一台主机提供主机信息

   ```
   scp /fdy.tar.gz   root@192.168.6.137:/
   ```

   

6. 设置定时任务

   ```
   crontab -e
   
   * * * * * /bin/bash /tmp/sss.sh
   ```

7. 确认任务

   ```
   crontab -l
   ```

8. 等待定时反应





# 实验2

> 1. 因为sshpass有明文显示的风险，所以不建议使用，所以另开一个实验
> 2. 通过公私钥进行免密登录



1. 查看是否有ssh/crontabs

   ```
   rpm -qa | grep crontabs
   ```

2. 确认crond服务状态

   ```
   systemct status crond
   ```

3. 确认两机之间互通

4. 设置免密登录

   ```
   vim /etc/hosts
   ```

   ![](https://gitee.com/fan-dongyuan/ty-gallery/raw/master/%E5%B7%A5%E5%9D%8A%E5%9B%BE/host.png)

   ![](https://gitee.com/fan-dongyuan/ty-gallery/raw/master/%E5%B7%A5%E5%9D%8A%E5%9B%BE/sshkey.png)

5. 把本地主机的公钥远程复制到远程主机中

   ![](https://gitee.com/fan-dongyuan/ty-gallery/raw/master/%E5%B7%A5%E5%9D%8A%E5%9B%BE/sshcopy.png)

6. 之后便可通过crontab编写定时任务

   ![](https://gitee.com/fan-dongyuan/ty-gallery/raw/master/%E5%B7%A5%E5%9D%8A%E5%9B%BE/crontab.png)













# rsync(远程同步)

rsync 可以理解为 remote sync（远程同步），但它不仅可以远程同步数据（类似于 scp 命令），还可

以本地同步数据（类似于 cp 命令）。不同于 cp 或 scp 的一点是，使用 rsync 命令备份数据时，不会直

接覆盖以前的数据（如果数据已经存在），而是先判断已经存在的数据和新数据的差异，只有数据不同

时才会把不相同的部分覆盖。

rsync使用所谓的“rsync算法”来使本地和远程两个主机之间的文件达到同步，这个算法只传送两个文件

的不同部分，而不是每次都整份传送，因此速度相当快

chmod u/g/o+w/r/x 文件或目录

chmod u/g/o-w/r/x 文件或目录



```
举例：
chmod u+x test.sh 给test.sh 增加执行权限
chmod g+rw t2 给t2文件夹的群组增加写入权限
# ll /etc/hosts

-rw-r--r--. 1 root root 158 6月 7 2013 /etc/hosts

# chmod u=rwx /etc/hosts

# ll /etc/hosts

-rwxr--r--. 1 root root 158 6月 7 2013 /etc/hosts

# chmod u-x /etc/hosts

# ll /etc/hosts

-rw-r--r--. 1 root root 158 6月 7 2013 /etc/hosts

# ll /etc/yum.conf

-rw-r--r--. 1 root root 970 11月 5 2018 /etc/yum.conf

# chown user /etc/yum.conf

# ll /etc/yum.conf
```

-rw-r--r--. 1 user root 970 11月 5 2018 /etc/yum.con**rsync** **编译安装方法**



### **rsync**选项及功能

-v, --verbose 详细模式输出。

-q, --quiet 精简输出模式。

-c, --checksum 打开校验开关，强制对文件传输进行校验。

-a, --archive 归档模式，表示以递归方式传输文件，并保持所有文件属性，等于-rlptgoD。

-r, --recursive 对子目录以递归模式处理。

-R, --relative 使用相对路径信息。

-b, --backup 创建备份，也就是对于目的已经存在有同样的文件名时，将老的文件重新命名为

~filename。可以使用--suffix选项来指定不同的备份文件前缀。

--backup-dir 将备份文件(如~filename)存放在在目录下。

-suffix=SUFFIX 定义备份文件前缀。

--delete 删除那些DST中SRC没有的文件。

--exclude：排除文件，当然也支持排除多个文件

-e, --rsh=command 指定使用rsh、ssh方式进行数据同步



### **rsync**的三种模式

针对以上 5 种命令格式，rsync 有 5 种不同的工作模式：

1. 用于仅在本地备份数据；

2. 用于将本地数据备份到远程机器上；

3. 用于将远程机器上的数据备份到本地机器上；

3. 和第三种是相对的，同样第五种和第二种是相对的，它们各自之间的区别在于登陆认证时使

用的验证方式不同



### rsync安装方式

```
#查看本机是否安装rsync

rpm -qa | grep -i rsync

#安装rsync

yum -y install rsync

#设置开机启动

echo “/usr/local/bin/rsync --daemon -config=/etc/rsyncd.conf” >>/etc/profile

#rsync启动

rsync --daemon --config=/etc/rsyncd.conf
```

\# 源码方式安装rsync，需要到其官网下载对应的安装包。rsync官网：rsync.samba.org

```
1)下载

wget https://download.samba.org/pub/rsync/src/rsync-3.2.3.tar.gz

2)解压并安装

tar -xvf rsync-3.2.3.tar.gz

3)编译安装

# 源码安装rsync时，其编译时所需要的gcc库文件尽量提前安装完毕

# 默认安装到/usr/local/目录下

./configure

make &&make install

4)设置开机启动

echo “/usr/local/bin/rsync --daemon -config=/etc/rsyncd.conf” >>/etc/profile第三种用于将远程机器上的数据备份到本地机器上；

第四种和第三种是相对的，同样第五种和第二种是相对的，它们各自之间的区别在于登陆认证时使

用的验证方式不同。
```

1. 本地模式

把数据从一个地方复制到另一个地方（仅在一台机器增量)，相当于cp;

b:通过加参数实现删除的功能，相当于rm;

删除文件内容

c:查看属性信息，相当于ls （不重要）

2. 远程shell模式

**！！！注意：**

 **/root****： 指的是目录本身及目录下的内容。**

 **/root/** **：指的是目录下的内容。**

192.168.192.129远程-->192.168.192.130 

列出远程主机上 /tmp/目录下的文件列表



```
将本地文件/root/aaa拷贝到远程主机的/tmp下，以保证远程/tmp目录和本地/etc保持同步

[root@localhost ~]# rsync /etc/hosts /opt

[root@localhost ~]# ls /opt

hosts
```

[root@localhost ~]# mkdir /null #创建一个空目录

[root@localhost ~]# rsync -r --delete /null/ /opt/ #让前面的null目录和后面的opt目录

保持一致，都是空目录

[root@localhost ~]# ls /opt

[root@localhost ~]#

[root@localhost ~]# **rsync /etc/hosts**

-rw-r--r-- 158 2013/06/07 22:31:32 hosts

[root@192 ~]# **rsync 192.168.192.130:/usr/local/**

root@192.168.192.130's password:

drwxr-xr-x 131 2023/02/13 21:07:09 .

drwxr-xr-x 6 2018/04/11 12:59:55 bin

drwxr-xr-x 6 2018/04/11 12:59:55 etc

drwxr-xr-x 6 2018/04/11 12:59:55 games

drwxr-xr-x 6 2018/04/11 12:59:55 include

drwxr-xr-x 6 2018/04/11 12:59:55 lib

drwxr-xr-x 6 2018/04/11 12:59:55 lib64

drwxr-xr-x 6 2018/04/11 12:59:55 libexec

drwxr-xr-x 6 2018/04/11 12:59:55 sbin

drwxr-xr-x 49 2023/02/13 21:07:09 share

drwxr-xr-x 6 2018/04/11 12:59:55 src

[root@192 ~]# mkdir aaa

[root@192 ~]# ls

aaa anaconda-ks.cfg

[root@192 ~]# cd aaa

[root@192 aaa]# touch 111 222

[root@192 ~]# **rsync -r /root/aaa 192.168.192.130:/tmp**

root@192.168.192.130's password:

\------------------------------------------------------

Client2: 192.168.192.130

[root@192 tmp]# ls /tmp

aaa

[root@192 tmp]# ls aaa

111 222

[root@192 ~]# rsync -r IP:/etc /tmp # 将远程主机的/etc目录拷贝到本地/tmp下，以

保证本地/tmp目录和远程/etc保持同步
