# MongoDB安装

## 3.4

```shell
# vim /etc/yum.repos.d/mongodb.repo
[mongodb-org-3.4]
name=MongoDB Repository
baseurl=https://repo.mongodb.org/yum/redhat/$releasever/mongodb-org/3.4/x86_64/
gpgcheck=1
enabled=1	
gpgkey=https://www.mongodb.org/static/pgp/server-3.4.asc

# 可以看到mongodb包
# yum list |grep mongodb 
# yum install -y mongodb-org


#启动
systemctl start mongod
```

## 4.2

```shell
vim /etc/yum.repos.d/mongodb-org-4.2.repo
[mongodb-org-4.2]
name=MongoDB Repository
baseurl=https://repo.mongodb.org/yum/redhat/$releasever/mongodb-org/4.2/x86_64/
gpgcheck=1
enabled=1	
gpgkey=https://www.mongodb.org/static/pgp/server-4.2.asc
```

# MongoDB配置文件

```shell
vim /etc/mongod.conf
# 下面是配置文件中默认未注释部分，并不是全部的
# 日志文件配置
systemLog:
  destination: file
  logAppend: true
  path: /var/log/mongodb/mongod.log

storage:
  # 数据库存放目录
  dbPath: /var/lib/mongo
  journal:
    enabled: true

processManagement:
  fork: true 
  # location of pidfile  进程文件路径
  pidFilePath: /var/run/mongodb/mongod.pid
  timeZoneInfo: /usr/share/zoneinfo

net:
  # 默认端口
  port: 27017
  # 绑定ip，多个ip用逗号相隔
  bindIp: 127.0.0.1
```

# **MongoDB连接**

```shell
# 默认端口和ip，可以直接mongo进入
mongo

# 用ip和端口连接进入
mongo --port 27017 --host 127.0.0.1

# 如果设置了用户和密码
mongo -u后面接用户名 -p后面接密码 --authenticationDatabase 后面接你加密的数据库
# 这个和mysql类似，用户通常是限制于某一个数据库
```



# MongoDB常见配置

## mongodb用户管理

user指定用户，customData为说明字段，可以省略，pwd为密码，roles指定用户的角色，db指定库名

```mysql
> use admin
# 在数据库中创建用户admin，密码为admin122
> db.createUser( { user: "admin", customData: {description: "superuser"}, pwd: "admin122", roles: [ { role: "root", db: "admin" } ] } )
# 列出所有用户，需要切换到admin库
> db.system.users.find()  

# 重启服务
systemctl restart mongod
# admin用户登录
mongo -u "admin" -p "admin122" --authenticationDatabase "admin"
```

```mysql
show users  //查看当前库下所有的用户
db.dropUser('admin') //删除用户
```

 test1用户对db1库读写，对db2库只读。

 之所以先use db1,表示用户在 db1 库中创建，就一定要db1库验证身份，即用户的信息跟随随数据库。比如上述 test1虽然有 db2 库的读取权限，但是一定要先在db1库进行身份验证，直接访问会提示验证失败。


```mysql
use  db1
switched to db db1
> db.createUser( { user: "test1", pwd: "123aaa", roles: [ { role: "readWrite", db: "db1" }, {role: "read", db: "db2" } ] } )

> use  db2
> db.auth("test1", "123aaa")
Error: Authentication failed.
0
```

## **MongoDB角色说明**

- Read：读权限
- readWrite： 读写
- dbAdmin：允许用户在指定数据库中执行管理函数，如索引、删除，查看统计或访问system.profile
- userAdmin:允许用户向system.users集合写入，可以在指定数据库里创建、删除和管理用户
- clusteradmin：旨在admin数据库中可用，赋予用户所有分片和复制集相关函数的管理权限
- readAnyDatabase：只在admin数据库中可用，赋予用户所有数据库的读权限
- readWriteAnyDateabase:只在admin数据库中可用，赋予用户所有数据库的读写权限
- useradminAnyDatabase:只在admin数据库中可用，赋予用户所有数据库的useradmin权限
- dbAdminAnyDatabase:只在admin数据库中可用，赋予用户所有数据库的dbAdmin权限
- root：只在admin数据库可用，超级权限



