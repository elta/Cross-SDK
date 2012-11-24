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

export METADATAKERNEL64=${SCRIPT}/../metadata/kernel-64

export SRCKERNEL64=${SCRIPT}/../src/kernel-64

export BUILDKERNEL64=${SCRIPT}/../build/kernel-64

[[ $# -eq 1 ]] || die "usage: $0 PREFIX"
export PREFIX="$1"
export PREFIXKERNEL64=${PREFIX}/gnu-linux
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

[ -d "${SRCKERNEL64}" ] || mkdir -p "${SRCKERNEL64}"

[ -d "${BUILDKERNEL64}" ] || mkdir -p "${BUILDKERNEL64}"

[ -d "${METADATAKERNEL64}" ] || mkdir -p "${METADATAKERNEL64}"

#################################################################
### 32bit gnu extract
#################################################################
pushd ${SRCKERNEL64}
[ -f ${METADATAKERNEL64}/linux_extract ] || \
(tar xf ${TARBALL}/linux-${LINUX_VERSION}.${LINUX_SUFFIX} || \
  die "extract linux error" ) && \
    touch ${METADATAKERNEL64}/linux_extract
cd linux-${LINUX_VERSION}
[-f ${METADATAKERNEL64}/linux_patch ] || \
  patch -p1 < ${PATCH}/linux-mips64el-defconfig.patch && \
    die "patch linux mips64el-defconfig error" && \
      touch ${METADATAKERNEL64}/linux_patch
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
pushd ${SRCKERNEL64}
cd linux-${LINUX_VERSION}
[ -f ${METADATAKERNEL64}/linux_config ] || \
  make ARCH=mips mips64el_defconfig || \
    die "linux config error" && \
      touch ${METADATAKERNEL64}/linux_config
[ -f ${METADATAKERNEL64}/linux_build ] || \
  make -j${JOBS} ARCH=mips CROSS_COMPILER=${CROSS_TARGET64}- || \
    die "linux build error" && \
      touch ${METADATAKERNEL64}/linux_build
[ -f ${METADATAKERNEL64}/linux_move ] || \
  mv vmlinux ${PREFIXKERNEL64}/kernel-64 || \
    die "linux move error" && \
      touch ${METADATAKERNELO32}/linux_move
popd
