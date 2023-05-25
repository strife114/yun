# 简介

1. 虚拟化，是指通过虚拟化技术将一台计算机虚拟为多台逻辑计算机。在一台计算机上同时运行多个逻辑计算机，每个逻辑计算机可运行不同的操作系统，并且[应用程序](https://baike.baidu.com/item/应用程序/5985445)都可以在相互独立的空间内运行而互不影响，从而显著提高计算机的工作效率

2. 虚拟化使用软件的方法重新定义划分IT资源，可以实现IT资源的动态分配、灵活调度、跨域共享，提高IT资源利用率，使IT资源能够真正成为社会基础设施，服务于各行各业中灵活多变的应用需求。

3. KVM(Kernel-Based Virtual Machines)是一个基于Linux内核的虚拟化技术, 可以直接将Linux内核转换为Hypervisor（系统管理程序）从而使得Linux内核能够直接管理虚拟机, 直接调用Linux内核中的内存管理、进程管理子系统来管理虚拟机。

   KVM的虚拟化需要硬件支持（如[Intel VT](https://baike.baidu.com/item/Intel VT)技术或者AMD V技术)。是基于硬件的完全虚拟化。而Xen早期则是基于软件模拟的Para-Virtualization，新版本则是基于硬件支持的完全虚拟化。但Xen本身有自己的[进程调度](https://baike.baidu.com/item/进程调度)器、[存储管理](https://baike.baidu.com/item/存储管理/9827115)模块等，所以代码较为庞大。广为流传的[商业系统](https://baike.baidu.com/item/商业系统)虚拟化软件VMware ESX系列是基于软件模拟的Full-Virtualization。



# 虚拟化分类

1. 全虚拟化：最流行的虚拟化方法使用名为Hypervisor的一种软件，在虚拟服务器和底层硬件之间建立一个抽象层。VMware和微软的VirtualPC是代表该方法的两个商用产品，而基于核心的虚拟机（KVM）是面向Linux系统的开源产品。Hypervisor可以捕获CPU指令，为指令访问硬件控制器和外设充当中介。因而，完全虚拟化技术几乎能让任何一款操作系统不用改动就能安装到虚拟服务器上，而它们不知道自己运行在虚拟化环境下。主要缺点是，Hypervisor 给处理器带来的负荷会很大。
2. 半虚拟化：完全虚拟化是处理器密集型技术，因为它要求Hypervisor管理各个虚拟服务器，并让它们彼此独立。减轻这种负担的一种方法就是，改动客户端操作系统，让它以为自己运行在虚拟环境下，能够与Hypervisor 协同工作。这种方法就叫准虚拟化（para-virtualization）Xen。它是开源准虚拟化技术的一个例子。操作系统作为虚拟服务器在Xen hypervisor上运行之前，它必须在核心层面进行某些改变。因此，Xen适用于BSD、Linux、Solaris及其他开源操作系统，但不适合像Windows这些专有的操作系统进行虚拟化处理，因为它们无法改动。准虚拟化技术的优点是性能高，经过准虚拟化处理的服务器可与Hypervisor协同工作，其响应能力几乎不亚于未经过虚拟化处理的服务器。准虚拟化与完全虚拟化相比优点明显，以至于微软和VMware都在开发这项技术，以完善各自的产品。



# KVM

## 环境

1. 配置至少2g内存
2. 开启虚拟化引擎
3. 两块硬盘(sdb为50g)
4. 关闭所有安全策略



## 检查环境

1. 检查内存是否为2g以上

   ```sh
   [root@localhost ~]# free
                 total        used        free      shared  buff/cache   available
   Mem:        3861292      244260     3470868       11860      146164     3417896
   Swap:       2097148           0     2097148
   
   ```

2. 检查cpu是否开启虚拟化支持

   ```sh
   [root@localhost ~]# grep -Ei 'vmx|svm' /proc/cpuinfo
   flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush mmx fxsr sse sse2 ss ht syscall nx pdpe1gb rdtscp lm constant_tsc arch_perfmon nopl xtopology tsc_reliable nonstop_tsc eagerfpu pni pclmulqdq vmx ssse3 fma cx16 pcid sse4_1 sse4_2 x2apic movbe popcnt tsc_deadline_timer aes xsave avx f16c rdrand hypervisor lahf_lm abm 3dnowprefetch invpcid_single ssbd ibrs ibpb stibp tpr_shadow vnmi ept vpid fsgsbase tsc_adjust bmi1 avx2 smep bmi2 invpcid rdseed adx smap clflushopt xsaveopt xsavec xgetbv1 arat md_clear spec_ctrl intel_stibp flush_l1d arch_capabilities
   flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush mmx fxsr sse sse2 ss ht syscall nx pdpe1gb rdtscp lm constant_tsc arch_perfmon nopl xtopology tsc_reliable nonstop_tsc eagerfpu pni pclmulqdq vmx ssse3 fma cx16 pcid sse4_1 sse4_2 x2apic movbe popcnt tsc_deadline_timer aes xsave avx f16c rdrand hypervisor lahf_lm abm 3dnowprefetch invpcid_single ssbd ibrs ibpb stibp tpr_shadow vnmi ept vpid fsgsbase tsc_adjust bmi1 avx2 smep bmi2 invpcid rdseed adx smap clflushopt xsaveopt xsavec xgetbv1 arat md_clear spec_ctrl intel_stibp flush_l1d arch_capabilities
   
   
   # 注意
   如果显示为空，则检查配置是否选择支持虚拟化
   
   ```

3. 挂载新磁盘

   ```sh
   [root@localhost ~]# lsblk
   [root@localhost ~]# mkds.ext4 /dev/sdb
   
   
   # 查看磁盘信息
   [root@localhost ~]# blkid /dev/sdb
   
   # 创建空目录并挂载
   [root@localhost ~]# mkdir /kvm_data
   [root@localhost ~]# mount /dev/sdb /kvm_data/
   # 配置自动挂载
   [root@localhost ~]# vim /etc/fstab
   /dev/sdb     /kvm_data           ext4      defaults    0 0
   ```



## 安装

1. 下载

   ```sh
   [root@localhost ~]# yum install -y  virt-*  libvirt  bridge-utils qemu-img
   ```

2. 配置网卡

   ```sh
   # 创建一个新网卡
   [root@localhost ~]# cd /etc/sysconfig/network-scripts/
   [root@localhost ~]# cp ifcfg-ens33 ifcfg-br0
   [root@localhost ~]# vim ifcfg-br0
   TYPE=Bridge
   BOOTPROTO=none
   NAME=br0
   DEVICE=br0
   ONBOOT=yes
   IPADDR=192.168.223.13
   NETMASK=255.255.255.0
   GATEWAY=192.168.223.2
   DNS1=114.114.114.114
   DNS2=8.8.8.8
   
   # 将旧网卡重置
   TYPE=Ethernet
   BOOTPROTO=none
   NAME=ens33
   DEVICE=ens33
   ONBOOT=yes
   BRIDGE=br0
   
   
   # 重启
   # service network restart
   
   # 查看
   [root@localhost ~]# ifconfig
   br0: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
           inet 192.168.223.13  netmask 255.255.255.0  broadcast 192.168.223.255
           inet6 fe80::20c:29ff:fe89:ffd  prefixlen 64  scopeid 0x20<link>
           ether 00:0c:29:89:0f:fd  txqueuelen 1000  (Ethernet)
           RX packets 253  bytes 23806 (23.2 KiB)
           RX errors 0  dropped 0  overruns 0  frame 0
           TX packets 142  bytes 27884 (27.2 KiB)
           TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0
   
   ens33: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
           inet6 fe80::20c:29ff:fe89:ffd  prefixlen 64  scopeid 0x20<link>
           ether 00:0c:29:89:0f:fd  txqueuelen 1000  (Ethernet)
           RX packets 254  bytes 27408 (26.7 KiB)
           RX errors 0  dropped 1  overruns 0  frame 0
           TX packets 152  bytes 32028 (31.2 KiB)
           TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0
   
   lo: flags=73<UP,LOOPBACK,RUNNING>  mtu 65536
           inet 127.0.0.1  netmask 255.0.0.0
           inet6 ::1  prefixlen 128  scopeid 0x10<host>
           loop  txqueuelen 1000  (Local Loopback)
           RX packets 0  bytes 0 (0.0 B)
           RX errors 0  dropped 0  overruns 0  frame 0
           TX packets 0  bytes 0 (0.0 B)
           TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0
   
   virbr0: flags=4099<UP,BROADCAST,MULTICAST>  mtu 1500
           inet 192.168.122.1  netmask 255.255.255.0  broadcast 192.168.122.255
           ether 52:54:00:db:6d:12  txqueuelen 1000  (Ethernet)
           RX packets 0  bytes 0 (0.0 B)
           RX errors 0  dropped 0  overruns 0  frame 0
           TX packets 0  bytes 0 (0.0 B)
           TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0
   
   # 注意
   此处br0网卡的配置为本虚拟机的nat网段
   ```

   



## 配置KVM

1. 启动服务

   ```sh
   # 检查模块是否加载
   [root@localhost ~]# lsmod|grep kvm
   # 启动并检查是否启动
   [root@localhost ~]# systemctl start libvirtd
   [root@localhost ~]# ps -ef |grep libvirt
   # 查看网卡
   [root@localhost ~]# brctl show
   ```

2. 上传镜像（方法自定）

3. 虚拟机安装

   ```sh
   [root@localhost ~]# virt-install --name=test --memory=512,maxmemory=1024 --vcpus=1,maxvcpus=2 --os-type=linux --os-variant=rhel7 --location=/tmp/CentOS-7-x86_64-DVD-2009.iso --disk path=/kvm_data/test.img,size=10  --bridge=br0 --graphics=none --console=pty,target_type=serial --extra-args="console=tty0 console=ttyS0"
   
   ```

4. 配置时间区域

   ```sh
   2-->1(Set timezone)-->2(Asia亚洲)-->65(Shanghai)-->2选项旁边变为x代表已经设置好了
   ```

5. 配置分区方式

   ```sh
   5-->一直c
   ```

6. 配置root密码

   ```sh
   8-->输入密码-->yes-->完成
   ```

7. 安装

   ```sh
   b
   ```





## 运维管理

### 虚拟机管理

```sh
# 查看所有虚拟机简洁信息
[root@localhost ~]# virsh list --all

# 查看虚拟机配置文件
[root@localhost ~]# virsh edit test

# 进入指定虚拟机
[root@localhost ~]# virsh console test

# 开启/关闭虚拟机
[root@localhost ~]# virsh start/shutdown test

# 强制关闭虚拟机
[root@localhost ~]# virsh destroy test

# 删除虚拟机
[root@localhost ~]# virsh undefine test

# 开机自启
[root@localhost ~]# virsh autostart test

# 取消自启
[root@localhost ~]# virsh autostart --disable test

# 挂起
[root@localhost ~]# virsh suspend test

# 恢复
[root@localhost ~]# virsh resume test

# 克隆
[root@localhost ~]# virt-clone --original test --name test2 --file /kvm_data/test2.img
参数：
  --original：指定克隆源虚拟机。
  --name：指定克隆后的虚拟机名字。
  --file：指定目标虚拟机的虚拟磁盘文件。
```

### 快照管理

```sh
# 创建快照
[root@localhost ~]# virsh snapshot-create test

# 查看详细快照信息
[root@localhost ~]# qemu-img info /kvm_data/test.img
# 查看简洁快照信息
[root@localhost ~]# virsh snapshot-list test

# 查看快照版本
[root@localhost ~]# virsh snapshot-current test

# 查看所有快照
[root@localhost ~]# ls /var/lib/libvirt/qemu/snapshot/test/

# 恢复快照
[root@localhost ~]# virsh snapshot-revert test 1679987562

# 删除快照
[root@localhost ~]# virsh snapshot-delete test 1679987562
```

### 磁盘管理

```sh
# 查看磁盘详细信息
[root@localhost ~]# qemu-img info /kvm_data/test.img

# 创建磁盘
# 创建一个2g的raw格式磁盘
[root@localhost ~]# qemu-img create -f raw /kvm_data/test_1.img 2G

# 格式转换
# raw转qcow2
[root@localhost ~]# qemu-img convert -O qcow2 /kvm_data/test_1.img 
/kvm_data/test_1.img






# 更改启动磁盘格式
[root@localhost ~]# virsh edit test
# 找到disk标识符修改type和file
<disk type='file' device='disk'>
      <driver name='qemu' type='raw'/>
      <source file='/kvm_data/test_1.raw'/>
      <target dev='vda' bus='virtio'/>
      <address type='pci' domain='0x0000' bus='0x00' slot='0x06' function='0x0'/>
</disk>


# 磁盘扩容
# 扩容raw格式
# 重启虚拟机后生效
[root@localhost ~]# qemu-img resize /kvm_data/test_1.raw +2G
# 进入虚拟机进行分区
fdisk /dev/vda
n-->p-->三个回车-->w
fdisk -l




# 磁盘增加
[root@localhost ~]# qemu-img create -f raw /kvm_data/test_2.raw 5G
[root@localhost ~]# virsh shutdown test
[root@localhost ~]# virsh edit test
# 找到disk区域标识，在启动磁盘下方添加
    <disk type='file' device='disk'>
      <driver name='qemu' type='raw'/>
      <source file='/kvm_data/test_2.raw'/>
      <target dev='vdb' bus='virtio'/>
      <address type='pci' domain='0x0000' bus='0x00' slot='0x09' 
function='0x0'/>
</disk>

[root@localhost ~]# virsh start test


# 注意
1.扩容时若提示qemu-img: Can't resize an image which has snapshots，则需要删除快照
```

### 性能管理

```sh
# 查看虚拟机配置信息
[root@localhost ~]# virsh dominfo test


# 性能配置信息
[root@localhost ~]# virsh edit test
 # 最大内存
 <memory unit='KiB'>1048576</memory>
 # 可用内存
 <currentMemory unit='KiB'>524288</currentMemory>
 # 最大cpu
 <vcpu placement='static' current='1'>2</vcpu>



# 修改内存(修改配置文件)
# virsh edit test
<memory unit='KiB'>1048576</memory>  
<currentMemory unit='KiB'>624288</currentMemory>
<vcpu placement='static' current='1'>2</vcpu>
# 重启虚拟机
[root@localhost ~]# virsh shutdown test
[root@localhost ~]# virsh start test
# 查看配置信息
[root@localhost ~]# virsh dominfo test



# 动态修改内存
[root@localhost ~]# virsh setmem test 800m
# 动态修改vcpu
[root@localhost ~]# virsh setvcpus test 2
# 查看
[root@localhost ~]# virsh dominfo test
# 将修改信息写入配置文件
[root@localhost ~]# virsh dumpxml test > /etc/libvirt/qemu/test.xml

# 注意
1.cpu只可增加不可减少
```

### 网络管理

```sh
# 查看网卡列表
# 查看请在虚拟机运行状态查看
[root@localhost ~]# virsh domiflist test

# 增加一块网卡
# virbr0类似VMware的NAT模式
# 如果写--source br0，则网络模式为桥接
[root@localhost ~]# virsh attach-interface test --type bridge  --source virbr0
# 写入配置文件
[root@localhost ~]# virsh dumpxml test > /etc/libvirt/qemu/test.xml

```

### 迁移管理

```sh
# 查看磁盘所在目录
[root@localhost ~]# virsh domblklist test
Target     Source
------------------------------------------------
vda        /kvm_data/test.img
vdb        /kvm_data/test_2.img
hda        -

# 迁移虚拟机
# 
# 迁移配置和磁盘文件
[root@localhost ~]# virsh dumpxml test > /etc/libvirt/qemu/test02.xml 

[root@localhost ~]# rsync  -avz  /etc/libvirt/qemu/test02.xml   root@192.168.223.6:/etc/libvirt/qemu/test02.xml 
或
[root@localhost ~]# scp /etc/libvirt/qemu/test02.xml 192.168.223.6:/etc/libvirt/qemu/test02.xml 

[root@localhost ~]# rsync -av /kvm_data/test.img  /kvm_data/test02.img

# 修改配置文件(远端迁移不需要修改前两项)
1.修改domname
<name>test02</name>
2.修改uid(只修改数字即可)
<uuid>1e62c108-e613-436a-9d03-dc5c0b64b9b1</uuid>
3.修改磁盘路径
  <disk type='file' device='disk'>
      <driver name='qemu' type='raw'/>
      <source file='/kvm_data/test02raw'/>
      <backingStore/>
      <target dev='vda' bus='virtio'/>
      <alias name='virtio-disk0'/>
      <address type='pci' domain='0x0000' bus='0x00' slot='0x06' function='0x0'/>
  </disk>

# 定义新虚拟机
[root@localhost ~]# virsh define /etc/libvirt/qemu/test02.xml 

# 查看
[root@localhost ~]# virsh list --all

# 注意
1.操作的前提是关闭虚拟机
2.如果是迁移到别处，需要把配置文件和磁盘文件拷贝到目标机器
3.如果是本地迁移则不需要迁移磁盘文件
```

