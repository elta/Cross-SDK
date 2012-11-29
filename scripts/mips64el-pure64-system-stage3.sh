#! /bin/bash

export JOBS=16

export BZ=tar.bz2
export GZ=tar.gz
export XZ=tar.xz

export UTILLINUX_VERSION=2.20.1
export UTILLINUX_SUFFIX=${BZ}
export E2FSPROGS_VERSION=1.42.3
export E2FSPROGS_SUFFIX=${BZ}
export SYSVINIT_VERSION=2.88
export SYSVINIT_SUFFIX=${BZ}
export KMOD_VERSION=8
export KMOD_SUFFIX=${XZ}
export UDEV_VERSION=182
export UDEV_SUFFIX=${XZ}
export LINUX_VERSION=3.3.7
export LINUX_SUFFIX=${XZ}
export BOOTSCRIPT_VERSION=2.0
export BOOTSCRIPT_SUFFIX=${BZ}

function die() {
  echo "*** $1 ***"
  exit 1
}

[ -e build.sh ]
export SCRIPT="$(pwd)"
export TARBALL=${SCRIPT}/../tarballs
export PATCH=${SCRIPT}/../patches
export SRCS=${SCRIPT}/../srcs
export CONFIG=${SCRIPT}/../configs
export SRC=${SCRIPT}/../src/mips64el-pure64-linux/stage3
export BUILD=${SCRIPT}/../build/mips64el-pure64-linux/stage3

export CROSS_SDK_TOOLS=${SCRIPT}/../sdk
export CROSS=${CROSS_SDK_TOOLS}/mips64el-pure64/
export PATH=$PATH:/cross-tools/bin/

[ -d "${SRC}" ] || mkdir -p "${SRC}"
[ -d "${BUILD}" ] || mkdir -p "${BUILD}"

unset CFLAGS
unset CXXFLAGS
export CFLAGS="-w"
export CROSS_HOST=${MACHTYPE}
export CROSS_TARGET="mips64el-unknown-linux-gnu"
export BUILD64="-mabi=64"

export CC="${CROSS_TARGET}-gcc"
export CXX="${CROSS_TARGET}-g++"
export AR="${CROSS_TARGET}-ar"
export AS="${CROSS_TARGET}-as"
export RANLIB="${CROSS_TARGET}-ranlib"
export LD="${CROSS_TARGET}-ld"
export STRIP="${CROSS_TARGET}-strip"

[ -d "${CROSS_SDK_TOOLS}" ] || mkdir -p ${CROSS_SDK_TOOLS}
[ -d "${CROSS}" ] || mkdir -p ${CROSS}
[ -d "${CROSS}/tools" ] || mkdir -p ${CROSS}/tools
[ -d "/tools" ] || sudo ln -s ${CROSS}/tools /
[ -d "${CROSS}/cross-tools" ] || mkdir -p ${CROSS}/cross-tools
[ -d "/cross-tools" ] || sudo ln -s ${CROSS}/cross-tools /

# Creating Directories
mkdir -pv ${CROSS}/{bin,boot,dev,{etc/,}opt,home,lib,mnt}
mkdir -pv ${CROSS}/{proc,media/{floppy,cdrom},run,sbin,srv,sys}
mkdir -pv ${CROSS}/var/{lock,log,mail,spool}
mkdir -pv ${CROSS}/var/{opt,cache,lib/{misc,locate},local}
install -dv -m 0750 ${CROSS}/root
install -dv -m 1777 ${CROSS}{/var,}/tmp
mkdir -pv ${CROSS}/usr/{,local/}{bin,include,lib,sbin,src}
mkdir -pv ${CROSS}/usr/{,local/}share/{doc,info,locale,man}
mkdir -pv ${CROSS}/usr/{,local/}share/{misc,terminfo,zoneinfo}
mkdir -pv ${CROSS}/usr/{,local/}share/man/man{1,2,3,4,5,6,7,8}
for dir in ${CROSS}/usr{,/local}; do
    ln -sv share/{man,doc,info} $dir
