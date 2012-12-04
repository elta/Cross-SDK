#! /bin/bash

source source.sh

[ -d "${SRCBUSYBOXN32}" ] || mkdir -p "${SRCBUSYBOXN32}"
[ -d "${BUILDBUSYBOXN32}" ] || mkdir -p "${BUILDBUSYBOXN32}"
[ -d "${METADATABUSYBOXN32}" ] || mkdir -p "${METADATABUSYBOXN32}"

[ -f ${PREFIXGNU64}/bin/${CC} ] || die "No toolchain found, process error"

export PATH=${PATH}:${PREFIXGNU64}/bin

export CC=${CROSS_TARGET64}-gcc
export CFLAGS="-isystem ${SYSROOTGNU64}/usr/include ${BUILDN32}"
export CXX=${CROSS_TARGET64}-g++
export CXXFLAGS="-isystem ${SYSROOTGNU64}/usr/include ${BUILDN32}"
export LDFLAGS="-Wl,-rpath-link,${SYSROOTGNU64}/usr/lib32:${SYSROOTGNU64}/lib32 ${BUILDN32}"

#export BUSYBOX_OPTIONS="static dynamic"
export BUSYBOX_OPTIONS="dynamic"

# Begin for loop, build static/dynamic busybox.
for option in ${BUSYBOX_OPTIONS}; do

[ -f ${METADATABUSYBOXN32}/busybox-${option}-create ] || \
  mkdir ${SRCBUSYBOXN32}/busybox-$option || \
    die "busybox-${option}-create dir create failed" && \
      touch ${METADATABUSYBOXN32}/busybox-${option}-create

pushd ${SRCBUSYBOXN32}/busybox-$option
[ -f ${METADATABUSYBOXN32}/busybox-${option}-extract ] || \
  tar xvf ${TARBALL}/busybox-${BUSYBOX_VERSION}.${BUSYBOX_SUFFIX} || \
    die "busybox-${option}-extract error" && \
      touch ${METADATABUSYBOXN32}/busybox-${option}-extract

cd busybox-${BUSYBOX_VERSION}
[ -f ${METADATABUSYBOXN32}/busybox-${option}-patch-busybox-${BUSYBOX_VERSION} ] || \
  patch -Np1 -i ${PATCH}/busybox-${BUSYBOX_VERSION}.patch || \
    die "busybox-${option}-patch-busybox-${BUSYBOX_VERSION} failed" && \
      touch ${METADATABUSYBOXN32}/busybox-${option}-patch-busybox-${BUSYBOX_VERSION}
[ -f ${METADATABUSYBOXN32}/busybox-${option}-patch-busybox-mipsel-n32-${option}_defconfig ] || \
  patch -Np1 -i ${PATCH}/busybox-mipsel-n32-${option}_defconfig.patch \
    || die "busybox-${option}-patch-busybox-mipsel-n32-${option}_defconfig failed" && \
      touch ${METADATABUSYBOXN32}/busybox-${option}-patch-busybox-mipsel-n32-${option}_defconfig
[ -f ${METADATABUSYBOXN32}/busybox-${option}-config ] || \
  make mipsel-n32-${option}_defconfig || \
    die "busybox-${option}-config error" && \
      touch ${METADATABUSYBOXN32}/busybox-${option}-config
[ -f ${METADATABUSYBOXN32}/busybox-${option}-build ] || \
  make -j${JOBS} ARCH=mips CROSS_COMPILE=${CROSS_TARGET64}- || \
    die "busybox-${option}-build error" && \
      touch ${METADATABUSYBOXN32}/busybox-${option}-build
[ -f ${METADATABUSYBOXN32}/busybox-${option}-install ] || \
  make ARCH=mips CROSS_COMPILE=${CROSS_TARGET64}- install || \
    die "busybox-${option}-install error" && \
      touch ${METADATABUSYBOXN32}/busybox-${option}-install
popd

# Make BusyBox Image
pushd ${SRCBUSYBOXN32}/busybox-$option
dd if=/dev/zero of=${BUSYBOXN32_IMAGE} bs=4k count=512k
echo y | mkfs.ext3 ${BUSYBOXN32_IMAGE}
[ -d "${MOUNT_POINT}" ] || mkdir ${MOUNT_POINT}
sudo mount -o loop ${BUSYBOXN32_IMAGE} ${MOUNT_POINT}

# Build BusyBox File System
cp -ar ${SRCBUSYBOXN32}/busybox-$option/busybox-${BUSYBOX_VERSION}/_install/* ${MOUNT_POINT}
sudo cp -ar ${SRCBUSYBOXN32}/busybox-$option/busybox-${BUSYBOX_VERSION}/examples/bootfloppy/etc \
  ${MOUNT_POINT}/
mkdir ${MOUNT_POINT}/dev
mkdir ${MOUNT_POINT}/proc

sudo cp -a /dev/zero ${MOUNT_POINT}/dev/
sudo cp -a /dev/console ${MOUNT_POINT}/dev/
sudo cp -a /dev/null ${MOUNT_POINT}/dev/
sudo cp -a /dev/tty ${MOUNT_POINT}/dev/
sudo cp -a /dev/tty2 ${MOUNT_POINT}/dev/
sudo cp -a /dev/ttyS0 ${MOUNT_POINT}/dev/

if [ -d ${SYSROOTGNU64}/lib32 ]; then
    cp -ar ${SYSROOTGNU64}/lib32 ${MOUNT_POINT}/
fi

sudo echo "/bin/mount -o remount,rw /" >> ${MOUNT_POINT}/etc/init.d/rcS
sudo umount ${MOUNT_POINT}

popd

[ -d ${PREFIXGNULINUX} ] || mkdir -p ${PREFIXGNULINUX}
mv ${SRCBUSYBOXN32}/busybox-$option/${BUSYBOXN32_IMAGE} ${PREFIXGNULINUX}
# End for loop, build static/dynamic busybox.
done

