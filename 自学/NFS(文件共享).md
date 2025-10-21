# NFS

## 简介

 1. NFS（Network File System）：最大的功能就是可以通过网络，让不同的机器、不同的操作系统可以**共享彼此的文件**。
 2. NFS服务器可以让PC将网络中的NFS服务器共享的目录挂载到本地端的文件系统中，而在本地端的系统中来看，那个远程主机的目录就好像是自己的一个磁盘分区一样，在使用上相当便利。
 3. NFS一般用来存储共享视频，图片等**静态**数据。



# RPC

## 简介

**在介绍RPC之前，要先介绍一下IPC**

进程间通信（IPC，Inter-Process Communication），指至**少两个进程或线程间传送数据或信号的一些技术或方法**。进程是计算机系统分配资源的最小单位。每个进程都有自己的一部分独立的系统资源，彼此是隔离的。为了能**使不同的进程互相访问资源并进行协调工作**，才有了进程间通信。这些进程可以运行在同一计算机上或网络连接的不同计算机上。 

有两种类型的进程间通信(IPC)：

本地过程调用(LPC)：LPC用在多任务操作系统中，使得同时运行的任务能互相会话。这些任务共享内存空间使任务同步和互相发送信息。
远程过程调用(RPC)：RPC（Remote Procedure Call）——远程过程调用，它是一种通过网络从远程计算机程序上请求服务，而不需要了解底层网络技术的协议。RPC类似于LPC，只是在网上工作。RPC开始是出现在Sun微系统公司和HP公司的运行UNIX操作系统的计算机中。
为什么要用RPC呢？

我们知道，同一主机的同一程序之间因为有函数栈的存在，使得函数的相互调用很简单。但是两个程序（程序A和程序B）分别运行在不同的主机上，A想要调用B的函数来实现某一功能，那么使用常规的方法就是不可实现的，RPC就是干这个活的

总结一下就是：
RPC就是从一台机器（客户端）上通过参数传递的方式调用另一台机器（服务器）上的一个函数或方法（可以统称为服务）并得到返回的结果。
RPC 会隐藏底层的通讯细节（不需要直接处理Socket通讯或Http通讯） RPC 是一个请求响应模型。
客户端发起请求，服务器返回响应（类似于Http的工作方式） RPC 在使用形式上像调用本地函数（或方法）一样去调用远程的函数（或方法）。





# 实验

1. 在服务端安装rpc和nfs

   ```
   yum install -y nfs-utils
   yum install -y rpcbind
   ```

2. 客户端安装nfs

   ```
   yum install -y nfs-utils
   ```

3. 启动服务端nfs和rpc，并设置自启

   ```
   systemctl start rpcbind
   systemctl start nfs-utils
   
   systemctl enable rpcbind
   systemctl enable nfs-utils
   
   systemctl status rpcbind
   systemctl status nfs-utils
   
   # 查看是否设置成功自启
   systemctl list-unit-files
   ```

4. 服务端创建共享目录

   ```
   mkdir /data
   cd /data
   touch f2
   ```

5. 修改服务端配置文件

   ```
   # vim /etc/exports
   
   如果有网段限制增加如下一行：
    /data/share 172.20.32.0/24(rw,no_root_squash,insecure,sync) 
   任意IP访问增加如下一行
   /data/share *(rw,no_root_squash,insecure,sync)
   
   
   参数：
    sync 所有数据在请求时写入共享
    async nfs 在写入数据前可以响应请求
    secure nfs 通过 1024 以下的安全 TCP/IP 端口发送
    insecure nfs 通过 1024 以上的端口发送
    wdelay 如果多个用户要写入 nfs 目录，则归组写入（默认）
    no_wdelay 如果多个用户要写入 nfs 目录，则立即写入，当使用 async 时，无需此设置
    hide 在 nfs 共享目录中不共享其子目录
    no_hide 共享 nfs 目录的子目录
    subtree_check 如果共享 /usr/bin 之类的子目录时，强制 nfs 检查父目录的 权限（默认）
    no_subtree_check 不检查父目录权限
    all_squash 共享文件的 UID 和 GID 映射匿名用户 anonymous，适合公 用目录
    no_all_squash 保留共享文件的 UID 和 GID（默认）
   root_squash root 用户的所有请求映射成如 anonymous 用户一样的权限 （默认）
   no_root_squash root 用户具有根目录的完全管理访问权限
   anonuid=xxx 指定 nfs 服务器 /etc/passwd 文件中匿名用户的 UID
   anongid=xxx 指定 nfs 服务器 /etc/passwd 文件中匿名用户的 GID
   
   
   注意 ：如果在启动了NFS之后又修改了/etc/exports，可以用exportfs 命令来使改动立刻生效，该命令格式如下：
   # exportfs -rv //重新共享所有目录并输出详细信息
   # exportfs -au //卸载所有共享目录
   -a 全部挂载或卸载 /etc/exports中的内容
   　　-r 重新读取/etc/exports 中的信息 ，并同步更新/etc/exports、/var/lib/nfs/xtab
       -u 卸载单一目录（和-a一起使用为卸载所有/etc/exports文件中的目录）
   　　-v 在export的时候，将详细的信息输出到屏幕上。
   
   
   
   ```

6. 重启服务端rpc和nfs服务

   ```
   systemctl restart rpcbind
   systemctl restart nfs
   
   ```

7. 关闭防火墙

   ```
   systemctl stop firewalld.service
   ```

8. 查看

   ```
   nfsstat 查看NFS的运行状态
   
   rpcinfo 查看rpc执行信息，可以用于检测rpc运行情况的工具，利用rpcinfo -p 可查看出RPC开启的端口所提供的程序
   
   showmount
   -a 显示已经于客户端连接上的目录信息
   　　-e IP或者hostname 显示此IP地址分享出来的目录
   
   ```

9. 客户端挂载

   ```
   systemctl start nfs
   
   mount -t nfs 172.20.32.219:/data /mnt //挂载服务端data目录
   
   
   
   如果客户端需要卸载共享目录，可使用
    umount /mnt
   
   ```

10. 测试

    ```
    df 
    ```

    