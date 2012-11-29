#! /bin/bash

export JOBS=3


export BZ=tar.bz2
export GZ=tar.gz
export XZ=tar.xz

export BUSYBOX_VERSION=1.20.1
export BUSYBOX_SUFFIX=${BZ}
export LINUX_VERSION=3.3.7
export LINUX_SUFFIX=${XZ}

export SCRIPT="$(pwd)"
export TARBALL=${SCRIPT}/../tarballs
export PATCH=${SCRIPT}/../patches
export SRCS=${SCRIPT}/../srcs

export MOUNT_POINT=busybox_mount

unset CFLAGS
unset CXXFLAGS
export CROSS_HOST=${MACHTYPE}
export CROSS_TARGET64="mips64el-unknown-linux-gnu"
export CROSS_TARGET32="mipsel-unknown-linux-gnu"


export BUILD32="-mabi=32"
export BUILDN32="-mabi=n32"
export BUILD64="-mabi=64"

export PREFIX=${HOME}/sdk_install
export PREFIXGNULINUX=${PREFIX}/gnu-linux
export PREFIXGNU64=${PREFIX}/gnu64
export PREFIXGNU32=${PREFIX}/gnu32
export RTEMSPREFIX64=${PREFIX}/rtems64
export RTEMSPREFIX32=${PREFIX}/rtems32
export BAREPREFIX64=${PREFIX}/elf64
export BAREPREFIX32=${PREFIX}/elf32
export QEMUPREFIX=${PREFIX}/qemu
export LLVMPREFIX=${PREFIX}/llvm
export QTCPREFIX=${PREFIX}/qt-creator

export PATH=${PATH}:${PREFIXGNU64}/bin:${PREFIXGNU32}/bin:${RTEMSPREFIX64}/bin:${RTEMSPREFIX32}/bin:${BAREPREFIX64}/bin:${BAREPREFIX32}/bin
export SYSROOTGNU64=${PREFIXGNU64}/${CROSS_TARGET64}/sys-root/
export SYSROOTGNU32=${PREFIXGNU32}/${CROSS_TARGET32}/sys-root/

function die() {
  echo "$1"
  exit 1
}

function count_back ()
{
    echo "SDK Path Is: ${PREFIX}"

    for ((i = 5; i > 0; i--)); do
        echo -e "\rScript Will Start In $i Second     \c"
        sleep 1;
    done;

    echo -e "\rScript Begin:                                        "
}

###########################################################
# Wait 5 Second and begin script.
###########################################################

count_back

###########################################################
# busybox-mul64.sh
###########################################################

export IMAGEMUL64=busybox-mul64.img

export BUSYBOXMUL64_SRC=${SCRIPT}/../src/busybox-mul64
export BUSYBOXMUL64_BUILD=${SCRIPT}/../build/busybox-mul64
export BUSYBOXMUL64_METADATA=${SCRIPT}/../metadata/busybox-mul64

export BUSYBOXMUL64_CC=${CROSS_TARGET64}-gcc
export BUSYBOXMUL64_CFLAGS="-isystem ${SYSROOTGNU64}/usr/include ${BUILD64}"
export BUSYBOXMUL64_CXX=${CROSS_TARGET64}-g++
export BUSYBOXMUL64_CXXFLAGS="-isystem ${SYSROOTGNU64}/usr/include ${BUILD64}"
export BUSYBOXMUL64_LDFLAGS="-Wl,-rpath-link,${SYSROOTGNU64}/usr/lib64:${SYSROOTGNU64}/lib64 ${BUILD64}"

###########################################################
# busybox-pure64.sh
###########################################################

export IMAGEPURE64=busybox-pure64.img

export BUSYBOXPURE64_SRC=${SCRIPT}/../src/busybox-pure64
export BUSYBOXPURE64_BUILD=${SCRIPT}/../build/busybox-pure64
export BUSYBOXPURE64_METADATA=${SCRIPT}/../metadata/busybox-pure64

export BUSYBOXPURE64_CC=${CROSS_TARGET64}-gcc
export BUSYBOXPURE64_CFLAGS="-isystem ${SYSROOTGNU64}/usr/include ${BUILD64}"
export BUSYBOXPURE64_CXX=${CROSS_TARGET64}-g++
export BUSYBOXPURE64_CXXFLAGS="-isystem ${SYSROOTGNU64}/usr/include ${BUILD64}"
export BUSYBOXPURE64_LDFLAGS="-Wl,-rpath-link,${SYSROOTGNU64}/usr/lib64:${SYSROOTGNU64}/lib64 ${BUILD64}"

###########################################################
# busybox-n32.sh
###########################################################

export BUSYBOXN32_IMAGE=busybox-mipsel-n32.img

export BUSYBOXN32_SRC=${SCRIPT}/../src/busybox-n32
export BUSYBOXN32_BUILD=${SCRIPT}/../build/busybox-n32
export BUSYBOXN32_METADATAN32=${SCRIPT}/../metadata/busybox-n32

export BUSYBOXN32_CC=${CROSS_TARGET64}-gcc
export BUSYBOXN32_CFLAGS="-isystem ${SYSROOTGNU64}/usr/include ${BUILDN32}"
export BUSYBOXN32_CXX=${CROSS_TARGET64}-g++
export BUSYBOXN32_CXXFLAGS="-isystem ${SYSROOTGNU64}/usr/include ${BUILDN32}"
export BUSYBOXN32_LDFLAGS="-Wl,-rpath-link,${SYSROOTGNU64}/usr/lib32:${SYSROOTGNU64}/lib32 ${BUILDN32}"


###########################################################
# busybox-o32.sh
###########################################################

export BUSYBOXO32_IMAGE=busybox-o32.img

export BUSYBOXO32_SRC=${SCRIPT}/../src/busybox-o32
export BUSYBOXO32_BUILD=${SCRIPT}/../build/busybox-o32
export BUSYBOXO32_METADATAN32=${SCRIPT}/../metadata/busybox-o32

export BUSYBOXO32_CC=${CROSS_TARGET32}-gcc
export BUSYBOXO32_CFLAGS="-isystem ${SYSROOTGNU32}/usr/include ${BUILD32}"
export BUSYBOXO32_CXX=${CROSS_TARGET32}-g++
export BUSYBOXO32_CXXFLAGS="-isystem ${SYSROOTGNU32}/usr/include ${BUILD32}"
export BUSYBOXO32_LDFLAGS="-Wl,-rpath-link,${SYSROOTGNU32}/usr/lib:${SYSROOTGNU32}/lib ${BUILD32}"

###########################################################
# kernel-64.sh
###########################################################

export METADATAKERNEL64=${SCRIPT}/../metadata/kernel-64
export SRCKERNEL64=${SCRIPT}/../src/kernel-64
export BUILDKERNEL64=${SCRIPT}/../build/kernel-64

###########################################################
# kernel-n32.sh
###########################################################

export METADATAKERNELN32=${SCRIPT}/../metadata/kernel-n32
export SRCKERNELN32=${SCRIPT}/../src/kernel-n32
export BUILDKERNELN32=${SCRIPT}/../build/kernel-n32

###########################################################
# kernel-o32.sh
###########################################################

export METADATAKERNELO32=${SCRIPT}/../metadata/kernel-o32
export SRCKERNELO32=${SCRIPT}/../src/kernel-o32
export BUILDKERNELO32=${SCRIPT}/../build/kernel-o32



















