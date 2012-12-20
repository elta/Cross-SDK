#! /bin/bash

source source.sh

[ -d "${PREFIXGNULINUX}" ] || mkdir -p "${PREFIXGNULINUX}"
[ -d "${SRCKERNEL64}" ] || mkdir -p "${SRCKERNEL64}"
[ -d "${BUILDKERNEL64}" ] || mkdir -p "${BUILDKERNEL64}"
[ -d "${METADATAKERNEL64}" ] || mkdir -p "${METADATAKERNEL64}"

[ -f ${PREFIXGNU64}/bin/${CROSS_TARGET64}-gcc ] || \
  die "No toolchain found, process error"

export PATH=${PATH}:${PREFIXGNU64}/bin

#################################################################
### kernel extract
#################################################################
pushd ${SRCKERNEL64}
[ -f ${METADATAKERNEL64}/linux_extract ] || \
(tar xf ${TARBALL}/linux-${LINUX_VERSION}.${LINUX_SUFFIX} || \
  die "extract linux error" ) && \
    touch ${METADATAKERNEL64}/linux_extract
cd linux-${LINUX_VERSION}
[ -f ${METADATAKERNEL64}/linux_patch ] || \
  patch -p1 < ${PATCH}/linux-mips64el-multilib-defconfig.patch || \
    die "patch linux mips64el-defconfig error" && \
      touch ${METADATAKERNEL64}/linux_patch
popd

#################################################################
### kernel build
#################################################################
pushd ${SRCKERNEL64}
cd linux-${LINUX_VERSION}
[ -f ${METADATAKERNEL64}/linux_config ] || \
  make ARCH=mips mips64el_multilib_defconfig || \
    die "linux config error" && \
      touch ${METADATAKERNEL64}/linux_config
[ -f ${METADATAKERNEL64}/linux_build ] || \
  make -j${JOBS} ARCH=mips CROSS_COMPILER=${CROSS_TARGET64}- || \
    die "linux build error" && \
      touch ${METADATAKERNEL64}/linux_build
[ -f ${METADATAKERNEL64}/linux_move ] || \
  mv vmlinux ${PREFIXGNULINUX}/kernel-64 || \
    die "linux move error" && \
      touch ${METADATAKERNEL64}/linux_move
[ -f ${METADATAKERNEL64}/linux_N32_move ] || \
  mv vmlinux.32 ${PREFIXGNULINUX}/kernel-N32 || \
    die "linux N32 move error" && \
      touch ${METADATAKERNEL64}/linux_N32_move
popd