done
ln -sv lib ${CROSS}/tools/lib64
cd ${CROSS}/boot
ln -svf . boot

# Creating Essential Symlinks
ln -sv /tools/bin/{bash,cat,echo,grep,login,pwd,sleep,stty} ${CROSS}/bin
ln -sv /tools/bin/file ${CROSS}/usr/bin
ln -sv /tools/sbin/{agetty,blkid} ${CROSS}/sbin
ln -sv /tools/lib/libgcc_s.so{,.1} ${CROSS}/usr/lib
ln -sv /tools/lib/libstd*so* ${CROSS}/usr/lib
ln -sv bash ${CROSS}/bin/sh
ln -sv /run ${CROSS}/var/run
mkdir -pv ${CROSS}/usr/lib64
ln -sv /tools/lib/libstd*so* ${CROSS}/usr/lib64

pushd ${SRC}
[ -d "util-linux-${UTILLINUX_VERSION}" ] \
  || tar xf ${TARBALL}/util-linux-${UTILLINUX_VERSION}.${UTILLINUX_SUFFIX}
cd util-linux-${UTILLINUX_VERSION}
echo "scanf_cv_type_modifier=as" > config.cache
CC="${CC} ${BUILD64}" PKG_CONFIG=true \
  ./configure --prefix=/tools --exec-prefix=/tools \
  --build=${CROSS_HOST} --host=${CROSS_TARGET} \
  --enable-login-utils --disable-makeinstall-chown \
  --config-cache \
  || die "config util-linux error"
make -j${JOBS} || die "build util-linux error"
make install || die "install util-linux error"
popd

pushd ${SRC}
[ -d "e2fsprogs-${E2FSPROGS_VERSION}" ] \
  || tar xf ${TARBALL}/e2fsprogs-${E2FSPROGS_VERSION}.${E2FSPROGS_SUFFIX}
popd

pushd ${BUILD}
[ -d "e2fsprogs-build" ] || mkdir e2fsprogs-build
cd e2fsprogs-build
CC="${CC} ${BUILD64}" PKG_CONFIG=true \
  ${SRC}/e2fsprogs-${E2FSPROGS_VERSION}/configure --prefix=/tools --enable-elf-shlibs \
  --build=${CROSS_HOST} --host=${CROSS_TARGET} \
  --disable-libblkid --disable-libuuid --disable-fsck \
  --disable-uuidd
  make LIBUUID="-luuid" STATIC_LIBUUID="-luuid" \
  LIBBLKID="-lblkid" STATIC_LIBBLKID="-lblkid" \
  LDFLAGS="-Wl,-rpath,/tools/lib64" \
  || die "config e2fsprogs error"
make install || die "install e2fsprogs error"
make install-libs || die "install e2fsprogs libs error "
ln -sv /tools/sbin/{fsck.ext2,fsck.ext3,fsck.ext4,e2fsck} ${CROSS}/sbin
popd

pushd ${SRC}
[ -d "sysvinit-${SYSVINIT_VERSION}dsf" ] \
  || tar xf ${TARBALL}/sysvinit-${SYSVINIT_VERSION}dsf.${SYSVINIT_SUFFIX}
cd sysvinit-${SYSVINIT_VERSION}dsf
cp -v src/Makefile{,.orig}
sed -e 's,/usr/lib,/tools/lib,g' \
    src/Makefile.orig > src/Makefile
make -C src clobber || die "build sysvinit clobber error"
make -C src CC="${CC} ${BUILD64}" || die "build sysvinit error"
make -C src ROOT=${CROSS} install || die "install sysvinit error"

cat > ${CROSS}/etc/inittab << "EOF"
# Begin /etc/inittab

id:3:initdefault:

si::sysinit:/etc/rc.d/init.d/rc sysinit

