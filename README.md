# linux-fixes

**only works on X11** :bangbang:

The scripts solves two problems:

1. slow scroll on chromium based applications
2. CAps LOck DElay

most of the code is written by me, but some part of the code is not mine. The code for configure imwheel with slider and zenity is not mine, I pick the code from some script on the internet long time ago and I lost the repo.

The code for CAps LOck DElay I get from this repo:
https://github.com/HexValid/Linux-CapsLock-Delay-Fixer

## Usage

clone the repo

```
$ ./install.sh -d debian
```

-d stands for distribution currently you can use

- debian
- arch
- fedora

-f stands for fix and accepts one value

- 1 the number one will install and configure imwheel for slow scroll
- 2 will fix only CApsLOckDElay

if you want to fix both problems then just use ./install.sh -d {and your pacmage mananger}

-u stands for uninstall, in case you want to uninstall all the cnfigureation and binaries.

and also you can use any distribution that is based on already mentions base distributions.
For example, if you using pop-os, ubuntu, kubuntu or zorin-os you will chose debian, you get the point.

## What exactly script doing?

Imwheel:
The script will install the imwheel program for you if it is not already installed. After installing the program, a popup will appear to select the desired scroll speed. After choosing the desired speed, a file used for imwheel configuration will be created ~/.imwheelrc (do not delete this file). After creating the configuration file, a file named imwheel.desktop will be created in the path ~/.config/autostart/
the file serves to start the imwheel program at the very beginning of logging into the session.

CAps LOck DElay:
On the ~/ path, a folder called scripts will be created, in it there will be a .sh file that will be started at the very beginning of entering the session, as well as imwheel. A file will also be created in the path ~/.config/autostart/CapsLockDelayFixer.desktop which will be used to start the script from the scripts folder.

## Motivation

Whenever I installed linux or moved to a new distribution, I always had a problem with scrolling and caps lock delay, I wrote a script for this reason to solve the mentioned problem.
