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

||x86|x64|arm7|arm8|
|:-:|:-:|:-:|:-:|:-:|
|Android|TBA|TBA|TBA|TBA|
|Alpine|✓|✓|✓|✓|
|Archlinux|✓|✓|✓|✓|
|CentOS7|✓|✓|✓|✓|
|CentOS8|✓|✓|✓|✓|
|Fedora|✓|✓|✓|✓|
|FreeBSD|✓|✓|✓|✓|
|Manjaro|✓|✓|✓|✓|
|Ubuntu|✓|✓|✓|✓|
|MacOS|✓|✓|✓|✓|
|Windows|✓|✓|✘|✘|

## How do I generate a config file?
I would recommend [this utility](https://xmrig.com/wizard) offered by xmrig.com - It's pretty easy breezy, there's no real need for me to reinvent the wheel here.

## How do I run XMRigger?
Launching the utility can be done in shorthand like below:
```
git clone https://github.com/AlexanderIreland/xmrigger
cd xmrigger && chmod +x xmrigger && ./xmrigger -a arm -o ubuntu -s /swap -S 3 -conf /opt/xmrig/build/config.json
```

Flag mapping:
  - a: declares CPU architecture - Currently supporting arm, x86, x64 and x96
    - For any other RISC architecture, default to arm - this includes variants of arm and arm BIG.little
  - c: declares C compiler to be used
  - conf: declares the config.json file to be used
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
|Android|✓|✘|✓|✘|✓|✘|
|MacOS|✓|✘|✓|✘|✘|✘|
|Linux|✓|✓|✓|✘|✓|✘|
|Windows|✓|✘|✓|✓|✓|✓|

key: ![#1abc9c](https://via.placeholder.com/15/1abc9c/000000?text=+) = full cnn compliance ![#f1c40f](https://via.placeholder.com/15/f1c40f/000000?text=+) = partial cnn compliance

## What features are planned for the future?
Roadmap:
- generate service on completion
- complete compiler install options

Done
- Do away with wallet file, move to complete config generator - use sed to insert values where necessary~~
- Gather prerequisites based on OS
  - 3.a) Centos7: epel-release git make cmake gcc gcc-c++ libstdc++-static libuv-static hwloc-devel openssl-devel
  - 3.b) Centos8: git make cmake gcc gcc-c++ libstdc++-static hwloc-devel openssl-devel automake libtool autoconf
  - 3.c) Alpine: git make cmake libstdc++ gcc g++ libuv-dev openssl-dev hwloc-dev
  - 3.d) Fedora: git make cmake gcc gcc-c++ libstdc++-static libuv-static hwloc-devel openssl-devel
  - 3.e) FreeBSD: git cmake libuv openssl hwloc
  - 3.f) MacOS: cmake libuv openssl hwloc
  - 3.g) Ubuntu: git build-essential cmake libuv1-dev libssl-dev libhwloc-dev
  - 3.h) Windows: mingw-w64-x86_64-gcc git make
- 4) Pull latest: https://github.com/xmrig/xmrig.git
- 5) Create build dir
- 6) Configure cmake opts
  - 6.a) CPU arch support
    - 6.a.1) arm64: -DCMAKE_SYSTEM_PROCESSOR=arm
  - 6.b) Platform support
    - 6.b.1) L/Unix: -DCMAKE_SYSTEM_NAME=Linux
    - 6.b.2) MacOS: -DOPENSSL_ROOT_DIR=/usr/local/opt/openssl
      - 6.b.2.a: 32-bit binary out: -DCMAKE_OSX_ARCHITECTURES=i386
      - 6.b.2.b: 64-bit binary out: -DCMAKE_OSX_ARCHITECTURES=x86_64
      - 6.b.2.c: 96-bit universal binary out: "-DCMAKE_OSX_ARCHITECTURES=x86_64;i386"
    - 6.b.3) Windows:
      - 6.b.3.a) MSYS2: "c:\Program Files\CMake\bin\cmake.exe" .. -G "Unix Makefiles" -DXMRIG_DEPS=c:/xmrig-deps/gcc/x64
      - 6.b.3.b) VS19: cmake .. -G "Visual Studio 16 2019" -A x64 -DXMRIG_DEPS=c:\xmrig-deps\msvc2019\x64
      - cmake --build . --config Release
      - 6.b.3.c) VS19 + CUDA: cmake .. -G "Visual Studio 16 2019" -A x64 -DCUDA_TOOLKIT_ROOT_DIR="c:/Program Files/NVIDIA GPU Computing toolkit/CUDA/v11.0"
      - cmake --build . --config Release
    - 6.b.4) WindowsPhone: -DCMAKE_SYSTEM_NAME=WindowsPhone -DCMAKE_SYSTEM_VERSION=8.1
    - 6.b.5) Tegra/Android: -DCMAKE_SYSTEM_NAME=Android
- 7) Configure make opts 
  - 7.a) Alpine, Centos, Fedora, Ubuntu, Windows: make -j$(nproc)
  - 7.b) FreeBSD: make -j$(sysctl -n hw.ncpu)
  - 7.c) MacOS: make -j$(sysctl -n hw.logicalcpu)
- 8) Configure page files for low-mem systems
- 9) Configure compilers - initial pre-revision list
  - 9.a) C compilers
    - 9.a.1) Full Cnn compliance compilers
      - 9.a.1.a) EDG - Win, Unix, Android, RISC
      - 9.a.1.b) IAR - Windows only
    - 9.a.2) Partial Cnn compliance compilers
      - 9.a.2.a) Clang - Win, Unix, Android, RISC - Full compliance with c89, c99, partial with c11, c18
      - 9.a.2.b) GCC - Partial/Most Win, Unix, AmigaOS, VAX/VMS, RTEMS, DOS - Full compliance with c89, partial with c99, c11 and c18
      - 9.a.2.c) Oracle C - Win, Unix, Android, RISC - compliant with c89, c99, c11
  - 9.b) Cxx compilers
    - 9.b.1) Full C++nn compliance compilers
      - 9.b.1.a) Clang - Partial/Most Win, Unix, Android, RISC
      - 9.b.1.b) EDG - Win, Unix, Android, RISC
      - 9.b.1.c) Visual C++ - Win, Unix-Like, Android
- 10) Noting that some arm systems have issues with caching on certain versions of GCC - known-good version is gcc-8.3.0
- 11) Create independent arm7 and arm8 build options, both need independent cmake opts
