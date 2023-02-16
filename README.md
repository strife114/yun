# SCP（远程传输）

## 简介

> 1. **scp**就是secure copy，是用来进行**远程文件拷贝**的。数据传输使用 ssh，并且和**ssh** 使用相同的认证方式，提供相同的安全保证 。
>
> 2. **scp**不需要安装额外的软件，使用起来简单方便，安全可靠且支持限速参数但是它不支持排除目录

## 命令格式

```
scp [参数] < 源地址(用户名@iphuu或主机名)>:<文件路径>  <目的地址（用户名 @IP 地址或主机名）>:<文件路径> 

例：scp /fdy.tar.gz  root@10.1.1.88:/
   scp /test/*   root@10.1.1.88:/

参数:
 -r  传输文件夹
 -v  显示传输详细
```

# sshpass

> sshpass是一款凡是为凡是使用ssl方式访问的操作提供一个免输入密码的非交互式操作，以便于在脚本中执行ssl操作，如ssh，scp等

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
    -r      删除工作作
```

## 时间格式

> 1. 定时任中的时间的说明，时间的格式大概是这样的* * * * * 五个*号代表的意思分别是分，时，日，月，周的顺序来排列的
>
> 2. 如果想每分钟都执行一次的话就采用默认的 * * * * *，如果想每五分钟执行一次可以 */5 * * * * ，如果是每两个小时执行一次的话那就是 *  */2 * * *来设置; 



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
   sshpass -p 123456 scp /fdy root@192.168.223.4:/
   ```

4. 赋权

   ```
   chmod 755 s1.sh
   
   # 4 = r = 读
   # 2 = w = 写
   # 1 = x = 执
   
   ```

5. 设置定时任务

   ```
   crontab -e
   
   * * * * *  s1.sh # 每分钟运行一次
   ```

6. 确认任务

   ```
   crontab -l
   ```

7. 等待定时反应





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



