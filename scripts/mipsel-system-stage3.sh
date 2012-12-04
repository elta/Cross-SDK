#! /bin/bash

source source.sh

[ -d "${PREFIX}" ] || mkdir -p ${PREFIX}
[ -d "${PREFIXMIPSEL}" ] || mkdir -p ${PREFIXMIPSEL}
[ -d "${PREFIXMIPSEL}/tools" ] || mkdir -p ${PREFIXMIPSEL}/tools
[ -d "/tools" ] || sudo ln -s ${PREFIXMIPSEL}/tools /
[ -d "${PREFIXMIPSEL}/cross-tools" ] || mkdir -p ${PREFIXMIPSEL}/cross-tools
[ -d "/cross-tools" ] || sudo ln -s ${PREFIXMIPSEL}/cross-tools /

[ -f "/cross-tools/bin/${CROSS_TARGET32}-gcc" ] || die "No tool chain found"

export PATH=${PATH}:/cross-tools/bin/

[ -d "${SRCMIPSELSTAGE3}" ] || mkdir -p "${SRCMIPSELSTAGE3}"
[ -d "${BUILDMIPSELSTAGE3}" ] || mkdir -p "${BUILDMIPSELSTAGE3}"

export CC="${CROSS_TARGET32}-gcc"
export CXX="${CROSS_TARGET32}-g++"
export AR="${CROSS_TARGET32}-ar"
export AS="${CROSS_TARGET32}-as"
export RANLIB="${CROSS_TARGET32}-ranlib"
export LD="${CROSS_TARGET32}-ld"
export STRIP="${CROSS_TARGET32}-strip"

# Creating Directories
mkdir -pv ${PREFIXMIPSEL}/{bin,boot,dev,{etc/,}opt,home,lib,mnt}
mkdir -pv ${PREFIXMIPSEL}/{proc,media/{floppy,cdrom},run,sbin,srv,sys}
mkdir -pv ${PREFIXMIPSEL}/var/{lock,log,mail,spool}
mkdir -pv ${PREFIXMIPSEL}/var/{opt,cache,lib/{misc,locate},local}
install -dv -m 0750 ${PREFIXMIPSEL}/root
install -dv -m 1777 ${PREFIXMIPSEL}{/var,}/tmp
mkdir -pv ${PREFIXMIPSEL}/usr/{,local/}{bin,include,lib,sbin,src}
mkdir -pv ${PREFIXMIPSEL}/usr/{,local/}share/{doc,info,locale,man}
mkdir -pv ${PREFIXMIPSEL}/usr/{,local/}share/{misc,terminfo,zoneinfo}
mkdir -pv ${PREFIXMIPSEL}/usr/{,local/}share/man/man{1,2,3,4,5,6,7,8}
for dir in ${PREFIXMIPSEL}/usr{,/local}; do
    ln -sv share/{man,doc,info} $dir
done
cd ${PREFIXMIPSEL}/boot
ln -svf . boot

# Creating Essential Symlinks
ln -sv /tools/bin/{bash,cat,echo,grep,login,pwd,sleep,stty} ${PREFIXMIPSEL}/bin
ln -sv /tools/bin/file ${PREFIXMIPSEL}/usr/bin
ln -sv /tools/sbin/{agetty,blkid} ${PREFIXMIPSEL}/sbin
ln -sv /tools/lib/libgcc_s.so{,.1} ${PREFIXMIPSEL}/usr/lib
ln -sv /tools/lib/libstd*so* ${PREFIXMIPSEL}/usr/lib
ln -sv bash ${PREFIXMIPSEL}/bin/sh
ln -sv /run ${PREFIXMIPSEL}/var/run

pushd ${SRCMIPSELSTAGE3}
[ -d "util-linux-${UTILLINUX_VERSION}" ] \
  || tar xf ${TARBALL}/util-linux-${UTILLINUX_VERSION}.${UTILLINUX_SUFFIX}
