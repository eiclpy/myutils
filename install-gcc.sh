#!/bin/bash

version=${1:-13}

if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root!"
    exit 1
fi

apt-add-repository -y ppa:ubuntu-toolchain-r/test
apt-get update
apt-get install -y gcc-${version} g++-${version} gfortran-${version}

update-alternatives \
    --verbose \
    --install /usr/bin/cpp                        cpp                          /usr/bin/cpp-${version} ${version} \
    --slave /usr/bin/g++                          g++                          /usr/bin/g++-${version} \
    --slave /usr/bin/gcc                          gcc                          /usr/bin/gcc-${version} \
    --slave /usr/bin/gcc-ar                       gcc-ar                       /usr/bin/gcc-ar-${version} \
    --slave /usr/bin/gcc-nm                       gcc-nm                       /usr/bin/gcc-nm-${version} \
    --slave /usr/bin/gcc-ranlib                   gcc-ranlib                   /usr/bin/gcc-ranlib-${version} \
    --slave /usr/bin/gcov                         gcov                         /usr/bin/gcov-${version} \
    --slave /usr/bin/gcov-dump                    gcov-dump                    /usr/bin/gcov-dump-${version} \
    --slave /usr/bin/gcov-tool                    gcov-tool                    /usr/bin/gcov-tool-${version} \
    --slave /usr/bin/gfortran                     gfortran                     /usr/bin/gfortran-${version} \
    --slave /usr/bin/lto-dump                     lto-dump                     /usr/bin/lto-dump-${version} \
    --slave /usr/bin/x86_64-linux-gnu-cpp         x86_64-linux-gnu-cpp         /usr/bin/x86_64-linux-gnu-cpp-${version} \
    --slave /usr/bin/x86_64-linux-gnu-g++         x86_64-linux-gnu-g++         /usr/bin/x86_64-linux-gnu-g++-${version} \
    --slave /usr/bin/x86_64-linux-gnu-gcc         x86_64-linux-gnu-gcc         /usr/bin/x86_64-linux-gnu-gcc-${version} \
    --slave /usr/bin/x86_64-linux-gnu-gcc-ar      x86_64-linux-gnu-gcc-ar      /usr/bin/x86_64-linux-gnu-gcc-ar-${version} \
    --slave /usr/bin/x86_64-linux-gnu-gcc-nm      x86_64-linux-gnu-gcc-nm      /usr/bin/x86_64-linux-gnu-gcc-nm-${version} \
    --slave /usr/bin/x86_64-linux-gnu-gcc-ranlib  x86_64-linux-gnu-gcc-ranlib  /usr/bin/x86_64-linux-gnu-gcc-ranlib-${version} \
    --slave /usr/bin/x86_64-linux-gnu-gcov        x86_64-linux-gnu-gcov        /usr/bin/x86_64-linux-gnu-gcov-${version} \
    --slave /usr/bin/x86_64-linux-gnu-gcov-dump   x86_64-linux-gnu-gcov-dump   /usr/bin/x86_64-linux-gnu-gcov-dump-${version} \
    --slave /usr/bin/x86_64-linux-gnu-gcov-tool   x86_64-linux-gnu-gcov-tool   /usr/bin/x86_64-linux-gnu-gcov-tool-${version} \
    --slave /usr/bin/x86_64-linux-gnu-gfortran    x86_64-linux-gnu-gfortran    /usr/bin/x86_64-linux-gnu-gfortran-${version} \
    --slave /usr/bin/x86_64-linux-gnu-lto-dump    x86_64-linux-gnu-lto-dump    /usr/bin/x86_64-linux-gnu-lto-dump-${version}