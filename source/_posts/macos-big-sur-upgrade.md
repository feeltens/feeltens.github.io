---
title: macos-big-sur-upgrade
date: 2020-11-20 19:23:44
tags: macOS
---

# macOS Big Sur 升级记录

---

自从 Apple 发布 macOS Big Sur 系统之后，笔者就怀着一颗追新的心，马不停蹄地下载 macOS Big Sur 完整镜像，抹盘重装自己的 Macbook。然后，Macbook 就一天一崩溃。。幸好，有问题，咱不怕。新系统升级带来的各种软件兼容性问题，总归要解决的。基本上，每天解决一个小问题，自己手上的 Macbook 也越用越顺手了。记录一下，留作备忘。

## V2RayX

万万没想到，最重要的上网工具 V2RayX，竟然崩溃了。没关系，我换用 ClashX 就好了。

## Proxifier

Proxifier 作为最常用的代理软件，在 Big Sur 系统上，需要升级到 V3 版本。但最关键的注册码，从何而来呢？幸好有万能的 GitHub，顺便贴出自己的 Proxifier for Mac V3 注册码：

```
3CWNN-WYTP4-SD83W-ASDFR-84KEA
```

## WeChat-plugin

在 Mac 微信上删除对话框，然后 Macbook 又 crash 了。。没关系，我暂时不用 WeChat-plugin 的防撤回功能了。

## 迅雷

之前的 Thunder v6.6.6 修改版也闪退了，幸好找到了 Thunder for Mac v9.9.9 版本，虽然不完美，但凑合用吧。

## Turbo Boost Switcher Pro

升级完系统，第一时间更新了 Turbo Boost Switcher Pro 新版本。但是总是禁用不了 Turbo Boost。关键时刻还得靠官网 FAQ。详见：https://www.rugarciap.com/faqs/

重要步骤：重启到 Recovery 模式（启动时，长按 Command + R），打开 Terminal，输入如下命令：（YourVolumeName 替换成你的系统盘的卷名称）

```shell
kmutil trigger-panic-medic --volume-root /Volumes/<YourVolumeName>
```

然后，再重启，就发现可以禁用 Intel 的 Turbo Boost 了。

## Parallels Desktop 16 联网

在 Parallels Desktop 16 特别版上，虚拟机无法联网。

此时，完全退出 Parallels Desktop。在 Terminal 中，输入以下命令和用户密码，会自动启动 Parallels Desktop。（注意：Terminal 不要关掉。）

```shell
sudo -b /Applications/Parallels\ Desktop.app/Contents/MacOS/prl_client_app
```

后来，又去试了一下 VMware Fusion for Mac v12，还算不错，但首选还是 PD。

总结一下，追新挺好，稳定为主。