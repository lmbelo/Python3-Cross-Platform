#!/bin/bash

set -e
set -x

chsh -s /bin/bash
SHELL=/bin/bash

apt-get update -y
apt-get install -y bash git autoconf autoconf-archive automake curl wget patch tar xz-utils bzip2 gzip clang make llvm-dev uuid-dev libssl-dev libbz2-dev lzma-dev libxml2-dev

# We must upgrade CMake to >= 3.2.3 first
curl -sSL https://cmake.org/files/v3.14/cmake-3.14.5-Linux-x86_64.tar.gz | tar -xzC /opt
export PATH=$PATH:/opt/cmake-3.14.5-Linux-x86_64/bin

if [ ${ARCH} = "x86_64" ]; then
    echo "Targeting arch x86_64"
    export MACOS_NDK=/python3-macos/x86_64/cross-toolchain/target

    # if we don't have the ndk, then we create it (or download it)
    if [ ! -d "$MACOS_NDK" ]; then
        echo "Preparing the MacOS x86_64 NDK"
        mkdir -p /python3-macos/x86_64        

        echo "Downloading the MacOS NDK"
        pushd /python3-macos/x86_64
        # Try to download from our private resource - this pre-built version drops considerably the toolchain build process
        wget --load-cookies /tmp/cookies.txt "https://docs.google.com/uc?export=download&confirm=$(wget --quiet --save-cookies /tmp/cookies.txt --keep-session-cookies --no-check-certificate 'https://docs.google.com/uc?export=download&id=1IQKjdh4gAy4_M1NtM_T8yS3EspQIAFc2' -O- | sed -rn 's/.*confirm=([0-9A-Za-z_]+).*/\1\n/p')&id=1IQKjdh4gAy4_M1NtM_T8yS3EspQIAFc2" -O osxcross.tar.xz && rm -rf /tmp/cookies.txt
        tar --no-same-owner -xf osxcross.tar.xz 
        mv osxcross cross-toolchain       
        popd
        pushd /python3-macos/x86_64/cross-toolchain
        #UNATTENDED=1 ./build_clang.sh
        UNATTENDED=1 ./build.sh
        popd

        # else we create the ndk
        if [ ! -d "$MACOS_NDK" ]; then
            # We move the cross-toolchain to the target arch folder
            mv /python3-macos/cross-toolchain /python3-macos/x86_64
            echo "Building the MacOS NDK"
            pushd /python3-macos/x86_64/cross-toolchain
            pushd tarballs
            # Download the MacOS SDK from our private resource
            wget --load-cookies /tmp/cookies.txt "https://docs.google.com/uc?export=download&confirm=$(wget --quiet --save-cookies /tmp/cookies.txt --keep-session-cookies --no-check-certificate 'https://docs.google.com/uc?export=download&id=1ojmEgjQbI_N22s07hGlG4tlYkLFERKe8' -O- | sed -rn 's/.*confirm=([0-9A-Za-z_]+).*/\1\n/p')&id=1ojmEgjQbI_N22s07hGlG4tlYkLFERKe8" -O MacOSX11.1.sdk.tar.bz2 && rm -rf /tmp/cookies.txt
            popd
            UNATTENDED=1 ./build.sh
            popd
        fi        
    else    
        echo "MacOS NDK found"
    fi    
else
    echo "Targeting arch arm64"
fi

export PATH=/python3-macos/x86_64/cross-toolchain/target/bin:$PATH
export MACOSX_DEPLOYMENT_TARGET=11.1

#UNATTENDED=1 osxcross-macports update-cache
#UNATTENDED=1 osxcross-macports install ncurses

cd /python3-macos

./build.sh "$@"