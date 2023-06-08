# 介绍

## CI/CD

1. CI：中文意思是**持续集成**，是一种软件开发实践。持续集成强调开发人员提交了新代码之后，立刻进行构建、测试.根据测试结果，我们可以确定新代码和原有代码能否正确地集成在一起。持续集成是实现持续交付和持续部署的基础，它确保了代码在被提交到共享代码库之前经过了测试和验证。
2. CD：中文意思是**持续交付**，是在持续集成的基础上，将集成后的代码部署到**最贴近真实运行环境**（类生产环境）。比如，我们完成单元测试后，可以把代码部署到连接数据库的Staging环境中更多的测试。如果代码没有问题，可以继续手动部署到生产环境。持续交付要求软件构建、测试和部署都需要进行自动化，并且可以在任何时候快速地部署到生产环境中。
3. CDP：中文意思是**持续部署**，是一种**更进一步的持续交付**。在持续部署中，软件构建和测试后会自动部署到生产环境中，**无需手动干预**。持续部署依赖于持续交付和持续集成，并可将其自动化程度提高到一个新级别。

## Gitlab持续集成

1. 继承团队中每个开发人员提交的代码到代码存储库中
2. 开发人员在merge或者pull请求中合并拉取新代码
3. 在提交或者合并更改到代码库之前，会触发构建，测试和新代码验证的管道
4. CI可帮助在开发周期的早期发现并减少错误

## Gitlab持续交付

1. 可通过结构化的部署管道确保将经过CI验证的代码交付给你的应用程序
2. CD可以将经过验证的代码更快地移至你的应用程序



## 持续系列的工作过程

**提交**
流程的第一论，是开发者向代码仓库提交代码。所有后面的步骤都始于本地代码的一次提交(commit)
**测试(第一轮)**
代码仓库对commit操作配置了钩子(hook)，只要提交代码或者合并进主干，就会跑自动化测试.
**构建**
通过第一轮测试，代码就可以合并进主干。就算可以交付了。
交付后，就先进行构建(build)，再进入第二轮测试。所谓构建，指的是将源码转换为可以运行的实际代码,比如安装依赖,配置各种资源〔样式表、JS脚本、图片)等等。
**测试(第二轮)**
构建完成，就要进行第二轮测试。如果第一轮已经涵盖了所有测试内容，第二轮可以省略，当然，这时构建步骤也要移到第一轮测试前面。
**部署**
过了第二轮测试，当前代码就是一个可以直接部署的版本(artifact)。将这个版本的所有文件打包(tarfilename.tar*]存档,发到生产服务器。
**回滚**
一旦当前版本发生问题，就要回滚到上一个版本的构建结果。最简单的做法就是修改一下符号链接，

## Gitlab CI/CD工作原理

1. 将代码托管到git存储库中
2. 在项目根插件ci文件.gitlab-ci.yml，在文件中指定构建，测试和部署脚本
3. gitlab将检测到它并使用名为gitlab runner的工具运行脚本
4. 脚本被分组为作业，它们共同组成了一个管道



## CI/CD优势

1. 开源：CI/CD是开源gitlab社区版和专有gitlab企业版的一部分
2. 易于学习：具有详细的入门文档
3. 无缝集成：gitlab的CI/CD是gitlab的一部分，支持从计划到部署，具有出色的用户体验
4. 可扩展：测试可以在单独的计算机上分布式运行，可以根据需要添加任意数量的计算机
5. 更快的结果：每个构建可以拆分为多个作业，这些作业可以在多态计算机上并行运行
6. 针对交付进行了优化：多个阶段、手动部署、环境和变量

## CI/CD特点

1. 多平台：UNIX,WINDOWS,macOS和任何其他支持GO的平台上执行构建
2. 多语言：构建脚本是命令行驱动的，并且可以与java、php、ruby、c和其他语言一起使用
3. 稳定构建：构建在gitlab不同的机器上运行
4. 并行构建：gitlab CI/CD在多台机器上拆分构建，以实现快速执行
5. 实时日志记录：合并请求中的链接将您带到动态更新的当前构建日志
6. 灵活的管道：您可以在每个阶段定义多个并行作业，并且可以触发其他构建
7. 版本管道：一个.gitlab-cy.yml文件包含你的测试，整个过程步骤，是每个人都能贡献更改，并确保每个分支获得所需的管道
8. 自动缩放：你可以自动缩放构建机器，以确保立即处理你的构建并降低成本
9. 构建工件：你可以将二进制文件和其他构建工件尚在到gitlab并浏览和下载它们
10. docker支持：可以使用自定义docker镜像，作为测试的一部分启动服务，构建新的dockers镜像，甚至可以在k8s上运行。
11. 容器注册表：内置的容器注册表，用于存储、共享和使用容器镜像
12. 受保护的变量：部署期间的使用受每个环境保护的变量安全地存储和使用机密
13. 环境：定义多个环境





