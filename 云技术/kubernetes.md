# 一、K8S介绍

就在Docker容器技术被炒得热火朝天之时，大家发现，**如果想要将Docker应用于具体的业务实现，是存在困难的——编排、管理和调度等各个方面，都不容易**。于是，人们迫切需要一套管理系统，对Docker及容器进行更高级更灵活的管理。



就在这个时候，K8S出现了。



K8S，就是**基于容器的集群管理平台**，它的全称，是kubernetes。

**K8S作用：**

1. 自动化运维平台
2. 充分利用服务器资源
3. 服务的无缝衔接





# **二、什么是IAAS、PAAS、SAAS**

**云架构：**

1. IAAS
2. PAAS
3. SAAS
4. Serverless(无服务)

从发展历程来讲，国内跟国外又有点不同，云计算的概念最早2000年起源于美国，然后我国从07年开始引入。国外的云计算基本是由企业牵头来做推广普及的（资本主义嘛），我国引入了概念后，基本是政府、政策两大方面来驱动影响。去年（18年）的政府报告也再次提出了把发展智能制造作为主攻方向，推动“中国制造2025”战略落地，云计算在里面是最基础最重要的核心技术之一。

从技术层面，云计算的发展基本是按照  **虚拟化、网络化、分布式技术成熟稳定 --> IAAS成熟稳定--> PAAS成熟稳定 --> SAAS成熟稳定**  这条路线走的。每个阶段都有业界开源或者非开源的技术未代表，比如**最开始的虚拟化阶段，典型的代表是Xen、vSphere、KVM**等技术；**IAAS层是OpenStack；PAAS层是Kubernetes；SAAS层开源界当前还没有典型的代表，aws推出了有Lambda** 。

随着未来IoT物联网、5G、IPv6全面实行、量子计算等技术全面发展和普及，云计算将会是最底层的支撑核心技术。然后这些技术的发展，必然也会带动和升级云计算。国家与西方的较量和角逐，通过政策性的引导投入在先进的互联网技术，这不失为“弯道超车”的良计。落实到个人，作为云计算的从业者，我想这是一门值得投资关注和永久学习的技术。



刚才我们提到过IAAS、PAAS、SAAS这几个词，而且只要你关注过云计算，这几个词你不会陌生。那么什么是IAAS、PAAS、SAAS呢？ 我们下面来讲一讲。

我们知道TCP/IP有七层协议，协议的出现和规定就是让标准能够统一，这样无论是开发者、使用者、网络设备厂商都能按照这公认的协议来学习和生产。如果没有协议，我想必将会乱套，你搞你的标准，我搞我的标准。

云计算这块虽然没有类型TCP/IP这样协议的强定义，但是公认的会把云计算分为三个层级，这三个层级就是IAAS、PAAS、SAAS。至于为什么要这么分，个人认为主要是云计算牵扯的方面太多了，一个庞大的东西如果不分层，必然也会乱套。接下来我们看看这三个层级分别的定义（源自维基百科）：

