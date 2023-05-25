# 案例一、服务器系统配置初始化

## 需求

1、设置时区并同步时间

2、禁用selinux

3、清空防火墙默认策略

4、历史命令显示时间

5、禁止root远程登录

6、禁止定时任务发送邮件

7、设置最大打开文件数

8、减少Swap使用

9、系统内核参数优化

10、      安装系统性能分析工具及其他常用工具

## 代码实现

```sh
#/bin/bash
# 设置时区并同步时间
# 时间服务器time.windows.com已失效，请选择其他服务器
ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
if ! crontab -l |grep ntpdate &>/dev/null ; then
    (echo "* 1 * * * ntpdate time.windows.com >/dev/null 2>&1";crontab -l) |crontab 
fi

# 禁用selinux
sed -i '/SELINUX/{s/enforcing/disabled/}' /etc/selinux/config

# 关闭防火墙
if egrep "7.[0-9]" /etc/redhat-release &>/dev/null; then
    systemctl stop firewalld
    systemctl disable firewalld
elif egrep "6.[0-9]" /etc/redhat-release &>/dev/null; then
    service iptables stop
    chkconfig iptables off
fi

# 历史命令显示操作时间
if ! grep HISTTIMEFORMAT /etc/bashrc; then
    echo 'export HISTTIMEFORMAT="%F %T `whoami` "' >> /etc/bashrc
fi

# SSH超时时间
if ! grep "TMOUT=600" /etc/profile &>/dev/null; then
    echo "export TMOUT=600" >> /etc/profile
fi

# 禁止root远程登录
sed -i 's/#PermitRootLogin yes/PermitRootLogin no/' /etc/ssh/sshd_config

# 禁止定时任务向发送邮件
sed -i 's/^MAILTO=root/MAILTO=""/' /etc/crontab 

# 设置最大打开文件数
if ! grep "* soft nofile 65535" /etc/security/limits.conf &>/dev/null; then
    cat >> /etc/security/limits.conf << EOF
    * soft nofile 65535
    * hard nofile 65535
EOF
fi

# 系统内核优化
cat >> /etc/sysctl.conf << EOF
net.ipv4.tcp_syncookies = 1
net.ipv4.tcp_max_tw_buckets = 20480
net.ipv4.tcp_max_syn_backlog = 20480
net.core.netdev_max_backlog = 262144
net.ipv4.tcp_fin_timeout = 20  
EOF

# 减少SWAP使用
echo "0" > /proc/sys/vm/swappiness

# 安装系统性能分析工具及其他
yum install -y gcc make autoconf vim sysstat net-tools ntpdate

```





# 案例二、批量创建用户并设置不同密码

## 需求

1. 公司新来一百位实习生，手动创建用户名太过麻烦

2. 每个人的名字都不一样，所以用户名不规律。

3. 密码不能一致，需要使用随机密码

4. 判断要创建的用户是否存在

## 代码实现

### 有规则用户

```sh
#!/bin/bash
# 声明变量
USER_FILE=./user_info
for USER in user{1..10};do
        # 如果没有这个id，那么就执行下面的命令
        if ! id $USER &>/dev/null; then
                # 生成随机密码
                PASS=$(echo $RANDOM |md5sum | cut -c 1-8)
                useradd $USER
                # 为用户设置密码
                echo $PASS | passwd --stdin $USER
                echo "$USER     $PASS" >> $USER_FILE
                echo "$user user create successful"
        else
                echo "USER user already exists!"
        fi
done

```

### 创建指定用户

#### 代码

```sh
#!/bin/bash
# $@ 是传给脚本的所有参数的列表
USER_LIST=$@
USER_FILE=./user_info
for USER in $USER_LIST; do
        if ! id $USER &>/dev/null; then
                PASS=$(echo $RANDOM |md5sum | cut -c 1-8)
                useradd $USER
                echo $PASS | passwd --stdin $USER &>/dev/null
                echo "$USER     $PASS" >> $USER_FILE
                echo "$user user create successful"
        else
                echo "USER user already exists!"
        fi
done
```

#### 实现

```sh
[root@localhost ~]# sh -x user2.sh lyh fdy 123
[root@localhost ~]# cat user_info 
lyh	547b5967
fdy	b218a089
123	28b6a496
```





# 案例三、查看服务器利用率

