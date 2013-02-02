#! /bin/bash

source source.sh

[ -d "${BUILDKERNEL64}" ] || mkdir -p "${BUILDKERNEL64}"
[ -d "${METADATAKERNEL64}" ] || mkdir -p "${METADATAKERNEL64}"
[ -d "${PREFIXGNULINUX}" ] || mkdir -p "${PREFIXGNULINUX}"

export PATH=${PREFIXHOSTTOOLS}/bin:${PREFIXGNU64}/bin:${PATH}
export CC="${CROSS_TARGET64}-gcc"
export CXX="${CROSS_TARGET64}-g++"
export AR="${CROSS_TARGET64}-ar"
export AS="${CROSS_TARGET64}-as"
export RANLIB="${CROSS_TARGET64}-ranlib"
export LD="${CROSS_TARGET64}-ld"
export STRIP="${CROSS_TARGET64}-strip"

[ -f ${PREFIXGNU64}/bin/${CC} ] || die "***No toolchain found, process error"

pushd ${BUILDKERNEL64}
[ -f ${METADATAKERNEL64}/linux_extract ] || \
  tar xf ${TARBALL}/linux-${LINUX_VERSION}.${LINUX_SUFFIX} || \
    die "***extract linux error" && \
      touch ${METADATAKERNEL64}/linux_extract
cd linux-${LINUX_VERSION}
if [ ${HOSTOS} = "Darwin" ]; then
[ -f "${METADATAKERNEL64}/linux_macos_patch" ] || \
  patch -p1 < ${PATCH}/linux-3.7.4-mips-macos.patch || \
    die "***patch linux for macosx error" && \
      touch ${METADATAKERNEL64}/linux_macos_patch
fi
[ -f ${METADATAKERNEL64}/linux_mrpro ] || \
  make mrproper || \
    die "***clean linux error" && \
      touch ${METADATAKERNEL64}/linux_mrpro
[ -f ${METADATAKERNEL64}/linux_config_patch ] || \
  patch -p1 < ${PATCH}/linux-mips64el-multilib-defconfig.patch || \
    die "***Patch linux config error" && \
      touch ${METADATAKERNEL64}/linux_config_patch
[ -f ${METADATAKERNEL64}/linux_mkconfig ] || \
  make ARCH=mips mips64el_multilib_defconfig || \
    die "***make linux defconfig error" && \
      touch ${METADATAKERNEL64}/linux_mkconfig
[ -f ${METADATAKERNEL64}/linux_build ] || \
make -j${JOBS} ARCH=mips CROSS_COMPILE=${CROSS_TARGET64}- CFLAGS=${BUILD64}|| \
  die "***build linux error" && \
      touch ${METADATAKERNEL64}/linux_build
[ -f ${METADATAKERNEL64}/linux_copy_64 ] || \
  cp vmlinux ${PREFIXGNULINUX}/vmlinux-64 || \
    die "***copy 64bit vmlinux error" && \
      touch ${METADATAKERNEL64}/linux_copy_64
[ -f ${METADATAKERNEL64}/linux_copy_n32 ] || \
  cp vmlinux.32 ${PREFIXGNULINUX}/vmlinux-n32 || \
    die "***copy n32 vmlinux error" && \
      touch ${METADATAKERNEL64}/linux_copy_n32
popd
