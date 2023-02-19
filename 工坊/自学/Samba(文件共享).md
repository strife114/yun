# Samba简介

1. **在Linux系统中，tftp、nfs和samba服务器是最常用的文件传输工具，**

2. NFS 与 Samba 一样，也是在网络中实现文件共享的一种实现，但不幸的是，其不支持 windows 平台，samba 是能够在**任何支持 SMB 协议的主机**之间共享文件的一种实现，**当然也包括 windows。**

3. Samba 是在 Linux 和 UNIX 系统上实现 SMB 协议的一个免费软件，由服务器及客户端程序构成。

4. SMB 是一种在局域网上共享文件和打印机的一种通信协议，它为局域网内的不同计算机之间提供文件及打印机等资源的共享服务。

5. SMB 协议是 C/S 型协议，客户机通过该协议可以访问服务器上的共享文件系统、打印机及其他资源。
6. samba是模仿Windows网上邻居的SMB的通讯协议，将Linux操作系统“假装成”Windows操作系统，通过网上邻居的方式来进行文件传输的。

 

# Samba服务器介绍

Samba是在Linux系统上实现SMB（Session MessageBlock）协议的一个免费软件，以实现文件共享和打印机服务共享。 

## Samba服务器组件

samba有两个主要的进程**smbd**和**nmbd**。smbd进程提供了**文件和打印服务**，而**nmbd则提供了NetBIOS名称服务和浏览支持，帮助SMB客户定位服务器，处理所有基于UDP的协议。** 

## samba 监听端口

| TCP        | UDP        |
| ---------- | ---------- |
| 139 \| 445 | 137 \| 138 |

- tcp 端口相对应的服务是 smbd 服务，其作用是提供对服务器中文件、打印资源的共享访问
- udp 端口相对应的服务是 nmbd 服务，其作用是提供基于 NetBIOS 主机名称的解析



## samba 用户

|            帐号             |                           密码                            |
| :-------------------------: | :-------------------------------------------------------: |
| /etc/passwd（都是系统用户） | Samba 服务自有密码文件通过 smbpasswd -a USERNAME 命令设置 |


都是系统用户

```
smbpasswd 命令：
    -a Sys_User     //添加系统用户为 samba 用户并为其设置密码
    -d              //禁用用户帐号
    -e              //启用用户帐号
    -x              //删除用户帐号
    
    
    

# yum -y install samba-*
# useradd tom
# smbpasswd -a tom
New SMB password:
Retype new SMB password:
Added user tom.

```

##  samba 安全级别

Samba 服务器的安全级别有三个，分别是 user，server，domain

| 安全级别 |                  作用                  |
| :------: | :------------------------------------: |
|   user   |             基于本地的验证             |
|  server  | 由另一台指定的服务器对用户身份进行认证 |
|  domain  |           由域控进行身份验证           |

以前的 samba 版本支持的安全级别有四个，分别是 share，user，server，domain
share 是用来设置匿名访问的，但现在的版本已经不支持 share 了，但是还是可以实现匿名访问的只是配置方式变了

## Samba服务器相关的配置文件

### **/etc/samba/smb.conf** （主配置文件）

这是samba的主要配置文件，基本上仅有这个文件，而且这个配置文件本身的说明非常详细。主要的设置包括服务器全局设置，如工作组、NetBIOS名称和密码等级，以及共享目录的相关设置，如实际目录、共享资源名称和权限等两大部分。

| samba 三大组成 | 作用                                                         |
| -------------- | ------------------------------------------------------------ |
| [global]       | 全局配置，此处的设置项对整个 samba 服务器都有效              |
| [homes]        | 宿主目录共享设置，此处用来设置 Linux 用户的默认共享，对应用户的宿主目录。 当用户访问服务器中与自己用户名同名的共享目录时，通过验证后将会自动映射到该用户的宿主目录中 |
| [printers]     | 打印机共享设置                                               |

​	

