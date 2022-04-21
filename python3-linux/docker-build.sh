#!/bin/bash

set -e
set -x

apt-get update -y
apt-get install -y autoconf autoconf-archive automake cmake gawk gettext git gcc llvm clang lld make patch pkg-config

export LINUX_NDK=/usr/bin

cd /python3-linux

./build.sh "$@"
