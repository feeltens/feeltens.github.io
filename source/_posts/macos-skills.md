---
title: macOS skills
date: 2019-07-23 21:58:47
tags:
	- macOS
categories:
	- skill
---


## 安装任何来源软件
```shell
sudo spctl --master-disable
```

## 修改文件夹权限

创建带权限的文件目录
```shell
sudo mkdir -pm 775 /opt/fastdfs
```
修改文件目录的持有者（推荐使用）
```shell
sudo chown -R $USER /opt/fastdfs
```
修改已存在的文件目录权限
```shell
sudo chmod -R 777 /opt/fastdfs
```

## 调整菜单栏图标位置
按住 `Command`，手动拖拽系统图标

<!--more-->

## 隐藏 Transcend JetDrive Lite

1. 为你的 Transcend 制作替身，也就是快捷方式
2. 将该替身重命名为 `SD`，然后保存到非 Transcend 磁盘的其他地方
3. 将快捷方式拖入 Finder 左侧个人收藏边栏
4. 使用 File Locker 将 /Volumes/SD 隐藏。

## 切换中英文输入法

System Perences → Keyboard → Shortcuts → Input Sources → 勾选 Select the previous input source

## 修改配置文件，提前备份

```shell
cp oldFile newFile
```

## macOS 查看哪些端口被占用
```shell
sudo lsof -i :9000
sudo kill -9 364
```
`lsof` 代表 `list open file`。
`-i` 代表网络连接。
`:9000` 指明端口号。

## macOS 优酷客户端下载的视频位置

```
~/Library/Containers/com.youku.mac/Data/
```

## macOS 语言设置

- macOS 全局语言设置

```
System Preferences → Language & Region → Preferred languages
```

- macOS 系统初始化 Recovery 语言

打开终端 Terminal 输入

```shell
sudo languagesetup
```

然后输入 1) 是英文，重启电脑

13) 是简体中文

- App-Language

```
App-Language-Chooser
Language-Switcher
LanguagesService
LinguaSwitch
```

- 修改单个 Mac 应用程序的默认语言

在使用英文作为 Mac 默认语言的时候，需要让 Microsoft Word 以简体中文运行。

1. 找到 App 的 Bundle Identifier
    Bundle Identifier 是 App 的标识。

  ```shell
  mdls -name kMDItemCFBundleIdentifier /Applications/Microsoft\ Word.app
  ```

  注意：在命令行中，如果文件名或者目录名中包含空格，是需要用『\』来转义的。

  命令运行之后，会返回以下的结果：

  ```shell
  kMDItemCFBundleIdentifier = "com.microsoft.Word"
  ```

  其中，com.microsoft.word 就是 Microsoft Word 的 Bundle Identifier 。

  kMDItemCFBundleIdentifier = "com.microsoft.Word"

2. 修改 Microsoft Word 的默认语言为简体中文

   ```shell
   defaults write com.microsoft.Word AppleLanguages '("zh-Hans")'
   ```

   修改完之后，是永久生效的。可以用相同的方法，修改回原来的语言。

   如果只需要让某个 App 以某种语言临时运行一次，不希望修改它的默认运行语言，可以输入命令

   ```shell
   /Applications/iCal.app/Contents/MacOS/iCal -AppleLanguages '(de)'
   ```

   或使用 Alfred Workflows

   ```shell
   Open App in English
   Open App in Chinese
   ```

- VOX 播放器语言设置成中文

用 Finder 打开应用程序文件夹, 找到 VOX, 右键显示文件包内容,  

依次打开 Contents-Resources, 找到最后一个 zh-Hant.lproj 文件夹,  

将里面的所有文件都复制覆盖到 en.lproj 文件夹, 然后再打开 VOX。



## macOS 清空字体缓存

只适用于 OSX 10.5 及以上版本。
首先退出字体册，然后退出所有可能在使用字体的应用程序（如 Word，Pages 等）；

然后在『Terminal』中输入下面的命令：

```shell
sudo atsutil databases -remove
atsutil databases -removeUser
atsutil server -shutdown
atsutil server -ping
```


## 提取 Mac 应用程序图标

方法一：使用预览工具 Preview 快速提取 App 图标
方法二：直接提取 App 图标的 icns 文件。在 App 右键 → Show Package Contents → Content → Resources


## macOS 原生截图

- 对整个屏幕截图 → 按 Command (⌘) + Shift + 3

- 对某个窗口截图

  按 Command + Shift + 4。指针会变为十字准线。
  接着按空格键。指针会变为相机指针。
  将相机指针移至某个窗口以使其高亮显示。
  点按鼠标或触控板。要取消，请按 Escape (esc) 键，然后点按。

