# XMRigger

## What is this?
XMRigger is a catch-all installer and cross-compiler for [XMRig](https://github.com/xmrig/xmrig) which is a high performance, open source, cross platform RandomX, KawPow, CryptoNight and AstroBWT unified CPU/GPU miner.

## Why does this exist?
Compiling XMRig on a non-standard system quite frankly just sucks at the moment and takes time to troubleshoot. Fiddling with compile settings across my small library of SBCs and other assorted systems was a pain in the butt. I figured if I had to do it once, I might as well share this with the community so that it need not be repeated. [[ time == $CURRENCY ]]

## What does this mean for me? 
Specifically if you have a non-standard system like any of the myriad of core-rich SBCs available in the budding SBC market, you'll now be able to pull, configure, compile and run your very own XMRig miner with no stress or hassle because I've done the nitty-gritty for you. SBCs for the most part are low-yield miners, but also cost very little to run - in some cases it can make sense to enslave an idle SBC to print XMR.

## Couldn't I just compile XMRig on my own?
Absolutely and I encourage you to do so if you're able to! XMRigger is mainly aimed at systems which aren't standard and have significant issues during compilation, but also supports more common systems and configs.

## What systems can I run this on?
Currently officially supported OS and architecture combinations are as marked below:
1. Linux
   * Alpine - x86, x64, arm7, arm8
   * Archlinux - x86, x64, arm7, arm8
   * CentOS7 - x86, x64, arm7, arm8
   * CentOS8 - x86, x64, arm7, arm8
   * Fedora - x86, x64, arm7, arm8
   * FreeBSD - x86, x64, arm7, arm8
   * Manjaro - x86, x64, arm7, arm8
   * Ubuntu - x86, x64, arm7, arm8
2. MacOS:
   * MacOS Mojave - x86, x64, arm7, arm8
   * MacOS Catalina - x86, x64, arm7, arm8
3. Windows:
   * Win10 - x86, x64
      * install can be handled either through VS2019 or MSYS2 - arm support not yet planned
4. Android:
   * TBA - Hold tight, this feature is coming

## How do I generate a config file?
I would recommend [this utility](https://xmrig.com/wizard) offered by xmrig.com - It's pretty easy breezy, there's no real need for me to reinvent the wheel here.

## How do I run XMRigger?
Launching the utility can be done in shorthand like below:
```
git clone https://github.com/AlexanderIreland/xmrigger
cd xmrigger && chmod +x xmrigger && ./xmrigger -a arm -o ubuntu -s /swap -S 3
```

Flag mapping:
  - a: declares CPU architecture - Currently supporting arm, x86, x64 and x96
    - For any other RISC architecture, default to arm - this includes variants of arm and arm BIG.little
  - c: declares C compiler to be used
  - cxx: declares CXX compiler to be used
  - o: declares OS - Currently manual but auto-detect is coming
  - pb: triggers a post-build action - basic xmrig start
  - ps: triggers a post-build action - silent xmrig start - starts xmrig in a detatched screen, screen -ls to show the screen
  - s: declares the swap file dir
  - S: declares the swap file size in G, only digits required
  - v: forces cmake to output verbose logging to stdout

## What compilers can I use?
Currently supported compilers are: 
|| clang ![#f1c40f](https://via.placeholder.com/15/f1c40f/000000?text=+) | edg/rose ![#1abc9c](https://via.placeholder.com/15/1abc9c/000000?text=+) | gcc ![#f1c40f](https://via.placeholder.com/15/f1c40f/000000?text=+) | iar ![#f1c40f](https://via.placeholder.com/15/f1c40f/000000?text=+) | oracle c ![#f1c40f](https://via.placeholder.com/15/f1c40f/000000?text=+) | visual c++ ![#f1c40f](https://via.placeholder.com/15/f1c40f/000000?text=+) |
|---|:-:|:-:|:-:|:-:|:-:|:-:|
|Android|✓|✓|✓|✘|✓|✘|
|MacOS|✓|✘|✓|✘|✘|✘|
|Linux|✓|✓|✓|✘|✓|✘|
|Windows|✓|✓|✓|✓|✓|✓|

key: ![#1abc9c](https://via.placeholder.com/15/1abc9c/000000?text=+) = full cnn compliance ![#f1c40f](https://via.placeholder.com/15/f1c40f/000000?text=+) = partial cnn compliance
