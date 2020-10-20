#!/bin/bash
echo "#██████╗ ██████╗ ███████╗    ██████╗ ██╗ ██████╗ "
echo "#██╔══██╗██╔══██╗██╔════╝    ██╔══██╗██║██╔════╝ "
echo "#██████╔╝██████╔╝█████╗█████╗██████╔╝██║██║  ███╗"
echo "#██╔═══╝ ██╔══██╗██╔══╝╚════╝██╔══██╗██║██║   ██║"
echo "#██║     ██║  ██║███████╗    ██║  ██║██║╚██████╔╝"
echo "#╚═╝     ╚═╝  ╚═╝╚══════╝    ╚═╝  ╚═╝╚═╝ ╚═════╝ "
echo "# - - - - - - - - - - - - - - - - - - - - - - - -"
#todo:
# 1) Acquire wallet address
# 2) Ask config options
# 3) Gather prerequisites based on OS
#  3.a) Centos7: epel-release git make cmake gcc gcc-c++ libstdc++-static libuv-static hwloc-devel openssl-devel
#  3.b) Centos8: git make cmake gcc gcc-c++ libstdc++-static hwloc-devel openssl-devel automake libtool autoconf
#  3.c) Alpine: git make cmake libstdc++ gcc g++ libuv-dev openssl-dev hwloc-dev
#  3.d) Fedora: git make cmake gcc gcc-c++ libstdc++-static libuv-static hwloc-devel openssl-devel
#  3.e) FreeBSD: git cmake libuv openssl hwloc
#  3.f) MacOS: cmake libuv openssl hwloc
#  3.g) Ubuntu: git build-essential cmake libuv1-dev libssl-dev libhwloc-dev
#  3.h) Windows: mingw-w64-x86_64-gcc git make
# 4) Pull latest: https://github.com/xmrig/xmrig.git
# 5) Create build dir
# 6) Configure cmake opts
#  6.a) CPU arch support
#   6.a.1) arm64: -DCMAKE_SYSTEM_PROCESSOR=arm
#  6.b) Platform support
#   6.b.1) L/Unix: -DCMAKE_SYSTEM_NAME=Linux
#   6.b.2) MacOS: -DOPENSSL_ROOT_DIR=/usr/local/opt/openssl
#   6.b.3) Windows: -G "Unix Makefiles" -DXMRIG_DEPS=c:/xmrig-deps/gcc/x64
#   6.b.4) WindowsPhone: -DCMAKE_SYSTEM_NAME=WindowsPhone -DCMAKE_SYSTEM_VERSION=8.1
#   6.b.5) Tegra/Android: -DCMAKE_SYSTEM_NAME=Android
# 7) Configure make opts 
#  7.a) Alpine, Centos, Fedora, Ubuntu, Windows: make -j$(nproc)
#  7.b) FreeBSD: make -j$(sysctl -n hw.ncpu)
#  7.c) MacOS: make -j$(sysctl -n hw.logicalcpu)
