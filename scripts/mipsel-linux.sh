#! /bin/bash

source source.sh

[ -d "${BUILDKERNELO32}" ] || mkdir -p "${BUILDKERNELO32}"
[ -d "${METADATAKERNELO32}" ] || mkdir -p "${METADATAKERNELO32}"

export PATH=${PREFIXHOSTTOOLS}/bin:${PREFIXGNU64}/bin:${PATH}
export CC="${CROSS_TARGET64}-gcc"
export CXX="${CROSS_TARGET64}-g++"
export AR="${CROSS_TARGET64}-ar"
export AS="${CROSS_TARGET64}-as"
export RANLIB="${CROSS_TARGET64}-ranlib"
export LD="${CROSS_TARGET64}-ld"
export STRIP="${CROSS_TARGET64}-strip"

[ -f ${PREFIXGNU64}/bin/${CC} ] || die "***No toolchain found, process error"

pushd ${BUILDKERNELO32}
[ -f ${METADATAKERNELO32}/linux_extract ] || \
  tar xf ${TARBALL}/linux-${LINUX_VERSION}.${LINUX_SUFFIX} || \
    die "***extract linux error" && \
      touch ${METADATAKERNELO32}/linux_extract
cd linux-${LINUX_VERSION}
if [ ${HOSTOS} = "Darwin" ]; then
[ -f "${METADATAKERNELO32}/linux_macos_patch" ] || \
  patch -p1 < ${PATCH}/linux-3.7.4-mips-macos.patch || \
    die "***patch linux for macosx error" && \
      touch ${METADATAKERNELO32}/linux_macos_patch
fi
[ -f ${METADATAKERNELO32}/linux_mrpro ] || \
  make mrproper || \
    die "***clean cross linux error" && \
      touch ${METADATAKERNELO32}/linux_mrpro
[ -f ${METADATAKERNELO32}/linux_config_patch ] || \
  patch -p1 < ${PATCH}/linux-mipsel-sysroot-defconfig.patch || \
    die "***Patch linux config error" && \
      touch ${METADATAKERNELO32}/linux_config_patch
[ -f ${METADATAKERNELO32}/linux_mkconfig ] || \
  make ARCH=mips mipsel_sysroot_defconfig || \
    die "***make linux defconfig error" && \
      touch ${METADATAKERNELO32}/linux_mkconfig
[ -f ${METADATAKERNELO32}/linux_build ] || \
make -j${JOBS} ARCH=mips CROSS_COMPILE=${CROSS_TARGET64}- || \
  die "***build linux error" && \
      touch ${METADATAKERNELO32}/linux_build
[ -f ${METADATAKERNELO32}/linux_copy ] || \
  cp vmlinux ${PREFIXGNULINUX}/vmlinux-o32 || \
    die "***copy vmlinux error" && \
      touch ${METADATAKERNELO32}/linux_copy
popd
