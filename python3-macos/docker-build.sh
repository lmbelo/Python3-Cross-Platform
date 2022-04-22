#!/bin/bash

set -e
set -x

apt-get update -y
apt-get install -y git curl clang llvm-dev libxml2-dev uuid-dev libssl-dev bash patch cmake tar xz-utils bzip2 gzip sed cpio pkg-config libbz2-dev zlib1g-dev

curl -sSL https://cmake.org/files/v3.14/cmake-3.14.5-Linux-x86_64.tar.gz | tar -xzC /opt
export PATH=/opt/cmake-3.14.5-Linux-x86_64/bin:$PATH

cd python3-macos/cross-toolchain/tarballs
curl -vLO https://github.com/phracker/MacOSX-SDKs/releases/download/11.3/MacOSX10.14.sdk.tar.xz
cd ../
UNATTENDED=1 ./build.sh
ls -R
cd ../../

export MACOS_SDK=/cross-toolchain/osxcross/bin

cd /python3-macos

#./build.sh "$@"