## 需求

1. cpu 60%

2. 内存 利用率

3. 硬盘 利用率

4. TCP连接状态 

## 代码实现

```sh
#!/bin/bash
# 用于检查系统的CPU、内存和磁盘使用情况。其中，cpu()函数用于检查CPU使用率、用户进程占用率、系统进程占用率和I/O等待率；
function cpu() {
    NUM=1
    while [ $NUM -le 3 ]; do
        util=`vmstat |awk '{if(NR==3)print 100-$15"%"}'`
        user=`vmstat |awk '{if(NR==3)print $13"%"}'`
        sys=`vmstat |awk '{if(NR==3)print $14"%"}'`
        iowait=`vmstat |awk '{if(NR==3)print $16"%"}'`
        echo "CPU - 使用率: $util , 等待磁盘IO响应使用率: $iowait"
        let NUM++
        sleep 1
    done
}
# memory()函数用于检查内存总大小、已使用大小和剩余大小；
function memory() {
    total=`free -m |awk '{if(NR==2)printf "%.1f",$2/1024}'`
    used=`free -m |awk '{if(NR==2) printf "%.1f",($2-$NF)/1024}'`
    available=`free -m |awk '{if(NR==2) printf "%.1f",$NF/1024}'`
    echo "内存 - 总大小: ${total}G , 使用: ${used}G , 剩余: ${available}G"
}
# disk()函数用于检查磁盘挂载点、总大小、已使用大小和使用百分比等信息。这个脚本可以帮助管理员监控系统资源的使用情况
function disk() {
    fs=$(df -h |awk '/^\/dev/{print $1}')
    for p in $fs; do
        mounted=$(df -h |awk '$1=="'$p'"{print $NF}')
        size=$(df -h |awk '$1=="'$p'"{print $2}')
        used=$(df -h |awk '$1=="'$p'"{print $3}')
        used_percent=$(df -h |awk '$1=="'$p'"{print $5}')
        echo "硬盘 - 挂载点: $mounted , 总大小: $size , 使用: $used , 使用率: $used_percent"
    done
}

function tcp_status() {
    summary=$(ss -antp |awk '{status[$1]++}END{for(i in status) printf i":"status[i]" "}')
    echo "TCP连接状态 - $summary"
}

cpu
memory
disk
tcp_status

```





# 案例四、找出占用CPU和RAM占用率高的进程

## 需求

1. 找出占用内存最高的十个进程
2. 找出占用cpu最高的十个进程
3. 按照特定要求排序

## 代码实现

```sh
#!/bin/bash
# 按照从高到低的顺序显示占用最高的十个的cpu进程
ps -eo user,pid,pcpu,pmem,args --sort=-pcpu  |head -n 10
# 按照从高到低的顺序显示占用最高的十个的ram进程
ps -eo user,pid,pcpu,pmem,args --sort=-pmem  |head -n 10
```







# 案例五、查看网卡实时流量

## 需求

1. 实时监测
2. 根据/proc/net/dev 文件做循环取值

## 代码实现

### 代码

```sh
#!/bin/bash
# 要检测的网卡名
NIC=$1
echo -e " In ------ Out"
# 无限循环
while true; do
	# 从文件中提取指定网卡行的第2列字节数据
    OLD_IN=$(awk '$0~"'$NIC'"{print $2}' /proc/net/dev)
    # 从文件中提取指定网卡行的第10列字节数据
    OLD_OUT=$(awk '$0~"'$NIC'"{print $10}' /proc/net/dev)
    sleep 1
    # 从文件中提取指定网卡行的新第2列数据
    NEW_IN=$(awk  '$0~"'$NIC'"{print $2}' /proc/net/dev)
    # 从文件中提取指定网卡行的新第10列数据
    NEW_OUT=$(awk '$0~"'$NIC'"{print $10}' /proc/net/dev)
    # 用新数据减去旧数据的插值得到一个值，留小数点后一位
    IN=$(printf "%.1f%s" "$((($NEW_IN-$OLD_IN)/1024))" "KB/s")
    # 用新数据减去旧数据的插值得到一个值，留小数点后一位
    OUT=$(printf "%.1f%s" "$((($NEW_OUT-$OLD_OUT)/1024))" "KB/s")
    # 输出差值（得到流量）
    echo "$IN $OUT"
    sleep 1
done
```

