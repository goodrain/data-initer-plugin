# data-initer-plugin
一个用于初始化数据的插件，适用于包括 Rainbond 在内的所有基于 Kubernetes 体系的云平台使用。

其基本的原理，是利用 Kubernetes 的 [init容器](https://kubernetes.io/zh/docs/concepts/workloads/pods/init-containers/) 实现的。插件所在的容器会在业务容器启动之前运行直至完成，通过定义好的下载、解压逻辑，将准备好的  


```bash
docker run -ti  \
-e FILE_URL=https://goodrain-delivery.oss-cn-hangzhou.aliyuncs.com/somedir/mydata.zip \
-e FILE_PATH=/data \
-e DEBUG=1 \
-v $(pwd):/data data-initer-plugin
```

|ENV|VALUE|Tip|
|:---:|:---:|:---:|
|FILE_URL|url|Where to download|
|FILE_PATH|path to dir|Where file to save|
|EXTRACT_FILE|true/false|Auto extract file by default|
|DOWNLOAD_ARGS| -X ,--xx |Other download args of Wget|
|DEBUG|anything true|Debug|