l0:0:wait:/etc/rc.d/init.d/rc 0
l1:S1:wait:/etc/rc.d/init.d/rc 1
l2:2:wait:/etc/rc.d/init.d/rc 2
l3:3:wait:/etc/rc.d/init.d/rc 3
l4:4:wait:/etc/rc.d/init.d/rc 4
l5:5:wait:/etc/rc.d/init.d/rc 5
l6:6:wait:/etc/rc.d/init.d/rc 6

ca:12345:ctrlaltdel:/sbin/shutdown -t1 -a -r now

su:S016:once:/sbin/sulogin

EOF

cat >> ${CROSS}/etc/inittab << "EOF"
1:2345:respawn:/sbin/agetty -I '\033(K' tty1 9600
2:2345:respawn:/sbin/agetty -I '\033(K' tty2 9600
3:2345:respawn:/sbin/agetty -I '\033(K' tty3 9600
4:2345:respawn:/sbin/agetty -I '\033(K' tty4 9600
5:2345:respawn:/sbin/agetty -I '\033(K' tty5 9600
6:2345:respawn:/sbin/agetty -I '\033(K' tty6 9600

EOF

cat >> ${CROSS}/etc/inittab << "EOF"
c0:12345:respawn:/sbin/agetty 115200 ttyS0 vt100

EOF

cat >> ${CROSS}/etc/inittab << "EOF"
# End /etc/inittab
EOF
popd

pushd ${SRC}
[ -d "kmod-${KMOD_VERSION}" ] \
  || tar xf ${TARBALL}/kmod-${KMOD_VERSION}.${KMOD_SUFFIX}
cd kmod-${KMOD_VERSION}
CC="${CC} ${BUILD64}" ./configure --prefix=/tools \
    --bindir=/bin --with-rootlibdir=/lib64 \
    --build=${CROSS_HOST} --host=${CROSS_TARGET} \
    || die "config kmod error"
make -j${JOBS} || die "build kmod error"
make DESTDIR=${CROSS} install || die "install kmod error"
ln -sv kmod ${CROSS}/bin/lsmod
ln -sv ../bin/kmod ${CROSS}/sbin/depmod
ln -sv ../bin/kmod ${CROSS}/sbin/insmod
ln -sv ../bin/kmod ${CROSS}/sbin/modprobe
ln -sv ../bin/kmod ${CROSS}/sbin/modinfo
ln -sv ../bin/kmod ${CROSS}/sbin/rmmod
popd

pushd ${SRC}
[ -d "udev-${UDEV_VERSION}" ] \
  || tar xf ${TARBALL}/udev-${UDEV_VERSION}.${UDEV_SUFFIX}
cd udev-${UDEV_VERSION}
CC="${CC} ${BUILD64}" LIBS="-lpthread" \
  BLKID_CFLAGS="-I/tools/include/blkid" BLKID_LIBS="-L/tools/lib64 -lblkid" \
  KMOD_CFLAGS="-I/tools/include" KMOD_LIBS="-L${CROSS}/lib64 -lkmod"  \
  ./configure --prefix=/usr \
  --build=${CROSS_HOST} --host=${CROSS_TARGET} \
  --exec-prefix="" --with-rootprefix=$CROSS \
  --sysconfdir=/etc --libexecdir=/lib \
  --libdir=/usr/lib64 --disable-introspection \
  --with-usb-ids-path=no --with-pci-ids-path=no \
  --disable-gtk-doc-html --disable-gudev \
  --disable-keymap --disable-logging \
  || die "config udev error"
make -j${JOBS} || die "build udev error"
make DESTDIR=${CROSS} install || die "install udev error"
popd

# Creating the passwd, group, and log Files
cat > ${CROSS}/etc/passwd << "EOF"
root::0:0:root:/root:/bin/bash
EOF

cat > ${CROSS}/etc/group << "EOF"
root:x:0:
bin:x:1:
sys:x:2:
kmem:x:3:
tty:x:4:
tape:x:5:
daemon:x:6:
floppy:x:7:
disk:x:8:
lp:x:9:
dialout:x:10:
audio:x:11:
video:x:12:
utmp:x:13:
usb:x:14:
cdrom:x:15:
EOF

