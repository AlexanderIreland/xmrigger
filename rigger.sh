#!/bin/bash
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
#    6.b.2.a: 32-bit binary out: -DCMAKE_OSX_ARCHITECTURES=i386
#    6.b.2.b: 64-bit binary out: -DCMAKE_OSX_ARCHITECTURES=x86_64
#    6.b.2.c: 96-bit universal binary out: "-DCMAKE_OSX_ARCHITECTURES=x86_64;i386"
#   6.b.3) Windows:
#    6.b.3.a) MSYS2: "c:\Program Files\CMake\bin\cmake.exe" .. -G "Unix Makefiles" -DXMRIG_DEPS=c:/xmrig-deps/gcc/x64
#    6.b.3.b) VS19: cmake .. -G "Visual Studio 16 2019" -A x64 -DXMRIG_DEPS=c:\xmrig-deps\msvc2019\x64
#     cmake --build . --config Release
#    6.b.3.c) VS19 + CUDA: cmake .. -G "Visual Studio 16 2019" -A x64 -DCUDA_TOOLKIT_ROOT_DIR="c:/Program Files/NVIDIA GPU Computing Toolkit/CUDA/v11.0"
#     cmake --build . --config Release
#   6.b.4) WindowsPhone: -DCMAKE_SYSTEM_NAME=WindowsPhone -DCMAKE_SYSTEM_VERSION=8.1
#   6.b.5) Tegra/Android: -DCMAKE_SYSTEM_NAME=Android
# 7) Configure make opts 
#  7.a) Alpine, Centos, Fedora, Ubuntu, Windows: make -j$(nproc)
#  7.b) FreeBSD: make -j$(sysctl -n hw.ncpu)
#  7.c) MacOS: make -j$(sysctl -n hw.logicalcpu)
# 8) Configure page files for low-mem systems

# Load vars
CMAKE_ARGS=""
CUDA_TOOLKIT_DIR="c:/Program Files/NVIDIA GPU Computing Toolkit/CUDA/v11.0" #default - bless fwdslash
MAKE_CORE_COUNT=1
MSVS2019_GCC_64_DIR="c:\xmrig-deps\msvc2019\x64" #default, may req escapes
MSVS2019_XMRIGDEPS_DIR="c:\xmrig-deps\msvc2019\x64" #default, may req escapes
MSYS_CMAKE_DIR="c:\Program Files\CMake\bin\cmake.exe" #default, may req escapes
MSYS_GCC_64_DIR="c:/xmrig-deps/gcc/x64" #default
OSX_OPENSSL_DIR="/usr/local/opt/openssl"
SELECTED_COMPILE_OS=""
SWAP_FILE_DIR_LINUX_GENERIC="/paging-xmrigger"

# We need colours, colors if you desire freedom
RESTORE=$(echo -en '\033[0m')
RED=$(echo -en '\033[00;31m')
GREEN=$(echo -en '\033[00;32m')
YELLOW=$(echo -en '\033[00;33m')
BLUE=$(echo -en '\033[00;34m')
MAGENTA=$(echo -en '\033[00;35m')
PURPLE=$(echo -en '\033[00;35m')
CYAN=$(echo -en '\033[00;36m')
LIGHTGRAY=$(echo -en '\033[00;37m')
LRED=$(echo -en '\033[01;31m')
LGREEN=$(echo -en '\033[01;32m')
LYELLOW=$(echo -en '\033[01;33m')
LBLUE=$(echo -en '\033[01;34m')
LMAGENTA=$(echo -en '\033[01;35m')
LPURPLE=$(echo -en '\033[01;35m')
LCYAN=$(echo -en '\033[01;36m')
WHITE=$(echo -en '\033[01;37m')

