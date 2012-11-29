#! /bin/bash

source source.sh

[ -d "${BUSYBOXO32_SRC}" ] || mkdir -p "${BUSYBOXO32_SRC}"
[ -d "${BUSYBOXO32_BUILD}" ] || mkdir -p "${BUSYBOXO32_BUILD}"
[ -d "${BUSYBOXO32_METADATA}" ] || mkdir -p "${BUSYBOXO32_METADATA}"

export CC=${BUSYBOXO32_CC}
export CFLAGS=${BUSYBOXO32_CFLAGS}
export CXX=${BUSYBOXO32_CXX}
export CXXFLAGS=${BUSYBOXO32_CXXFLAGS}
export LDFLAGS=${BUSYBOXO32_LDFLAGS}

[ -f ${PREFIXGNU32}/bin/${CC} ] || die "No toolchain found, process error"

#export BUSYBOX_OPTIONS="static dynamic"
export BUSYBOX_OPTIONS="dynamic"

# Begin for loop, build static/dynamic busybox.
for option in ${BUSYBOX_OPTIONS}; do

[ -f ${BUSYBOXO32_METADATA}/busybox-${option}-create ] || \
  mkdir ${BUSYBOXO32_SRC}/busybox-$option || \
    die "busybox-${option}-create dir create failed" && \
      touch ${BUSYBOXO32_METADATA}/busybox-${option}-create

pushd ${BUSYBOXO32_SRC}/busybox-$option
[ -f ${BUSYBOXO32_METADATA}/busybox-${option}-extract ] || \
  tar xvf ${TARBALL}/busybox-${BUSYBOX_VERSION}.${BUSYBOX_SUFFIX} || \
    die "busybox-${option}-extract error" && \
      touch ${BUSYBOXO32_METADATA}/busybox-${option}-extract

cd busybox-${BUSYBOX_VERSION}
[ -f ${BUSYBOXO32_METADATA}/busybox-${option}-patch-busybox-${BUSYBOX_VERSION} ] || \
  patch -Np1 -i ${PATCH}/busybox-${BUSYBOX_VERSION}.patch || \
    die "Patch failed" && \
      touch ${BUSYBOXO32_METADATA}/busybox-${option}-patch-busybox-${BUSYBOX_VERSION}
[ -f ${BUSYBOXO32_METADATA}/busybox-${option}-patch-busybox-mipsel-${option}_defconfig ] || \
  patch -Np1 -i ${PATCH}/busybox-mipsel-${option}_defconfig.patch \
    || die "Patch failed" && \
      touch ${BUSYBOXO32_METADATA}/busybox-${option}-patch-busybox-mipsel-${option}_defconfig
[ -f ${BUSYBOXO32_METADATA}/busybox-${option}-config ] || \
  make mipsel-${option}_defconfig || \
    die "busybox-${option}-config error" && \
      touch ${BUSYBOXO32_METADATA}/busybox-${option}-config
[ -f ${BUSYBOXO32_METADATA}/busybox-${option}-build ] || \
  make -j${JOBS} ARCH=mips CROSS_COMPILE=${CROSS_TARGET32}- || \
    die "busybox-${option}-build error" && \
      touch ${BUSYBOXO32_METADATA}/busybox-${option}-build
[ -f ${BUSYBOXO32_METADATA}/busybox-${option}-install ] || \
  make ARCH=mips CROSS_COMPILE=${CROSS_TARGET32}- install || \
    die "busybox-${option}-install error" && \
      touch ${BUSYBOXO32_METADATA}/busybox-${option}-install
popd

# Make BusyBox Image
pushd ${BUSYBOXO32_SRC}/busybox-$option
dd if=/dev/zero of=${BUSYBOXO32_IMAGE} bs=4k count=512k
echo y | mkfs.ext3 ${BUSYBOXO32_IMAGE}
[ -d "${MOUNT_POINT}" ] || mkdir ${MOUNT_POINT}
sudo mount -o loop ${BUSYBOXO32_IMAGE} ${MOUNT_POINT}

# Build BusyBox File System
cp -ar ${BUSYBOXO32_SRC}/busybox-$option/busybox-${BUSYBOX_VERSION}/_install/* ${MOUNT_POINT}
sudo cp -ar ${BUSYBOXO32_SRC}/busybox-$option/busybox-${BUSYBOX_VERSION}/examples/bootfloppy/etc \
  ${MOUNT_POINT}/
mkdir ${MOUNT_POINT}/dev
mkdir ${MOUNT_POINT}/proc

sudo cp -a /dev/zero ${MOUNT_POINT}/dev/
sudo cp -a /dev/console ${MOUNT_POINT}/dev/
sudo cp -a /dev/null ${MOUNT_POINT}/dev/
sudo cp -a /dev/tty ${MOUNT_POINT}/dev/
sudo cp -a /dev/tty2 ${MOUNT_POINT}/dev/
sudo cp -a /dev/ttyS0 ${MOUNT_POINT}/dev/

# Copy Library to File System
if [ -d ${SYSROOTGNU32}/lib ]; then
    cp -ar ${SYSROOTGNU32}/lib ${MOUNT_POINT}/
fi

sudo echo "/bin/mount -o remount,rw /" >> ${MOUNT_POINT}/etc/init.d/rcS
sudo umount ${MOUNT_POINT}

popd

[ -d ${PREFIXGNULINUX} ] || mkdir -p ${PREFIXGNULINUX}
mv ${BUSYBOXO32_SRC}/busybox-$option/${BUSYBOXO32_IMAGE} ${PREFIXGNULINUX}
# End for loop, build static/dynamic busybox.
done

