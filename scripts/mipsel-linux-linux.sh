#! /bin/bash

source source.env

[ -d "${SRCMIPSELKERNEL}" ] || mkdir -p "${SRCMIPSELKERNEL}"
[ -d "${BUILDMIPSELKERNEL}" ] || mkdir -p "${BUILDMIPSELKERNEL}"
[ -d "${METADATAMIPSELKERNEL}" ] || mkdir -p "${METADATAMIPSELKERNEL}"
[ -d "${PREFIXGNULINUX}" ] || mkdir -p "${PREFIXGNULINUX}"

mkdir -p ${PREFIXMIPSELROOTFS}
mkdir -p ${PREFIXMIPSELROOTFS}/boot

export PATH=${PREFIXHOSTTOOLS}/bin:${PREFIXMIPSELTOOLCHAIN}/bin:$PATH

###############################################################
# mipsel sysroot extract
###############################################################

pushd ${BUILDMIPSELKERNEL}
[ -f ${METADATAMIPSELKERNEL}/linux_extract ] || \
  tar xf ${TARBALL}/linux-${LINUX_VERSION}.${LINUX_SUFFIX} || \
    die "***extract linux error" && \
      touch ${METADATAMIPSELKERNEL}/linux_extract
popd

pushd ${BUILDMIPSELKERNEL}
cd linux-${LINUX_VERSION}
[ -f ${METADATAMIPSELKERNEL}/linux_cross_mrpro ] || \
  make mrproper || \
    die "clean cross linux error" && \
      touch ${METADATAMIPSELKERNEL}/linux_cross_mrpro
[ -f ${METADATAMIPSELKERNEL}/linux_config_patch ] || \
  patch -p1 < ${PATCH}/linux-mipsel-sysroot-defconfig.patch || \
    die "***Patch linux config error" && \
      touch ${METADATAMIPSELKERNEL}/linux_config_patch
[ -f ${METADATAMIPSELKERNEL}/linux_defconfig ] || \
  make ARCH=mips mipsel_sysroot_defconfig || \
    die "***Patch linux config error" && \
      touch ${METADATAMIPSELKERNEL}/linux_defconfig
[ -f ${METADATAMIPSELKERNEL}/linux_cross_build ] || \
  make -j${JOBS} ARCH=mips CROSS_COMPILE=${CROSS_TARGET32}- || \
    die "build cross linux error" && \
      touch ${METADATAMIPSELKERNEL}/linux_cross_build
[ -f ${METADATAMIPSELKERNEL}/linux_cross_install ] || \
  make ARCH=mips CROSS_COMPILE=${CROSS_TARGET32}- \
  INSTALL_MOD_PATH=${PREFIXMIPSELROOTFS} modules_install || \
    die "install cross linux module error" && \
      touch ${METADATAMIPSELKERNEL}/linux_cross_install
[ -f ${METADATAMIPSELKERNEL}/linux_cross_cpvmlinux ] || \
  cp vmlinux ${PREFIXGNULINUX}/vmlinux-o32 || \
    die "cp vmlinux error" && \
      touch ${METADATAMIPSELKERNEL}/linux_cross_cpvmlinux
[ -f ${METADATAMIPSELKERNEL}/linux_cross_cpsystemmap ] || \
  cp System.map ${PREFIXMIPSELROOTFS}/boot/System.map-${LINUX_VERSION} || \
    die "cp System.map error" && \
      touch ${METADATAMIPSELKERNEL}/linux_cross_cpsystemmap
[ -f ${METADATAMIPSELKERNEL}/linux_cross_cpconfig ] || \
  cp .config ${PREFIXMIPSELROOTFS}/boot/config-${LINUX_VERSION} || \
    die "***cp config file error" && \
      touch ${METADATAMIPSELKERNEL}/linux_cross_cpconfig
popd

touch ${METADATAMIPSELKERNEL}/linux_kernel_finished
