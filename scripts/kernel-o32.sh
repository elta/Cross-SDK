#! /bin/bash

export JOBS=3

export BZ=tar.bz2
export GZ=tar.gz
export XZ=tar.xz

export LINUX_VERSION=3.3.7
export LINUX_SUFFIX=${XZ}

function die() {
  echo "$1"
  exit 1
}

export SCRIPT="$(pwd)"
export TARBALL=${SCRIPT}/../tarballs
export PATCH=${SCRIPT}/../patches

export METADATAKERNELO32=${SCRIPT}/../metadata/kernel-o32

export SRCKERNELO32=${SCRIPT}/../src/kernel-o32

export BUILDKERNELO32=${SCRIPT}/../build/kernel-o32

[[ $# -eq 1 ]] || die "usage: $0 PREFIX"
export PREFIX="$1"
export PREFIXKERNELO32=${PREFIX}/gnu-linux
export PREFIX64=${PREFIX}/gnu64
export PREFIX32=${PREFIX}/gnu32
export RTEMSPREFIX64=${PREFIX}/rtems64
export RTEMSPREFIX32=${PREFIX}/rtems32
export BAREPREFIX64=${PREFIX}/elf64
export BAREPREFIX32=${PREFIX}/elf32
export QEMUPREFIX=${PREFIX}/qemu
export LLVMPREFIX=${PREFIX}/llvm
export QTCPREFIX=${PREFIX}/qt-creator
export PATH=${PATH}:${PREFIX64}/bin:${PREFIX32}/bin:${RTEMSPREFIX64}/bin:${RTEMSPREFIX32}/bin:${BAREPREFIX64}/bin:${BAREPREFIX32}/bin

[ -d "${SRCKERNELO32}" ] || mkdir -p "${SRCKERNELO32}"

[ -d "${BUILDKERNELO32}" ] || mkdir -p "${BUILDKERNELO32}"

[ -d "${METADATAKERNELO32}" ] || mkdir -p "${METADATAKERNELO32}"

#################################################################
### 32bit gnu extract
#################################################################
pushd ${SRCKERNELO32}
[ -f ${METADATAKERNELO32}/linux_extract ] || \
(tar xf ${TARBALL}/linux-${LINUX_VERSION}.${LINUX_SUFFIX} || \
  die "extract linux error" ) && \
    touch ${METADATAKERNELO32}/linux_extract
popd

unset CFLAGS
unset CXXFLAGS
export CFLAGS="-w"
export CROSS_HOST=${MACHTYPE}
export CROSS_TARGET32="mipsel-unknown-linux-gnu"
export O32="-mabi=32"
export N32="-mabi=n32"
export N64="-mabi=64"

#################################################################
### 32bit gnu build
#################################################################
pushd ${SRCKERNELO32}
cd linux-${LINUX_VERSION}
[ -f ${METADATAKERNELO32}/linux_config ] || \
  make ARCH=mips malta_defconfig || \
    die "linux config error" && \
      touch ${METADATAKERNELO32}/linux_config
[ -f ${METADATAKERNELO32}/linux_build ] || \
  make -j${JOBS} ARCH=mips CROSS_COMPILER=${CROSS_TARGET32}- || \
    die "linux build error" && \
      touch ${METADATAKERNELO32}/linux_build
[ -f ${METADATAKERNELO32}/linux_move ] || \
  mv vmlinux ${PREFIXKERNELO32}/kernel-o32 || \
    die "linux move error" && \
      touch ${METADATAKERNELO32}/linux_move
popd
