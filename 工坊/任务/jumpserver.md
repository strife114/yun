# 堡垒机

## 简介

1. 在特定网络环境下，为了保障网络和数据不受外界入侵和破坏，而运用各种技术手段，实时收集和监控网络环境中的每一个组成部分的系统状态、安全事件、网络活动，以便集中报警、及时处理及审计定责。
2. 我们又把堡垒机叫做跳板机。简易的跳板机功能简单，主要核心功能是远程登录服务器和日志审计。堡垒机还可以用来做资产管理、监控、用户授权等。
3. 开源软件：Jumpserver
4. 商业堡垒机：齐治、Citrix XenApp。

## 堡垒机为企业带来的价值

### （1）管理效益

管理效益就是指所有主账号和从账户在一个平台上进行管理，账号管理更加简单有序。通过建立运维用户与主账号的唯一对应关系，确保运维用户拥有的权限是完成任务所需的最小权限。它是可视化运维的行为监控，及时预警发现违规操作。

### （2）用户效益

运维人员只需记忆一个账号和密码，一次登录，便可实现对其所维护的多台资源的访问。无需频繁地输入IP地址和账户密码，提高工作效率，降低工作复杂度。批量运维和操作资源。

### （3）企业效益

可以降低人为安全风险，避免安全损失。符合“网络安全法”等规定，满足合规要求，保障企业效益。

堡垒机通过精细化授权，可以明确“哪些人以哪些身份访问哪些设备”，从而让运维混乱变得有序起来；通过体系化的指令审计规则，让运维操作变得安全可控。

## 使用场景

1. 简易堡垒机只适合小型公司使用，在公司服务器只有几台的情况下，可以使用，也就是跳板机。跳板机主要功能是登陆公司内网服务器，还可以去查找审计当你登陆到某台机器后做了什么操作。

## 使用条件

1. 首先要有公网IP，因为登陆公司的服务器，不只是在公司内登陆，还可能在家里办公或者是出差时要登陆。所以这服务器需要有一个公网IP。除了公网IP，它还需要和我们机房其他机器连成一个局域网。假设机房里有十台机器，只有一台有公网，将这台有公网的机器作为一个跳板机，通过它来连接其他机器。
2. 跳板机是有公网对外开放的，所以要设置防火墙规则，需要做权限最小化的处理，需要什么端口就开放什么端口，不能开放多余的端口。登陆限制，限制IP访问，又或是做一个VPN通道。还可以设置sshd_config，只能通过密钥登陆，拒绝密码登陆。
3. 对用户进行限制，使用jailkit来做用户、目录权限的限制。
4. 除了这些之外还需要做一个日志审计，日志审计不能在跳板机上做，需要到各个客户机上做。
5. 使用jailkit来实现chroot，将用户限制在一个虚拟系统中，让他只能使用有限的命令来保证我们系统的安全性，具体节点规划见表。



# 堡垒机部署

## 实验环境

| IP              | 角色   | 节点规划   |
| --------------- | ------ | ---------- |
| 192.168.223.100 | master | jumpserver |
| 192.168.223.7   | 测试机 |            |



## 部署

### 自动化部署

1. 执行命令

   ```sh
   [root@master ~]# curl -sSL https://resource.fit2cloud.com/jumpserver/jumpserver/releases/latest/download/quick_start.sh | bash
   ```

   

# Web页面操作

## 管理主机

