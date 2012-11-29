#! /bin/bash

source source.sh

[ -d "${BUSYBOXPURE64_SRC}" ] || mkdir -p "${BUSYBOXPURE64_SRC}"
[ -d "${BUSYBOXPURE64_BUILD}" ] || mkdir -p "${BUSYBOXPURE64_BUILD}"
[ -d "${BUSYBOXPURE64_METADATA}" ] || mkdir -p "${BUSYBOXPURE64_METADATA}"

export CC=${BUSYBOXPURE64_CC}
export CFLAGS=${BUSYBOXPURE64_CFLAGS}
export CXX=${BUSYBOXPURE64_CXX}
export CXXFLAGS=${BUSYBOXPURE64_CXXFLAGS}
export LDFLAGS=${BUSYBOXPURE64_LDFLAGS}

[ -f ${PREFIXGNU64}/bin/${CC} ] || die "No toolchain found, process error"

#export BUSYBOX_OPTIONS="static dynamic"
export BUSYBOX_OPTIONS="dynamic"

# Begin for loop, build static/dynamic busybox.
for option in ${BUSYBOX_OPTIONS}; do

[ -f ${BUSYBOXPURE64_METADATA}/busybox-${option}-create ] || \
  mkdir ${BUSYBOXPURE64_SRC}/busybox-$option || \
    die "busybox-${option}-create dir create failed" && \
      touch ${BUSYBOXPURE64_METADATA}/busybox-${option}-create

pushd ${BUSYBOXPURE64_SRC}/busybox-$option
[ -f ${BUSYBOXPURE64_METADATA}/busybox-${option}-extract ] || \
  tar xvf ${TARBALL}/busybox-${BUSYBOX_VERSION}.${BUSYBOX_SUFFIX} || \
    die "busybox-${option}-extract error" && \
      touch ${BUSYBOXPURE64_METADATA}/busybox-${option}-extract

cd busybox-${BUSYBOX_VERSION}
[ -f ${BUSYBOXPURE64_METADATA}/busybox-${option}-patch-busybox-${BUSYBOX_VERSION} ] || \
  patch -Np1 -i ${PATCH}/busybox-${BUSYBOX_VERSION}.patch || \
    die "Patch failed" && \
      touch ${BUSYBOXPURE64_METADATA}/busybox-${option}-patch-busybox-${BUSYBOX_VERSION}
[ -f ${BUSYBOXPURE64_METADATA}/busybox-${option}-patch-busybox-mips64el-${option}_defconfig ] || \
  patch -Np1 -i ${PATCH}/busybox-mips64el-${option}_defconfig.patch \
    || die "Patch failed" && \
      touch ${BUSYBOXPURE64_METADATA}/busybox-${option}-patch-busybox-mips64el-${option}_defconfig

[ -f ${BUSYBOXPURE64_METADATA}/busybox-${option}-config ] || \
  make mips64el-${option}_defconfig || \
    die "busybox-${option}-config error" && \
      touch ${BUSYBOXPURE64_METADATA}/busybox-${option}-config
[ -f ${BUSYBOXPURE64_METADATA}/busybox-${option}-build ] || \
  make -j${JOBS} ARCH=mips CROSS_COMPILE=${CROSS_TARGET64}- || \
    die "busybox-${option}-build error" && \
      touch ${BUSYBOXPURE64_METADATA}/busybox-${option}-build
[ -f ${BUSYBOXPURE64_METADATA}/busybox-${option}-install ] || \
  make ARCH=mips CROSS_COMPILE=${CROSS_TARGET64}- install || \
    die "busybox-${option}-install error" && \
      touch ${BUSYBOXPURE64_METADATA}/busybox-${option}-install
popd

# Make BusyBox Image
pushd ${BUSYBOXPURE64_SRC}/busybox-$option
dd if=/dev/zero of=${IMAGEPURE64} bs=4k count=512k
echo y | mkfs.ext3 ${IMAGEPURE64}
[ -d "${MOUNT_POINT}" ] || mkdir ${MOUNT_POINT}
sudo mount -o loop ${IMAGEPURE64} ${MOUNT_POINT}

# Build BusyBox File System
cp -ar ${BUSYBOXPURE64_SRC}/busybox-$option/busybox-${BUSYBOX_VERSION}/_install/* ${MOUNT_POINT}
sudo cp -ar ${BUSYBOXPURE64_SRC}/busybox-$option/busybox-${BUSYBOX_VERSION}/examples/bootfloppy/etc \
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
mv ${BUSYBOXPURE64_SRC}/busybox-$option/${IMAGEPURE64} ${PREFIXGNULINUX}
# End for loop, build static/dynamic busybox.
done

