## kubectl语法

```
# kubectl [command][TYPE][NAME][flags]
# kubectl 子命令 资源类型  资源名称 命令参数
参数选项：
 --alsologtostderr[=false]: 同时输出日志到标准错误控制台和文件
 --api-version="":和服务端交互使用的API版本
 --certificate-authority="":用以镜像认证授权的.cert文件路径
 --client-certificate="":TLS使用的客户端证书路径
 --client-key="":TLS使用的客户端密钥路径
 --cluster="":指定使用的kubeconfig配置文件中的集群名
 --context="":指定使用的kubeconfig配置文件中的环境名
 --insecure-skip-tls-verify[=false]:如果为true，将不会检查服务器凭证的有效性，这会导致HTTPS链接变得不安全
 --kubeconfig="":命令行请求使用的配置文件路径
 --log-backtrace-at=0:党日志长度超过定义的行数时，忽略堆栈信息
 --log-dir=""：如果不为空，将日志文件写入此目录。
 --log-flush-frequency=5s：刷新日志的最大时间间隔。
 --logtostderr[=true]：输出日志到标准错误控制台，不输出到文件。
 --match-server-version[=false]：要求服务端和客户端版本匹配。
 --namespace=""：如果不为空，命令将使用此namespace。
 --password=""：APIServer进行简单认证使用的密码。
 -s,--server=""：Kubernetes API Server的地址和端口号。
 --stderrthreshold=2：高于此级别的日志将被输出到错误控制台。
 --token=""：认证到APIServer使用的令牌。
 --user=""：指定使用的kubeconfig配置文件中的用户名。
 --username=""：APIServer进行简单认证使用的用户名。
 --v=0：指定输出日志的级别。
 --vmodule=：指定输出日志的模块。
```



## 根据yaml文件创建资源

```
# 根据yaml文件一次性创建service和rc
kubectl create -f my-service.yaml -f my-rc.yaml

```



## 查看资源对象

```
# 查看所有pod列表
kubectl get pods

# 查看rc和service列表
kubectl get rc,service


# 查看pod的所有信息（不显示属于node）
kubectl get pod -A

# 显示node的详细信息
kubectl describe nodes [node-name]

# 显示pod的详细信息
kubectl describe pods/[pod-name]

# 显示由RC管理的pod信息
kubectl describe pods [rc-name]


# 查看pod的详细关联信息（查看pod属于哪个node）
kubectl get pod -o wide
```



## 删除资源对象

```
# 基于pod.yaml定义的名称删除pod
kubectl delete -f pod.yaml

# 删除所有包含某个label的pod和service
kubectl delete pods,service -l name=[label-name]

# 删除所有pod
kubectl delete pods --all
```



## 容器操作

```
# 执行pod的data命令，默认使用pod中的第一个容器执行
kubectl exec [pod-name] data

# 指定pod中某个容器执行data命令
kubectl exec [pod-name] -c [container-name] data

# 通过bash获取pod中某个容器的tty，相当于登录容器
kubectl exec -ti [pod-name] -c [container-name] bash


# 扩容和缩容
# 设置的参数跟当前参数的比较而随之扩容或是缩容
kubectl scale rc redis --replicas=3


# 滚动升级
 kubectl rolling-update redis -f redis-rc.update.yaml
 kubeclt rolling-update redis --image=redis-2.0
 
 
# 运行nginx容器
kubectl run nginx --image=10.18.4.10/library/nginx:latest

# 测试nginx应用
kubectl get svc
nginx           ClusterIP     10.100.220.6      <none>        80/TCP    9s

curl 10.100.220.6:80
```



## node隔离和恢复

```
# 停止node上的pod并隔离node
kubectl cordon node

# 查看Node的状态，可以观察到在node的状态中增加了一项SchedulingDisabled，对于后续创建的Pod，系统将不会再向该Node进行调度
kubectl get nodes

# 恢复node
kubectl uncordon node
```



## 动态扩容和缩容

```
# 将Nginx Deployment控制的Pod副本数量从初始的1更新为5
kubectl scale deployment nginx --replicas=5

# 验证
kubectl get pods

# 将--replicas设置为比当前Pod副本数量更小的数字，系统将会“杀掉”一些运行中的Pod，即可实现应用集群缩容
```





## 将pod调度到指定node

```
# 给node添加标签
kubectl label nodes [node-name] [label-key]=[label-value]
kubectl label nodes node project=gcxt

# 删除node的标签
kubectl label nodes node project-


# 在pod中加入nodeSelector定义
apiVersion: v1
kind: ReplicationController
metadata:
  name: memcached-gcxt
  labels:
    name: memcached-gcxt
spec:
  replicas: 1
  selector:
    name: memcached-gcxt
  template:
    metadata:
      labels:
        name: memcached-gcxt
    spec:
      containers:
      - name: memcached-gcxt
        image: memcached
        command:
        - memcached
        - -m 64
        ports:
        - containerPort: 11211
      nodeSelector:
        project: gcxt
        
# 创建pod，scheduler就会将该Pod调度到拥有project=gcxt标签的Node上去
kubectl create -f my-service.yaml
```





