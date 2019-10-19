---
title: IDEA Git 忽略文件最佳方式
date: 2019-09-19 22:51:08
tags:
	- Git
	- IDEA
---

# IDEA Git 忽略文件最佳方式

## 文件没有纳入版本管理

加入 .gitignore 文件中。

推荐安装并使用 .gitignore 和 Add to gitignore 两个插件。

## 文件已经纳入版本管理


IntelliJ IDEA 提供了 changelist 功能，可以对文件进行分类，提交时，只提交 active（活跃的）changelist。

<!--more-->

在 IDEA 最下面的 Version Control，右键，点击「New Changelist」

![](https://raw.githubusercontent.com/feeltens/vnote-resources/master/images/20190919223824.png)



命名为 ignored。

![](https://raw.githubusercontent.com/feeltens/vnote-resources/master/images/20190919223947.png)



修改需要忽略的文件，将文件从 Default Changelist 拖动到 ignored 里面。

![](https://raw.githubusercontent.com/feeltens/vnote-resources/master/images/20190919224125.png)



以后 git 提交时，选择 Changelist 为 Default Changelist 即可。此时忽略的文件便不会出现在提交文件列表里了。

![](https://raw.githubusercontent.com/feeltens/vnote-resources/master/images/20190919224521.png)