##  MongoDB集合命令

```mysql
# 集合命令创建
db.createCollection("<collectionsName>")
db.createCollection("myCollection")
# 查看当前数据库下的所有集合
show collections
# 创建一个带有options操作的集合：
 db.createCollection("mycol", { capped : true, size : 6142800, max : 10000 } )
 # 直接插入数据，这样也会自动创建一个集合 tutorialspoint
 db.tutorialspoint.insert({"name" : "tutorialspoint"})
 # 删除指定的集合名称
 db.tutorialspoint.drop()
```

**<font color='orange'>集合命令介绍</font>**

```mysql
db.createCollection("mycol", { capped : true, size : 6142800, max : 10000 } ) 
# 语法：db.createCollection(name,options)

参数详解：
name     集合的名字，options可选，用来配置集合的参数，参数如下
capped true/false （可选）如果为true，则启用封顶集合。封顶集合是固定大小的集合，当它达到其最大大小，会自动覆盖最早的条目。如果指定true，则也需要指定尺寸参数。
autoindexID  true/false （可选）如果为true，自动创建索引_id字段的默认值是false。
size （可选）指定最大大小字节封顶集合。如果封顶如果是 true，那么你还需要指定这个字段。单位B
max （可选）指定封顶集合允许在文件的最大数量。
```

## MongoDB文档命令

```mysql
# 单个插入
db.mycol.insert({"name":"张三","age":18})
db.mycol.find()

# 多个插入
db.mycol.insert([{"name":"李四","age":18},{"name":"王五"}])
db.mycol.insertOne({"name":"张三One","age":18})
db.mycol.find()
db.mycol.insertMany([{"name":"李四M","age":18},{"name":"王五M"}])

# 文档更新
> db.mycol.update({"name":"张三"},{$set:{"name":"张三aaa"}})

# 文档删除
db.test.insert([{"name":"李四","age":18},{"name":"王五"},{"name":"赵六","age":18},{"name":"Tom","age":19},{"name":"Anna","age":20}])
db.test.remove({'name':'王五'})
```



## MongoDB数据管理

```mysql
show collections //查看集合，或者使用show  tables
db.Account.insert({AccountID:1,UserName:"123",password:"123456"})  //如果集合不存在，直接插入数据，则mongodb会自动创建集合
db.Account.update({AccountID:1},{"$set":{"Age":20}}) //更新
db.Account.find()   //查看所有文档
db.Account.find({AccountID:1})   //根据条件查询
db.Account.remove({AccountID:1})  //根据条件删除
db.Account.drop() //删除所有文档，即删除集合
use dbname  //先进入对应的库
db.printCollectionStats()  // 然后查看集合状态
```

## MongoDB数据库管理

```mysql
#数据库查看
show dbs #查看所有数据库
db 或 db.getName() #查看当前使用的数据库
#查看当前数据库状态
db.stats()
#查看当前数据库版本信息
db.version（）
#查看当前db的连接服务器机器地址
db.getmongo()
#删除当前使用数据库
db.dropDatabase()
#查询之前的错误信息和清除
db.getPrevError()
db.resetError()
#查看集合数据
show collections
db.dropDatabase()
#查看集合中的文档数据
db.mycol.find()

db.version()  //查看版本
use userdb  //如果库存在就切换，不存在就创建
show dbs //查看库，此时userdb并没有出现，这是因为该库是空的，还没有任何集合，只需要创建一个集合就能看到了 
db.createCollection('clo1') //创建集合clo1，在当前库下面创建
db.dropDatabase() //删除当前库，要想删除某个库，必须切换到那个库下
db.stats()  //查看当前库的信息
db.serverStatus()   //查看mongodb服务器的状态
```



# MongoDB常规操作

## Mongodb集合

### 创建MongoDB集合