## 应用滚动升级

1. 编写yaml文件

   ```
   # vim httpd.conf
   apiVersion: apps/v1beta1
   kind: Deployment
   metadata:
     name: httpd
   spec:
     replicas: 3
     template:
       metadata:
         labels:
           run: httpd
       spec:
         containers:
           - name: httpd
             image: 10.18.4.10/library/httpd:2.2.31
             ports:
               - containerPort: 80
   ```

2. 启动Deployment

   ```
   kubectl create -f httpd.yaml 
    
   kubectl get pods
   ```

3. 查看Deployment

   ```
   kubectl get deployments httpd -o wide
   
   NAME READY UP-TO-DATE AVAILABLE AGE CONTAINERS IMAGES SELECTOR
   httpd    3/3      3           3        93s    httpd     httpd:2.2.31  run=httpd
   ```

4. 修改yaml文件

   ```
   apiVersion: apps/v1beta1
   kind: Deployment
   metadata:
     name: httpd
   spec:
     replicas: 3
     template:
       metadata:
         labels:
           run: httpd
       spec:
         containers:
           - name: httpd
             image: 10.18.4.10/library/httpd:2.2.32    //将2.2.31更改为2.2.32
             ports:
               - containerPort: 80
   ```

5. 启动

   ```
    kubectl apply -f httpd.yaml
   ```

6. 查看

   ```
   kubectl get deployments httpd -o wide
   
   NAME READY UP-TO-DATE AVAILABLE AGE CONTAINERS IMAGES SELECTOR
   httpd    3/3      3       3            7m53s   httpd   httpd:2.2.32  run=httpd
   
   # 查看Deployment详细信息
   kubectl describe deployment httpd
   ```





### 回滚

```
创建3个配置文件，内容中唯一不同的就是镜像的版本号。
vim  httpd.v1.yaml 

apiVersion: apps/v1beta1
kind: Deployment
metadata:
  name: httpd
spec:
  revisionHistoryLimit: 10  # 指定保留最近的几个revision
  replicas: 3
  template:
    metadata:
      labels:
        run: httpd
    spec:
      containers:
        - name: httpd
          image: 10.18.4.10/library/httpd:2.2.16
          ports:
            - containerPort: 80
```

```
vim  httpd.v2.yaml 

apiVersion: apps/v1beta1
kind: Deployment
metadata:
  name: httpd
spec:
  revisionHistoryLimit: 10  # 指定保留最近的几个revision
  replicas: 3
  template:
    metadata:
      labels:
        run: httpd
    spec:
      containers:
        - name: httpd
          image: 10.18.4.10/library/httpd:2.2.17
          ports:
            - containerPort: 80
```

```
vim  httpd.v3.yaml 

apiVersion: apps/v1beta1
kind: Deployment
metadata:
  name: httpd
spec:
  revisionHistoryLimit: 10  # 指定保留最近的几个revision
  replicas: 3
  template:
    metadata:
      labels:
        run: httpd
    spec:
      containers:
        - name: httpd
          image: 10.18.4.10/library/httpd:2.2.18
          ports:
            - containerPort: 80
```

```
# 部署Deployment
# kubectl apply -f httpd.v1.yaml --record
deployment.apps/httpd configured
# kubectl apply -f httpd.v2.yaml --record
deployment.apps/httpd configured
# kubectl apply -f httpd.v3.yaml --record
deployment.apps/httpd configured

# --record的作用是将当前命令记录到revision中，可以知道每个revision对应的是哪个配置文件
```

```
# 查看deployment
 kubectl get deployments -o wide
 
# 查看revision历史记录
 kubectl rollout history deployment httpd
 
 deployment.extensions/httpd 
REVISION  CHANGE-CAUSE
1         <none>
2         <none>
3         kubectl apply --filename=httpd.v1.yaml --record=true
4         kubectl apply --filename=httpd.v2.yaml --record=true
5         kubectl apply --filename=httpd.v3.yaml --record=true
```

```
# 回滚
 kubectl rollout undo deployment httpd --to-revision=1
deployment.extensions/httpd rolled back4

 kubectl get deployments -o wide
NAME READY UP-TO-DATE AVAILABLE AGE CONTAINERS IMAGES SELECTOR
httpd    3/3       3            3      35m     httpd    10.18.4.10/library/httpd:2.2.31 run=httpd

# 再次查看Deployment可以看到httpd版本已经回退了。
# 查看revision历史记录，可以看到revision记录也发生了变化。
kubectl rollout history deployment httpd
deployment.extensions/httpd 
......
```

