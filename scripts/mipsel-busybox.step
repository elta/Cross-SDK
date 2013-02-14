#! /bin/bash

source source.env

#[ -f ${PREFIXGNU64}/bin/${CC} ] || die "No toolchain found, process error"

export PATH=${PREFIXHOSTTOOLS}/bin:${PREFIXMIPSELTOOLCHAIN}/bin:${PATH}

export CC=${CROSS_TARGET32}-gcc
export CFLAGS="-isystem ${PREFIXMIPSELROOTFS}/usr/include"
export CXX=${CROSS_TARGET32}-g++
export CXXFLAGS="-isystem ${PREFIXMIPSELROOTFS}/usr/include"
export LDFLAGS="-Wl,-rpath-link,${PREFIXMIPSELROOTFS}/usr/lib:${PREFIXMIPSELROOTFS}/lib"

[ -d "${SRCBUSYBOXO32}" ] || mkdir -p "${SRCBUSYBOXO32}"
[ -d "${BUILDBUSYBOXO32}" ] || mkdir -p "${BUILDBUSYBOXO32}"
[ -d "${METADATABUSYBOXO32}" ] || mkdir -p "${METADATABUSYBOXO32}"

[ -f ${PREFIXMIPSELTOOLCHAIN}/bin/${CC} ] || die "No toolchain found, process error"

#export BUSYBOX_OPTIONS="static dynamic"
export BUSYBOX_OPTIONS="dynamic"

# Begin for loop, build static/dynamic busybox.
for option in ${BUSYBOX_OPTIONS}; do

[ -f ${METADATABUSYBOXO32}/busybox-${option}-create ] || \
  mkdir ${SRCBUSYBOXO32}/busybox-$option || \
    die "busybox-${option}-create dir create failed" && \
      touch ${METADATABUSYBOXO32}/busybox-${option}-create

#pushd ${BUILDBUSYBOXO32}
#[ -f ${METADATABUSYBOXO32}/linux_extract ] || \
#  tar xf ${TARBALL}/linux-${LINUX_VERSION}.${LINUX_SUFFIX} || \
#    die "***exract linux error" && \
#      touch ${METADATABUSYBOXO32}/linux_extract
#popd

pushd ${SRCBUSYBOXO32}/busybox-$option
[ -f ${METADATABUSYBOXO32}/busybox-${option}-extract ] || \
  tar xvf ${TARBALL}/busybox-${BUSYBOX_VERSION}.${BUSYBOX_SUFFIX} || \
    die "busybox-${option}-extract error" && \
      touch ${METADATABUSYBOXO32}/busybox-${option}-extract

cd busybox-${BUSYBOX_VERSION}
if [ ${HOSTOS} = "Darwin" ]; then
[ -f ${METADATABUSYBOXO32}/busybox-1.20.2-macos.patch ] || \
  patch -Np1 -i ${PATCH}/busybox-${BUSYBOX_VERSION}-macos.patch || \
    die "Patch for MacOS failed" && \
      touch ${METADATABUSYBOXO32}/busybox-1.20.2-macos.patch
fi
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

#pushd ${BUILDBUSYBOXO32}
#cd linux-${LINUX_VERSION}
#[ -f ${METADATABUSYBOXO32}/linux_mrpro ] || \
#  make mrproper || \
#    die "***clean linux error" && \
#      touch ${METADATABUSYBOXO32}/linux_mrpro
#[ -f ${METADATABUSYBOXO32}/linux_patch ] || \
#  patch -p1 < ${PATCH}/linux-mipsel-sysroot-defconfig.patch || \
#    die "***Patch linux config error" && \
#      touch ${METADATABUSYBOXO32}/linux_patch
#[ -f ${METADATABUSYBOXO32}/linux_mkconfig ] || \
#  make ARCH=mips mipsel_sysroot_defconfig || \
#    die "***make linux defconfig error" && \
#      touch ${METADATABUSYBOXO32}/linux_mkconfig
#[ -f ${METADATABUSYBOXO32}/linux_build ] || \
#  make -j${JOBS} ARCH=mips CROSS_COMPILE=${CROSS_TARGET32}- || \
#    die "***build linux error" && \
#      touch ${METADATABUSYBOXO32}/linux_build
#popd

# Make BusyBox Image
pushd ${SRCBUSYBOXO32}/busybox-$option
dd if=/dev/zero of=${BUSYBOXO32_IMAGE} bs=4k count=512k
echo y | mkfs.ext3 ${BUSYBOXO32_IMAGE}
[ -d "${MOUNT_POINT}" ] || mkdir ${MOUNT_POINT}
if [ ${HOSTOS} = "Darwin" ]; then
#ext2fuse ${BUSYBOXO32_IMAGE} ${MOUNT_POINT} &
die "There is something wrong with ext3 under Mac, so we complete busybox and stop here."
else
sudo mount -o loop ${BUSYBOXO32_IMAGE} ${MOUNT_POINT}
fi

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
sudo cp -a /dev/tty1 ${MOUNT_POINT}/dev/
sudo cp -a /dev/tty2 ${MOUNT_POINT}/dev/
sudo cp -a /dev/ttyS0 ${MOUNT_POINT}/dev/

#[ -f ${METADATABUSYBOXO32}/linux_cpvmlinux ] || \
#  cp vmlinux ${MOUNT_POINT}/boot/ || \
#    die "***cp vmlinux error" && \
#      touch ${METADATABUSYBOXO32}/linux_cpvmlinux
#[ -f ${METADATABUSYBOXO32}/linux_cpsystemmap ] || \
#  cp System.map ${MOUNT_POINT}/boot/System.map-3.3.7 || \
#    die "***cp System.map error" && \
#      touch ${METADATABUSYBOXO32}/linux_cpsystemmap
#[ -f ${METADATABUSYBOXO32}/linux_cpconfig ] || \
#  cp .config ${MOUNT_POINT}/boot/config-3.3.7 || \
#    die "***cp config file error" && \
#      touch ${METADATABUSYBOXO32}/linux_cpconfig

# Copy Library to File System
if [ -d ${PREFIXMIPSELROOTFS}/lib ]; then
    cp -ar ${PREFIXMIPSELROOTFS}/lib ${MOUNT_POINT}/
fi

sudo echo "/bin/mount -o remount,rw /" >> ${MOUNT_POINT}/etc/init.d/rcS
sudo umount ${MOUNT_POINT}

popd

[ -d ${PREFIXGNULINUX} ] || mkdir -p ${PREFIXGNULINUX}
mv ${SRCBUSYBOXO32}/busybox-$option/${BUSYBOXO32_IMAGE} ${PREFIXGNULINUX}
# End for loop, build static/dynamic busybox.
done

touch ${METADATABUSYBOXO32}/mipsel_busybox_finished
