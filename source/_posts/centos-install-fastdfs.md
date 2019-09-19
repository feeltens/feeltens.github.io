---
title: CentOS 安装部署单机版 FastDFS
date: 2019-07-18 09:56:47
categories:
	- Dev
tags: 
	- FastDFS
	- CentOS
---

## 环境准备
虚拟机 CentOS-7 ip：111.111.111.11
本地 macOS

修改 CentOS hosts
配置 hosts，将文件服务器的 ip 与域名映射。后期配置可以直接使用 `file.feeltens.com` 去配置服务器地址。
ip 变了，就只需要修改 hosts 即可。

```shell
sudo vim /etc/hosts
```
添加如下配置：
```
# FastDfs
111.111.111.11 file.feeltens.com
```

本地 macOS 访问虚拟机里面的 FastDFS，也需要修改 hosts。

<!--more-->

CentOS 创建临时目录
```shell
sudo mkdir -pm 775 /myfolder
```
安装 CentOS 依赖包：
```shell
yum install -y gcc gcc-c++ pcre pcre-devel zlib zlib-devel openssl openssl-devel
```

## 安装 FastDFS

### 下载安装 libfastcommon
libfastcommon 是从 FastDFS 和 FastDHT 中提取出来的公共 C 函数库，基础环境，安装即可 。
[https://github.com/happyfish100/libfastcommon](https://github.com/happyfish100/libfastcommon)
```shell
cd /myfolder
```
```shell
git clone https://github.com/happyfish100/libfastcommon.git
```
```shell
cd libfastcommon
```
编译、安装
```shell
./make.sh && ./make.sh install
```
libfastcommon.so 安装到了 /usr/lib64/libfastcommon.so，但是 FastDFS 主程序设置的 lib 目录是 /usr/local/lib，所以需要创建软链接。
```shell
ln -s /usr/lib64/libfastcommon.so /usr/local/lib/libfastcommon.so
ln -s /usr/lib64/libfastcommon.so /usr/lib/libfastcommon.so
ln -s /usr/lib64/libfdfsclient.so /usr/local/lib/libfdfsclient.so
ln -s /usr/lib64/libfdfsclient.so /usr/lib/libfdfsclient.so
```

### 下载安装 FastDFS
下载 FastDFS
[https://github.com/happyfish100/fastdfs](https://github.com/happyfish100/fastdfs)
```shell
cd /myfolder
```
```shell
git clone https://github.com/happyfish100/fastdfs.git
```
```shell
cd fastdfs
```
编译
```shell
./make.sh
```
安装
```shell
./make.sh install
```
默认安装方式安装后的服务脚本：
```
/etc/init.d/fdfs_trackerd
/etc/init.d/fdfs_storaged
```
默认安装方式安装后的配置文件：
```
/etc/fdfs/tracker.conf.sample
/etc/fdfs/storage.conf.sample
/etc/fdfs/client.conf.sample
```
默认安装方式安装后的命令工具在 `/usr/bin` 目录下，列表如下：
```
/usr/bin/fdfs_appender_test
/usr/bin/fdfs_appender_test1
/usr/bin/fdfs_append_file
/usr/bin/fdfs_crc32
/usr/bin/fdfs_delete_file
/usr/bin/fdfs_download_file
/usr/bin/fdfs_file_info
/usr/bin/fdfs_monitor
/usr/bin/fdfs_storaged
/usr/bin/fdfs_test
/usr/bin/fdfs_test1
/usr/bin/fdfs_trackerd
/usr/bin/fdfs_upload_appender
/usr/bin/fdfs_upload_file
/usr/bin/stop.sh
/usr/bin/restart.sh
```
FastDFS 服务脚本设置的 bin 目录是 /usr/local/bin，但实际命令安装在 /usr/bin/ 下。
所以需要建立 /usr/bin 到 /usr/local/bin 的软链接。
```shell
ln -s /usr/bin/fdfs_trackerd   /usr/local/bin
ln -s /usr/bin/fdfs_storaged   /usr/local/bin
ln -s /usr/bin/stop.sh         /usr/local/bin
ln -s /usr/bin/restart.sh      /usr/local/bin
```
### 配置 FastDFS 跟踪器 (Tracker)
进入 /etc/fdfs，复制 FastDFS 跟踪器样例配置文件 tracker.conf.sample，并重命名为 tracker.conf。
```shell
cd /etc/fdfs
```
```shell
cp tracker.conf.sample tracker.conf
```
```shell
vim tracker.conf
```
修改配置如下：
```
# 配置文件是否不生效，false 为生效
disabled=false

# 提供服务的端口
port=22122

# Tracker 数据和日志目录地址（根目录必须存在，子目录会自动创建）
base_path=/opt/fastdfs/tracker

# HTTP 服务端口
http.server_port=80
```
创建 tracker 基础数据目录，即 base_path 对应的目录
```shell
sudo mkdir -pm 777 /opt/fastdfs/tracker
```
在防火墙中开放 22122 端口，本次虚拟机 CentOS 防火墙已完全关闭。

启动 Tracker
初次成功启动，会在 `/opt/fastdfs/tracker/` (配置的 base_path) 下创建 `data` 和 `logs` 两个目录。
可以用这种方式启动
```shell
/etc/init.d/fdfs_trackerd start
```
也可以用这种方式启动，前提是上面创建了软链接，后面都用这种方式
```shell
service fdfs_trackerd start
```
查看 FastDFS Tracker 是否已成功启动 ，22122 端口正在被监听，则算是 Tracker 服务安装成功。
```shell
netstat -unltp | grep fdfs
```
关闭 Tracker 命令：
```shell
service fdfs_trackerd stop
```
设置 Tracker 开机启动
```shell
chkconfig fdfs_trackerd on
```
或者：
```shell
vim /etc/rc.d/rc.local
```
加入配置：
```
/etc/init.d/fdfs_trackerd start
```
Tracker 服务启动成功后，会在 base_path 下创建 data、logs 两个目录。目录结构如下：
```
${base_path}
  |__data
  |   |__storage_groups.dat：存储分组信息
  |   |__storage_servers.dat：存储服务器列表
  |__logs
  |   |__trackerd.log： tracker server 日志文件
```

### 配置 FastDFS 存储 (Storage)
进入 /etc/fdfs 目录，复制 FastDFS 存储器样例配置文件 storage.conf.sample，并重命名为 storage.conf
```shell
cd /etc/fdfs
```
```shell
cp storage.conf.sample storage.conf
```
```shell
vim storage.conf
```
修改配置如下：
```
# 配置文件是否不生效，false 为生效
disabled=false

# 指定此 storage server 所在 组(卷)
group_name=group1

# storage server 服务端口
port=23000

# 心跳间隔时间，单位为秒 (这里是指主动向 tracker server 发送心跳)
heart_beat_interval=30

# Storage 数据和日志目录地址(根目录必须存在，子目录会自动生成)
base_path=/opt/fastdfs/storage

# 存放文件时 storage server 支持多个路径。这里配置存放文件的基路径数目，通常只配一个目录。
store_path_count=1

# 逐一配置 store_path_count 个路径，索引号基于 0。
# 如果不配置 store_path0，那它就和 base_path 对应的路径一样。
store_path0=/opt/fastdfs/file

# FastDFS 存储文件时，采用了两级目录。这里配置存放文件的目录个数。
# 如果本参数只为 N（如： 256），那么 storage server 在初次运行时，会在 store_path 下自动创建 N * N 个存放文件的子目录。
subdir_count_per_path=256

# tracker_server 的列表 ，会主动连接 tracker_server
# 有多个 tracker server 时，每个 tracker server 写一行
tracker_server=file.feeltens.com:22122

# 允许系统同步的时间段 (默认是全天) 。一般用于避免高峰同步产生一些问题而设定。
sync_start_time=00:00
sync_end_time=23:59
# 访问端口
http.server_port=80
```

创建 Storage 基础数据目录，对应 base_path 目录
```shell
sudo mkdir -pm 775 /opt/fastdfs/storage
```
创建配置的 store_path0 路径
```shell
sudo mkdir -pm 775 /opt/fastdfs/file
```
在防火墙中开放 23000 端口，本次虚拟机 CentOS 防火墙已完全关闭。

启动 Storage
启动 Storage 前确保 Tracker 是启动的。
初次启动成功，会在 `/opt/fastdfs/storage` 目录下创建 data、 logs 两个目录。

可以用这种方式启动
```shell
/etc/init.d/fdfs_storaged start
```
也可以用这种方式，后面都用这种
```shell
service fdfs_storaged start
```
查看 Storage 是否成功启动，23000 端口正在被监听，就算 Storage 启动成功。
```shell
netstat -unltp | grep fdfs
```

关闭 Storage 命令：
```shell
service fdfs_storaged stop
```
查看 Storage 和 Tracker 是否在通信：
```shell
/usr/bin/fdfs_monitor /etc/fdfs/storage.conf
```
显示结果如下：
```
➜  storage /usr/bin/fdfs_monitor /etc/fdfs/storage.conf
[2019-06-14 06:35:39] DEBUG - base_path=/opt/fastdfs/storage, connect_timeout=30, network_timeout=60, tracker_server_count=1, anti_steal_token=0, anti_steal_secret_key length=0, use_connection_pool=0, g_connection_pool_max_idle_time=3600s, use_storage_id=0, storage server id count: 0

server_count=1, server_index=0

tracker server is 111.111.111.11:22122

group count: 1

Group 1:
group name = group1
disk total space = 17394 MB
disk free space = 13128 MB
trunk free space = 0 MB
storage server count = 1
active server count = 1
storage server port = 23000
storage HTTP port = 80
store path count = 1
subdir count per path = 256
current write server index = 0
current trunk file id = 0

        Storage 1:
                id = 111.111.111.11
                ip_addr = 111.111.111.11 (file.feeltens.com)  ACTIVE
                http domain = 
                version = 5.05
                join time = 2019-06-14 06:34:57
                up time = 2019-06-14 06:34:57
                total storage = 17394 MB
                free storage = 13128 MB
                upload priority = 10
                store_path_count = 1
                subdir_count_per_path = 256
                storage_port = 23000
                storage_http_port = 80
                current_write_path = 0
                source storage id = 
                if_trunk_server = 0
                connection.alloc_count = 256
                connection.current_count = 0
                connection.max_count = 0
                total_upload_count = 0
                success_upload_count = 0
                total_append_count = 0
                success_append_count = 0
                total_modify_count = 0
                success_modify_count = 0
                total_truncate_count = 0
                success_truncate_count = 0
                total_set_meta_count = 0
                success_set_meta_count = 0
                total_delete_count = 0
                success_delete_count = 0
                total_download_count = 0
                success_download_count = 0
                total_get_meta_count = 0
                success_get_meta_count = 0
                total_create_link_count = 0
                success_create_link_count = 0
                total_delete_link_count = 0
                success_delete_link_count = 0
                total_upload_bytes = 0
                success_upload_bytes = 0
                total_append_bytes = 0
                success_append_bytes = 0
                total_modify_bytes = 0
                success_modify_bytes = 0
                stotal_download_bytes = 0
                success_download_bytes = 0
                total_sync_in_bytes = 0
                success_sync_in_bytes = 0
                total_sync_out_bytes = 0
                success_sync_out_bytes = 0
                total_file_open_count = 0
                success_file_open_count = 0
                total_file_read_count = 0
                success_file_read_count = 0
                total_file_write_count = 0
                success_file_write_count = 0
                last_heart_beat_time = 2019-06-14 06:35:29
                last_source_update = 1970-01-01 08:00:00
                last_sync_update = 1970-01-01 08:00:00
                last_synced_timestamp = 1970-01-01 08:00:00 
```
重要信息是 `Storage ip_addr = 111.111.111.11 (file.feeltens.com)  ACTIVE`。

设置 Storage 开机启动
```shell
chkconfig fdfs_storaged on
```
或者：
```shell
vim /etc/rc.d/rc.local
```
加入配置：
```
/etc/init.d/fdfs_storaged start
```

Storage 目录同 Tracker，Storage 启动成功后，在 base_path 下创建了 data、logs 目录，记录着 Storage Server 的信息。
在 store_path0 目录下，创建了 N*N 个子目录。
```shell
cd /opt/fastdfs/file/data
```

### 文件上传测试

修改 Tracker 服务器中的客户端配置文件
```shell
cd /etc/fdfs
```
```shell
cp client.conf.sample client.conf
```
```shell
vim client.conf
```
修改如下配置即可，其它默认。
```
# Client 的数据和日志目录
base_path=/opt/fastdfs/client

# Tracker 端口
tracker_server=file.feeltens.com:22122
```

上传测试
```shell
sudo mkdir -pm 775 /opt/fastdfs/client
```
在 CentOS 内部执行如下命令，上传 1.jpg 图片
```shell
/usr/bin/fdfs_upload_file /etc/fdfs/client.conf /myfolder/1.jpg
```
显示结果如下：
```
➜  /myfolder /usr/bin/fdfs_upload_file /etc/fdfs/client.conf /myfolder/1.jpg
group1/M00/00/00/b29vC10C0YaAXl0GAADglZ7FErM123.jpg
```
返回的文件 ID 由 group、存储目录、两级子目录、fileid、文件后缀名（由客户端指定，主要用于区分文件类型）拼接而成。
![](https://raw.githubusercontent.com/feeltens/vnote-resources/master/images/20190613232013.png)

查找上传的图片
```shell
cd /opt/fastdfs/file/data/00/00
```
```shell
ll
```
显示结果如下：
```
➜  00 ll
total 60K
-rw-r--r--. 1 root root 57K Jun 14 06:43 b29vC10C0YaAXl0GAADglZ7FErM123.jpg
```

## 安装 Nginx
Nginx 只需要安装到 StorageServer 所在的服务器即可，用于访问文件。
单机部署 TrackerServer 和 StorageServer 在一台服务器上。

### 安装 nginx
```shell
cd /myfolder
```
```shell
wget -c https://nginx.org/download/nginx-1.15.1.tar.gz
```
解压
```shell
tar -zxvf nginx-1.15.1.tar.gz
```
```shell
cd nginx-1.15.1
```
使用默认配置
```shell
./configure
```
编译、安装
```shell
make && make install
```

启动 nginx
```shell
cd /usr/local/nginx/sbin
```
```shell
./nginx
```

其他 nginx 命令：
停止 nginx 服务：
```shell
./nginx -s stop
```
退出 nginx 服务：
```shell
./nginx -s quit
```
重新加载 nginx 配置：
```shell
./nginx -s reload
```

设置 nginx 开机启动：
```shell
vim /etc/rc.local
```
添加一行配置：
```
/usr/local/nginx/sbin/nginx
```
设置执行权限：
```shell
sudo chmod 755 /etc/rc.local
```

查看 nginx 的版本和模块
```shell
/usr/local/nginx/sbin/nginx -V
```
显示结果如下：
```
➜  sbin /usr/local/nginx/sbin/nginx -V
nginx version: nginx/1.15.1
built by gcc 4.8.5 20150623 (Red Hat 4.8.5-36) (GCC)
configure arguments:
```

在防火墙中开放 nginx 的默认 80 端口，本次虚拟机 CentOS 防火墙已完全关闭。

### 配置 nginx
修改 nginx.conf
```shell
vim /usr/local/nginx/conf/nginx.conf
```
在
```
error_page   500 502 503 504  /50x.html;
location = /50x.html {
    root   html;
}
```
下方
添加如下配置，将 /group1/M00 映射到 /opt/fastdfs/file/data
```
location /group1/M00 {
    alias /opt/fastdfs/file/data;
}
```
重启 nginx
```shell
/usr/local/nginx/sbin/nginx -s reload
```

### 测试访问图片
在外面主机 macOS 的浏览器访问之前上传的图片。
http://file.feeltens.com/group1/M00/00/00/b29vC10C0YaAXl0GAADglZ7FErM123.jpg

## FastDFS 配置 Nginx 模块
### fastdfs-nginx-module 模块说明
FastDFS 通过 Tracker 服务器，将文件放在 Storage 服务器存储，但是同组存储服务器之间需要进行文件复制，有同步延迟的问题。
假设 Tracker 服务器将文件上传到了 192.168.51.128，上传成功后文件 ID 已经返回给客户端。
此时 FastDFS 存储集群机制，会将这个文件同步到同组存储 192.168.51.129。在文件还没有复制完成的情况下，客户端如果用这个文件 ID 在 192.168.51.129 上取文件，就会出现文件无法访问的错误。
而 fastdfs-nginx-module 可以重定向文件链接到源服务器取文件，避免客户端由于复制延迟导致的文件无法访问错误。

### 安装配置 fastdfs-nginx-module

下载 fastdfs-nginx-module
```shell
cd /myfolder
```
```shell
wget https://github.com/happyfish100/fastdfs-nginx-module/archive/5e5f3566bbfa57418b5506aaefbe107a42c9fcb1.zip
```
fastdfs-nginx-module 最新版的 master 与当前 nginx 有些版本问题，所以指定旧有稳定版本。

解压
```shell
unzip 5e5f3566bbfa57418b5506aaefbe107a42c9fcb1.zip
```

重命名
```shell
mv fastdfs-nginx-module-5e5f3566bbfa57418b5506aaefbe107a42c9fcb1  fastdfs-nginx-module-master
```

配置 nginx
停止 nginx 服务
```shell
/usr/local/nginx/sbin/nginx -s stop
```
```shell
cd /myfolder/nginx-1.15.1
```
添加 fastdfs-nginx-module 模块
```shell
./configure --add-module=../fastdfs-nginx-module-master/src
```
重新编译、安装
```shell
make && make install
```
查看 nginx 模块
```shell
/usr/local/nginx/sbin/nginx -V
```
显示结果如下：
```
➜  nginx-1.15.1 /usr/local/nginx/sbin/nginx -V
nginx version: nginx/1.15.1
built by gcc 4.8.5 20150623 (Red Hat 4.8.5-36) (GCC)
configure arguments: --add-module=../fastdfs-nginx-module-master/src
```

复制 fastdfs-nginx-module 源码中的配置文件到 /etc/fdfs 目录，并修改
```shell
cd /myfolder/fastdfs-nginx-module-master/src
```
```shell
cp mod_fastdfs.conf /etc/fdfs/
```
```shell
vim /etc/fdfs/mod_fastdfs.conf
```
修改配置如下：
```
# 连接超时时间
connect_timeout=10

# Tracker Server
tracker_server=file.feeltens.com:22122

# StorageServer 默认端口
storage_server_port=23000

# 如果文件 ID 的 uri 中包含 /group**，则要设置为 true
url_have_group_name = true

# Storage 配置的 store_path0 路径，必须和 storage.conf 中的一致
store_path0=/opt/fastdfs/file
```

复制 FastDFS 的部分配置文件到 /etc/fdfs 目录
```shell
cd /myfolder/fastdfs/conf/
```
```shell
cp anti-steal.jpg http.conf mime.types /etc/fdfs/
```

配置 nginx，修改 nginx.conf
```shell
vim /usr/local/nginx/conf/nginx.conf
```
修改配置：
注释掉刚刚添加的
```
location /group1/M00 {
    alias /opt/fastdfs/file/data;
}
```
并在 80 端口下添加 fastdfs-nginx 模块
```
location ~/group([0-9])/M00 {
    ngx_fastdfs_module;
}
```
![fastdfs-nginx-config](https://raw.githubusercontent.com/feeltens/vnote-resources/master/images/20190614000703.png)
注意：
`listen 80` 端口值是要与 `/etc/fdfs/storage.conf` 中的 `http.server_port=80` (前面改成 80 了) 相对应。如果改成其它端口，则需要统一，同时在防火墙中打开该端口。
`location` 的配置，如果有多个 group 则配置 location ~/group([0-9])/M00 ，没有则不用配 group。

启动 nginx
```shell
/usr/local/nginx/sbin/nginx
```
打印处如下就算配置成功。
显示结果如下：
```
➜  conf /usr/local/nginx/sbin/nginx
ngx_http_fastdfs_set pid=67575
```

### 测试访问图片
在外面主机 macOS 的浏览器访问之前上传的图片。
http://file.feeltens.com/group1/M00/00/00/b29vC10C0YaAXl0GAADglZ7FErM123.jpg

![FastDFS最终部署结构图](https://raw.githubusercontent.com/feeltens/vnote-resources/master/images/20190614001052.png)

## 安装 FastDHT
FastDFS 本身是不支持重复文件去重的。可以借助 `FastDHT` 来实现文件去重。
FastDHT 是分布式哈希系统（DHT），使用 Berkeley DB 做数据存储，使用 libevent 做网络 IO 处理。依赖于 libfastcommon。

### 安装 Berkeley DB
下载 berkeley-db
```shell
cd /myfolder
```
```shell
wget http://download.oracle.com/berkeley-db/db-6.0.30.tar.gz
```

解压
```shell
tar zxvf db-6.0.30.tar.gz
```
```shell
cd db-6.0.30/build_unix
```
进行提权：
```shell
chmod 777 ../dist/configure
```
选择安装目录
```shell
../dist/configure --prefix=/usr
```
编译、安装
```shell
make && make install
```
安装完 db，会在 /usr/local 目录下生成 berkeley-db 目录。
```shell
cd /usr/ && ll
```
berkeley-db 安装后的目录结构如下：
```
/usr
├── bin
│   ├── db_archive
│   ├── db_checkpoint
│   ├── db_codegen
│   ├── db_deadlock
│   ├── db_dump
│   ├── db_hotbackup
│   ├── db_load
│   ├── db_printlog
│   ├── db_recover
│   ├── db_stat
│   ├── db_upgrade
│   └── db_verify
├── common
│   ├── crypto_stub.c
│   ├── db_byteorder.c
│   ├── db_err.c
│   ├── db_getlong.c
│   ├── db_idspace.c
│   ├── db_log2.c
│   ├── db_shash.c
│   ├── dbt.c
│   ├── mkpath.c
│   ├── openflags.c
│   ├── os_method.c
│   ├── tags -> ../dist/tags
│   ├── util_arg.c
│   ├── util_cache.c
│   ├── util_log.c
│   ├── util_sig.c
│   └── zerofill.c
├── docs
│   ├── api_c
│   ├── api_cxx
│   ├── api_tcl
│   ├── articles
│   ├── collections
│   ├── gsg
│   ├── gsg_db_rep
│   ├── gsg_txn
│   ├── images
│   ├── java
│   ├── license
│   ├── porting
│   ├── ref
│   └── utility
│   └── index.html
├── include
│   ├── db.h
│   └── db_cxx.h
└── lib
    ├── libdb-6.0.a
    ├── libdb-6.0.la
    ├── libdb-6.0.so
    ├── libdb-6.so -> libdb-6.0.so
    ├── libdb.a
    └── libdb.so -> libdb-6.0.so

```

### 下载安装 FastDHT
```shell
cd /myfolder
```
```shell
git clone https://github.com/happyfish100/fastdht.git
```
```shell
cd fastdht
```

编译、安装
```shell
sudo ./make.sh
```
```shell
sudo ./make.sh install
```
最后会在 /usr/local/bin 生成安装后的文件，在 /etc/fdht 下生成配置文件。
```shell
cd /usr/local/bin && ll
```
```shell
cd /etc/fdht && ll
```

### 配置 FastDHT

创建 fastdht 目录
```shell
sudo mkdir -pm 775 /opt/fastdfs/fastdht
```

修改 fdhtd.conf 文件
```shell
vim /etc/fdht/fdhtd.conf
```
修改配置如下：
```
port=11411
base_path=/opt/fastdfs/fastdht
# 有 # 表示打开，如果想关闭此选项，则应该为 ## 开头。# 和 include 之间没有空格
#include /etc/fdht/fdht_servers.conf
```

修改 fdht_servers.conf 文件
```shell
vim /etc/fdht/fdht_servers.conf
```
修改配置如下：
```
# 分组数量（数字可自定义）
group_count = 1
group0 = file.feeltens.com:11411
# group0 = 192.168.224.224:11411
# group1 = 192.168.224.223:11411
# group1 = 192.168.224.224:11411
```

修改 fdht_client.conf 文件
```shell
vim /etc/fdht/fdht_client.conf
```
修改配置如下：
```
# keep_alive=1 关联 storaged.conf 文件
keep_alive=1
base_path=/opt/fastdfs/fastdht
#（注意： # 和 include 之间没有空格）
#include /etc/fdht/fdht_servers.conf
```

修改 storage.conf 文件
```shell
vim /etc/fdfs/storage.conf
```
修改配置如下：
```
# 是否检测上传文件已经存在。如果已经存在，则不存在文件内容，建立一个索引链接以节省磁盘空间
check_file_duplicate=1
# 当上个参数设定为1时，在 FastDHT 中的命名空间
key_namespace=FastDFS
# 长连接配置选项，如果为0则为短连接 1为长连接
keep_alive=1
# 可以通过 #include filename 方式来加载 FastDHT servers  的配置
# 注意： # 和 include 之间没有空格
#include /etc/fdht/fdht_servers.conf
```

查看动态链接库是否全链接完毕
```shell
ldd /usr/local/bin/fdhtd
```
显示结果如下：
```
➜  fdht ldd /usr/local/bin/fdhtd
        linux-vdso.so.1 =>  (0x00007ffe52792000)
        libdb-6.0.so => not found
        libfastcommon.so => /lib/libfastcommon.so (0x00007f86dc518000)
        libpthread.so.0 => /lib64/libpthread.so.0 (0x00007f86dc2fc000)
        libc.so.6 => /lib64/libc.so.6 (0x00007f86dbf2f000)
        libm.so.6 => /lib64/libm.so.6 (0x00007f86dbc2d000)
        libdl.so.2 => /lib64/libdl.so.2 (0x00007f86dba29000)
        /lib64/ld-linux-x86-64.so.2 (0x00007f86dc759000)
```
提示缺少 libdb-6.0.so。
执行 ldconfig 命令：
```shell
ldconfig
```
`ldconfig` 命令的用途，主要是在默认搜寻目录 (/lib 和 /usr/lib) 以及动态库配置文件 /etc/ld.so.conf 内所列的目录下，搜索出可共享的动态链接库 (格式如 lib.so)，进而创建出动态装入程序(ld.so) 所需的连接和缓存文件。缓存文件默认为 /etc/ld.so.cache，此文件保存已排好序的动态链接库名字列表。
再次查看动态链接库是否全链接完毕
```shell
ldd /usr/local/bin/fdhtd
```
显示结果如下：
```
➜  fdht ldd /usr/local/bin/fdhtd
        linux-vdso.so.1 =>  (0x00007ffd26992000)
        libdb-6.0.so => /lib/libdb-6.0.so (0x00007f8c3a3db000)
        libfastcommon.so => /lib/libfastcommon.so (0x00007f8c3a19a000)
        libpthread.so.0 => /lib64/libpthread.so.0 (0x00007f8c39f7e000)
        libc.so.6 => /lib64/libc.so.6 (0x00007f8c39bb1000)
        libm.so.6 => /lib64/libm.so.6 (0x00007f8c398af000)
        libdl.so.2 => /lib64/libdl.so.2 (0x00007f8c396ab000)
        /lib64/ld-linux-x86-64.so.2 (0x00007f8c3a7b9000)
```

### 启动 FastDHT

注意：要先启动 FastDHT，再启动 storage，才能使文件去重功能生效。

启动 FastDHT 命令
```shell
fdhtd /etc/fdht/fdhtd.conf
```
重启 FastDHT 命令
```shell
fdhtd /etc/fdht/fdhtd.conf restart
```

验证配置文件是否正确
```shell
service fdfs_trackerd restart
fdhtd /etc/fdht/fdhtd.conf
service fdfs_storaged restart
/usr/local/bin/fdht_test /etc/fdht/fdht_client.conf
```
显示结果如下：
```
/usr/local/bin/fdht_test: Symbol `g_log_context' has different size in shared object, consider re-linking
fdht_get_sub_keys fail, errno: 95, error info: Operation not supported
```
问题未解决，不过使用不受影响。TODO

查看端口是否启动
```shell
netstat -an | grep 11411
```
显示结果如下：
```
➜  fdht netstat -an | grep 11411
tcp        0      0 0.0.0.0:11411           0.0.0.0:*               LISTEN
```

设置 FastDHT 开机自启
```shell
vim /etc/rc.local
```
加入以下配置：
```shell
fdhtd /etc/fdht/fdhtd.conf
```
如果开启自启不生效，可能是 CentOS 找不到 fdhtd 文件。建议把全路径写上：/usr/local/bin/fdhtd /etc/fdht/fdhtd.conf。
执行命令，使之生效：
```shell
chmod +x /etc/rc.local
```

## 后续维护命令
重启 FastDFS 的 tracker、storage 和 FastDHT
```shell
service fdfs_trackerd start
fdhtd /etc/fdht/fdhtd.conf restart
service fdfs_storaged restart
```
查看 FastDFS 和 FastDHT 运行状态
```shell
netstat -unltp | grep fdfs && netstat -unltp | grep fdhtd
```
查看 FastDFS 的 tracker、storage 和 FastDHT 的相关日志
```shell
tail -f /opt/fastdfs/tracker/logs/trackerd.log
```
```shell
tail -f /opt/fastdfs/storage/logs/storaged.log
```
```shell
tail -f /opt/fastdfs/fastdht/logs/fdhtd.log
```

## 参考资料
用 FastDFS 一步步搭建文件管理系统 - bojiangzhou - 博客园
https://www.cnblogs.com/chiangchou/p/fastdfs.html
【FastDFS】FastDFS+FastDHT 完成文件上传去重 - 柠檬树 - CSDN 博客
https://blog.csdn.net/qq_26545305/article/details/80071256
fastdht github install 说明文档
https://github.com/happyfish100/fastdht/blob/master/INSTALL
Oracle Berkeley DB - Previous Releases 
https://www.oracle.com/technetwork/database/database-technologies/berkeleydb/downloads/index-082944.html
[FastDFS] FastDFS FAQ
http://bbs.chinaunix.net/thread-1920470-1-1.html