# Jenkins

## 简介

1. Jenkins是一个广泛用于持续集成的可视化web自动化工具，Jenkins可以很友好的支持各种语言的项目构建，也可以完全兼容ant maven、gradle等多种第三方构建工具，同时跟svn git能无缝集成，也支持直接与知名源代码托管网站，比如 github、bitbucket直接集成，而且插件众多，在这么多年的"技术积累之后，在国内大部分公司都有使用Jenkins。
2. Jenkins是哟个开源软件项目，是基于java开发的一种持续集成工具，主要做的事情就是从git中拉取代码，根据配置信息打包；把打好的包传输到目标服务器，并可以执行一些shell脚本，使项目打包发布一键完成
3. 官网：https://www.jenkins.io/
   ![](https://strife.oratun.cn/%E5%9B%BE%E5%BA%8A/jenkins/jenkins%E8%A7%84%E5%88%92.png)

4. 首先，开发人员每天进行代码提交，提交到git仓库
5. 然后，jenkins作为持续集成工具，使用Git工具到Git仓库拉取代码到集成服务器，再配合JDK、Maven等软件完成代码编译，代码测试与审查，测试，打包等工作，在这个过程中每一步出错，都重新再执行一次整个流程。
6. 最后，Jenkins把生成的jar或war包分发到测试服务器或者生产服务器，测试人员或用户就可以访问应用。



# Gitlab

## 简介

GitLab是一个用于仓库管理系统的开源项目，使用Git作为代码管理工具，并在此基础上搭建起来的web服务。

## Gitlab和Github区别

GitLab和GitHub一样属于第三方基于Git开发的作品，免费且开源（基于MIT协议)，与Github类似，可以注册用户，任意提交你的代码，添加SSHKey等等。不同的是，GitLab是可以部署到自己的服务器上，数据库等一切信息都掌握在自己手上，适合团队内部协作开发。
Github服务器在别人手上，所有的代码需要上传到别人的服务器上。Gitlab可以看作是一个个人版的Github.



# 实验环境

| IP              | 主机    | 节点规划                   |
| --------------- | ------- | -------------------------- |
| 192.168.223.101 | jenkins | Jenkins服务器              |
| 192.168.223.100 | gitlab  | Gitlab仓库服务器（12.4.2） |
| 192.168.223.3   | tomcat  | Tomcat测试机               |

# Gitlab

## 安装

### 资源网

```sh
https://packages.gitlab.com/gitlab/gitlab-ce
```

### Gitlab7.13

#### 安装1

1. 安装依赖包

   ```sh
   [root@gitlab ~]# yum -y install policycoreutils openssh-server openssh-clients postfix
   ```

2. 安装存储库

   ```sh
   [root@gitlab ~]# curl -s https://packages.gitlab.com/install/repositories/gitlab/gitlab-ce/script.rpm.sh | sudo bash
   ```

3. 安装gitlab

   ```sh
   [root@gitlab ~]# yum install gitlab-ce-7.13.0-ce.0.el7.x86_64 -y --nogpgcheck
   ```

#### 安装2

1. 安装依赖包

   ```sh
   [root@gitlab ~]# yum -y install policycoreutils openssh-server openssh-clients postfix
   ```

2. 下载rpm包

   ```sh
   [root@gitlab ~]# wget --content-disposition https://packages.gitlab.com/gitlab/gitlab-ce/packages/el/7/gitlab-ce-7.13.0-ce.0.el7.x86_64.rpm/download.rpm
   ```

3. 安装

   ```sh
   [root@gitlab ~]# rpm -ivh gitlab-ce-7.13.0-ce.0.el7.x86_64.rpm
   ```

#### 重置密码

1. 切换相应路径

   ```sh
   [root@gitlab ~]# cd /opt/gitlab/bin/
   ```

2. 进入控制台

   ```sh
   [root@gitlab ~]# gitlab-rails console
   ```

3. 查询root用户账号信息并赋值给u

   ```sh
   u=User.find(1)
   ```

4. 设置密码

   ```sh
   u.password='root123456'
   
   # 确认密码（非必须）
   u.password_confirmation = 'root123456'
   ```