function intro-text () {
  echo "${PURPLE} ██╗  ██╗███╗   ███╗██████╗ ██╗ ██████╗  ██████╗ ███████╗██████╗ ${RESTORE}"
  echo "${PURPLE} ╚██╗██╔╝████╗ ████║██╔══██╗██║██╔════╝ ██╔════╝ ██╔════╝██╔══██╗${RESTORE}"
  echo "${PURPLE}  ╚███╔╝ ██╔████╔██║██████╔╝██║██║  ███╗██║  ███╗█████╗  ██████╔╝${RESTORE}"
  echo "${PURPLE}  ██╔██╗ ██║╚██╔╝██║██╔══██╗██║██║   ██║██║   ██║██╔══╝  ██╔══██╗${RESTORE}"
  echo "${PURPLE} ██╔╝ ██╗██║ ╚═╝ ██║██║  ██║██║╚██████╔╝╚██████╔╝███████╗██║  ██║${RESTORE}"
  echo "${PURPLE} ╚═╝  ╚═╝╚═╝     ╚═╝╚═╝  ╚═╝╚═╝ ╚═════╝  ╚═════╝ ╚══════╝╚═╝  ╚═╝${RESTORE}"
  echo "${CYAN}+---------------------------------------------------------------+"
}

# main stub test
function ubuntu-arm-stub () {
  xmr-clone-repo-clean
  xmrigger-packages-ubuntu
  #config-cmake-ubuntu
  config-cmake-arm
  execute-cmake-generic
  execute-make-generic 
}

# Configure swap file for low-mem Linux systems
function swapfile-linux-gen () {
  # 3G default, generally not more than 2 is needed
  sudo fallocate -l 3G $SWAP_FILE_DIR_LINUX_GENERIC
  sudo chmod 600 $SWAP_FILE_DIR_LINUX_GENERIC
  sudo mkswap $SWAP_FILE_DIR_LINUX_GENERIC
  sudo swapon $SWAP_FILE_DIR_LINUX_GENERIC
}

# Pull pre-requisite packages for Alpine
function xmrigger-packages-alpine () {
  sudo apk add git make cmake libstdc++ gcc g++ libuv-dev openssl-dev hwloc-dev
}
# Pull pre-requisite packages for Centos7
function xmrigger-packages-centos7 () {
  sudo yum install -y epel-release
  sudo yum install -y git make cmake gcc gcc-c++ libstdc++-static libuv-static hwloc-devel openssl-devel
}
# Pull pre-requisite packages for Centos8
function xmrigger-packages-centos8 () {
  sudo dnf install -y epel-release
  sudo yum config-manager --set-enabled PowerTools
  sudo dnf install -y git make cmake gcc gcc-c++ libstdc++-static hwloc-devel openssl-devel automake libtool autoconf
}
# Pull pre-requisite packages for Fedora
function xmrigger-packages-fedora () {
  sudo dnf install -y git make cmake gcc gcc-c++ libstdc++-static libuv-static hwloc-devel openssl-devel
}
# Pull pre-requisite packages for FreeBSD
function xmrigger-packages-freebsd () {
  pkg install git cmake libuv openssl hwloc
}
# Pull pre-requisite packages for MacOS
function xmrigger-packages-macos () {
  brew install cmake libuv openssl hwloc
}
# Pull pre-requisite packages for Ubuntu
function xmrigger-packages-ubuntu () { 
  sudo apt-get install -y git build-essential cmake libuv1-dev libssl-dev libhwloc-dev 
}
# Pull pre-requisite packages for Windows using msys2 - VS19 installs skip this step
function xmrigger-packages-windows-msys2 () {
  pacman -S mingw-w64-x86_64-gcc git make
}

# Clone XMRig repo - Linux generic - clean dir
function xmr-clone-repo-clean () { 
  cd /opt/
  rm -rf /opt/xmrig/
  git clone https://github.com/xmrig/xmrig.git
  mkdir xmrig/build && cd xmrig/build
}
# Clone XMRig repo - Linux generic - no clean
function xmr-clone-repo () { 
  cd /opt/ && git clone https://github.com/xmrig/xmrig 
}