```
[global] #全局samba服务器全局设置，对整个服务器有效
    workgroup = WORKGROUP	#设置samba server需要加入的工作组或者域，当设置为WORKGROUP时，可以在网上共享邻居看到。
    security = user			#安全验证方式，share|user|server|domain，默认为user（需要提供用户名和密码，并由samba服务验证）

    passdb backend = tdbsam	#用户后台，smbpasswd|tdbsam|ldapsam,tdbsam：使用一个数据库文件来建立用户数据库(passdb.tdb)，默认在/etc/samba目录下。passdb.tdb用户数据库可以使用smbpasswd –a来建立Samba用户，不过要建立的Samba用户必须先是系统用户。也可以使用pdbedit命令来建立Samba账户。

    printing = cups			#打印机类型
    printcap name = cups	#指定打印机配置文件
    load printers = yes		#是否在开启 samba server 时即共享打印机。
    cups options = raw		

#########################共享文件夹的定义#####################################################
[homes]	#共享名称（特殊的，用户家目录。默认设置）
    comment = Home Directories
    valid users = %S, %D%w%S  #%S:当前服务名（如果存在), %D:当前用户所属域或工作组名称,
    browseable = No
    read only = No
    inherit acls = Yes

[printers] #共享名称 （默认设置）
    comment = All Printers
    path = /var/tmp
    printable = Yes
    create mask = 0600
    browseable = No

[print$] #共享名称，打印机驱动（默认设置）
    comment = Printer Drivers
    path = /var/lib/samba/drivers
    write list = @printadmin root
    force group = @printadmin
    create mask = 0664
    directory mask = 0775

#自定义共享文件夹
[java]	#共享名称，即客户端访问Samba服务器时浏览到的目录名，该名称不要求与本地目录名相同，但在当前Samba服务器必须唯一。如Windows访问共享文件夹时：\\ip\共享名称
    comment = share all		#提示信息，任意
    path = /root/java		#需要被共享的目录
    browseable = yes		#是yes/否no，在浏览资源中显示共享目录，若为否则必须指定共享路径才能存取
    writeable = yes			#允许写入

```

**/etc/samba/lmhosts** 

早期的 NetBIOS name 需额外设定，因此需要这个 lmhosts 的 NetBIOS name 对应的 IP 檔。 事实上它有点像是 /etc/hosts 的功能！只不过这个 lmhosts 对应的主机名是 NetBIOS name 喔！不要跟 /etc/hosts 搞混了！目前 Samba 预设会去使用你的本机名称 (hostname) 作为你的 NetBIOS name，因此这个档案不设定也无所谓。

**/etc/sysconfig/samba** 

提供启动 smbd, nmbd 时，你还想要加入的相关服务参数。

**/etc/samba/smbusers** 

由于 Windows 与 Linux 在管理员与访客的账号名称不一致，例如： administrator (windows) 及 root(linux)， 为了对应这两者之间的账号关系，可使用这个档案来设定

**/var/lib/samba/private/{passdb.tdb,secrets.tdb}** 

管理 Samba 的用户账号/密码时，会用到的数据库档案；

**/usr/share/doc/samba-<版本>** 

这个目录包含了 SAMBA 的所有相关的技术手册喔！也就是说，当你安装好了 SAMBA 之后，你的系统里面就已经含有相当丰富而完整的 SAMBA 使用手册了！值得高兴吧！ ^_^，所以，赶紧自行参考喔！
至于常用的脚本文件案方面，若分为服务器与客户端功能，则主要有底下这几个数据：

**/usr/sbin/{smbd,nmbd}**

服务器功能，就是最重要的权限管理 (smbd) 以及 NetBIOS name 查询 (nmbd) 两个重要的服务程序；

**/usr/bin/{tdbdump,tdbtool}**

服务器功能，在 Samba 3.0 以后的版本中，用户的账号与密码参数已经转为使用数据库了！Samba 使用的数据库名称为 TDB (Trivial DataBase)。 
既然是使用数据库，当然要使用数据库的控制指令来处理啰。tdbdump 可以察看数据库的内容，tdbtool 则可以进入数据库操作接口直接手动修改帐密参数。不过，你得要安装 tdb-tools 这个软件才行；

**/usr/bin/smbstatus**

服务器功能，可以列出目前 Samba 的联机状况， 包括每一条 Samba 联机的 PID, 分享的资源，使用的用户来源等等，让你轻松管理 Samba 啦；

**/usr/bin/{smbpasswd,pdbedit}**

服务器功能，在管理 Samba 的用户账号密码时， 早期是使用 smbpasswd 这个指令，不过因为后来使用 TDB 数据库了，因此建议使用新的 pdbedit 指令来管理用户数据；

**/usr/bin/testparm**

服务器功能，这个指令主要在检验配置文件 smb.conf 的语法正确与否，当你编辑过 smb.conf 
时，请务必使用这个指令来检查一次，避免因为打字错误引起的困扰啊！

**/sbin/mount.cifs**

客户端功能，在 Windows 上面我们可以设定『网络驱动器机』来连接到自己的主机上面。在 Linux 上面，我们则是透过 mount (mount.cifs) 来将远程主机分享的档案与目录挂载到自己的 Linux 主机上面哪！

**/usr/bin/smbclient**

