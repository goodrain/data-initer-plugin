# data-initer-plugin
### 概述

项目地址：https://github.com/goodrain/data-initer-plugin

这是一个用于初始化数据的插件，适用于包括 Rainbond 在内的所有基于 Kubernetes 体系的云平台使用。

其基本的原理，是利用 Kubernetes 的 [init容器](https://kubernetes.io/zh/docs/concepts/workloads/pods/init-containers/) 实现的。插件所在的容器会在业务容器启动之前运行直至完成，通过定义好的下载、解压逻辑，将实现准备好的初始化数据压缩包（仅支持 zip 、tgz、 tar.gz 三种格式）解压到目标目录中去，下载过程支持断点续传。当然，我们要事先将目标目录进行持久化的设置。

下面是一个运行示例，`data-initer-plugin` 是使用当前代码构建出来的镜像，当前示例仅表示其工作原理。正常使用时，请参见后文中 **如何使用插件** 一节。


```bash
docker run -ti  \
-e FILE_URL=https://goodrain-delivery.oss-cn-hangzhou.aliyuncs.com/somedir/mydata.zip \
-e FILE_PATH=/data \
-e DEBUG=1 \
-v $(pwd):/data data-initer-plugin
```

插件支持的环境变量配置如下：

|ENV|VALUE|Tip|
|:---:|:---:|:---:|
|FILE_URL|url|Where to download|
|FILE_PATH|path to dir|Where file to save|
|EXTRACT_FILE|true/false|Auto extract file by default|
|DOWNLOAD_ARGS| -X ,--xx |Other download args of Wget|
|DEBUG|anything true|Debug|



### 在 Rainbond 构建插件

Rainbond 的插件机制中，有对 init 容器的天然支持 —— 初始化类型插件。



#### 1. 新建插件

![image-20210420153912325](https://tva1.sinaimg.cn/large/008eGmZEly1gpq92claspj31vo0u0wlu.jpg)



#### 2. 填写构建源信息

![image-20210420174918386](https://tva1.sinaimg.cn/large/008eGmZEly1gpqctnpfjnj322g0tqn0s.jpg)

关键信息包括：

1. 源码地址：https://github.com/goodrain/data-initer-plugin.git 当选择Dockerfile安装时，需要提供的代码地址
2. 代码版本：main

接下来点击创建插件，等待构建成功即可。



####3. 声明插件配置

这一步，我们需要声明这个插件都可以接收什么样的配置。从概述一节中，我们知道这个插件正常工作时需要定义几个环境变量的。

进入配置组管理处，添加一组配置：

![image-20210420185514757](https://tva1.sinaimg.cn/large/008eGmZEly1gpqeqa4ep8j31zy0u0zox.jpg)

保存配置后，插件就做好了。



### 如何使用插件

#### 1. 前提条件

- 需要被初始化数据的服务组件已经设置好持久化目录。
- 持久化数据已经打包完成（支持格式zip、tgz、tar.gz），并上传到对象存储中。



#### 2. 安装并配置插件

- 为服务组件安装已经制作好的 通用数据初始化插件。
- 查看配置，输入初始化数据包的下载地址，以及目标持久化目录之后，更新配置。

![image-20210421092824164](https://tva1.sinaimg.cn/large/008eGmZEly1gpr3ytje26j325s0p6djq.jpg)

- 更新内存，由于初始化类型插件在运行结束后会自动退出，所以大家不用担心占据资源过大的情况。内存值的设定可以尽量放大，以稍微大于持久化数据包的大小为宜。这会加快下载以及解压的速度。



#### 3. 构建并启动服务组件

观测日志，如果输出如下， 则说明数据初始化过程已经开始：

```bash
7b554df4b7bb:Connecting to rainbond-pkg.oss-cn-shanghai.aliyuncs.com (106.14.228.173:443)

7b554df4b7bb:Rainbond-5.2.2-relea   0% |                                |  367k  2:45:46 ETA
```

等待下载解压完成后，服务组件就会进入正常的启动流程中。



#### 4. 拆除插件

该插件具备读写服务组件持久化数据目录的权限，虽然我们已经加入了防止重复初始化的实现逻辑，但是我们依然 **强烈要求** 在数据初始化成功后，卸载该插件。



### 关于对象存储



我们推荐将初始化数据包放在对象存储中，并提供 Rainbond 平台可以访问的下载地址。

常见的自建对象存储有以下两种情况：

- 基于 S3 协议实现的对象存储软件，如 Minio ，可以在 Rainbond 对接开源应用商店后搜索并安装。
- 公有云服务商所提供的对象存储服务，如阿里云OSS。



