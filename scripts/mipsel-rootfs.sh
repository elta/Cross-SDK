#! /bin/bash
source source.sh

[ -d "${SRCMIPSELSYSROOT}" ] || mkdir -p "${SRCMIPSELSYSROOT}"
[ -d "${BUILDMIPSELSYSROOT}" ] || mkdir -p "${BUILDMIPSELSYSROOT}"
[ -d "${METADATAMIPSELSYSROOT}" ] || mkdir -p "${METADATAMIPSELSYSROOT}"

mkdir -p ${PREFIXMIPSELSYSROOT}
mkdir -p ${PREFIXMIPSELSYSROOT}/cross-tools
export PATH=$PATH:${PREFIXMIPSELSYSROOT}/cross-tools/bin

#################### Creating Directories ###############
mkdir -pv ${PREFIXMIPSELSYSROOT}/{bin,boot,dev,{etc/,}opt,home,lib,mnt,run}
mkdir -pv ${PREFIXMIPSELSYSROOT}/{proc,media/{floppy,cdrom},sbin,srv,sys}
mkdir -pv ${PREFIXMIPSELSYSROOT}/var/{lock,log,mail,run,spool}
mkdir -pv ${PREFIXMIPSELSYSROOT}/var/{opt,cache,lib/{misc,locate},local}
install -dv -m 0750 ${PREFIXMIPSELSYSROOT}/root
install -dv -m 1777 ${PREFIXMIPSELSYSROOT}{/var,}/tmp
mkdir -pv ${PREFIXMIPSELSYSROOT}/usr/{,local/}{bin,include,lib,sbin,src}
mkdir -pv ${PREFIXMIPSELSYSROOT}/usr/{,local/}share/{doc,info,locale,man}
mkdir -pv ${PREFIXMIPSELSYSROOT}/usr/{,local/}share/{misc,terminfo,zoneinfo}
mkdir -pv ${PREFIXMIPSELSYSROOT}/usr/{,local/}share/man/man{1,2,3,4,5,6,7,8}
for dir in ${PREFIXMIPSELSYSROOT}/usr{,/local}; do
  ln -sfnv share/{man,doc,info} ${dir}
done
mkdir -pv ${PREFIXMIPSELSYSROOT}/etc/sysconfig

cat > ${PREFIXMIPSELSYSROOT}/etc/passwd << "EOF"
root::0:0:root:/root:/bin/bash
EOF

cat > ${PREFIXMIPSELSYSROOT}/etc/group << "EOF"
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

touch ${PREFIXMIPSELSYSROOT}/var/run/utmp ${PREFIXMIPSELSYSROOT}/var/log/{btmp,lastlog,wtmp}
touch ${PREFIXMIPSELSYSROOT}/run/utmp
chmod -v 664 ${PREFIXMIPSELSYSROOT}/run/utmp
chmod -v 664 ${PREFIXMIPSELSYSROOT}/var/run/utmp ${PREFIXMIPSELSYSROOT}/var/log/lastlog
chmod -v 600 ${PREFIXMIPSELSYSROOT}/var/log/btmp

################## End Creating Directories ###############

###############################################################
# mipsel sysroot extract
###############################################################

pushd ${BUILDMIPSELSYSROOT}
[ -f ${METADATAMIPSELSYSROOT}/linux_extract ] || \
  tar xf ${TARBALL}/linux-${LINUX_VERSION}.${LINUX_SUFFIX} || \
    die "***extract linux error" && \
      touch ${METADATAMIPSELSYSROOT}/linux_extract

[ -f ${METADATAMIPSELSYSROOT}/iana_extract ] || \
  tar xf ${TARBALL}/iana-etc-${IANA_VERSION}.${IANA_SUFFIX} || \
    die "***extract iana error" && \
      touch ${METADATAMIPSELSYSROOT}/iana_extract

[ -f ${METADATAMIPSELSYSROOT}/iproute2_extract ] || \
  tar xf ${TARBALL}/iproute2-${IPROUTE2_VERSION}.${IPROUTE2_SUFFIX} || \
    die "***extract iproute2 error" && \
      touch ${METADATAMIPSELSYSROOT}/iproute2_extract

[ -f ${METADATAMIPSELSYSROOT}/bzip2_extract ] || \
  tar xf ${TARBALL}/bzip2-${BZIP2_VERSION}.${BZIP2_SUFFIX} || \
    die "***extract bzip2 error" && \
      touch ${METADATAMIPSELSYSROOT}/bzip2_extract

[ -f ${METADATAMIPSELSYSROOT}/man_extract ] || \
  tar xf ${TARBALL}/man-${MAN_VERSION}.${MAN_SUFFIX} || \
    die "***extract man error" && \
      touch ${METADATAMIPSELSYSROOT}/man_extract

[ -f ${METADATAMIPSELSYSROOT}/bootscript_extract ] || \
  tar xf ${TARBALL}/bootscripts-cross-lfs-${BOOTSCRIPTS_VERSION}.${BOOTSCRIPTS_SUFFIX} || \
    die "***extract bootscript error" && \
      touch ${METADATAMIPSELSYSROOT}/bootscript_extract

[ -f ${METADATAMIPSELSYSROOT}/vim_extract ] || \
  tar xf ${TARBALL}/vim-${VIM_VERSION}.${VIM_SUFFIX} || \
    die "***extract vim error" && \
      touch ${METADATAMIPSELSYSROOT}/vim_extract

[ -f ${METADATAMIPSELSYSROOT}/dhcpcd_extract ] || \
  tar xf  ${TARBALL}/dhcpcd-${DHCPCD_VERSION}.${DHCPCD_SUFFIX} || \
    die "***extract dhcpcd error" && \
      touch ${METADATAMIPSELSYSROOT}/dhcpcd_extract

[ -f ${METADATAMIPSELSYSROOT}/groff_extract_cross ] || \
  tar xf ${TARBALL}/groff-${GROFF_VERSION}.${GROFF_SUFFIX} || \
    die "***extract groff cross error" && \
      touch ${METADATAMIPSELSYSROOT}/groff_extract_cross

popd

pushd ${SRCMIPSELSYSROOT}
[ -f ${METADATAMIPSELSYSROOT}/gmp_extract ] || \
  tar xf ${TARBALL}/gmp-${GMP_VERSION}.${GMP_SUFFIX} || \
    die "***extract gmp error" && \
      touch ${METADATAMIPSELSYSROOT}/gmp_extract

[ -f ${METADATAMIPSELSYSROOT}/mpfr_extract ] || \
  tar xf ${TARBALL}/mpfr-${MPFR_VERSION}.${MPFR_SUFFIX} || \
    die "***extract mpfr error" && \
      touch ${METADATAMIPSELSYSROOT}/mpfr_extract

[ -f ${METADATAMIPSELSYSROOT}/mpc_extract ] || \
  tar xf ${TARBALL}/mpc-${MPC_VERSION}.${MPC_SUFFIX} || \
    die "***extract mpc error" && \
      touch ${METADATAMIPSELSYSROOT}/mpc_extract

[ -f ${METADATAMIPSELSYSROOT}/ppl_extract ] || \
  tar xf ${TARBALL}/ppl-${PPL_VERSION}.${PPL_SUFFIX} || \
    die "***extract ppl error" && \
      touch ${METADATAMIPSELSYSROOT}/ppl_extract

[ -f ${METADATAMIPSELSYSROOT}/cloog_extract ] || \
  tar xf ${TARBALL}/cloog-${CLOOG_VERSION}.${CLOOG_SUFFIX} || \
    die "***extract cloog error" && \
      touch ${METADATAMIPSELSYSROOT}/cloog_extract

[ -f ${METADATAMIPSELSYSROOT}/binutils_extract ] || \
  tar xf ${TARBALL}/binutils-${BINUTILS_VERSION}.${BINUTILS_SUFFIX} || \
    die "***extract binutils error" && \
      touch ${METADATAMIPSELSYSROOT}/binutils_extract

[ -f ${METADATAMIPSELSYSROOT}/gcc_extract ] || \
  tar xf ${TARBALL}/gcc-${GCC_VERSION}.${GCC_SUFFIX} || \
    die "***extract gcc error" && \
      touch ${METADATAMIPSELSYSROOT}/gcc_extract

[ -f ${METADATAMIPSELSYSROOT}/eglibc_extract ] || \
  tar xf ${TARBALL}/eglibc-${EGLIBC_VERSION}-r21467.${EGLIBC_SUFFIX} || \
    die "***extract eglibc error" && \
      touch ${METADATAMIPSELSYSROOT}/eglibc_extract

cd eglibc-${EGLIBC_VERSION}
[ -f ${METADATAMIPSELSYSROOT}/eglibc_ports_extract ] || \
  tar xf ${TARBALL}/eglibc-ports-${EGLIBC_VERSION}-r21467.${EGLIBC_SUFFIX} || \
    die "***extract eglibc ports error" && \
      touch ${METADATAMIPSELSYSROOT}/eglibc_ports_extract
cd ../

[ -f ${METADATAMIPSELSYSROOT}/file_extract ] || \
  tar xf ${TARBALL}/file-${FILE11_VERSION}.${FILE11_SUFFIX} || \
    die "***extract file error" && \
      touch ${METADATAMIPSELSYSROOT}/file_extract

[ -f ${METADATAMIPSELSYSROOT}/groff_extract ] || \
  tar xf ${TARBALL}/groff-${GROFF_VERSION}.${GROFF_SUFFIX} || \
    die "***extract groff error" && \
      touch ${METADATAMIPSELSYSROOT}/groff_extract

[ -f ${METADATAMIPSELSYSROOT}/shadow_extract ] || \
  tar xf ${TARBALL}/shadow-${SHADOW_VERSION}.${SHADOW_SUFFIX} || \
    die "***extract shadow error" && \
      touch ${METADATAMIPSELSYSROOT}/shadow_extract

[ -f ${METADATAMIPSELSYSROOT}/ncurses_extract ] || \
  tar xf ${TARBALL}/ncurses-${NCURSES_VERSION}.${NCURSES_SUFFIX} || \
    die "***extract ncurses error" && \
      touch ${METADATAMIPSELSYSROOT}/ncurses_extract

[ -f ${METADATAMIPSELSYSROOT}/man-pages_extract ] || \
  tar xf ${TARBALL}/man-pages-${MANPAGES_VERSION}.${MANPAGES_SUFFIX} || \
    die "***extract man pages error" && \
      touch ${METADATAMIPSELSYSROOT}/man-pages_extract

[ -f ${METADATAMIPSELSYSROOT}/zlib_extract ] || \
  tar xf ${TARBALL}/zlib-${ZLIB_VERSION}.${ZLIB_SUFFIX} || \
    die "***extract zlib error" && \
      touch ${METADATAMIPSELSYSROOT}/zlib_extract

## These used by glib
#[ -f ${METADATAMIPSELSYSROOT}/expat_extract ] || \
#  tar xf ${TARBALL}/expat-${EXPAT_VERSION}.${EXPAT_SUFFIX} || \
#    die "***extract expat error" && \
#      touch ${METADATAMIPSELSYSROOT}/expat_extract
#
#[ -f ${METADATAMIPSELSYSROOT}/dbus_extract ] || \
#  tar xf ${TARBALL}/dbus-${DBUS_VERSION}.${DBUS_SUFFIX} || \
#    die "***extract dbus error" && \
#      touch ${METADATAMIPSELSYSROOT}/dbus_extract
#
#[ -f ${METADATAMIPSELSYSROOT}/glib_extract ] || \
#  tar xf ${TARBALL}/glib-${GLIB_VERSION}.${GLIB_SUFFIX} || \
#    die "***extract glib error" && \
#      touch ${METADATAMIPSELSYSROOT}/glib_extract

[ -f ${METADATAMIPSELSYSROOT}/sed_extract ] || \
  tar xf ${TARBALL}/sed-${SED_VERSION}.${SED_SUFFIX} || \
    die "***extract sed error" && \
      touch ${METADATAMIPSELSYSROOT}/sed_extract

[ -f ${METADATAMIPSELSYSROOT}/util_linux_extract ] || \
  tar xf ${TARBALL}/util-${UTIL_VERSION}.${UTIL_SUFFIX} || \
    die "***extract util-linux error" && \
      touch ${METADATAMIPSELSYSROOT}/util_linux_extract

[ -f ${METADATAMIPSELSYSROOT}/e2fsprogs_extract ] || \
  tar xf ${TARBALL}/e2fsprogs-${E2FSPROGS_VERSION}.${E2FSPROGS_SUFFIX} || \
    die "***extract e2fsprogs error" && \
      touch ${METADATAMIPSELSYSROOT}/e2fsprogs_extract

[ -f ${METADATAMIPSELSYSROOT}/coreutils_extract ] || \
  tar xf ${TARBALL}/coreutils-${COREUTILS_VERSION}.${COREUTILS_SUFFIX} || \
    die "***extract coreutils error" && \
      touch ${METADATAMIPSELSYSROOT}/coreutils_extract

[ -f ${METADATAMIPSELSYSROOT}/m4_extract ] || \
  tar xf ${TARBALL}/m4-${M4_VERSION}.${M4_SUFFIX} || \
    die "***extract m4 error" && \
      touch ${METADATAMIPSELSYSROOT}/m4_extract

[ -f ${METADATAMIPSELSYSROOT}/bison_extract ] || \
  tar xf ${TARBALL}/bison-${BISON_VERSION}.${BISON_SUFFIX} || \
    die "***extract bison error" && \
      touch ${METADATAMIPSELSYSROOT}/bison_extract

[ -f ${METADATAMIPSELSYSROOT}/procps_extract ] || \
  tar xf ${TARBALL}/procps-${PROCPS_VERSION}.${PROCPS_SUFFIX} || \
    die "***extract procps error" && \
      touch ${METADATAMIPSELSYSROOT}/procps_extract

[ -f ${METADATAMIPSELSYSROOT}/libtool_extract ] || \
  tar xf ${TARBALL}/libtool-${LIBTOOL_VERSION}.${LIBTOOL_SUFFIX} || \
    die "***extract libtool error" && \
      touch ${METADATAMIPSELSYSROOT}/libtool_extract

[ -f ${METADATAMIPSELSYSROOT}/flex_extract ] || \
  tar xf ${TARBALL}/flex-${FLEX_VERSION}.${FLEX_SUFFIX} || \
    die "***extract flex error" && \
      touch ${METADATAMIPSELSYSROOT}/flex_extract

[ -f ${METADATAMIPSELSYSROOT}/perl_extract ] || \
  tar xf ${TARBALL}/perl-${PERL_VERSION}.${PERL_SUFFIX} || \
    die "***extract perl error" && \
      touch ${METADATAMIPSELSYSROOT}/perl_extract

[ -f ${METADATAMIPSELSYSROOT}/readline_extract ] || \
  tar xf ${TARBALL}/readline-${READLINE_VERSION}.${READLINE_SUFFIX} || \
    die "***extract readline error" && \
      touch ${METADATAMIPSELSYSROOT}/readline_extract

[ -f ${METADATAMIPSELSYSROOT}/autoconf_extract ] || \
  tar xf ${TARBALL}/autoconf-${AUTOCONF_VERSION}.${AUTOCONF_SUFFIX} || \
    die "***extract autoconf error" && \
      touch ${METADATAMIPSELSYSROOT}/autoconf_extract

[ -f ${METADATAMIPSELSYSROOT}/automake_extract ] || \
  tar xf ${TARBALL}/automake-${AUTOMAKE_VERSION}.${AUTOMAKE_SUFFIX} || \
    die "***extract automake error" && \
      touch ${METADATAMIPSELSYSROOT}/automake_extract

[ -f ${METADATAMIPSELSYSROOT}/bash_extract ] || \
  tar xf ${TARBALL}/bash-${BASH_VERSION}.${BASH_SUFFIX} || \
    die "***extract bash error" && \
      touch ${METADATAMIPSELSYSROOT}/bash_extract

[ -f ${METADATAMIPSELSYSROOT}/diffutils_extract ] || \
  tar xf ${TARBALL}/diffutils-${DIFFUTILS_VERSION}.${DIFFUTILS_SUFFIX} || \
    die "***extract diffutils error" && \
      touch ${METADATAMIPSELSYSROOT}/diffutils_extract

[ -f ${METADATAMIPSELSYSROOT}/findutils_extract ] || \
  tar xf ${TARBALL}/findutils-${FINDUTILS_VERSION}.${FINDUTILS_SUFFIX} || \
    die "***extract findutils error" && \
      touch ${METADATAMIPSELSYSROOT}/findutils_extract

[ -f ${METADATAMIPSELSYSROOT}/gawk_extract ] || \
  tar xf ${TARBALL}/gawk-${GAWK_VERSION}.${GAWK_SUFFIX} || \
    die "***extract gawk error" && \
      touch ${METADATAMIPSELSYSROOT}/gawk_extract

[ -f ${METADATAMIPSELSYSROOT}/gettext_extract ] || \
  tar xf ${TARBALL}/gettext-${GETTEXT_VERSION}.${GETTEXT_SUFFIX} || \
    die "***extract gettext error" && \
      touch ${METADATAMIPSELSYSROOT}/gettext_extract

[ -f ${METADATAMIPSELSYSROOT}/grep_extract ] || \
  tar xf ${TARBALL}/grep-${GREP_VERSION}.${GREP_SUFFIX} || \
    die "***extract grep error" && \
      touch ${METADATAMIPSELSYSROOT}/grep_extract

[ -f ${METADATAMIPSELSYSROOT}/gzip_extract ] || \
  tar xf ${TARBALL}/gzip-${GZIP_VERSION}.${GZIP_SUFFIX} || \
    die "***extract gzip error" && \
      touch ${METADATAMIPSELSYSROOT}/gzip_extract

[ -f ${METADATAMIPSELSYSROOT}/iputils_extract ] || \
  tar xf ${TARBALL}/iputils-${IPUTILS_VERSION}.${IPUTILS_SUFFIX} || \
    die "***extract iputils error" && \
      touch ${METADATAMIPSELSYSROOT}/iputils_extract

[ -f ${METADATAMIPSELSYSROOT}/kbd_extract ] || \
  tar xf ${TARBALL}/kbd-${KBD_VERSION}.${KBD_SUFFIX} || \
    die "***extract kbd error" && \
      touch ${METADATAMIPSELSYSROOT}/kbd_extract

[ -f ${METADATAMIPSELSYSROOT}/less_extract ] || \
  tar xf ${TARBALL}/less-${LESS_VERSION}.${LESS_SUFFIX} || \
    die "***extract less error" && \
      touch ${METADATAMIPSELSYSROOT}/less_extract

[ -f ${METADATAMIPSELSYSROOT}/make_extract ] || \
  tar xf ${TARBALL}/make-${MAKE_VERSION}.${MAKE_SUFFIX} || \
    die "***extract make error" && \
      touch ${METADATAMIPSELSYSROOT}/make_extract

[ -f ${METADATAMIPSELSYSROOT}/module_init_extract ] || \
  tar xf ${TARBALL}/module-init-tools-${MODULE_VERSION}.${MODULE_SUFFIX} || \
    die "***extract module init error" && \
      touch ${METADATAMIPSELSYSROOT}/module_init_extract

