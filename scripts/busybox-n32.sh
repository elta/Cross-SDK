#! /bin/bash

export JOBS=16


export BZ=tar.bz2
export GZ=tar.gz
export XZ=tar.xz

export BUSYBOX_VERSION=1.20.1
export BUSYBOX_SUFFIX=${BZ}

export IMAGE=busybox-mipsel-n32.img
export MOUNT_POINT=busybox_mount

function die() {
  echo "$1"
  exit 1
}

export SCRIPT="$(pwd)"
export TARBALL=${SCRIPT}/../tarballs
export PATCH=${SCRIPT}/../patches
export CONFIG=${SCRIPT}/../configs
export SRCS=${SCRIPT}/../srcs
export SRC=${SCRIPT}/../src/busybox-n32
export BUILD=${SCRIPT}/../build/busybox-n32
export METADATAN32=${SCRIPT}/../metadata/busybox-n32

[ -d "${SRC}" ] || mkdir -p "${SRC}"
[ -d "${BUILD}" ] || mkdir -p "${BUILD}"
[ -d "${METADATAN32}" ] || mkdir -p "${METADATAN32}"

unset CFLAGS
unset CXXFLAGS
unset BUILDFLAG
export CROSS_HOST=${MACHTYPE}
export CROSS_TARGET="mips64el-unknown-linux-gnu"

[[ $# -eq 1 ]] || die "usage: $0 PREFIX"
export PREFIX="$1"
export PREFIX64=${PREFIX}/gnu64
export PREFIXGNULINUX=${PREFIX}/gnu-linux
export PATH=${PATH}:${PREFIX64}/bin
export SYSROOT=${PREFIX64}/${CROSS_TARGET}/sys-root/

# Change ABI, Change libdir (LIB).
export ABI=n32
export BUILDFLAG="-mabi=${ABI}"
export LIB=lib32

export CC=${CROSS_TARGET}-gcc
export CFLAGS="-isystem ${SYSROOT}/usr/include ${BUILDFLAG}"
export CXX=${CROSS_TARGET}-g++
export CXXFLAGS="-isystem ${SYSROOT}/usr/include ${BUILDFLAG}"
export LDFLAGS="-Wl,-rpath-link,${SYSROOT}/usr/${LIB}:${SYSROOT}/${LIB} ${BUILDFLAG}"

#export BUSYBOX_OPTIONS="static dynamic"
export BUSYBOX_OPTIONS="dynamic"

# Begin for loop, build static/dynamic busybox.
for option in ${BUSYBOX_OPTIONS}; do

[ -f ${METADATAN32}/busybox-${option}-create ] || \
  mkdir ${SRC}/busybox-$option || \
    die "busybox-${option}-create dir create failed" && \
      touch ${METADATAN32}/busybox-${option}-create

pushd ${SRC}/busybox-$option
[ -f ${METADATAN32}/busybox-${option}-extract ] || \
  tar xvf ${TARBALL}/busybox-${BUSYBOX_VERSION}.${BUSYBOX_SUFFIX} || \
    die "busybox-${option}-extract error" && \
      touch ${METADATAN32}/busybox-${option}-extract

cd busybox-${BUSYBOX_VERSION}
[ -f ${METADATAN32}/busybox-${option}-patch-busybox-${BUSYBOX_VERSION} ] || \
  patch -Np1 -i ${PATCH}/busybox-${BUSYBOX_VERSION}.patch || \
    die "busybox-${option}-patch-busybox-${BUSYBOX_VERSION} failed" && \
      touch ${METADATAN32}/busybox-${option}-patch-busybox-${BUSYBOX_VERSION}
[ -f ${METADATAN32}/busybox-${option}-patch-busybox-mipsel-n32-${option}_defconfig ] || \
  patch -Np1 -i ${PATCH}/busybox-mipsel-n32-${option}_defconfig.patch \
    || die "busybox-${option}-patch-busybox-mipsel-n32-${option}_defconfig failed" && \
      touch ${METADATAN32}/busybox-${option}-patch-busybox-mipsel-n32-${option}_defconfig
[ -f ${METADATAN32}/busybox-${option}-config ] || \
  make mipsel-n32-${option}_defconfig || \
    die "busybox-${option}-config error" && \
      touch ${METADATAN32}/busybox-${option}-config
[ -f ${METADATAN32}/busybox-${option}-build ] || \
  make -j${JOBS} ARCH=mips CROSS_COMPILE=${CROSS_TARGET}- || \
    die "busybox-${option}-build error" && \
      touch ${METADATAN32}/busybox-${option}-build
[ -f ${METADATAN32}/busybox-${option}-install ] || \
  make ARCH=mips CROSS_COMPILE=${CROSS_TARGET}- install || \
    die "busybox-${option}-install error" && \
      touch ${METADATAN32}/busybox-${option}-install
popd

# Make BusyBox Image
pushd ${SRC}/busybox-$option
dd if=/dev/zero of=${IMAGE} bs=4k count=512k
echo y | mkfs.ext3 ${IMAGE}
[ -d "${MOUNT_POINT}" ] || mkdir ${MOUNT_POINT}
sudo mount -o loop ${IMAGE} ${MOUNT_POINT}

# Build BusyBox File System
cp -ar ${SRC}/busybox-$option/busybox-${BUSYBOX_VERSION}/_install/* ${MOUNT_POINT}
sudo cp -ar ${SRC}/busybox-$option/busybox-${BUSYBOX_VERSION}/examples/bootfloppy/etc \
  ${MOUNT_POINT}/
mkdir ${MOUNT_POINT}/dev
mkdir ${MOUNT_POINT}/proc

sudo cp -a /dev/zero ${MOUNT_POINT}/dev/
sudo cp -a /dev/console ${MOUNT_POINT}/dev/
sudo cp -a /dev/null ${MOUNT_POINT}/dev/
sudo cp -a /dev/tty ${MOUNT_POINT}/dev/
sudo cp -a /dev/tty2 ${MOUNT_POINT}/dev/
sudo cp -a /dev/ttyS0 ${MOUNT_POINT}/dev/

if [ -d ${SYSROOT}/lib32 ]; then
    cp -ar ${SYSROOT}/lib32 ${MOUNT_POINT}/
fi

sudo echo "/bin/mount -o remount,rw /" >> ${MOUNT_POINT}/etc/init.d/rcS
sudo umount ${MOUNT_POINT}

popd

[ -d ${PREFIXGNULINUX} ] || mkdir -p ${PREFIXGNULINUX}
mv ${SRC}/busybox-$option/${IMAGE} ${PREFIXGNULINUX}
# End for loop, build static/dynamic busybox.
done