5. 保存设置

   ```sh
   u.save!
   ```

#### 解锁用户

```sh
user=User.where(email:'jenkins@domain.com').first
=> #<User id:22 @jenkins>
irb(main):013:0> user.unlock_access!
=> true
irb(main):014:0>
```

### Gitlab12.10.14

1. 下载rpm包

   ```sh
   [root@gitlab ~]# wget --no-check-certificate https://mirrors.tuna.tsinghua.edu.cn/gitlab-ce/yum/el7/gitlab-ce-12.10.14-ce.0.el7.x86_64.rpm 
   ```

2. 安装依赖包

   ```sh
   [root@gitlab ~]# yum -y install policycoreutils openssh-server openssh-clients postfix
   [root@gitlab ~]# yum install -y policycoreutils-python
   ```

3. 安装rpm

   ```sh
   [root@gitlab ~]# rpm -ivh gitlab-ce-12.10.14-ce.0.el7.x86_64.rpm
   ```

4. 下载git工具

   ```sh
   [root@gitlab ~]# yum install -y git
   ```

   

## Gitlab配置

1. 修改配置文件

   ```sh
   [root@gitlab ~]# vim /etc/gitlab/gitlab.rb
   # 修改
   external_url 'http://192.168.223.100:82'
   # 取消注释并修改
   nginx['listen_port'] = 82
   # 取消注释
   unicorn['worker_processes'] = 2
   ```

2. 重载配置

   ```sh
   [root@gitlab ~]# gitlab-ctl reconfigure
   ```

3. 重启服务并设置自启

   ```sh
   [root@gitlab ~]# gitlab-ctl restart #重启服务
   
   
   #开机自启
   [root@gitlab ~]# systemctl enable gitlab-runsvdir.service
   ```

4. 浏览器访问

   ```
   192.168.223.100:82
   
   # 设置新密码
   
   # 用户：root
   # 密码：新密码
   
   ```