[ -f ${METADATAMIPSELSYSROOT}/patch_extract ] || \
  tar xf ${TARBALL}/patch-${PATCH_VERSION}.${PATCH_SUFFIX} || \
    die "***extract patch error" && \
      touch ${METADATAMIPSELSYSROOT}/patch_extract

[ -f ${METADATAMIPSELSYSROOT}/psmisc_extract ] || \
  tar xf ${TARBALL}/psmisc-${PSMISC_VERSION}.${PSMISC_SUFFIX} || \
    die "***extract psmisc error" && \
      touch ${METADATAMIPSELSYSROOT}/psmisc_extract

[ -f ${METADATAMIPSELSYSROOT}/libestr_extract ] || \
  tar xf ${TARBALL}/libestr-${LIBESTR_VERSION}.${LIBESTR_SUFFIX} || \
    die "***extract libestr error" && \
      touch ${METADATAMIPSELSYSROOT}/libestr_extract

[ -f ${METADATAMIPSELSYSROOT}/libee_extract ] || \
  tar xf ${TARBALL}/libee-${LIBEE_VERSION}.${LIBEE_SUFFIX} || \
    die "***extract libee error" && \
      touch ${METADATAMIPSELSYSROOT}/libee_extract

[ -f ${METADATAMIPSELSYSROOT}/rsyslog_extract ] || \
  tar xf ${TARBALL}/rsyslog-${RSYSLOG_VERSION}.${RSYSLOG_SUFFIX} || \
    die "***extract rsyslog error" && \
      touch ${METADATAMIPSELSYSROOT}/rsyslog_extract

[ -f ${METADATAMIPSELSYSROOT}/sysvinit_extract ] || \
  tar xf ${TARBALL}/sysvinit-${SYSVINIT_VERSION}.${SYSVINIT_SUFFIX} || \
    die "***extract rsyvinit error" && \
      touch ${METADATAMIPSELSYSROOT}/sysvinit_extract

[ -f ${METADATAMIPSELSYSROOT}/tar_extract ] || \
  tar xf ${TARBALL}/tar-${TAR_VERSION}.${TAR_SUFFIX} || \
    die "***extract tar error" && \
      touch ${METADATAMIPSELSYSROOT}/tar_extract

[ -f ${METADATAMIPSELSYSROOT}/texinfo_extract ] || \
  tar xf ${TARBALL}/texinfo-${TEXINFO_VERSION}a.${TEXINFO_SUFFIX} || \
    die "***extract texinfo error" && \
      touch ${METADATAMIPSELSYSROOT}/texinfo_extract

[ -f ${METADATAMIPSELSYSROOT}/kmod_extract ] || \
  tar xf ${TARBALL}/kmod-${KMOD_VERSION}.${KMOD_SUFFIX} || \
    die "***extract kmod error" && \
      touch ${METADATAMIPSELSYSROOT}/kmod_extract

[ -f ${METADATAMIPSELSYSROOT}/udev_extract ] || \
  tar xf ${TARBALL}/udev-${UDEV_VERSION}.${UDEV_SUFFIX} || \
    die "***extract udev error" && \
      touch ${METADATAMIPSELSYSROOT}/udev_extract

[ -f ${METADATAMIPSELSYSROOT}/xz_extract ] || \
  tar xf ${TARBALL}/xz-${XZ_VERSION}.${XZ_SUFFIX} || \
    die "***extract xz error" && \
      touch ${METADATAMIPSELSYSROOT}/xz_extract

popd

pushd ${BUILDMIPSELSYSROOT}
cd linux-${LINUX_VERSION}
[ -f ${METADATAMIPSELSYSROOT}/linux_mrproper ] || \
  make mrproper || \
    die "***make mrproper error" && \
      touch ${METADATAMIPSELSYSROOT}/linux_mrproper
[ -f ${METADATAMIPSELSYSROOT}/linux_headers_check ] || \
  make ARCH=mips headers_check || \
    die "***check headers error" && \
      touch ${METADATAMIPSELSYSROOT}/linux_headers_check
[ -f ${METADATAMIPSELSYSROOT}/linux_headers_install ] || \
  make ARCH=mips INSTALL_HDR_PATH=dest headers_install || \
    die "***install headers error" && \
      touch ${METADATAMIPSELSYSROOT}/linux_headers_install
