#! /bin/bash

source source.sh

[ -d "${BUSYBOXMUL64_SRC}" ] || mkdir -p "${BUSYBOXMUL64_SRC}"
[ -d "${BUSYBOXMUL64_BUILD}" ] || mkdir -p "${BUSYBOXMUL64_BUILD}"
[ -d "${BUSYBOXMUL64_METADATA}" ] || mkdir -p "${BUSYBOXMUL64_METADATA}"

export CC=${BUSYBOXMUL64_CC}
export CFLAGS=${BUSYBOXMUL64_CFLAGS}
export CXX=${BUSYBOXMUL64_CXX}
export CXXFLAGS=${BUSYBOXMUL64_CXXFLAGS}
export LDFLAGS=${BUSYBOXMUL64_LDFLAGS}

[ -f ${PREFIXGNU64}/bin/${CC} ] || die "No toolchain found, process error"

export BUSYBOX_OPTIONS="dynamic"

# Begin for loop, build static/dynamic busybox.
for option in ${BUSYBOX_OPTIONS}; do

[ -f ${BUSYBOXMUL64_METADATA}/busybox-${option}-create ] || \
  mkdir ${BUSYBOXMUL64_SRC}/busybox-$option || \
    die "busybox-${option}-create dir create failed" && \
      touch ${BUSYBOXMUL64_METADATA}/busybox-${option}-create

pushd ${BUSYBOXMUL64_SRC}/busybox-$option
[ -f ${BUSYBOXMUL64_METADATA}/busybox-${option}-extract ] || \
  tar xf ${TARBALL}/busybox-${BUSYBOX_VERSION}.${BUSYBOX_SUFFIX} || \
    die "busybox-${option}-extract error" && \
      touch ${BUSYBOXMUL64_METADATA}/busybox-${option}-extract

cd busybox-${BUSYBOX_VERSION}
[ -f ${BUSYBOXMUL64_METADATA}/busybox-${option}-patch-busybox-${BUSYBOX_VERSION} ] || \
  patch -Np1 -i ${PATCH}/busybox-${BUSYBOX_VERSION}.patch || \
    die "Patch failed" && \
      touch ${BUSYBOXMUL64_METADATA}/busybox-${option}-patch-busybox-${BUSYBOX_VERSION}
[ -f ${BUSYBOXMUL64_METADATA}/busybox-${option}-patch-busybox-mips64el-${option}_defconfig ] || \
  patch -Np1 -i ${PATCH}/busybox-mips64el-${option}_defconfig.patch \
    || die "Patch failed" && \
      touch ${BUSYBOXMUL64_METADATA}/busybox-${option}-patch-busybox-mips64el-${option}_defconfig
[ -f ${BUSYBOXMUL64_METADATA}/busybox-${option}-config ] || \
  make mips64el-${option}_defconfig || \
    die "busybox-${option}-config error" && \
      touch ${BUSYBOXMUL64_METADATA}/busybox-${option}-config
[ -f ${BUSYBOXMUL64_METADATA}/busybox-${option}-build ] || \
  make -j${JOBS} ARCH=mips CROSS_COMPILE=${CROSS_TARGET64}- || \
    die "busybox-${option}-build error" && \
      touch ${BUSYBOXMUL64_METADATA}/busybox-${option}-build
[ -f ${BUSYBOXMUL64_METADATA}/busybox-${option}-install ] || \
  make ARCH=mips CROSS_COMPILE=${CROSS_TARGET64}- install || \
    die "busybox-${option}-install error" && \
      touch ${BUSYBOXMUL64_METADATA}/busybox-${option}-install
popd

# Make BusyBox Image
pushd ${BUSYBOXMUL64_SRC}/busybox-$option
dd if=/dev/zero of=${IMAGEMUL64} bs=4k count=512k
echo y | mkfs.ext3 ${IMAGEMUL64}
[ -d "${MOUNT_POINT}" ] || mkdir ${MOUNT_POINT}
sudo mount -o loop ${IMAGEMUL64} ${MOUNT_POINT}

# Build BusyBox File System
cp -ar ${BUSYBOXMUL64_SRC}/busybox-$option/busybox-${BUSYBOX_VERSION}/_install/* ${MOUNT_POINT}
sudo cp -ar ${BUSYBOXMUL64_SRC}/busybox-$option/busybox-${BUSYBOX_VERSION}/examples/bootfloppy/etc \
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
if [ -d ${SYSROOTGNU64}/lib ]; then
    cp -ar ${SYSROOTGNU64}/lib ${MOUNT_POINT}/
fi

if [ -d ${SYSROOTGNU64}/lib32 ]; then
    cp -ar ${SYSROOTGNU64}/lib32 ${MOUNT_POINT}/
fi

if [ -d ${SYSROOTGNU64}/lib64 ]; then
    cp -ar ${SYSROOTGNU64}/lib64 ${MOUNT_POINT}/
fi

sudo echo "/bin/mount -o remount,rw /" >> ${MOUNT_POINT}/etc/init.d/rcS
sudo umount ${MOUNT_POINT}

popd

[ -d ${PREFIXGNULINUX} ] || mkdir -p ${PREFIXGNULINUX}
mv ${BUSYBOXMUL64_SRC}/busybox-$option/${IMAGEMUL64} ${PREFIXGNULINUX}
# End for loop, build static/dynamic busybox.
done
