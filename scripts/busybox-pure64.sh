#! /bin/bash

source source.sh

[ -d "${SRCBUSYBOXPURE64}" ] || mkdir -p "${SRCBUSYBOXPURE64}"
[ -d "${BUILDBUSYBOXPURE64}" ] || mkdir -p "${BUILDBUSYBOXPURE64}"
[ -d "${METADATABUSYBOXPURE64}" ] || mkdir -p "${METADATABUSYBOXPURE64}"

[ -f ${PREFIXGNU64}/bin/${CC} ] || die "No toolchain found, process error"

export PATH=${PATH}:${PREFIXGNU64}/bin

export CC=${CROSS_TARGET64}-gcc
export CFLAGS="-isystem ${SYSROOTGNU64}/usr/include ${BUILD64}"
export CXX=${CROSS_TARGET64}-g++
export CXXFLAGS="-isystem ${SYSROOTGNU64}/usr/include ${BUILD64}"
export LDFLAGS="-Wl,-rpath-link,${SYSROOTGNU64}/usr/lib64:${SYSROOTGNU64}/lib64 ${BUILD64}"

#export BUSYBOX_OPTIONS="static dynamic"
export BUSYBOX_OPTIONS="dynamic"

# Begin for loop, build static/dynamic busybox.
for option in ${BUSYBOX_OPTIONS}; do

[ -f ${METADATABUSYBOXPURE64}/busybox-${option}-create ] || \
  mkdir ${SRCBUSYBOXPURE64}/busybox-$option || \
    die "busybox-${option}-create dir create failed" && \
      touch ${METADATABUSYBOXPURE64}/busybox-${option}-create

pushd ${SRCBUSYBOXPURE64}/busybox-$option
[ -f ${METADATABUSYBOXPURE64}/busybox-${option}-extract ] || \
  tar xvf ${TARBALL}/busybox-${BUSYBOX_VERSION}.${BUSYBOX_SUFFIX} || \
    die "busybox-${option}-extract error" && \
      touch ${METADATABUSYBOXPURE64}/busybox-${option}-extract

cd busybox-${BUSYBOX_VERSION}
[ -f ${METADATABUSYBOXPURE64}/busybox-${option}-patch-busybox-${BUSYBOX_VERSION} ] || \
  patch -Np1 -i ${PATCH}/busybox-${BUSYBOX_VERSION}.patch || \
    die "Patch failed" && \
      touch ${METADATABUSYBOXPURE64}/busybox-${option}-patch-busybox-${BUSYBOX_VERSION}
[ -f ${METADATABUSYBOXPURE64}/busybox-${option}-patch-busybox-mips64el-${option}_defconfig ] || \
  patch -Np1 -i ${PATCH}/busybox-mips64el-${option}_defconfig.patch \
    || die "Patch failed" && \
      touch ${METADATABUSYBOXPURE64}/busybox-${option}-patch-busybox-mips64el-${option}_defconfig

[ -f ${METADATABUSYBOXPURE64}/busybox-${option}-config ] || \
  make mips64el-${option}_defconfig || \
    die "busybox-${option}-config error" && \
      touch ${METADATABUSYBOXPURE64}/busybox-${option}-config
[ -f ${METADATABUSYBOXPURE64}/busybox-${option}-build ] || \
  make -j${JOBS} ARCH=mips CROSS_COMPILE=${CROSS_TARGET64}- || \
    die "busybox-${option}-build error" && \
      touch ${METADATABUSYBOXPURE64}/busybox-${option}-build
[ -f ${METADATABUSYBOXPURE64}/busybox-${option}-install ] || \
  make ARCH=mips CROSS_COMPILE=${CROSS_TARGET64}- install || \
    die "busybox-${option}-install error" && \
      touch ${METADATABUSYBOXPURE64}/busybox-${option}-install
popd

# Make BusyBox Image
pushd ${SRCBUSYBOXPURE64}/busybox-$option
dd if=/dev/zero of=${BUSYBOXPURE64_IMAGE} bs=4k count=512k
echo y | mkfs.ext3 ${BUSYBOXPURE64_IMAGE}
[ -d "${MOUNT_POINT}" ] || mkdir ${MOUNT_POINT}
sudo mount -o loop ${BUSYBOXPURE64_IMAGE} ${MOUNT_POINT}

# Build BusyBox File System
cp -ar ${SRCBUSYBOXPURE64}/busybox-$option/busybox-${BUSYBOX_VERSION}/_install/* ${MOUNT_POINT}
sudo cp -ar ${SRCBUSYBOXPURE64}/busybox-$option/busybox-${BUSYBOX_VERSION}/examples/bootfloppy/etc \
  ${MOUNT_POINT}/
mkdir ${MOUNT_POINT}/dev
mkdir ${MOUNT_POINT}/proc

sudo cp -a /dev/zero ${MOUNT_POINT}/dev/
sudo cp -a /dev/console ${MOUNT_POINT}/dev/
sudo cp -a /dev/null ${MOUNT_POINT}/dev/
sudo cp -a /dev/tty ${MOUNT_POINT}/dev/
sudo cp -a /dev/tty2 ${MOUNT_POINT}/dev/
sudo cp -a /dev/ttyS0 ${MOUNT_POINT}/dev/

if [ -d ${SYSROOTGNU64}/lib64 ]; then
    cp -ar ${SYSROOTGNU64}/lib64 ${MOUNT_POINT}/
fi

sudo echo "/bin/mount -o remount,rw /" >> ${MOUNT_POINT}/etc/init.d/rcS
sudo umount ${MOUNT_POINT}

popd

[ -d ${PREFIXGNULINUX} ] || mkdir -p ${PREFIXGNULINUX}
mv ${SRCBUSYBOXPURE64}/busybox-$option/${BUSYBOXPURE64_IMAGE} ${PREFIXGNULINUX}
# End for loop, build static/dynamic busybox.
done