### 实现

```sh
[root@localhost ~]# bash wang.sh ens33
 In ------ Out
0.0KB/s 0.0KB/s
0.0KB/s 0.0KB/s
0.0KB/s 0.0KB/s
0.0KB/s 0.0KB/s
0.0KB/s 0.0KB/s
0.0KB/s 1.0KB/s
1.0KB/s 1.0KB/s
9.0KB/s 1235.0KB/s
0.0KB/s 0.0KB/s


# 注意
代码$1获取的是脚本名后的第一个身位
```





# 案例六、邮件测试

## 需求

1. 可以发送邮件

## 代码实现

### 代码

```sh
# 下载mailx邮件
[root@localhost ~]# yum install -y mailx



  # 邮箱名字 # 授权码
  # 登录

# 配置
[root@localhost ~]# vim /etc/mail.rc
# 将 2521505194@qq.com 设置为邮件的发件人地址，使用 smtp.qq.com 作为SMTP服务器。
set from=2521505194@qq.com smtp=smtp.qq.com
# 使用 2521505194@qq.com 作为SMTP服务器的验证用户名，而验证码这个命令通常在需要SMTP服务器身份验证时使用。例如，如果你使用QQ邮箱并启用了“登录保护”功能，则无法直接使用邮箱密码登录。此时，你需要使用授权码作为SMTP服务器身份验证密码来发送邮件。
set smtp-auth-user=2521505194@qq.com smtp-auth-password=flerwtucixkjdjhj    # 邮箱名字 # 授权码
set smtp-auth=login  # 登录
```

### 实现

```sh
[root@localhost ~]# echo "fdy" test.log
[root@localhost ~]# mailx -s "邮箱测试" 1272776782@qq.com < test.log
```







# 案例七、MySQL主从邮件测试

## 需求

1. master的读写操作会记录到binlog日志当中，slave节点读取master的binlog最新数据到slqve的relaylog中，slave节点再去本地执行，保持数据同步。
2. slave节点通过一个账号连接到master节点，通过两个线程完成（Slave_IO_Running: Yes；Slave_SQL_Running: Yes）
3. 通过slave节点 使用show slave status\G 可以格式化输出从节点信息
4. 因为show slave status\G需要进入MySQL才可以，这里需要免交互执行

## 代码实现

### 代码

```sh
#!/bin/bash  
HOST=localhost
USER=root
PASSWD=123456
# 获取MySQL命令的文本并在给定的文本数据中查找包含字符串 "Slave_" 且以 "_Running:" 结尾的行
IO_SQL_STATUS=$(mysql -h$HOST -u$USER -p$PASSWD -e 'show slave status\G' 2>/dev/null |awk '/Slave_.*_Running:/{print $1$2}')
for i in $IO_SQL_STATUS; do
	# 提取i变量并将:后的值删除并输出赋值:前的值
    THREAD_STATUS_NAME=${i%:*}
    # 提取i变量并将:前的值删除并输出赋值:后的值
    THREAD_STATUS=${i#*:}
    if [ "$THREAD_STATUS" != "Yes" ]; then
        echo "Error: MySQL Master-Slave $THREAD_STATUS_NAME status is $THREAD_STATUS!" |mailx -s "Master-Slave Staus" 1272776782@qq.com
    fi
done


# 注意
需结合案例七进行实验
```

### 实现

```sh
# 进入slave的mysql关闭slave连接
mysql> stop slave;
# 执行脚本
mysql> bash mysqlzhucou.sh
```





# 案例八、检测脚本的语法是否有误

## 需求

1. 检测脚本语法是否有误

## 代码实现

### 代码

```sh
#!/bin/bash
sh -n $1 2>/tmp/sh.err
if [ $? -ne 0 ]
then
    cat /tmp/sh.err
    read -p "请输入q/Q退出脚本: " c
    if [ -z "$c"]
    then
	vim $1 
        exit 0
    fi
    if [ $c == q ] || [ $c == Q ]
    then
	exit 0
    else
	vim $1
	exit 0
    fi
else
    echo "脚本$1没有语法错误."
fi
```

### 实现

```sh
[root@localhost ~]# bash 19.sh 111.sh
```





# 案例九、扫描网段在线IP

## 需求

1. 把一个192.168.223.0/24网段的在线ip列出

