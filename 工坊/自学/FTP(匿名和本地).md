# 实验之本地用户访问

1. 查看是否安装ftp

   ```
   rpm -qa| grep ftp
   
   # 卸载
   rpm -e ftp
   ```

2. 关闭防火墙以及selinux

   ```
   systemctl stop firewalld //关闭防火墙
   setenforce 0
   systemctl status firewalld //查看防护墙状态
   ```

3. 客户机和服务器安装ftp服务

   ```
   yum install -y vsftpd lftp ftp
   ```

4. 开启服务和设置自启

   ```
   systemctl start vsftpd.service         
   systemctl enable vsftpd.service     
   systemctl status vsftpd.service     
   ```

5. 备份配置文件

   ```
   cd /etc/vsftpd
   
   cp vsftpd.conf vsftpd.conf_bak
   ```

6. 修改对应本地用户的上传

   ```
   anonymous_enable=NO
   xferlog_file=/var/log/xferlog //上传与下载日志存放路径
   chroot_list_file=/etc/vsftpd/chroot_list
   port_enable=YES //启动被动式联机
   pasv_enable=YES
   pasv_min_port=30000 //被动模式结束端口，
   pasv_max_port=15000
   userlist_deny=NO
   ```

7. 在服务器创建用户并设置密码

   ```
   useradd li
   
   passwd li
   或
   echo 123456 |passwd --stdin li
   ```

8. 客户端远程访问服务器

   ```
   ftp 服务器ip
   
   # 输入谁的用户就会进入哪个用户的家目录且只能下载文件
   # 可以切换目录，根据权限而定
   ```

9. 下载服务端文件

   ```
   # 下载的文件会在退出的位置找到
   get 1.sh
   ```

10. 上传客户端文件

    ```
    上传时只能上传在当前客户端位置目录下的文件
    put 2.sh
    ```

    

注意：

```
331 Please specify the password.
Password:
530 Login incorrect.
Login failed.
```

检查/etc/pam.d/vsftpd文件，在第二个auth前加上注释重启服务





# 实验之匿名用户访问

1. 修改对应匿名用户的上传

   ```
   anonymous_enable=YES #启用匿名访问
   anon_umask=022 #匿名用户所上传文件的权限掩码
   anon_root=/var/ftp #匿名用户的 FTP 根目录
   anon_upload_enable=YES #允许上传文件
   anon_mkdir_write_enable=YES #允许创建目录
   anon_other_write_enable=YES #开放其他写入权(删除、覆盖、重命名)
   anon_max_rate=0 #限制最大传输速率
   
   
   ```

2. 关闭seLinux

   ```
   setenforce 0 
   
   永久生效：
    vim /etc/selinux/config
    
    SELINUX = disabled
   ```

3. 客户端远程访问服务器

   ```
   ftp 服务器ip
   
   # 输入ftp
   # 不输入密码
   # 直接进入/var/ftp下
   ```

4. 下载服务端文件

   ```
   # 下载的文件会在退出的位置找到
   get 1.sh
   ```

5. 上传客户端文件

   ```
   上传时只能上传在当前客户端位置目录下的文件
   put 2.sh
   ```

   