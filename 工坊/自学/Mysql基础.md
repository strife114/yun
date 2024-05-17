# 下载

1. yum源配置

   ```shell
   # rpm --import https://repo.mysql.com/RPM-GPG-KEY-mysql-2022
   # rpm -Uvh https://repo.mysql.com//mysql57-community-release-el7-7.noarch.rpm
   ```

2. 下载MySQL

   ```sh
   # yum install -y mysql-community-server
   ```

3. 开启并设置自启

   ```sh
   # systemctl start mysqld
   # systemctl enable mysqld
   ```

4. 获取MySQL的初始密码

   ```sh
   # grep 'temporary password' /var/log/mysqld.log
   ```

5. 登录

   ```
   # mysql -uroot -p
   ```

6. 修改密码

   ```sh
   # alter user 'root'@'localhost' IDENTIFIED BY '密码';
   
   # 修改密码策略
   set global validate_password_policy=LOW;
   set global validate_password.length=6;
   
   # 配置root远程登录
   # IP地址即允许登录的ip地址，也可以填写%，表示允许任何地址
   # 密码表示给远程登录独立设置密码，和本地登录密码可以不同
   grant all privilees on *.* to root@"IP地址" identified by '密码' with grant option;
   
   flush privileges;
   ```

7. 退出且检查

   ```sh
   exit
   netstat -anp | grep 3306
   ```

   

# 增删改查

```mysql
# 查看数据库
show databases;
# 新建数据库（lll）
create database lll;
# 进入数据库
use lll;

# 查看表格
show tables;
# 创建表格
create table lll(id int(3), name varchar(4), salary int(3), job varchar(2))
# 查看表结构
desc lll;
# 查看表数据
select * from lll;

# 插入数据
insert into lll (id,name,salary,job) values(1,'lll',4000,'it');
# 改变表结构
alter table lll modify name varchar(6);
# 改变表数据
update lll set salary=5000;
# 修改表名
rename table lll to llx;


# 中创建表company（表结构如(id int not null primary key,name varchar(50),addr varchar(255))
create table company(id int(10) not null primary key, name varchar(50), addr varchar(255));

# 在表company中插入一条数据(1,"alibaba","china")
insert into company(id,name,addr)values(1,"alibaaba","china");
```

