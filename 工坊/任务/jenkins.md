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
| 192.168.223.200 | tomcat  | Tomcat测试机               |







# 实验

## Gitlab安装

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

## Jenkins安装

1. 安装依赖包和epel源

   ```sh
   [root@jenkins ~]# yum install git epel-release daemonize java-1.8.0-openjdk* -y
   ```

2. 安装rpm包（rpm包自行下载版本）

   ```sh
   [root@jenkins ~]# rpm -ivh jenkins-2.332-1.1.noarch.rpm
   
   
   # 注意
   1. 出现warning: jenkins-2.332-1.1.noarch.rpm: Header V4 RSA/SHA512 Signature, key ID 45f2c3d5: NOKEY
   error: Failed dependencies:
   	daemonize is needed by jenkins-2.332-1.1.noarch
   	
   # 解决方法
   1. 下载daemonize
      yum install -y daemonize
   ```

   

