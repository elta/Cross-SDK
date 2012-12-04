#! /bin/bash

source source.sh

[ -d "${PREFIXGNULINUX}" ] || mkdir -p "${PREFIXGNULINUX}"
[ -d "${SRCKERNELN32}" ] || mkdir -p "${SRCKERNELN32}"
[ -d "${BUILDKERNELN32}" ] || mkdir -p "${BUILDKERNELN32}"
[ -d "${METADATAKERNELN32}" ] || mkdir -p "${METADATAKERNELN32}"

[ -f ${PREFIXGNU64}/bin/${CROSS_TARGET64}-gcc ] || \
  die "No toolchain found, process error"

export PATH=${PATH}:${PREFIXGNU64}/bin

#################################################################
### 32bit linux extract
#################################################################
pushd ${SRCKERNELN32}
[ -f ${METADATAKERNELN32}/linux_extract ] || \
(tar xf ${TARBALL}/linux-${LINUX_VERSION}.${LINUX_SUFFIX} || \
  die "extract linux error" ) && \
    touch ${METADATAKERNELN32}/linux_extract
cd linux-${LINUX_VERSION}
[ -f ${METADATAKERNELN32}/linux_patch ] || \
  patch -p1 < ${PATCH}/linux-mipsel-n32-defconfig.patch || \
    die "patch linux mipsel-n32_defconfig error" && \
      touch ${METADATAKERNELN32}/linux_patch
popd

#################################################################
### 32bit linux build
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
[ -f ${METADATAKERNELN32}/linux32_build ] || \
  make -j${JOBS} ARCH=mips CROSS_COMPILER=${CROSS_TARGET64}- vmlinux.32 || \
    die "linux build error" && \
      touch ${METADATAKERNELN32}/linux32_build
[ -f ${METADATAKERNELN32}/linux_move ] || \
  mv vmlinux.32 ${PREFIXGNULINUX}/kernel-n32 || \
    die "linux move error" && \
      touch ${METADATAKERNELN32}/linux_move
popd
