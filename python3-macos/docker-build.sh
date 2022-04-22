#!/bin/bash

set -e
set -x

apt-get update -y
apt-get install -y git curl clang llvm-dev libxml2-dev uuid-dev libssl-dev bash patch make tar xz-utils bzip2 gzip sed cpio libbz2-dev

export MACOS_SDK=/macos-sdk

ls

if [ ! -d "$ANDROID_NDK" ] ; then
    cd cross-toolchain/tarballs
    curl -vLO https://github.com/phracker/MacOSX-SDKs/releases/download/11.3/MacOSX10.14.sdk.tar.xz
    cd ../../
fi

ls python3-macos/cross-toolchain/tarballs

cd /python3-macos

#./build.sh "$@"
