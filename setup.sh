#!/usr/bin/env bash

set +e

proxy=https://ghproxy.com/
INCLUDE_PATH=/usr/local/include/

if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root!"
    exit 1
fi

function register_clang_version {
    local version=$1
    local priority=$2

    update-alternatives \
        --verbose \
        --install /usr/bin/llvm-config llvm-config /usr/bin/llvm-config-${version} ${priority} \
        --slave /usr/bin/llvm-ar llvm-ar /usr/bin/llvm-ar-${version} \
        --slave /usr/bin/llvm-as llvm-as /usr/bin/llvm-as-${version} \
        --slave /usr/bin/llvm-bcanalyzer llvm-bcanalyzer /usr/bin/llvm-bcanalyzer-${version} \
        --slave /usr/bin/llvm-cov llvm-cov /usr/bin/llvm-cov-${version} \
        --slave /usr/bin/llvm-diff llvm-diff /usr/bin/llvm-diff-${version} \
        --slave /usr/bin/llvm-dis llvm-dis /usr/bin/llvm-dis-${version} \
        --slave /usr/bin/llvm-dwarfdump llvm-dwarfdump /usr/bin/llvm-dwarfdump-${version} \
        --slave /usr/bin/llvm-extract llvm-extract /usr/bin/llvm-extract-${version} \
        --slave /usr/bin/llvm-link llvm-link /usr/bin/llvm-link-${version} \
        --slave /usr/bin/llvm-mc llvm-mc /usr/bin/llvm-mc-${version} \
        --slave /usr/bin/llvm-nm llvm-nm /usr/bin/llvm-nm-${version} \
        --slave /usr/bin/llvm-objdump llvm-objdump /usr/bin/llvm-objdump-${version} \
        --slave /usr/bin/llvm-ranlib llvm-ranlib /usr/bin/llvm-ranlib-${version} \
        --slave /usr/bin/llvm-readobj llvm-readobj /usr/bin/llvm-readobj-${version} \
        --slave /usr/bin/llvm-rtdyld llvm-rtdyld /usr/bin/llvm-rtdyld-${version} \
        --slave /usr/bin/llvm-size llvm-size /usr/bin/llvm-size-${version} \
        --slave /usr/bin/llvm-stress llvm-stress /usr/bin/llvm-stress-${version} \
        --slave /usr/bin/llvm-symbolizer llvm-symbolizer /usr/bin/llvm-symbolizer-${version} \
        --slave /usr/bin/llvm-tblgen llvm-tblgen /usr/bin/llvm-tblgen-${version} \
        --slave /usr/bin/llvm-objcopy llvm-objcopy /usr/bin/llvm-objcopy-${version} \
        --slave /usr/bin/llvm-strip llvm-strip /usr/bin/llvm-strip-${version}

    update-alternatives \
        --verbose \
        --install /usr/bin/clang clang /usr/bin/clang-${version} ${priority} \
        --slave /usr/bin/clang++ clang++ /usr/bin/clang++-${version} \
        --slave /usr/bin/asan_symbolize asan_symbolize /usr/bin/asan_symbolize-${version} \
        --slave /usr/bin/clang-cpp clang-cpp /usr/bin/clang-cpp-${version} \
        --slave /usr/bin/clang-check clang-check /usr/bin/clang-check-${version} \
        --slave /usr/bin/clang-cl clang-cl /usr/bin/clang-cl-${version} \
        --slave /usr/bin/ld.lld ld.lld /usr/bin/ld.lld-${version} \
        --slave /usr/bin/lld lld /usr/bin/lld-${version} \
        --slave /usr/bin/lld-link lld-link /usr/bin/lld-link-${version} \
        --slave /usr/bin/clang-format clang-format /usr/bin/clang-format-${version} \
        --slave /usr/bin/clang-format-diff clang-format-diff /usr/bin/clang-format-diff-${version} \
        --slave /usr/bin/clang-include-fixer clang-include-fixer /usr/bin/clang-include-fixer-${version} \
        --slave /usr/bin/clang-offload-bundler clang-offload-bundler /usr/bin/clang-offload-bundler-${version} \
        --slave /usr/bin/clang-query clang-query /usr/bin/clang-query-${version} \
        --slave /usr/bin/clang-rename clang-rename /usr/bin/clang-rename-${version} \
        --slave /usr/bin/clang-reorder-fields clang-reorder-fields /usr/bin/clang-reorder-fields-${version} \
        --slave /usr/bin/clang-tidy clang-tidy /usr/bin/clang-tidy-${version} \
        --slave /usr/bin/lldb lldb /usr/bin/lldb-${version} \
        --slave /usr/bin/lldb-server lldb-server /usr/bin/lldb-server-${version} \
        --slave /usr/bin/clangd clangd /usr/bin/clangd-${version}
}

rm -rf /tmp/myutils
mkdir -p /tmp/myutils
cd /tmp/myutils

[ -e ${INCLUDE_PATH}dbg.h ] || wget ${proxy}https://raw.githubusercontent.com/sharkdp/dbg-macro/master/dbg.h -O ${INCLUDE_PATH}dbg.h
[ -e ${INCLUDE_PATH}backward.h ] || wget ${proxy}https://raw.githubusercontent.com/bombela/backward-cpp/master/backward.hpp -O ${INCLUDE_PATH}backward.h
[ -e ${INCLUDE_PATH}doctest.h ] || wget ${proxy}https://raw.githubusercontent.com/doctest/doctest/master/doctest/doctest.h -O ${INCLUDE_PATH}doctest.h
[ -e ${INCLUDE_PATH}argparse.h ] || wget ${proxy}https://raw.githubusercontent.com/p-ranav/argparse/master/include/argparse/argparse.hpp -O ${INCLUDE_PATH}argparse.h

if ! which clang &>/dev/null; then
    wget https://apt.llvm.org/llvm.sh
    LLVM_VERSION=$(grep CURRENT_LLVM_STABLE= llvm.sh | awk -F= '{print $2}')
    which clang-$LLVM_VERSION &>/dev/null || bash llvm.sh all
    register_clang_version $LLVM_VERSION $LLVM_VERSION
fi

[ -e /etc/apt/sources.list.d/ubuntu-toolchain-r-ubuntu-test-*.list ] || apt-add-repository -y ppa:ubuntu-toolchain-r/test
which g++-11 &>/dev/null || apt-get -y install g++-11
which gdb &>/dev/null || apt-get -y install gdb
