# NTP

## 简介

> 时间同步协议（NTP）用来同步网络上不同主机的系统时钟。所有受管理的主机可以与一台名为NTP服务器的指定时间服务器同步时间。另一方面，NTP服务器则与任何公共NTP服务器或者你所选择的任何服务器同步自己的时间。所有NTP管理的设备其系统时间同步时可以精确到毫秒级。





# 实验

1. 查询ntp是否存在

   ```
   rpm -qa | grep NTP
   ```

2. 缺少则安装

   ```
   yum install -y ntp
   ```

3. **修改服务器配置文件**

   ```
   
   # For more information about this file, see the man pages
   # ntp.conf(5), ntp_acc(5), ntp_auth(5), ntp_clock(5), ntp_misc(5), ntp_mon(5).
   
   driftfile /var/lib/ntp/drift
   
   # Permit time synchronization with our time source, but do not
   # permit the source to query or modify the service on this system.
   restrict default nomodify notrap nopeer noquery
   
   # Permit all access over the loopback interface.  This could
   # be tightened as well, but to do so would effect some of
   # the administrative functions.
   restrict 127.0.0.1
   restrict ::1
   
   # 1
   restrict 127.127.1.0
   # 授权网段223上所有机器可以从这台机器上查询和时间同步
   restrict 192.168.223.0 mask 255.255.255.0 nomodify notrap
   
   # Hosts on local network are less restricted.
   #restrict 192.168.1.0 mask 255.255.255.0 nomodify notrap
   
   # Use public servers from the pool.ntp.org project.
   # Please consider joining the pool(http://www.pool.ntp.org/join.html).
   # 2
   #server 0.centos.pool.ntp.org iburst
   #server 1.centos.pool.ntp.org iburst
   #server 2.centos.pool.ntp.org iburst
   #server 3.centos.pool.ntp.org iburst
   # 3
   # 如果联不通外网，将上面四行注释
   server 127.127.1.0 # local clock
   # 当外部NTP服务器无法连接时，使用本机为NTP服务器
   fudge 127.127.1.0 stratum 10
   #broadcast 192.168.1.255 autokey        # broadcast server
   #broadcastclient                        # broadcast client
   #broadcast 224.0.1.1 autokey            # multicast server
   #multicastclient 224.0.1.1              # multicast client
   #manycastserver 239.255.254.254         # manycast server
   #manycastclient 239.255.254.254 autokey # manycast client
   
   # Enable public key cryptography.
   #crypto
   
   ```

4. 启动

   ```
   systemctl start ntpd
   
   # 设置自启
   systemct enable ntpd
   
   
   ```

5. 查看是否运行

   ```
   netstat -tlunp | grep ntp
   ```

6. 修改客户端配置文件

   ```
   
   # For more information about this file, see the man pages
   # ntp.conf(5), ntp_acc(5), ntp_auth(5), ntp_clock(5), ntp_misc(5), ntp_mon(5).
   
   driftfile /var/lib/ntp/drift
   
   # Permit time synchronization with our time source, but do not
   # permit the source to query or modify the service on this system.
   restrict default nomodify notrap nopeer noquery
   
   # Permit all access over the loopback interface.  This could
   # be tightened as well, but to do so would effect some of
   # the administrative functions.
   restrict 127.0.0.1
   restrict ::1
   
   # Hosts on local network are less restricted.
   #restrict 192.168.1.0 mask 255.255.255.0 nomodify notrap
   
   # Use public servers from the pool.ntp.org project.
   # Please consider joining the pool (http://www.pool.ntp.org/join.html).
   # 1
   #server 0.centos.pool.ntp.org iburst
   #server 1.centos.pool.ntp.org iburst
   #server 2.centos.pool.ntp.org iburst
   #server 3.centos.pool.ntp.org iburst
   
   # 2
   # add NTP server
   server 192.168.223.4 profer
   #broadcast 192.168.1.255 autokey        # broadcast server
   #broadcastclient                        # broadcast client
   #broadcast 224.0.1.1 autokey            # multicast server
   #multicastclient 224.0.1.1              # multicast client
   #manycastserver 239.255.254.254         # manycast server
   #manycastclient 239.255.254.254 autokey # manycast client
   
   # Enable public key cryptography.
   #crypto
   
   includefile /etc/ntp/crypto/pw
   
   # Key file containing the keys and key identifiers used when operating
   
   ```

