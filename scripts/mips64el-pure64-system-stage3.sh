#! /bin/bash

source source.sh

[ -d "${SRCPURE64ELSTAGE3}" ] || mkdir -p "${SRCPURE64ELSTAGE3}"
[ -d "${BUILDPURE64ELSTAGE3}" ] || mkdir -p "${BUILDPURE64ELSTAGE3}"

[ -d "${CROSS_SDK_TOOLS}" ] || mkdir -p ${CROSS_SDK_TOOLS}
[ -d "${PREFIXPURE64EL}" ] || mkdir -p ${PREFIXPURE64EL}
[ -d "${PREFIXPURE64EL}/tools" ] || mkdir -p ${PREFIXPURE64EL}/tools
[ -d "/tools" ] || sudo ln -s ${PREFIXPURE64EL}/tools /
[ -d "${PREFIXPURE64EL}/cross-tools" ] || mkdir -p ${PREFIXPURE64EL}/cross-tools
[ -d "/cross-tools" ] || sudo ln -s ${PREFIXPURE64EL}/cross-tools /

[ -f "/cross-tools/bin/${CROSS_TARGET64}-gcc" ] || die "No tool chain found"

export PATH=${PATH}:/cross-tools/bin/

export CC="${CROSS_TARGET64}-gcc"
export CXX="${CROSS_TARGET64}-g++"
export AR="${CROSS_TARGET64}-ar"
export AS="${CROSS_TARGET64}-as"
export RANLIB="${CROSS_TARGET64}-ranlib"
export LD="${CROSS_TARGET64}-ld"
export STRIP="${CROSS_TARGET64}-strip"

# Creating Directories
mkdir -pv ${PREFIXPURE64EL}/{bin,boot,dev,{etc/,}opt,home,lib,mnt}
mkdir -pv ${PREFIXPURE64EL}/{proc,media/{floppy,cdrom},run,sbin,srv,sys}
mkdir -pv ${PREFIXPURE64EL}/var/{lock,log,mail,spool}
mkdir -pv ${PREFIXPURE64EL}/var/{opt,cache,lib/{misc,locate},local}
install -dv -m 0750 ${PREFIXPURE64EL}/root
install -dv -m 1777 ${PREFIXPURE64EL}{/var,}/tmp
mkdir -pv ${PREFIXPURE64EL}/usr/{,local/}{bin,include,lib,sbin,src}
mkdir -pv ${PREFIXPURE64EL}/usr/{,local/}share/{doc,info,locale,man}
mkdir -pv ${PREFIXPURE64EL}/usr/{,local/}share/{misc,terminfo,zoneinfo}
mkdir -pv ${PREFIXPURE64EL}/usr/{,local/}share/man/man{1,2,3,4,5,6,7,8}
for dir in ${PREFIXPURE64EL}/usr{,/local}; do
    ln -sv share/{man,doc,info} $dir
done
ln -sv lib ${PREFIXPURE64EL}/tools/lib64
cd ${PREFIXPURE64EL}/boot
ln -svf . boot

# Creating Essential Symlinks
ln -sv /tools/bin/{bash,cat,echo,grep,login,pwd,sleep,stty} ${PREFIXPURE64EL}/bin
ln -sv /tools/bin/file ${PREFIXPURE64EL}/usr/bin
ln -sv /tools/sbin/{agetty,blkid} ${PREFIXPURE64EL}/sbin
ln -sv /tools/lib/libgcc_s.so{,.1} ${PREFIXPURE64EL}/usr/lib
ln -sv /tools/lib/libstd*so* ${PREFIXPURE64EL}/usr/lib
ln -sv bash ${PREFIXPURE64EL}/bin/sh
ln -sv /run ${PREFIXPURE64EL}/var/run
mkdir -pv ${PREFIXPURE64EL}/usr/lib64
ln -sv /tools/lib/libstd*so* ${PREFIXPURE64EL}/usr/lib64

pushd ${SRCPURE64ELSTAGE3}
[ -d "util-linux-${UTILLINUX_VERSION}" ] \
  || tar xf ${TARBALL}/util-linux-${UTILLINUX_VERSION}.${UTILLINUX_SUFFIX}
cd util-linux-${UTILLINUX_VERSION}
echo "scanf_cv_type_modifier=as" > config.cache
CC="${CC} ${BUILD64}" PKG_CONFIG=true \
  ./configure --prefix=/tools --exec-prefix=/tools \
  --build=${CROSS_HOST} --host=${CROSS_TARGET64} \
  --enable-login-utils --disable-makeinstall-chown \
  --config-cache \
  || die "config util-linux error"
make -j${JOBS} || die "build util-linux error"
make install || die "install util-linux error"
popd