- 修改截图的默认保存路径

  ```shell
  com.apple.screencapture location ~/Desktop/ScreenShots
  killall SystemUIServer
  ```

- 去掉或恢复截图的阴影

  去掉截图的阴影

  ```shell
  defaults write com.apple.screencapture disable-shadow -bool true
  killall SystemUIServer
  ```

  恢复截图的阴影

  ```shell
  defaults write com.apple.screencapture disable-shadow -bool false
  killall SystemUIServer
  ```

## 如何让 Finder 出现退出选项

```shel
defaults write com.apple.Finder QuitMenuItem 1
```

重启 Finder 之后才能生效
恢复原来的样子

```shell
defaults write com.apple.Finder QuitMenuItem 0
```

## 修改 hosts

```shell
sudo chmod 755 /etc/hosts
sudo vi /etc/hosts
```
建议使用 SwitchHosts


## macOS 开机音效

取消开机音效
```shell
sudo nvram SystemAudioVolume=%80
```

恢复开机音效
```shell
sudo nvram -d SystemAudioVolume
```

## 删除自带的输入法

安装 PlistEdit Pro

在终端里输入命令

```shell
sudo open ~/Library/Preferences/com.apple.HIToolbox.plist
```

选中 「Root」→「AppleEnabledInputSources」

接着会跳出名为“0、1、2、3、4、5、6” 的文件夹，逐个翻阅各个文件夹。

待找到出现 KeyBoardLayout Name 为 `ABC` 关键字样的文件夹时，删除整个以数字命名的文件。保存，关闭。

重启电脑


## Finder 更改所有文件夹显示选项

- 打开 Finder，连续点击 Command + ↑ 数次，直到界面不再跳转即可查看到磁盘的图标；

- 选择显示类型

- Command + J

- 设置显示效果

  Always open in list view
  Browse in list view
  Text size: 14
  Use as Defaults

- 打开 Terminal，输入命令

  ```shell
  sudo find / -name .DS_Store -exec rm {} +
  ```

- 重启 Finder


## macOS 定时关机、重启、睡眠

### 定期设定

System Preferences → Energy Saver → Schedule… → Shut Down  Every Day  at 22:00

### 临时设定

- 通过终端命令配置单次任务

设定 2012 年 11 月 7 日 23:15 关机

```shell
sudo shutdown -h 1211072315
```

设定 2012 年 11 月 7 日 23:15 重启

```shell
sudo shutdown -r 1211072315
```

设定 2012 年 11 月 7 日 23:15 睡眠

```shell
sudo shutdown -s 1211072315
```

命令的主体主要是 shutdown，h/r/s 分别代表关机 / 重启 / 睡眠，然后在后面加上执行时间 (yymmddhhmm) 即可。

- 通过终端取消单次定时任务

注意创建的 pid 623，这是指当前运行的这个 shutdown 命令的进程号，如果要取消关机，只需要停止这个进程的运行就可以了。命令为：

```shell
sudo kill 623
```



## 制作启动盘命令

把 U 盘抹掉，名称设置为 ABC

Format: Mac OS Extended (Journaled)

GUID

以下命令在 Terminal 中手动输入 + Tab 提示。

macOS Mojave
```shell
sudo /Applications/Install\ macOS\ Mojave.app/Contents/Resources/createinstallmedia --volume /Volumes/ABC --applicationpath /Applications/Install\ macOS\ Mojave.app --nointeraction
```

macOS Catalina Beta
```shell
sudo /Applications/Install\ macOS\ Catalina\ Beta.app/Contents/Resources/createinstallmedia --volume /Volumes/ABC
```


## 系统服务 & 用户服务

系统服务

```shell
/System/Library/Services
```

用户服务

```shell
~/Library/Services
```


## QuickLook「快速预览」 插件扩展

.qlgenerator

安装步骤：

将插件移动到 /Library/QuickLook 目录下

使用「终端」重启 QuickLook

```shell
qlmanage -r
```

插件列表：

- qlmarkdown 兼容 markdown
- QLColorCode 高亮查看代码
- QuickLookJSON 查看 JSON 文件
- QLPrettyPatch 查看 Patch 文件
- QLStephen 预览无拓展名的纯文本文件
- QuickLookCSV 预览 CSV 文件
- BetterZipQL 查看 Zip 压缩文件的信息以及文件目录
- QLlmageSize 在预览窗口的标题栏中显示图片分辨率及文件大小
- WebP 快速查看 WebP 格式图片



## QuickLook（快速查看）直接选择和复制文字

终端开启命令

```shell
defaults write com.apple.finder QLEnableTextSelection -bool TRUE;killall Finder
```

恢复命令

