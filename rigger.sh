#!/bin/bash
#todo:
# 1) Do away with wallet file, move to complete config generator - use sed to insert values where necessary
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
# 9) Configure compilers - initial pre-revision list
#  9.a) C compilers
#   9.a.1) Full Cnn compliance compilers
#    9.a.1.a) EDG - Win, Unix, Android, RISC
#    9.a.1.b) IAR - Windows only
#   9.a.2) Partial Cnn compliance compilers
#    9.a.2.a) Clang - Win, Unix, Android, RISC - Full compliance with c89, c99, partial with c11, c18
#    9.a.2.b) GCC - Partial/Most Win, Unix, AmigaOS, VAX/VMS, RTEMS, DOS - Full compliance with c89, partial with c99, c11 and c18
#    9.a.2.c) Oracle C - Win, Unix, Android, RISC - compliant with c89, c99, c11
#  9.b) Cxx compilers
#   9.b.1) Full C++nn compliance compilers
#    9.b.1.a) Clang - Partial/Most Win, Unix, Android, RISC
#    9.b.1.b) EDG - Win, Unix, Android, RISC
#    9.b.1.c) Visual C++ - Win, Unix-Like, Android
#  10) Noting that some arm systems have issues with caching on certain versions of GCC - known-good version is gcc-8.3.0
#  11) Create independent arm7 and arm8 build options, both need independent cmake opts

# Load vars
CMAKE_ARGS=""
C_COMPILER="gcc" #gcc is the default and usually fine
CUDA_TOOLKIT_DIR="c:/Program Files/NVIDIA GPU Computing Toolkit/CUDA/v11.0" #default - bless fwdslash
CXX_COMPILER="gcc" #gcc is the default and usually fine
MAKE_CORE_COUNT=1
MSVS2019_GCC_64_DIR="c:\xmrig-deps\msvc2019\x64" #default, may req escapes
MSVS2019_XMRIGDEPS_DIR="c:\xmrig-deps\msvc2019\x64" #default, may req escapes
MSYS_CMAKE_DIR="c:\Program Files\CMake\bin\cmake.exe" #default, may req escapes
MSYS_GCC_64_DIR="c:/xmrig-deps/gcc/x64" #default
OSX_OPENSSL_DIR="/usr/local/opt/openssl"
PACKAGE_MANAGER=""
SELECTED_COMPILE_ARCH=""
SELECTED_COMPILE_OS=""
SWAP_FILE_DIR_LINUX_GENERIC="/paging-xmrigger"
SWAP_FILE_SIZE="3G"
XMRIG_DIR="/opt"

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
  echo ""
  echo "${CYAN}+---------------------------------------------------------------+"
  echo "${PURPLE} ██╗  ██╗███╗   ███╗██████╗ ██╗ ██████╗  ██████╗ ███████╗██████╗ ${RESTORE}"
  echo "${PURPLE} ╚██╗██╔╝████╗ ████║██╔══██╗██║██╔════╝ ██╔════╝ ██╔════╝██╔══██╗${RESTORE}"
  echo "${PURPLE}  ╚███╔╝ ██╔████╔██║██████╔╝██║██║  ███╗██║  ███╗█████╗  ██████╔╝${RESTORE}"
  echo "${PURPLE}  ██╔██╗ ██║╚██╔╝██║██╔══██╗██║██║   ██║██║   ██║██╔══╝  ██╔══██╗${RESTORE}"
  echo "${PURPLE} ██╔╝ ██╗██║ ╚═╝ ██║██║  ██║██║╚██████╔╝╚██████╔╝███████╗██║  ██║${RESTORE}"
  echo "${PURPLE} ╚═╝  ╚═╝╚═╝     ╚═╝╚═╝  ╚═╝╚═╝ ╚═════╝  ╚═════╝ ╚══════╝╚═╝  ╚═╝${RESTORE}"
  echo "${CYAN}+---------------------------------------------------------------+"
  echo ""
}

function help-text () {
  echo ""
  echo "${CYAN}+------------------------------------------------------------+"
  echo "${CYAN}See below for the full list of flags available and their usage - all flag arguments are lowercase"
  echo "${LGREEN}-a ${LGREEN}-${LCYAN} Defines the CPU architecture, options available are:{$MAGENTA} arm7, arm8, x86, x64${RESTORE}"
  echo "${LGREEN}-o ${LGREEN}-${LCYAN} Defines the OS, options available are:{$MAGENTA}  alpine, arch, centos7, centos8, fedora, freebsd, manjaro, ubuntu, macos, win10-msys2 and win10-vs2019${RESTORE}"
  echo "${LGREEN}-s ${LGREEN}-${LCYAN} Defines the swap file directory if required - this is recommended for systems with <2G of memory as compiling usually will occupy more than 2G even without loading a desktop environment${RESTORE}"
  echo "${LGREEN}-S ${LGREEN}-${LCYAN} Sets the size of the swap file, only accepts ints (whole numbers, no decimal places){RESTORE}"
  echo "${CYAN}+---------------------------------------------------------------+"
  echo ""
}

