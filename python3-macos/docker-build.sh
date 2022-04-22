#!/bin/bash

set -e
set -x

apt-get update -y
apt-get install -y git curl cmake patch libssl-dev lzma-dev libxml2-dev llvm-dev

curl -sSL https://cmake.org/files/v3.14/cmake-3.14.5-Linux-x86_64.tar.gz | sudo tar -xzC /opt
export PATH=/opt/cmake-3.14.5-Linux-x86_64/bin:$PATH

cd python3-macos/cross-toolchain
./build_clang.sh

cd tarballs
curl -vLO https://github.com/phracker/MacOSX-SDKs/releases/download/11.3/MacOSX10.14.sdk.tar.xz
cd ../
./build.sh
ls -R
cd ../../

export MACOS_SDK=/cross-toolchain/osxcross/bin

cd /python3-macos

#./build.sh "$@"