touch ${CROSS}/run/utmp ${CROSS}/var/log/{btmp,lastlog,wtmp}
chmod -v 664 ${CROSS}/run/utmp ${CROSS}/var/log/lastlog
chmod -v 600 ${CROSS}/var/log/btmp


pushd ${SRC}
[ -d "linux-${LINUX_VERSION}" ] \
  || tar xf ${TARBALL}/linux-${LINUX_VERSION}.${LINUX_SUFFIX}
cd linux-${LINUX_VERSION}
make mrproper

make ARCH=mips CROSS_COMPILE=${CROSS_TARGET}- malta_defconfig
make ARCH=mips CROSS_COMPILE=${CROSS_TARGET}- menuconfig

make -j${JOBS} ARCH=mips CROSS_COMPILE=${CROSS_TARGET}- \
  || die "make linux error"
make ARCH=mips CROSS_COMPILE=${CROSS_TARGET}- \
  INSTALL_MOD_PATH=${CROSS} modules_install \
  || die "install linux modules error"
cp -v vmlinux ${CROSS}/boot/vmlinux-${LINUX_VERSION}
gzip -9 ${CROSS}/boot/vmlinux-${LINUX_VERSION}
cp -v System.map ${CROSS}/boot/System.map-${LINUX_VERSION}
cp -v .config ${CROSS}/boot/config-${LINUX_VERSION}
popd

# Build Flags
sudo cat > ${CROSS}/root/.bash_profile << "EOF"
set +h
PS1='\u:\w\$ '
LC_ALL=POSIX
PATH=/bin:/usr/bin:/sbin:/usr/sbin:/tools/bin:/tools/sbin
export LC_ALL PATH PS1
EOF

echo export BUILD64=\""${BUILD64}\"" >> ${CROSS}/root/.bash_profile

# Creating the /etc/fstab File
cat > ${CROSS}/etc/fstab << "EOF"
# Begin /etc/fstab

# file system  mount-point  type   options          dump  fsck
#                                                         order

/dev/hda       /            ext3   defaults         1     1
#/dev/[yyy]     swap         swap   pri=1            0     0
proc           /proc        proc   defaults         0     0
sysfs          /sys         sysfs  defaults         0     0
devpts         /dev/pts     devpts gid=4,mode=620   0     0
#shm            /dev/shm     tmpfs  defaults         0     0
#tmpfs          /run            tmpfs       defaults         0     0
#devtmpfs       /dev            devtmpfs    mode=0755,nosuid 0     0
# End /etc/fstab
EOF

pushd ${SRC}
[ -d "bootscripts-cross-lfs-${BOOTSCRIPT_VERSION}-pre1" ] \
  || tar xf ${TARBALL}/bootscripts-cross-lfs-${BOOTSCRIPT_VERSION}-pre1.${BOOTSCRIPT_SUFFIX}
cd bootscripts-cross-lfs-${BOOTSCRIPT_VERSION}-pre1
make DESTDIR=${CROSS} install-minimal || die "build bootscripts error"
cat > ${CROSS}/etc/sysconfig/clock << "EOF"
# Begin /etc/sysconfig/clock

UTC=1

# End /etc/sysconfig/clock
EOF
popd

# ln libs
sudo ln -svf /lib64/libkmod.so.2 ${CROSS}/tools/lib/
sudo ln -svf /lib64/libkmod.so.2.1.2 ${CROSS}/tools/lib/

# Populating /dev
sudo mknod -m 600 ${CROSS}/dev/console c 5 1
sudo mknod -m 666 ${CROSS}/dev/null c 1 3
sudo mknod -m 600 ${CROSS}/lib/udev/devices/console c 5 1
sudo mknod -m 666 ${CROSS}/lib/udev/devices/null c 1 3

sudo chown -Rv 0:0 ${CROSS}
sudo chgrp -v 13 ${CROSS}/var/run/utmp ${CROSS}/var/log/lastlog

sudo rm -rf /cross-tools /tools