cd util-linux-${UTILLINUX_VERSION}
echo "scanf_cv_type_modifier=as" > config.cache
CC="${CC} ${BUILD32}" PKG_CONFIG=true \
  ./configure --prefix=/tools --exec-prefix=/tools \
  --build=${CROSS_HOST} --host=${CROSS_TARGET32} \
  --enable-login-utils --disable-makeinstall-chown \
  --config-cache \
  || die "config util-linux error"
make -j${JOBS} || die "build util-linux error"
make install || die "install util-linux error"
popd

pushd ${SRCMIPSELSTAGE3}
[ -d "shadow-${SHADOW_VERSION}" ] \
  || tar xf ${TARBALL}/shadow-${SHADOW_VERSION}.${SHADOW_SUFFIX}
  cd shadow-${SHADOW_VERSION}
  sed -i 's/groups$(EXEEXT) //' src/Makefile.in
  find man -name Makefile.in -exec sed -i '/groups\.1\.xml/d' '{}' \;
  find man -name Makefile.in -exec sed -i 's/groups\.1 / /' {} \;
  echo "ac_cv_func_setpgrp_void=yes" > config.cache
  CC="${CC}" ./configure --prefix=/tools \
  --build=${CROSS_HOST} --host=${CROSS_TARGET32} --sysconfdir=/etc \
  --cache-file=config.cache || die "config shadow error"
  make -j${JOBS} || die "build shadow error"
  make DESTDIR=${PREFIXMIPSEL} install || die "install shadow error"
popd

pushd ${SRCMIPSELSTAGE3}
[ -d "e2fsprogs-${E2FSPROGS_VERSION}" ] \
  || tar xf ${TARBALL}/e2fsprogs-${E2FSPROGS_VERSION}.${E2FSPROGS_SUFFIX}
popd

pushd ${BUILDMIPSELSTAGE3}
[ -d "e2fsprogs-build" ] || mkdir e2fsprogs-build
cd e2fsprogs-build
CC="${CC} ${BUILD32}" PKG_CONFIG=true \
  ${SRCMIPSELSTAGE3}/e2fsprogs-${E2FSPROGS_VERSION}/configure --prefix=/tools \
  --enable-elf-shlibs \
  --build=${CROSS_HOST} --host=${CROSS_TARGET32} \
  --disable-libblkid --disable-libuuid --disable-fsck \
  --disable-uuidd
  make LIBUUID="-luuid" STATIC_LIBUUID="-luuid" \
  LIBBLKID="-lblkid" STATIC_LIBBLKID="-lblkid" \
  || die "config e2fsprogs error"
#  LDFLAGS="-Wl,-rpath,/tools/lib32" \
make install || die "install e2fsprogs error"
make install-libs || die "install e2fsprogs libs error "
ln -sv /tools/sbin/{fsck.ext2,fsck.ext3,fsck.ext4,e2fsck} ${PREFIXMIPSEL}/sbin
popd

pushd ${SRCMIPSELSTAGE3}
[ -d "sysvinit-${SYSVINIT_VERSION}dsf" ] \
  || tar xf ${TARBALL}/sysvinit-${SYSVINIT_VERSION}dsf.${SYSVINIT_SUFFIX}
cd sysvinit-${SYSVINIT_VERSION}dsf
cp -v src/Makefile{,.orig}
sed -e 's,/usr/lib,/tools/lib,g' \
    src/Makefile.orig > src/Makefile
make -C src clobber || die "build sysvinit clobber error"
make -C src CC="${CC} ${BUILD32}" || die "build sysvinit error"
make -C src ROOT=${PREFIXMIPSEL} install || die "install sysvinit error"

cat > ${PREFIXMIPSEL}/etc/inittab << "EOF"
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

