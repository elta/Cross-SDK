#! /bin/bash

source source.sh

[ -d "${PREFIXGNULINUX}" ] || mkdir -p "${PREFIXGNULINUX}"
[ -d "${SRCKERNELO32}" ] || mkdir -p "${SRCKERNELO32}"
[ -d "${BUILDKERNELO32}" ] || mkdir -p "${BUILDKERNELO32}"
[ -d "${METADATAKERNELO32}" ] || mkdir -p "${METADATAKERNELO32}"

[ -f ${PREFIXGNU32}/bin/${CROSS_TARGET32}-gcc ] || \
  die "No toolchain found, process error"

#################################################################
### 32bit linux extract
#################################################################
pushd ${SRCKERNELO32}
[ -f ${METADATAKERNELO32}/linux_extract ] || \
(tar xf ${TARBALL}/linux-${LINUX_VERSION}.${LINUX_SUFFIX} || \
  die "extract linux error" ) && \
    touch ${METADATAKERNELO32}/linux_extract
popd

#################################################################
### 32bit linux build
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
  mv vmlinux ${PREFIXGNULINUX}/kernel-o32 || \
    die "linux move error" && \
      touch ${METADATAKERNELO32}/linux_move
popd