**基础架构即服务**（**IaaS**）提供在线的高级API服务，底层基础架构细节都不会向上体现，比如[服务器](https://cloud.tencent.com/product/cvm?from=10680)位置，网络布线，数据分区、扩展、备份，安全性等等。底层的计算、网络、存储等资源都将通过虚拟化技术来整体管理和配置，这些虚拟化技术有Xen，KVM，VMware ESX/ ESXi，Hyper-V，Ceph，SDN等。

说直接点就是传统的计算、网络、存储资源全部做虚拟化，之前直接管理服务器、交换机、存储。虚拟化之后你只要在电脑面前操作虚拟化管理平台管理这些硬件虚拟出来的VM、虚拟交换机、路由器、存储池。

**平台即服务**（**PaaS**）或**应用程序平台即服务**（**PaaS**）是云计算服务的一种，它提供了一个平台，允许客户在这个平台上开发、运行和管理应用程序，无需去考虑应用程序的构建和维护工作。提供对操作系统和相关服务的访问。它让用户能够使用提供商支持的编程语言和工具把应用程序部署到云中。用户不必管理或控制底层基础架构，而是控制部署的应用程序并在一定程度上控制应用程序驻留环境的配置。PaaS的提供者包括Google App Engine、Windows Azure、Force.com、Heroku等。小企业软件工作室是非常适合使用PaaS的企业。通过使用云平台，可以创建世界级的产品，而不需要负担内部生产的开销。
    通过PaaS这种模式，用户可以在一个提供SDK（Software Development Kit，即软件开发工具包）、文档、测试环境和部署环境等在内的开发平台上非常方便地编写和部署应用，而且不论是在部署，还是在运行的时候，用户都无需为服务器、 操作系统、网络和存储等资源的运维而操心，这些繁琐的工作都由PaaS云供应商负责。而且PaaS在整合率上面非常惊人，比如一台运行Google App Engine的服务器能够支撑成千上万的应用，也就是说， PaaS是非常经济的。 **PaaS主要面对的用户是开发人员**。

说直接点就是 PAAS是建立在完善的IAAS之上的，用户使用PAAS平台，只关心如何去使用PAAS平台给予的资源，而这些资源的创建、维护工作，使用者完全不用关心。

**软件即服务**（Software as a Service，缩写：**SaaS**）有时被作为“即需即用软件服务”，它是一种软件交付模式。在这种交付模式中云端集中式托管软件及其相关的数据，软件仅需透过互联网，而不用通过安装即可使用。**用户通常使用精简客户端经由一个网页浏览器来访问软件**。

说直接点就是假如有家SAAS级云服务供应商，它的网页控制台有CRM、ERP、OA等等你需要用到的软件。传统的软件，无论是BS架构或者CS架构，SAAS供应商都能够提供（或者额外提供），比如腾讯之前提供的web QQ也算是一种SAAS级服务。作为用户，你只关心使用SAAS提供的成熟级的软件应用，其他一切事情，比如[数据存储](https://cloud.tencent.com/product/cdcs?from=10680)、软件维护、安全等都交给云厂商处理和负责。



# **三、容器云介绍**

上面长篇大论说了两点内容，其实这也是为了引出本文章的正题。本系列文章聚焦在Kubernetes这项开源技术，这项技术是PAAS层级的典型开源代表。所以，了解前面两点的知识背景，有助于你站在一更高层面理解和学习这项技术。

**1. 容器技术为什么会火？**

之所以要讲讲“容器云”，主要也是时代发展趋势必然所致。07年国内开始云计算概念引进，到现在各大云厂商的兴起，已经整整过去了12年。这12年，前面6年都是在做IAAS层的建设。概念炒作、私有云落地、企业上公有云... 都是一步步走过来，每一年都有突飞猛进的变化。6年一过，IAAS建设还在不断完善，随之开始有PAAS层技术概念的兴起，2010年开始国外Cloud Foundry、Coreos、docker容器技术刚刚创立，给云计算又指明了一个新道路。随后的两三年（2013年），国内开始引进这些技术，IT从业者又在不断学习，寻找比IAAS更完美的云计算管理方案。

IT人员学习需要时间，不到两三年的功夫，从16年开始，docker、k8s等技术就火的一塌糊涂。之前iaas层的建设，大部分都是运维人员参与，开发只负责写代码从不参与底层运维管理工作。随着容器技术的出现，开发人员和运维人员很自然的走在了一起，有了融合（devops）。这也是让docker和k8s火的原因之一，支撑PAAS层级的人员至少增加了一半（甚至更多）。

**2. 容器云时代是否来临**

其实，你可以把容器云理解为云上的容器技术服务，这个概念的终极体现就是PAAS层的云交付模式。前面谈到，docker、k8s现在已经是大火，这必然会推动云计算PAAS层的完善和普及。站在云厂商的角度，前几年客户不断的来上云、用云，其实就是在不断的玩IAAS。等IAAS玩溜了，没得玩了，自然会考虑云厂商的PAAS、SAAS层级产品。所以，你问容器云时代是否来临，我觉得从17年开始就已经来了。有些技术体系完善走得靠前的公司，他们已经步入选择PAAS层级的云产品（或者自建k8s无数遍了）。

PS：还得再提下，开发人员真的很喜欢docker。

**3. 容器云是否会取代传统云**

这几年玩技术的，有点逼格的都会关注这家公司发布的数据，那就是 —— Gartner。高德纳这家公司是信息技术研究和分析的公司，他们出的IT技术信息报告和数据分析都非常权威可信（还有它的魔力象限，国外大厂都认可并且愿意争求达标）。所以，看一项热门技术的发展趋势，我们可以参考Gartner提供的相关分析报告。

Gartner公司已列出了2019年及以后影响平台即服务（PaaS）技术和平台架构的四大趋势。其中前面两个趋势很明确的提出PAAS市场的发展势头和重要程度：

第一个趋势：蓬勃发展的PaaS市场

截至2019年，整个PaaS市场包含360多家供应商，提供涉及21个类别的550多种云平台服务。Gartner预计，从2018年到2022年，市场规模将翻番；PaaS将成为未来的主流平台交付模式。

第二个趋势：云平台连续体

PaaS功能旨在支持云平台的角色。然而，包括基础设施即服务（IaaS）和软件即服务（SaaS）在内的所有云服务都可能是平台的关键因素。这些服务共同构成了云平台连续体。在全部云服务当中寻找和确认基于平台的创新机会很快将成为每个云战略的一部分。



# 四、服务部署模式的变迁与微服务



1. 物理机的部署（直接把服务部署在物理机上）
2. 虚拟化的部署（把服务部署在虚拟机中，虚拟机分隔物理资源--充分利用服务器资源，Openstack）
3. 容器化的方式来部署（k8s）



## 4.1 单体软件

要理解微服务，首先需要理解软件架构的演变。

早期的软件，所有功能都写在一起，这称为**单体架构**（monolithic software）。

![img](https://cdn.beekka.com/blogimg/asset/220204/bg2022042802.webp)

整个软件就是单一的整体，彷佛一体化的机器。

可以想到，软件的功能越多，单体架构就会越复杂，很多缺点也随之暴露出来。

> （1）所有功能耦合在一起，互相影响，最终难以管理。
>
> （2）哪怕只修改一行代码，整个软件就要重新构建和部署，成本非常高。
>
> （3）因为软件做成了一个整体，不可能每个功能单独开发和测试，只能整体开发和测试，导致必须采用瀑布式开发模型。

以上三个原因的详细分析，可以参考我以前的文章[《软件工程的最大难题》](https://www.ruanyifeng.com/blog/2021/05/scaling-problem.html)。

![img](https://cdn.beekka.com/blogimg/asset/220204/bg2022042803.webp)

总之，单体架构的大型软件，不仅开发速度慢，而且会形成难以维护和升级的复杂代码，成为程序员的沉重负担。

## 4.2 面向服务架构

为了解决上面这些问题，很早就有人提出来，必须打破代码的耦合，拆分单体架构，将软件拆分成一个个独立的功能单元。

大概在20多年前，随着互联网的出现，功能单元可以用远程"服务"的形式提供，就诞生出了"面向服务架构"（service-oriented architecture，简称 SOA）。

![img](https://cdn.beekka.com/blogimg/asset/220204/bg2022042804.webp)

所谓服务（service），就是在后台不间断运行、提供某种功能的一个程序。最常见的服务就是 Web 服务，通过80端口向外界提供网页访问。

"面向服务架构"就是把一个大型的单体程序，拆分成一个个独立服务，也就是较小的程序。每个服务都是一个独立的功能单元，承担不同的功能，服务之间通过通信协议连在一起。

![img](https://cdn.beekka.com/blogimg/asset/220204/bg2022042805.webp)

这种架构有很多优点。

> （1）每种服务功能单一，相当于一个小型软件，便于开发和测试。
>
> （2）各个服务独立运行，简化了架构，提高了可靠性。
>
> （3）鼓励和支持代码重用，同一个服务可以用于多种目的。
>
> （4）不同服务可以单独开发和部署，便于升级。
>
> （5）扩展性好，可以容易地加机器、加功能，承受高负载。
>
> （6）不容易出现单点故障。即使一个服务失败了，不会影响到其他服务。

跟单体架构不一样，面向服务架构是语言不敏感的，不同服务可以使用不同的语言和工具开发，可能需要部署在不同的系统和环境。

这意味着，**面向服务架构默认运行在不同服务器上**，每台服务器提供一种服务，多台服务器共同组成一个完整的网络应用。

## 4.3 微服务

2014年，[Docker](https://www.ruanyifeng.com/blog/2018/02/docker-tutorial.html) 出现了，彻底改变了软件开发的面貌。它让程序运行在容器中，每个容器可以分别设定运行环境，并且只占用很少的系统资源。

![img](https://cdn.beekka.com/blogimg/asset/220204/bg2022042806.webp)

显而易见，可以用容器来实现"面向服务架构"，每个服务不再占用一台服务器，而是占用一个容器。

这样就不需要多台服务器了，最简单的情况下，本机运行多个容器，只用一台服务器就实现了面向服务架构，这在以前是做不到的。这种实现方式就叫做微服务。

![img](https://cdn.beekka.com/blogimg/asset/220204/bg2022042807.webp)

简单说，**微服务就是采用容器技术的面向服务架构**。它依然使用"服务"作为功能单元，但是变成了轻量级实现，不需要新增服务器，只需要新建容器（一个进程），所以才叫做"微服务"。

**一个微服务就是一个独立的[进程](https://www.ruanyifeng.com/blog/2013/04/processes_and_threads.html)。** 这个进程可以运行在本机，也可以运行在别的服务器，或者在云端（比如云服务和云函数 FaaS）。

它的特点与面向服务架构是一样的，但因为更轻量级，所以功能的解耦和服务化可以做得更彻底。而且，它可以标准化，同样的容器不管在哪里运行，结果都是一样的，所以市场上有很多 SaaS 产品，提供标准化的微服务。

正是由于微服务这些突出的优点，这几年才会变得如此流行。它和容器技术、云服务一起，一定会在未来的软件开发中，扮演越来越重要的角色。



# 五、云、云架构。云原生

**云**：使用容器来构建的一套服务集群的一个网络

**云架构**：


[(13条消息) 云计算架构_Dave888Zhou的博客-CSDN博客](https://blog.csdn.net/zhoudaxia/article/details/9021693)



**云原生**：为了让应用程序（项目、服务软件）都运行在云上的解决方案

云原生特点：

1. 容器化（所有服务必须部署在容器里）
2. 微服务架构
3. CI/CD(可持续交付/可持续部署)
4. DevOps



# 六、k8s架构基本原理

![](https://gitee.com/fan-dongyuan/ty-gallery/raw/master/%E5%B7%A5%E5%9D%8A%E5%9B%BE/web/k8s%E5%9F%BA%E6%9C%AC%E6%9E%B6%E6%9E%84.png)

**Kubernetes架构原理**：

> 1. K8S由google公司使用**go**语言开发，根据borg系统开发而来
>
> 2. K8S架构
>
>    ```
>    Master节点
>     1. api server  k8s网关（所有请求需经过apiserver）
>     2. scheduler  调度器（使用调度算法，把某个请求调度到下面某一个node节点上面）
>     3. controller 控制器（负责维护集群的状态，比如故障检测、自动扩展、滚动更新等，维护k8s资源对象，增删改查）
>     4. etcd       存储器（存储资源对象）
>    
>    Node节点
>     1. docker    容器引擎（容器基础环境），负责容器的创建和管理工作
>     2. kubelet   node节点操作指令执行器（会监控Api Server上的资源变动，若变动与自己有关系，kublet就去执行任务；定期向master会报节点资源使用情况）
>     3. kube-proxy 代理服务，负载均衡（实现service的抽象，为一组pod抽象的服务提供统一接口并提供负载均衡）监控pod；pod如果发生了变化，及时修改映射关系；修改映射关系的同时，修改路由规则，以便在负载均衡时可以选择到新的pod。
>     4. fluentd    日志收集服务
>     5. pod        k8s最小管理工具（基本单元、最小单元）内部为容器
>    
>    特点：
>    （1）一个master对应多个node
>    （2）master节点不存储容器，只负责调度、网关、控制器、资源对象的存储等
>    （3）容器存储在node节点（存储在pod内部）
>    （4）pod内部可以有一个或者多个容器
>    （5）kubelet负责本地的pod维护
>    （6）kube-proxy 负责负载均衡。在多个pod之间
>    ```
>
> 



# 七、核心组件原理pod

1. pod是什么？

   >1. pod也是一个容器，装的是docker创建的容器，可以封装docker创建的容器
   >2. pod也是虚拟化分组（有自己地IP地址、主机名等），相当于沙箱环境，（独立的主机，可以封装一个或多个容器）

2. pod用来做什么？

   >在服务部署的时候，会使用pod来管理一组相关的服务（**一个pod中要么部署一个服务要么部署有关系的一组服务**）

3. 如何实现服务集群

   >只需要复制多方的pod副本即可，也是k8s的先进管理之处，如果想继续扩容或缩容，只需要控制pod的数量

4. pod底层网络、数据存储是如何运行的？

   >1. pod内部容器创建之前先创建pause容器（用于共享网络和存储等等）
   >2. 内部容器之间可以使用localhost访问，相当于访问本地服务，性能高



# 八、核心组件原理（replicaset、deplyment、statefulset）

1. ReplicaSet副本控制器

   >1. 副本控制器用于**控制pod副本（服务集群）的数量**，永远和预期设定的数量保持一致
   >
   > ```
   >replicas = 3  //限制副本数量
   > ```
   >
   >2. ReplicationController和Replicaset的区别
   >
   > >1. ReplicaSet支持**单选、复合选择**
   > >2. ReplicationController只支持**单选**
   >
   >3. 副本控制器中有一个标签控制器，**用来管理（识别）一系列容器，方便于管理和监控拥有同一标签的所有容器**，维护与自己相关的服务

2. Deployment资源部署对象

   服务部署、滚动更新

   >1. replicaset不支持滚动更新，Deployment支持滚动更新，通常与replicaset一起使用
   >
   >2. 滚动更新用于解决下线更新问题，解决更新迭代
   >
   >3. 更新时会重新建立新的replicaset和pod
   >
   >4. 滚动更新的含义
   >
   > 一次只更新一小部分副本，成功后，再更新更多的副本，最终完成所有副本的更新。
   >
   > 滚动更新的好处
   >
   > 最大好处是零停机，整个更新过程始终有副本在运行，从而保证了业务的连续性。

   ![image-20230112104258176](https://gitee.com/fan-dongyuan/ty-gallery/raw/master/%E5%B7%A5%E5%9D%8A%E5%9B%BE/web/Deployment%E9%83%A8%E7%BD%B2%E6%A8%A1%E5%9E%8B)

3. Statefulset资源部署对象

   部署模型、有状态服务

   >1. Statefulset为了**解决有状态服务使用容器化部署的问题**
   >
   >2. 有状态服务：
   >
   > > 1. 有实时的数据需要存储、
   > > 2. 有状态服务集群中，把某一个服务抽离，一段时间再加入机器网络，如果集群网络无法使用
   >
   >3. 无状态服务：
   >
   > >1. 无实时的数据需要存储、
   > >2. 无状态服务集群中，把某一个服务抽离，一段时间再加入机器网络，如果集群网络无影响
   >
   >4. Deployment不能部署有状态服务，通常来说，Statefulset用于部署有状态服务，Deployment用于部署无状态服务

   ![image-20230112104424364](https://gitee.com/fan-dongyuan/ty-gallery/raw/master/%E5%B7%A5%E5%9D%8A%E5%9B%BE/web/statefulset%E9%83%A8%E7%BD%B2%E6%A8%A1%E5%9E%8B)



# 九、pod访问原理

## 9.1、pod如何对外网提供服务

>pod是虚拟的资源对象（进程），如果没有对应的实体与之对应，则无法对外提供访问

>解决方式：
>
>1. 绑定物理机端口（开启物理机端口，让其与pod端口映射）
>
>

![image-20230113091358593](https://gitee.com/fan-dongyuan/ty-gallery/raw/master/%E5%B7%A5%E5%9D%8A%E5%9B%BE/web/pod%E7%AB%AF%E5%8F%A3%E6%98%A0%E5%B0%84%E8%AE%BF%E9%97%AE)



## 9.2 负载均衡访问

Service如何实现负载均衡

>**什么是service VIP？**
>（1）service和pod都是一个进程，service也不能对外网提供服务。
>（2）service和pod之间可以直接进行通信，他们的通信属于局域网通信。
>（3）把请求交给service后，service使用iptables、ipvs做数据包的分发。
>
>思考：
>service对象是如何与pod进行关联的？
>通过标签选择器
>selector:
>app = x 选择一组订单的服务pod，创建一个service



　Pod服务发现借助kube-proxy实现，该组件实现了三件事情：监控pod；pod如果发生了变化，及时修改映射关系；修改映射关系的同时，修改路由规则，以便在负载均衡时可以选择到新的pod。

![](https://gitee.com/fan-dongyuan/ty-gallery/raw/master/%E5%B7%A5%E5%9D%8A%E5%9B%BE/web/%E8%B4%9F%E8%BD%BD%E5%9D%87%E8%A1%A1%E5%8E%9F%E7%90%86.png)





# 十、Kubectl主命令

## 语法

```sh
语法
使用以下语法从终端窗口运行 kubectl 命令：

# kubectl [command][TYPE][NAME][flags]
# kubectl 子命令 资源类型  资源名称 命令参数
其中 command、TYPE、NAME 和 flags 分别是：

command：指定要对一个或多个资源执行的操作
常用的子命令：
help—获取帮助
get— 显示有关一个或多个资源的信息
describe—显示关于一个或多个资源的详细信息
logs—显示容器日志
exec—进入容器中一个正在运行的进程
apply—创建或选择一个资源
delete—删除一个或多个资源


TYPE：指定资源类型
常见的资源类型：
pods （po）
nodes（no）
deployments （deploy）
replicasets（rs）
daemonsets（ds）
statefulsets（sts）
jobs
cronjobs（cj）
services（svc）
persistentvolumes（pv）
persistentvolumeclaim （pvc）

NAME：指定资源的名称。名称区分大小写。 如果省略名称，则显示所有资源的详细信息。例如：kubectl get pods。
1.在对多个资源执行操作时，你可以按类型和名称指定每个资源，或指定一个或多个文件：
2.要按类型和名称指定资源：
3.要对所有类型相同的资源进行分组，请执行以下操作：TYPE1 name1 name2 name<#>。
例子：kubectl get pod example-pod1 example-pod2

4.分别指定多个资源类型：TYPE1/name1 TYPE1/name2 TYPE2/name3 TYPE<#>/name<#>。
例子：kubectl get pod/example-pod1 replicationcontroller/example-rc1

5.用一个或多个文件指定资源：-f file1 -f file2 -f file<#>

6.使用 YAML 而不是 JSON， 因为 YAML 对用户更友好, 特别是对于配置文件。
例子：kubectl get -f ./pod.yaml

flags： 指定可选的参数
参数选项：
 --alsologtostderr[=false]:              同时输出日志到标准错误控制台和文件
 --api-version="":                       和服务端交互使用的API版本
 --certificate-authority="":             用以镜像认证授权的.cert文件路径
 --client-certificate="":                TLS使用的客户端证书路径
 --client-key="":                        TLS使用的客户端密钥路径
 --cluster="":                           指定使用的kubeconfig配置文件中的集群名
 --context="":                           指定使用的kubeconfig配置文件中的环境名
 --insecure-skip-tls-verify[=false]:     如果为true，将不会检查服务器凭证的有效性，这会导致HTTPS链接变得不安全
 --kubeconfig="":                        命令行请求使用的配置文件路径
 --log-backtrace-at=0:                   当日志长度超过定义的行数时，忽略堆栈信息
 --log-dir=""：                          如果不为空，将日志文件写入此目录。
 --log-flush-frequency=5s：              刷新日志的最大时间间隔。
 --logtostderr[=true]：                  输出日志到标准错误控制台，不输出到文件。
 --match-server-version[=false]：        要求服务端和客户端版本匹配。
 --namespace=""：                        如果不为空，命令将使用此namespace。
 --password=""：                         APIServer进行简单认证使用的密码。
 -s,--server=""：                        Kubernetes API Server的地址和端口号。
 --stderrthreshold=2：                   高于此级别的日志将被输出到错误控制台。
 --token=""：                            认证到APIServer使用的令牌。
 --user=""：                             指定使用的kubeconfig配置文件中的用户名。
 --username=""：                         APIServer进行简单认证使用的用户名。
 --v=0：                                 指定输出日志的级别。
 --vmodule=：                            指定输出日志的模块。
```



## 查看资源对象

```sh
# 查看所有pod列表
kubectl get pods

# 查看rc和service列表
kubectl get rc,service


# 查看pod的所有信息（不显示属于node）
kubectl get pod -A

# 查看pod的所有详细信息
kubectl get pod -A wide

# 显示node的详细信息
kubectl describe nodes [node-name]

# 显示pod的详细信息
kubectl describe pods/[pod-name]

# 显示由RC管理的pod信息
kubectl describe pods [rc-name]


# 查看pod的详细关联信息（查看pod属于哪个node）
kubectl get pod -o wide





# 创建命名空间
kubectl create namespace 空间名
# 查看命名空间中某服务的node分布和详细信息
kubectl get pods -o wide -n 空间名
# 创建命名空间  ：kubectl create namespace zlm-k8s
# 创建 pod    ：kubectl apply -f nginx-deployment.yaml
# 查看 pod    ：kubectl -n zlm-k8s get pod -o wide
# 进入 pod    ：kubectl -n zlm-k8s exec -it pod名称 bash
# 编辑 pod    ：kubectl -n zlm-k8s edit deployment nginx-deployment
# 删除 pod    ：kubectl -n zlm-k8s delete deployment nginx-deployment
```

## 删除资源对象

```sh
# 基于pod.yaml定义的名称删除pod
kubectl delete -f pod.yaml

# 删除所有包含某个label的pod和service
kubectl delete pods,service -l name=[label-name]

# 删除所有pod
kubectl delete pods --all
```

## 容器操作

```sh
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

## Service操作

```sh
# 创建 Service（不能指定 nodePort） ：kubectl -n zlm-k8s expose deployment nginx-deployment --type=NodePort --name=nginx-service
# 编辑 Service                    ：kubectl -n zlm-k8s edit service nginx-service
# 删除 Service                    ：kubectl -n zlm-k8s delete service nginx-service
# 查看 pod、Service               ：kubectl -n 命名空间 get pod,svc -o wide
```

## node隔离和恢复

```sh
# 停止node上的pod并隔离node
kubectl cordon node

# 查看Node的状态，可以观察到在node的状态中增加了一项SchedulingDisabled，对于后续创建的Pod，系统将不会再向该Node进行调度
kubectl get nodes

# 恢复node
kubectl uncordon node
```

## 动态扩容和缩容

```sh
# 将Nginx Deployment控制的Pod副本数量从初始的1更新为5
kubectl scale deployment nginx --replicas=5

# 验证
kubectl get pods

# 将--replicas设置为比当前Pod副本数量更小的数字，系统将会“杀掉”一些运行中的Pod，即可实现应用集群缩容
```

## 将pod调度到指定node

```sh
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

   ```sh
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

   ```sh
   kubectl create -f httpd.yaml 
    
   kubectl get pods
   ```

3. 查看Deployment

   ```sh
   kubectl get deployments httpd -o wide
   
   NAME READY UP-TO-DATE AVAILABLE AGE CONTAINERS IMAGES SELECTOR
   httpd    3/3      3           3        93s    httpd     httpd:2.2.31  run=httpd
   ```

4. 修改yaml文件

   ```sh
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

   ```sh
    kubectl apply -f httpd.yaml
   ```

6. 查看

   ```sh
   kubectl get deployments httpd -o wide
   
   NAME READY UP-TO-DATE AVAILABLE AGE CONTAINERS IMAGES SELECTOR
   httpd    3/3      3       3            7m53s   httpd   httpd:2.2.32  run=httpd
   
   # 查看Deployment详细信息
   kubectl describe deployment httpd
   ```

### 回滚

```sh
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

```sh
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

```sh
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

```sh
# 部署Deployment
# kubectl apply -f httpd.v1.yaml --record
deployment.apps/httpd configured
# kubectl apply -f httpd.v2.yaml --record
deployment.apps/httpd configured
# kubectl apply -f httpd.v3.yaml --record
deployment.apps/httpd configured

# --record的作用是将当前命令记录到revision中，可以知道每个revision对应的是哪个配置文件
```

```sh
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

```sh
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





# 十一、实验项目

## K8s部署nginx服务

### 实验环境

| IP           | 主机   | 节点规划   |
| ------------ | ------ | ---------- |
| 192.168.6.4  | master | k8s-master |
| 192.168.6.11 | worker | k8s-node1  |
| 192.168.6.12 | worker | k8s-node2  |



### 系统环境准备（所有节点安装）

```sh
# 安装工具
yum -y install vim
yum -y install wget

# 设置阿里源
mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.backup
wget -O /etc/yum.repos.d/CentOS-Base.repo https://mirrors.aliyun.com/repo/Centos-7.repo

# 修改主机名
#master
hostnamectl set-hostname master
#node1
hostnamectl set-hostname node1
#node2
hostnamectl set-hostname node2

# 编辑hosts文件
# 最后一行添加
192.168.6.4 master
192.168.6.11 node1
192.168.6.12 node2

# 设置时间同步
rm -f /etc/localtime && ln -s /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

# 安装并配置bash-completion 设置添加命令自动补充
yum -y install bash-completion
source /etc/profile

# 关闭防火墙和selinux
systemctl stop firewalld.service 
systemctl disable firewalld.service
setenforce 0
sed -i 's/enforcing/disabled/' /etc/selinux/config  # 永久关闭

# 关闭swap
free -h
swapoff -a
sed -i 's/.*swap.*/#&/' /etc/fstab
free -h
```

### k8s集群部署

1. 安装containerd（所有节点都安装）

   ```sh
   yum install -y yum-utils device-mapper-persistent-data lvm2
   yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo 
   sudo yum install -y containerd.io
   
   systemctl stop containerd.service
   
   cp /etc/containerd/config.toml /etc/containerd/config.toml.bak
   containerd config default > $HOME/config.toml
   cp $HOME/config.toml /etc/containerd/config.toml
   
   # 修改 /etc/containerd/config.toml 文件后，要将 docker、containerd 停止后，再启动
   sudo sed -i "s#registry.k8s.io/pause#registry.cn-hangzhou.aliyuncs.com/google_containers/pause#g" /etc/containerd/config.toml
   
   # 确保 /etc/containerd/config.toml 中的 disabled_plugins 内不存在 cri
   sed -i "s#SystemdCgroup = false#SystemdCgroup = true#g" /etc/containerd/config.toml
   
   #启动containerd
   systemctl start containerd.service
   systemctl status containerd.service
   ```

2. 添加阿里云k8s镜像仓库

   ```sh
   cat <<EOF > /etc/yum.repos.d/kubernetes.repo
   [kubernetes]
   name=Kubernetes
   baseurl=https://mirrors.aliyun.com/kubernetes/yum/repos/kubernetes-el7-x86_64/
   enabled=1
   gpgcheck=0
   repo_gpgcheck=0
   gpgkey=https://mirrors.aliyun.com/kubernetes/yum/doc/yum-key.gpg https://mirrors.aliyun.com/kubernetes/yum/doc/rpm-package-key.gpg
   EOF
   ```

3. 将桥接的IPv4流量传递到iptables的链（所有节点都安装）

   ```sh
   # 设置所需的 sysctl 参数，参数在重新启动后保持不变
   cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
   net.bridge.bridge-nf-call-iptables  = 1
   net.bridge.bridge-nf-call-ip6tables = 1
   net.ipv4.ip_forward                 = 1
   EOF
   
   # 应用 sysctl 参数而不重新启动
   sudo sysctl --system
   
   # 启动br_netfilter
   modprobe br_netfilter
   echo 1 > /proc/sys/net/ipv4/ip_forward
   
   ```

4. 安装k8s（所有节点都安装）

   ```sh
   # 可以安装1.24.0-1.26.3版本,本文使用1.26.0
   # sudo yum install -y kubelet-1.24.0-0 kubeadm-1.24.0-0 kubectl-1.24.0-0 --disableexcludes=kubernetes --nogpgcheck
   
   
   #sudo yum install -y kubelet-1.25.3-0 kubeadm-1.25.3-0 kubectl-1.25.3-0 --disableexcludes=kubernetes --nogpgcheck
   
   # 2022-11-18，经过测试，版本号：1.25.4
   # sudo yum install -y kubelet-1.25.4-0 kubeadm-1.25.4-0 kubectl-1.25.4-0 --disableexcludes=kubernetes --nogpgcheck
   
   # 2023-02-07，经过测试，版本号：1.25.5，
   # sudo yum install -y kubelet-1.25.5-0 kubeadm-1.25.5-0 kubectl-1.25.5-0 --disableexcludes=kubernetes --nogpgcheck
   
   # 2023-02-07，经过测试，版本号：1.25.6，
   # sudo yum install -y kubelet-1.25.6-0 kubeadm-1.25.6-0 kubectl-1.25.6-0 --disableexcludes=kubernetes --nogpgcheck
   
   # 2023-02-07，经过测试，版本号：1.26.0，
   # sudo yum install -y kubelet-1.26.0-0 kubeadm-1.26.0-0 kubectl-1.26.0-0 --disableexcludes=kubernetes --nogpgcheck
   
   # 2023-02-07，经过测试，版本号：1.26.1，
   # sudo yum install -y kubelet-1.26.1-0 kubeadm-1.26.1-0 kubectl-1.26.1-0 --disableexcludes=kubernetes --nogpgcheck
   
   # 2023-03-02，经过测试，版本号：1.26.2，
   # sudo yum install -y kubelet-1.26.2-0 kubeadm-1.26.2-0 kubectl-1.26.2-0 --disableexcludes=kubernetes --nogpgcheck
   
   yum install -y kubelet-1.26.3-0 kubeadm-1.26.3-0 kubectl-1.26.3-0 --disableexcludes=kubernetes --nogpgcheck
   
   systemctl daemon-reload
   systemctl restart kubelet
   systemctl enable kubelet
   ```

5. 初始化k8s（仅master）

   ```sh
   kubeadm init \
    --apiserver-advertise-address=192.168.6.4 \
    --image-repository registry.aliyuncs.com/google_containers
   ```

6. node加入集群（详细看代码块）

   ```sh
   # master节点查看加入集群命令
   kubeadm token create --print-join-command
   # 两个node节点执行加入集群命令
   kubeadm join 192.168.6.4:6443 --token rb9i1a.kdi2as1chr50b4ku --discovery-token-ca-cert-hash sha256:f3d30f98ea3ff47e561c2a2d471447cbe9e9839fbc400807b79fec9e44ea314b 
   ```

7. 防止终端重启报错（所有节点都执行）

   ```sh
   cd ~
   vim .bashrc
   # 新增以下内容
   export KUBECONFIG=/etc/kubernetes/admin.conf
   ```

8. master查看状态

   ```sh
   # 查看节点状态
   kubectl get nodes
   NAME     STATUS   ROLES           AGE   VERSION
   master   NotReady    control-plane   59m   v1.26.0
   node1    NotReady   <none>          47m   v1.26.0
   node2    NotReady    <none>          47m   v1.26.0
   # 这里是notready，后面开始配置网卡
   ```

9. master节点配置网络

   ```sh
   # 下载
   wget --no-check-certificate https://projectcalico.docs.tigera.io/archive/v3.25/manifests/calico.yaml
   
   # 修改 calico.yaml 文件
   vim calico.yaml
   # 在 - name: CLUSTER_TYPE 下方添加如下内容
   - name: CLUSTER_TYPE
     value: "k8s,bgp"
     # 下方为新增内容
   - name: IP_AUTODETECTION_METHOD
     value: "interface=网卡名称"
     # INTERFACE_NAME=ens33
     
     
     
   # 查看节点状态（等待几分钟）
   kubectl get nodes
   NAME     STATUS   ROLES           AGE   VERSION
   master   Ready    control-plane   61m   v1.26.0
   node1    Ready    <none>          49m   v1.26.0
   node2    Ready    <none>          49m   v1.26.0
   
   ```



### 创建nginx服务

1. 创建命名空间（master）

   ```sh
   kubectl create namespace zlm-k8s
   ```

2. 添加nginx.yaml文件

   ```sh
   cat > nginx.yaml << EOF
   # 创建命名空间  ：kubectl create namespace zlm-k8s
   # 创建 pod    ：kubectl apply -f nginx-deployment.yaml
   # 查看 pod    ：kubectl -n zlm-k8s get pod -o wide
   # 查看 pod    ：kubectl -n zlm-k8s get pod -o wide
   # 进入 pod    ：kubectl -n zlm-k8s exec -it pod名称 bash
   # 编辑 pod    ：kubectl -n zlm-k8s edit deployment nginx-deployment
   # 删除 pod    ：kubectl -n zlm-k8s delete deployment nginx-deployment
   apiVersion: apps/v1
   kind: Deployment
   metadata:
     name: nginx-deployment
     namespace: zlm-k8s
   spec:
     replicas: 2
     selector:
       matchLabels:
         app: nginx
     template:
       metadata:
         labels:
           app: nginx
       spec:
         containers:
         - name: nginx
           image: nginx:1.23.2
           ports:
           - containerPort: 80
   ---
   # 创建 Service（不能指定 nodePort） ：kubectl -n zlm-k8s expose deployment nginx-deployment --type=NodePort --name=nginx-service
   # 编辑 Service                    ：kubectl -n zlm-k8s edit service nginx-service
   # 删除 Service                    ：kubectl -n zlm-k8s delete service nginx-service
   # 查看 pod、Service               ：kubectl -n 命名空间 get pod,svc -o wide
   
   # https://kubernetes.io/zh-cn/docs/concepts/services-networking/service/
   apiVersion: v1
   kind: Service
   metadata:
     name: nginx-service
     namespace: zlm-k8s
   spec:
     ports:
       - nodePort: 30080
         port: 80
         protocol: TCP
         targetPort: 80
     selector:
       app: nginx
     type: NodePort
   EOF
   ```

3. 执行nginx构建

   ```sh
   kubectl apply -f nginx.yaml
   ```

4. 查看nginx状态

   ```sh
   kubectl get pods -o wide -n zlm-k8s
   NAME                                READY   STATUS    RESTARTS   AGE   IP               NODE    NOMINATED NODE   READINESS GATES
   nginx-deployment-565887c86b-q55cl   1/1     Running   0          43m   172.16.166.129   node1   <none>           <none>
   nginx-deployment-565887c86b-rxhbs   1/1     Running   0          43m   172.16.104.4     node2   <none>           <none>
   ```

5. 浏览器访问

   ```sh
   192.168.6.4:30080
   ```

   

