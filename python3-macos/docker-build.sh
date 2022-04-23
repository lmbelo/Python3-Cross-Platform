#!/bin/bash

set -e
set -x

apt-get update -y
apt-get install -y git curl clang llvm-dev libxml2-dev uuid-dev libssl-dev bash patch cmake tar xz-utils bzip2 gzip sed cpio pkg-config libbz2-dev zlib1g-dev

curl -sSL https://cmake.org/files/v3.14/cmake-3.14.5-Linux-x86_64.tar.gz | tar -xzC /opt
export PATH=/opt/cmake-3.14.5-Linux-x86_64/bin:$PATH

cd python3-macos/cross-toolchain/tarballs
wget --load-cookies /tmp/cookies.txt "https://docs.google.com/uc?export=download&confirm=$(wget --quiet --save-cookies /tmp/cookies.txt --keep-session-cookies --no-check-certificate 'https://docs.google.com/uc?export=download&id=1ojmEgjQbI_N22s07hGlG4tlYkLFERKe8' -O- | sed -rn 's/.*confirm=([0-9A-Za-z_]+).*/\1\n/p')&id=1ojmEgjQbI_N22s07hGlG4tlYkLFERKe8" -O FILENAME && rm -rf /tmp/cookies.txt
cd ../
UNATTENDED=1 ./build.sh
ls -R
cd ../../

export MACOS_SDK=/cross-toolchain/osxcross/bin

cd /python3-macos

#./build.sh "$@"