7. 测试

   ```
   手动同步时间
   /usr/sbin/ntpdate 192.168.223.4
   查看与上层ntp服务器的状态
   ntpq -p
   查看时间同步状态：
   ntpstat
   ```

   





# Chronyd和NTP

## 1 简介

​        集群中节点之间需要时间同步，Chronyd不依赖外部的时间服务NTP，在内部搭建时间服务器。

        Chrony是网络时间协议（NTP）的一种实现，是一个类Unix系统上NTP客户端和服务器的替代品。Chrony客户端可以与NTP servers同步系统时间，也可以与参考时钟（例如：GPS接受设备）进行同步，还与手动输入的时间进行同步。同样Chrony也可以作为一个NTPv4（RFC 5905） server为其他计算机提供时间同步服务。
        Chrony 可以更快的同步系统时钟，具有更好的时钟准确度，并且它对于那些不是一直在线的系统很有帮助。Chrony在Internet上同步的两台机器之间的典型精度在几毫秒内，而在LAN上的机器之间的精度在几十微秒内。chronyd 更小、更节能，它占用更少的内存且仅当需要时它才唤醒 CPU。即使网络拥塞较长时间，它也能很好地运行。它支持 Linux 上的硬件时间戳，允许在本地网络进行极其准确的同步。Chrony 是自由开源的，并且支持 GNU/Linux 和 BSD 衍生版（比如 FreeBSD、NetBSD）、macOS 和 Solaris 等。

## 2 与ntpd对比

### （1）chronyd做的比ntpd好的

chronyd可以在时断时续访问参考时间源的环境下工作，而ntpd需要定期轮询参考时间源才能正常工作。
即使网络拥塞时间更长，chronyd也可以运行良好。
chronyd通常可以更快、更准确地同步时钟。
chronyd能够快速适应晶体振荡器温度变化引起的时钟频率的突然变化，而ntpd可能需要很长时间才能稳定下来。
在默认配置下，为了不影响其他正在运行的程序，chronyd从不在系统启动同步时钟之后执行时间步进。ntpd也可以配置为从不步进时间，但它必须使用不同的方法来调整时钟，这有一些缺点，包括对时钟精度的负面影响。
chronyd可以在更大的范围内调整Linux系统上的时钟频率，这使得它甚至可以在时钟损坏或不稳定的机器上运行。例如，在一些虚拟机上。
chronyd体积更小，占用的内存更少，而且只有在必要的时候才会唤醒CPU，这对于节能来说是更好的选择。

### （2）chronyd能做的但ntpd做不到的

chronyd提供了对孤立网络的支持，在孤立网络中，时间校正的唯一方法就是手动输入。例如，由管理员查看时钟。chronyd可以检查在不同的更新中修正的错误，从而估算出计算机增加或减少时间的速度，并在随后使用这个估算来调整计算机时钟。
chronyd可以计算RTC时钟（在计算机关闭时保持时间的时钟）的增益和损耗率。它可以在系统启动时使用这些计算的数据，以及从RTC时钟获取的时间调整值来设置系统时间。RTC时钟设备目前仅在Linux系统上可用。
支持Linux上的硬件时间戳，允许在本地网络上进行非常精确的同步。

### （3）ntpd做得到但chronyd做不到的

ntpd支持NTP v4（RFC 5905）的所有同步模式，包括broadcast、multicast和manycast clients and servers模式。请注意，broadcast和multicast模式（即使有身份验证）与普通servers and clients模式相比，更不精确、更不安全，通常应避免使用。
ntpd支持使用公钥加密的Autokey协议（RFC 5906）对服务器进行身份验证。注意，该协议已被证明是不安全的，可能会被Network Time Security（NTS）取代。
ntpd包含很多参考时间源的驱动程序，而chronyd依赖于其他程序（例如gpsd），以使用共享内存（SHM）或Unix domain socket（SOCK）访问参考时间源的数据。

### （4）chronyd与ntpd，该怎么选

除了由不支持Chrony的工具管理或监视的系统，或者具有不能与Chrony一起使用的硬件参考时钟的系统之外，其他系统都应该首选Chrony。
需要使用Autokey协议对数据包进行身份验证的系统只能使用ntpd，因为chronyd不支持这个协议。Autokey协议存在严重的安全问题，应避免使用该协议。使用对称密钥进行身份验证，而不是使用Autokey，这是chronyd和ntpd都支持的。Chrony支持更强的哈希函数，如SHA256和SHA512，而ntpd只能使用MD5和SHA1。
