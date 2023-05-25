# 简介

1. Tomcat是Apache软件基金会( Apache Software Foundation )的Jakarta项目中的一个核心项目，由Apache、Sun和其他一些公司及个人共同开发而成。受Java爱好者的喜爱，并得到了部分软件开发商的认可，成为目前比较流行的Web应用服务器。

2. Tomcat服务器是一个免费的[开放源代码](https://www.baidu.com/s?wd=开放源代码&tn=SE_PcZhidaonwhc_ngpagmjz&rsv_dl=gh_pc_zhidao)的Web 应用服务器，属于轻量级应用服务器，在中小型系统和并发访问用户不是很多的场合下被普遍使用，是开发和调试JSP程序的首选。目前有很多网站是用Java编写的，所以解析Java程序就必须有相关的软件来完成，Tomcat就是其中之一。

3. Java程序写的网站用**Tomcat+JDK来运行**。

4. Tomcat是一个中间件，真正起作用的，**解析Java脚本的是JDK**。

5. JDK（Java Development Kit）是整个Java的核心，它包含了Java运行环境和一堆Java相关的工具以及Java基础库。最主流的JDK为Sun公司发布的JDK，除此之外，其实IBM公司也有发布JDK，CentOS上也可以用yum安装OpenJDK。



# JDK部署

1. 下载

   ```
   # 官网下载
   http://www.oracle.com/echnetwork/java/javase/downloads/jdk8-downloads-2133151.htmlo-
   
   注意：这个下载地址不能在Linux虚拟机里使用wget命令下载，只能先通过浏览器下载到本机上，然后再上传到Linux。本次下载的版本为jdk1.8，将虚拟机连接CRT，通过CRT上传JDK到/usr/local/src/目录下
   ```

2. 安装

   ```
   /usr/local/src/
   tar -zxvf jdk-8u211-linux-x64.tar.gz 
   mv jdk1.8.0_211/  /usr/local/jdk1.8
   
   ```

3. 修改环境变量

   ```
   vim /etc/profile
   
   # 将下面内容添加到底部
   JAVA_HOME=/usr/local/jdk1.8/
   JAVA_BIN=/usr/local/jdk1.8/bin
   JRE_HOME=/usr/local/jdk1.8/jre
   PATH=$PATH:/usr/local/jdk1.8/bin:/usr/local/jdk1.8/jre/bin
   CLASSPATH=/usr/local/jdk1.8/jre/lib:/usr/local/jdk1.8/lib:/usr/local/jdk1.8/jre/lib/charsets.jar
   
   
   source /etc/profile
   ```

4. 检查安装情况

   ```
   java-version
   
   注意：有可能版本跟自己安装的不一致，是因为系统自带openjdk或者以前安装过openjdk
   
   # 查看java所在目录
   which java
   
   注意：如果结果为/usr/bin/java则说明是系统自带的openjdk，或者目录不一致的时候，可以将其重命名为java_bak
   
   mv /usr/bin/java /usr/bin/java_bak
   source /etc/profile
   # 确定版本
   java -version
   ```



# Tomcat部署

1. 官网下载

   ```
   http://tomcat.apache.org/
   ```

2. 解压

   ```
   cd /usr/local/src/
   tar -zxvf apache-tomcat-9.0.33.tar.gz 
   mv apache-tomcat-9.0.33  /usr/local/tomcat
   
   注意：本次下载解压的包是二进制包，不用我们去编译
   ```

3. 启动

   ```
    /usr/local/tomcat/bin/startup.sh 
    
    
    # 停止
    /usr/local/tomcat/bin/shutdown.sh 
   ```

4. 测试

   ```
   1. netstat -nlpt |grep java
   
   2. 浏览器打开
   ip:8080
   
   # 8080为提供Web服务的端口；
   # 8005为管理端口
   ```



# Tomcat配置

## 配置监听80

1. 修改配置文件

   ```
   vim /usr/local/tomcat/conf/server.xml
   
   # 直接搜索8080找到如下内容
   ......
       # 将这里的8080直接改成80
       <Connector port="8080" protocol="HTTP/1.1"
                  connectionTimeout="20000"
                  redirectPort="8443" />
   
   ......
   [root@tomcat ~]# 
   
   ```

2. 重启

   ```
   /usr/local/tomcat/bin/shutdown.sh 
    /usr/local/tomcat/bin/startup.sh 
    
    注意：Tomcat服务是不支持restart的方式重启服务的
   ```

3. 测试

   ```
   1. netstat  -nlpt |grep java
   
   2. 浏览器访问（默认端口80）
   ip
   
   注意：如果之前配置过其他web服务（apache、nginx），会发生端口冲突，关闭服务即可
   ```



## 配置虚拟主机

1. 修改配置文件

   ```
   vim /usr/local/tomcat/conf/server.xml 
   # 直接搜索Host
   ......
     <Host name="localhost"  appBase="webapps"
         unpackWARs="true" autoDeploy="true">
   
   # name 定义域名
   # appBase 定义应用的目录
   # unpackWARs 是否自动解压war包
   # autoDeploy true表示服务处于运行状态，能够检测appbase下的文件，如果有新的web应用加入进来，会自动发布这个web应用
   
    <!-- SingleSignOn valve, share authentication between web applications
         Documentation at: /docs/config/valve.html -->
    <!--
         <Valve className="org.apache.catalina.authenticator.SingleSignOn" />
    -->
    <!-- Access log processes all example.
         Documentation at: /docs/config/valve.html
         Note: The pattern used is equivalent to using pattern="common" -->
    <Valve className="org.apache.catalina.valves.AccessLogValve" 	directory="logs"
         prefix="localhost_access_log" suffix=".txt"
         pattern="%h %l %u %t &quot;%r&quot; %s %b" />
       </Host>
   ......
   
   
   # Java的应用通常是一个JAR的压缩包，你只需要将JAR的压缩包放到appBase目录下面即可。刚刚我访问的Tomcat默认页其实就是在appBase目录下面,不过是在它子目录ROOT里
   ```

2. 新增虚拟主机

   ```
   编辑server.xml在Host下面增加以下内容
   
   ......     
   <Host name="www.123.cn" appBase="webapps"
               unpackWARs="true" autoDeploy="true"
               xmlValidation="false" xmlNamespaceAware="false">
           <Context path="" docBase="/data/wwwroot/123.cn/" debug="0" reloadable="true" crossContext="true"/>
         </Host>
   
   # docBase 定义网站的文件存放路径，不定义，默认在appBase/ROOT下
   # appBase 应用存放目录（实际上是一个相对路径，相对于/usr/local/tomcat/ 路径），通常是需要把war包直接放到该目录下面，它会自动解压成一个程序目录
   
   ```

   

## appBase部署java应用

### 使用方式

搭建了一个Tomcat，想要使用Tomcat去跑一个网站。首先应用不能是一个传统所谓的目录（Apache、Nginx访问网站，首先需要指定一个目录，目录里存放着PHP文件或者是Html的文件，然后去访问），Tomcat需要提供一个war的包，就是一个压缩包，这个压缩包里面包含着运行这个网站的一些文件，包括配置，js代码，数据库相关的等等，都需要打包成war这种文件，而这个文件需要放置到 webapps 里面



下面我们通过部署个Java的应用来体会appBase和docBase目录的区别。

为了方便测试，下载一个zrlog（Java写的blog站点应用，轻量），：

（下载地址：http://dl.zrlog.com/release/zrlog-1.7.1-baaecb9-release.war）

### 下载

1. 下载解压

   ```
    cd /usr/local/src/
    wget http://dl.zrlog.com/release/zrlog-1.7.1-baaecb9-release.war
    
    # appBase支持自动解压，所以直接拷贝就行
    cp zrlog-1.7.1-baaecb9-release.war /usr/local/tomcat/webapps/
   ```

2. 重命名包名

   ```
    cd /usr/local/tomcat/webapps/
     mv zrlog-1.7.1-baaecb9-release zrlog
   ```

3. 测试

   ```
   浏览器访问
   ip/zrlog
   # 会出现安装向导，这是一个配置数据库的过程
   
   
   
   
   
   
   # 数据库安装
   
   rpm -qa |grep -i mariadb
   
   
   # 如果有就删除
   yum remove -y mariadb-libs
   
   
   # 设置yum源
   vi /etc/yum.repos.d/MariaDB.repo
   
   [mariadb]
   name = MariaDB
   baseurl = https://mirrors.cloud.tencent.com/mariadb/yum/10.4/centos7-amd64
   gpgkey=https://mirrors.cloud.tencent.com/mariadb/yum/RPM-GPG-KEY-MariaDB
   gpgcheck=1
   
   # 下载
   yum -y install  MariaDB-client MariaDB-server
   # 设置开启并自启
   systemctl start mariadb
   systemctl enable mariadb
   
   # 设置密码
   vim /etc/my.cnf
   
   skip-grant-tables
   
   mysql
   
   alter user 'root'@'localhost' identified by '123456';
   或
   set password for 'root'@'localhost'=password('1qaz!QAZ'); 
   
   flush privileges;
   # 重启
   systemtctl restart mariadb
   ```

4. 进入数据库创建用户

   ```
    create database zrlog;  
    grant all on zrlog.* to 'zrlog'@127.0.0.1 identified by '000000';
    flush privileges;
   ```

5. 检查是否可以登录数据库

   ```
   mysql -uzrlog -h127.0.0.1 -p000000
   ```

6. 浏览器配置

   ```
   检查完成,zrlog用户登录成功。使用 zrlog用户信息填写刚才在浏览器中打开的网页，Email填写自己的邮箱，本次是实验，填写内容为自定义邮箱（tomcat@163.com），单击“下一步”按钮
   
   设置管理员账号（admin）和管理员密码（123456），网站标题和子标题按需填写，本次自定义内容（网站标题：“测试”，网站子标题：“linux”）
   
   填写完成后，单击“下一步”按钮，可以看到安装完成的界面
   
   单击“点击查看”按钮，我们就可以进入搭建好的zrlog页面了
   
   我们也可以进入管理页面，写一些文章，单击上图主菜单栏中的“管理”按钮
   
   输入安装向导里已经设置好的账户名和密码（admin：123456），单击“登录”按钮，登录成功页面
   
   单击“文章撰写”栏目，写上自己想写的内容，然后保存
   然后回到主页面，你就可以看到刚才你写的内容。
   ```



## docBase部署java应用

### 应用场景

我们在浏览器访问zrlog需要指定IP地址加目录，那么如何才能输入IP直接访问该目录呢？

### 部署

1.  修改配置文件

   ```
   # 查看docBase路径
   vim  /usr/local/tomcat/conf/server.xml 
   
   <Host name="www.123.cn" appBase="webapps"
               unpackWARs="true" autoDeploy="true"
               xmlValidation="false" xmlNamespaceAware="false">
               # docBase 定义的目录为：/data/wwwroot/123.cn
           <Context path="" docBase="/data/wwwroot/123.cn/" debug="0" reloadable="true" crossContext="true"/>
         </Host>
   
   
   
   ```

2. 创建数据目录

   ```
   mkdir -p /data/wwwroot/123.cn/
   
   # 将/usr/local/tomcat/webapps/zrlog 中的所有文件移动到/data/wwwroot/123.cn/目录下
   mv /usr/local/tomcat/webapps/zrlog/* /data/wwwroot/123.cn/
   ```

3. Windows下绑定hosts文件

   ```
   hosts文件路径：C:\Windows\System32\drivers\etc
   在文件下面添加
   192.168.50.156 www.123.cn
   
   ```

4. 测试

   ```
   # 打开命令提示符（CMD），用ping命令ping www.123.cn 看IP是否为虚拟机IP，如果是的话，现在就可以访问了
   
   # 接下来就用域名去访问zrlog页面，由于之前配置完虚拟主机后，并没有重启服务，这里要重启一下服务
   /usr/local/tomcat/bin/shutdown.sh 
    /usr/local/tomcat/bin/startup.sh 
   ```

   

## Tomcat日志

1. 查看日志

   ```
   # Tomcat在应用过程中，难免会出现错误，如何去查看这些错误，这就需要查看Tomcat的日志。Tomcat日志存放在/usr/local/tomcat/logs/目录下
   
   ls /usr/local/tomcat/logs/
    
   # catalina开头的日志为Tomcat的综合日志，它记录Tomcat服务相关信息，也会记录错误日志
   # catalina.2022-xx-xx.log和catalina.out内容相同，前者会每天生成一个新的日志
   # host-manager和manager为管理相关的日志，其中host-manager为虚拟主机的管理日志
   # localhost和localhost-access为虚拟主机相关日志，其中带access字样的日志为访问日志，不带access字样的为默认虚拟主机的错误日志
   ```

2. 配置生成日志

   ```
   # 日志默认不会生成，需要在server.xml中配置一下
   vim /usr/local/tomcat/conf/server.xml 
   ......
         <Host name="www.123.cn" appBase="webapps"
               unpackWARs="true" autoDeploy="true"
               xmlValidation="false" xmlNamespaceAware="false">
           <Context path="" docBase="/data/wwwroot/123.cn/" debug="0" reloadable="true" crossContext="true"/>
          
    <Valve className="org.apache.catalina.valves.AccessLogValve."
                  directory="logs"
                  prefix="123.cn_access" suffix=".log"
                  pattern="%h %l %u %t &quot;%r&quot;%s %b"/>
         </Host>
   ......
   # valve为日志文件配置；
   # prefix定义访问日志的前缀；
   # suffix定义日志的后缀；
   # pattern定义日志格式
   
   注意：新增加的虚拟主机默认并不会生成类似默认虚拟主机的那个localhost.日期.log日志，错误日志会统一记录到catalina.out中。关于Tomcat日志，你最需要关注catalina.out，当出现问题时，我们应该第一想到去查看它
   ```

3. 重启

   ```
    /usr/local/tomcat/bin/shutdown.sh 
     /usr/local/tomcat/bin/startup.sh 
   ```

4. 测试

   ```
   # 重启Tomcat服务完成后，访问网站，查看/usr/local/tomcat/logs目录下是否有日志生成，并且查看生成的日志信息
   ls /usr/local/tomcat/logs
   
   cat /usr/local/tomcat/logs/123.cn_access_log.2023-02-23.log
   ```

   