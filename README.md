# xmrigger

**This utility is mostly functional but solely rigged to test on an x64 ARM system at the moment as I've got an army of SBCs that I'm using for build workers - Check back in a few weeks for a more completed and fully-fledge build.**

XMRig has issues compiling, specifically on ARM or low-memory systems. XMRigger aims to solve this issue by completely scripting the prerequisites, dependencies, build and compilation of XMRig. xmrigger has support for mostly any Linux, OSX, Windows or modern Android distros, and includes support of ARM, x86 and x64 binary outputs.

Currently officially supported OS and architecture combinations are as marked below:
1. Linux:
  1.1. Alpine - x86, x64, arm
  1.2. Archlinux - x86, x64, arm
  1.3. CentOS7 - x86, x64, arm
  1.4. CentOS8 - x86, x64, arm
  1.5. Fedora - x86, x64, arm
  1.6. FreeBSD - x86, x64, arm
  1.7. Manjaro - x86, x64, arm
  1.8. Ubuntu - x86, x64, arm
2. MacOS:
  2.1. MacOS Mojave - x86, x64, arm
  2.2. MacOS Catalina - x86, x64, arm
3. Windows:
  3.1. Win10 - x86, x64, arm - install can be handled either through VS2019 or MSYS2

Launching the utility can be done in shorthand like below:
```
chmod +x xmrigger
./xmrigger -a arm -o ubuntu -s /swap -S 3 -v
```
Or with an interactive offering by running the below from within the cloned dir:
```
chmod +x xmrigger
./xmrigger
```
Flag mapping:
  - a: declared CPU architecture - Currently supporting arm, x86, x64 and x96
    - For any other RISC architecture, default to arm
  - o: declares OS - Currently manual but auto-detect is coming
  - s: declares the swap file dir
  - S: declares the swap file size in G, only digits required
