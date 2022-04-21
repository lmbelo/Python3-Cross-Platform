Python 3 Linux
================

This is an experimental set of build scripts that will compile Python [3.7.9, 3.8.9, 3.9.9 and 3.10.4] for Linux.
This project is a supplier for the [delphi4python](https://github.com/Embarcadero/python4delphi) project.

Prerequisites
-------------

Building requires:

1. Linux. This project might work on other systems from the UNIX family but no guarantee.
2. CLANG, LLVM and LLD installed.

Running requires:

1. Linux x86_64

Build
-----

1. Run `./clean.sh` for good measure.
2. Use the docker-build script for easy compile.

Build using Docker
------------------

```
docker run --rm -it -v $(pwd):/python3-linux -v --env ARCH=x86_64 --env PYVER=3.9.4 python:3.9.0-slim /python3-linux/docker-build.sh
```

SSL/TLS
-------
SSL certificates have old and new naming schemes. Android uses the old scheme yet the latest OpenSSL uses the new one. If you got ```CERTIFICATE_VERIFY_FAILED``` when using SSL/TLS in Python, you need to collect system certificates: (thanks @GRRedWings for the idea)
```
cd /data/local/tmp/build
mkdir -p etc/ssl
cat /system/etc/security/cacerts/* > etc/ssl/cert.pem
```
Path for certificates may vary with device vendor and/or Android version. Note that this approach only collects system certificates. If you need to collect user-installed certificates, most likely root access on your Android device is needed.

Check SSL/TLS functionality with:
```
import urllib.request
print(urllib.request.urlopen('https://httpbin.org/ip').read().decode('ascii'))
```

Known Issues
------------

No big issues! yay