客户端功能，当你的 Linux主机想要藉由『网络上的芳邻』的功能来查看别台计算机所分享出来的目录与装置时，就可以使用 smbclient来查看啦！这个指令也可以使用在自己的 SAMBA 主机上面，用来查看是否设定成功哩！

**/usr/bin/nmblookup**

客户端功能，有点类似 nslookup 啦！重点在查出 NetBIOS name 就是了

**/usr/bin/smbtree**

客户端功能，这玩意就有点像 Windows 
系统的网络上的芳邻显示的结果，可以显示类似『靠近我的计算机』之类的数据， 能够查到工作组与计算机名称的树状目录分布图！





## 常用配置指定用户参数

| 参数           | 作用                                                         |
| -------------- | ------------------------------------------------------------ |
| workgroup      | 表示设置工作组名称                                           |
| server string  | 表示描述 samba 服务器                                        |
| security       | 表示设置安全级别，其值可为 share、user、server、domain       |
| passdb backend | 表示设置共享帐户文件的类型，其值可为 tdbsam(tdb数据库文件)、ldapsam(LDAP目录认证)、smbpasswd(兼容旧版本 samba 密码文件) |
| comment        | 表示设置对应共享目录的注释，说明信息，即文件共享名           |
| browseable     | 表示设置共享是否可见                                         |
| writable       | 表示设置目录是否可写                                         |
| path           | 表示共享目录的路径                                           |
| guest ok       | 表示设置是否所有人均可访问共享目录                           |
| public         | 表示设置是否允许匿名用户访问                                 |
| write list     | 表示设置允许写的用户和组，组要用 @ 表示，例如 write list = root,@root |
| valid users    | 设置可以访问的用户和组，例如 valid users = root,@root        |
| hosts deny     | 设置拒绝哪台主机访问，例如 hosts deny = 192.168.10.100       |
| hosts allow    | 设置允许哪台主机访问，例如 hosts allow = 192.168.10.200      |
| printable      | 表示设置是否为打印机                                         |


​	

​	

# 实验1（Linux和windows共享文件夹）

1. 安装

   ```
   yum install -y samba
   
   ```

2. 关闭安全机制

   ```
   systemctl stop firewalld.service
   setenforce 0
   ```

3. 创建共享目录并赋权

   ```
   mkdir /fdy
   touch /fdy/1 /fdy/2
   chmod 777 /fdy
   ```

4. 创建系统用户

   ```
   useradd -s /sbin/nologin f1
   
   注意：创建正常用户和非登录用户都可以使用共享
   ```
   
5. 配置

   ```
   vim /etc/samba/smb.conf
   
   
   
   [Share]
   comment=this is samba fir
   path = /fdy
   writable=yes
   browseable=yes
   ```

6. 设置samba用户和密码

   ```
   smbpasswd -a f1
   
   ```

7. 重启服务

   ```
   systemctl restart smb
   ```

8. windows打开文件管理器输入ip

   ```
   Share代表的就是设置的path目录，而且此共享会带上本用户的家目录
   ```

   



注意（权限不足）：

1. 解决该问题的办法也很简单，如果只是本地调试使用，建议还是按照案例，将path设置在根目录，再修改共享文件权限即可。如path=/share，chmod 777 share/ -R就可以解决问题
2. setenforce 0
3. 刷新凭证

   ```
   # 之前有记录凭证
   net use * /delete /y
   ```

   



实验2（Linux和Linux共享文件夹）

1. 安装

   ```
   yum install -y samba
   ```

2. 关闭安全机制

   ```
   systemctl stop firewalld.service
   setenforce 0
   ```

3. 创建共享目录并赋权

   ```
   mkdir /fdy
   touch /fdy/1 /fdy/2
   chmod 777 /fdy
   ```

4. 创建系统用户

   ```
   useradd -s /sbin/nologin ff
   
   注意：创建正常用户和非登录用户都可以使用共享
   ```

5. 配置

   ```
   vim /etc/samba/smb.conf
   
   
   
   [JAVA]
   comment=this is samba fir
   path = /fdy
   writable=yes
   browseable=yes
   ```

6. 设置samba用户

   ```
   smbpasswd -a ff
   
   ```

7. 客户端访问文件夹

   ```
   1. 挂载本地的方式访问
   mount -t cifs -o username=ff,password=123456 //192.168.223.6/ff  /disk
   
   2. 直接访问共享目录（需安装samba-client）
   #查看该用户在目的地址上可访问的共享文件夹
   smbclient -L //ip -U 用户名 
   # 进入交互模式，可直接用ls命令查看文件
   smbclient //ip/共享名称 -U 用户名
   
   smbclient -L //192.168.223.6 -U ff
   smbclient  //192.168.223.6/java -U ff
   
   ```

   