## 代码实现

### 代码

```sh
#!/bin/bash
for i in `seq 1 254`
do 
    if ping -c 2 -W 2 192.168.223.$i >/dev/null 2>/dev/null
    then
	echo "192.168.223.$i 是通的."
    else
	echo "192.168.223.$i 不通."
    fi
done

```

### 实现

```sh
[root@slave ~]# bash 18.sh 
192.168.223.1 是通的.
192.168.223.2 是通的.
192.168.223.3 是通的.
192.168.223.4 是通的.
192.168.223.5 不通.
192.168.223.6 不通.
192.168.223.7 不通.
```





# 案例十、检查系统是否被入侵过

## 需求

1. ps aux可以查看到进程的PID，而每个PID都会在/proc内产生。如果查看到的pid在proc内是没有的，则进程被人修改了，这就代表系统很有可能已经被入侵过了。

## 代码实现

### 代码

```sh
#!/bin/bash
# 获取当前进程PID
pp=$$
# 将系统上所有进程详细信息输出到文件中
ps -elf |sed '1'd > /tmp/pid.txt
# 循环筛选除当前pid的其他所有pid，检查目录是否存在
for pid in `awk -v ppn=$pp '$5!=ppn {print $4}' /tmp/pid.txt`
do
    if ! [ -d /proc/$pid ]
    then
	echo "系统中并没有pid为$pid的目录，需要检查。"
    fi    
done
```

### 实现

```sh
[root@slave ~]# sh -x 21.sh 
```





# 案例十一、远程监控服务器存活状态

## 需求

1. 监控远程的一台机器(假设ip为192.168.223.5)的存活状态，当发现宕机时发一封邮件给你自己。
2. 提前下载python(yum install -y python)

## 代码实现

### 代码

mail.py

```python
#!/usr/bin/env python3
# -*- coding: utf-8 -*-
import smtplib
from email.mime.text import MIMEText
from email.header import Header
import sys

# 配置邮件服务器信息
smtp_server = 'smtp.qq.com'
smtp_port = 465
smtp_ssl = True
smtp_username = '1272776782@qq.com'
smtp_password = 'pktvlgrorjwkjghg'

def send_mail(recipient, subject, content):
    # 创建邮件消息对象
    message = MIMEText(content, 'plain', 'utf-8')
    message['Subject'] = Header(subject, 'utf-8')
    message['From'] = smtp_username
    message['To'] = recipient

    # 连接邮件服务器并发送邮件
    try:
        smtp = smtplib.SMTP_SSL(smtp_server, smtp_port) if smtp_ssl else smtplib.SMTP(smtp_server, smtp_port)
        smtp.login(smtp_username, smtp_password)
        smtp.sendmail(smtp_username, [recipient], message.as_string())
        smtp.quit()
        print('邮件发送成功')
    except smtplib.SMTPException as e:
        print('邮件发送失败:', e)

if __name__ == '__main__':
    recipient = sys.argv[1]
    subject = sys.argv[2]
    content = sys.argv[3]
    send_mail(recipient, subject, content)
```

9.sh

```sh

#!/bin/bash
n=`ping -c5 192.168.223.5|grep 'packet' |awk -F '%' '{print $1}' |awk '{print $NF}'`
m=1272776782@qq.com
if [ -z "$n" ]
then
    echo "脚本有问题。"
    python3 mail.py  $m "检测机器存活脚本$0有问题" "获取变量的值为空"
    exit
else
    n1=`echo $n|sed 's/[0-9]//g'`
    if [ -n "$n1" ]
    then
        echo "脚本有问题。"
        python3 mail.py  $m "检测机器存活脚本$0有问题" "获取变量的值不是纯数字"
        exit
    fi
fi

while :
do
    if [ $n -ge 50 ]
    then
        python mail.py $m "机器宕机" "丢包率是$n%"
    fi
    sleep 30
done
```

### 实现

```sh
[root@slave ~]# sh -x 9.sh 
++ ping -c5 192.168.223.5
++ grep packet
++ awk -F % '{print $1}'
++ awk '{print $NF}'
+ n=100
+ m=1272776782@qq.com
+ '[' -z 100 ']'
++ echo 100
++ sed 's/[0-9]//g'
+ n1=
+ '[' -n '' ']'
+ :
+ '[' 100 -ge 50 ']'
+ python mail.py 1272776782@qq.com 机器宕机 丢包率是100%
邮件发送成功
+ sleep 30
+ :
+ '[' 100 -ge 50 ']'
+ python mail.py 1272776782@qq.com 机器宕机 丢包率是100%
邮件发送成功
+ sleep 30
```