```shell
defaults delete com.apple.finder QLEnableTextSelection;killall Finder
```


禁止 mac 的隐藏开机启动项

```
/Library/LaunchAgents
```

## Mac 登陆 去掉 其他用户

```shell
sudo defaults write /Library/Preferences/com.apple.loginwindow SHOWOTHERUSERS_MANAGED -bool FALSE
```


## Mac 解压压缩乱码问题解决

Mac 的 zip 格式压缩，使用的字符编码是当前系统默认的 UTF-8；
Windows 系统中文版默认字符集是 GB2312。

在 macOS 系统中，推荐使用 The Archive Browser 解压，使用 BetterZip 压缩。


## 显示/隐藏文件命令

显示隐藏文件

```shell
defaults write com.apple.finder AppleShowAllFiles YES

defaults write com.apple.finder AppleShowAllFiles -bool true

```

隐藏隐藏文件

```shell
defaults write com.apple.finder AppleShowAllFiles NO

defaults write com.apple.finder AppleShowAllFiles -bool false
```


## macOS 终端走代理

启用了 shadowsocks 且本地代理为 socks5://127.0.0.1:1080

设置代理

```shell
export ALL_PROXY=socks5://127.0.0.1:1080
```

清除代理

```shell
unset ALL_PROXY
```

查看 ip 测试是否生效

```shell
curl -i https://ip.cn
```

为了方便使用，可以为上述长命名设置 alias

```shell
vi ~/.zshrc
```

添加如下配置信息

```
alias setproxy="export ALL_PROXY=socks5://127.0.0.1:1080"
alias unsetproxy="unset ALL_PROXY"
alias ip="curl -i http://ip.cn"
```

```shell
source ~/.zshrc
```

在使用终端走代理时，setproxy；

不使用终端走代理时，unsetprocy


## Mac 设置 Launchpad 的列数和行数

设置 Launchpad 的列数，对应于每一行 App 的个数

```shell
defaults write com.apple.dock springboard-columns -int 列数
```

设置 Launchpad 的行数，对应于每一列 App 的个数

```shell
defaults write com.apple.dock springboard-rows -int 行数
```

重置 Launchpad

```shell
defaults write com.apple.dock ResetLaunchPad -bool TRUE
```

重置 Dock

```shell
killall Dock
```


## Mac 一次性打开多个特定网页

打开 Automator → Application → Library → Internet → Get Specified URLs → 添加特定网页地址 → Display Webpages → Command + S → 保存为 Application


## Mac 系统预置 app 路径

```
/System/Library/CoreServices/
```

比如 /System/Library/CoreServices/Finder.app


## Mac 输入法路径

```
/Library/Input Methods/Qingg.app
```

## Mac 终端切换到 root 用户

终端命令

```shell
sudo -i
```

输入 root 用户密码


## Mac / Ubuntu / Linux 配置 sudo 免密码
终端命令
```shell
sudo -i
```

输入 root 用户密码

修改文件权限，可读写
```shell
chmod u+w /etc/sudoers
```

配置修改账户免密

```shell
sudo vim /etc/sudoers
```

输入命令 `/wheel` 找到

```
# root and users in group wheel can run anything on any machine as any user
root        ALL = (ALL) ALL
%admin      ALL = (ALL) ALL
```

修改为

```
# root and users in group wheel can run anything on any machine as any user
#root       ALL = (ALL) ALL
#%admin     ALL = (ALL) ALL
root            ALL = (ALL) NOPASSWD: NOPASSWD: ALL
%admin          ALL = (ALL) NOPASSWD: NOPASSWD: ALL
```


## 禁止 .DS_store 生成

禁止 .DS_store 生成，打开“终端”，复制黏贴下面的命令，回车执行，重启 Mac 即可生效。
```shell
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool TRUE
```
恢复 .DS_store 生成
```shell
defaults delete com.apple.desktopservices DSDontWriteNetworkStores
```
刪除已存在的.DS_Store
```shell
sudo find . -name ".DS_Store" -depth -exec rm {} \;
```

## macOS Command + Q 防止 App 误按退出

- SlowQuitApps 延缓关闭操作

- CommandQ

- QBlocker

- Karabiner

    Press Command+Q twice to Quit Application
    
    https://pqrs.org/osx/karabiner/complex_modifications/
    
    搜索 command+q
    
- Hammerspoon

    安装 double_cmdq_to_quit.lua


## 分区格式 APFS 降级为 HFS+
 1. 使用 U 盘启动，在终端中执行命令 `diskutil zeroDisk`，将分区表抹掉；
 2. 再从 U 盘重启进去再重新格式化，然后安装旧系统

## 清歌输入法 备份
```
~/Library/Application Support/Qingg
```

