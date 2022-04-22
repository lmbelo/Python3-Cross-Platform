#!/bin/bash

set -e
set -x

THIS_DIR="$PWD"

PYVER=${PYVER:-3.9.0}
SRCDIR=src/Python-$PYVER

COMMON_ARGS="--arch ${ARCH:-arm}"

if [ ! -d $SRCDIR ]; then
    mkdir -p src
    pushd src
    curl -vLO https://www.python.org/ftp/python/$PYVER/Python-$PYVER.tar.xz
    # Use --no-same-owner so that files extracted are still owned by the
    # running user in a rootless container
    tar --no-same-owner -xf Python-$PYVER.tar.xz
    popd
fi

cp -r Linux $SRCDIR
pushd $SRCDIR
patch -Np1 -i ./Linux/unversioned-libpython.patch
autoreconf -ifv
which python
python -m pip install dataclasses
./Linux/build_deps.py $COMMON_ARGS
./Linux/configure.py $COMMON_ARGS --prefix=/usr "$@"
make
make install DESTDIR="$THIS_DIR/build"
popd
cp -r $SRCDIR/Linux/sysroot/usr/share/terminfo build/usr/share/
cp devscripts/env.sh build/
