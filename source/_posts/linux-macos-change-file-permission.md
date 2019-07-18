---
title: Linux / macOS 修改文件目录权限
date: 2019-07-19 05:25:13
tags:
	- Linux
	- macOS
	- Shell
categories:
	- Dev
---

笔者在使用 Linux 和 macOS 时，经常遇到文件目录权限不足的问题，所以整理了一些修改文件目录权限的命令。

<!--more-->

## 创建自带特定权限的文件目录

```shell
sudo mkdir -pm 775 /opt/fastdfs
```
命令说明：

- 示例命令，是创建一个权限为 775 的 `/opt/fastdfs` 的目录。
- `-p` 是 `--parents` 的意思，若父目录不存在，则自动创建父目录。
- `-m` 是 `--mode` 的意思，用于设定权限，`-m 775` 代表权限为 775。

## 修改文件目录的持有者（推荐使用）

```shell
sudo chown -R $USER /opt/fastdfs
```
命令说明：

- 示例命令，是将 `/opt/fastdfs` 目录的持有者修改为当前登录用户。
- `-R` 代表递归操作。
- `$USER` 代表当前登录用户，也可以修改为特定用户名。

## 修改已存在的文件目录权限

```shell
sudo chmod -R 775 /opt/fastdfs
```
命令说明：

- 示例命令，是将 `/opt/fastdfs` 目录的权限修改为 775。

---

最后一句，涉及权限，谨慎使用。