cat >> ${PREFIXMIPSEL}/etc/inittab << "EOF"
1:2345:respawn:/sbin/agetty -I '\033(K' tty1 9600
2:2345:respawn:/sbin/agetty -I '\033(K' tty2 9600
3:2345:respawn:/sbin/agetty -I '\033(K' tty3 9600
4:2345:respawn:/sbin/agetty -I '\033(K' tty4 9600
5:2345:respawn:/sbin/agetty -I '\033(K' tty5 9600
6:2345:respawn:/sbin/agetty -I '\033(K' tty6 9600

EOF

cat >> ${PREFIXMIPSEL}/etc/inittab << "EOF"
c0:12345:respawn:/sbin/agetty 115200 ttyS0 vt100

EOF

cat >> ${PREFIXMIPSEL}/etc/inittab << "EOF"
# End /etc/inittab
EOF
popd

pushd ${SRCMIPSELSTAGE3}
[ -d "kmod-${KMOD_VERSION}" ] \
  || tar xf ${TARBALL}/kmod-${KMOD_VERSION}.${KMOD_SUFFIX}
cd kmod-${KMOD_VERSION}
CC="${CC} ${BUILD32}" ./configure --prefix=/tools \
    --bindir=/bin \
    --build=${CROSS_HOST} --host=${CROSS_TARGET32} \
    || die "config kmod error"
make -j${JOBS} || die "build kmod error"
make DESTDIR=${PREFIXMIPSEL} install || die "install kmod error"
ln -sv kmod ${PREFIXMIPSEL}/bin/lsmod
ln -sv ../bin/kmod ${PREFIXMIPSEL}/sbin/depmod
ln -sv ../bin/kmod ${PREFIXMIPSEL}/sbin/insmod
ln -sv ../bin/kmod ${PREFIXMIPSEL}/sbin/modprobe
ln -sv ../bin/kmod ${PREFIXMIPSEL}/sbin/modinfo
ln -sv ../bin/kmod ${PREFIXMIPSEL}/sbin/rmmod
popd

pushd ${SRCMIPSELSTAGE3}
[ -d "udev-${UDEV_VERSION}" ] \
  || tar xf ${TARBALL}/udev-${UDEV_VERSION}.${UDEV_SUFFIX}
cd udev-${UDEV_VERSION}
CC="${CC} ${BUILD32}" LIBS="-lpthread" \
  BLKID_CFLAGS="-I/tools/include/blkid" BLKID_LIBS="-L/tools/lib -lblkid" \
  KMOD_CFLAGS="-I/tools/include" KMOD_LIBS="-L${PREFIXMIPSEL}/lib -lkmod"  \
  ./configure --prefix=/usr \
  --build=${CROSS_HOST} --host=${CROSS_TARGET32} \
  --with-rootprefix=$PREFIXMIPSEL --bindir=/sbin --sysconfdir=/etc --libexecdir=/lib \
  --disable-introspection --with-usb-ids-path=no --with-pci-ids-path=no \
  --disable-gtk-doc-html --disable-gudev --disable-keymap --disable-logging \
  --with-firmware-path=/lib/firmware \
  || die "config udev error"
make -j${JOBS} || die "build udev error"
make DESTDIR=${PREFIXMIPSEL} install || die "install udev error"
install -dv ${PREFIXMIPSEL}/lib/firmware
popd

# Creating the passwd, group, and log Files
cat > ${PREFIXMIPSEL}/etc/passwd << "EOF"
root::0:0:root:/root:/bin/bash
EOF

cat > ${PREFIXMIPSEL}/etc/group << "EOF"
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

touch ${PREFIXMIPSEL}/run/utmp ${PREFIXMIPSEL}/var/log/{btmp,lastlog,wtmp}
chmod -v 664 ${PREFIXMIPSEL}/run/utmp ${PREFIXMIPSEL}/var/log/lastlog
chmod -v 600 ${PREFIXMIPSEL}/var/log/btmp


pushd ${SRCMIPSELSTAGE3}
[ -d "linux-${LINUX_VERSION}" ] \
  || tar xf ${TARBALL}/linux-${LINUX_VERSION}.${LINUX_SUFFIX}
