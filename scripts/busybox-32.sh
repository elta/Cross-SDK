#! /bin/bash

source source.sh

[ -d "${SRCBUSYBOXO32}" ] || mkdir -p "${SRCBUSYBOXO32}"
[ -d "${BUILDBUSYBOXO32}" ] || mkdir -p "${BUILDBUSYBOXO32}"
[ -d "${METADATABUSYBOXO32}" ] || mkdir -p "${METADATABUSYBOXO32}"

[ -f ${PREFIXGNU32}/bin/${CC} ] || die "No toolchain found, process error"

export PATH=${PATH}:${PREFIXGNU32}/bin

export CC=${CROSS_TARGET32}-gcc
export CFLAGS="-isystem ${SYSROOTGNU32}/usr/include ${BUILD32}"
export CXX=${CROSS_TARGET32}-g++
export CXXFLAGS="-isystem ${SYSROOTGNU32}/usr/include ${BUILD32}"
export LDFLAGS="-Wl,-rpath-link,${SYSROOTGNU32}/usr/lib:${SYSROOTGNU32}/lib ${BUILD32}"

#export BUSYBOX_OPTIONS="static dynamic"
export BUSYBOX_OPTIONS="dynamic"

# Begin for loop, build static/dynamic busybox.
for option in ${BUSYBOX_OPTIONS}; do

[ -f ${METADATABUSYBOXO32}/busybox-${option}-create ] || \
  mkdir ${SRCBUSYBOXO32}/busybox-$option || \
    die "busybox-${option}-create dir create failed" && \
      touch ${METADATABUSYBOXO32}/busybox-${option}-create

pushd ${SRCBUSYBOXO32}/busybox-$option
[ -f ${METADATABUSYBOXO32}/busybox-${option}-extract ] || \
  tar xvf ${TARBALL}/busybox-${BUSYBOX_VERSION}.${BUSYBOX_SUFFIX} || \
    die "busybox-${option}-extract error" && \
      touch ${METADATABUSYBOXO32}/busybox-${option}-extract

cd busybox-${BUSYBOX_VERSION}
[ -f ${METADATABUSYBOXO32}/busybox-${option}-patch-busybox-${BUSYBOX_VERSION} ] || \
  patch -Np1 -i ${PATCH}/busybox-${BUSYBOX_VERSION}.patch || \
    die "Patch failed" && \
      touch ${METADATABUSYBOXO32}/busybox-${option}-patch-busybox-${BUSYBOX_VERSION}
[ -f ${METADATABUSYBOXO32}/busybox-${option}-patch-busybox-mipsel-${option}_defconfig ] || \
  patch -Np1 -i ${PATCH}/busybox-mipsel-${option}_defconfig.patch \
    || die "Patch failed" && \
      touch ${METADATABUSYBOXO32}/busybox-${option}-patch-busybox-mipsel-${option}_defconfig
[ -f ${METADATABUSYBOXO32}/busybox-${option}-config ] || \
  make mipsel-${option}_defconfig || \
    die "busybox-${option}-config error" && \
      touch ${METADATABUSYBOXO32}/busybox-${option}-config
[ -f ${METADATABUSYBOXO32}/busybox-${option}-build ] || \
  make -j${JOBS} ARCH=mips CROSS_COMPILE=${CROSS_TARGET32}- || \
    die "busybox-${option}-build error" && \
      touch ${METADATABUSYBOXO32}/busybox-${option}-build
[ -f ${METADATABUSYBOXO32}/busybox-${option}-install ] || \
  make ARCH=mips CROSS_COMPILE=${CROSS_TARGET32}- install || \
    die "busybox-${option}-install error" && \
      touch ${METADATABUSYBOXO32}/busybox-${option}-install
popd

# Make BusyBox Image
pushd ${SRCBUSYBOXO32}/busybox-$option
dd if=/dev/zero of=${BUSYBOXO32_IMAGE} bs=4k count=512k
echo y | mkfs.ext3 ${BUSYBOXO32_IMAGE}
[ -d "${MOUNT_POINT}" ] || mkdir ${MOUNT_POINT}
sudo mount -o loop ${BUSYBOXO32_IMAGE} ${MOUNT_POINT}

# Build BusyBox File System
cp -ar ${SRCBUSYBOXO32}/busybox-$option/busybox-${BUSYBOX_VERSION}/_install/* ${MOUNT_POINT}
sudo cp -ar ${SRCBUSYBOXO32}/busybox-$option/busybox-${BUSYBOX_VERSION}/examples/bootfloppy/etc \
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
mv ${SRCBUSYBOXO32}/busybox-$option/${BUSYBOXO32_IMAGE} ${PREFIXGNULINUX}
# End for loop, build static/dynamic busybox.
done

