#! /bin/bash

source source.sh

[ -d "${BUSYBOXN32_SRC}" ] || mkdir -p "${BUSYBOXN32_SRC}"
[ -d "${BUSYBOXN32_BUILD}" ] || mkdir -p "${BUSYBOXN32_BUILD}"
[ -d "${BUSYBOXN32_METADATA}" ] || mkdir -p "${BUSYBOXN32_METADATA}"

export CC=${BUSYBOXN32_CC}
export CFLAGS=${BUSYBOXN32_CFLAGS}
export CXX=${BUSYBOXN32_CXX}
export CXXFLAGS=${BUSYBOXN32_CXXFLAGS}
export LDFLAGS=${BUSYBOXN32_LDFLAGS}

[ -f ${PREFIXGNU64}/bin/${CC} ] || die "No toolchain found, process error"

#export BUSYBOX_OPTIONS="static dynamic"
export BUSYBOX_OPTIONS="dynamic"

# Begin for loop, build static/dynamic busybox.
for option in ${BUSYBOX_OPTIONS}; do

[ -f ${BUSYBOXN32_METADATA}/busybox-${option}-create ] || \
  mkdir ${BUSYBOXN32_SRC}/busybox-$option || \
    die "busybox-${option}-create dir create failed" && \
      touch ${BUSYBOXN32_METADATA}/busybox-${option}-create

pushd ${BUSYBOXN32_SRC}/busybox-$option
[ -f ${BUSYBOXN32_METADATA}/busybox-${option}-extract ] || \
  tar xvf ${TARBALL}/busybox-${BUSYBOX_VERSION}.${BUSYBOX_SUFFIX} || \
    die "busybox-${option}-extract error" && \
      touch ${BUSYBOXN32_METADATA}/busybox-${option}-extract

cd busybox-${BUSYBOX_VERSION}
[ -f ${BUSYBOXN32_METADATA}/busybox-${option}-patch-busybox-${BUSYBOX_VERSION} ] || \
  patch -Np1 -i ${PATCH}/busybox-${BUSYBOX_VERSION}.patch || \
    die "busybox-${option}-patch-busybox-${BUSYBOX_VERSION} failed" && \
      touch ${BUSYBOXN32_METADATA}/busybox-${option}-patch-busybox-${BUSYBOX_VERSION}
[ -f ${BUSYBOXN32_METADATA}/busybox-${option}-patch-busybox-mipsel-n32-${option}_defconfig ] || \
  patch -Np1 -i ${PATCH}/busybox-mipsel-n32-${option}_defconfig.patch \
    || die "busybox-${option}-patch-busybox-mipsel-n32-${option}_defconfig failed" && \
      touch ${BUSYBOXN32_METADATA}/busybox-${option}-patch-busybox-mipsel-n32-${option}_defconfig
[ -f ${BUSYBOXN32_METADATA}/busybox-${option}-config ] || \
  make mipsel-n32-${option}_defconfig || \
    die "busybox-${option}-config error" && \
      touch ${BUSYBOXN32_METADATA}/busybox-${option}-config
[ -f ${BUSYBOXN32_METADATA}/busybox-${option}-build ] || \
  make -j${JOBS} ARCH=mips CROSS_COMPILE=${CROSS_TARGET64}- || \
    die "busybox-${option}-build error" && \
      touch ${BUSYBOXN32_METADATA}/busybox-${option}-build
[ -f ${BUSYBOXN32_METADATA}/busybox-${option}-install ] || \
  make ARCH=mips CROSS_COMPILE=${CROSS_TARGET64}- install || \
    die "busybox-${option}-install error" && \
      touch ${BUSYBOXN32_METADATA}/busybox-${option}-install
popd

# Make BusyBox Image
pushd ${BUSYBOXN32_SRC}/busybox-$option
dd if=/dev/zero of=${BUSYBOXN32_IMAGE} bs=4k count=512k
echo y | mkfs.ext3 ${BUSYBOXN32_IMAGE}
[ -d "${MOUNT_POINT}" ] || mkdir ${MOUNT_POINT}
sudo mount -o loop ${BUSYBOXN32_IMAGE} ${MOUNT_POINT}

# Build BusyBox File System
cp -ar ${BUSYBOXN32_SRC}/busybox-$option/busybox-${BUSYBOX_VERSION}/_install/* ${MOUNT_POINT}
sudo cp -ar ${BUSYBOXN32_SRC}/busybox-$option/busybox-${BUSYBOX_VERSION}/examples/bootfloppy/etc \
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
mv ${BUSYBOXN32_SRC}/busybox-$option/${BUSYBOXN32_IMAGE} ${PREFIXGNULINUX}
# End for loop, build static/dynamic busybox.
done

