# data-initer-plugin
A plugin that performs data initialization before the application starts


```bash
docker run -ti  \
-e FILE_URL=https://goodrain-delivery.oss-cn-hangzhou.aliyuncs.com/boe/code/BOECODE-0107.zip \
-e FILE_PATH=/data \
-e DEBUG=1 \
-v $(pwd):/data datainit
```

|ENV|VALUE|Tip|
|:---:|:---:|:---:|
|FILE_URL|url|Where to download|
|FILE_PATH|path to dir|Where file to save|
|EXTRACT_FILE|true/false|Auto extract file by default|
|DOWNLOAD_ARGS| -X ,--xx |Other download args of Wget|
|DEBUG|anything true|Debug|

