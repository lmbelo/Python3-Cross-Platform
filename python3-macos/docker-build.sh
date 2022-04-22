#!/bin/bash

set -e
set -x

apt-get update -y
apt-get install -y git curl clang llvm-dev libxml2-dev uuid-dev libssl-dev bash patch cmake tar xz-utils bzip2 gzip sed cpio pkg-config libbz2-dev zlib1g-dev

curl -sSL https://cmake.org/files/v3.14/cmake-3.14.5-Linux-x86_64.tar.gz | tar -xzC /opt
export PATH=/opt/cmake-3.14.5-Linux-x86_64/bin:$PATH

cd python3-macos/cross-toolchain/tarballs
curl -vLO https://doc-0k-0k-docs.googleusercontent.com/docs/securesc/9f7ejkivseib9032ki8t4th8j1sv81c2/t505le7n43borigjo37kmmlcinu5jqjl/1650669750000/16226730521172937773/16226730521172937773/1ojmEgjQbI_N22s07hGlG4tlYkLFERKe8?e=download&ax=ACxEAsahI5Qti31YIPaQTjzXEAzczAO8AHh5eiiGWkUkPXyxzPZY6qPzvu1StECvMUehlyYcTiTjNSKhUQp2jS3eFxiYhsVTh3e9hnIXOegp5SXVj6Tmppq7NR53BopXE5P_PHHaMs4vZlSgVgVcl0XZAv7TIuUDIcy34I0MgS8YZiJIo8YYq0OIS-xJYiyPvLxbKRIbn-zA0nBqnXfKou0muHrWYsHoN3KmO_1MBY2DhWEtAi76z3IFD6Mg81G9ZqlELHwo5Y9ko_swQtXZNdPxil5zkFNiCmvGVbBgqjsCgAE0ZaRgv0ZjzVkM3pLCQH6BQ76XS7Io_5EA1LcmnwdMV2Pp7xFnaJraNH_4rQEsa3ATWm8XCWRcqu_WFe9CDQ4JIWLI6qpjT0WmRAVgkKOgfBoV07wJZ-hanRV-1Ixu71JQJ-m8TatPT7Ul5UsW3ZGXgE3fJDyh6xcq1mefrScBXe9l0xMcHTsUQ2IOIT5i9Ms555DVs-8FSFHoL9HzpNW_lWlBEkA1vJY0DKV0mH_LXcrONRgiYncaajvhHq9ekeYMBztHWnbn9FtlMG5T2qp7UBGRws00H--V4RJ52OlA3u0kLJQGitieYWwYssl2-6rS98lk5wiB_LsFAJShS6Wbl3LYt0DpuxM4DFGMU3L0R1RwtF0o0FhIdA38sRRe-fqMk_3wtdaqKZuxAHH0sjh5Zx9q4We_WVA&authuser=0&nonce=vejaasi915msi&user=16226730521172937773&hash=8n9c13cpo9u5qhqg30hr3cvfo5cotphd
cd ../
UNATTENDED=1 ./build.sh
ls -R
cd ../../

export MACOS_SDK=/cross-toolchain/osxcross/bin

cd /python3-macos

#./build.sh "$@"