# Injecting os-specific arguments for cmake
function config-cmake-alpine () { 
  CMAKE_ARGS=$CMAKE_ARGS' -DCMAKE_SYSTEM_NAME=Linux' 
}
function config-cmake-centos7 () { 
  CMAKE_ARGS=$CMAKE_ARGS' -DCMAKE_SYSTEM_NAME=Linux' 
}
function config-cmake-centos8 () { 
  CMAKE_ARGS=$CMAKE_ARGS' -DCMAKE_SYSTEM_NAME=Linux' 
}
function config-cmake-fedora () { 
  CMAKE_ARGS=$CMAKE_ARGS' -DCMAKE_SYSTEM_NAME=Linux' 
}
function config-cmake-freebsd () { 
  CMAKE_ARGS=$CMAKE_ARGS' -DCMAKE_SYSTEM_NAME=Linux' 
}
function config-cmake-macos () { 
  CMAKE_ARGS=$CMAKE_ARGS"-DOPENSSL_ROOT_DIR=OSX_OPENSSL_DIR" 
}
function config-cmake-ubuntu () { 
  # Below looks to cause issues if invoked by default on an arm-variant CPU arch
  # CMAKE_ARGS=$CMAKE_ARGS' -DCMAKE_SYSTEM_NAME=Linux' 
  echo "Bash hates empty functions - holding the fort until this works again"
}
function config-cmake-windows-msys2 () { 
  CMAKE_ARGS=$CMAKE_ARGS"-G Visual Studio 16 2019 -A x64 -DXMRIG_DEPS='$MSYS_GCC_64_DIR'" 
}
function config-cmake-windows-vs2019 () { 
  CMAKE_ARGS=$CMAKE_ARGS' -G "Visual Studio 16 2019" -A x64 -DXMRIG_DEPS="$MSVS2019_XMRIGDEPS_DIR"' 
}
function config-cmake-windows-vs2019-cuda-support () { 
  CMAKE_ARGS=$CMAKE_ARGS' -G "Visual Studio 16 2019" -A x64 -DCUDA_TOOLKIT_ROOT_DIR="$CUDA_TOOLKIT_DIR"' 
}

# Injecting cpu-arch arguments for cmake
function config-cmake-arm () { 
  CMAKE_ARGS=$CMAKE_ARGS' -DCMAKE_SYSTEM_PROCESSOR=arm' 
}

# Will produce a 32-bit binary out for OSX
function config-cmake-osx-i386 () { 
  CMAKE_ARGS=$CMAKE_ARGS' -DCMAKE_OSX_ARCHITECTURES=i386' 
}

# Will produce a 64-bit binary out for OSX
function config-cmake-osx-64 () { 
  CMAKE_ARGS=$CMAKE_ARGS' -DCMAKE_OSX_ARCHITECTURES=x86_64' 
}

# Will produce a 96-bit universal binary out for OSX
function config-cmake-osx-86 () { 
  CMAKE_ARGS=$CMAKE_ARGS' -DCMAKE_OSX_ARCHITECTURES=x86_64;i386' 
}

# Execute cmake and pray
function execute-cmake-generic () { 
  #something broke here, breakpoint
  echo "cmake .. $CMAKE_ARGS"
  cmake .. $CMAKE_ARGS 
}

# Execute cmake for VS2019
function execute-cmake-vs2019 () { 
  cmake --build . --config Release 
}

# Execute make with generic nproc arg - for Alpine, Arch, Centos7, Centos8, Debian, Fedora, Manjaro, Ubuntu Windows /w MSYS2
function execute-make-generic () {
  MAKE_CORE_COUNT=$(nproc)
  make -j$MAKE_CORE_COUNT
}

# Execute make with make with generic sysctl -n hw.ncpu - for FreeBSD
function execute-make-hw-ncpu-variants () {
  MAKE_CORE_COUNT=$(sysctl -n hw.ncpu)
  make -j$MAKE_CORE_COUNT
}

# Execute make with make with generic sysctl -n hw.logicalcpu - for MacOS
function execute-make-hw-logical-cpu-variants () {
  MAKE_CORE_COUNT=$(sysctl -n hw.logicalcpu)
  make -j$MAKE_CORE_COUNT
}

# Menu function to select OS
function pick-compile-os () {
  PS3="Enter the number that corresponds to your OS: "
  select os in Alpine Centos7 Centos8 Fedora FreeBSD MacOS Ubuntu Windows-MSYS2 Windows-VS2019
  do
      echo "${PURPLE}Target OS: ${GREEN}$os${RESTORE}"
      SELECTED_COMPILE_OS=$os
  done
}

function main () {
  intro-text
  pick-compile-os
  ubuntu-arm-stub
}

main