db.createCollection(name, options)
参数说明：

- name: 要创建的集合名称
- options: （可选）参数的集合

options 可以是如下参数：

| **参数名**                                  | **类型** | **描述**                                                     |
| ------------------------------------------- | -------- | ------------------------------------------------------------ |
| capped                                      | 布尔     | （可选）如果为 true，则创建最大容量的集合，如果超出容量capped集合将自动的覆盖旧数据，**当设置为true时，则需要指定size参数大小进行设置** |
| autoIndexId                                 | 布尔     | （可选）如为 true，自动在 _id 字段创建索引。默认为 false。【3.4版本开始移除该参数，详见[[SERVER-19067] Warn at creation that autoIndexId:false is deprecated - MongoDB Jira](https://jira.mongodb.org/browse/SERVER-19067) |
| 】                                          |          |                                                              |
| size                                        | 数值     | （可选）为固定集合指定一个最大值，即字节数。                 |
| **如果 capped 为 true，也需要指定该字段。** |          |                                                              |
| max                                         | 数值     | （可选）指定固定集合中包含文档的最大数量。                   |

[注]在插入文档时，MongoDB 首先检查固定集合的 size 字段，然后检查 max 字段。
直接创建一个集合：
```mysql
db.createCollection("<collectionsName>")
#创建集合myCollection
db.createCollection("myCollection")
```
创建一个带有options操作的集合：
```
 #创建一个带有options操作的集合：
 db.createCollection("mycol", { capped : true, size : 6142800, max : 10000 } )
```

直接插入数据，这样也会自动创建一个集合

```
db.tutorialspoint.insert({"name" : "tutorialspoint"})
```
### 删除指定的集合
集合删除很简单，直接db.<collectionName>.drop()
```mysql
#删除集合
db.<collectionName>.drop()
#查看集合
> show collections
> db.myCollection.drop()
true
> db.mycol.drop()
true
```


## 数据类型

```shell
MongoDB supports many datatypes. Some of them are −

String − This is the most commonly used datatype to store the data. String in MongoDB must be UTF-8 valid.

Integer − This type is used to store a numerical value. Integer can be 32 bit or 64 bit depending upon your server.

Boolean − This type is used to store a boolean (true/ false) value.

Double − This type is used to store floating point values.

Min/ Max keys − This type is used to compare a value against the lowest and highest BSON elements.

Arrays − This type is used to store arrays or list or multiple values into one key.

Timestamp − ctimestamp. This can be handy for recording when a document has been modified or added.

Object − This datatype is used for embedded documents.

Null − This type is used to store a Null value.

Symbol − This datatype is used identically to a string; however, it's generally reserved for languages that use a specific symbol type.

Date − This datatype is used to store the current date or time in UNIX time format. You can specify your own date time by creating object of Date and passing day, month, year into it.

Object ID − This datatype is used to store the document’s ID.

Binary data − This datatype is used to store binary data.

Code − This datatype is used to store JavaScript code into the document.

Regular expression − This datatype is used to store regular expression.
```

## Mongodb文档操作

### 文档插入  insert

```mysql
#单个插入
db.mycol.insert({"name":"张三","age":18})
db.mycol.find()
#多个插入
db.mycol.insert([{"name":"李四","age":18},{"name":"王五"}])
```

 insertOne(document)方法

insert() 方法可以同时插入<font  color='red'>**多个文档**</font>，但如果您只需要将一个文档插入到集合中的话，可以使用 insertOne() 方法，该方法的语法格式如下：

```MYSQL
db.mycol.insertOne({"name":"张三One","age":18})
db.mycol.find()
```

insertMany(documents)方法

```
 db.mycol.insertMany([{"name":"李四M","age":18},{"name":"王五M"}])
```

### 文档更新  update

update() 方法用于更新已存在的文档。

```MYSQL
> db.mycol.update({"name":"张三"},{$set:{"name":"张三aaa"}})
```

### 文档删除 drop

文档删除主要是使用drop方法，但是要注意对于capped collection无法进行删除操作，以下则是进行具体操作的示例，这里先造点数据

```mysql
db.test.insert([{"name":"李四","age":18},{"name":"王五"},{"name":"赵六","age":18},{"name":"Tom","age":19},{"name":"Anna","age":20}])
```

示例：

1. 简单进行条件删除：

```mysql
db.test.remove({'name':'王五'})
```

2. 在version2.6 及其后续版本提供了更为复杂的删除方案：

```
db.collection.remove(
                  <query>,
                   {
                             justOne: <boolean>,
                             writeConcern: <document>,
                             collation: <document>,
                             let: <document> // Added in MongoDB 5.0
                   }
        )
```

| **参数**     | **类型** | **描述**                                                     |
| ------------ | -------- | ------------------------------------------------------------ |
| query        | document | 使用query operators指定删除条件。要删除集合中的所有文档，请传递空文档({})。 |
| justOne      | boolean  | 可选的。要将删除限制为仅一个文档，请设置为true。省略使用false的默认 value 并删除符合删除条件的所有文档。 |
| writeConcern | document | 可选的。表示写关注的文件。省略使用默认写入问题。见写关注。 如果在事务中运行，请不要为操作明确设置写关注点。要对事务使用写关注，请参见 事务和写关注。 |
| collation    | document | 可选的。 指定要用于操作的排序规则。 排序规则允许用户为 string 比较指定 language-specific 规则，例如字母和重音标记的规则。 排序规则选项具有以下语法： collation：{ locale：<string>， caseLevel：<boolean>， caseFirst：<string>， strength：<int>， numericOrdering：<boolean>， alternate：<string>， maxVariable：<string>， backwards ：<boolean> } 指定排序规则时，locale字段是必填字段;所有其他校对字段都是可选的。有关字段的说明，请参阅整理文件。 如果未指定排序规则但集合具有默认排序规则(请参阅db.createCollection())，则操作将使用为集合指定的排序规则。 如果没有为集合或操作指定排序规则，MongoDB 使用先前版本中用于 string 比较的简单二进制比较。 您无法为操作指定多个排序规则。对于 example，您不能为每个字段指定不同的排序规则，或者如果使用排序执行查找，则不能对查找使用一个排序规则，而对排序使用另一个排序规则。 version 3.4 中的新内容。 |

注意：insert(): 若插入的数据主键已经存在，则会抛 **org.springframework.dao.DuplicateKeyException** 异常，提示主键重复，不保存当前数据。



# PHP连接MongoDB

## 安装mongodb扩展

**<font  color='orange'>方法1：下载扩展mongoDB</font>**

本案例使用的版本为<font  color='red'>php5.4</font>，在PHP5.4中只用添加mongo.so即可，在<font  color='red'>php7.0</font>以后的版本中只需添加mongodb.so即可

```shell
cd /usr/local/src/
git clone https://github.com/mongodb/mongo-php-driver
cd mongo-php-driver
git submodule update --init
/usr/local/php/bin/phpize
./configure --with-php-config=/usr/local/php/bin/php-config
make && make install
/usr/local/php/lib/php/extensions/no-debug-zts-20170718/

vi /usr/local/php/etc/php.ini //增加 extension=mongodb.so
/usr/local/php/bin/php -m
```

**<font  color='orange'>方法2：下载扩展mongoDB</font>**

```shell
 yum  -y install m4  autoconf
 cd /usr/local/src/
 wget https://pecl.php.net/get/mongodb-1.3.0.tgz 
 tar -zxvf mongodb-1.3.0.tgz
 cd mongodb-1.3.0
 /usr/local/php/bin/phpize
 ./configure --with-php-config=/usr/local/php/bin/php-config
 make && make install
 vi /usr/local/php/etc/php.ini 
//增加 extension=mongodb.so extension=mongo.so
wget https://pecl.php.net/get/mongo-1.5.2.tgz
tar -zxvf mongo-1.5.2.tgz 
/usr/local/php/bin/phpize
 ./configure --with-php-config=/usr/local/php/bin/php-config
 make && make install

 /usr/local/php/bin/php -m
```

## 扩展测试验证

参考文档 https://docs.mongodb.com/ecosystem/drivers/php/

 http://www.runoob.com/mongodb/mongodb-php.html

```shell
service mongod start
systemctl stop firewalld
setenforce 0
```

**配置验证**

```shell
 vi /usr/local/apache2/htdocs/1.php //增加
<?php
$m = new MongoClient(); // 连接
$db = $m->test; // 获取名称为 "test" 的数据库
$collection = $db->createCollection("runoob");
echo "集合创建成功";
?>
ln /usr/local/php/bin/php  /usr/bin/
[root@localhost htdocs]# php  1.php
集合创建成功
```

在php7.0后的版本中因语法有部分修改所以在<font color='orange'>**PHP7.0**</font>以后的版本中测试使用下边两个语句

<font  color='red'>两个PHP文件，先执行第一个；第一个是插入数据的，第二个是查看结果的</font>

第一个文件：插入数据

```php
<?php
$bulk = new MongoDB\Driver\BulkWrite;
$document = ['_id' => new MongoDB\BSON\ObjectID, 'name' => '菜鸟教程'];

$_id= $bulk->insert($document);

var_dump($_id);

$manager = new MongoDB\Driver\Manager("mongodb://localhost:27017");  
$writeConcern = new MongoDB\Driver\WriteConcern(MongoDB\Driver\WriteConcern::MAJORITY, 1000);
$result = $manager->executeBulkWrite('test.runoob', $bulk, $writeConcern);
?>
```

第二个文件：查看结果

```shell
<?php
$manager = new MongoDB\Driver\Manager("mongodb://localhost:27017");  

// 插入数据
$bulk = new MongoDB\Driver\BulkWrite;
$bulk->insert(['x' => 1, 'name'=>'菜鸟教程', 'url' => 'http://www.runoob.com']);
$bulk->insert(['x' => 2, 'name'=>'Google', 'url' => 'http://www.google.com']);
$bulk->insert(['x' => 3, 'name'=>'taobao', 'url' => 'http://www.taobao.com']);
$manager->executeBulkWrite('test.sites', $bulk);

$filter = ['x' => ['$gt' => 1]];
$options = [
    'projection' => ['_id' => 0],
    'sort' => ['x' => -1],
];

// 查询数据
$query = new MongoDB\Driver\Query($filter, $options);
$cursor = $manager->executeQuery('test.sites', $query);

foreach ($cursor as $document) {
    print_r($document);
}
?>
```









# MongoDB副本集

## 实验环境

| IP           | 角色   |
| ------------ | ------ |
| 192.168.6.3  | master |
| 192.168.6.11 | slave  |
| 192.168.6.12 | slave  |

## 时代变迁

1. 早期版本使用master-slave，一主一从和MySQL类似，但slave在此架构中为只读，当主库宕机后，从库不能自动切换为主
2. 目前已经淘汰master-slave模式，改为副本集，这种模式下有一个主(primary)，和多个从(secondary)，只读。支持给它们设置权重，当主宕掉后，权重最高的从切换为主
3. 在此架构中还可以建立一个仲裁(arbiter)的角色，它只负责裁决，而不存储数据
4. 再此架构中读写数据都是在主上，要想实现负载均衡的目的需要手动指定读库的目标server





## 文件配置（3）

```sh
# vim /etc/mongod.conf
net:
  port: 27017
  #bindIp: 127.0.0.1  # Listen to local interface only, comment to listen on all interfaces.
  # 根据机器的不同修改不同的ip
  bindIp: 127.0.0.1,192.168.6.3
  
#replication:
replication:
  oplogSizeMB: 20
  replSetName: aminglinux
```

## 命令配置（3）

```sh
# systemctl restart mongod


# 远程连接测试
# mongo
# mongo --host 192.168.6.11/192.168.6.12
```

## 主从配置操作（192.168.6.3）

```sh
> use admin
switched to db admin
> config={_id:"aminglinux",members:[{_id:0,host:"192.168.6.3:27017"},{_id:1,host:"192.168.6.11:27017"},{_id:2,host:"192.168.6.12:27017"}]}
> rs.initiate(config)

# 查看状态
> rs.status()
id  0 SECONDARY  id  1  STARTUP  id 2  STARTUP

# 注意
1. 如果两个从机状态为statestr、startup，可以尝试以下解决方法

# 解决方法
1. 进行以下操作
   > var config={_id:"aminglinux",members:[{_id:0,host:"192.168.6.3:27017"},{_id:1,host:"192.168.6.11:27017"},{_id:2,host:"192.168.6.12:27017"}]}
```

## 副本集测试

```sh
# 测试1
master主机
aminglinux:PRIMARY> 

slave1，slave2副机
aminglinux:SECONDARY> 

# 测试2
# 主机建库，建集合
> use mydb
> db.acc.insert({AccountID:1,UserName:"fdy" password:"123456“})
> 
# 从机查看
> show dbs
admin  0.000GB
local  0.000GB
mydb   0.000GB



# 注意
1. 如果有getERRor的报错信息，可尝试以下解决方法

# 解决方法
1. 执行命令
   db.getMongo().setSlaveOk()
```



## 副本集更改权重

```sh
# 查看权重
cfg = rs.conf()

# 赋予主从权重（值越高优先级越高）
aminglinux:PRIMARY> cfg.members[0].priority = 3
3
aminglinux:PRIMARY> cfg.members[1].priority = 2
2
aminglinux:PRIMARY> cfg.members[2].priority = 1
1

```

## 权重跳转

```sh
# 在master上执行以下命令，使从节点变为主节点
# iptables -I INPUT -p TCP --dport 27017 -j DROP



# 从机上查看权重
# mongo
aminglinux:PRIMARY>
```









# MongoDB分片

## 简介

1. mongos：是整个分片架构的核心。数据库集群的入口，所有的请求都通过mongos进行协调，通常有多个mongos作为请求的入口，保证高可用。对客户端而言 不知道是否有分片，只需要把数据交给mongos。mongos本身没有任何数据，他也不知道该怎么处理这数据，去找config server。
2. config server:配置服务器，存储集群所有节点、分片数据路的信息。默认需要配置3个Config Server节点，保证高可用。mongos本身并没有物理存储分片服务器和数据路由信息，只是缓存再内存里。第一次启动或者重启就会从config server加载配置信息。
3. shard：真正的数据存储位置，可以看成是一个个副本集。
4. 大致的工作流程：客户端提交数据，传给mongos进程，mongos查看配置服务器config server，知道了它包含的shard有哪些，由此把数据均衡分配给各个shard。



## 文件配置（3）

``` sh
mkdir -p /data/mongodb/mongos/log/
mkdir -p /data/mongodb/config/{data,log}
mkdir -p /data/mongodb/shard1/{data,log}
mkdir -p /data/mongodb/shard2/{data,log}
mkdir -p /data/mongodb/shard3/{data,log}
mkdir  -p /etc/mongod


# 修改配置文件
vi /etc/mongod/config.conf 
# 添加以下内容
pidfilepath = /var/run/mongodb/configsrv.pid
dbpath = /data/mongodb/config/data
logpath = /data/mongodb/config/log/congigsrv.log
logappend = true
bind_ip = 0.0.0.0
port = 21000
fork = true
configsvr = true
# 副本集名称
replSet = configs
# 设置最大连接数
maxConns = 20000





# 启动服务
mongod -f /etc/mongod/config.conf

# 进入
mongo --port 21000
> use admin
> config = { _id: "configs", members: [ {_id : 0, host : "192.168.6.3:21000"},{_id : 1, host : "192.168.6.11:21000"},{_id : 2, host : "192.168.6.12:21000"}] }
{ "ok" : 1 }
```

## Shard分片(3)

```sh
# vim /etc/mongod/shared1.conf
# 加入以下内容
pidfilepath = /var/run/mongodb/shard1.pid
dbpath = /data/mongodb/shard1/data
logpath = /data/mongodb/shard1/log/shard1.log
logappend = true
bind_ip = 0.0.0.0
port = 27001
fork = true
# 打开web监控
httpinterface = true
rest = true
# 副本集名称
replSet = shard1
shardsvr = true
# 设置最大连接数
maxConns = 20000


# vim /etc/mongod/shard2.conf
pidfilepath = /var/run/mongodb/shard2.pid
dbpath = /data/mongodb/shard2/data
logpath = /data/mongodb/shard2/log/shard2.log
logappend = true
bind_ip = 0.0.0.0
port = 27002
fork = true
httpinterface = true
rest=true
replSet = shard2
shardsvr = true
maxConns=20000

# vim /etc/mongod/shard3.conf
pidfilepath = /var/run/mongodb/shard3.pid
dbpath = /data/mongodb/shard3/data
logpath = /data/mongodb/shard3/log/shard3.log
logappend = true
bind_ip = 0.0.0.0
port = 27003
fork = true
httpinterface = true
rest=true
replSet = shard3
shardsvr = true
maxConns=20000
```

## 启动服务(3)

```sh
# config-server
mongod -f /etc/mongod/config.conf  
# 启动shard副本集
mongod -f /etc/mongod/shard1.conf   #27001
mongod -f /etc/mongod/shard2.conf   #27002
mongod -f /etc/mongod/shard3.conf   #27003
# 启用mongos服务
mongos -f /etc/mongod/mongos.conf

ps  -ef | grep mongod
```

## 初始化配置(3)

```sh
# 192.168.6.3
> use admin
switched to db admin
> config = { _id: "shard1", members: [ {_id : 0, host : "192.168.6.3:27001"}, {_id: 1,host : "192.168.6.11:27001"},{_id : 2, host : "192.168.6.12:27001",arbiterOnly:true}] }
> rs.initiate(config)
{ "ok" : 1 }


# 192.168.6.11
> use admin
switched to db admin
> config = { _id: "shard2", members: [ {_id : 0, host : "192.168.6.3:27002" ,arbiterOnly:true},{_id : 1, host : "192.168.6.11:27002"},{_id : 2, host : "192.168.6.12:27002"}] }
> rs.initiate(config)
{ "ok" : 1 }


# 192.168.6.12
> use admin
> config = { _id: "shard3", members: [ {_id : 0, host : "192.168.6.3:27003" ,arbiterOnly:true},{_id : 1, host : "192.168.6.11:27003"},{_id : 2, host : "192.168.6.12:27003"}] }
> rs.initiate(config)
{ "ok" : 1 }
```



## 路由配置(3)

```sh
vim /etc/mongod/mongos.conf
# 加入以下内容
pidfilepath = /var/run/mongodb/mongos.pid
logpath = /data/mongodb/mongos/log/mongos.log
logappend = true
bind_ip = 0.0.0.0
port = 20000
fork = true
# 监听的配置服务器,只能有1个或者3个，configs为配置服务器的副本集名字
configdb = configs/192.168.6.3:21000,192.168.6.11:21000,192.168.6.12:21000
# 设置最大连接数
maxConns = 20000


# 启动服务
mongos -f /etc/mongod/mongos.conf


# 登录（任何一台都行）
mongo --port 20000

# 串联所有分片与路由器
mongos> sh.addShard("shard1/192.168.6.3:27001,192.168.6.11:27001,192.168.6.12:27001")
{ "shardAdded" : "shard1", "ok" : 1 }
mongos> sh.addShard("shard2/192.168.6.3:27002,192.168.6.11:27002,192.168.6.12:27002")
{ "shardAdded" : "shard2", "ok" : 1 }
mongos> sh.addShard("shard3/192.168.6.3:27003,192.168.6.11:27003,192.168.6.12:27003")
{ "shardAdded" : "shard3", "ok" : 1 }
mongos> sh.sta
sh.startBalancer(  sh.status(
mongos> sh.sta
sh.startBalancer(  sh.status(
# 查看集群状态
mongos> sh.status()
--- Sharding Status --- 
  sharding version: {
  	"_id" : 1,
  	"minCompatibleVersion" : 5,
  	"currentVersion" : 6,
```

## 启用分片

```sh
# 任意一台都行
# 进入
mongo --port 20000
mongos> use admin
switched to db admin

# 指定要分片的数据库
# 分片方法1
mongos> db.runCommand({ enablesharding : "fdy"})
{ "ok" : 1 }
# 分片方法2
mongos> sh.enableSharding("fdy") 

# 范围分片
# 分片方法1
mongos> db.runCommand( { shardcollection : "fdy.tables",key : {id: 1} } )
{ "collectionsharded" : "fdy.tables", "ok" : 1 }
# 分片方法2
mongos> sh.shardCollection("fdy.tables",{"id":1} ) 

mongos> use fdy
switched to db fdy
mongos> for (var i = 1; i <= 10000; i++) db.table1.save({id:i,"test":"testval"})
WriteResult({ "nInserted" : 1 })
mongos> db.tables.stats()
{
	"sharded" : true,
	"capped" : false,
	"ns" : "fdy.tables",
	"count" : 0,
	"size" : 0,
	"storageSize" : 4096,
	"totalIndexSize" : 8192,
	"indexSizes" : {
		"_id_" : 4096,
		"id_1" : 4096
	},
	"avgObjSize" : 0,
	"nindexes" : 2,
```









# MongoDB备份与恢复

## MongoDB备份

```shell
# 备份指定库，例如testdb
# -o表示存放的目录，-d表示要备份的库
mongodump   -d  mycol  -o /tmp/database
mongodump --host 192.168.108.20 --port 20000 -d testdb -o /tmp/mongobak

# 结果说明，备份完成之后，一般会在/tmp/mongobak下生成testdb目录，对应的备份库名，testdb目录下会有几个文件，对应的是库里面的集合
ls /tmp/mongobak/testdb/
table1.bson  table1.metadata.json
#b son是真正的数据，cat查看会乱码，json是相关信息

# 备份所有库
mongodump --host 127.0.0.1   -o /tmp/alldatabase
mongodump --host 192.168.108.20 --port 20000 -o /tmp/alldatabase

# 备份指定的集合
mongodump -d mycol  -c table1 -o /tmp/tables1
mongodump --host 192.168.108.20  --port 20000 -d testdb -c table1 -o /tmp/mongobak2/
```

## MongoDB恢复

```shell
# 恢复所有的库，恢复之前得把config库和admin库删掉
rm -rf /tmp/mongobak/config
rm -rf /tmp/mongobak/admin

mongorestore -h 192.168.247.160 --port 20000 --drop /tmp/mongobak/  

参数详解：
--drop     可选，意思是当恢复之前先把之前的数据删除，不建议使用

# 恢复指定库
# 把testdb库删除，再恢复
mongo --host 192.168.108.40 --port 27017
use mycol
db.dropDatabase()

# 恢复  指定数据库
mongorestore -d  mycol   /tmp/database/mycol

# 恢复指定数据库下的集合，同时也恢复了数据库
# 这里要指定备份的集合里的bson路径
mongorestore -d  mycol  -c table1 /tmp/tables1/mycol/table1.bson
```

# MongoDB导出和导入

## Mongodb导出

```
mongoexport --host 127.0.0.1  -d mycol -c table1  -o /tmp/mydb2/1.json
```

## Mongodb导入

```mysql
mongo
use  mycol
# 删除集合（集合含有内容较多，删除集合重新创建）
db.mycol.drop()
# 创建集合
db.createCollection("table1")
# 需要有指定集合且集合下面的文档数据为空，将指定数据进行导入
mongoimport --host 127.0.0.1  -d mycol -c table1   --file  /tmp/mydb2/1.json
```