cd linux-${LINUX_VERSION}
  make mrproper
  make ARCH=mips CROSS_COMPILE=${CROSS_TARGET32}- malta_defconfig
  make ARCH=mips CROSS_COMPILE=${CROSS_TARGET32}- menuconfig
  make -j${JOBS} ARCH=mips CROSS_COMPILE=${CROSS_TARGET32}- \
  || die "make linux error"
make ARCH=mips CROSS_COMPILE=${CROSS_TARGET32}- \
  INSTALL_MOD_PATH=${PREFIXMIPSEL} modules_install \
  || die "install linux modules error"
cp -v vmlinux ${PREFIXMIPSEL}/boot/vmlinux-${LINUX_VERSION}
gzip -9 ${PREFIXMIPSEL}/boot/vmlinux-${LINUX_VERSION}
cp -v System.map ${PREFIXMIPSEL}/boot/System.map-${LINUX_VERSION}
cp -v .config ${PREFIXMIPSEL}/boot/config-${LINUX_VERSION}
popd

# Build Flags
cat > ${PREFIXMIPSEL}/root/.bash_profile << "EOF"
set +h
PS1='\u:\w\$ '
LC_ALL=POSIX
PATH=/bin:/usr/bin:/sbin:/usr/sbin:/tools/bin:/tools/sbin
export LC_ALL PATH PS1
EOF

# Creating the /etc/fstab File
cat > ${PREFIXMIPSEL}/etc/fstab << "EOF"
# Begin /etc/fstab

# file system  mount-point  type   options          dump  fsck
#                                                         order

/dev/hda       /            ext3   defaults         1     1
#/dev/[yyy]     swap         swap   pri=1            0     0
proc           /proc        proc   defaults         0     0
sysfs          /sys         sysfs  defaults         0     0
devpts         /dev/pts     devpts gid=4,mode=620   0     0
shm            /dev/shm     tmpfs  defaults         0     0
tmpfs          /run            tmpfs       defaults         0     0
#devtmpfs       /dev            devtmpfs    mode=0755,nosuid 0     0
# End /etc/fstab
EOF

pushd ${SRCMIPSELSTAGE3}
[ -d "bootscripts-cross-lfs-${BOOTSCRIPT_VERSION}-pre1" ] \
  || tar xf ${TARBALL}/bootscripts-cross-lfs-${BOOTSCRIPT_VERSION}-pre1.${BOOTSCRIPT_SUFFIX}
cd bootscripts-cross-lfs-${BOOTSCRIPT_VERSION}-pre1
make DESTDIR=${PREFIXMIPSEL} install-minimal || die "build bootscripts error"
cat > ${PREFIXMIPSEL}/etc/sysconfig/clock << "EOF"
# Begin /etc/sysconfig/clock

UTC=1

# End /etc/sysconfig/clock
EOF
popd

# Populating /dev
sudo mknod -m 600 ${PREFIXMIPSEL}/dev/console c 5 1
sudo mknod -m 666 ${PREFIXMIPSEL}/dev/null c 1 3
sudo mknod -m 666 ${PREFIXMIPSEL}/dev/hda b 3 0
sudo mknod -m 666 ${PREFIXMIPSEL}/dev/rtc0 c 254 0
sudo ln -sv ${PREFIXMIPSEL}/dev/rtc0 ${PREFIXMIPSEL}/dev/rtc
sudo mknod -m 600 ${PREFIXMIPSEL}/lib/udev/devices/console c 5 1
sudo mknod -m 666 ${PREFIXMIPSEL}/lib/udev/devices/null c 1 3

sudo chown -Rv 0:0 ${PREFIXMIPSEL}
sudo chgrp -v 13 ${PREFIXMIPSEL}/var/run/utmp ${PREFIXMIPSEL}/var/log/lastlog

sudo rm -rf /cross-tools /tools

