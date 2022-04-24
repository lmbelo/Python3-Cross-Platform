import argparse
import os
import pathlib
from dataclasses import dataclass
from typing import Dict, Optional

BASE = pathlib.Path(__file__).resolve().parent
SYSROOT = BASE / 'sysroot'


@dataclass
class Arch:
    MACOS_TARGET: str
    BINUTILS_PREFIX: Optional[str] = None

    @property
    def binutils_prefix(self) -> str:
        return self.BINUTILS_PREFIX or self.MACOS_TARGET


ARCHITECTURES = {
    'x86_64': Arch('x86_64-apple-darwin20.2',),
}

def ndk_unified_toolchain() -> pathlib.Path:
    sdk_path = os.getenv('MACOS_SDK')
    if not sdk_path:
        raise Exception('Requires environment variable $ANDROID_NDK')

    print(pathlib.Path(sdk_path))
    if not os.path.exists(pathlib.Path(sdk_path)):
        raise Exception('Environment variable path not found') 

    return pathlib.Path(sdk_path)


def env_vars(target_arch_name: str) -> Dict[str, str]:
    target_arch = ARCHITECTURES[target_arch_name]

    CLANG_PREFIX = ndk_unified_toolchain()

    env = {
        # Compilers
        'CC' : f'{CLANG_PREFIX}/o64-clang',
        'CXX': f'{CLANG_PREFIX}/o64-clang++',
        'CPP': f'{CLANG_PREFIX}/o64-clang -E',

        # Compiler flags
        'CPPFLAGS': f'-I{SYSROOT}/usr/include',
        #'CFLAGS': '-fPIC',
        #'CXXFLAGS': '-fPIC',
        'LDFLAGS': f'-L{SYSROOT}/usr/lib -pie',        

        # pkg-config settings
        'PKG_CONFIG': f'{CLANG_PREFIX}/{target_arch}-pkg-config',
        'RELEASE': 'yes',

        'PYTHONPATH': str(BASE),
    }

    for prog in ('ar', 'as', 'nm', 'ObjectDump', 'ranlib', 'readelf', 'strip', 'check_dylib', 'ld'):
        env[prog.upper()] = str(ndk_unified_toolchain() / f'{target_arch}-')
    #env['ld'] = str(ndk_unified_toolchain() / 'lld') 

    return env


def parse_args():
    parser = argparse.ArgumentParser()
    parser.add_argument('--arch', required=True, choices=ARCHITECTURES.keys(), dest='target_arch_name')
    return parser.parse_known_args()