[ -f ${METADATAMIPSELSYSROOT}/linux_headers_copy ] || \
  cp -r dest/include/* ${PREFIXMIPSELSYSROOT}/usr/include || \
    die "***copy headers error" && \
      touch ${METADATAMIPSELSYSROOT}/linux_headers_copy
[ -f ${METADATAMIPSELSYSROOT}/linux_headers_find ] || \
  find ${PREFIXMIPSELSYSROOT}/usr/include -name .install \
  -or -name ..install.cmd | xargs rm -fv || \
    die "***install headers error" && \
      touch ${METADATAMIPSELSYSROOT}/linux_headers_find
popd

pushd ${BUILDMIPSELSYSROOT}
[ -d "gmp_build" ] || mkdir gmp_build
cd gmp_build
[ -f ${METADATAMIPSELSYSROOT}/gmp_configure ] || \
  CPPFLAGS=-fexceptions \
    ${SRCMIPSELSYSROOT}/gmp-${GMP_VERSION}/configure \
    --prefix=${PREFIXMIPSELSYSROOT}/cross-tools --enable-cxx || \
      die "***config gmp error" && \
        touch ${METADATAMIPSELSYSROOT}/gmp_configure
[ -f ${METADATAMIPSELSYSROOT}/gmp_build ] || \
  make -j${JOBS} || die "***build gmp error" && \
    touch ${METADATAMIPSELSYSROOT}/gmp_build
[ -f ${METADATAMIPSELSYSROOT}/gmp_install ] || \
  make install || die "***install gmp error" && \
    touch ${METADATAMIPSELSYSROOT}/gmp_install
popd

pushd ${BUILDMIPSELSYSROOT}
[ -d "mpfr_build" ] || mkdir mpfr_build
cd mpfr_build
[ -f ${METADATAMIPSELSYSROOT}/mpfr_configure ] || \
  LDFLAGS="-Wl,-rpath,${PREFIXMIPSELSYSROOT}/cross-tools/lib" \
  ${SRCMIPSELSYSROOT}/mpfr-${MPFR_VERSION}/configure \
  --prefix=${PREFIXMIPSELSYSROOT}/cross-tools \
  --with-gmp=${PREFIXMIPSELSYSROOT}/cross-tools --enable-shared || \
    die "***config mpfr error" && \
      touch ${METADATAMIPSELSYSROOT}/mpfr_configure
[ -f ${METADATAMIPSELSYSROOT}/mpfr_build ] || \
  make -j${JOBS} || \
    die "***build mpfr error" && \
      touch ${METADATAMIPSELSYSROOT}/mpfr_build
[ -f ${METADATAMIPSELSYSROOT}/mpfr_install ] || \
  make install || \
    die "***install mpfr error" && \
      touch ${METADATAMIPSELSYSROOT}/mpfr_install
popd

pushd ${BUILDMIPSELSYSROOT}
[ -d "mpc_build" ] || mkdir mpc_build
cd mpc_build
[ -f ${METADATAMIPSELSYSROOT}/mpc_configure ] || \
  LDFLAGS="-Wl,-rpath,/cross-tools/lib" \
  ${SRCMIPSELSYSROOT}/mpc-${MPC_VERSION}/configure \
  --prefix=${PREFIXMIPSELSYSROOT}/cross-tools \
  --with-gmp=${PREFIXMIPSELSYSROOT}/cross-tools \
  --with-mpfr=${PREFIXMIPSELSYSROOT}/cross-tools || \
    die "***config mpc error" && \
      touch ${METADATAMIPSELSYSROOT}/mpc_configure
[ -f ${METADATAMIPSELSYSROOT}/mpc_build ] || \
  make -j${JOBS} || die "***build mpc error" && \
    touch ${METADATAMIPSELSYSROOT}/mpc_build
[ -f ${METADATAMIPSELSYSROOT}/mpc_install ] || \
  make install || die "***install mpc error" && \
    touch ${METADATAMIPSELSYSROOT}/mpc_install
popd

pushd ${BUILDMIPSELSYSROOT}
[ -d "ppl_build" ] || mkdir ppl_build
cd ppl_build
[ -f ${METADATAMIPSELSYSROOT}/ppl_configure ] || \
  LDFLAGS="-Wl,-rpath,${PREFIXMIPSELSYSROOT}/cross-tools/lib" \
  ${SRCMIPSELSYSROOT}/ppl-${PPL_VERSION}/configure \
  --prefix=${PREFIXMIPSELSYSROOT}/cross-tools --enable-shared \
  --enable-interfaces="c,cxx" --disable-optimization \
  --with-libgmp-prefix=${PREFIXMIPSELSYSROOT}/cross-tools \
  --with-libgmpxx-prefix=${PREFIXMIPSELSYSROOT}/cross-tools || \
    die "***config ppl error" && \
      touch ${METADATAMIPSELSYSROOT}/ppl_configure
[ -f ${METADATAMIPSELSYSROOT}/ppl_build ] || \
  make -j${JOBS} || die "***build ppl error" && \
    touch ${METADATAMIPSELSYSROOT}/ppl_build
[ -f ${METADATAMIPSELSYSROOT}/ppl_install ] || \
  make install || die "***install ppl error" && \
    touch ${METADATAMIPSELSYSROOT}/ppl_install
popd

pushd ${BUILDMIPSELSYSROOT}
[ -d "cloog_build" ] || mkdir cloog_build
cd cloog_build
[ -f ${METADATAMIPSELSYSROOT}/cloog_configure ] || \
  LDFLAGS="-Wl,-rpath,${PREFIXMIPSELSYSROOT}/cross-tools/lib" \
  ${SRCMIPSELSYSROOT}/cloog-${CLOOG_VERSION}/configure \
  --prefix=${PREFIXMIPSELSYSROOT}/cross-tools --enable-shared \
  --with-gmp-prefix=${PREFIXMIPSELSYSROOT}/cross-tools || \
    die "***config cloog error" && \
      touch ${METADATAMIPSELSYSROOT}/cloog_configure
[ -f ${METADATAMIPSELSYSROOT}/cloog_build ] || \
  make -j${JOBS} || die "***build cloog error" && \
    touch ${METADATAMIPSELSYSROOT}/cloog_build
[ -f ${METADATAMIPSELSYSROOT}/cloog_install ] || \
  make install || die "***install cloog error" && \
    touch ${METADATAMIPSELSYSROOT}/cloog_install
popd

pushd ${BUILDMIPSELSYSROOT}
[ -d "binutils-build" ] || mkdir binutils-build
cd binutils-build
[ -f ${METADATAMIPSELSYSROOT}/binutils_configure ] || \
  AS="as" AR="ar" \
  ${SRCMIPSELSYSROOT}/binutils-${BINUTILS_VERSION}/configure \
  --prefix=${PREFIXMIPSELSYSROOT}/cross-tools \
  --host=${CROSS_HOST} --target=${CROSS_TARGET32} \
  --with-sysroot=${PREFIXMIPSELSYSROOT} --disable-nls \
  --enable-shared \
  --disable-multilib || \
    die "***config binutils error" && \
      touch ${METADATAMIPSELSYSROOT}/binutils_configure
[ -f ${METADATAMIPSELSYSROOT}/binutils_build_host ] || \
  make configure-host || \
    die "config binutils host error" && \
      touch ${METADATAMIPSELSYSROOT}/binutils_build_host
[ -f ${METADATAMIPSELSYSROOT}/binutils_build ] || \
  make -j${JOBS} || \
    die "***build binutils error" && \
      touch ${METADATAMIPSELSYSROOT}/binutils_build
[ -f ${METADATAMIPSELSYSROOT}/binutils_install ] || \
  make install || \
    die "***install binutils error" && \
      touch ${METADATAMIPSELSYSROOT}/binutils_install
[ -f ${METADATAMIPSELSYSROOT}/binutils_headers_copy ] || \
  cp ${SRCMIPSELSYSROOT}/binutils-${BINUTILS_VERSION}/include/libiberty.h ${PREFIXMIPSELSYSROOT}/usr/include || \
    die "***copy binutils header error" && \
      touch ${METADATAMIPSELSYSROOT}/binutils_headers_copy
popd

pushd ${BUILDMIPSELSYSROOT}
[ -d "gcc-static-build" ] || mkdir gcc-static-build
cd gcc-static-build
[ -f ${METADATAMIPSELSYSROOT}/gcc_static_configure ] || \
  AR=ar LDFLAGS="-Wl,-rpath,${PREFIXMIPSELSYSROOT}/cross-tools/lib" \
  ${SRCMIPSELSYSROOT}/gcc-${GCC_VERSION}/configure \
  --prefix=${PREFIXMIPSELSYSROOT}/cross-tools \
  --build=${CROSS_HOST} --host=${CROSS_HOST} \
  --target=${CROSS_TARGET32} --with-sysroot=${PREFIXMIPSELSYSROOT} \
  --disable-multilib --disable-nls \
  --without-headers --with-newlib --disable-decimal-float \
  --disable-libgomp --disable-libmudflap --disable-libssp \
  --with-mpfr=${PREFIXMIPSELSYSROOT}/cross-tools \
  --with-gmp=${PREFIXMIPSELSYSROOT}/cross-tools \
  --with-ppl=${PREFIXMIPSELSYSROOT}/cross-tools \
  --with-cloog=${PREFIXMIPSELSYSROOT}/cross-tools \
  --with-mpc=${PREFIXMIPSELSYSROOT}/cross-tools \
  --disable-shared --disable-threads --enable-languages=c \
  --enable-cloog-backend=isl || \
    die "***config gcc static stage1 error" && \
      touch ${METADATAMIPSELSYSROOT}/gcc_static_configure
[ -f ${METADATAMIPSELSYSROOT}/gcc_static_build ] || \
  make -j${JOBS} all-gcc all-target-libgcc || \
    die "***build gcc static stage1 error" && \
      touch ${METADATAMIPSELSYSROOT}/gcc_static_build
[ -f ${METADATAMIPSELSYSROOT}/gcc_static_install ] || \
  make install-gcc install-target-libgcc || \
    die "***install gcc static stage1 error" && \
      touch ${METADATAMIPSELSYSROOT}/gcc_static_install
popd


pushd ${SRCMIPSELSYSROOT}
cd eglibc-${EGLIBC_VERSION}
[ -f ${METADATAMIPSELSYSROOT}/eglibc_cp ] || \
  cp Makeconfig{,.orig} || \
    die "***eglibc cp makeconfig error" && \
      touch ${METADATAMIPSELSYSROOT}/eglibc_cp
[ -f ${METADATAMIPSELSYSROOT}/eglibc_sed ] || \
  sed -e 's/-lgcc_eh//g' Makeconfig.orig > Makeconfig || \
    die "***eglibc sed error" && \
      touch ${METADATAMIPSELSYSROOT}/eglibc_sed
popd

pushd ${BUILDMIPSELSYSROOT}
[ -d "eglibc-build" ] || mkdir eglibc-build
cd eglibc-build
[ -f ${METADATAMIPSELSYSROOT}/eglibc_config ] || \
cat > config.cache << "EOF"
libc_cv_forced_unwind=yes
libc_cv_c_cleanup=yes
libc_cv_gnu89_inline=yes
EOF

cat > configparms << EOF
install_root=${PREFIXMIPSELSYSROOT}
EOF

[ -f ${METADATAMIPSELSYSROOT}/eglibc_configure ] || \
  BUILD_CC="gcc" CC="${CROSS_TARGET32}-gcc ${BUILD32}" \
  AR="${CROSS_TARGET32}-ar" \
  RANLIB="${CROSS_TARGET32}-ranlib" \
  CFLAGS_FOR_TARGET="-O2" CFLAGS+="-O2" \
  ${SRCMIPSELSYSROOT}/eglibc-${EGLIBC_VERSION}/configure \
  --prefix=/usr \
  --libexecdir=/usr/lib/eglibc --host=${CROSS_TARGET32} \
  --build=${CROSS_HOST} \
  --disable-profile --enable-add-ons --with-tls --enable-kernel=2.6.0 \
  --with-__thread --with-binutils=${PREFIXMIPSELSYSROOT}/cross-tools/bin \
  --with-headers=${PREFIXMIPSELSYSROOT}/usr/include \
  --cache-file=config.cache ||\
    die "***config eglibc error" && \
      touch ${METADATAMIPSELSYSROOT}/eglibc_configure
[ -f ${METADATAMIPSELSYSROOT}/eglibc_build ] || \
  make -j${JOBS} || die "***build eglibc error" && \
    touch ${METADATAMIPSELSYSROOT}/eglibc_build
[ -f ${METADATAMIPSELSYSROOT}/eglibc_install ] || \
  make install || die "***install eglibc error" && \
    touch ${METADATAMIPSELSYSROOT}/eglibc_install
popd

pushd ${BUILDMIPSELSYSROOT}
[ -d "gcc-build" ] || mkdir gcc-build
cd gcc-build
[ -f ${METADATAMIPSELSYSROOT}/gcc_configure ] || \
  AR=ar LDFLAGS="-Wl,-rpath,${PREFIXMIPSELSYSROOT}/cross-tools/lib" \
  ${SRCMIPSELSYSROOT}/gcc-${GCC_VERSION}/configure \
  --prefix=${PREFIXMIPSELSYSROOT}/cross-tools \
  --build=${CROSS_HOST} --host=${CROSS_HOST} \
  --target=${CROSS_TARGET32} \
  --disable-multilib --with-sysroot=${PREFIXMIPSELSYSROOT} --disable-nls \
  --enable-shared --enable-languages=c,c++ --enable-__cxa_atexit \
  --with-mpfr=${PREFIXMIPSELSYSROOT}/cross-tools \
  --with-gmp=${PREFIXMIPSELSYSROOT}/cross-tools \
  --with-ppl=${PREFIXMIPSELSYSROOT}/cross-tools \
  --with-cloog=${PREFIXMIPSELSYSROOT}/cross-tools \
  --with-mpc=${PREFIXMIPSELSYSROOT}/cross-tools \
  --enable-c99 --enable-long-long --enable-threads=posix \
  --enable-cloog-backend=isl || \
    die "***config gcc stage2 error" && \
      touch ${METADATAMIPSELSYSROOT}/gcc_configure
[ -f ${METADATAMIPSELSYSROOT}/gcc_build ] || \
  make -j${JOBS} \
  AS_FOR_TARGET="${CROSS_TARGET32}-as" \
  LD_FOR_TARGET="${CROSS_TARGET32}-ld" || \
    die "***build gcc stage2 error" && \
      touch ${METADATAMIPSELSYSROOT}/gcc_build
[ -f ${METADATAMIPSELSYSROOT}/gcc_install ] || \
  make install || \
    die "***install gcc stage2 error" && \
      touch ${METADATAMIPSELSYSROOT}/gcc_install
popd

pushd ${BUILDMIPSELSYSROOT}
[ -d "file_build" ] || mkdir file_build
cd file_build
[ -f ${METADATAMIPSELSYSROOT}/file_configure ] || \
  ${SRCMIPSELSYSROOT}/file-${FILE11_VERSION}/configure \
  --prefix=${PREFIXMIPSELSYSROOT}/cross-tools || \
    die "***config file error" && \
      touch ${METADATAMIPSELSYSROOT}/file_configure
[ -f ${METADATAMIPSELSYSROOT}/file_build ] || \
  make -j${JOBS} || \
    die "***build file error" && \
      touch ${METADATAMIPSELSYSROOT}/file_build
[ -f ${METADATAMIPSELSYSROOT}/file_install ] || \
  make install || \
    die "***install file error" && \
      touch ${METADATAMIPSELSYSROOT}/file_install
popd

pushd ${BUILDMIPSELSYSROOT}
[ -d "groff_build" ] || mkdir groff_build
cd groff_build
[ -f ${METADATAMIPSELSYSROOT}/groff_configure ] || \
  PAGE=A4 ${SRCMIPSELSYSROOT}/groff-${GROFF_VERSION}/configure \
  --prefix=${PREFIXMIPSELSYSROOT}/cross-tools --without-x || \
    die "***config groff error" && \
      touch ${METADATAMIPSELSYSROOT}/groff_configure
[ -f ${METADATAMIPSELSYSROOT}/groff_build ] || \
  make -j${JOBS} || \
    die "***build groff error" && \
      touch ${METADATAMIPSELSYSROOT}/groff_build
[ -f ${METADATAMIPSELSYSROOT}/groff_install ] || \
  make install || \
    die "***install groff error" && \
      touch ${METADATAMIPSELSYSROOT}/groff_install
popd

pushd ${SRCMIPSELSYSROOT}
cd shadow-${SHADOW_VERSION}
[ -f ${METADATAMIPSELSYSROOT}/shadow_patch ] || \
  patch -p1 < ${PATCH}/shadow-${SHADOW_VERSION}-sysroot_hacks-1.patch || \
    die "Patch shadow error" && \
      touch ${METADATAMIPSELSYSROOT}/shadow_patch
popd

pushd ${BUILDMIPSELSYSROOT}
[ -d "shadow_build" ] || mkdir shadow_build
cd shadow_build
cat > config.cache << EOF
shadow_cv_passwd_dir="${PREFIXMIPSELSYSROOT}/bin"
EOF
cat >> config.cache << EOF
ac_cv_func_lckpwdf=no
EOF
[ -f ${METADATAMIPSELSYSROOT}/shadow_configure ] || \
  ${SRCMIPSELSYSROOT}/shadow-${SHADOW_VERSION}/configure \
  --prefix=${PREFIXMIPSELSYSROOT}/cross-tools \
  --sbindir=${PREFIXMIPSELSYSROOT}/cross-tools/bin \
  --sysconfdir=$PREFIXMIPSELSYSROOT/etc \
  --disable-shared --without-libpam \
  --without-audit --without-selinux \
  --program-prefix=${CROSS_TARGET32}- \
  --without-nscd --cache-file=config.cache || \
    die "***config shadow error" && \
      touch ${METADATAMIPSELSYSROOT}/shadow_configure
[ -f ${METADATAMIPSELSYSROOT}/cp_config ] || \
  cp config.h{,.orig} || \
    die "***copy config error" && \
      touch ${METADATAMIPSELSYSROOT}/cp_config
[ -f ${METADATAMIPSELSYSROOT}/cp_config_sed ] || \
  sed "/PASSWD_PROGRAM/s/passwd/${CROSS_TARGET32}-&/" config.h.orig > config.h || \
    die "***sed config.h error" && \
      touch ${METADATAMIPSELSYSROOT}/cp_config_sed
[ -f ${METADATAMIPSELSYSROOT}/shadow_build ] || \
  make -j${JOBS} || \
    die "***build shadow error" && \
      touch ${METADATAMIPSELSYSROOT}/shadow_build
[ -f ${METADATAMIPSELSYSROOT}/shadow_install ] || \
  make install || \
    die "***install shadow error" && \
      touch ${METADATAMIPSELSYSROOT}/shadow_install
popd

pushd ${SRCMIPSELSYSROOT}
cd ncurses-${NCURSES_VERSION}
[ -f ${METADATAMIPSELSYSROOT}/ncurses_patch ] || \
  patch -Np1 -i ${PATCH}/ncurses-5.9-bash_fix-1.patch || \
    die "***patch ncurses error" && \
      touch ${METADATAMIPSELSYSROOT}/ncurses_patch
popd

pushd ${BUILDMIPSELSYSROOT}
[ -d "ncurses_build" ] || mkdir ncurses_build
cd ncurses_build
[ -f ${METADATAMIPSELSYSROOT}/ncurses_configure ] || \
  ${SRCMIPSELSYSROOT}/ncurses-${NCURSES_VERSION}/configure \
  --prefix=${PREFIXMIPSELSYSROOT}/cross-tools \
  --without-debug --without-shared || \
    die "***config ncurses error" && \
      touch ${METADATAMIPSELSYSROOT}/ncurses_configure
[ -f ${METADATAMIPSELSYSROOT}/ncurses_include_build ] || \
  make -C include || \
    die "***build ncurses include error" && \
      touch ${METADATAMIPSELSYSROOT}/ncurses_include_build
[ -f ${METADATAMIPSELSYSROOT}/ncurses_tic_build ] || \
  make -C progs tic || \
    die "***build ncurses tic error" && \
      touch ${METADATAMIPSELSYSROOT}/ncurses_tic_build
[ -f ${METADATAMIPSELSYSROOT}/ncurses_install ] || \
  install -m755 progs/tic ${PREFIXMIPSELSYSROOT}/cross-tools/bin || \
    die "***install ncurses error" && \
      touch ${METADATAMIPSELSYSROOT}/ncurses_install
popd

export CC="${CROSS_TARGET32}-gcc ${BUILD32}"
export CXX="${CROSS_TARGET32}-g++ ${BUILD32}"
export AR="${CROSS_TARGET32}-ar"
export AS="${CROSS_TARGET32}-as"
export RANLIB="${CROSS_TARGET32}-ranlib"
export LD="${CROSS_TARGET32}-ld"
export STRIP="${CROSS_TARGET32}-strip"

pushd ${SRCMIPSELSYSROOT}
cd man-pages-${MANPAGES_VERSION}
[ -f ${METADATAMIPSELSYSROOT}/manpages_install ] || \
  make prefix=${PREFIXMIPSELSYSROOT}/usr install || \
    die "***install man pages error" && \
      touch ${METADATAMIPSELSYSROOT}/manpages_install
popd

pushd ${BUILDMIPSELSYSROOT}
[ -d "gmp_cross_build" ] || mkdir gmp_cross_build
cd gmp_cross_build
[ -f ${METADATAMIPSELSYSROOT}/gmp_cross_configure ] || \
  CPPFLAGS=-fexceptions \
  ${SRCMIPSELSYSROOT}/gmp-${GMP_VERSION}/configure --prefix=/usr \
  --build=${CROSS_HOST} --host=${CROSS_TARGET32} \
  --enable-cxx --enable-mpbsd || \
    die "***config cross gmp error" && \
      touch ${METADATAMIPSELSYSROOT}/gmp_cross_configure
[ -f ${METADATAMIPSELSYSROOT}/gmp_cross_build ] || \
  make -j${JOBS} || \
    die "***make cross gmp error" && \
      touch ${METADATAMIPSELSYSROOT}/gmp_cross_build
[ -f ${METADATAMIPSELSYSROOT}/gmp_cross_install ] || \
  make DESTDIR=${PREFIXMIPSELSYSROOT} install || \
    die "***install cross gmp error" && \
      touch ${METADATAMIPSELSYSROOT}/gmp_cross_install
[ -f ${METADATAMIPSELSYSROOT}/gmp_cross_rmla ] || \
  rm -v ${PREFIXMIPSELSYSROOT}/usr/lib/lib{gmp,gmpxx,mp}.la || \
    die "***remove cross gmp *.la error" && \
      touch ${METADATAMIPSELSYSROOT}/gmp_cross_rmla
popd

pushd ${BUILDMIPSELSYSROOT}
[ -d "mpfr_cross_build" ] || mkdir mpfr_cross_build
cd mpfr_cross_build
[ -f ${METADATAMIPSELSYSROOT}/mpfr_cross_configure ] || \
  ${SRCMIPSELSYSROOT}/mpfr-${MPFR_VERSION}/configure \
  --prefix=/usr --enable-shared \
  --build=${CROSS_HOST} --host=${CROSS_TARGET32} \
  --with-gmp-lib=${PREFIXMIPSELSYSROOT}/usr/lib || \
    die "***config cross mpfr error" && \
      touch ${METADATAMIPSELSYSROOT}/mpfr_cross_configure
[ -f ${METADATAMIPSELSYSROOT}/mpfr_cross_build ] || \
  make -j${JOBS} || \
    die "***build cross mpfr error" && \
      touch ${METADATAMIPSELSYSROOT}/mpfr_cross_build
[ -f ${METADATAMIPSELSYSROOT}/mpfr_cross_install ] || \
  make DESTDIR=${PREFIXMIPSELSYSROOT} install || \
    die "***install cross mpfr error" && \
      touch ${METADATAMIPSELSYSROOT}/mpfr_cross_install
[ -f ${METADATAMIPSELSYSROOT}/mpfr_cross_rmla ] || \
  rm -v ${PREFIXMIPSELSYSROOT}/usr/lib/libmpfr.la || \
    die "***remove cross mpfr *.la error" && \
      touch ${METADATAMIPSELSYSROOT}/mpfr_cross_rmla
popd

pushd ${BUILDMIPSELSYSROOT}
[ -d "mpc_cross_build" ] || mkdir mpc_cross_build
cd mpc_cross_build
[ -f ${METADATAMIPSELSYSROOT}/mpc_cross_configure ] || \
  ${SRCMIPSELSYSROOT}/mpc-${MPC_VERSION}/configure \
  --prefix=/usr --enable-shared \
  --build=${CROSS_HOST} \
  --host=${CROSS_TARGET32} \
  --with-gmp-lib=${PREFIXMIPSELSYSROOT}/usr/lib \
  --with-mpfr-lib=${PREFIXMIPSELSYSROOT}/usr/lib || \
    die "***config cross mpc error"
      touch ${METADATAMIPSELSYSROOT}/mpc_cross_configure
[ -f ${METADATAMIPSELSYSROOT}/mpc_cross_build ] || \
  make -j${JOBS} || \
    die "***build cross mpc error" && \
      touch ${METADATAMIPSELSYSROOT}/mpc_cross_build
[ -f ${METADATAMIPSELSYSROOT}/mpc_cross_install ] || \
  make DESTDIR=${PREFIXMIPSELSYSROOT} install || \
    die "***install cross mpc error" && \
      touch ${METADATAMIPSELSYSROOT}/mpc_cross_install
[ -f ${METADATAMIPSELSYSROOT}/mpc_cross_rmla ] || \
  rm -v ${PREFIXMIPSELSYSROOT}/usr/lib/libmpc.la || \
    die "***remove cross mpc *la error" && \
      touch ${METADATAMIPSELSYSROOT}/mpc_cross_rmla
popd

pushd ${BUILDMIPSELSYSROOT}
[ -d "ppl_cross_build" ] || mkdir ppl_cross_build
cd ppl_cross_build
[ -f ${METADATAMIPSELSYSROOT}/ppl_cross_configure ] || \
  CPPFLAGS=-fexceptions \
  ${SRCMIPSELSYSROOT}/ppl-${PPL_VERSION}/configure --prefix=/usr \
  --build=${CROSS_HOST} --host=${CROSS_TARGET32} \
  --with-libgmp-prefix=${PREFIXMIPSELSYSROOT}/usr \
  --with-libgmpxx-prefix=${PREFIXMIPSELSYSROOT}/usr \
  --enable-shared --disable-optimization \
  --enable-check=quick || \
    die "***config cross ppl error" && \
      touch ${METADATAMIPSELSYSROOT}/ppl_cross_configure
[ -f ${METADATAMIPSELSYSROOT}/ppl_cross_build ] || \
  make -j${JOBS} || \
    die "***build cross ppl error" && \
      touch ${METADATAMIPSELSYSROOT}/ppl_cross_build
[ -f ${METADATAMIPSELSYSROOT}/ppl_cross_install ] || \
  make DESTDIR=${PREFIXMIPSELSYSROOT} install || \
    die "***install cross ppl error" && \
      touch ${METADATAMIPSELSYSROOT}/ppl_cross_install
[ -f ${METADATAMIPSELSYSROOT}/ppl_cross_rmla ] || \
  rm -v ${PREFIXMIPSELSYSROOT}/usr/lib/lib{ppl,ppl_c,pwl}.la || \
    die "***remove cross ppl *.la error" && \
      touch ${METADATAMIPSELSYSROOT}/ppl_cross_rmla
popd

pushd ${SRCMIPSELSYSROOT}
cd cloog-${CLOOG_VERSION}
cp -v configure{,.orig}
sed -e "/LD_LIBRARY_PATH=/d" configure.orig > configure
popd

pushd ${BUILDMIPSELSYSROOT}
[ -d "cloog_cross_build" ] || mkdir cloog_cross_build
cd cloog_cross_build
[ -f ${METADATAMIPSELSYSROOT}/cloog_cross_configure ] || \
  LDFLAGS="-Wl,-rpath-link,${PREFIXMIPSELSYSROOT}/cross-tools/${CROSS_TARGET32}/lib" \
  ${SRCMIPSELSYSROOT}/cloog-${CLOOG_VERSION}/configure \
  --build=${CROSS_HOST} --host=${CROSS_TARGET32} \
  --prefix=/usr --enable-shared --with-gmp --with-ppl || \
    die "config cross cloog error" && \
      touch ${METADATAMIPSELSYSROOT}/cloog_cross_configure
[ -f ${METADATAMIPSELSYSROOT}/cloog_cross_build ] || \
  make -j${JOBS} || \
    die "***build cross cloog error" && \
      touch ${METADATAMIPSELSYSROOT}/cloog_cross_build
[ -f ${METADATAMIPSELSYSROOT}/cloog_cross_install ] || \
  make DESTDIR=${PREFIXMIPSELSYSROOT} install || \
    die "***install cross cloog error" && \
      touch ${METADATAMIPSELSYSROOT}/cloog_cross_install
[ -f ${METADATAMIPSELSYSROOT}/cloog_cross_rmla ] || \
  rm -v ${PREFIXMIPSELSYSROOT}/usr/lib/libcloog-isl.la || \
    die "***remove cross cloog *.la error" && \
      touch ${METADATAMIPSELSYSROOT}/cloog_cross_rmla
popd

pushd ${SRCMIPSELSYSROOT}
cd zlib-${ZLIB_VERSION}
[ -f ${METADATAMIPSELSYSROOT}/zlib_cross_configure ] || \
  ./configure \
  --prefix=/usr --shared || \
    die "***config zlib error" && \
      touch ${METADATAMIPSELSYSROOT}/zlib_cross_configure
[ -f ${METADATAMIPSELSYSROOT}/zlib_cross_build ] || \
  make -j${JOBS}|| \
    die "***build zlib error" && \
      touch ${METADATAMIPSELSYSROOT}/zlib_cross_build
[ -f ${METADATAMIPSELSYSROOT}/zlib_cross_install ] || \
  make prefix=${PREFIXMIPSELSYSROOT}/usr install || \
    die "***install zlib error" && \
      touch ${METADATAMIPSELSYSROOT}/zlib_cross_install
[ -f ${METADATAMIPSELSYSROOT}/zlib_cross_mvso ] || \
  mv -v ${PREFIXMIPSELSYSROOT}/usr/lib/libz.so.* ${PREFIXMIPSELSYSROOT}/lib || \
    die "***move libz.so.* zlib error" && \
      touch ${METADATAMIPSELSYSROOT}/zlib_cross_mvso
[ -f ${METADATAMIPSELSYSROOT}/zlib_cross_ln ] || \
  ln -sfv ../../lib/libz.so.1 ${PREFIXMIPSELSYSROOT}/usr/lib/libz.so || \
    die "***link libz.so.1 zlib error" && \
      touch ${METADATAMIPSELSYSROOT}/zlib_cross_ln
chmod -v 644 ${PREFIXMIPSELSYSROOT}/usr/lib/libz.a
popd

#pushd ${BUILDMIPSELSYSROOT}
#[ -d "expat_cross_build" ] || mkdir expat_cross_build
#cd expat_cross_build
#[ -f ${METADATAMIPSELSYSROOT}/expat_cross_configure ] || \
#  ${SRCMIPSELSYSROOT}/expat-${EXPAT_VERSION}/configure \
#  --prefix=/usr \
#  --build=${CROSS_HOST} --host=${CROSS_TARGET32} \
#  --target=${CROSS_TARGET32} || \
#    die "***config expat error" && \
#      touch ${METADATAMIPSELSYSROOT}/expat_cross_configure
#[ -f ${METADATAMIPSELSYSROOT}/expat_cross_build ] || \
#  make -j${JOBS} || \
#    die "***build expat error" && \
#      touch ${METADATAMIPSELSYSROOT}/expat_cross_build
#[ -f ${METADATAMIPSELSYSROOT}/expat_cross_install ] || \
#  make prefix=${PREFIXMIPSELSYSROOT}/usr install || \
#    die "***install expat error" && \
#      touch ${METADATAMIPSELSYSROOT}/expat_cross_install
#popd
#
#pushd ${BUILDMIPSELSYSROOT}
#[ -d "dbus_cross_build" ] || mkdir dbus_cross_build
#cd dbus_cross_build
#[ -f ${METADATAMIPSELSYSROOT}/dbus_cross_configure ] || \
#  ${SRCMIPSELSYSROOT}/dbus-${DBUS_VERSION}/configure \
#  --prefix=/usr \
#  --build=${CROSS_HOST} --host=${CROSS_TARGET32} \
#  --target=${CROSS_TARGET32} || \
#    die "***config dbus error" && \
#      touch ${METADATAMIPSELSYSROOT}/dbus_cross_configure
#[ -f ${METADATAMIPSELSYSROOT}/dbus_cross_build ] || \
#  make -j${JOBS} || \
#    die "***build dbus error" && \
#      touch ${METADATAMIPSELSYSROOT}/dbus_cross_build
#[ -f ${METADATAMIPSELSYSROOT}/dbus_cross_install ] || \
#  make DESTDIR=${PREFIXMIPSELSYSROOT} install || \
#    die "***install dbus error" && \
#      touch ${METADATAMIPSELSYSROOT}/dbus_cross_install
#popd
#
#pushd ${BUILDMIPSELSYSROOT}
#[ -d "glib_cross_build" ] || mkdir glib_cross_build
#cd glib_cross_build
#cat > config.cache << EOF
#glib_cv_stack_grows=false
#glib_cv_uscore=false
#ac_cv_func_posix_getpwuid_r=false
#ac_cv_func_posix_getgrgid_r=false
#EOF
#[ -f ${METADATAMIPSELSYSROOT}/glib_cross_configure ] || \
#  ${SRCMIPSELSYSROOT}/glib-${GLIB_VERSION}/configure \
#  --prefix=/usr \
#  --build=${CROSS_HOST} --host=${CROSS_TARGET32} \
#  --target=${CROSS_TARGET32} --sysconfdir=/etc \
#  --cache-file=config.cache --enable-debug=no || \
#    die "***config glib error" && \
#      touch ${METADATAMIPSELSYSROOT}/glib_cross_configure
#[ -f ${METADATAMIPSELSYSROOT}/glib_cross_build ] || \
#  make -j${JOBS} || \
#    die "***build glib error" && \
#      touch ${METADATAMIPSELSYSROOT}/glib_cross_build
#[ -f ${METADATAMIPSELSYSROOT}/glib_cross_install ] || \
#  make DESTDIR=${PREFIXMIPSELSYSROOT} install || \
#    die "***install glib error" && \
#      touch ${METADATAMIPSELSYSROOT}/glib_cross_install
#popd

pushd ${BUILDMIPSELSYSROOT}
[ -d "binutils_cross_build" ] || mkdir binutils_cross_build
cd binutils_cross_build
[ -f ${METADATAMIPSELSYSROOT}/binutils_cross_configure ] || \
  ${SRCMIPSELSYSROOT}/binutils-${BINUTILS_VERSION}/configure \
  --prefix=/usr \
  --build=${CROSS_HOST} --host=${CROSS_TARGET32} \
  --target=${CROSS_TARGET32} --enable-shared || \
    die "***config file error" && \
      touch ${METADATAMIPSELSYSROOT}/binutils_cross_configure
[ -f ${METADATAMIPSELSYSROOT}/binutils_cross_buildhost ] || \
  make configure-host || \
    die "config cross binutils host error" && \
      touch ${METADATAMIPSELSYSROOT}/binutils_cross_buildhost
[ -f ${METADATAMIPSELSYSROOT}/binutils_cross_buildtooldir ] || \
  make tooldir=/usr || \
    die "***build cross binutils tooldir error" && \
      touch ${METADATAMIPSELSYSROOT}/binutils_cross_buildtooldir
[ -f ${METADATAMIPSELSYSROOT}/binutils_cross_install ] || \
  make DESTDIR=${PREFIXMIPSELSYSROOT} tooldir=/usr install || \
    die "***install binutils error" && \
      touch ${METADATAMIPSELSYSROOT}/binutils_cross_install
popd

pushd ${SRCMIPSELSYSROOT}
cd gcc-${GCC_VERSION}
cp libiberty/Makefile.in{,.orig}
sed 's/install_to_$(INSTALL_DEST) //' libiberty/Makefile.in.orig > \
libiberty/Makefile.in
cp gcc/gccbug.in{,.orig}
sed 's/@have_mktemp_command@/yes/' gcc/gccbug.in.orig > gcc/gccbug.in
cp gcc/Makefile.in{,.orig}
sed 's@\./fixinc\.sh@-c true@' gcc/Makefile.in.orig > gcc/Makefile.in
popd

pushd ${BUILDMIPSELSYSROOT}
[ -d "gcc_cross_build" ] || mkdir gcc_cross_build
cd gcc_cross_build
[ -f ${METADATAMIPSELSYSROOT}/gcc_cross_configure ] || \
  LDFLAGS="-Wl,-rpath-link,${PREFIXMIPSELSYSROOT}/cross-tools/${CROSS_TARGET32}/lib" \
  ${SRCMIPSELSYSROOT}/gcc-${GCC_VERSION}/configure \
  --prefix=/usr --libexecdir=/usr/lib \
  --build=${CROSS_HOST} --host=${CROSS_TARGET32} --target=${CROSS_TARGET32} \
  --enable-shared --enable-threads=posix --enable-__cxa_atexit \
  --enable-c99 --enable-long-long --enable-clocale=gnu \
  --enable-languages=c,c++ --disable-libstdcxx-pch || \
    die "***configure cross gcc error" && \
      touch ${METADATAMIPSELSYSROOT}/gcc_cross_configure
cp Makefile{,.orig}
sed "/^HOST_\(GMP\|PPL\|CLOOG\)\(LIBS\|INC\)/s:-[IL]/\(lib\|include\)::" \
    Makefile.orig > Makefile
[ -f ${METADATAMIPSELSYSROOT}/gcc_cross_build ] || \
  make -j${JOBS} || \
    die "***build cross gcc error" && \
      touch ${METADATAMIPSELSYSROOT}/gcc_cross_build
[ -f ${METADATAMIPSELSYSROOT}/gcc_cross_install ] || \
  make DESTDIR=${PREFIXMIPSELSYSROOT} install || \
    die "***install cross gcc error" && \
      touch ${METADATAMIPSELSYSROOT}/gcc_cross_install
[ -f ${METADATAMIPSELSYSROOT}/gcc_cross_lncpp ] || \
  ln -sfv ../usr/bin/cpp ${PREFIXMIPSELSYSROOT}/lib || \
    die "***link cross gcc lncpp error" && \
      touch ${METADATAMIPSELSYSROOT}/gcc_cross_lncpp
[ -f ${METADATAMIPSELSYSROOT}/gcc_cross_lncc ] || \
  ln -sfv gcc ${PREFIXMIPSELSYSROOT}/usr/bin/cc || \
    die "***link cross gcc lncpp error" && \
      touch ${METADATAMIPSELSYSROOT}/gcc_cross_lncc
popd


pushd ${BUILDMIPSELSYSROOT}
[ -d "sed_build" ] || mkdir sed_build
cd sed_build
[ -f ${METADATAMIPSELSYSROOT}/sed_cross_configure ] || \
  ${SRCMIPSELSYSROOT}/sed-${SED_VERSION}/configure \
  --build=${CROSS_HOST} \
  --host=${CROSS_TARGET32} \
  --prefix=/usr --bindir=/bin || \
    die "***config sed error" && \
      touch ${METADATAMIPSELSYSROOT}/sed_cross_configure
[ -f ${METADATAMIPSELSYSROOT}/sed_cross_build ] || \
  make -j${JOBS} || \
    die "***build sed error" && \
      touch ${METADATAMIPSELSYSROOT}/sed_cross_build
[ -f ${METADATAMIPSELSYSROOT}/sed_cross_buildhtml ] || \
  make html || \
    die "***build sed html error" && \
      touch ${METADATAMIPSELSYSROOT}/sed_cross_buildhtml
[ -f ${METADATAMIPSELSYSROOT}/sed_cross_install ] || \
  make DESTDIR=${PREFIXMIPSELSYSROOT} install || \
    die "***install sed error" && \
      touch ${METADATAMIPSELSYSROOT}/sed_cross_install
[ -f ${METADATAMIPSELSYSROOT}/sed_cross_installhtml ] || \
  make -C doc DESTDIR=${PREFIXMIPSELSYSROOT} install-html || \
    die "***install sed html error" && \
      touch ${METADATAMIPSELSYSROOT}/sed_cross_installhtml
popd

pushd ${BUILDMIPSELSYSROOT}
[ -d "ncurses_cross_build" ] || mkdir ncurses_cross_build
cd ncurses_cross_build
[ -f ${METADATAMIPSELSYSROOT}/ncurses_cross_configure ] || \
  ${SRCMIPSELSYSROOT}/ncurses-${NCURSES_VERSION}/configure \
  --build=${CROSS_HOST} \
  --host=${CROSS_TARGET32} \
  --prefix=/usr --libdir=/lib --with-shared \
  --enable-widec --without-debug --without-ada \
  --with-manpage-format=normal \
  --with-build-cc="gcc -D_GNU_SOURCE" || \
    die "***config cross ncurses error" && \
      touch ${METADATAMIPSELSYSROOT}/ncurses_cross_configure
[ -f ${METADATAMIPSELSYSROOT}/ncurses_cross_build ] || \
  make -j${JOBS} || \
    die "***build cross ncurses error" && \
      touch ${METADATAMIPSELSYSROOT}/ncurses_cross_build
[ -f ${METADATAMIPSELSYSROOT}/ncurses_cross_install ] || \
  make DESTDIR=${PREFIXMIPSELSYSROOT} install || \
    die "***install cross ncurses error" && \
      touch ${METADATAMIPSELSYSROOT}/ncurses_cross_install
[ -f ${METADATAMIPSELSYSROOT}/ncurses_cross_mva ] || \
  mv -v ${PREFIXMIPSELSYSROOT}/lib/lib{panelw,menuw,formw,ncursesw,ncurses++w}.a \
  ${PREFIXMIPSELSYSROOT}/usr/lib || \
    die "***move *.a cross ncurses error" && \
      touch ${METADATAMIPSELSYSROOT}/ncurses_cross_mva
[ -f ${METADATAMIPSELSYSROOT}/ncurses_cross_rmso ] || \
  rm -v ${PREFIXMIPSELSYSROOT}/lib/lib{ncursesw,menuw,panelw,formw}.so || \
    die "***remove *.so cross ncurses error" && \
      touch ${METADATAMIPSELSYSROOT}/ncurses_cross_rmso
ln -sfv ../../lib/libncursesw.so.5 ${PREFIXMIPSELSYSROOT}/usr/lib/libncursesw.so
ln -sfv ../../lib/libmenuw.so.5 ${PREFIXMIPSELSYSROOT}/usr/lib/libmenuw.so
ln -sfv ../../lib/libpanelw.so.5 ${PREFIXMIPSELSYSROOT}/usr/lib/libpanelw.so
ln -sfv ../../lib/libformw.so.5 ${PREFIXMIPSELSYSROOT}/usr/lib/libformw.so
for lib in curses ncurses form panel menu ; do
    echo "INPUT(-l${lib}w)" > ${PREFIXMIPSELSYSROOT}/usr/lib/lib${lib}.so
    ln -sfv lib${lib}w.a ${PREFIXMIPSELSYSROOT}/usr/lib/lib${lib}.a
done
ln -sfv libncursesw.so ${PREFIXMIPSELSYSROOT}/usr/lib/libcursesw.so
ln -sfv libncursesw.a ${PREFIXMIPSELSYSROOT}/usr/lib/libcursesw.a
ln -sfv libncurses++w.a ${PREFIXMIPSELSYSROOT}/usr/lib/libncurses++.a
ln -sfv ncursesw5-config ${PREFIXMIPSELSYSROOT}/usr/bin/ncurses5-config
ln -sfv ../share/terminfo ${PREFIXMIPSELSYSROOT}/usr/lib/terminfo
popd

pushd ${SRCMIPSELSYSROOT}
cd util-${UTIL_VERSION}
cp hwclock/hwclock.c{,.orig}
sed -e 's@etc/adjtime@var/lib/hwclock/adjtime@g' \
    hwclock/hwclock.c.orig > hwclock/hwclock.c
popd

pushd ${BUILDMIPSELSYSROOT}
[ -d "util_linux_build" ] || mkdir util_linux_build
cd util_linux_build
cat > config.cache << EOF
scanf_cv_type_modifier=ms
EOF
mkdir -pv ${PREFIXMIPSELSYSROOT}/var/lib/hwclock
[ -f ${METADATAMIPSELSYSROOT}/util_linux_configure ] || \
  ${SRCMIPSELSYSROOT}/util-${UTIL_VERSION}/configure \
  --build=${CROSS_HOST} \
  --host=${CROSS_TARGET32} \
  --enable-arch --enable-partx --disable-wall \
  --enable-write --disable-makeinstall-chown \
  --cache-file=config.cache || \
    die "***config util-linux error" && \
      touch ${METADATAMIPSELSYSROOT}/util_linux_configure
[ -f ${METADATAMIPSELSYSROOT}/util_linux_build ] || \
  make -j${JOBS} || \
    die "***build util-linux error" && \
      touch ${METADATAMIPSELSYSROOT}/util_linux_build
[ -f ${METADATAMIPSELSYSROOT}/util_linux_install ] || \
  make DESTDIR=${PREFIXMIPSELSYSROOT} install || \
    die "***install util-linux error" && \
      touch ${METADATAMIPSELSYSROOT}/util_linux_install
[ -f ${METADATAMIPSELSYSROOT}/util_linux_mv ] || \
  mv -v ${PREFIXMIPSELSYSROOT}/usr/bin/logger ${PREFIXMIPSELSYSROOT}/bin || \
    die "***move looger util-linux error" && \
      touch ${METADATAMIPSELSYSROOT}/util_linux_mv
popd

pushd ${BUILDMIPSELSYSROOT}
[ -d e2fs_build ] || mkdir e2fs_build
cd e2fs_build
[ -f ${METADATAMIPSELSYSROOT}/e2fs_configure ] || \
  PKG_CONFIG=true LDFLAGS="-lblkid -luuid" \
  ${SRCMIPSELSYSROOT}/e2fsprogs-${E2FSPROGS_VERSION}/configure \
  --build=${CROSS_HOST} \
  --host=${CROSS_TARGET32} \
  --prefix=/usr --with-root-prefix="" \
  --enable-elf-shlibs --disable-libblkid \
  --disable-libuuid --disable-fsck --disable-uuidd \
  --cache-file=config.cache || \
    die "***config e2fsprogs error" && \
      touch ${METADATAMIPSELSYSROOT}/e2fs_configure
[ -f ${METADATAMIPSELSYSROOT}/e2fs_build ] || \
  make -j${JOBS} || \
    die "***build e2fsprogs error" && \
      touch ${METADATAMIPSELSYSROOT}/e2fs_build
[ -f ${METADATAMIPSELSYSROOT}/e2fs_install ] || \
  make DESTDIR=${PREFIXMIPSELSYSROOT} install || \
    die "***install e2fsprogs error" && \
      touch ${METADATAMIPSELSYSROOT}/e2fs_install
[ -f ${METADATAMIPSELSYSROOT}/e2fs_install_libs ] || \
  make DESTDIR=${PREFIXMIPSELSYSROOT} install-libs || \
    die "***install e2fsprogs libs error" && \
      touch ${METADATAMIPSELSYSROOT}/e2fs_install_libs
[ -f ${METADATAMIPSELSYSROOT}/e2fs_install_rmso ] || \
  rm -v ${PREFIXMIPSELSYSROOT}/usr/lib/lib{com_err,e2p,ext2fs,ss}.so || \
    die "***remove *.so e2fsprogs libs error" && \
      touch ${METADATAMIPSELSYSROOT}/e2fs_install_rmso
ln -sv ../../lib/libcom_err.so.2 ${PREFIXMIPSELSYSROOT}/usr/lib/libcom_err.so
ln -sv ../../lib/libe2p.so.2 ${PREFIXMIPSELSYSROOT}/usr/lib/libe2p.so
ln -sv ../../lib/libext2fs.so.2 ${PREFIXMIPSELSYSROOT}/usr/lib/libext2fs.so
ln -sv ../../lib/libss.so.2 ${PREFIXMIPSELSYSROOT}/usr/lib/libss.so
popd

pushd ${BUILDMIPSELSYSROOT}
[ -d coreutils_build ] || mkdir coreutils_build
cd coreutils_build
touch man/uname.1 man/hostname.1
cat > config.cache << EOF
fu_cv_sys_stat_statfs2_bsize=yes
gl_cv_func_rename_trailing_slash_bug=no
gl_cv_func_mbrtowc_incomplete_state=yes
gl_cv_func_mbrtowc_nul_retval=yes
gl_cv_func_mbrtowc_null_arg=yes
gl_cv_func_mbrtowc_retval=yes
gl_cv_func_btowc_eof=yes
gl_cv_func_wcrtomb_retval=yes
gl_cv_func_wctob_works=yes
EOF
[ -f ${METADATAMIPSELSYSROOT}/coreutils_configure ] || \
  ${SRCMIPSELSYSROOT}/coreutils-${COREUTILS_VERSION}/configure \
  --build=${CROSS_HOST} \
  --host=${CROSS_TARGET32} \
  --prefix=/usr --cache-file=config.cache \
  --enable-no-install-program=kill,uptime \
  --enable-install-program=hostname || \
    die "***config coreutils error" && \
      touch ${METADATAMIPSELSYSROOT}/coreutils_configure
[ -f ${METADATAMIPSELSYSROOT}/coreutils_build ] || \
  make -j${JOBS} || \
    die "***build coreutils error" && \
      touch ${METADATAMIPSELSYSROOT}/coreutils_build
[ -f ${METADATAMIPSELSYSROOT}/coreutils_install ] || \
  make DESTDIR=${PREFIXMIPSELSYSROOT} install || \
    die "***install coreutils error" && \
      touch ${METADATAMIPSELSYSROOT}/coreutils_install
[ -f ${METADATAMIPSELSYSROOT}/coreutils_move1 ] || \
  mv -v ${PREFIXMIPSELSYSROOT}/usr/bin/{cat,chgrp,chmod,chown,cp,date} ${PREFIXMIPSELSYSROOT}/bin || \
    die "***move usr/bin/* coreutils first error" && \
      touch ${METADATAMIPSELSYSROOT}/coreutils_move1
[ -f ${METADATAMIPSELSYSROOT}/coreutils_move2 ] || \
  mv -v ${PREFIXMIPSELSYSROOT}/usr/bin/{dd,df,echo,false,hostname,ln,ls,mkdir} ${PREFIXMIPSELSYSROOT}/bin || \
    die "***move usr/bin/* coreutils second error" && \
      touch ${METADATAMIPSELSYSROOT}/coreutils_move2
[ -f ${METADATAMIPSELSYSROOT}/coreutils_move3 ] || \
  mv -v ${PREFIXMIPSELSYSROOT}/usr/bin/{mv,pwd,rm,rmdir,stty,true,uname} ${PREFIXMIPSELSYSROOT}/bin || \
    die "***move usr/bin/* coreutils third error" && \
      touch ${METADATAMIPSELSYSROOT}/coreutils_move3
[ -f ${METADATAMIPSELSYSROOT}/coreutils_move4 ] || \
  mv -v ${PREFIXMIPSELSYSROOT}/usr/bin/chroot ${PREFIXMIPSELSYSROOT}/usr/sbin || \
    die "***move usr/bin/* coreutils fourth error" && \
      touch ${METADATAMIPSELSYSROOT}/coreutils_move4
[ -f ${METADATAMIPSELSYSROOT}/coreutils_move5 ] || \
  mv -v ${PREFIXMIPSELSYSROOT}/usr/bin/{[,basename,head,install,nice} ${PREFIXMIPSELSYSROOT}/bin || \
    die "***move usr/bin/* coreutils fifth error" && \
      touch ${METADATAMIPSELSYSROOT}/coreutils_move5
[ -f ${METADATAMIPSELSYSROOT}/coreutils_move6 ] || \
  mv -v ${PREFIXMIPSELSYSROOT}/usr/bin/{readlink,sleep,sync,test,touch} ${PREFIXMIPSELSYSROOT}/bin || \
    die "***move usr/bin/* coreutils sixth error" && \
      touch ${METADATAMIPSELSYSROOT}/coreutils_move6
[ -f ${METADATAMIPSELSYSROOT}/coreutils_link ] || \
  ln -sfv ../../bin/install ${PREFIXMIPSELSYSROOT}/usr/bin || \
    die "***link usr/bin/install coreutils error" && \
      touch ${METADATAMIPSELSYSROOT}/coreutils_link
popd

pushd ${BUILDMIPSELSYSROOT}
cd iana-etc-${IANA_VERSION}
[ -f ${METADATAMIPSELSYSROOT}/iana_build ] || \
  make -j${JOBS} || \
    die "***build iana-etc error" && \
      touch ${METADATAMIPSELSYSROOT}/iana_build
[ -f ${METADATAMIPSELSYSROOT}/iana_install ] || \
  make DESTDIR=${PREFIXMIPSELSYSROOT} install || \
    die "***install iana-etc error" && \
      touch ${METADATAMIPSELSYSROOT}/iana_install
popd

pushd ${BUILDMIPSELSYSROOT}
[ -d m4_build ] || mkdir m4_build
cd m4_build
cat > config.cache << EOF
gl_cv_func_btowc_eof=yes
gl_cv_func_mbrtowc_incomplete_state=yes
gl_cv_func_mbrtowc_sanitycheck=yes
gl_cv_func_mbrtowc_null_arg=yes
gl_cv_func_mbrtowc_retval=yes
gl_cv_func_mbrtowc_nul_retval=yes
gl_cv_func_wcrtomb_retval=yes
gl_cv_func_wctob_works=yes
EOF
[ -f ${METADATAMIPSELSYSROOT}/m4_configure ] || \
  ${SRCMIPSELSYSROOT}/m4-${M4_VERSION}/configure --build=${CROSS_HOST} \
  --host=${CROSS_TARGET32} \
  --prefix=/usr --cache-file=config.cache || \
    die "***config m4 error" && \
      touch ${METADATAMIPSELSYSROOT}/m4_configure
[ -f ${METADATAMIPSELSYSROOT}/m4_build ] || \
  make -j${JOBS} || \
    die "***build m4 error" && \
      touch ${METADATAMIPSELSYSROOT}/m4_build
[ -f ${METADATAMIPSELSYSROOT}/m4_install ] || \
  make DESTDIR=${PREFIXMIPSELSYSROOT} install || \
    die "***install m4 error" && \
      touch ${METADATAMIPSELSYSROOT}/m4_install
popd

pushd ${BUILDMIPSELSYSROOT}
[ -d bison_build ] || mkdir bison_build
cd bison_build
[ -f ${METADATAMIPSELSYSROOT}/bison_configure ] || \
  CC=${CC} ${SRCMIPSELSYSROOT}/bison-${BISON_VERSION}/configure \
  --build=${CROSS_HOST} --host=${CROSS_TARGET32} \
  --prefix=/usr || \
    die "***config bison error" && \
      touch ${METADATAMIPSELSYSROOT}/bison_configure
cat >> config.h << "EOF"
#define YYENABLE_NLS 1
EOF
[ -f ${METADATAMIPSELSYSROOT}/bison_build ] || \
  make -j${JOBS} || \
    die "***build bison error" && \
      touch ${METADATAMIPSELSYSROOT}/bison_build
[ -f ${METADATAMIPSELSYSROOT}/bison_install ] || \
  make DESTDIR=${PREFIXMIPSELSYSROOT} install || \
    die "***install bison error" && \
      touch ${METADATAMIPSELSYSROOT}/bison_install
popd

pushd ${SRCMIPSELSYSROOT}
cd procps-${PROCPS_VERSION}
[ -f ${METADATAMIPSELSYSROOT}/procps_build ] || \
  make CPPFLAGS= lib64=lib m64= || \
    die "***build procps error" && \
      touch ${METADATAMIPSELSYSROOT}/procps_build
[ -f ${METADATAMIPSELSYSROOT}/procps_install ] || \
  make DESTDIR=${PREFIXMIPSELSYSROOT} lib64=lib m64= ldconfig= \
  install="install -D" install || \
    die "***install procps error" && \
      touch ${METADATAMIPSELSYSROOT}/procps_install
popd

pushd ${BUILDMIPSELSYSROOT}
[ -d libtool_build ] || mkdir libtool_build
cd libtool_build
[ -f ${METADATAMIPSELSYSROOT}/libtool_configure ] || \
  ${SRCMIPSELSYSROOT}/libtool-${LIBTOOL_VERSION}/configure \
  --build=${CROSS_HOST} \
  --host=${CROSS_TARGET32} \
  --prefix=/usr || \
    die "***config libtool error" && \
      touch ${METADATAMIPSELSYSROOT}/libtool_configure
[ -f ${METADATAMIPSELSYSROOT}/libtool_build ] || \
  make -j${JOBS} || \
    die "***build libtool error" && \
      touch ${METADATAMIPSELSYSROOT}/libtool_build
[ -f ${METADATAMIPSELSYSROOT}/libtool_install ] || \
  make DESTDIR=${PREFIXMIPSELSYSROOT} install || \
    die "***install libtool error" && \
      touch ${METADATAMIPSELSYSROOT}/libtool_install
popd

pushd ${SRCMIPSELSYSROOT}
cd flex-${FLEX_VERSION}
cp -v Makefile.in{,.orig}
sed "s/-I@includedir@//g" Makefile.in.orig > Makefile.in

cat > config.cache << EOF
ac_cv_func_malloc_0_nonnull=yes
ac_cv_func_realloc_0_nonnull=yes
EOF
[ -f ${METADATAMIPSELSYSROOT}/flex_configure ] || \
  CC=${CC} ./configure \
  --build=${CROSS_HOST} --host=${CROSS_TARGET32} \
  --prefix=/usr --cache-file=config.cache || \
    die "***config flex error" && \
      touch ${METADATAMIPSELSYSROOT}/flex_configure
[ -f ${METADATAMIPSELSYSROOT}/flex_makelibfl ] || \
  make CC="${CC} -fPIC" libfl.a || \
    die "***make flex libfl.a error" && \
      touch ${METADATAMIPSELSYSROOT}/flex_makelibfl
[ -f ${METADATAMIPSELSYSROOT}/flex_build ] || \
make -j${JOBS} || die "***build flex error" && \
      touch ${METADATAMIPSELSYSROOT}/flex_build
[ -f ${METADATAMIPSELSYSROOT}/flex_install ] || \
  make DESTDIR=${PREFIXMIPSELSYSROOT} install || \
    die "***install flex error" && \
      touch ${METADATAMIPSELSYSROOT}/flex_install
ln -sfv libfl.a ${PREFIXMIPSELSYSROOT}/usr/lib/libl.a
[ -f ${METADATAMIPSELSYSROOT}/flex_cat ] || \
`cat > ${PREFIXMIPSELSYSROOT}/usr/bin/lex << "EOF"
#!/bin/sh
# Begin /usr/bin/lex

exec /usr/bin/flex -l "$@"

# End /usr/bin/lex
EOF` || \
  die "***cat /usr/bin/lex flex error" && \
    touch ${METADATAMIPSELSYSROOT}/flex_cat
chmod -v 755 ${PREFIXMIPSELSYSROOT}/usr/bin/lex
popd

pushd ${BUILDMIPSELSYSROOT}
cd iproute2-${IPROUTE2_VERSION}
for dir in ip misc tc; do
    cp ${dir}/Makefile{,.orig}
    sed 's/0755 -s/0755/' ${dir}/Makefile.orig > ${dir}/Makefile
done
cp misc/Makefile{,.orig}
sed '/^TARGETS/s@arpd@@g' misc/Makefile.orig > misc/Makefile
[ -f ${METADATAMIPSELSYSROOT}/iproute2_build1 ] || \
  make DESTDIR=${PREFIXMIPSELSYSROOT} CC="${CC}" \
       DOCDIR=/usr/share/doc/iproute2 \
       MANDIR=/usr/share/man  || \
         die "***build iproute2 error" && \
           touch ${METADATAMIPSELSYSROOT}/iproute2_build1
[ -f ${METADATAMIPSELSYSROOT}/iproute2_build2 ] || \
  make DESTDIR=${PREFIXMIPSELSYSROOT}  \
       DOCDIR=/usr/share/doc/iproute2 \
       MANDIR=/usr/share/man install || \
         die "***install iproute2 error"
             touch ${METADATAMIPSELSYSROOT}/iproute2_build2
popd

## FIXME
#pushd ${SRCMIPSELSYSROOT}
#cd perl-${PERL_VERSION}
##patch -p1 < ${PATCH}/perl-${PERL_VERSION}-cross_compile-1.patch \
##  || die "patch perl error"
#chmod -v 644 Makefile.SH
#cp -v Makefile.SH{,.orig}
#sed -e "s@pldlflags=''@pldlflags=\"\$cccdlflags\"@g" \
#    -e "s@static_target='static'@static_target='static_pic'@g" Makefile.SH.orig > Makefile.SH
#sed -i -e '/^BUILD_ZLIB/ s/True/False/' \
#       -e '/^INCLUDE\|^LIB/ s|\./zlib-src|/usr/include|' \
#       ext/Compress/Raw/Zlib/config.in
#cd Cross
#
#[ -f ${METADATAMIPSELSYSROOT}/perl_build ] || \
#  make ARCH=mips PREFIXMIPSELSYSROOT_COMPILE=${CROSS_TARGET32}-  || \
#    die "***build perl error"
#      touch ${METADATAMIPSELSYSROOT}/perl_build
#[ -f ${METADATAMIPSELSYSROOT}/perl_install ] || \
#  make DESTDIR=${PREFIXMIPSELSYSROOT} install || \
#    die "***install perl error"
#      touch ${METADATAMIPSELSYSROOT}/perl_install
#popd

pushd ${BUILDMIPSELSYSROOT}
[ -d readline_build ] || mkdir readline_build
cd readline_build
[ -f ${METADATAMIPSELSYSROOT}/readline_configure ] || \
  ${SRCMIPSELSYSROOT}/readline-${READLINE_VERSION}/configure \
  --build=${CROSS_HOST} --host=${CROSS_TARGET32} \
  --prefix=/usr --libdir=/lib || \
    die "***config readline error" && \
      touch ${METADATAMIPSELSYSROOT}/readline_configure
[ -f ${METADATAMIPSELSYSROOT}/readline_build ] || \
  make -j${JOBS} || \
    die "***build readline error" && \
      touch ${METADATAMIPSELSYSROOT}/readline_build
[ -f ${METADATAMIPSELSYSROOT}/readline_install ] || \
  make DESTDIR=${PREFIXMIPSELSYSROOT} install || \
    die "***install readline error" && \
      touch ${METADATAMIPSELSYSROOT}/readline_install
[ -f ${METADATAMIPSELSYSROOT}/readline_installdoc ] || \
  make DESTDIR=${PREFIXMIPSELSYSROOT} install-doc || \
    die "***install readline doc error" && \
      touch ${METADATAMIPSELSYSROOT}/readline_installdoc
[ -f ${METADATAMIPSELSYSROOT}/readline_mva ] || \
  mv -v ${PREFIXMIPSELSYSROOT}/lib/lib{readline,history}.a ${PREFIXMIPSELSYSROOT}/usr/lib || \
    die "***move *.a readline doc error" && \
      touch ${METADATAMIPSELSYSROOT}/readline_mva
[ -f ${METADATAMIPSELSYSROOT}/readline_rmso ] || \
  rm -v ${PREFIXMIPSELSYSROOT}/lib/lib{readline,history}.so || \
    die "***remove *.a readline doc error" && \
      touch ${METADATAMIPSELSYSROOT}/readline_rmso
ln -sfv ../../lib/libreadline.so.6 ${PREFIXMIPSELSYSROOT}/usr/lib/libreadline.so
ln -sfv ../../lib/libhistory.so.6 ${PREFIXMIPSELSYSROOT}/usr/lib/libhistory.so
popd

pushd ${BUILDMIPSELSYSROOT}
[ -d autoconf_build ] || mkdir autoconf_build
cd autoconf_build
[ -f ${METADATAMIPSELSYSROOT}/autoconf_configure ] || \
  ${SRCMIPSELSYSROOT}/autoconf-${AUTOCONF_VERSION}/configure \
  --build=${CROSS_HOST} \
  --host=${CROSS_TARGET32} --prefix=/usr || \
    die "***config autoconf error" && \
      touch ${METADATAMIPSELSYSROOT}/autoconf_configure
[ -f ${METADATAMIPSELSYSROOT}/autoconf_build ] || \
  make -j${JOBS} || \
    die "***build autoconf error" && \
      touch ${METADATAMIPSELSYSROOT}/autoconf_build
[ -f ${METADATAMIPSELSYSROOT}/autoconf_install ] || \
  make DESTDIR=${PREFIXMIPSELSYSROOT} install || \
    die "***install autoconf error" && \
      touch ${METADATAMIPSELSYSROOT}/autoconf_install
popd

pushd ${BUILDMIPSELSYSROOT}
[ -d automake_build ] || mkdir automake_build
cd automake_build
[ -f ${METADATAMIPSELSYSROOT}/automake_configure ] || \
  ${SRCMIPSELSYSROOT}/automake-${AUTOMAKE_VERSION}/configure \
  --build=${CROSS_HOST} \
  --host=${CROSS_TARGET32} --prefix=/usr || \
    die "***config automake error" && \
      touch ${METADATAMIPSELSYSROOT}/automake_configure
[ -f ${METADATAMIPSELSYSROOT}/automake_build ] || \
  make -j${JOBS} || \
    die "***build automake error" && \
      touch ${METADATAMIPSELSYSROOT}/automake_build
[ -f ${METADATAMIPSELSYSROOT}/automake_install ] || \
  make DESTDIR=${PREFIXMIPSELSYSROOT} install || \
    die "***install automake error" && \
      touch ${METADATAMIPSELSYSROOT}/automake_install
popd

pushd ${SRCMIPSELSYSROOT}
cd bash-${BASH_VERSION}
[ -f ${METADATAMIPSELSYSROOT}/bash_patch ] || \
  patch -Np1 -i ${PATCH}/bash-4.2-branch_update-4.patch || \
    die "***Patch bash error" && \
      touch ${METADATAMIPSELSYSROOT}/bash_patch
popd

pushd ${BUILDMIPSELSYSROOT}
[ -d bash_build ] || mkdir bash_build
cd bash_build
cat > config.cache << "EOF"
ac_cv_func_mmap_fixed_mapped=yes
ac_cv_func_strcoll_works=yes
ac_cv_func_working_mktime=yes
bash_cv_func_sigsetjmp=present
bash_cv_getcwd_malloc=yes
bash_cv_job_control_missing=present
bash_cv_printf_a_format=yes
bash_cv_sys_named_pipes=present
bash_cv_ulimit_maxfds=yes
bash_cv_under_sys_siglist=yes
bash_cv_unusable_rtsigs=no
gt_cv_int_divbyzero_sigfpe=yes
EOF
[ -f ${METADATAMIPSELSYSROOT}/bash_configure ] || \
  ${SRCMIPSELSYSROOT}/bash-${BASH_VERSION}/configure \
  --build=${CROSS_HOST} --host=${CROSS_TARGET32} \
  --prefix=/usr --bindir=/bin --cache-file=config.cache \
  --without-bash-malloc --with-installed-readline || \
    die "***config bash error" && \
      touch ${METADATAMIPSELSYSROOT}/bash_configure
[ -f ${METADATAMIPSELSYSROOT}/bash_build ] || \
  make -j${JOBS} || \
    die "***build bash error" && \
      touch ${METADATAMIPSELSYSROOT}/bash_build
[ -f ${METADATAMIPSELSYSROOT}/bash_install ] || \
  make DESTDIR=${PREFIXMIPSELSYSROOT} htmldir=/usr/share/doc/bash-4.2 install || \
    die "***install bash error" && \
      touch ${METADATAMIPSELSYSROOT}/bash_install
[ -f ${METADATAMIPSELSYSROOT}/bash_link ] || \
  ln -svf bash ${PREFIXMIPSELSYSROOT}/bin/sh || \
    die "***link bash error" && \
      touch ${METADATAMIPSELSYSROOT}/bash_link
popd

pushd ${BUILDMIPSELSYSROOT}
cd bzip2-${BZIP2_VERSION}
cp Makefile{,.orig}
sed -e "/^all:/s/ test//" Makefile.orig > Makefile
sed -i -e 's:ln -s -f $(PREFIX)/bin/:ln -s :' Makefile
[ -f ${METADATAMIPSELSYSROOT}/bzip2_make ] || \
  make -f Makefile-libbz2_so CC="${CC}" AR="${AR}" RANLIB="${RANLIB}" || \
    die "***bzip make -f Makefile-libbz2_so error" && \
      touch ${METADATAMIPSELSYSROOT}/bzip2_make
[ -f ${METADATAMIPSELSYSROOT}/bzip2_clean ] || \
  make clean || \
    die "***clean bzip error" && \
      touch ${METADATAMIPSELSYSROOT}/bzip2_clean
[ -f ${METADATAMIPSELSYSROOT}/bzip2_build ] || \
  make CC="${CC}" AR="${AR}" RANLIB="${RANLIB}" || \
    die "***build bzip2 error" && \
      touch ${METADATAMIPSELSYSROOT}/bzip2_build
[ -f ${METADATAMIPSELSYSROOT}/bzip2_install ] || \
  make PREFIX=${PREFIXMIPSELSYSROOT}/usr install || \
    die "***install bzip2 error" && \
      touch ${METADATAMIPSELSYSROOT}/bzip2_install
[ -f ${METADATAMIPSELSYSROOT}/bzip2_copy_shared ] || \
  cp -v bzip2-shared ${PREFIXMIPSELSYSROOT}/bin/bzip2 || \
    die "***copy bzip2 error" && \
        touch ${METADATAMIPSELSYSROOT}/bzip2_copy_shared
[ -f ${METADATAMIPSELSYSROOT}/bzip2_copy_lib ] || \
  cp -av libbz2.so* ${PREFIXMIPSELSYSROOT}/lib || \
    die "***copy bzip2 error" && \
      touch ${METADATAMIPSELSYSROOT}/bzip2_copy_lib
ln -sfv ../../lib/libbz2.so.1.0 ${PREFIXMIPSELSYSROOT}/usr/lib/libbz2.so
[ -f ${METADATAMIPSELSYSROOT}/bzip2_remove ] || \
  rm -v ${PREFIXMIPSELSYSROOT}/usr/bin/{bunzip2,bzcat,bzip2} || \
    die "***remove bzip2 error" && \
      touch ${METADATAMIPSELSYSROOT}/bzip2_remove
ln -sfv bzip2 ${PREFIXMIPSELSYSROOT}/bin/bunzip2
ln -sfv bzip2 ${PREFIXMIPSELSYSROOT}/bin/bzcat
popd


pushd ${BUILDMIPSELSYSROOT}
[ -d diffutils_build ] || mkdir diffutils_build
cd diffutils_build
[ -f ${METADATAMIPSELSYSROOT}/diffutils_configure ] || \
  ${SRCMIPSELSYSROOT}/diffutils-${DIFFUTILS_VERSION}/configure \
  --prefix=/usr --build=${CROSS_HOST} \
  --host=${CROSS_TARGET32} || \
    die "***config diffutils error" && \
      touch ${METADATAMIPSELSYSROOT}/diffutils_configure
sed -i 's@\(^#define DEFAULT_EDITOR_PROGRAM \).*@\1"vi"@' config.h
touch man/*.1
[ -f ${METADATAMIPSELSYSROOT}/diffutils_build ] || \
  make -j${JOBS} || \
    die "***build diffutils error" && \
      touch ${METADATAMIPSELSYSROOT}/diffutils_build
[ -f ${METADATAMIPSELSYSROOT}/diffutils_install ] || \
  make DESTDIR=${PREFIXMIPSELSYSROOT} install || \
    die "***install diffutils error" && \
      touch ${METADATAMIPSELSYSROOT}/diffutils_install
popd

pushd ${BUILDMIPSELSYSROOT}
[ -d file_cross_build ] || mkdir file_cross_build
cd file_cross_build
[ -f ${METADATAMIPSELSYSROOT}/file_cross_configure ] || \
  ${SRCMIPSELSYSROOT}/file-${FILE11_VERSION}/configure \
  --prefix=/usr --build=${CROSS_HOST} \
  --host=${CROSS_TARGET32} || \
    die "***config cross file error" && \
      touch ${METADATAMIPSELSYSROOT}/file_cross_configure
[ -f ${METADATAMIPSELSYSROOT}/file_cross_build ] || \
  make -j${JOBS} || \
    die "***build cross file error" && \
      touch ${METADATAMIPSELSYSROOT}/file_cross_build
[ -f ${METADATAMIPSELSYSROOT}/file_cross_install ] || \
  make DESTDIR=${PREFIXMIPSELSYSROOT} install || \
    die "***install file error" && \
      touch ${METADATAMIPSELSYSROOT}/file_cross_install
popd

pushd ${BUILDMIPSELSYSROOT}
[ -d findutils_cross_build ] || mkdir findutils_cross_build
cd findutils_cross_build
cat > config.cache << EOF
gl_cv_func_wcwidth_works=yes
gl_cv_header_working_fcntl_h=yes
ac_cv_func_fnmatch_gnu=yes
EOF
[ -f ${METADATAMIPSELSYSROOT}/findutils_configure ] || \
  ${SRCMIPSELSYSROOT}/findutils-${FINDUTILS_VERSION}/configure \
  --build=${CROSS_HOST} \
  --host=${CROSS_TARGET32} \
  --prefix=/usr --cache-file=config.cache \
  --libexecdir=/usr/lib/locate \
  --localstatedir=/var/lib/locate || \
    die "***config findutils error" && \
      touch ${METADATAMIPSELSYSROOT}/findutils_configure
[ -f ${METADATAMIPSELSYSROOT}/findutils_build ] || \
  make -j${JOBS} || \
    die "***build findutils error" && \
      touch ${METADATAMIPSELSYSROOT}/findutils_build
[ -f ${METADATAMIPSELSYSROOT}/findutils_install ] || \
  make DESTDIR=${PREFIXMIPSELSYSROOT} install || \
    die "***install findutils error" && \
      touch ${METADATAMIPSELSYSROOT}/findutils_install
[ -f ${METADATAMIPSELSYSROOT}/findutils_mv ] || \
  mv -v ${PREFIXMIPSELSYSROOT}/usr/bin/find ${PREFIXMIPSELSYSROOT}/bin || \
    die "***move find findutils error" && \
      touch ${METADATAMIPSELSYSROOT}/findutils_mv
[ -f ${METADATAMIPSELSYSROOT}/findutils_cp ] || \
  cp ${PREFIXMIPSELSYSROOT}/usr/bin/updatedb{,.orig} || \
    die "***copy findutils error" && \
      touch ${METADATAMIPSELSYSROOT}/findutils_cp
[ -f ${METADATAMIPSELSYSROOT}/findutils_sed ] || \
  sed 's@find:=${BINDIR}@find:=/bin@' ${PREFIXMIPSELSYSROOT}/usr/bin/updatedb.orig > \
    ${PREFIXMIPSELSYSROOT}/usr/bin/updatedb || \
    die "***copy findutils error" && \
      touch ${METADATAMIPSELSYSROOT}/findutils_sed
[ -f ${METADATAMIPSELSYSROOT}/findutils_rm ] || \
  rm ${PREFIXMIPSELSYSROOT}/usr/bin/updatedb.orig || \
    die "***remove updatedb.orig findutils error" && \
      touch ${METADATAMIPSELSYSROOT}/findutils_rm
popd

pushd ${BUILDMIPSELSYSROOT}
[ -d gawk_build ] || mkdir gawk_build
cd gawk_build
[ -f ${METADATAMIPSELSYSROOT}/gawk_configure ] || \
  ${SRCMIPSELSYSROOT}/gawk-${GAWK_VERSION}/configure \
  --build=${CROSS_HOST} \
  --host=${CROSS_TARGET32} \
  --prefix=/usr --libexecdir=/usr/lib \
  --disable-libsigsegv || \
    die "***config gawk error" && \
      touch ${METADATAMIPSELSYSROOT}/gawk_configure
[ -f ${METADATAMIPSELSYSROOT}/gawk_build ] || \
  make -j${JOBS} || \
    die "***build gawk error" && \
      touch ${METADATAMIPSELSYSROOT}/gawk_build
[ -f ${METADATAMIPSELSYSROOT}/gawk_install ] || \
  make DESTDIR=${PREFIXMIPSELSYSROOT} install || \
    die "***install gawk error" && \
      touch ${METADATAMIPSELSYSROOT}/gawk_install
popd

pushd ${BUILDMIPSELSYSROOT}
[ -d gettext_build ] || mkdir gettext_build
cd gettext_build
cat > config.cache << EOF
am_cv_func_iconv_works=yes
gl_cv_func_wcwidth_works=yes
gt_cv_func_printf_posix=yes
gt_cv_int_divbyzero_sigfpe=yes
EOF
[ -f ${METADATAMIPSELSYSROOT}/gettext_configure ] || \
  ${SRCMIPSELSYSROOT}/gettext-${GETTEXT_VERSION}/configure \
  --build=${CROSS_HOST} \
  --host=${CROSS_TARGET32} \
  --prefix=/usr --cache-file=config.cache || \
    die "***config gettext error" && \
      touch ${METADATAMIPSELSYSROOT}/gettext_configure
[ -f ${METADATAMIPSELSYSROOT}/gettext_build ] || \
  make -j${JOBS} || \
    die "***build gettext error" && \
      touch ${METADATAMIPSELSYSROOT}/gettext_build
[ -f ${METADATAMIPSELSYSROOT}/gettext_install ] || \
  make DESTDIR=${PREFIXMIPSELSYSROOT} install || \
    die "***install gettext error" && \
      touch ${METADATAMIPSELSYSROOT}/gettext_install
popd

pushd ${BUILDMIPSELSYSROOT}
[ -d "grep_build" ] || mkdir grep_build
cd grep_build
[ -f ${METADATAMIPSELSYSROOT}/grep_configure ] || \
  ${SRCMIPSELSYSROOT}/grep-${GREP_VERSION}/configure \
  --build=${CROSS_HOST} --host=${CROSS_TARGET32} \
  --prefix=/usr --bindir=/bin --disable-perl-regexp || \
    die "***config grep error" && \
      touch ${METADATAMIPSELSYSROOT}/grep_configure
[ -f ${METADATAMIPSELSYSROOT}/grep_build ] || \
  make -j${JOBS} || \
    die "***build grep error" && \
      touch ${METADATAMIPSELSYSROOT}/grep_build
[ -f ${METADATAMIPSELSYSROOT}/grep_install ] || \
  make DESTDIR=${PREFIXMIPSELSYSROOT} install || \
    die "***install grep error" && \
      touch ${METADATAMIPSELSYSROOT}/grep_install
popd

pushd ${BUILDMIPSELSYSROOT}
cd groff-${GROFF_VERSION}
# FIXME This is a sub dir config, it's very strange.
  pushd src/libs/gnulib/
  [ -f ${METADATAMIPSELSYSROOT}/groff_cross_configure0 ] || \
    ./configure --build=${CROSS_HOST} \
    --host=${CROSS_TARGET32} --prefix=/usr || \
      die "confgure groff/src/libs/gnulib" && \
        touch ${METADATAMIPSELSYSROOT}/groff_cross_configure0
  popd
[ -f ${METADATAMIPSELSYSROOT}/groff_cross_configure ] || \
  PAGE=A4 ./configure --build=${CROSS_HOST} \
  --host=${CROSS_TARGET32} --prefix=/usr || \
    die "***config groff error" && \
      touch ${METADATAMIPSELSYSROOT}/groff_cross_configure
[ -f ${METADATAMIPSELSYSROOT}/groff_cross_build ] || \
  make TROFFBIN=troff GROFFBIN=groff GROFF_BIN_PATH= || \
    die "***build groff error" && \
      touch ${METADATAMIPSELSYSROOT}/groff_cross_build
[ -f ${METADATAMIPSELSYSROOT}/groff_cross_install ] || \
  make prefix=${PREFIXMIPSELSYSROOT}/usr install || \
    die "***install cross groff error" && \
      touch ${METADATAMIPSELSYSROOT}/groff_cross_install
[ -f ${METADATAMIPSELSYSROOT}/groff_cross_link1 ] || \
  ln -sfv soelim ${PREFIXMIPSELSYSROOT}/usr/bin/zsoelim || \
    die "***link1 cross groff error" && \
      touch ${METADATAMIPSELSYSROOT}/groff_cross_link1 || \
[ -f ${METADATAMIPSELSYSROOT}/groff_cross_link2 ] || \
  ln -sfv eqn ${PREFIXMIPSELSYSROOT}/usr/bin/geqn || \
    die "***link2 cross groff error" && \
      touch ${METADATAMIPSELSYSROOT}/groff_cross_link2
[ -f ${METADATAMIPSELSYSROOT}/groff_cross_link3 ] || \
  ln -sfv tbl ${PREFIXMIPSELSYSROOT}/usr/bin/gtbl || \
    die "***link3 cross groff error" && \
      touch ${METADATAMIPSELSYSROOT}/groff_cross_link3
popd

pushd ${SRCMIPSELSYSROOT}
cd gzip-${GZIP_VERSION}
[ -f ${METADATAMIPSELSYSROOT}/gzip_sed ] || \
for file in $(grep -lr futimens *); do
  cp -v ${file}{,.orig}
  sed -e "s/futimens/gl_&/" ${file}.orig > ${file}
done || \
    die "***config gzip error" && \
      touch ${METADATAMIPSELSYSROOT}/gzip_sed
popd

pushd ${BUILDMIPSELSYSROOT}
[ -d gzip_build ] || mkdir gzip_build
cd gzip_build
[ -f ${METADATAMIPSELSYSROOT}/gzip_configure ] || \
  ${SRCMIPSELSYSROOT}/gzip-${GZIP_VERSION}/configure \
  --build=${CROSS_HOST} \
  --host=${CROSS_TARGET32} \
  --prefix=/usr --bindir=/bin || \
    die "***config gzip error" && \
      touch ${METADATAMIPSELSYSROOT}/gzip_configure
[ -f ${METADATAMIPSELSYSROOT}/gzip_build ] || \
  make -j${JOBS} || \
    die "***build gzip error" && \
      touch ${METADATAMIPSELSYSROOT}/gzip_build
[ -f ${METADATAMIPSELSYSROOT}/gzip_install ] || \
  make DESTDIR=${PREFIXMIPSELSYSROOT} install || \
    die "***install gzip error" && \
      touch ${METADATAMIPSELSYSROOT}/gzip_install
[ -f ${METADATAMIPSELSYSROOT}/gzip_mv ] || \
  mv ${PREFIXMIPSELSYSROOT}/bin/z{egrep,cmp,diff,fgrep,force,grep,less,more,new} \
  ${PREFIXMIPSELSYSROOT}/usr/bin || \
    die "***move gzip error" && \
      touch ${METADATAMIPSELSYSROOT}/gzip_mv
popd

## FIXME This use gcc, Not PREFIXMIPSELSYSROOT-GCC
#pushd ${SRCMIPSELSYSROOT}
#cd iputils-${IPUTILS_VERSION}
#[ -f ${METADATAMIPSELSYSROOT}/iputils_install ] || \
#  make -j${JOBS} || \
#    die "***build iputils error" && \
#      touch ${METADATAMIPSELSYSROOT}/iputils_install
#install -v -m755 ping{,6} ${PREFIXMIPSELSYSROOT}/bin
#install -v -m755 arping ${PREFIXMIPSELSYSROOT}/usr/bin
#install -v -m755 clockdiff ${PREFIXMIPSELSYSROOT}/usr/bin
#install -v -m755 rdisc ${PREFIXMIPSELSYSROOT}/usr/bin
#install -v -m755 tracepath ${PREFIXMIPSELSYSROOT}/usr/bin
#install -v -m755 trace{path,route}6 ${PREFIXMIPSELSYSROOT}/usr/bin
#install -v -m644 doc/*.8 ${PREFIXMIPSELSYSROOT}/usr/share/man/man8
#popd

pushd ${SRCMIPSELSYSROOT}
cd kbd-${KBD_VERSION}
[ -f ${METADATAMIPSELSYSROOT}/kbd_patch ] || \
patch -p1 < ${PATCH}/kbd-${KBD_VERSION}-es.po_fix-1.patch \
  || die "patch kbd error" && \
      touch ${METADATAMIPSELSYSROOT}/kbd_patch
popd

pushd ${BUILDMIPSELSYSROOT}
[ -d kbd_build ] || mkdir kbd_build
cd kbd_build
cat > config.cache << EOF
ac_cv_func_setpgrp_void=yes
ac_cv_func_malloc_0_nonnull=yes
ac_cv_func_realloc_0_nonnull=yes
EOF
[ -f ${METADATAMIPSELSYSROOT}/kbd_configure ] || \
  ${SRCMIPSELSYSROOT}/kbd-${KBD_VERSION}/configure \
  --build=${CROSS_HOST} --host=${CROSS_TARGET32} \
  --prefix=/usr --cache-file=config.cache || \
    die "***config kbd error" && \
      touch ${METADATAMIPSELSYSROOT}/kbd_configure
[ -f ${METADATAMIPSELSYSROOT}/kbd_build ] || \
  make -j${JOBS} || \
    die "***build kbd error" && \
      touch ${METADATAMIPSELSYSROOT}/kbd_build
[ -f ${METADATAMIPSELSYSROOT}/kbd_install ] || \
  make DESTDIR=${PREFIXMIPSELSYSROOT} install || \
    die "***install kbd error" && \
      touch ${METADATAMIPSELSYSROOT}/kbd_install
[ -f ${METADATAMIPSELSYSROOT}/kbd_mv ] || \
  mv -v ${PREFIXMIPSELSYSROOT}/usr/bin/{kbd_mode,dumpkeys,loadkeys,openvt,setfont} ${PREFIXMIPSELSYSROOT}/bin || \
    die "***move kbd error" && \
      touch ${METADATAMIPSELSYSROOT}/kbd_mv
popd

pushd ${BUILDMIPSELSYSROOT}
[ -d less_build ] || mkdir less_build
cd less_build
[ -f ${METADATAMIPSELSYSROOT}/less_configure ] || \
  ${SRCMIPSELSYSROOT}/less-${LESS_VERSION}/configure \
  --build=${CROSS_HOST} --host=${CROSS_TARGET32} \
  --prefix=/usr --sysconfdir=/etc || \
    die "***config less error" && \
      touch ${METADATAMIPSELSYSROOT}/less_configure
[ -f ${METADATAMIPSELSYSROOT}/less_build ] || \
  make -j${JOBS} || \
    die "***build less error" && \
      touch ${METADATAMIPSELSYSROOT}/less_build
[ -f ${METADATAMIPSELSYSROOT}/less_install ] || \
  make prefix=${PREFIXMIPSELSYSROOT}/usr install || \
    die "***install less error" && \
      touch ${METADATAMIPSELSYSROOT}/less_install
[ -f ${METADATAMIPSELSYSROOT}/less_mv ] || \
  mv -v ${PREFIXMIPSELSYSROOT}/usr/bin/less ${PREFIXMIPSELSYSROOT}/bin || \
    die "***move less error" && \
      touch ${METADATAMIPSELSYSROOT}/less_mv
popd

pushd ${BUILDMIPSELSYSROOT}
[ -d make_build ] || mkdir make_build
cd make_build
[ -f ${METADATAMIPSELSYSROOT}/make_configure ] || \
  ${SRCMIPSELSYSROOT}/make-${MAKE_VERSION}/configure \
  --build=${CROSS_HOST} \
  --host=${CROSS_TARGET32} \
  --prefix=/usr || \
    die "***config make error" && \
      touch ${METADATAMIPSELSYSROOT}/make_configure
[ -f ${METADATAMIPSELSYSROOT}/make_build ] || \
  make -j${JOBS} || \
    die "***build make error" && \
      touch ${METADATAMIPSELSYSROOT}/make_build
[ -f ${METADATAMIPSELSYSROOT}/make_install ] || \
  make DESTDIR=${PREFIXMIPSELSYSROOT} install || \
    die "***install make error" && \
      touch ${METADATAMIPSELSYSROOT}/make_install
popd

pushd ${BUILDMIPSELSYSROOT}
cd man-${MAN_VERSION}
cp configure{,.orig}
sed -e "/PREPATH=/s@=.*@=\"$(eval echo ${PREFIXMIPSELSYSROOT}/{,usr/}{sbin,bin})\"@g" \
    -e 's@-is@&R@g' configure.orig > configure
cp src/man.conf.in{,.orig}
sed -e 's@MANPATH./usr/man@#&@g' \
    -e 's@MANPATH./usr/local/man@#&@g' \
    src/man.conf.in.orig > src/man.conf.in
[ -f ${METADATAMIPSELSYSROOT}/man_configure ] || \
  ./configure -confdir=/etc || \
    die "***config man error" && \
      touch ${METADATAMIPSELSYSROOT}/man_configure
cp conf_script{,.orig}
sed "s@${PREFIXMIPSELSYSROOT}@@" conf_script.orig > conf_script
gcc src/makemsg.c -o src/makemsg
[ -f ${METADATAMIPSELSYSROOT}/man_build ] || \
  make -j${JOBS} || \
    die "***build man error" && \
      touch ${METADATAMIPSELSYSROOT}/man_build
[ -f ${METADATAMIPSELSYSROOT}/man_install ] || \
  make DESTDIR=${PREFIXMIPSELSYSROOT} install || \
    die "***install man error" && \
      touch ${METADATAMIPSELSYSROOT}/man_install
popd

pushd ${BUILDMIPSELSYSROOT}
[ -d module_build ] || mkdir module_build
cd module_build
[ -f ${METADATAMIPSELSYSROOT}/module_configure ] || \
  ${SRCMIPSELSYSROOT}/module-init-tools-${MODULE_VERSION}/configure \
  --build=${CROSS_HOST} --host=${CROSS_TARGET32} \
  --prefix=/usr --bindir=/bin \
  --sbindir=/sbin --enable-zlib-dynamic || \
    die "***config module-init-tools error" && \
      touch ${METADATAMIPSELSYSROOT}/module_configure
[ -f ${METADATAMIPSELSYSROOT}/module_build ] || \
  make DOCBOOKTOMAN= || \
    die "***build module-init-tools error" && \
      touch ${METADATAMIPSELSYSROOT}/module_build
[ -f ${METADATAMIPSELSYSROOT}/module_install ] || \
  make DESTDIR=${PREFIXMIPSELSYSROOT} INSTALL=install install || \
    die "***install module-init-tools error" && \
      touch ${METADATAMIPSELSYSROOT}/module_install
popd

pushd ${BUILDMIPSELSYSROOT}
[ -d patch_build ] || mkdir patch_build
cd patch_build
cat > config.cache << EOF
ac_cv_path_ed_PROGRAM=ed
ac_cv_func_strnlen_working=yes
EOF
[ -f ${METADATAMIPSELSYSROOT}/patch_configure ] || \
  ${SRCMIPSELSYSROOT}/patch-${PATCH_VERSION}/configure \
  --build=${CROSS_HOST} \
  --host=${CROSS_TARGET32} \
  --prefix=/usr --cache-file=config.cache || \
    die "***config patch error" && \
      touch ${METADATAMIPSELSYSROOT}/patch_configure
[ -f ${METADATAMIPSELSYSROOT}/patch_build ] || \
  make -j${JOBS} || \
    die "***build patch error" && \
      touch ${METADATAMIPSELSYSROOT}/patch_build
[ -f ${METADATAMIPSELSYSROOT}/patch_install ] || \
  make prefix=${PREFIXMIPSELSYSROOT}/usr install || \
    die "***install patch error" && \
      touch ${METADATAMIPSELSYSROOT}/patch_install
popd

pushd ${BUILDMIPSELSYSROOT}
[ -d psmisc_build ] || mkdir psmisc_build
cd psmisc_build
cat > config.cache << EOF
ac_cv_func_malloc_0_nonnull=yes
ac_cv_func_realloc_0_nonnull=yes
EOF
[ -f ${METADATAMIPSELSYSROOT}/psmisc_configure ] || \
  ${SRCMIPSELSYSROOT}/psmisc-${PSMISC_VERSION}/configure \
  --build=${CROSS_HOST} \
  --host=${CROSS_TARGET32} \
  --prefix=/usr --exec-prefix="" \
  --cache-file=config.cache || \
    die "***config psmisc error" && \
      touch ${METADATAMIPSELSYSROOT}/psmisc_configure
[ -f ${METADATAMIPSELSYSROOT}/psmisc_build ] || \
  make -j${JOBS} || \
    die "***build psmisc error" && \
      touch ${METADATAMIPSELSYSROOT}/psmisc_build
[ -f ${METADATAMIPSELSYSROOT}/psmisc_install ] || \
  make DESTDIR=${PREFIXMIPSELSYSROOT} install || \
    die "***install psmisc error" && \
      touch ${METADATAMIPSELSYSROOT}/psmisc_install
[ -f ${METADATAMIPSELSYSROOT}/psmisc_mv ] || \
  mv -v ${PREFIXMIPSELSYSROOT}/bin/pstree* ${PREFIXMIPSELSYSROOT}/usr/bin || \
    die "***move psmisc error" && \
      touch ${METADATAMIPSELSYSROOT}/psmisc_mv
[ -f ${METADATAMIPSELSYSROOT}/psmisc_link ] || \
  ln -sfv killall ${PREFIXMIPSELSYSROOT}/bin/pidof || \
    die "***link psmisc error" && \
      touch ${METADATAMIPSELSYSROOT}/psmisc_link
popd

pushd ${BUILDMIPSELSYSROOT}
[ -d shadow_cross_build ] || mkdir shadow_cross_build
cd shadow_cross_build
cat > config.cache << EOF
ac_cv_func_setpgrp_void=yes
EOF
[ -f ${METADATAMIPSELSYSROOT}/shadow_cross_configure ] || \
  ${SRCMIPSELSYSROOT}/shadow-${SHADOW_VERSION}/configure \
  --build=${CROSS_HOST} --host=${CROSS_TARGET32} \
  --sysconfdir=/etc --without-libpam \
  --without-audit --without-selinux \
  --cache-file=config.cache || \
    die "***config shadow error" && \
      touch ${METADATAMIPSELSYSROOT}/shadow_cross_configure
cp src/Makefile{,.orig}
sed 's/groups$(EXEEXT) //' src/Makefile.orig > src/Makefile
for mkf in $(find man -name Makefile)
do
  cp ${mkf}{,.orig}
  sed -e '/groups.1.xml/d' -e 's/groups.1 //' ${mkf}.orig > ${mkf}
done
[ -f ${METADATAMIPSELSYSROOT}/shadow_cross_build ] || \
  make -j${JOBS} || \
    die "***build shadow error" && \
      touch ${METADATAMIPSELSYSROOT}/shadow_cross_build
[ -f ${METADATAMIPSELSYSROOT}/shadow_cross_install ] || \
  make DESTDIR=${PREFIXMIPSELSYSROOT} install || \
    die "***install shadow error" && \
      touch ${METADATAMIPSELSYSROOT}/shadow_cross_install
[ -f ${METADATAMIPSELSYSROOT}/shadow_cross_cp ] || \
  cp ${PREFIXMIPSELSYSROOT}/etc/login.defs login.defs.orig || \
    die "***copy shadow error" && \
      touch ${METADATAMIPSELSYSROOT}/shadow_cross_cp
[ -f ${METADATAMIPSELSYSROOT}/shadow_cross_sed ] || \
  sed -e's@#MD5_CRYPT_ENAB.no@MD5_CRYPT_ENAB yes@' \
  -e 's@/var/spool/mail@/var/mail@' \
  login.defs.orig > ${PREFIXMIPSELSYSROOT}/etc/login.defs || \
    die "***sed shadow error" && \
      touch ${METADATAMIPSELSYSROOT}/shadow_cross_sed
[ -f ${METADATAMIPSELSYSROOT}/shadow_cross_mv ] || \
  mv -v ${PREFIXMIPSELSYSROOT}/usr/bin/passwd ${PREFIXMIPSELSYSROOT}/bin || \
    die "***move shadow error" && \
      touch ${METADATAMIPSELSYSROOT}/shadow_cross_mv
popd

# Use make, not make -j${JOBS}
pushd ${BUILDMIPSELSYSROOT}
[ -d libestr_build ] || mkdir libestr_build
cd libestr_build
cat > config.cache << EOF
ac_cv_func_malloc_0_nonnull=yes
ac_cv_func_realloc_0_nonnull=yes
EOF
[ -f ${METADATAMIPSELSYSROOT}/libestr_configure ] || \
  ${SRCMIPSELSYSROOT}/libestr-${LIBESTR_VERSION}/configure \
  --build=${CROSS_HOST} \
  --host=${CROSS_TARGET32} --prefix=/usr --sbindir=/sbin \
  --cache-file=config.cache || \
    die "***config libestr error" && \
      touch ${METADATAMIPSELSYSROOT}/libestr_configure
[ -f ${METADATAMIPSELSYSROOT}/libestr_build ] || \
  make || \
    die "***build libestr error" && \
      touch ${METADATAMIPSELSYSROOT}/libestr_build
[ -f ${METADATAMIPSELSYSROOT}/libestr_install ] || \
  make DESTDIR=${PREFIXMIPSELSYSROOT} install || \
    die "***install libestr error" && \
      touch ${METADATAMIPSELSYSROOT}/libestr_install
[ -f ${METADATAMIPSELSYSROOT}/libestr_rmla ] || \
  rm ${PREFIXMIPSELSYSROOT}/usr/lib/libestr.la || \
    die "***rm libestr.la error" && \
      touch ${METADATAMIPSELSYSROOT}/libestr_rmla
popd

# Use make, not make -j${JOBS}
pushd ${BUILDMIPSELSYSROOT}
[ -d libee_build ] || mkdir libee_build
cd libee_build
cat > config.cache << EOF
ac_cv_func_malloc_0_nonnull=yes
ac_cv_func_realloc_0_nonnull=yes
EOF
[ -f ${METADATAMIPSELSYSROOT}/libee_configure ] || \
  PKG_CONFIG_LIBDIR=${PREFIXMIPSELSYSROOT}/usr/lib \
  PKG_CONFIG_PATH=${PREFIXMIPSELSYSROOT}/usr/lib/pkgconfig \
  ${SRCMIPSELSYSROOT}/libee-${LIBEE_VERSION}/configure \
  --build=${CROSS_HOST} \
  --host=${CROSS_TARGET32} --prefix=/usr --sbindir=/sbin \
  --cache-file=config.cache || \
    die "***config libee error" && \
      touch ${METADATAMIPSELSYSROOT}/libee_configure
[ -f ${METADATAMIPSELSYSROOT}/libee_build ] || \
  make || \
    die "***build libee error" && \
      touch ${METADATAMIPSELSYSROOT}/libee_build
[ -f ${METADATAMIPSELSYSROOT}/libee_install ] || \
  make DESTDIR=${PREFIXMIPSELSYSROOT} install || \
    die "***install libee error" && \
      touch ${METADATAMIPSELSYSROOT}/libee_install
[ -f ${METADATAMIPSELSYSROOT}/libee_rmla ] || \
  rm ${PREFIXMIPSELSYSROOT}/usr/lib/libee.la || \
    die "***rm libee.la error" && \
      touch ${METADATAMIPSELSYSROOT}/libee_rmla
popd

pushd ${BUILDMIPSELSYSROOT}
[ -d rsyslog_build ] || mkdir rsyslog_build
cd rsyslog_build
cat > config.cache << EOF
ac_cv_func_malloc_0_nonnull=yes
ac_cv_func_realloc_0_nonnull=yes
EOF
[ -f ${METADATAMIPSELSYSROOT}/rsyslog_configure ] || \
  PKG_CONFIG_LIBDIR=${PREFIXMIPSELSYSROOT}/usr/lib \
  PKG_CONFIG_PATH=${PREFIXMIPSELSYSROOT}/usr/lib/pkgconfig \
  LDFLAGS="-L${PREFIXMIPSELSYSROOT}/usr/lib -lestr" \
  ${SRCMIPSELSYSROOT}/rsyslog-${RSYSLOG_VERSION}/configure \
  --build=${CROSS_HOST} \
  --host=${CROSS_TARGET32} \
  --prefix=/usr --sbindir=/sbin --libdir=/usr/lib \
  --cache-file=config.cache || \
    die "***config rsyslog error" && \
      touch ${METADATAMIPSELSYSROOT}/rsyslog_configure
[ -f ${METADATAMIPSELSYSROOT}/rsyslog_build ] || \
  make -j${JOBS}|| \
    die "***build rsyslog error" && \
      touch ${METADATAMIPSELSYSROOT}/rsyslog_build
[ -f ${METADATAMIPSELSYSROOT}/rsyslog_install ] || \
  make DESTDIR=${PREFIXMIPSELSYSROOT} install || \
    die "***install rsyslog error" && \
      touch ${METADATAMIPSELSYSROOT}/rsyslog_install
[ -f ${METADATAMIPSELSYSROOT}/rsyslog_install_d ] || \
  install -dv ${PREFIXMIPSELSYSROOT}/etc/rsyslog.d || \
    die "***install rsyslog rsyslog.d error" && \
      touch ${METADATAMIPSELSYSROOT}/rsyslog_install_d
popd

[ -f ${METADATAMIPSELSYSROOT}/rsyslog_cat ] || \
`cat > ${PREFIXMIPSELSYSROOT}/etc/rsyslog.conf << "EOF"
# Begin /etc/rsyslog.conf

# PREFIXMIPSELSYSROOT configuration of rsyslog. For more info use man rsyslog.conf

#######################################################################
# Rsyslog Modules

# Support for Local System Logging
$ModLoad imuxsock.so

# Support for Kernel Logging
$ModLoad imklog.so

#######################################################################
# Global Options

# Use traditional timestamp format.
$ActionFileDefaultTemplate RSYSLOG_TraditionalFileFormat

# Set the default permissions for all log files.
$FileOwner root
$FileGroup root
$FileCreateMode 0640
$DirCreateMode 0755

# Provides UDP reception
$ModLoad imudp
$UDPServerRun 514

# Disable Repating of Entries
$RepeatedMsgReduction on

#######################################################################
# Include Rsyslog Config Snippets

$IncludeConfig /etc/rsyslog.d/*.conf

#######################################################################
# Standard Log Files

auth,authpriv.*                        /var/log/auth.log
*.*;auth,authpriv.none                -/var/log/syslog
daemon.*                        -/var/log/daemon.log
kern.*                                -/var/log/kern.log
lpr.*                                -/var/log/lpr.log
mail.*                                -/var/log/mail.log
user.*                                -/var/log/user.log

# Catch All Logs
*.=debug;\
        auth,authpriv.none;\
        news.none;mail.none        -/var/log/debug
        *.=info;*.=notice;*.=warn;\
        auth,authpriv.none;\
        cron,daemon.none;\
        mail,news.none                -/var/log/messages

# Emergency are shown to everyone
*.emerg                                *

# End /etc/rsyslog.conf
EOF` || \
  die "***cat rsyslog rsyslog.d error" && \
    touch ${METADATAMIPSELSYSROOT}/rsyslog_cat

pushd ${SRCMIPSELSYSROOT}
cd sysvinit-${SYSVINIT_VERSION}
[ -f ${METADATAMIPSELSYSROOT}/sysvinit_cpsed ] || \
  cp -v src/Makefile src/Makefile.orig && \
  sed -e 's@/dev/initctl@$(ROOT)&@g' \
      -e 's@\(mknod \)-m \([0-9]* \)\(.* \)p@\1\3p; chmod \2\3@g' \
      -e '/^ifeq/s/$(ROOT)//' \
      -e 's@/usr/lib@$(ROOT)&@' \
      src/Makefile.orig > src/Makefile || \
        die "***copy sed sysvinit error" && \
         touch ${METADATAMIPSELSYSROOT}/sysvinit_cpsed
[ -f ${METADATAMIPSELSYSROOT}/cat_inittab_1 ] || \
`cat > ${PREFIXMIPSELSYSROOT}/etc/inittab << "EOF"
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

EOF` || \
    die "***cat inittab first error" && \
      touch ${METADATAMIPSELSYSROOT}/cat_inittab_1
[ -f ${METADATAMIPSELSYSROOT}/sysvinit_build_clobber ] || \
  make -C src clobber  || \
    die "***build sysvinit clobber error" && \
      touch ${METADATAMIPSELSYSROOT}/sysvinit_build_clobber
[ -f ${METADATAMIPSELSYSROOT}/sysvinit_build ] || \
  make -C src ROOT=${PREFIXMIPSELSYSROOT} CC="${CC}" || \
    die "***build sysvinit error" && \
      touch ${METADATAMIPSELSYSROOT}/sysvinit_build
[ -f ${METADATAMIPSELSYSROOT}/sysvinit_install ] || \
  make -C src ROOT=${PREFIXMIPSELSYSROOT} INSTALL="install" install || \
    die "***install sysvinit error" && \
      touch ${METADATAMIPSELSYSROOT}/sysvinit_install
popd

[ -f ${METADATAMIPSELSYSROOT}/cat_inittab_2 ] || \
`cat >> ${PREFIXMIPSELSYSROOT}/etc/inittab << "EOF"
1:2345:respawn:/sbin/agetty -I '\033(K' tty1 9600
2:2345:respawn:/sbin/agetty -I '\033(K' tty2 9600
3:2345:respawn:/sbin/agetty -I '\033(K' tty3 9600
4:2345:respawn:/sbin/agetty -I '\033(K' tty4 9600
5:2345:respawn:/sbin/agetty -I '\033(K' tty5 9600
6:2345:respawn:/sbin/agetty -I '\033(K' tty6 9600

EOF` || \
  die "***cat inittab second error" && \
    touch ${METADATAMIPSELSYSROOT}/cat_inittab_2

[ -f ${METADATAMIPSELSYSROOT}/cat_inittab_3 ] || \
`cat >> ${PREFIXMIPSELSYSROOT}/etc/inittab << "EOF"
c0:12345:respawn:/sbin/agetty 115200 ttyS0 vt100
EOF` || \
  die "***cat inittab third error" && \
    touch ${METADATAMIPSELSYSROOT}/cat_inittab_3

[ -f ${METADATAMIPSELSYSROOT}/cat_inittab_4 ] || \
`cat >> ${PREFIXMIPSELSYSROOT}/etc/inittab << "EOF"
# End /etc/inittab
EOF` || \
  die "***cat inittab forth error" && \
    touch ${METADATAMIPSELSYSROOT}/cat_inittab_4

pushd ${BUILDMIPSELSYSROOT}
[ -d "tar-build" ] || mkdir tar-build
cd tar-build
cat > config.cache << EOF
gl_cv_func_wcwidth_works=yes
gl_cv_func_btowc_eof=yes
ac_cv_func_malloc_0_nonnull=yes
ac_cv_func_realloc_0_nonnull=yes
gl_cv_func_mbrtowc_incomplete_state=yes
gl_cv_func_mbrtowc_nul_retval=yes
gl_cv_func_mbrtowc_null_arg=yes
gl_cv_func_mbrtowc_retval=yes
gl_cv_func_wcrtomb_retval=yes
EOF
[ -f ${METADATAMIPSELSYSROOT}/tar_configure ] || \
  ${SRCMIPSELSYSROOT}/tar-${TAR_VERSION}/configure \
  --build=${CROSS_HOST} --host=${CROSS_TARGET32} \
  --prefix=/usr --bindir=/bin --libexecdir=/usr/sbin \
  --cache-file=config.cache || \
    die "***config tar error" && \
      touch ${METADATAMIPSELSYSROOT}/tar_configure
[ -f ${METADATAMIPSELSYSROOT}/tar_build ] || \
  make -j${JOBS} || \
    die "***build tar error" && \
      touch ${METADATAMIPSELSYSROOT}/tar_build
[ -f ${METADATAMIPSELSYSROOT}/tar_install ] || \
  make DESTDIR=${PREFIXMIPSELSYSROOT} install || \
    die "***install tar error" && \
      touch ${METADATAMIPSELSYSROOT}/tar_install
popd

pushd ${BUILDMIPSELSYSROOT}
[ -d "texinfo_build" ] || mkdir texinfo_build
cd texinfo_build
[ -f ${METADATAMIPSELSYSROOT}/texinfo_configure ] || \
  ${SRCMIPSELSYSROOT}/texinfo-${TEXINFO_VERSION}/configure \
  --build=${CROSS_HOST} --host=${CROSS_TARGET32} \
  --prefix=/usr || \
    die "***config texinfo error" && \
      touch ${METADATAMIPSELSYSROOT}/texinfo_configure
[ -f ${METADATAMIPSELSYSROOT}/texinfo_build_lib ] || \
  make -C tools/gnulib/lib || \
    die "***build texinfo lib error" && \
      touch ${METADATAMIPSELSYSROOT}/texinfo_build_lib
[ -f ${METADATAMIPSELSYSROOT}/texinfo_build_tools ] || \
  make -C tools || \
    die "***build texinfo tools error" && \
      touch ${METADATAMIPSELSYSROOT}/texinfo_build_tools
[ -f ${METADATAMIPSELSYSROOT}/texinfo_build ] || \
  make -j${JOBS} || \
    die "***build texinfo error" && \
      touch ${METADATAMIPSELSYSROOT}/texinfo_build
[ -f ${METADATAMIPSELSYSROOT}/texinfo_install ] || \
  make DESTDIR=${PREFIXMIPSELSYSROOT} install || \
    die "***install texinfo error" && \
      touch ${METADATAMIPSELSYSROOT}/texinfo_install
cd ${PREFIXMIPSELSYSROOT}/usr/share/info
[ -f ${METADATAMIPSELSYSROOT}/texinfo_rmdir ] || \
  rm dir || \
    die "***remove dir texinfo error" && \
      touch ${METADATAMIPSELSYSROOT}/texinfo_rmdir
for f in *
do install-info ${f} dir 2>/dev/null
done
popd

pushd ${BUILDMIPSELSYSROOT}
[ -d "kmod_build" ] || mkdir kmod_build
cd kmod_build
[ -f ${METADATAMIPSELSYSROOT}/kmod_configure ] || \
  ${SRCMIPSELSYSROOT}/kmod-${KMOD_VERSION}/configure \
  --build=${CROSS_HOST} \
  --host=${CROSS_TARGET32} --target=${CROSS_TARGET32} \
  --prefix=/usr --bindir=/bin || \
    die "config kmod error" && \
      touch ${METADATAMIPSELSYSROOT}/kmod_configure
[ -f ${METADATAMIPSELSYSROOT}/kmod_build ] || \
  make -j${JOBS} || \
    die "build kmod error" && \
      touch ${METADATAMIPSELSYSROOT}/kmod_build
[ -f ${METADATAMIPSELSYSROOT}/kmod_install ] || \
  make DESTDIR=${PREFIXMIPSELSYSROOT} install || \
    die "install kmod error" && \
      touch ${METADATAMIPSELSYSROOT}/kmod_install
popd

pushd ${PREFIXMIPSELSYSROOT}/usr/share/misc
[ -f ${METADATAMIPSELSYSROOT}/patch_pci ] || \
  patch -p1 < ${PATCH}/pci-ids-2.0.patch || \
    die "***pci ids error"
      touch ${METADATAMIPSELSYSROOT}/patch_pci
popd

[ -f ${METADATAMIPSELSYSROOT}/libuuid_rmla ] || \
  rm ${PREFIXMIPSELSYSROOT}/usr/lib/libuuid.la || \
    die "***rm libuuid.la error" && \
      touch ${METADATAMIPSELSYSROOT}/libuuid_rmla

[ -f ${METADATAMIPSELSYSROOT}/libblkid_rmla ] || \
  rm ${PREFIXMIPSELSYSROOT}/usr/lib/libblkid.la || \
    die "***rm libblkid.la error" && \
      touch ${METADATAMIPSELSYSROOT}/libblkid_rmla

## FIXME Now we use --disable-gudev, so the glib is disabled
pushd ${BUILDMIPSELSYSROOT}
[ -d "udev_build" ] || mkdir udev_build
cd udev_build
[ -f ${METADATAMIPSELSYSROOT}/udev_configure ] || \
  PKG_CONFIG=true \
  LDFLAGS="-lblkid -luuid -lkmod" \
  CC=${CC} \
  ${SRCMIPSELSYSROOT}/udev-${UDEV_VERSION}/configure \
  --build=${CROSS_HOST} --host=${CROSS_TARGET32} \
  --exec-prefix="" --sysconfdir=/etc \
  --libexecdir=/lib --libdir=/usr/lib --disable-gudev \
  --disable-extras \
  --with-pci-ids-path=${PREFIXMIPSELSYSROOT}/usr/share/misc || \
    die "***config udev error" && \
      touch ${METADATAMIPSELSYSROOT}/udev_configure
[ -f ${METADATAMIPSELSYSROOT}/udev_build ] || \
  make -j${JOBS} || \
    die "***build udev error" && \
      touch ${METADATAMIPSELSYSROOT}/udev_build
[ -f ${METADATAMIPSELSYSROOT}/udev_install ] || \
  make DESTDIR=${PREFIXMIPSELSYSROOT} install || \
    die "***install udev error" && \
      touch ${METADATAMIPSELSYSROOT}/udev_install
popd

pushd ${BUILDMIPSELSYSROOT}
cd ${VIM_DIR}
[ -f ${METADATAMIPSELSYSROOT}/vim_patch ] || \
  patch -Np1 -i ${PATCH}/vim-7.3-branch_update-4.patch || \
    die "*** patch vim error" && \
      touch ${METADATAMIPSELSYSROOT}/vim_patch
cat >> src/feature.h << "EOF"
#define SYS_VIMRC_FILE "/etc/vimrc"
EOF
cat > src/auto/config.cache << "EOF"
vim_cv_getcwd_broken=no
vim_cv_memmove_handles_overlap=yes
vim_cv_stat_ignores_slash=no
vim_cv_terminfo=yes
vim_cv_tgent=zero
vim_cv_toupper_broken=no
vim_cv_tty_group=world
ac_cv_sizeof_int=4
EOF
[ -f ${METADATAMIPSELSYSROOT}/vim_configure ] || \
  CPPFLAGS="-DUNUSED=" ./configure --build=${CROSS_HOST} \
  --host=${CROSS_TARGET32} \
  --prefix=/usr --enable-multibyte --enable-gui=no \
  --disable-gtktest --disable-xim --with-features=normal \
  --disable-gpm --without-x --disable-netbeans \
  --with-tlib=ncurses || \
    die "***config vim error" && \
      touch ${METADATAMIPSELSYSROOT}/vim_configure
[ -f ${METADATAMIPSELSYSROOT}/vim_build ] || \
  make -j${JOBS} || \
    die "***build vim error" && \
      touch ${METADATAMIPSELSYSROOT}/vim_build
[ -f ${METADATAMIPSELSYSROOT}/vim_install ] || \
  make DESTDIR=${PREFIXMIPSELSYSROOT}  install || \
    die "***install vim error" && \
      touch ${METADATAMIPSELSYSROOT}/vim_install
ln -sfv vim ${PREFIXMIPSELSYSROOT}/usr/bin/vi
ln -sfnv ../vim/vim72/doc ${PREFIXMIPSELSYSROOT}/usr/share/doc/vim-7.2
popd

pushd ${BUILDMIPSELSYSROOT}
[ -d "xz_build" ] || mkdir xz_build
cd xz_build
[ -f ${METADATAMIPSELSYSROOT}/xz_configure ] || \
  ${SRCMIPSELSYSROOT}/xz-${XZ_VERSION}/configure \
  --build=${CROSS_HOST} \
  --host=${CROSS_TARGET32} \
  --prefix=/usr || \
    die "***config xz error" && \
      touch ${METADATAMIPSELSYSROOT}/xz_configure
[ -f ${METADATAMIPSELSYSROOT}/xz_build ] || \
  make -j${JOBS} || \
    die "***build xz error" && \
      touch ${METADATAMIPSELSYSROOT}/xz_build
[ -f ${METADATAMIPSELSYSROOT}/xz_install ] || \
  make DESTDIR=${PREFIXMIPSELSYSROOT} install || \
    die "***install xz error" && \
      touch ${METADATAMIPSELSYSROOT}/xz_install
[ -f ${METADATAMIPSELSYSROOT}/xz_mv ] || \
  mv -v ${PREFIXMIPSELSYSROOT}/usr/bin/{xz,lzma,lzcat,unlzma,unxz,xzcat} ${PREFIXMIPSELSYSROOT}/bin || \
    die "***move xz error" && \
      touch ${METADATAMIPSELSYSROOT}/xz_mv
popd

pushd ${BUILDMIPSELSYSROOT}
cd dhcpcd-${DHCPCD_VERSION}
[ -f ${METADATAMIPSELSYSROOT}/dhcpcd_configure ] || \
  ./configure \
  --target=${CROSS_TARGET32} --host=${CROSS_HOST} || \
    die "***config dhcpcd error" && \
      touch ${METADATAMIPSELSYSROOT}/dhcpcd_configure
[ -f ${METADATAMIPSELSYSROOT}/dhcpcd_build ] || \
  make PREFIX=/usr BINDIR=/sbin SYSCONFDIR=/etc \
  DBDIR=/var/lib/dhcpcd LIBEXECDIR=/usr/lib/dhcpcd || \
    die "***build dhcpcd error" && \
      touch ${METADATAMIPSELSYSROOT}/dhcpcd_build
[ -f ${METADATAMIPSELSYSROOT}/dhcpcd_install ] || \
  make PREFIX=/usr BINDIR=/sbin SYSCONFDIR=/etc \
  DBDIR=/var/lib/dhcpcd LIBEXECDIR=/usr/lib/dhcpcd \
  DESTDIR=${PREFIXMIPSELSYSROOT} install || \
    die "***install dhcpcd error" && \
      touch ${METADATAMIPSELSYSROOT}/dhcpcd_install
popd

pushd ${BUILDMIPSELSYSROOT}
cd bootscripts-cross-lfs-${BOOTSCRIPTS_VERSION}
[ -f ${METADATAMIPSELSYSROOT}/bootscript_build ] || \
   make DESTDIR=${PREFIXMIPSELSYSROOT} install-bootscripts || \
    die "***install bootscripts error" && \
      touch ${METADATAMIPSELSYSROOT}/bootscript_build
[ -f ${METADATAMIPSELSYSROOT}/bootscript_install ] || \
  make DESTDIR=${PREFIXMIPSELSYSROOT} install-network || \
    die "***install network error" && \
      touch ${METADATAMIPSELSYSROOT}/bootscript_install
popd

#########################################################################
#
# Now we add config file to the file system.
#
#########################################################################

[ -f ${METADATAMIPSELSYSROOT}/create_clock ] || \
`cat > ${PREFIXMIPSELSYSROOT}/etc/sysconfig/clock << "EOF"
# Begin /etc/sysconfig/clock

UTC=1

# End /etc/sysconfig/clock
EOF` || \
  die "Create clock error" && \
      touch ${METADATAMIPSELSYSROOT}/create_clock


[ -f ${METADATAMIPSELSYSROOT}/create_inputrc ] || \
`cat > ${PREFIXMIPSELSYSROOT}/etc/inputrc << "EOF"
# Begin /etc/inputrc
# Modified by Chris Lynn <roryo@roryo.dynup.net>

# Allow the command prompt to wrap to the next line
set horizontal-scroll-mode Off

# Enable 8bit input
set meta-flag On
set input-meta On

# Turns off 8th bit stripping
set convert-meta Off

# Keep the 8th bit for display
set output-meta On

# none, visible or audible
set bell-style none

# All of the following map the escape sequence of the
# value contained inside the 1st argument to the
# readline specific functions

"\eOd": backward-word
"\eOc": forward-word

# for linux console
"\e[1~": beginning-of-line
"\e[4~": end-of-line
"\e[5~": beginning-of-history
"\e[6~": end-of-history
"\e[3~": delete-char
"\e[2~": quoted-insert

# for xterm
"\eOH": beginning-of-line
"\eOF": end-of-line

# for Konsole
"\e[H": beginning-of-line
"\e[F": end-of-line

# End /etc/inputrc
EOF` || die "Create inputrc error" && \
  touch ${METADATAMIPSELSYSROOT}/create_inputrc

[ -f ${METADATAMIPSELSYSROOT}/create_network ] || \
`cat > ${PREFIXMIPSELSYSROOT}/etc/sysconfig/network << EOF
HOSTNAME=mipsel-gnu-linux
EOF` || die "create network error" && \
  touch ${METADATAMIPSELSYSROOT}/create_network

[ -f ${METADATAMIPSELSYSROOT}/create_host ] || \
`cat > ${PREFIXMIPSELSYSROOT}/etc/hosts << "EOF"
# Begin /etc/hosts (network card version)

127.0.0.1 localhost

# End /etc/hosts (network card version)
EOF` || die "crete host error" && \
  touch ${METADATAMIPSELSYSROOT}/create_host

[ -f ${METADATAMIPSELSYSROOT}/create_host ] || \
`cat > ${PREFIXMIPSELSYSROOT}/etc/resolv.conf << "EOF"
# Generated by NetworkManager
nameserver 127.0.1.1
EOF` || die "crete resolv.conf error" && \
  touch ${METADATAMIPSELSYSROOT}/create_host

[ -d ${PREFIXMIPSELSYSROOT}/etc/sysconfig/network-devices ] || \
  mkdir -pv ${PREFIXMIPSELSYSROOT}/etc/sysconfig/network-devices
pushd ${PREFIXMIPSELSYSROOT}/etc/sysconfig/network-devices &&
[ -f ${METADATAMIPSELSYSROOT}/mkdir_ifconfig ] || \
[ -d ifconfig.eth0 ] || mkdir -v ifconfig.eth0 || \
  die "***create static ip address error" && \
    touch ${METADATAMIPSELSYSROOT}/mkdir_ifconfig
[ -f ${METADATAMIPSELSYSROOT}/create_static_ip ] || \
`cat > ifconfig.eth0/ipv4 << "EOF"
ONBOOT=yes
SERVICE=ipv4-static
IP=192.168.1.1
GATEWAY=192.168.1.2
PREFIX=24
BROADCAST=192.168.1.255
EOF` || \
  die "***create static ip address error" && \
    touch ${METADATAMIPSELSYSROOT}/create_static_ip
popd

echo 2

[ -f ${METADATAMIPSELSYSROOT}/create_fstab ] || \
`cat > ${PREFIXMIPSELSYSROOT}/etc/fstab << "EOF"
# Begin /etc/fstab

# file system  mount-point  type   options          dump  fsck
#                                                         order

/dev/hda       /            ext3   defaults         1     1
#/dev/[yyy]     swap         swap   pri=1           0     0
proc           /proc        proc   defaults         0     0
sysfs          /sys         sysfs  defaults         0     0
devpts         /dev/pts     devpts gid=4,mode=620   0     0
shm            /dev/shm     tmpfs  defaults         0     0
tmpfs          /run         tmpfs  defaults         0     0
# End /etc/fstab
EOF` || \
  die "create fstab error" && \
    touch ${METADATAMIPSELSYSROOT}/create_fstab

[ -f ${METADATAMIPSELSYSROOT}/create_vernu ] || \
`cat > ${PREFIXMIPSELSYSROOT}/etc/clfs-release << EOF
PREFIXMIPSELSYSROOT-Sysroot
EOF` || \
  die "***create version number error" && \
    touch ${METADATAMIPSELSYSROOT}/create_vernu
############### Change Own Ship ########################
[ -f ${METADATAMIPSELSYSROOT}/change_own ] || \
  sudo chown -Rv 0:0 ${PREFIXMIPSELSYSROOT} || \
    die "***Change own error" && \
      touch ${METADATAMIPSELSYSROOT}/change_own

[ -f ${METADATAMIPSELSYSROOT}/touch_file ] || \
  sudo touch ${PREFIXMIPSELSYSROOT}/var/run/utmp ${PREFIXMIPSELSYSROOT}/var/log/{btmp,lastlog,wtmp} || \
    die "***touch file error" && \
      touch ${METADATAMIPSELSYSROOT}/touch_file

[ -f ${METADATAMIPSELSYSROOT}/change_utmp ] || \
  sudo chmod -v 664 ${PREFIXMIPSELSYSROOT}/var/run/utmp ${PREFIXMIPSELSYSROOT}/var/log/lastlog || \
    die "***Change utmp/lastlog group error" && \
      touch ${METADATAMIPSELSYSROOT}/change_utmp

[ -f ${METADATAMIPSELSYSROOT}/write_group ] || \
  sudo chgrp -v 4 ${PREFIXMIPSELSYSROOT}/usr/bin/write || \
    die "***Change write group error" && \
      touch ${METADATAMIPSELSYSROOT}/write_group

[ -f ${METADATAMIPSELSYSROOT}/write_mode ] || \
  sudo chmod g+s ${PREFIXMIPSELSYSROOT}/usr/bin/write || \
    die "Change write mode error" && \
      touch ${METADATAMIPSELSYSROOT}/write_mode

[ -f ${METADATAMIPSELSYSROOT}/create_null ] || \
  sudo mknod -m 0666 ${PREFIXMIPSELSYSROOT}/dev/null c 1 3 || \
    die "***Create null error" && \
      touch ${METADATAMIPSELSYSROOT}/create_null

[ -f ${METADATAMIPSELSYSROOT}/create_console ] || \
  sudo mknod -m 0600 ${PREFIXMIPSELSYSROOT}/dev/console c 5 1 || \
    die "***Create console error" && \
      touch ${METADATAMIPSELSYSROOT}/create_console

[ -f ${METADATAMIPSELSYSROOT}/create_rtc0 ] || \
  sudo mknod -m 0666 ${PREFIXMIPSELSYSROOT}/dev/rtc0 c 254 0 || \
    die "***Create rtc0 error" && \
      touch ${METADATAMIPSELSYSROOT}/create_rtc0

[ -f ${METADATAMIPSELSYSROOT}/link_rtc ] || \
  sudo ln -sv ${PREFIXMIPSELSYSROOT}/dev/rtc0 ${PREFIXMIPSELSYSROOT}/dev/rtc || \
    die "***Link rtc error" && \
      touch ${METADATAMIPSELSYSROOT}/link_rtc

pushd ${PREFIXMIPSELSYSROOT}
[ -f ${METADATAMIPSELSYSROOT}/cross_tools_rm ] || \
  sudo rm -rf ${PREFIXMIPSELSYSROOT}/cross-tools || \
    die "***remove cross tools error" && \
      touch ${METADATAMIPSELSYSROOT}/cross_tools_rm
popd

pushd ${PREFIXGNULINUX}
[ -f ${METADATAMIPSELSYSROOT}/mipsel_sysroot_ddimg ] || \
 dd if=/dev/zero of=mipsel-sysroot.img bs=1M count=10000 || \
    die "***dd mipsel sysroot.img error" && \
      touch ${METADATAMIPSELSYSROOT}/mipsel_sysroot_ddimg

[ -f ${METADATAMIPSELSYSROOT}/mipsel_sysroot_mkfsimg ] || \
  echo y | mkfs.ext3 mipsel-sysroot.img || \
    die "***mkfs mipsel sysroot.img error" && \
      touch ${METADATAMIPSELSYSROOT}/mipsel_sysroot_mkfsimg

[ -f ${METADATAMIPSELSYSROOT}/mipsel_sysroot_dirmnt ] || \
  mkdir mnt_tmp || \
    die "***mkdir mnt error" && \
      touch ${METADATAMIPSELSYSROOT}/mipsel_sysroot_dirmnt

[ -f ${METADATAMIPSELSYSROOT}/mipsel_sysroot_mnt ] || \
  sudo mount -o loop mipsel-sysroot.img ./mnt_tmp || \
    die "***mount mipsel sysroot.img error" && \
      touch ${METADATAMIPSELSYSROOT}/mipsel_sysroot_mnt

[ -f ${METADATAMIPSELSYSROOT}/mipsel_sysroot_copy ] || \
  sudo cp -ar ${PREFIXMIPSELSYSROOT}/* ./mnt_tmp/ || \
    die "***copy to mipsel sysroot.img error" && \
      touch ${METADATAMIPSELSYSROOT}/mipsel_sysroot_copy

[ -f ${METADATAMIPSELSYSROOT}/mipsel_sysroot_umnt ] || \
  sudo umount ./mnt_tmp/ || \
    die "***copy to mipsel sysroot.img error" && \
      touch ${METADATAMIPSELSYSROOT}/mipsel_sysroot_umnt

[ -f ${METADATAMIPSELSYSROOT}/mipsel_sysroot_rmmnt ] || \
  rm -rf  mnt_tmp || \
    die "***remove mnt error" && \
      touch ${METADATAMIPSELSYSROOT}/mipsel_sysroot_rmmnt

popd
