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
#  3a) Centos7: epel-release git make cmake gcc gcc-c++ libstdc++-static libuv-static hwloc-devel openssl-devel
#  3b) Centos8: git make cmake gcc gcc-c++ libstdc++-static hwloc-devel openssl-devel automake libtool autoconf
#  3c) 
# 4) Pull latest: https://github.com/xmrig/xmrig.git
# 5) Create build dir
# 6) Configure cmake opts
# 7) Configure make opts (make -j$(nproc) default)