pushd ${SRCPURE64ELSTAGE3}
[ -d "e2fsprogs-${E2FSPROGS_VERSION}" ] \
  || tar xf ${TARBALL}/e2fsprogs-${E2FSPROGS_VERSION}.${E2FSPROGS_SUFFIX}
popd

pushd ${BUILDPURE64ELSTAGE3}
[ -d "e2fsprogs-build" ] || mkdir e2fsprogs-build
cd e2fsprogs-build
CC="${CC} ${BUILD64}" PKG_CONFIG=true \
  ${SRCPURE64ELSTAGE3}/e2fsprogs-${E2FSPROGS_VERSION}/configure --prefix=/tools --enable-elf-shlibs \
  --build=${CROSS_HOST} --host=${CROSS_TARGET64} \
  --disable-libblkid --disable-libuuid --disable-fsck \
  --disable-uuidd
  make LIBUUID="-luuid" STATIC_LIBUUID="-luuid" \
  LIBBLKID="-lblkid" STATIC_LIBBLKID="-lblkid" \
  LDFLAGS="-Wl,-rpath,/tools/lib64" \
  || die "config e2fsprogs error"
make install || die "install e2fsprogs error"
make install-libs || die "install e2fsprogs libs error "
ln -sv /tools/sbin/{fsck.ext2,fsck.ext3,fsck.ext4,e2fsck} ${PREFIXPURE64EL}/sbin
popd

pushd ${SRCPURE64ELSTAGE3}
[ -d "sysvinit-${SYSVINIT_VERSION}dsf" ] \
  || tar xf ${TARBALL}/sysvinit-${SYSVINIT_VERSION}dsf.${SYSVINIT_SUFFIX}
cd sysvinit-${SYSVINIT_VERSION}dsf
cp -v src/Makefile{,.orig}
sed -e 's,/usr/lib,/tools/lib,g' \
    src/Makefile.orig > src/Makefile
make -C src clobber || die "build sysvinit clobber error"
make -C src CC="${CC} ${BUILD64}" || die "build sysvinit error"
make -C src ROOT=${PREFIXPURE64EL} install || die "install sysvinit error"

cat > ${PREFIXPURE64EL}/etc/inittab << "EOF"
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

cat >> ${PREFIXPURE64EL}/etc/inittab << "EOF"
1:2345:respawn:/sbin/agetty -I '\033(K' tty1 9600
2:2345:respawn:/sbin/agetty -I '\033(K' tty2 9600
3:2345:respawn:/sbin/agetty -I '\033(K' tty3 9600
4:2345:respawn:/sbin/agetty -I '\033(K' tty4 9600
5:2345:respawn:/sbin/agetty -I '\033(K' tty5 9600
6:2345:respawn:/sbin/agetty -I '\033(K' tty6 9600

EOF

cat >> ${PREFIXPURE64EL}/etc/inittab << "EOF"
c0:12345:respawn:/sbin/agetty 115200 ttyS0 vt100

EOF

cat >> ${PREFIXPURE64EL}/etc/inittab << "EOF"
# End /etc/inittab
EOF
popd

pushd ${SRCPURE64ELSTAGE3}
[ -d "kmod-${KMOD_VERSION}" ] \
  || tar xf ${TARBALL}/kmod-${KMOD_VERSION}.${KMOD_SUFFIX}
cd kmod-${KMOD_VERSION}
CC="${CC} ${BUILD64}" ./configure --prefix=/tools \
    --bindir=/bin --with-rootlibdir=/lib64 \
    --build=${CROSS_HOST} --host=${CROSS_TARGET64} \
    || die "config kmod error"
make -j${JOBS} || die "build kmod error"
make DESTDIR=${PREFIXPURE64EL} install || die "install kmod error"
ln -sv kmod ${PREFIXPURE64EL}/bin/lsmod
ln -sv ../bin/kmod ${PREFIXPURE64EL}/sbin/depmod
ln -sv ../bin/kmod ${PREFIXPURE64EL}/sbin/insmod
ln -sv ../bin/kmod ${PREFIXPURE64EL}/sbin/modprobe
ln -sv ../bin/kmod ${PREFIXPURE64EL}/sbin/modinfo
ln -sv ../bin/kmod ${PREFIXPURE64EL}/sbin/rmmod
popd

pushd ${SRCPURE64ELSTAGE3}
[ -d "udev-${UDEV_VERSION}" ] \
  || tar xf ${TARBALL}/udev-${UDEV_VERSION}.${UDEV_SUFFIX}