#######################
# launch flag support #
#######################

while getopts a:o:s:S:v: flag
do
    case "${flag}" in
        a) SELECTED_COMPILE_ARCH=${OPTARG};;
        o) SELECTED_COMPILE_OS=${OPTARG};;
        s) SWAP_FILE_DIR_LINUX_GENERIC=${OPTARG};;
        S) SWAP_FILE_SIZE="${OPTARG}G";;
        v) CMAKE_ARGS="$CMAKE_ARGS -v";; # verbose cmake for troubleshooting
    esac
done

######################################################################################################
# Main function that can handle build with flags - currently only requires -o for OS and -a for arch #
######################################################################################################

function main-compile-funct-template () {
  # Providing an alternative shorthand to menu navigation
  xmr-clone-repo-clean
  xmrigger-packages-$SELECTED_COMPILE_OS
  config-cmake-$SELECTED_COMPILE_ARCH
}

#################################################
# Configure swap file for low-mem Linux systems #
#################################################

function swapfile-generic () {
  # 3G default, generally not more than 2 is needed
  # typically 4G total memory is recommended for compilation to be successful
  # bear in mind that using swap is also a tad slower, compile time will suffer as a result if you have to dip into swap
  echo ""
  echo "${CYAN}+---------------------------------------------------------------+"
  echo "${LGREEN}# If you've set either the -s or -S flags a swapfile will now be created${RESTORE}"
  echo "${LGREEN}# If one of these flags is set but not the other, the default value will be used for the unset flag${RESTORE}"
  echo "${CYAN}+---------------------------------------------------------------+"
  echo "${LGREEN}# The defaults are 3G swap size, and the swap file location is /paging-xmrigger${RESTORE}"
  echo "${MAGENTA}# If these settings work for you, keep on truckin'${RESTORE}"
  echo "${CYAN}+---------------------------------------------------------------+"
  echo ""
  sudo fallocate -l 3G $SWAP_FILE_DIR_LINUX_GENERIC
  sudo chmod 600 $SWAP_FILE_DIR_LINUX_GENERIC
  sudo mkswap $SWAP_FILE_DIR_LINUX_GENERIC
  sudo swapon $SWAP_FILE_DIR_LINUX_GENERIC
  echo "${CYAN}+---------------------------------------------------------------+"
  echo ""
}

###############################
# Pre-requisite installations #
###############################