5. 创建用户组

   ![](https://gitee.com/Strife-Dispute/ty-gallery/raw/master/%E5%B7%A5%E5%9D%8A%E5%9B%BE/jenkins/gitlab1.png)

6. 在用户组中创建项目

   ![](https://gitee.com/Strife-Dispute/ty-gallery/raw/master/%E5%B7%A5%E5%9D%8A%E5%9B%BE/jenkins/gitlab2.png)

## 代码拉取和上传

1. 配置用户和邮箱

   ```sh
   [root@gitlab ~]# git config --global user.name "root"
   [root@gitlab ~]# git config --global user.email 1272776782@qq.com
   ```

2. 拉取项目

   ```sh
   [root@gitlab ~]# git clone http://192.168.223.100:82/test/web-test.git
   
   [root@gitlab ~]# cd web-test
   [root@gitlab web-test]# ls
   README.md
   ```

3. 推送项目

   ```sh
   # 上传一个文档到此目录
   [root@gitlab web-test]# ls
   README.md  私有云部署.md
   
   # 代码上传工作区
   [root@gitlab web-test]# git add .
   # 提交代码申明
   [root@gitlab web-test]# git commit -am "11"
   # 推送代码
   [root@gitlab web-test]# git push origin master
   ```

4. 创建用户

   ![](https://gitee.com/Strife-Dispute/ty-gallery/raw/master/%E5%B7%A5%E5%9D%8A%E5%9B%BE/jenkins/gitlab3.png)

   ![](https://gitee.com/Strife-Dispute/ty-gallery/raw/master/%E5%B7%A5%E5%9D%8A%E5%9B%BE/jenkins/gitlab4.png)

5. 修改密码

   ![](https://gitee.com/Strife-Dispute/ty-gallery/raw/master/%E5%B7%A5%E5%9D%8A%E5%9B%BE/jenkins/gitlab5.png)

   ![](https://gitee.com/Strife-Dispute/ty-gallery/raw/master/%E5%B7%A5%E5%9D%8A%E5%9B%BE/jenkins/gitlab6.png)

6. 添加用户到组

   ![](https://gitee.com/Strife-Dispute/ty-gallery/raw/master/%E5%B7%A5%E5%9D%8A%E5%9B%BE/jenkins/gitlabzu1.png)

7. 使用新用户登录

   ![](https://gitee.com/Strife-Dispute/ty-gallery/raw/master/%E5%B7%A5%E5%9D%8A%E5%9B%BE/jenkins/gitlabzu2.png)



## Gitlab全局备份

1. 修改gitlab配置文件

   ```sh
   [root@gitlab ~]# vim /etc/gitlab/gitlab.rb 
   # 搜索Backup关键词可到达
   
   gitlab_rails['manage_backup_path'] = true
   gitlab_rails['backup_path'] = "/var/opt/gitlab/backups"
   
   ###! Docs: https://docs.gitlab.com/ee/raketasks/backup_restore.html#backup-archive-permissions
   gitlab_rails['backup_archive_permissions'] = 0644
   
   # gitlab_rails['backup_pg_schema'] = 'public'
   
   ###! The duration in seconds to keep backups before they are allowed to be deleted
   gitlab_rails['backup_keep_time'] = 7776000
   
   ```

2. 全局备份

   ```sh
   [root@gitlab ~]# gitlab-rake gitlab:backup:create
   
   
   # 查看归档包
   [root@gitlab backups]# pwd
   /var/opt/gitlab/backups
   [root@gitlab backups]# ls
   1685666715_2023_06_01_12.10.14_gitlab_backup.tar
   ```

3. 删除本机上的所有项目

4. 恢复

   ```sh
   [root@gitlab ~]# gitlab-rake gitlab:backup:restore BACKUP=1685666715_2023_06_01_12.10.14
   
   
   
   # 注意
   1. gitlab-rake gitlab:backup:restore BACKUP=数据编号（绝对路径）有可能需要绝对路径，一般来说是配置文件设置了自己想要的路径后才会需要绝对路径
   2. 恢复的时候可能需要关闭数据库进程
   
   # 解决方法
   2. gitlab-ctl stop unicorn
      gitlab-ctl stop sidekiq
   ```

5. 补充

   ```sh
   [root@gitlab backups]# ls
   1685666715_2023_06_01_12.10.14_gitlab_backup.tar  db            tmp
   artifacts.tar.gz                                  lfs.tar.gz    uploads.tar.gz
   backup_information.yml                            pages.tar.gz
   builds.tar.gz                                     repositories
   
   
   # 全量备份时考虑到有些内容不需要备份，否则备份文件过大，拷贝起来比较缓慢，筛选信息，首先看一下备份文件说明：
   db                       # 数据库备份：主要为PostgreSQL数据库数据内容
   uploads                  # 附件数据备份
   repositories             # Git仓库数据备份
   builds                   # CI 作业输入日志等数据备份
   artifacts                # CI 作业工件数据备份（artifacts用于指定在job 成功或失败 时应附加到作业的文件和目录的列表。）
   lfs                      # LFS对象数据备份
   registry                 # 容器镜像备份
   pages                    # GitLab Pages content，页面内容数据备份
   # 这些文件会在恢复后在备份目录产生
   ```

   







# Jenkins

## 安装

1. 安装jdk

   ```sh
   [root@localhost ~]# rpm -ivh jdk-11.0.19_linux-x64_bin.rpm
   
   
   # jdk下载
   https://strife.oratun.cn/yun/%E6%BA%90%E7%A0%81%E5%8C%85/jdk-11.0.19_linux-x64_bin.rpm
   ```

2. 安装jenkins

   ```sh
   # 安装yum源
   [root@jenkins ~]# wget --no-check-certificate -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
   # 安装key
   [root@jenkins ~]# rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
   # 安装依赖
   [root@jenkins ~]# yum -y install fontconfig java-11-openjdk
   # 安装Jenkins
   [root@jenkins ~]# yum -y install jenkins
   
   # 本实验为2.401.1版本
   ```

3. 修改配置文件

   ```sh
   [root@jenkins ~]# vim /etc/sysconfig/jenkins
   JENKINS_PORT="8080" #修改默认端口，根据所需修改
   # 修改执行用户
   JENKINS_USER="root"
   ```

4. 启动服务并设置自启

   ```sh
   [root@jenkins ~]# systemctl start jenkins
   [root@jenkins ~]# systemctl enable jenkins
   ```

5. 浏览器访问ip:8080

6. 输入初始密码

   ```sh
   [root@jenkins ~]# cat /var/lib/jenkins/secrets/initialAdminPassword 
   81f8c8c820fc42f891bc5e55af261ccd
   ```

   ![](https://gitee.com/Strife-Dispute/ty-gallery/raw/master/%E5%B7%A5%E5%9D%8A%E5%9B%BE/jenkins/jenkins1.png)

7. 选择自定义插件

   选择完后取消所有插件选择（当然也可以全部选择安装，或者安装自己需要的，这样之后不用去特地搜索插件安装）

   ![](https://gitee.com/Strife-Dispute/ty-gallery/raw/master/%E5%B7%A5%E5%9D%8A%E5%9B%BE/jenkins/jenkins2.png)

8. 选择直接使用admin用户

   ![](https://gitee.com/Strife-Dispute/ty-gallery/raw/master/%E5%B7%A5%E5%9D%8A%E5%9B%BE/jenkins/jenkins3.png)

9. 其他默认即可

10. 设置中文汉化

   ![](https://gitee.com/Strife-Dispute/ty-gallery/raw/master/%E5%B7%A5%E5%9D%8A%E5%9B%BE/jenkins/jenkins4.png)

   ![](https://gitee.com/Strife-Dispute/ty-gallery/raw/master/%E5%B7%A5%E5%9D%8A%E5%9B%BE/jenkins/jenkins5.png)

11. 重启jenkins服务（安装插件后有一个复选框可以重启jenkins）

12. 使用admin用户进入（密码为初始密码）

13. 修改admin密码

    ![](https://gitee.com/Strife-Dispute/ty-gallery/raw/master/%E5%B7%A5%E5%9D%8A%E5%9B%BE/jenkins/jenkins6.png)



## jenkins配置钉钉告警

1. 在钉钉上创建一个群，然后创建一个机器人，需要几个关键词

   ```
   # web链接
   Webhook：
   # 为了安全使用
   加签
   ```

2. 添加钉钉插件

   ![](https://gitee.com/Strife-Dispute/ty-gallery/raw/master/%E5%B7%A5%E5%9D%8A%E5%9B%BE/jenkins/jenkinsdd1.png)

   ![](https://gitee.com/Strife-Dispute/ty-gallery/raw/master/%E5%B7%A5%E5%9D%8A%E5%9B%BE/jenkins/jenkinsdd2.png)

   ![](https://gitee.com/Strife-Dispute/ty-gallery/raw/master/%E5%B7%A5%E5%9D%8A%E5%9B%BE/jenkins/jenkinsdd3.png)

3. 配置钉钉

   ![](https://gitee.com/Strife-Dispute/ty-gallery/raw/master/%E5%B7%A5%E5%9D%8A%E5%9B%BE/jenkins/jenkinsdd5.png)

   在最下面找到钉钉组件设置钉钉

   关键配置：

   名称：jenkins

   webhook：**********************

   加密：（加签）

   ![](https://gitee.com/Strife-Dispute/ty-gallery/raw/master/%E5%B7%A5%E5%9D%8A%E5%9B%BE/jenkins/jenkinsdd4.png)

4. 测试钉钉告警

   插件一个名称构建一个自由风格的软件项目

   ![](https://gitee.com/Strife-Dispute/ty-gallery/raw/master/%E5%B7%A5%E5%9D%8A%E5%9B%BE/jenkins/jenkinsdd6.png)

   选择钉钉机器人jenkins

   ![](https://gitee.com/Strife-Dispute/ty-gallery/raw/master/%E5%B7%A5%E5%9D%8A%E5%9B%BE/jenkins/jenkinsdd7.png)

   通知人选择所有并保存配置

   ![](https://gitee.com/Strife-Dispute/ty-gallery/raw/master/%E5%B7%A5%E5%9D%8A%E5%9B%BE/jenkins/jenkinsdd8.png)

   构建工程触发告警

   ![](https://gitee.com/Strife-Dispute/ty-gallery/raw/master/%E5%B7%A5%E5%9D%8A%E5%9B%BE/jenkins/jenkinsdd9.png)

   ![](https://gitee.com/Strife-Dispute/ty-gallery/raw/master/%E5%B7%A5%E5%9D%8A%E5%9B%BE/jenkins/jenkinsdd10.png)







# 自动化部署tomcat

1. 建立互信

   ```sh
   # gitlab互信
   [root@gitlab ~]# ssh-keygen
   [root@gitlab ~]# ssh-copy-id 192.168.223.101
   [root@gitlab ~]# ssh-copy-id 192.168.223.3
   
   
   
   # jenkins互信
   [root@jenkins ~]# ssh-keygen
   [root@jenkins ~]# ssh-copy-id 192.168.223.100
   [root@jenkins ~]# ssh-copy-id 192.168.223.3
   
   # 修改jenkins用户权限
   # 修改为/bin/bash
   jenkins:x:997:995:Jenkins Automation Server:/var/lib/jenkins:/bin/bash
   [root@jenkins ~]# su jenkins
   bash-4.2$ ssh-keygen
   bash-4.2$ ssh-copy-id 192.168.223.3
   
   # 将jenkins和gitlab互信起来
   [root@jenkins ~]# cd .ssh/
   [root@jenkins .ssh]# ls
   authorized_keys  id_rsa  id_rsa.pub  known_hosts
   [root@jenkins .ssh]# cat id_rsa.pub
   # 将数据复制
   # 点击gitlabweb页面的右上角用户，点击设置，选择ssh密钥，粘贴即可（有提示）
   
   
   # tomcat互信
   [root@tomcat ~]# ssh-keygen
   [root@tomcat ~]# ssh-copy-id 192.168.223.100
   [root@tomcat ~]# ssh-copy-id 192.168.223.101
   ```

2. jenkins服务器安装组件

   ```sh
   [root@jenkins ~]# yum update -y
   
   # 安装git
   [root@jenkins ~]# yum install -y git
   # 查看git版本
   [root@jenkins ~]# git --version
   
   
   
   # 安装maven
   [root@jenkins ~]# wget https://mirrors.cnnic.cn/apache/maven/maven-3/3.8.8/binaries/apache-maven-3.8.8-bin.tar.gz
   # 创建目录
   [root@jenkins ~]# mkdir /usr/local/maven
   [root@jenkins ~]# chmod 755 /usr/local/maven
   # 解压
   [root@jenkins ~]# tar zxvf apache-maven-3.5.4-bin.tar.gz -C /usr/local/maven
   
   
   
   
   # 配置maven和java的环境变量
   [root@jenkins ~]# vim /etc/profile
   # 末尾添加
   export JAVA_HOME=/usr/lib/jvm/jdk-11-oracle-x64
   export JRE_HOME="$JAVA_HOME/jre"
   export PATH=$PATH:$JAVA_HOME/bin:$JRE_HOME/bin
   export MAVEN_HOME=/usr/local/maven
   export PATH=$PATH:$MAVEN_HOME/bin
   # 这里的java也没有jre的路径，所以环境变量可不配置jre的环境
   
   # 生效
   [root@jenkins ~]# source /etc/profile
   
   # 查看maven版本
   [root@jenkins ~]# mvn -version
   Apache Maven 3.8.8 (4c87b05d9aedce574290d1acc98575ed5eb6cd39)
   Maven home: /usr/local/maven
   Java version: 11.0.19, vendor: Oracle Corporation, runtime: /usr/lib/jvm/jdk-11-oracle-x64
   Default locale: en_US, platform encoding: UTF-8
   OS name: "linux", version: "3.10.0-1160.el7.x86_64", arch: "amd64", family: "unix"
   
   
   
   # web页面添加插件
   1. Maven Integration plugin
   2. git plugin
   3. Release Plugin
   4. Maven Release Plug-in(选，本实验未安装)
   ```

3. tomcat服务部署Java

   ```sh
   [root@tomcat ~]# rpm -ivh jdk-11.0.19_linux-x64_bin.rpm 
   [root@tomcat ~]# vim /etc/profile
   # 末尾添加
   export JAVA_HOME=/usr/lib/jvm/jdk-11-oracle-x64
   export JRE_HOME="$JAVA_HOME/jre"
   export PATH=$PATH:$JAVA_HOME/bin:$JRE_HOME/bin
   
   [root@tomcat ~]# mkdir /usr/local/tomcat
   # 本文档中tomcat部署并没有用到jre，这里的java也没有jre的路径，所以环境变量可不配置jre的环境
   ```

4. 配置启动脚本

   ```sh
   [root@jenkins fdy]# cat tomcat.sh 
   #!/bin/bash
   # 后面因为自动化项目名的不同，tomcats1也会相应更改
   rsync -avzh /var/lib/jenkins/workspace/tomcats1/*  root@192.168.223.3:/usr/local/tomcat/
   ssh root@192.168.223.3 "/usr/local/tomcat/bin/shutdown.sh"
   sleep 3
   ssh root@192.168.223.3 "/usr/local/tomcat/bin/startup.sh"
   
   ```

   

5. 配置全局工具

   Dashboard---》系统管理----》全局工具配置

   Mavne配置

   ![](https://gitee.com/Strife-Dispute/ty-gallery/raw/master/%E5%B7%A5%E5%9D%8A%E5%9B%BE/jenkins/goju1.png)

   JDK配置

   ![](https://gitee.com/Strife-Dispute/ty-gallery/raw/master/%E5%B7%A5%E5%9D%8A%E5%9B%BE/jenkins/goju2.png)

   Git安装

   ![](https://gitee.com/Strife-Dispute/ty-gallery/raw/master/%E5%B7%A5%E5%9D%8A%E5%9B%BE/jenkins/goju3.png)

   Maven安装

   ![](https://gitee.com/Strife-Dispute/ty-gallery/raw/master/%E5%B7%A5%E5%9D%8A%E5%9B%BE/jenkins/goju4.png)

6. gitlab上传项目

   ```sh
   [root@gitlab fdy]# wget https://strife.oratun.cn/yun/%E6%BA%90%E7%A0%81%E5%8C%85/tomcats1-master.zip
   [root@gitlab fdy]# unzip tomcats1-master.zip
   [root@gitlab fdy]# ls
   bin              lib        modules    RELEASE-NOTES  target               webapps
   BUILDING.txt     LICENSE    NOTICE     res            temp
   conf             logs       pom.xml    RUNNING.txt    test
   CONTRIBUTING.md  MERGE.txt  README.md  ssltest.jar    tomcats1-master.zip
   [root@gitlab fdy]# rm -rf tomcats1-master.zip
   
   # 赋予执行权限（因为是实验环境这里赋予最大权限）
   [root@gitlab fdy]# chmod 777 -R *
   
   # 推送项目
   [root@gitlab fdy]# git init
   [root@gitlab fdy]# git remote add origin git@192.168.223.100:root/tomcats1.git
   [root@gitlab fdy]# git add .
   [root@gitlab fdy]# git commit -am "1"
   [root@gitlab fdy]# git push origin master
   
   
   # 注意
   1. 空目录logs无法上传，因为git推送无法推送空目录，直接在gitlab的项目上主页面点击+号创建目录即可
   ```

7. 开始创建maven项目

   ![](https://gitee.com/Strife-Dispute/ty-gallery/raw/master/%E5%B7%A5%E5%9D%8A%E5%9B%BE/jenkins/maven1.png)

   配置钉钉通知

   ![](https://gitee.com/Strife-Dispute/ty-gallery/raw/master/%E5%B7%A5%E5%9D%8A%E5%9B%BE/jenkins/peizhi1.png)

   配置目标源码库

   ![](https://gitee.com/Strife-Dispute/ty-gallery/raw/master/%E5%B7%A5%E5%9D%8A%E5%9B%BE/jenkins/peizhi2.png)

   ![](https://gitee.com/Strife-Dispute/ty-gallery/raw/master/%E5%B7%A5%E5%9D%8A%E5%9B%BE/jenkins/peizhi3.png)

   构建触发器

   ![](https://gitee.com/Strife-Dispute/ty-gallery/raw/master/%E5%B7%A5%E5%9D%8A%E5%9B%BE/jenkins/peizhi4.png)

   构建环境

   ![](https://gitee.com/Strife-Dispute/ty-gallery/raw/master/%E5%B7%A5%E5%9D%8A%E5%9B%BE/jenkins/peizhi5.png)

   配置构建内容和方式

   ![](https://gitee.com/Strife-Dispute/ty-gallery/raw/master/%E5%B7%A5%E5%9D%8A%E5%9B%BE/jenkins/peizhi6.png)

   构建完执行什么

   ![](https://gitee.com/Strife-Dispute/ty-gallery/raw/master/%E5%B7%A5%E5%9D%8A%E5%9B%BE/jenkins/peizhi7.png)

8. 执行构建

   ![](https://gitee.com/Strife-Dispute/ty-gallery/raw/master/%E5%B7%A5%E5%9D%8A%E5%9B%BE/jenkins/gojian1.png)

9. 查看控制台输出

   ![](https://gitee.com/Strife-Dispute/ty-gallery/raw/master/%E5%B7%A5%E5%9D%8A%E5%9B%BE/jenkins/ceshi1.png)











# 自动化部署vue项目（tomcat环境）

1. 下载所有插件、组件、依赖项等

   ```sh
   # web页面下载插件
   1. NodeJS Plugin
   2. Publish over SSH
   3. SSH Server
   
   
   # 下载gcc、make、bison
   [root@jenkins ~]# yum install -y centos-release-scl
   [root@jenkins ~]# yum install -y devtoolset-8-gcc*
   [root@jenkins ~]# yum install -y gcc
   [root@jenkins ~]# wget http://ftp.gnu.org/gnu/make/make-4.3.tar.gz
   [root@jenkins ~]# tar -xzvf make-4.3.tar.gz 
   [root@jenkins ~]# cd make-4.3
   [root@jenkins ~]# ./configure --prefix=/usr/local/make
   [root@jenkins ~]# make && make install
   [root@jenkins ~]# cd /usr/bin/
   [root@jenkins ~]# mv make make.bak
   [root@jenkins ~]# ln -sv /usr/local/make/bin/make /usr/bin/make
   [root@jenkins ~]# yum install -y bison
   [root@jenkins ~]# gcc --version
   [root@jenkins ~]# make --version
   [root@jenkins ~]# bison --version
   
   
   # 注意
   1. 本实验是基于自动化部署tomcat来进行
   ```

2. gitlab上传项目

   ```sh
   [root@gitlab vue-master]# https://strife.oratun.cn/yun/%E6%BA%90%E7%A0%81%E5%8C%85/vue-master.tar.gz
   [root@gitlab vue-master]# git init
   [root@gitlab vue-master]# git remote add origin git@192.168.223.100:root/vue.git
   [root@gitlab vue-master]# git add .
   [root@gitlab vue-master]# git commit -am "1"
   [root@gitlab vue-master]# git push origin master
   ```

3. 配置ssh目标主机

   ![](https://gitee.com/Strife-Dispute/ty-gallery/raw/master/%E5%B7%A5%E5%9D%8A%E5%9B%BE/jenkins/vue1.png)

4. 安装NodeJS16.0.0

   ![](https://gitee.com/Strife-Dispute/ty-gallery/raw/master/%E5%B7%A5%E5%9D%8A%E5%9B%BE/jenkins/vue2.png)

5. 构建任务

   新建任务-----》构建一个自由风格的软件项目（命名11）

6. 配置git

   ![](https://gitee.com/Strife-Dispute/ty-gallery/raw/master/%E5%B7%A5%E5%9D%8A%E5%9B%BE/jenkins/vue3.png)

7. 设置构建环境

   ![](https://gitee.com/Strife-Dispute/ty-gallery/raw/master/%E5%B7%A5%E5%9D%8A%E5%9B%BE/jenkins/vue4.png)

8. 设置构建内容

   ![](https://gitee.com/Strife-Dispute/ty-gallery/raw/master/%E5%B7%A5%E5%9D%8A%E5%9B%BE/jenkins/vue5.png)

9. 设置构建后执行shell

   ![](https://gitee.com/Strife-Dispute/ty-gallery/raw/master/%E5%B7%A5%E5%9D%8A%E5%9B%BE/jenkins/vue6.png)

10. 目标主机查看

    ```sh
    [root@tomcat wxsweb]# ls
    index.html  static
    [root@tomcat wxsweb]# pwd
    /usr/local/tomcat/webapps/wxsweb
    [root@tomcat wxsweb]# cat index.html 
    <!DOCTYPE html><html><head><meta charset=utf-8><meta name=viewport content="width=device-width,initial-scale=1"><title>experiment</title><link rel=stylesheet href=/static/css/font-awesome/font-awesome.min.css><link rel=stylesheet href=/static/css/bootstrap/bootstrap.min.css><link rel=stylesheet href=/static/css/styles.css><link rel=stylesheet href=/static/css/modal.css><link href=/static/css/app.3de0a3d70fd76cd4a366ec80d3b59753.css rel=stylesheet></head><body><div id=app></div><script type=text/javascript src=/static/js/manifest.2ae2e69a05c33dfc65f8.js></script><script type=text/javascript src=/static/js/vendor.2bb7f83c017306572689.js></script><script type=text/javascript src=/static/js/app.64ac9fa38c29189d5a2b.js></script></body><script src=https://cdn.staticfile.org/jquery/2.1.1/jquery.min.js></script><script src=https://cdn.staticfile.org/twitter-bootstrap/3.3.7/js/bootstrap.min.js></script><script src=https://cdnjs.cloudflare.com/ajax/libs/video.js/7.3.0/video.min.js></script><link href=https://cdnjs.cloudflare.com/ajax/libs/video.js/7.3.0/video-js.min.css rel=stylesheet><script>window.onload = function () {
        $('#videoModal').on('hidden.bs.modal', function () {
          console.log('模态框关闭...')
          let videoPlayer = $('#videoPlayer')[0]
          // console.log(videoPlayer)
          // console.log($('#videoPlayer'))
          videoPlayer.controls = true;
          if (!videoPlayer.paused) {
            videoPlayer.pause();
          }
        })
      }</script></html>
      
      
      
    # 浏览器访问192.168.223.3:8080/wxsweb/index.html
    # 因为没有内容，所有什么都不会显示
    ```

    