# 案例十二、监控本机端口

## 需求

1. 检测80端口（httpd）
2. 邮件脚本为mail.py
3. 重启服务时需要发邮件

## 代码实现

### 代码

```sh
#!/bin/bash
m=1272776782@qq.com
while :
do
    n=`netstat -lntp |grep ':80 '|wc -l`
    if [ $n -eq 0 ]
    then
        systemctl restart httpd >/tmp/apache.err
        python3 mail.py $m "80端口关闭" "已经重启httpd服务"
        pn=`pgrep -l httpd|wc -l`
        if [ $pn -eq 0 ]
        then
            python3 mail.py $m "httpd重启失败" "`head -1 /tmp/apache.err`"
        fi
    fi

    sleep 30
done

```

### 实现

```sh
[root@slave ~]# sh -x 10.sh 
+ m=1272776782@qq.com
+ :
++ netstat -lntp
++ grep ':80 '
++ wc -l
+ n=0
+ '[' 0 -eq 0 ']'
+ systemctl restart httpd
+ python3 mail.py 1272776782@qq.com 80端口关闭 已经重启httpd服务
邮件发送成功
++ pgrep -l httpd
++ wc -l
+ pn=6
+ '[' 6 -eq 0 ']'
+ sleep 30



# 注意
如果出现10.sh: line 9: python3: command not found则下载python3，如果不知道怎么下载则
yum install -y python*
```





# 案例十三、分库备份数据库

## 需求

1. 列出所有数据库再去除不需要备份的数据库、再循环备份数据库

## 代码实现

### 代码

```sh
#!/bin/bash
DATE=$(date +%F_%H-%M-%S)
HOST=localhost
USER=root
PASS=123456
BACKUP_DIR=/data/db_backup
# 备份除去Database|information_schema|mysql|performance_schema|sys以外的数据库
DB_LIST=$(mysql -h$HOST -u$USER -p$PASS -s -e "show databases;" 2>/dev/null |egrep -v "Database|information_schema|mysql|performance_schema|sys")

for DB in $DB_LIST; do
    BACKUP_NAME=$BACKUP_DIR/${DB}_${DATE}.sql
    if ! mysqldump -h$HOST -u$USER -p$PASS -B $DB > $BACKUP_NAME 2>/dev/null; then
        echo "$BACKUP_NAME 备份失败!"
    fi
done

```

### 实现

```sh
[root@master ~]# bash 29.sh
[root@master ~]# ls /data/db_backup/
test_2023-04-06_17-14-53.sql  
```





# 案例十四、分表备份数据库

## 需求

1. 分表备份

## 代码实现

### 代码

```sh
#!/bin/bash
DATE=$(date +%F_%H-%M-%S)
HOST=localhost
USER=root
PASS=123456
BACKUP_DIR=/data/db_backup
DB_LIST=$(mysql -h$HOST -u$USER -p$PASS -s -e "show databases;" 2>/dev/null |egrep -v "Database|information_schema|mysql|performance_schema|sys")

for DB in $DB_LIST; do
    BACKUP_DB_DIR=$BACKUP_DIR/${DB}_${DATE}
    [ ! -d $BACKUP_DB_DIR ] && mkdir -p $BACKUP_DB_DIR &>/dev/null
    TABLE_LIST=$(mysql -h$HOST -u$USER -p$PASS -s -e "use $DB;show tables;" 2>/dev/null)
    for TABLE in $TABLE_LIST; do
        BACKUP_NAME=$BACKUP_DB_DIR/${TABLE}.sql
        if ! mysqldump -h$HOST -u$USER -p$PASS $DB $TABLE > $BACKUP_NAME 2>/dev/null; then
            echo "$BACKUP_NAME 备份失败!"
        fi
    done
done



```

### 实现

```sh
[root@master ~]# bash 30.sh
[root@master ~]# ls /data/db_backup/
test_2023-04-06_17-14-53.sql  test_2023-04-06_17-24-47

```