# Pull pre-requisite packages for Alpine
function xmrigger-packages-alpine () {
  sudo apk add git make cmake libstdc++ gcc g++ libuv-dev openssl-dev hwloc-dev
}
# ARM systems generally do not require hwloc - doesn't harm to include, however
function xmrigger-packages-alpine-arm7 () {
  sudo apk add git make cmake libstdc++ gcc g++ libuv-dev openssl-dev hwloc-dev
}
# ARM systems generally do not require hwloc - doesn't harm to include, however
function xmrigger-packages-alpine-arm8 () {
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

#####################
# compiler installs #
#####################

function edg-install-ubuntu {
  sudo apt-get install software-properties-common
  sudo add-apt-repository ppa:rosecompiler/rose-development # Replace rose-development with rose-stable for release version
  sudo apt-get install rose
  #sudo apt-get install rose-tools # Optional: Installs ROSE tools in addition to ROSE Core
}

### Centos7 rose/edg
#[rose-develop]
#name = rose-rpm-repo
#baseurl = http://rosecompiler.org/uploads/repos/rhel/7/develop
#gpgcheck = 0
#enabled = 1
#
#[rose-dependencies]
#name = rose-dependencies-rpm-repo
#baseurl = http://rosecompiler.org/uploads/repos/rhel/7/dependencies
#gpgcheck = 0
#enabled = 1
#
### Centos8 rose/edg
#[rose-develop]
#name = rose-rpm-repo
#baseurl = http://rosecompiler.org/uploads/repos/rhel/7/develop
#gpgcheck = 0
#enabled = 1
#
# sudo yum install rose
#
### Optional rose test build:
#git clone https://github.com/LLNL/backstroke.git
#cd backstroke
#make
#sudo make install
#make check

# Clang for Ubuntu
# 12.04 - clang
# 14.04 - clang: 3.3, 3.4, 3.5
# 16.04 - clang: 3.5, 3.6, 3.7, 3.8
# 17.04 - clang: 6.0
# 18.04 - clang: 6.0

# GCC for Ubuntu
# 18.04 - gcc-6, gcc-7, gcc-9

####################
# Clone XMRig repo #
####################

# Clone XMRig repo - Linux generic - clean dir
function xmr-clone-repo-clean () { 
  cd $XMRIG_DIR
  rm -rf $XMRIG_DIR/xmrig/ # nukes any broken/existing installations
  git clone https://github.com/xmrig/xmrig.git
  mkdir xmrig/build && cd xmrig/build
}

# Clone XMRig repo - Linux generic - no clean
function xmr-clone-repo () { 
  cd $XMRIG_DIR && git clone https://github.com/xmrig/xmrig 
}

###########################
# OS-specific cmake flags #
###########################

# Injecting os-specific flags for cmake
function config-cmake-alpine () { 
  CMAKE_ARGS=$CMAKE_ARGS
}
function config-cmake-centos7 () { 
  CMAKE_ARGS=$CMAKE_ARGS
}
function config-cmake-centos8 () { 
  CMAKE_ARGS=$CMAKE_ARGS
}
function config-cmake-fedora () { 
  CMAKE_ARGS=$CMAKE_ARGS
}
function config-cmake-freebsd () { 
  CMAKE_ARGS=$CMAKE_ARGS
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

#############################
# Arch-specific cmake flags #
#############################

# Injecting cpu-arch arguments for cmake
function config-cmake-arm8 () { 
  CMAKE_ARGS=$CMAKE_ARGS' -DCMAKE_SYSTEM_PROCESSOR=arm -DWITH_RANDOMX=OFF -DARM_TARGET=8' #randomx currently causes compile issues on ARM systems, bug fix pending from official xmrig repo
}
function config-cmake-arm7 () { 
  CMAKE_ARGS=$CMAKE_ARGS' -DCMAKE_SYSTEM_PROCESSOR=arm -DWITH_RANDOMX=OFF -DARM_TARGET=7' #randomx currently causes compile issues on ARM systems, bug fix pending from official xmrig repo
}
function config-cmake-x86 () {
  CMAKE_ARGS=$CMAKE_ARGS' -DCMAKE_BUILD_TYPE=release32'
}
function config-cmake-x64 () {
  CMAKE_ARGS=$CMAKE_ARGS' -DCMAKE_GENERATOR_PLATFORM=x64'
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
function config-cmake-osx-96 () { 
  CMAKE_ARGS=$CMAKE_ARGS' -DCMAKE_OSX_ARCHITECTURES=x86_64;i386' 
}

##########################
# Cmake execution - pray #
##########################

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

##################
# make functions #
##################

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

function set-package-manager () {
	if [[ $SELECTED_COMPILE_OS=="alpine" ]]
  then
    PACKAGE_MANAGER="apk"
  elif [[ $SELECTED_COMPILE_OS=="arch" ]] || [[ $SELECTED_COMPILE_OS=="manjaro" ]] || [[ $SELECTED_COMPILE_OS=="windows-msys2" ]]
  then
    PACKAGE_MANAGER="pacman"
  elif [[ $SELECTED_COMPILE_OS=="centos6" ]] || [[ $SELECTED_COMPILE_OS=="centos7" ]] || [[ $SELECTED_COMPILE_OS=="centos8" ]]
  then
    PACKAGE_MANAGER="yum"
  elif [[ $SELECTED_COMPILE_OS=="fedora" ]]
  then
    PACKAGE_MANAGER="dnf"
  elif [[ $SELECTED_COMPILE_OS=="freebsd" ]]
  then
    PACKAGE_MANAGER="pkg"
  elif [[ $SELECTED_COMPILE_OS=="macos" ]]
    PACKAGE_MANAGER="brew"
  then
  elif [[ $SELECTED_COMPILE_OS=="ubuuntu" ]]
  then
    PACKAGE_MANAGER="apt-get"
  fi
}

######################
# compiler functions #
######################

function set-c-compiler () {
  CMAKE_ARGS=$CMAKE_ARGS' -DCMAKE_C_COMPILER=$C_COMPILER'
}

function set-cxx-compiler () {
  CMAKE_ARGS=$CMAKE_ARGS' -DCMAKE_CXX_COMPILER=$CXX_COMPILER'
}

###############################################################################
# Main program function - put functs here so that the computer goes beep boop #
###############################################################################

function main () {
  intro-text
  help-text
  set-package-manager
  config-cmake-$SELECTED_COMPILE_ARCH
  config-cmake-$SELECTED_COMPILE_OS
  if [[ $save =~ s ]] || [[ $save =~ S ]]
  then
	swapfile-generic
  else
}

main
