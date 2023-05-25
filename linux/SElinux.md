# 简介

安全增强型Linux（SELinux）是一个Linux内核的功能，它提供支持访问控制的安全政策保护机制。本文介绍如何开启或关闭SELinux，并且避免系统无法启动的问题。

# 背景信息

一般情况下，开启SELinux会提高系统的安全性，但是会破坏操作系统的文件，造成系统无法启动的问题。如果您所在的企业或团队具有十分严格的安全策略，要求在Linux操作系统中开启SELinux，您可以参考本文的步骤开启，避免系统无法启动的问题。



# 永久生效（/etc/selinux/config）

找到`SELINUX=disabled`，按`i`进入编辑模式，通过修改该参数开启SELinux。

可以根据需求修改参数，开启SELinux有以下两种模式：

- 强制模式`SELINUX=enforcing`：表示所有违反安全策略的行为都将被禁止。
- 宽容模式`SELINUX=permissive`：表示所有违反安全策略的行为不被禁止，但是会在日志中作记录。



# 临时生效（setenforce 0 ）

用于切换seLinux状态

# 验证

1. 运行命令`getenforce`，验证SELinux状态。

   返回状态如果是`enforcing`，表明SELinux已开启。