1. 登录

   用户名： amdin

   密码： admin

   ![](https://gitee.com/fan-dongyuan/ty-gallery/raw/master/%E5%B7%A5%E5%9D%8A%E5%9B%BE/jumpserver/guanli1.png)

2. 创建用户

   ![](https://gitee.com/fan-dongyuan/ty-gallery/raw/master/%E5%B7%A5%E5%9D%8A%E5%9B%BE/jumpserver/guanli2.png)

   ![](https://gitee.com/fan-dongyuan/ty-gallery/raw/master/%E5%B7%A5%E5%9D%8A%E5%9B%BE/jumpserver/guanli3.png)

3. 创建资产

   ![](https://gitee.com/fan-dongyuan/ty-gallery/raw/master/%E5%B7%A5%E5%9D%8A%E5%9B%BE/jumpserver/guanli4.png)

   ![](https://gitee.com/fan-dongyuan/ty-gallery/raw/master/%E5%B7%A5%E5%9D%8A%E5%9B%BE/jumpserver/guanli5.png)

4. 创建账号

   ![](https://gitee.com/fan-dongyuan/ty-gallery/raw/master/%E5%B7%A5%E5%9D%8A%E5%9B%BE/jumpserver/guanli6.png)

   ![](https://gitee.com/fan-dongyuan/ty-gallery/raw/master/%E5%B7%A5%E5%9D%8A%E5%9B%BE/jumpserver/guanli7.png)

5. 资产授权

   ![](https://gitee.com/fan-dongyuan/ty-gallery/raw/master/%E5%B7%A5%E5%9D%8A%E5%9B%BE/jumpserver/guanli8.png)

   ![](https://gitee.com/fan-dongyuan/ty-gallery/raw/master/%E5%B7%A5%E5%9D%8A%E5%9B%BE/jumpserver/guanli9.png)

6. 进入终端

   点击右上角的终端图标

   ![](https://gitee.com/fan-dongyuan/ty-gallery/raw/master/%E5%B7%A5%E5%9D%8A%E5%9B%BE/jumpserver/guanli10.png)

   ![](https://gitee.com/fan-dongyuan/ty-gallery/raw/master/%E5%B7%A5%E5%9D%8A%E5%9B%BE/jumpserver/guanli11.png)

   




## MFA认证

1. 点击右上角设置------》安全设置

   ![](https://gitee.com/Strife-Dispute/ty-gallery/raw/master/%E5%B7%A5%E5%9D%8A%E5%9B%BE/jumpserver/jumpmfa0.png)

2. 退出账号并重新登录（admin账号即可）

3. MFA注册

   ![](https://gitee.com/Strife-Dispute/ty-gallery/raw/master/%E5%B7%A5%E5%9D%8A%E5%9B%BE/jumpserver/jumpmfa1.png)

   用手机扫码二维码下载**身份验证器**

   ![](https://gitee.com/Strife-Dispute/ty-gallery/raw/master/%E5%B7%A5%E5%9D%8A%E5%9B%BE/jumpserver/jumpmfa2.png)

   点击右下角的+号，用**扫描二维码**的方式去注册身份验证器，

   ![](https://gitee.com/Strife-Dispute/ty-gallery/raw/master/%E5%B7%A5%E5%9D%8A%E5%9B%BE/jumpserver/jumpmfa3.png)

   然后将二维码填入上方的二维码

   ![](https://gitee.com/Strife-Dispute/ty-gallery/raw/master/%E5%B7%A5%E5%9D%8A%E5%9B%BE/jumpserver/jumpmfa4.png)

   ![](https://gitee.com/Strife-Dispute/ty-gallery/raw/master/%E5%B7%A5%E5%9D%8A%E5%9B%BE/jumpserver/jumpmfa7.png)

4. 登录账号测试

   ![](https://gitee.com/Strife-Dispute/ty-gallery/raw/master/%E5%B7%A5%E5%9D%8A%E5%9B%BE/jumpserver/jumpmfa5.png)

   ![](https://gitee.com/Strife-Dispute/ty-gallery/raw/master/%E5%B7%A5%E5%9D%8A%E5%9B%BE/jumpserver/jummfa6.png)



## 邮件告警

1. 设置邮箱

   设置-----》邮件设置------》邮件服务器

   ![](https://gitee.com/Strife-Dispute/ty-gallery/raw/master/%E5%B7%A5%E5%9D%8A%E5%9B%BE/jumpserver/jumpyouxiang1.png)

   ![](https://gitee.com/Strife-Dispute/ty-gallery/raw/master/%E5%B7%A5%E5%9D%8A%E5%9B%BE/jumpserver/jumpyouxiang2.png)

2. 测试

   ![](https://gitee.com/Strife-Dispute/ty-gallery/raw/master/%E5%B7%A5%E5%9D%8A%E5%9B%BE/jumpserver/jumpyouxiang3.png)





## JumpServer审计台

### 审计员

![](https://gitee.com/Strife-Dispute/ty-gallery/raw/master/%E5%B7%A5%E5%9D%8A%E5%9B%BE/jumpserver/jumpshenji1.png)

### 会话审计

![](https://gitee.com/Strife-Dispute/ty-gallery/raw/master/%E5%B7%A5%E5%9D%8A%E5%9B%BE/jumpserver/jumpshenji2.png)

![](https://gitee.com/Strife-Dispute/ty-gallery/raw/master/%E5%B7%A5%E5%9D%8A%E5%9B%BE/jumpserver/jumpshenji3.png)

![](https://gitee.com/Strife-Dispute/ty-gallery/raw/master/%E5%B7%A5%E5%9D%8A%E5%9B%BE/jumpserver/jumpshenji4.png)

### 日志审计

![](https://gitee.com/Strife-Dispute/ty-gallery/raw/master/%E5%B7%A5%E5%9D%8A%E5%9B%BE/jumpserver/jumpshenji5.png)