cd udev-${UDEV_VERSION}
CC="${CC} ${BUILD64}" LIBS="-lpthread" \
  BLKID_CFLAGS="-I/tools/include/blkid" BLKID_LIBS="-L/tools/lib64 -lblkid" \
  KMOD_CFLAGS="-I/tools/include" KMOD_LIBS="-L${PREFIXPURE64EL}/lib64 -lkmod"  \
  ./configure --prefix=/usr \
  --build=${CROSS_HOST} --host=${CROSS_TARGET64} \
  --exec-prefix="" --with-rootprefix=$PREFIXPURE64EL \
  --sysconfdir=/etc --libexecdir=/lib \
  --libdir=/usr/lib64 --disable-introspection \
  --with-usb-ids-path=no --with-pci-ids-path=no \
  --disable-gtk-doc-html --disable-gudev \
  --disable-keymap --disable-logging \
  || die "config udev error"
make -j${JOBS} || die "build udev error"
make DESTDIR=${PREFIXPURE64EL} install || die "install udev error"
popd

# Creating the passwd, group, and log Files
cat > ${PREFIXPURE64EL}/etc/passwd << "EOF"
root::0:0:root:/root:/bin/bash
EOF

cat > ${PREFIXPURE64EL}/etc/group << "EOF"
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

touch ${PREFIXPURE64EL}/run/utmp ${PREFIXPURE64EL}/var/log/{btmp,lastlog,wtmp}
chmod -v 664 ${PREFIXPURE64EL}/run/utmp ${PREFIXPURE64EL}/var/log/lastlog
chmod -v 600 ${PREFIXPURE64EL}/var/log/btmp


pushd ${SRCPURE64ELSTAGE3}
[ -d "linux-${LINUX_VERSION}" ] \
  || tar xf ${TARBALL}/linux-${LINUX_VERSION}.${LINUX_SUFFIX}
cd linux-${LINUX_VERSION}
make mrproper

make ARCH=mips CROSS_COMPILE=${CROSS_TARGET64}- malta_defconfig
make ARCH=mips CROSS_COMPILE=${CROSS_TARGET64}- menuconfig

make -j${JOBS} ARCH=mips CROSS_COMPILE=${CROSS_TARGET64}- \
  || die "make linux error"
make ARCH=mips CROSS_COMPILE=${CROSS_TARGET64}- \
  INSTALL_MOD_PATH=${PREFIXPURE64EL} modules_install \
  || die "install linux modules error"
cp -v vmlinux ${PREFIXPURE64EL}/boot/vmlinux-${LINUX_VERSION}
gzip -9 ${PREFIXPURE64EL}/boot/vmlinux-${LINUX_VERSION}
cp -v System.map ${PREFIXPURE64EL}/boot/System.map-${LINUX_VERSION}
cp -v .config ${PREFIXPURE64EL}/boot/config-${LINUX_VERSION}
popd

# Build Flags
sudo cat > ${PREFIXPURE64EL}/root/.bash_profile << "EOF"
set +h
PS1='\u:\w\$ '
LC_ALL=POSIX
PATH=/bin:/usr/bin:/sbin:/usr/sbin:/tools/bin:/tools/sbin
export LC_ALL PATH PS1
EOF

echo export BUILD64=\""${BUILD64}\"" >> ${PREFIXPURE64EL}/root/.bash_profile

# Creating the /etc/fstab File
cat > ${PREFIXPURE64EL}/etc/fstab << "EOF"
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

pushd ${SRCPURE64ELSTAGE3}
[ -d "bootscripts-cross-lfs-${BOOTSCRIPT_VERSION}-pre1" ] \
  || tar xf ${TARBALL}/bootscripts-cross-lfs-${BOOTSCRIPT_VERSION}-pre1.${BOOTSCRIPT_SUFFIX}
cd bootscripts-cross-lfs-${BOOTSCRIPT_VERSION}-pre1
make DESTDIR=${PREFIXPURE64EL} install-minimal || die "build bootscripts error"
cat > ${PREFIXPURE64EL}/etc/sysconfig/clock << "EOF"
# Begin /etc/sysconfig/clock

UTC=1

# End /etc/sysconfig/clock
EOF
popd

# ln libs
sudo ln -svf /lib64/libkmod.so.2 ${PREFIXPURE64EL}/tools/lib/
sudo ln -svf /lib64/libkmod.so.2.1.2 ${PREFIXPURE64EL}/tools/lib/

# Populating /dev
sudo mknod -m 600 ${PREFIXPURE64EL}/dev/console c 5 1
sudo mknod -m 666 ${PREFIXPURE64EL}/dev/null c 1 3
sudo mknod -m 600 ${PREFIXPURE64EL}/lib/udev/devices/console c 5 1
sudo mknod -m 666 ${PREFIXPURE64EL}/lib/udev/devices/null c 1 3

sudo chown -Rv 0:0 ${PREFIXPURE64EL}
sudo chgrp -v 13 ${PREFIXPURE64EL}/var/run/utmp ${PREFIXPURE64EL}/var/log/lastlog

sudo rm -rf /cross-tools /tools
