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

export METADATAKERNELN32=${SCRIPT}/../metadata/kernel-n32

export SRCKERNELN32=${SCRIPT}/../src/kernel-n32

export BUILDKERNELN32=${SCRIPT}/../build/kernel-n32

[[ $# -eq 1 ]] || die "usage: $0 PREFIX"
export PREFIX="$1"
export PREFIXKERNELN32=${PREFIX}/gnu-linux
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

[ -d "${SRCKERNELN32}" ] || mkdir -p "${SRCKERNELN32}"

[ -d "${BUILDKERNELN32}" ] || mkdir -p "${BUILDKERNELN32}"

[ -d "${METADATAKERNELN32}" ] || mkdir -p "${METADATAKERNELN32}"

#################################################################
### 32bit gnu extract
#################################################################
pushd ${SRCKERNELN32}
[ -f ${METADATAKERNELN32}/linux_extract ] || \
(tar xf ${TARBALL}/linux-${LINUX_VERSION}.${LINUX_SUFFIX} || \
  die "extract linux error" ) && \
    touch ${METADATAKERNELN32}/linux_extract
cd linux-${LINUX_VERSION}
[-f ${METADATAKERNELN32}/linux_patch ] || \
  patch -p1 < ${PATCH}/linux-mipsel-n32-defconfig.patch && \
    die "patch linux mipsel-n32_defconfig error" && \
      touch ${METADATAKERNELN32}/linux_patch
popd

unset CFLAGS
unset CXXFLAGS
export CFLAGS="-w"
export CROSS_HOST=${MACHTYPE}
export CROSS_TARGET64="mips64el-unknown-linux-gnu"
export O32="-mabi=32"
export N32="-mabi=n32"
export N64="-mabi=64"

#################################################################
### 32bit gnu build
#################################################################
pushd ${SRCKERNELN32}
cd linux-${LINUX_VERSION}
[ -f ${METADATAKERNELN32}/linux_config ] || \
  make ARCH=mips mipsel-n32_defconfig || \
    die "linux config error" && \
      touch ${METADATAKERNELN32}/linux_config
[ -f ${METADATAKERNELN32}/linux_build ] || \
  make -j${JOBS} ARCH=mips CROSS_COMPILER=${CROSS_TARGET64}- || \
    die "linux build error" && \
      touch ${METADATAKERNELN32}/linux_build
[ -f ${METADATAKERNELN32}/linux_move ] || \
  mv vmlinux.32 ${PREFIXKERNELN32}/kernel-n32 || \
    die "linux move error" && \
      touch ${METADATAKERNELO32}/linux_move
popd
