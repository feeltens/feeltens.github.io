---
title: Git 忽略文件目录权限或文件拥有者的改变
date: 2019-07-26 15:39:55
tags:
	- Git
---

笔者在重装系统和使用 chmod & chown 命令后，发现 IntelliJ IDEA 中的工程代码会出现大范围的代码不一致的情况（其实代码没有修改过）。后来查阅资料，发现 Git 默认会把文件权限也算作文件差异的一部分。

<!--more-->

解决办法：

git 中可以加入忽略文件权限的配置，在 git 根目录运行如下命令：
当前版本库忽略文件权限
```shell
git config core.filemode false
```
所有版本库忽略文件权限
```shell
git config --global core.filemode false
```
这样就设置了忽略文件权限。

查看 git 的配置文件：
```shell
cat .git/config
```

这时候再更新代码就 OK 了。

参考资料：
git 中忽略文件权限或文件拥有者的改变 - 冰狼爱魔 - 博客园
https://www.cnblogs.com/itsharehome/p/4866837.html
How do I make Git ignore file mode (chmod) changes? - Stack Overflow 
https://stackoverflow.com/questions/1580596/how-do-i-make-git-ignore-file-mode-chmod-changes
git config 官方说明
https://mirrors.edge.kernel.org/pub/software/scm/git/docs/git-config.html#EXAMPLES