## zsh 运行命令慢

日志文件路径
```
/private/var/log/asl/*.asl
```
清理日志文件
```shell
sudo du -sh /private/var/log/asl/
```
```shell
sudo rm -rf /private/var/log/asl/*.asl
```

## Mac 一键退出所有 App
- 打开 Automator，创建 Application
- 点击左侧 Library → Utilities，搜索 quit，选择 Quit All Applications
- 在右侧添加不需要退出的 App，即白名单
- Command + S，保存在 /Applications，命名为「Quit All Apps」

无需退出的 App 白名单
- Application
    - Alfred
    - AppPolice
    - aText
    - Command-Tab Plus
    - Default Folder X
    - Flux
    - ForkLift
    - GhostSKB
    - Hammerspoon
    - iTerm
    - Karabiner-Elements
    - PopClip
    - ShadowsocksX-NG
    - SizeUp
    - Smooze
    - Snap
    - Snipaste
    - stretchly
    - TotalFinder
    - XtraFinder
- Setapp
    - Bartender
    - BetterTouchTool
    - Boom 3D
    - Paste
    - ToothFairy
- Utilities
    - NoSleep



## 软链接快速访问目录
做一个软链接指向某个目录：
```shell
cd ~/run
ln -s apache-tomcat-8.5.23 tomcat
```
这样就能轻易用  `~/run/tomcat` 去访问 apache-tomcat-8.5.23 了。

## 重置 SMC
先关机，然后断开电源，拔掉所有 USB 的连接，然后同时按住键盘左下角的 Shift，Control，Option 和开机键 15 秒。全过程 Mac 不会开机。15 秒后松手插上电源开机。
如何重置 Mac 上的系统管理控制器 (SMC) 
https://support.apple.com/zh-cn/HT201295

## 重置 NVRAM
将 Mac 关机，然后开机并立即同时按住以下四个按键：Option、Command、P 和 R。您可以在大约 20 秒后松开这些按键，在此期间您的 Mac 可能看似在重新启动。
重置 Mac 上的 NVRAM 或 PRAM
https://support.apple.com/zh-cn/HT204063

## macOS 启动项
```
/System/Library/StartupItems
```
```
/Users/admin/Library/LaunchAgents
```

## Dock 不活动的图标进入半透明状态
```shell
defaults write com.apple.dock showhidden -bool TRUE; killall Dock
```

## Terminal / iTerm2 Session Ended 进程已完成

### Terminal
进入系统 `Terminal` 的偏好设置，在`通用`标签栏中，勾选`命令（完整的路径）`（默认是勾选的默认登录shell），即`终端`->`偏好设置`->`通用`->`shell 的打开方式`，选择命令（完整路径)，填写 `/bin/bash` 或 `/bin/zsh`
然后重启 Terminal。

切换 shell 为 zsh
```shell
chsh -s /bin/zsh
```

### iTerm
在 iTerm Preferences，Profiles -> General -> Command，选择 Command 设置 `/bin/zsh` 或者 `/bin/bash`。

## sudo: /usr/bin/sudo must be owned by uid 0 and have the setuid bit set

Log out as the current user, then log back in as root.
Execute
```shell
chown root:sys /usr/bin/sudo && chmod 4755 /usr/bin/sudo
```
Log out as root, then log back in as the current user.

## Mac 终端提示 login：Could not determine audit condition [Process completed]
解决方案：
打开 Finder 前往文件夹 `/usr/bin/` 文件夹，删除 login 文件。

```shell
cd /usr/bin/
```
```shell
rm -rf login
```

## App Store 无法更新的问题

可以修改 dns 为 1.1.1.1 加翻墙解决

## Mac 防止误触电源键，而关闭显示器

在终端输入命令
```shell
defaults write com.apple.loginwindow PowerButtonSleepsSystem -bool no
```
现在如果点按电源按钮是没有任何反应的，只有长按才会出现。

如果想恢复原来的设置 no 改成 yes 就可以了。
```shell
defaults write com.apple.loginwindow PowerButtonSleepsSystem -bool yes
```

## Mac 重置网络配置

```shell
cd /Library/Preferences/SystemConfiguration/
```
```shell
sudo mv preferences.plist preferences.plist.bak
```
然后重启。

此方法是备份原来的配置项，系统检测不到原来的配置项，就会自动新建。

## 查看 macOS 应用是不是 64 位
按住 Option 键，点击左上角的 苹果图标，选择 System Information...
依次点击 Software → Applications；
查看 64-Bit

## Alfred 快捷切换 MacBook 外接显示器横竖屏
https://www.jianshu.com/p/16120eb43728

## 苹果电脑没声音
```shell
sudo killall coreaudiod
```
