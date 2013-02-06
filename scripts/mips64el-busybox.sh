#! /bin/bash

source source.env

export PATH=${PREFIXHOSTTOOLS}/bin:${PREFIXGNU64}/bin:${PATH}
export CC=${CROSS_TARGET64}-gcc
export CFLAGS="-isystem ${SYSROOTGNU64}/usr/include ${BUILD64}"
export CXX=${CROSS_TARGET64}-g++
export CXXFLAGS="-isystem ${SYSROOTGNU64}/usr/include ${BUILD64}"
export LDFLAGS="-Wl,-rpath-link,${SYSROOTGNU64}/usr/lib64:${SYSROOTGNU64}/lib64 ${BUILD64}"

[ -d "${SRCBUSYBOXMUL64}" ] || mkdir -p "${SRCBUSYBOXMUL64}"
[ -d "${BUILDBUSYBOXMUL64}" ] || mkdir -p "${BUILDBUSYBOXMUL64}"
[ -d "${METADATABUSYBOXMUL64}" ] || mkdir -p "${METADATABUSYBOXMUL64}"

[ -f ${PREFIXGNU64}/bin/${CC} ] || die "No toolchain found, process error"

export BUSYBOX_OPTIONS="dynamic"

# Begin for loop, build static/dynamic busybox.
for option in ${BUSYBOX_OPTIONS}; do

[ -f ${METADATABUSYBOXMUL64}/busybox-${option}-create ] || \
  mkdir ${SRCBUSYBOXMUL64}/busybox-$option || \
    die "busybox-${option}-create dir create failed" && \
      touch ${METADATABUSYBOXMUL64}/busybox-${option}-create

pushd ${SRCBUSYBOXMUL64}/busybox-$option
[ -f ${METADATABUSYBOXMUL64}/busybox-${option}-extract ] || \
  tar xf ${TARBALL}/busybox-${BUSYBOX_VERSION}.${BUSYBOX_SUFFIX} || \
    die "busybox-${option}-extract error" && \
      touch ${METADATABUSYBOXMUL64}/busybox-${option}-extract

cd busybox-${BUSYBOX_VERSION}
if [ ${HOSTOS} = "Darwin" ]; then
[ -f ${METADATABUSYBOXMUL64}/busybox-1.20.2-macos.patch ] || \
  patch -Np1 -i ${PATCH}/busybox-${BUSYBOX_VERSION}-macos.patch || \
    die "Patch for MacOS failed" && \
      touch ${METADATABUSYBOXMUL64}/busybox-1.20.2-macos.patch
fi
[ -f ${METADATABUSYBOXMUL64}/busybox-${option}-patch-busybox-${BUSYBOX_VERSION} ] || \
  patch -Np1 -i ${PATCH}/busybox-${BUSYBOX_VERSION}.patch || \
    die "Patch failed" && \
      touch ${METADATABUSYBOXMUL64}/busybox-${option}-patch-busybox-${BUSYBOX_VERSION}
[ -f ${METADATABUSYBOXMUL64}/busybox-${option}-patch-busybox-mips64el-${option}_defconfig ] || \
  patch -Np1 -i ${PATCH}/busybox-mips64el-${option}_defconfig.patch \
    || die "Patch failed" && \
      touch ${METADATABUSYBOXMUL64}/busybox-${option}-patch-busybox-mips64el-${option}_defconfig
[ -f ${METADATABUSYBOXMUL64}/busybox-${option}-config ] || \
  make mips64el-${option}_defconfig || \
    die "busybox-${option}-config error" && \
      touch ${METADATABUSYBOXMUL64}/busybox-${option}-config
[ -f ${METADATABUSYBOXMUL64}/busybox-${option}-build ] || \
  make -j${JOBS} ARCH=mips CROSS_COMPILE=${CROSS_TARGET64}- || \
    die "busybox-${option}-build error" && \
      touch ${METADATABUSYBOXMUL64}/busybox-${option}-build
[ -f ${METADATABUSYBOXMUL64}/busybox-${option}-install ] || \
  make ARCH=mips CROSS_COMPILE=${CROSS_TARGET64}- install || \
    die "busybox-${option}-install error" && \
      touch ${METADATABUSYBOXMUL64}/busybox-${option}-install
popd

# Make BusyBox Image
pushd ${SRCBUSYBOXMUL64}/busybox-$option
dd if=/dev/zero of=${BUSYBOXMUL64_IMAGE} bs=4k count=512k
echo y | mkfs.ext3 ${BUSYBOXMUL64_IMAGE}
[ -d "${MOUNT_POINT}" ] || mkdir ${MOUNT_POINT}
if [ ${HOSTOS} = "Darwin" ]; then
#ext2fuse ${BUSYBOXMUL64_IMAGE} ${MOUNT_POINT} &
die "There is something wrong with ext3 under Mac, so we complete busybox and stop here."
else
sudo mount -o loop ${BUSYBOXMUL64_IMAGE} ${MOUNT_POINT}
fi

# Build BusyBox File System
cp -ar ${SRCBUSYBOXMUL64}/busybox-$option/busybox-${BUSYBOX_VERSION}/_install/* ${MOUNT_POINT}
sudo cp -ar ${SRCBUSYBOXMUL64}/busybox-$option/busybox-${BUSYBOX_VERSION}/examples/bootfloppy/etc \
  ${MOUNT_POINT}/
mkdir ${MOUNT_POINT}/dev
mkdir ${MOUNT_POINT}/proc

sudo cp -a /dev/zero ${MOUNT_POINT}/dev/
sudo cp -a /dev/console ${MOUNT_POINT}/dev/
sudo cp -a /dev/null ${MOUNT_POINT}/dev/
sudo cp -a /dev/tty ${MOUNT_POINT}/dev/
sudo cp -a /dev/tty1 ${MOUNT_POINT}/dev/
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
mv ${SRCBUSYBOXMUL64}/busybox-$option/${BUSYBOXMUL64_IMAGE} ${PREFIXGNULINUX}
# End for loop, build static/dynamic busybox.
done
