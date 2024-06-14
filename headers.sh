#!/bin/bash

INCLUDE_PATH=/usr/local/include/
PROXY=https://mirror.ghproxy.com/
DOWNLOAD_DIR=/tmp/headers/

mkdir -p ${DOWNLOAD_DIR}
cd ${DOWNLOAD_DIR}

function download() {
  [ -e $2 ] || curl -sSL -m $3 $1 -o $2
  [ -e $2 ] || curl -sSL -m $3 ${PROXY}$1 -o $2
}

download https://raw.githubusercontent.com/sharkdp/dbg-macro/master/dbg.h dbg.h 15
download https://raw.githubusercontent.com/bombela/backward-cpp/master/backward.hpp backward.h 15
download https://raw.githubusercontent.com/doctest/doctest/master/doctest/doctest.h doctest.h 15
download https://raw.githubusercontent.com/p-ranav/argparse/master/include/argparse/argparse.hpp argparse.h 15
download https://raw.githubusercontent.com/Neargye/nameof/master/include/nameof.hpp nameof.h 15
download https://raw.githubusercontent.com/martinus/nanobench/master/src/include/nanobench.h nanobench.h 15

[ -d magic_enum ] || git clone https://github.com/Neargye/magic_enum.git || git clone ${PROXY}https://github.com/Neargye/magic_enum.git
sed 's/#include "/#include "magic_enum\//g' magic_enum/include/magic_enum/magic_enum_all.hpp > magic_enum/include/magic_enum.h

echo "downloaded to ${DOWNLOAD_DIR}"

if [[ $EUID -ne 0 ]]; then
    echo "You should be root to install headers!"
    exit 1
fi

cp *.h ${INCLUDE_PATH}
cp -r magic_enum/include/* ${INCLUDE_PATH}

echo "installed to ${INCLUDE_PATH}"
