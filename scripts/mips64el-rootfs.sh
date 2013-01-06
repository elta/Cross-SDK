#! /bin/bash

source source.sh

export PATH=$PATH:${PREFIXMIPS64ELROOTFS}/cross-tools/bin

[ -d "${SRCMIPS64ELROOTFS}" ] || mkdir -p "${SRCMIPS64ELROOTFS}"
[ -d "${BUILDMIPS64ELROOTFS}" ] || mkdir -p "${BUILDMIPS64ELROOTFS}"
[ -d "${METADATAMIPS64ELROOTFS}" ] || mkdir -p "${METADATAMIPS64ELROOTFS}"
[ -d "${PREFIXGNULINUX}" ] || mkdir -p "${PREFIXGNULINUX}"

mkdir -p ${PREFIXMIPS64ELROOTFS}
mkdir -p ${PREFIXMIPS64ELROOTFS}/cross-tools

#################### Creating Directories ###############
mkdir -pv ${PREFIXMIPS64ELROOTFS}/{bin,boot,dev,{etc/,}opt,home,lib,mnt,run}
mkdir -pv ${PREFIXMIPS64ELROOTFS}/{proc,media/{floppy,cdrom},sbin,srv,sys}
mkdir -pv ${PREFIXMIPS64ELROOTFS}/var/{lock,log,mail,run,spool}
mkdir -pv ${PREFIXMIPS64ELROOTFS}/var/{opt,cache,lib/{misc,locate,hwclock},local}
install -dv -m 0750 ${PREFIXMIPS64ELROOTFS}/root
install -dv -m 1777 ${PREFIXMIPS64ELROOTFS}{/var,}/tmp
mkdir -pv ${PREFIXMIPS64ELROOTFS}/usr/{,local/}{bin,include,lib,sbin,src}
mkdir -pv ${PREFIXMIPS64ELROOTFS}/usr/{,local/}share/{doc,info,locale,man}
mkdir -pv ${PREFIXMIPS64ELROOTFS}/usr/{,local/}share/{misc,terminfo,zoneinfo}
mkdir -pv ${PREFIXMIPS64ELROOTFS}/usr/{,local/}share/man/man{1,2,3,4,5,6,7,8}
for dir in ${PREFIXMIPS64ELROOTFS}/usr{,/local}; do
  ln -sfnv share/{man,doc,info} ${dir};
done
touch ${PREFIXMIPS64ELROOTFS}/{,var/}run/utmp ${PREFIXMIPS64ELROOTFS}/var/log/{btmp,lastlog,wtmp}
mkdir -pv ${PREFIXMIPS64ELROOTFS}/etc/sysconfig

[ -f "${METADATAMIPS64ELROOTFS}/create_passwd" ] || \
  `cat > ${PREFIXMIPS64ELROOTFS}/etc/passwd << "EOF"
root::0:0:root:/root:/bin/bash
EOF` || \
    die "create passwd error" && \
      touch ${METADATAMIPS64ELROOTFS}/create_passwd

[ -f "${METADATAMIPS64ELROOTFS}/create_group" ] || \
  `cat > ${PREFIXMIPS64ELROOTFS}/etc/group << "EOF"
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
EOF` || \
    die "create group error" && \
      touch ${METADATAMIPS64ELROOTFS}/create_group

################## End Creating Directories ###############

############################### Extract tarballs ##############################
pushd ${SRCMIPS64ELROOTFS}
[ -f "${METADATAMIPS64ELROOTFS}/linux_extract" ] || \
  tar xf ${TARBALL}/linux-${LINUX_VERSION}.${LINUX_SUFFIX} || \
    die "extract linux error" && \
      touch ${METADATAMIPS64ELROOTFS}/linux_extract
[ -f "${METADATAMIPS64ELROOTFS}/gmp_extract" ] || \
  tar xf ${TARBALL}/gmp-${GMP_VERSION}.${GMP_SUFFIX} || \
    die "extract gmp error" && \
      touch ${METADATAMIPS64ELROOTFS}/gmp_extract
[ -f "${METADATAMIPS64ELROOTFS}/mpfr_extract" ] || \
  tar xf ${TARBALL}/mpfr-${MPFR_VERSION}.${MPFR_SUFFIX} || \
    die "extract mpfr error" && \
      touch ${METADATAMIPS64ELROOTFS}/mpfr_extract
[ -f "${METADATAMIPS64ELROOTFS}/mpc_extract" ] || \
  tar xf ${TARBALL}/mpc-${MPC_VERSION}.${MPC_SUFFIX} || \
    die "extract mpc error" && \
      touch ${METADATAMIPS64ELROOTFS}/mpc_extract
[ -f "${METADATAMIPS64ELROOTFS}/ppl_extract" ] || \
  tar xf ${TARBALL}/ppl-${PPL_VERSION}.${PPL_SUFFIX} || \
    die "extract ppl error" && \
      touch ${METADATAMIPS64ELROOTFS}/ppl_extract
[ -f "${METADATAMIPS64ELROOTFS}/cloog_extract" ] || \
  tar xf ${TARBALL}/cloog-${CLOOG_VERSION}.${CLOOG_SUFFIX} || \
    die "extract cloog error" && \
      touch ${METADATAMIPS64ELROOTFS}/cloog_extract
[ -f "${METADATAMIPS64ELROOTFS}/libestr_extract" ] || \
  tar xf ${TARBALL}/libestr-${LIBESTR_VERSION}.${LIBESTR_SUFFIX} || \
    die "extract libestr error" && \
      touch ${METADATAMIPS64ELROOTFS}/libestr_extract
[ -f "${METADATAMIPS64ELROOTFS}/libee_extract" ] || \
  tar xf ${TARBALL}/libee-${LIBEE_VERSION}.${LIBEE_SUFFIX} || \
    die "extract libee error" && \
      touch ${METADATAMIPS64ELROOTFS}/libee_extract
[ -f "${METADATAMIPS64ELROOTFS}/util-linux_extract" ] || \
  tar xf ${TARBALL}/util-${UTIL_VERSION}.${UTIL_SUFFIX} || \
    die "extract util-linux error" && \
      touch ${METADATAMIPS64ELROOTFS}/util-linux_extract
[ -f "${METADATAMIPS64ELROOTFS}/binutils_extract" ] || \
  tar xf ${TARBALL}/binutils-${BINUTILS_VERSION}.${BINUTILS_SUFFIX} || \
    die "extract binutils error" && \
      touch ${METADATAMIPS64ELROOTFS}/binutils_extract
[ -f "${METADATAMIPS64ELROOTFS}/gcc_extract" ] || \
  tar xf ${TARBALL}/gcc-${GCC_VERSION}.${GCC_SUFFIX} || \
    die "extract gcc error" && \
      touch ${METADATAMIPS64ELROOTFS}/gcc_extract
[ -f "${METADATAMIPS64ELROOTFS}/eglibc_extract" ] || \
  tar xf ${TARBALL}/eglibc-${EGLIBC_VERSION}-r21467.${EGLIBC_SUFFIX} || \
    die "extract eglibc error" && \
      touch ${METADATAMIPS64ELROOTFS}/eglibc_extract
[ -f "${METADATAMIPS64ELROOTFS}/file11_extract" ] || \
  tar xf ${TARBALL}/file-${FILE11_VERSION}.${FILE11_SUFFIX} || \
    die "extract file error" && \
      touch ${METADATAMIPS64ELROOTFS}/file11_extract
[ -f "${METADATAMIPS64ELROOTFS}/groff_extract" ] || \
  tar xf ${TARBALL}/groff-${GROFF_VERSION}.${GROFF_SUFFIX} || \
    die "extract groff error" && \
      touch ${METADATAMIPS64ELROOTFS}/groff_extract
[ -f "${METADATAMIPS64ELROOTFS}/shadow_extract" ] || \
  tar xf ${TARBALL}/shadow-${SHADOW_VERSION}.${SHADOW_SUFFIX} || \
    die "extract shadow error" && \
      touch ${METADATAMIPS64ELROOTFS}/shadow_extract
[ -f "${METADATAMIPS64ELROOTFS}/ncurses_extract" ] || \
  tar xf ${TARBALL}/ncurses-${NCURSES_VERSION}.${NCURSES_SUFFIX} || \
    die "extract ncurses error" && \
      touch ${METADATAMIPS64ELROOTFS}/ncurses_extract
[ -f "${METADATAMIPS64ELROOTFS}/zlib_extract" ] || \
  tar xf ${TARBALL}/zlib-${ZLIB_VERSION}.${ZLIB_SUFFIX} || \
    die "extract zlib error" && \
      touch ${METADATAMIPS64ELROOTFS}/zlib_extract
[ -f "${METADATAMIPS64ELROOTFS}/sed_extract" ] || \
  tar xf ${TARBALL}/sed-${SED_VERSION}.${SED_SUFFIX} || \
    die "extract sed error" && \
      touch ${METADATAMIPS64ELROOTFS}/sed_extract
[ -f "${METADATAMIPS64ELROOTFS}/coreutils_extract" ] || \
  tar xf ${TARBALL}/coreutils-${COREUTILS_VERSION}.${COREUTILS_SUFFIX} || \
    die "extract coreutils error" && \
      touch ${METADATAMIPS64ELROOTFS}/coreutils_extract
[ -f "${METADATAMIPS64ELROOTFS}/iana-etc_extract" ] || \
  tar xf ${TARBALL}/iana-etc-${IANA_VERSION}.${IANA_SUFFIX} || \
    die "extract iana-etc error" && \
      touch ${METADATAMIPS64ELROOTFS}/iana-etc_extract
[ -f "${METADATAMIPS64ELROOTFS}/m4_extract" ] || \
  tar xf ${TARBALL}/m4-${M4_VERSION}.${M4_SUFFIX} || \
    die "extract m4 error" && \
      touch ${METADATAMIPS64ELROOTFS}/m4_extract
[ -f "${METADATAMIPS64ELROOTFS}/bison_extract" ] || \
  tar xf ${TARBALL}/bison-${BISON_VERSION}.${BISON_SUFFIX} || \
    die "extract bison error" && \
      touch ${METADATAMIPS64ELROOTFS}/bison_extract
[ -f "${METADATAMIPS64ELROOTFS}/procps_extract" ] || \
  tar xf ${TARBALL}/procps-${PROCPS_VERSION}.${PROCPS_SUFFIX} || \
    die "extract procps error" && \
      touch ${METADATAMIPS64ELROOTFS}/procps_extract
[ -f "${METADATAMIPS64ELROOTFS}/libtool_extract" ] || \
  tar xf ${TARBALL}/libtool-${LIBTOOL_VERSION}.${LIBTOOL_SUFFIX} || \
    die "extract libtool error" && \
      touch ${METADATAMIPS64ELROOTFS}/libtool_extract
[ -f "${METADATAMIPS64ELROOTFS}/flex_extract" ] || \
  tar xf ${TARBALL}/flex-${FLEX_VERSION}.${FLEX_SUFFIX} || \
    die "extract flex error" && \
      touch ${METADATAMIPS64ELROOTFS}/flex_extract
[ -f "${METADATAMIPS64ELROOTFS}/iproute2_extract" ] || \
  tar xf ${TARBALL}/iproute2-${IPROUTE2_VERSION}.${IPROUTE2_SUFFIX} || \
    die "extract iproute error" && \
      touch ${METADATAMIPS64ELROOTFS}/iproute2_extract
[ -f "${METADATAMIPS64ELROOTFS}/python_extract" ] || \
  tar xvf ${TARBALL}/python-${PYTHON_VERSION}.${PYTHON_SUFFIX} || \
    die "extract python error" && \
      touch ${METADATAMIPS64ELROOTFS}/python_extract
[ -f "${METADATAMIPS64ELROOTFS}/readline_extract" ] || \
  tar xf ${TARBALL}/readline-${READLINE_VERSION}.${READLINE_SUFFIX} || \
    die "extract readline error" && \
      touch ${METADATAMIPS64ELROOTFS}/readline_extract
[ -f "${METADATAMIPS64ELROOTFS}/autoconf_extract" ] || \
  tar xf ${TARBALL}/autoconf-${AUTOCONF_VERSION}.${AUTOCONF_SUFFIX} || \
    die "extract autoconf error" && \
      touch ${METADATAMIPS64ELROOTFS}/autoconf_extract
[ -f "${METADATAMIPS64ELROOTFS}/automake_extract" ] || \
  tar xf ${TARBALL}/automake-${AUTOMAKE_VERSION}.${AUTOMAKE_SUFFIX} || \
    die "extract automake error" && \
      touch ${METADATAMIPS64ELROOTFS}/automake_extract
[ -f "${METADATAMIPS64ELROOTFS}/bash_extract" ] || \
  tar xf ${TARBALL}/bash-${BASH_VERSION}.${BASH_SUFFIX} || \
    die "extract bash error" && \
      touch ${METADATAMIPS64ELROOTFS}/bash_extract
[ -f "${METADATAMIPS64ELROOTFS}/bzip2_extract" ] || \
  tar xf ${TARBALL}/bzip2-${BZIP2_VERSION}.${BZIP2_SUFFIX} || \
    die "extract bzip2 error" && \
      touch ${METADATAMIPS64ELROOTFS}/bzip2_extract
[ -f "${METADATAMIPS64ELROOTFS}/diffutils_extract" ] || \
  tar xf ${TARBALL}/diffutils-${DIFFUTILS_VERSION}.${DIFFUTILS_SUFFIX} || \
    die "extract diffutils error" && \
      touch ${METADATAMIPS64ELROOTFS}/diffutils_extract
[ -f "${METADATAMIPS64ELROOTFS}/findutils_extract" ] || \
  tar xf ${TARBALL}/findutils-${FINDUTILS_VERSION}.${FINDUTILS_SUFFIX} || \
    die "extract findutils error" && \
      touch ${METADATAMIPS64ELROOTFS}/findutils_extract
[ -f "${METADATAMIPS64ELROOTFS}/gawk_extract" ] || \
  tar xf ${TARBALL}/gawk-${GAWK_VERSION}.${GAWK_SUFFIX} || \
    die "extract gawk error" && \
      touch ${METADATAMIPS64ELROOTFS}/gawk_extract
[ -f "${METADATAMIPS64ELROOTFS}/gettext_extract" ] || \
  tar xf ${TARBALL}/gettext-${GETTEXT_VERSION}.${GETTEXT_SUFFIX} || \
    die "extract gettext error" && \
      touch ${METADATAMIPS64ELROOTFS}/gettext_extract
[ -f "${METADATAMIPS64ELROOTFS}/grep_extract" ] || \
  tar xf ${TARBALL}/grep-${GREP_VERSION}.${GREP_SUFFIX} || \
    die "extract grep error" && \
      touch ${METADATAMIPS64ELROOTFS}/grep_extract
[ -f "${METADATAMIPS64ELROOTFS}/gzip_extract" ] || \
  tar xf ${TARBALL}/gzip-${GZIP_VERSION}.${GZIP_SUFFIX} || \
    die "extract gzip error" && \
      touch ${METADATAMIPS64ELROOTFS}/gzip_extract
[ -f "${METADATAMIPS64ELROOTFS}/kbd_extract" ] || \
  tar xf ${TARBALL}/kbd-${KBD_VERSION}.${KBD_SUFFIX} || \
    die "extract kbd error" && \
      touch ${METADATAMIPS64ELROOTFS}/kbd_extract
[ -f "${METADATAMIPS64ELROOTFS}/less_extract" ] || \
  tar xf ${TARBALL}/less-${LESS_VERSION}.${LESS_SUFFIX} || \
    die "extract less error" && \
      touch ${METADATAMIPS64ELROOTFS}/less_extract
[ -f "${METADATAMIPS64ELROOTFS}/make_extract" ] || \
  tar xf ${TARBALL}/make-${MAKE_VERSION}.${MAKE_SUFFIX} || \
    die "extract make error" && \
      touch ${METADATAMIPS64ELROOTFS}/make_extract
[ -f "${METADATAMIPS64ELROOTFS}/man_extract" ] || \
  tar xf ${TARBALL}/man-${MAN_VERSION}.${MAN_SUFFIX} || \
    die "extract man error" && \
      touch ${METADATAMIPS64ELROOTFS}/man_extract
[ -f "${METADATAMIPS64ELROOTFS}/module-init-tools_extract" ] || \
  tar xf ${TARBALL}/module-init-tools-${MODULE_VERSION}.${MODULE_SUFFIX} || \
    die "extract module-init-tools error" && \
      touch ${METADATAMIPS64ELROOTFS}/module-init-tools_extract
[ -f "${METADATAMIPS64ELROOTFS}/patch_extract" ] || \
  tar xf ${TARBALL}/patch-${PATCH_VERSION}.${PATCH_SUFFIX} || \
    die "extract patch error" && \
      touch ${METADATAMIPS64ELROOTFS}/patch_extract
[ -f "${METADATAMIPS64ELROOTFS}/psmisc_extract" ] || \
  tar xf ${TARBALL}/psmisc-${PSMISC_VERSION}.${PSMISC_SUFFIX} || \
    die "extract psmisc error" && \
      touch ${METADATAMIPS64ELROOTFS}/psmisc_extract
[ -f "${METADATAMIPS64ELROOTFS}/shadow_extract" ] || \
  tar xf ${TARBALL}/shadow-${SHADOW_VERSION}.${SHADOW_SUFFIX} || \
    die "extract shadow error" && \
      touch ${METADATAMIPS64ELROOTFS}/shadow_extract
[ -f "${METADATAMIPS64ELROOTFS}/libestr_extract" ] || \
  tar xf ${TARBALL}/libestr-${LIBESTR_VERSION}.${LIBESTR_SUFFIX} || \
    die "extract libestr error" && \
      touch ${METADATAMIPS64ELROOTFS}/libestr_extract
[ -f "${METADATAMIPS64ELROOTFS}/libee_extract" ] || \
  tar xf ${TARBALL}/libee-${LIBEE_VERSION}.${LIBEE_SUFFIX} || \
    die "extract libee error" && \
      touch ${METADATAMIPS64ELROOTFS}/libee_extract
[ -f "${METADATAMIPS64ELROOTFS}/rsyslog_extract" ] || \
  tar xf ${TARBALL}/rsyslog-${RSYSLOG_VERSION}.${RSYSLOG_SUFFIX} || \
    die "extract rsyslog error" && \
      touch ${METADATAMIPS64ELROOTFS}/rsyslog_extract
[ -f "${METADATAMIPS64ELROOTFS}/sysvinit_extract" ] || \
  tar xf ${TARBALL}/sysvinit-${SYSVINIT_VERSION}.${SYSVINIT_SUFFIX} || \
    die "extract sysvinit error" && \
      touch ${METADATAMIPS64ELROOTFS}/sysvinit_extract
[ -f "${METADATAMIPS64ELROOTFS}/tar_extract" ] || \
  tar xf ${TARBALL}/tar-${TAR_VERSION}.${TAR_SUFFIX} || \
    die "extract tar error" && \
      touch ${METADATAMIPS64ELROOTFS}/tar_extract
[ -f "${METADATAMIPS64ELROOTFS}/texinfo_extract" ] || \
  tar xf ${TARBALL}/texinfo-${TEXINFO_VERSION}a.${TEXINFO_SUFFIX} || \
    die "extract texinfo error" && \
      touch ${METADATAMIPS64ELROOTFS}/texinfo_extract
[ -f "${METADATAMIPS64ELROOTFS}/kmod_extract" ] || \
  tar xf ${TARBALL}/kmod-${KMOD_VERSION}.${KMOD_SUFFIX} || \
    die "extract kmod error" && \
      touch ${METADATAMIPS64ELROOTFS}/kmod_extract
[ -f "${METADATAMIPS64ELROOTFS}/udev_extract" ] || \
  tar xf ${TARBALL}/udev-${UDEV_VERSION}.${UDEV_SUFFIX} || \
    die "extract udev error" && \
      touch ${METADATAMIPS64ELROOTFS}/udev_extract
[ -f "${METADATAMIPS64ELROOTFS}/vim_extract" ] || \
  tar xf ${TARBALL}/vim-${VIM_VERSION}.${VIM_SUFFIX} || \
    die "extract vim error" && \
      touch ${METADATAMIPS64ELROOTFS}/vim_extract
[ -f "${METADATAMIPS64ELROOTFS}/xz_extract" ] || \
  tar xf ${TARBALL}/xz-${XZ_VERSION}.${XZ_SUFFIX} || \
    die "extract xz error" && \
      touch ${METADATAMIPS64ELROOTFS}/xz_extract
[ -f "${METADATAMIPS64ELROOTFS}/bootscript_extract" ] || \
  tar xf ${TARBALL}/bootscripts-cross-lfs-${BOOTSCRIPTS_VERSION}.${BOOTSCRIPTS_SUFFIX} || \
    die "extract bootscript error" && \
      touch ${METADATAMIPS64ELROOTFS}/bootscript_extract
[ -f "${METADATAMIPS64ELROOTFS}/linux_extract" ] || \
  tar xf ${TARBALL}/linux-${LINUX_VERSION}.${LINUX_SUFFIX} || \
    die "extract linux error" && \
      touch ${METADATAMIPS64ELROOTFS}/linux_extract
[ -f "${METADATAMIPS64ELROOTFS}/e2fs_extract" ] || \
  tar xf ${TARBALL}/e2fsprogs-${E2FSPROGS_VERSION}.${E2FSPROGS_SUFFIX} || \
    die "extract e2fs error" && \
      touch ${METADATAMIPS64ELROOTFS}/e2fs_extract
[ -f "${METADATAMIPS64ELROOTFS}/gdb_extract" ] || \
  tar xf ${TARBALL}/gdb-${GDB_VERSION}.${GDB_SUFFIX} || \
    die "extract gdb error" && \
      touch ${METADATAMIPS64ELROOTFS}/gdb_extract
popd


pushd ${SRCMIPS64ELROOTFS}/eglibc-${EGLIBC_VERSION}
[ -f "${METADATAMIPS64ELROOTFS}/eglibc-ports_extract" ] || \
  tar xf ${TARBALL}/eglibc-ports-${EGLIBCPORTS_VERSION}-r21467.${EGLIBCPORTS_SUFFIX} || \
    die "extract eglibc ports error" && \
      touch ${METADATAMIPS64ELROOTFS}/eglibc-ports_extract
popd

pushd ${BUILDMIPS64ELROOTFS}
[ -f "${METADATAMIPS64ELROOTFS}/groff_extract" ] || \
  tar xf ${TARBALL}/groff-${GROFF_VERSION}.${GROFF_SUFFIX} || \
    die "extract groff error" && \
      touch ${METADATAMIPS64ELROOTFS}/groff_extract
[ -f "${METADATAMIPS64ELROOTFS}/man-pages_extract" ] || \
  tar xf ${TARBALL}/man-pages-${MANPAGES_VERSION}.${MANPAGES_SUFFIX} || \
    die "extract man-pages error" && \
      touch ${METADATAMIPS64ELROOTFS}/man-pages_extract
[ -f "${METADATAMIPS64ELROOTFS}/iputils_extract" ] || \
  tar xf ${TARBALL}/iputils-${IPUTILS_VERSION}.${IPUTILS_SUFFIX} || \
    die "extract iputils error" && \
      touch ${METADATAMIPS64ELROOTFS}/iputils_extract
popd

pushd ${SRCMIPS64ELROOTFS}
[ -f "${METADATAMIPS64ELROOTFS}/perl_cross_extract" ] || \
  tar xf ${TARBALL}/perl-${PERLCROSS_VERSION}.${PERLCROSS_SUFFIX} || \
    die "extract perl cross error" && \
      touch ${METADATAMIPS64ELROOTFS}/perl_cross_extract
popd

pushd ${BUILDMIPS64ELROOTFS}
[ -f "${METADATAMIPS64ELROOTFS}/perl_extract" ] || \
  tar xf ${TARBALL}/perl-${PERL_VERSION}.${PERL_SUFFIX} || \
    die "extract perl error" && \
      touch ${METADATAMIPS64ELROOTFS}/perl_extract
popd

pushd ${BUILDMIPS64ELROOTFS}
cd perl-${PERL_VERSION}
[ -f "${METADATAMIPS64ELROOTFS}/perl_cross_merge" ] || \
  cp -ar ${SRCMIPS64ELROOTFS}/perl-${PERL_VERSION}/* ./ || \
    die "merge cross perl error" && \
      touch ${METADATAMIPS64ELROOTFS}/perl_cross_merge
popd

######################## Begin Compiler CrossGcc ##############################
pushd ${BUILDMIPS64ELROOTFS}
[ -f "${METADATAMIPS64ELROOTFS}/linux_copy" ] || \
  cp -ar ${SRCMIPS64ELROOTFS}/linux-${LINUX_VERSION} linux-headers || \
    die "copy linux error" && \
      touch ${METADATAMIPS64ELROOTFS}/linux_copy
cd linux-headers
[ -f "${METADATAMIPS64ELROOTFS}/linux_clean" ] || \
  make mrproper || \
    die "clean linux error" && \
      touch ${METADATAMIPS64ELROOTFS}/linux_clean
[ -f "${METADATAMIPS64ELROOTFS}/linux_check_headers" ] || \
  make ARCH=mips headers_check || \
    die "***check headers error" && \
      touch ${METADATAMIPS64ELROOTFS}/linux_check_headers
[ -f "${METADATAMIPS64ELROOTFS}/linux_headers_install" ] || \
  make ARCH=mips INSTALL_HDR_PATH=dest headers_install || \
    die "***install headers error" && \
      touch ${METADATAMIPS64ELROOTFS}/linux_headers_install
[ -f "${METADATAMIPS64ELROOTFS}/linux_copy_headers" ] || \
  cp -r dest/include/* ${PREFIXMIPS64ELROOTFS}/usr/include || \
    die "***copy headers error" && \
      touch ${METADATAMIPS64ELROOTFS}/linux_copy_headers
[ -f "${METADATAMIPS64ELROOTFS}/linux_clean_install.cmd" ] || \
  find ${PREFIXMIPS64ELROOTFS}/usr/include -name .install -or -name ..install.cmd | xargs rm -fv || \
    die "clean linux install.cmd error" && \
      touch ${METADATAMIPS64ELROOTFS}/linux_clean_install.cmd
popd

pushd ${BUILDMIPS64ELROOTFS}
[ -d gmp-build ] || mkdir gmp-build
cd gmp-build
[ -f "${METADATAMIPS64ELROOTFS}/gmp_config" ] || \
  CPPFLAGS=-fexceptions ${SRCMIPS64ELROOTFS}/gmp-${GMP_VERSION}/configure \
  --prefix=${PREFIXMIPS64ELROOTFS}/cross-tools --enable-cxx || \
    die "***config gmp error" && \
      touch ${METADATAMIPS64ELROOTFS}/gmp_config
[ -f "${METADATAMIPS64ELROOTFS}/gmp_build" ] || \
  make -j${JOBS} || \
    die "***build gmp error" && \
      touch ${METADATAMIPS64ELROOTFS}/gmp_build
[ -f "${METADATAMIPS64ELROOTFS}/gmp_install" ] || \
  make install || \
    die "***install gmp error" && \
      touch ${METADATAMIPS64ELROOTFS}/gmp_install
popd

pushd ${BUILDMIPS64ELROOTFS}
[ -d mpfr-build ] || mkdir mpfr-build
cd mpfr-build
[ -f "${METADATAMIPS64ELROOTFS}/mpfr_config" ] || \
  LDFLAGS="-Wl,-rpath,${PREFIXMIPS64ELROOTFS}/cross-tools/lib" \
  ${SRCMIPS64ELROOTFS}/mpfr-${MPFR_VERSION}/configure --prefix=${PREFIXMIPS64ELROOTFS}/cross-tools \
  --with-gmp=${PREFIXMIPS64ELROOTFS}/cross-tools --enable-shared || \
    die "***config mpfr error" && \
      touch ${METADATAMIPS64ELROOTFS}/mpfr_config
[ -f "${METADATAMIPS64ELROOTFS}/mpfr_build" ] || \
  make -j${JOBS} || \
    die "***build mpfr error" && \
      touch ${METADATAMIPS64ELROOTFS}/mpfr_build
[ -f "${METADATAMIPS64ELROOTFS}/mpfr_install" ] || \
  make install || \
    die "***install mpfr error" && \
      touch ${METADATAMIPS64ELROOTFS}/mpfr_install
popd

pushd ${BUILDMIPS64ELROOTFS}
[ -d mpc-build ] || mkdir mpc-build
cd mpc-build
[ -f "${METADATAMIPS64ELROOTFS}/mpc_config" ] || \
  LDFLAGS="-Wl,-rpath,/cross-tools/lib" \
  ${SRCMIPS64ELROOTFS}/mpc-${MPC_VERSION}/configure --prefix=${PREFIXMIPS64ELROOTFS}/cross-tools \
  --with-gmp=${PREFIXMIPS64ELROOTFS}/cross-tools --with-mpfr=${PREFIXMIPS64ELROOTFS}/cross-tools || \
    die "***config mpc error" && \
      touch ${METADATAMIPS64ELROOTFS}/mpc_config
[ -f "${METADATAMIPS64ELROOTFS}/mpc_build" ] || \
  make -j${JOBS} || \
    die "***build mpc error" && \
      touch ${METADATAMIPS64ELROOTFS}/mpc_build
[ -f "${METADATAMIPS64ELROOTFS}/mpc_install" ] || \
  make install || \
    die "***install mpc error" && \
      touch ${METADATAMIPS64ELROOTFS}/mpc_install
popd

pushd ${BUILDMIPS64ELROOTFS}
[ -d ppl-build ] || mkdir ppl-build
cd ppl-build
[ -f "${METADATAMIPS64ELROOTFS}/ppl_config" ] || \
  LDFLAGS="-Wl,-rpath,${PREFIXMIPS64ELROOTFS}/cross-tools/lib" \
  ${SRCMIPS64ELROOTFS}/ppl-${PPL_VERSION}/configure --prefix=${PREFIXMIPS64ELROOTFS}/cross-tools \
  --enable-shared \
  --enable-interfaces="c,cxx" --disable-optimization \
  --with-libgmp-prefix=${PREFIXMIPS64ELROOTFS}/cross-tools \
  --with-libgmpxx-prefix=${PREFIXMIPS64ELROOTFS}/cross-tools || \
    die "***config ppl error" && \
      touch ${METADATAMIPS64ELROOTFS}/ppl_config
[ -f "${METADATAMIPS64ELROOTFS}/ppl_build" ] || \
  make -j${JOBS} || \
    die "***build ppl error" && \
      touch ${METADATAMIPS64ELROOTFS}/ppl_build
[ -f "${METADATAMIPS64ELROOTFS}/ppl_install" ] || \
  make install || \
    die "***install ppl error" && \
      touch ${METADATAMIPS64ELROOTFS}/ppl_install
popd

pushd ${BUILDMIPS64ELROOTFS}
[ -d cloog-build ] || mkdir cloog-build
cd cloog-build
[ -f "${METADATAMIPS64ELROOTFS}/cloog_config" ] || \
  LDFLAGS="-Wl,-rpath,${PREFIXMIPS64ELROOTFS}/cross-tools/lib" \
  ${SRCMIPS64ELROOTFS}/cloog-${CLOOG_VERSION}/configure --prefix=${PREFIXMIPS64ELROOTFS}/cross-tools \
  --enable-shared \
  --with-gmp-prefix=${PREFIXMIPS64ELROOTFS}/cross-tools || \
    die "***config cloog error" && \
      touch ${METADATAMIPS64ELROOTFS}/cloog_config
[ -f "${METADATAMIPS64ELROOTFS}/cloog_build" ] || \
  make -j${JOBS} || \
    die "***build cloog error" && \
      touch ${METADATAMIPS64ELROOTFS}/cloog_build
[ -f "${METADATAMIPS64ELROOTFS}/cloog_install" ] || \
  make install || \
    die "***install cloog error" && \
      touch ${METADATAMIPS64ELROOTFS}/cloog_install
popd

pushd ${BUILDMIPS64ELROOTFS}
[ -d libestr-build ] || mkdir libestr-build
cd libestr-build
[ -f "${METADATAMIPS64ELROOTFS}/libestr_create_config.cache" ] || \
  `cat > config.cache << EOF
ac_cv_func_malloc_0_nonnull=yes
ac_cv_func_realloc_0_nonnull=yes
EOF` || \
    die "create libestr config.cache error" && \
      touch ${METADATAMIPS64ELROOTFS}/libestr_create_config.cache
[ -f "${METADATAMIPS64ELROOTFS}/libestr_config" ] || \
  ${SRCMIPS64ELROOTFS}/libestr-${LIBESTR_VERSION}/configure \
  --prefix=/cross-tools --sbindir=/sbin \
  --cache-file=config.cache || \
    die "***config libestr error" && \
      touch ${METADATAMIPS64ELROOTFS}/libestr_config
[ -f "${METADATAMIPS64ELROOTFS}/libestr_build" ] || \
  make -j${JOBS} || \
    die "***build libestr error" && \
      touch ${METADATAMIPS64ELROOTFS}/libestr_build
[ -f "${METADATAMIPS64ELROOTFS}/libestr_install" ] || \
  make DESTDIR=${PREFIXMIPS64ELROOTFS} install || \
    die "***install libestr error" && \
      touch ${METADATAMIPS64ELROOTFS}/libestr_install
popd

pushd ${BUILDMIPS64ELROOTFS}
[ -d libee-build ] || mkdir libee-build
cd libee-build
[ -f "${METADATAMIPS64ELROOTFS}/libee_create_config.cache" ] || \
  `cat > config.cache << EOF
ac_cv_func_malloc_0_nonnull=yes
ac_cv_func_realloc_0_nonnull=yes
EOF` || \
    die "create libee config.cache error" && \
      touch ${METADATAMIPS64ELROOTFS}/libee_create_config.cache
[ -f "${METADATAMIPS64ELROOTFS}/libee_config" ] || \
  PKG_CONFIG_PATH=${PREFIXMIPS64ELROOTFS}/cross-tools/lib/pkgconfig \
  CPPFLAGS="-I${PREFIXMIPS64ELROOTFS}/cross-tools/include" \
  LDFLAGS="-L${PREFIXMIPS64ELROOTFS}/cross-tools/lib" \
   ${SRCMIPS64ELROOTFS}/libee-${LIBEE_VERSION}/configure \
  --prefix=/cross-tools --sbindir=/sbin \
  --cache-file=config.cache || \
    die "***config libee error" && \
      touch ${METADATAMIPS64ELROOTFS}/libee_config
[ -f "${METADATAMIPS64ELROOTFS}/libee_build" ] || \
  make || \
    die "***build libee error" && \
      touch ${METADATAMIPS64ELROOTFS}/libee_build
[ -f "${METADATAMIPS64ELROOTFS}/libee_install" ] || \
  make DESTDIR=${PREFIXMIPS64ELROOTFS} install || \
    die "***install libee error" && \
      touch ${METADATAMIPS64ELROOTFS}/libee_install
popd

# TREATE AS PATCH
pushd ${SRCMIPS64ELROOTFS}/util-${UTIL_VERSION}
cp hwclock/hwclock.c{,.orig}
[ -f "${METADATAMIPS64ELROOTFS}/util-linux_update hwclock" ] || \
  sed -e 's@etc/adjtime@var/lib/hwclock/adjtime@g' \
  hwclock/hwclock.c.orig > hwclock/hwclock.c || \
    die "update util-linux hwclock" && \
      touch ${METADATAMIPS64ELROOTFS}/util-linux_update hwclock
popd

pushd ${BUILDMIPS64ELROOTFS}
[ -d util-linux-build ] || mkdir util-linux-build
cd util-linux-build
[ -f "${METADATAMIPS64ELROOTFS}/util-linux_create_config.cache" ] || \
  `cat > config.cache << EOF
scanf_cv_type_modifier=ms
EOF` || \
    die "create util-linux config.cache" && \
      touch ${METADATAMIPS64ELROOTFS}/util-linux_create_config.cache
[ -f "${METADATAMIPS64ELROOTFS}/util-linux_config" ] || \
  ${SRCMIPS64ELROOTFS}/util-${UTIL_VERSION}/configure \
  --prefix=/cross-tools \
  --enable-arch --enable-partx --disable-wall \
  --enable-write --disable-makeinstall-chown \
  --cache-file=config.cache \
  --disable-login --disable-su || \
    die "***config util-linux error" && \
      touch ${METADATAMIPS64ELROOTFS}/util-linux_config
[ -f "${METADATAMIPS64ELROOTFS}/util-linux_build" ] || \
  make -j${JOBS} || \
    die "***build util-linux error" && \
      touch ${METADATAMIPS64ELROOTFS}/util-linux_build
[ -f "${METADATAMIPS64ELROOTFS}/util-linux_install" ] || \
  make DESTDIR=${PREFIXMIPS64ELROOTFS} install || \
    die "***install util-linux error" && \
      touch ${METADATAMIPS64ELROOTFS}/util-linux_install
popd

pushd ${BUILDMIPS64ELROOTFS}
[ -d "binutils-build" ] || mkdir binutils-build
cd binutils-build
[ -f "${METADATAMIPS64ELROOTFS}/binutils_config" ] || \
  AS="as" AR="ar" \
  ${SRCMIPS64ELROOTFS}/binutils-${BINUTILS_VERSION}/configure \
  --prefix=${PREFIXMIPS64ELROOTFS}/cross-tools --host=${CROSS_HOST} --target=${CROSS_TARGET64} \
  --with-sysroot=${PREFIXMIPS64ELROOTFS} --disable-nls --enable-shared || \
    die "***config binutils error" && \
      touch ${METADATAMIPS64ELROOTFS}/binutils_config
[ -f "${METADATAMIPS64ELROOTFS}/binutils_config_host" ] || \
  make configure-host || \
    die "config binutils host error" && \
      touch ${METADATAMIPS64ELROOTFS}/binutils_config_host
[ -f "${METADATAMIPS64ELROOTFS}/binutils_build" ] || \
  make -j${JOBS} || \
    die "***build binutils error" && \
      touch ${METADATAMIPS64ELROOTFS}/binutils_build
[ -f "${METADATAMIPS64ELROOTFS}/binutils_install" ] || \
  make install || \
    die "***install binutils error" && \
      touch ${METADATAMIPS64ELROOTFS}/binutils_install
[ -f "${METADATAMIPS64ELROOTFS}/binutils_copy_headers" ] || \
  cp ${SRCMIPS64ELROOTFS}/binutils-${BINUTILS_VERSION}/include/libiberty.h \
  ${PREFIXMIPS64ELROOTFS}/usr/include || \
    die "***copy binutils header error" && \
      touch ${METADATAMIPS64ELROOTFS}/binutils_copy_headers
popd

pushd ${BUILDMIPS64ELROOTFS}
[ -d "gcc-build-stage1" ] || mkdir gcc-build-stage1
cd gcc-build-stage1
[ -f "${METADATAMIPS64ELROOTFS}/gcc_stage1_config" ] || \
  AR=ar LDFLAGS="-Wl,-rpath,${PREFIXMIPS64ELROOTFS}/cross-tools/lib" \
  ${SRCMIPS64ELROOTFS}/gcc-${GCC_VERSION}/configure \
  --prefix=${PREFIXMIPS64ELROOTFS}/cross-tools --build=${CROSS_HOST} --host=${CROSS_HOST} \
  --target=${CROSS_TARGET64} --with-sysroot=${PREFIXMIPS64ELROOTFS} \
  --disable-nls \
  --without-headers --with-newlib --disable-decimal-float \
  --disable-libgomp --disable-libmudflap --disable-libssp \
  --with-mpfr=${PREFIXMIPS64ELROOTFS}/cross-tools --with-gmp=${PREFIXMIPS64ELROOTFS}/cross-tools \
  --with-ppl=${PREFIXMIPS64ELROOTFS}/cross-tools --with-cloog=${PREFIXMIPS64ELROOTFS}/cross-tools \
  --with-mpc=${PREFIXMIPS64ELROOTFS}/cross-tools \
  --disable-shared --disable-threads --enable-languages=c \
  --enable-cloog-backend=isl || \
    die "***config gcc stage1 error" && \
      touch ${METADATAMIPS64ELROOTFS}/gcc_stage1_config
[ -f "${METADATAMIPS64ELROOTFS}/gcc_stage1_build" ] || \
  make -j${JOBS} all-gcc all-target-libgcc || \
    die "***build gcc stage1 error" && \
      touch ${METADATAMIPS64ELROOTFS}/gcc_stage1_build
[ -f "${METADATAMIPS64ELROOTFS}/gcc_stage1_install" ] || \
  make install-gcc install-target-libgcc || \
    die "***install gcc stage1 error" && \
      touch ${METADATAMIPS64ELROOTFS}/gcc_stage1_install
popd

# As a patch to eglibc
pushd ${SRCMIPS64ELROOTFS}/eglibc-${EGLIBC_VERSION}
[ -f "${METADATAMIPS64ELROOTFS}/eglibc_update_Makefile" ] || \
  cp Makeconfig{,.orig} &&
  sed -e 's/-lgcc_eh//g' Makeconfig.orig > Makeconfig || \
    die "update eglibc Makefile error" && \
      touch ${METADATAMIPS64ELROOTFS}/eglibc_update_Makefile
popd

pushd ${BUILDMIPS64ELROOTFS}
[ -d "eglibc-build32" ] || mkdir eglibc-build32
cd eglibc-build32
[ -f "${METADATAMIPS64ELROOTFS}/eglibc_create32_config.cache" ] || \
  `cat > config.cache << "EOF"
libc_cv_forced_unwind=yes
libc_cv_c_cleanup=yes
libc_cv_gnu89_inline=yes
EOF` || \
    die "create eglibc32 config.cache" && \
      touch ${METADATAMIPS64ELROOTFS}/eglibc_create32_config.cache

[ -f "${METADATAMIPS64ELROOTFS}/eglibc_update32_configparms" ] || \
  `cat > configparms << EOF
install_root=${PREFIXMIPS64ELROOTFS}
EOF` || \
    die "update eglibc32 configparms" && \
      touch ${METADATAMIPS64ELROOTFS}/eglibc_update32_configparms

[ -f "${METADATAMIPS64ELROOTFS}/eglibc_config32" ] || \
  BUILD_CC="gcc" CC="${CROSS_TARGET64}-gcc ${BUILD32}" \
  AR="${CROSS_TARGET64}-ar" RANLIB="${CROSS_TARGET64}-ranlib" \
  CFLAGS_FOR_TARGET="-O2" CFLAGS+="-O2" \
  ${SRCMIPS64ELROOTFS}/eglibc-${EGLIBC_VERSION}/configure \
  --prefix=/usr --libexecdir=/usr/lib/eglibc \
  --host=${CROSS_TARGET32} --build=${CROSS_HOST} \
  --disable-profile --enable-add-ons --with-tls --enable-kernel=2.6.0 \
  --with-__thread --with-binutils=${PREFIXMIPS64ELROOTFS}/cross-tools/bin \
  --with-headers=${PREFIXMIPS64ELROOTFS}/usr/include --cache-file=config.cache || \
    die "***config eglibc32 error" && \
      touch ${METADATAMIPS64ELROOTFS}/eglibc_config32
[ -f "${METADATAMIPS64ELROOTFS}/eglibc_build32" ] || \
  make -j${JOBS} || \
    die "***build eglibc32 error" && \
      touch ${METADATAMIPS64ELROOTFS}/eglibc_build32
[ -f "${METADATAMIPS64ELROOTFS}/eglibc_install32" ] || \
  make install || \
    die "***install eglibc32 error" && \
      touch ${METADATAMIPS64ELROOTFS}/eglibc_install32
popd

pushd ${BUILDMIPS64ELROOTFS}
[ -d "eglibc-buildn32" ] || mkdir eglibc-buildn32
cd eglibc-buildn32
[ -f "${METADATAMIPS64ELROOTFS}/eglibc_createn32_config.cache" ] || \
  `cat > config.cache << "EOF"
libc_cv_forced_unwind=yes
libc_cv_c_cleanup=yes
libc_cv_gnu89_inline=yes
EOF` || \
    die "create eglibcn32 config.cache" && \
      touch ${METADATAMIPS64ELROOTFS}/eglibc_createn32_config.cache

[ -f "${METADATAMIPS64ELROOTFS}/eglibc_updaten32_configparms" ] || \
  `cat > configparms << EOF
install_root=${PREFIXMIPS64ELROOTFS}
EOF` || \
    die "update eglibcn32 configparms" && \
      touch ${METADATAMIPS64ELROOTFS}/eglibc_updaten32_configparms


[ -f "${METADATAMIPS64ELROOTFS}/eglibc_confign32" ] || \
  BUILD_CC="gcc" CC="${CROSS_TARGET64}-gcc ${BUILDN32}" \
  AR="${CROSS_TARGET64}-ar" RANLIB="${CROSS_TARGET64}-ranlib" \
  CFLAGS_FOR_TARGET="-O2" CFLAGS+="-O2" \
  ${SRCMIPS64ELROOTFS}/eglibc-${EGLIBC_VERSION}/configure \
  --prefix=/usr --libdir=/usr/lib32 \
  --libexecdir=/usr/lib32/eglibc --host=${CROSS_TARGET64} --build=${CROSS_HOST} \
  --disable-profile --enable-add-ons --with-tls --enable-kernel=2.6.0 \
  --with-__thread --with-binutils=${PREFIXMIPS64ELROOTFS}/cross-tools/bin \
  --with-headers=${PREFIXMIPS64ELROOTFS}/usr/include --cache-file=config.cache || \
    die "***config eglibcn32 error" && \
      touch ${METADATAMIPS64ELROOTFS}/eglibc_confign32
[ -f "${METADATAMIPS64ELROOTFS}/eglibc_buildn32" ] || \
  make -j${JOBS} || \
    die "***build eglibcn32 error" && \
      touch ${METADATAMIPS64ELROOTFS}/eglibc_buildn32
[ -f "${METADATAMIPS64ELROOTFS}/eglibc_installn32" ] || \
  make install || \
    die "***install eglibcn32 error" && \
      touch ${METADATAMIPS64ELROOTFS}/eglibc_installn32
popd

pushd ${BUILDMIPS64ELROOTFS}
[ -d "eglibc-build64" ] || mkdir eglibc-build64
cd eglibc-build64

[ -f "${METADATAMIPS64ELROOTFS}/eglibc_create64_config.cache" ] || \
  `cat > config.cache << "EOF"
libc_cv_forced_unwind=yes
libc_cv_c_cleanup=yes
libc_cv_gnu89_inline=yes
EOF` || \
    die "create eglibc64 config.cache" && \
      touch ${METADATAMIPS64ELROOTFS}/eglibc_create64_config.cache

[ -f "${METADATAMIPS64ELROOTFS}/eglibc_update64_configparms" ] || \
  `cat > configparms << EOF
install_root=${PREFIXMIPS64ELROOTFS}
EOF` || \
    die "update eglibc32 configparms" && \
      touch ${METADATAMIPS64ELROOTFS}/eglibc_update64_configparms

[ -f "${METADATAMIPS64ELROOTFS}/eglibc_config64" ] || \
  BUILD_CC="gcc" CC="${CROSS_TARGET64}-gcc ${BUILD64}" \
  AR="${CROSS_TARGET64}-ar" RANLIB="${CROSS_TARGET64}-ranlib" \
  CFLAGS_FOR_TARGET="-O2" CFLAGS+="-O2" \
  ${SRCMIPS64ELROOTFS}/eglibc-${EGLIBC_VERSION}/configure \
  --prefix=/usr --libdir=/usr/lib64 \
  --libexecdir=/usr/lib64/eglibc --host=${CROSS_TARGET64} --build=${CROSS_HOST} \
  --disable-profile --enable-add-ons --with-tls --enable-kernel=2.6.0 \
  --with-__thread --with-binutils=${PREFIXMIPS64ELROOTFS}/cross-tools/bin \
  --with-headers=${PREFIXMIPS64ELROOTFS}/usr/include --cache-file=config.cache || \
    die "***config eglibc64 error" && \
      touch ${METADATAMIPS64ELROOTFS}/eglibc_config64
[ -f "${METADATAMIPS64ELROOTFS}/eglibc_build64" ] || \
make -j${JOBS} || \
  die "***build eglibc64 error" && \
    touch ${METADATAMIPS64ELROOTFS}/eglibc_build64
[ -f "${METADATAMIPS64ELROOTFS}/eglibc_install64" ] || \
make install || \
  die "***install eglibc64 error" && \
    touch ${METADATAMIPS64ELROOTFS}/eglibc_install64

[ -f "${METADATAMIPS64ELROOTFS}/eglibc_copy_headers" ] || \
  cp -v ${SRCMIPS64ELROOTFS}/eglibc-${EGLIBC_VERSION}/sunrpc/rpc/*.h \
        ${PREFIXMIPS64ELROOTFS}/usr/include/rpc && \
  cp -v ${SRCMIPS64ELROOTFS}/eglibc-${EGLIBC_VERSION}/sunrpc/rpcsvc/*.h \
        ${PREFIXMIPS64ELROOTFS}/usr/include/rpcsvc && \
  cp -v ${SRCMIPS64ELROOTFS}/eglibc-${EGLIBC_VERSION}/nis/rpcsvc/*.h \
        ${PREFIXMIPS64ELROOTFS}/usr/include/rpcsvc || \
    die "copy eglibc headers error" && \
      touch ${METADATAMIPS64ELROOTFS}/eglibc_copy_headers
popd

pushd ${BUILDMIPS64ELROOTFS}
[ -d "gcc-build-stage2" ] || mkdir gcc-build-stage2
cd gcc-build-stage2
[ -f "${METADATAMIPS64ELROOTFS}/gcc_stage2_config" ] || \
  AR=ar LDFLAGS="-Wl,-rpath,${PREFIXMIPS64ELROOTFS}/cross-tools/lib" \
  ${SRCMIPS64ELROOTFS}/gcc-${GCC_VERSION}/configure \
  --prefix=${PREFIXMIPS64ELROOTFS}/cross-tools \
  --build=${CROSS_HOST} --host=${CROSS_HOST} --target=${CROSS_TARGET64} \
  --with-sysroot=${PREFIXMIPS64ELROOTFS} --disable-nls \
  --enable-shared --enable-languages=c,c++ --enable-__cxa_atexit \
  --with-mpfr=${PREFIXMIPS64ELROOTFS}/cross-tools --with-gmp=${PREFIXMIPS64ELROOTFS}/cross-tools \
  --with-ppl=${PREFIXMIPS64ELROOTFS}/cross-tools --with-cloog=${PREFIXMIPS64ELROOTFS}/cross-tools \
  --with-mpc=${PREFIXMIPS64ELROOTFS}/cross-tools \
  --enable-c99 --enable-long-long --enable-threads=posix \
  --enable-cloog-backend=isl || \
    die "***config gcc stage2 error" && \
      touch ${METADATAMIPS64ELROOTFS}/gcc_stage2_config
[ -f "${METADATAMIPS64ELROOTFS}/gcc_stage2_build" ] || \
  make -j${JOBS} AS_FOR_TARGET="${CROSS_TARGET64}-as" \
  LD_FOR_TARGET="${CROSS_TARGET64}-ld" || \
    die "***build gcc stage2 error" && \
      touch ${METADATAMIPS64ELROOTFS}/gcc_stage2_build
[ -f "${METADATAMIPS64ELROOTFS}/gcc_stage2_install" ] || \
  make install || \
    die "***install gcc stage2 error" && \
      touch ${METADATAMIPS64ELROOTFS}/gcc_stage2_install
popd

pushd ${BUILDMIPS64ELROOTFS}
[ -d file-build ] || mkdir file-build
cd file-build
[ -f "${METADATAMIPS64ELROOTFS}/file_config" ] || \
  ${SRCMIPS64ELROOTFS}/file-${FILE11_VERSION}/configure --prefix=${PREFIXMIPS64ELROOTFS}/cross-tools || \
    die "***config file error" && \
      touch ${METADATAMIPS64ELROOTFS}/file_config
[ -f "${METADATAMIPS64ELROOTFS}/file_build" ] || \
  make -j${JOBS} || \
    die "***build file error" && \
      touch ${METADATAMIPS64ELROOTFS}/file_build
[ -f "${METADATAMIPS64ELROOTFS}/file_install" ] || \
  make install || \
    die "***install file error" && \
      touch ${METADATAMIPS64ELROOTFS}/file_install
popd

pushd ${BUILDMIPS64ELROOTFS}
[ -d groff-build ] || mkdir groff-build
cd groff-build
[ -f "${METADATAMIPS64ELROOTFS}/groff_config" ] || \
  PAGE=A4 ${SRCMIPS64ELROOTFS}/groff-${GROFF_VERSION}/configure \
  --prefix=${PREFIXMIPS64ELROOTFS}/cross-tools --without-x || \
    die "***config groff error" && \
      touch ${METADATAMIPS64ELROOTFS}/groff_config
[ -f "${METADATAMIPS64ELROOTFS}/groff_build" ] || \
  make -j${JOBS} || \
    die "***build groff error" && \
      touch ${METADATAMIPS64ELROOTFS}/groff_build
[ -f "${METADATAMIPS64ELROOTFS}/groff_install" ] || \
  make install || \
    die "***install groff error" && \
      touch ${METADATAMIPS64ELROOTFS}/groff_install
popd

pushd ${SRCMIPS64ELROOTFS}/shadow-${SHADOW_VERSION}
[ -f "${METADATAMIPS64ELROOTFS}/shadow_patch" ] || \
  patch -p1 < ${PATCH}/shadow-${SHADOW_VERSION}-sysroot_hacks-1.patch || \
    die "Patch shadow error" && \
      touch ${METADATAMIPS64ELROOTFS}/shadow_patch
popd

pushd ${BUILDMIPS64ELROOTFS}
[ -d shadow-build ] || mkdir shadow-build
cd shadow-build
[ -f "${METADATAMIPS64ELROOTFS}/shadow_create_config.cache" ] || \
  `cat > config.cache << EOF
shadow_cv_passwd_dir="${PREFIXMIPS64ELROOTFS}/bin"
ac_cv_func_lckpwdf=no
EOF` || \
    die "create shadow config.cache error" && \
      touch ${METADATAMIPS64ELROOTFS}/shadow_create_config.cache

[ -f "${METADATAMIPS64ELROOTFS}/shadow_config" ] || \
  ${SRCMIPS64ELROOTFS}/shadow-${SHADOW_VERSION}/configure --prefix=${PREFIXMIPS64ELROOTFS}/cross-tools \
  --sbindir=${PREFIXMIPS64ELROOTFS}/cross-tools/bin \
  --sysconfdir=$PREFIXMIPS64ELROOTFS/etc --disable-shared --without-libpam \
  --without-audit --without-selinux --program-prefix=${CROSS_TARGET64}- \
  --without-nscd --cache-file=config.cache || \
    die "***config shadow error" && \
      touch ${METADATAMIPS64ELROOTFS}/shadow_config
cp config.h{,.orig} && \
sed "/PASSWD_PROGRAM/s/passwd/${CROSS_TARGET64}-&/" config.h.orig > config.h || \
  die "update shadow config.h error" && \
[ -f "${METADATAMIPS64ELROOTFS}/shadow_build" ] || \
  make -j${JOBS} || \
    die "***build shadow error" && \
      touch ${METADATAMIPS64ELROOTFS}/shadow_build
[ -f "${METADATAMIPS64ELROOTFS}/shadow_install" ] || \
  make install || \
    die "***install shadow error" && \
      touch ${METADATAMIPS64ELROOTFS}/shadow_install
popd

pushd ${SRCMIPS64ELROOTFS}/ncurses-${NCURSES_VERSION}
[ -f "${METADATAMIPS64ELROOTFS}/ncurses_patch" ] || \
  patch -Np1 -i ${PATCH}/ncurses-5.9-bash_fix-1.patch || \
    die "***patch ncurses error" && \
      touch ${METADATAMIPS64ELROOTFS}/ncurses_patch
popd

pushd ${BUILDMIPS64ELROOTFS}
[ -d ncurses-build ] || mkdir ncurses-build
cd ncurses-build
[ -f "${METADATAMIPS64ELROOTFS}/ncurses_config" ] || \
  ${SRCMIPS64ELROOTFS}/ncurses-${NCURSES_VERSION}/configure \
  --prefix=${PREFIXMIPS64ELROOTFS}/cross-tools \
  --without-debug --without-shared || \
    die "***config ncurses error" && \
      touch ${METADATAMIPS64ELROOTFS}/ncurses_config
[ -f "${METADATAMIPS64ELROOTFS}/ncurses_build" ] || \
  make -C include || \
    die "***build ncurses include error" && \
      touch ${METADATAMIPS64ELROOTFS}/ncurses_build
[ -f "${METADATAMIPS64ELROOTFS}/ncurses_build_progs-tic" ] || \
  make -C progs tic || \
    die "***build ncurses tic error" && \
      touch ${METADATAMIPS64ELROOTFS}/ncurses_build_progs-tic
[ -f "${METADATAMIPS64ELROOTFS}/ncurses_install" ] || \
  install -m755 progs/tic ${PREFIXMIPS64ELROOTFS}/cross-tools/bin || \
    die "***install ncurses error" && \
      touch ${METADATAMIPS64ELROOTFS}/ncurses_install
popd

pushd ${BUILDMIPS64ELROOTFS}
[ -d "python-build" ] || mkdir python-build
cd python-build
[ -f "${METADATAMIPS64ELROOTFS}/python_config" ] || \
  ${SRCMIPS64ELROOTFS}/Python-${PYTHON_VERSION}/configure \
  --prefix=${PREFIXMIPS64ELROOTFS}/cross-tools || \
    die "***config python error" && \
      touch ${METADATAMIPS64ELROOTFS}/python_config
[ -f "${METADATAMIPS64ELROOTFS}/python_build" ] || \
  make -j${JOBS} || \
    die "***build python error" && \
      touch ${METADATAMIPS64ELROOTFS}/python_build
[ -f "${METADATAMIPS64ELROOTFS}/python_install" ] || \
  make install || \
    die "***install python error" && \
      touch ${METADATAMIPS64ELROOTFS}/python_install
popd


########################### Begin Cross Compile File System ####################
export CC="${CROSS_TARGET64}-gcc"
export CXX="${CROSS_TARGET64}-g++"
export AR="${CROSS_TARGET64}-ar"
export AS="${CROSS_TARGET64}-as"
export RANLIB="${CROSS_TARGET64}-ranlib"
export LD="${CROSS_TARGET64}-ld"
export STRIP="${CROSS_TARGET64}-strip"

pushd ${BUILDMIPS64ELROOTFS}
cd man-pages-${MANPAGES_VERSION}
[ -f "${METADATAMIPS64ELROOTFS}/man_cross_build" ] || \
  make CC="${CC} ${BUILD64}" prefix=${PREFIXMIPS64ELROOTFS}/usr install || \
    die "***install man pages error" && \
      touch ${METADATAMIPS64ELROOTFS}/man_cross_build
popd

pushd ${BUILDMIPS64ELROOTFS}
[ -d "gmp-32" ] || mkdir "gmp-32"
cd gmp-32
[ -f "${METADATAMIPS64ELROOTFS}/gmp_config32" ] || \
  CPPFLAGS=-fexceptions CC="${CC} ${BUILD32}" CXX="${CXX} ${BUILD32}" ABI=o32 \
  LDFLAGS="-Wl,-rpath-link,${PREFIXMIPS64ELROOTFS}/usr/lib:${PREFIXMIPS64ELROOTFS}/lib ${BUILD32}" \
  ${SRCMIPS64ELROOTFS}/gmp-${GMP_VERSION}/configure --prefix=/usr \
  --build=${CROSS_HOST} --host=${CROSS_TARGET32} \
  --enable-cxx --enable-mpbsd || \
    die "***config gmp32 error" && \
      touch ${METADATAMIPS64ELROOTFS}/gmp_config32
[ -f "${METADATAMIPS64ELROOTFS}/gmp_build32" ] || \
  make -j${JOBS} || \
    die "***make gmp32 error" && \
      touch ${METADATAMIPS64ELROOTFS}/gmp_build32
[ -f "${METADATAMIPS64ELROOTFS}/gmp_install32" ] || \
  make DESTDIR=${PREFIXMIPS64ELROOTFS} install || \
    die "***install gmp32 error" && \
      touch ${METADATAMIPS64ELROOTFS}/gmp_install32
[ -f "${METADATAMIPS64ELROOTFS}/gmp_rm32_la" ] || \
  rm -v ${PREFIXMIPS64ELROOTFS}/usr/lib/lib{gmp,gmpxx,mp}.la || \
    die "rm gmp32 la files error" && \
      touch ${METADATAMIPS64ELROOTFS}/gmp_rm32_la
[ -f "${METADATAMIPS64ELROOTFS}/gmp_rename32_gmp_header" ] || \
  mv ${PREFIXMIPS64ELROOTFS}/usr/include/gmp{,-32}.h || \
    die "rename gmp32 headers error" && \
      touch ${METADATAMIPS64ELROOTFS}/gmp_rename32_gmp_header
popd

pushd ${BUILDMIPS64ELROOTFS}
[ -d "gmp-n32" ] || mkdir "gmp-n32"
cd gmp-n32
[ -f "${METADATAMIPS64ELROOTFS}/gmp_confign32" ] || \
  CPPFLAGS=-fexceptions \
  CC="${CC} ${BUILDN32}" CXX="${CXX} ${BUILDN32}" ABI=n32 \
  LDFLAGS="-Wl,-rpath-link,${PREFIXMIPS64ELROOTFS}/usr/lib32:${PREFIXMIPS64ELROOTFS}/lib32 ${BUILDN32}" \
  ${SRCMIPS64ELROOTFS}/gmp-${GMP_VERSION}/configure --prefix=/usr \
  --build=${CROSS_HOST} --host=${CROSS_TARGET64} --libdir=/usr/lib32 \
  --enable-cxx --enable-mpbsd || \
    die "***config gmpn32 error" && \
      touch ${METADATAMIPS64ELROOTFS}/gmp_confign32
[ -f "${METADATAMIPS64ELROOTFS}/gmp_buildn32" ] || \
  make -j${JOBS} || \
    die "***make gmpn32 error" && \
      touch ${METADATAMIPS64ELROOTFS}/gmp_buildn32
[ -f "${METADATAMIPS64ELROOTFS}/gmp_installn32" ] || \
  make DESTDIR=${PREFIXMIPS64ELROOTFS} install || \
    die "***install gmpn32 error" && \
      touch ${METADATAMIPS64ELROOTFS}/gmp_installn32
[ -f "${METADATAMIPS64ELROOTFS}/gmp_rmn32_la" ] || \
  rm -v ${PREFIXMIPS64ELROOTFS}/usr/lib32/lib{gmp,gmpxx,mp}.la || \
    die "rm gmpn32 la files error" && \
      touch ${METADATAMIPS64ELROOTFS}/gmp_rmn32_la
[ -f "${METADATAMIPS64ELROOTFS}/gmp_renamen32_gmp_header" ] || \
  mv -v ${PREFIXMIPS64ELROOTFS}/usr/include/gmp{,-n32}.h || \
    die "rename gmpn32 headers error" && \
      touch ${METADATAMIPS64ELROOTFS}/gmp_renamen32_gmp_header
popd

pushd ${BUILDMIPS64ELROOTFS}
[ -d "gmp-64" ] || mkdir "gmp-64"
cd gmp-64
[ -f "${METADATAMIPS64ELROOTFS}/gmp_config64" ] || \
  CPPFLAGS=-fexceptions \
  CC="${CC} ${BUILD64}" CXX="${CXX} ${BUILD64}" \
  LDFLAGS="-Wl,-rpath-link,${PREFIXMIPS64ELROOTFS}/usr/lib64:${PREFIXMIPS64ELROOTFS}/lib64 ${BUILD64}" \
  ${SRCMIPS64ELROOTFS}/gmp-${GMP_VERSION}/configure --prefix=/usr \
  --build=${CROSS_HOST} --host=${CROSS_TARGET64} --libdir=/usr/lib64 \
  --enable-cxx --enable-mpbsd || \
    die "***config gmp64 error" && \
      touch ${METADATAMIPS64ELROOTFS}/gmp_config64
[ -f "${METADATAMIPS64ELROOTFS}/gmp_build64" ] || \
  make -j${JOBS} || \
    die "***make gmp64 error" && \
      touch ${METADATAMIPS64ELROOTFS}/gmp_build64
[ -f "${METADATAMIPS64ELROOTFS}/gmp_install64" ] || \
  make DESTDIR=${PREFIXMIPS64ELROOTFS} install || \
    die "***install gmp64 error" && \
      touch ${METADATAMIPS64ELROOTFS}/gmp_install64
[ -f "${METADATAMIPS64ELROOTFS}/gmp_rm64_la" ] || \
  rm -v ${PREFIXMIPS64ELROOTFS}/usr/lib64/lib{gmp,gmpxx,mp}.la || \
    die "rm gmp64 la files error" && \
      touch ${METADATAMIPS64ELROOTFS}/gmp_rm64_la
[ -f "${METADATAMIPS64ELROOTFS}/gmp_rename64_header" ] || \
  mv -v ${PREFIXMIPS64ELROOTFS}/usr/include/gmp{,-64}.h || \
    die "rename gmp64 headers" && \
      touch ${METADATAMIPS64ELROOTFS}/gmp_rename64_header
popd

# FIXME --with-gmp-include=${PREFIXMIPS64ELROOTFS}/cross-tools/include is unreasonable
pushd ${BUILDMIPS64ELROOTFS}
[ -d "mpfr-32" ] || mkdir mpfr-32
cd mpfr-32
[ -f "${METADATAMIPS64ELROOTFS}/mpfr_config32" ] || \
  CC="${CC} ${BUILD32}" \
  LDFLAGS="-Wl,-rpath-link,${PREFIXMIPS64ELROOTFS}/usr/lib:${PREFIXMIPS64ELROOTFS}/lib ${BUILD32}" \
  ${SRCMIPS64ELROOTFS}/mpfr-${MPFR_VERSION}/configure --prefix=/usr --enable-shared \
  --build=${CROSS_HOST} --host=${CROSS_TARGET32} \
  --with-gmp-include=${PREFIXMIPS64ELROOTFS}/cross-tools/include \
  --with-gmp-lib=${PREFIXMIPS64ELROOTFS}/usr/lib || \
    die "***config mpfr32 error" && \
      touch ${METADATAMIPS64ELROOTFS}/mpfr_config32
[ -f "${METADATAMIPS64ELROOTFS}/mpfr_build32" ] || \
  make -j${JOBS} || \
    die "***build mpfr32 error" && \
      touch ${METADATAMIPS64ELROOTFS}/mpfr_build32
[ -f "${METADATAMIPS64ELROOTFS}/mpfr_install32" ] || \
  make DESTDIR=${PREFIXMIPS64ELROOTFS} install || \
    die "***install mpfr32 error" && \
      touch ${METADATAMIPS64ELROOTFS}/mpfr_install32
[ -f "${METADATAMIPS64ELROOTFS}/mpfr_rm32_la" ] || \
  rm -v ${PREFIXMIPS64ELROOTFS}/usr/lib/libmpfr.la || \
    die "rm mpfr32 la files error" && \
      touch ${METADATAMIPS64ELROOTFS}/mpfr_rm32_la
popd

# FIXME --with-gmp-include=${PREFIXMIPS64ELROOTFS}/cross-tools/include is unreasonable
pushd ${BUILDMIPS64ELROOTFS}
[ -d "mpfr-n32" ] || mkdir mpfr-n32
cd mpfr-n32
[ -f "${METADATAMIPS64ELROOTFS}/mpfr_confign32" ] || \
  CC="${CC} ${BUILDN32}" \
  LDFLAGS="-Wl,-rpath-link,${PREFIXMIPS64ELROOTFS}/usr/lib32:${PREFIXMIPS64ELROOTFS}/lib32 ${BUILDN32}" \
  ${SRCMIPS64ELROOTFS}/mpfr-${MPFR_VERSION}/configure --prefix=/usr --enable-shared \
  --build=${CROSS_HOST} --host=${CROSS_TARGET64} --libdir=/usr/lib32 \
  --with-gmp-include=${PREFIXMIPS64ELROOTFS}/cross-tools/include \
  --with-gmp-lib=${PREFIXMIPS64ELROOTFS}/usr/lib32 || \
    die "***config mpfrn32 error" && \
      touch ${METADATAMIPS64ELROOTFS}/mpfr_confign32
[ -f "${METADATAMIPS64ELROOTFS}/mpfr_buildn32" ] || \
  make -j${JOBS} || \
    die "***build mpfrn32 error" && \
      touch ${METADATAMIPS64ELROOTFS}/mpfr_buildn32
[ -f "${METADATAMIPS64ELROOTFS}/mpfr_installn32" ] || \
  make DESTDIR=${PREFIXMIPS64ELROOTFS} install || \
    die "***install mpfrn32 error" && \
      touch ${METADATAMIPS64ELROOTFS}/mpfr_installn32
[ -f "${METADATAMIPS64ELROOTFS}/mpfr_rmn32_la" ] || \
  rm -v ${PREFIXMIPS64ELROOTFS}/usr/lib32/libmpfr.la || \
    die "rm mpfrn32 la files error" && \
      touch ${METADATAMIPS64ELROOTFS}/mpfr_rmn32_la
popd

# FIXME --with-gmp-include=${PREFIXMIPS64ELROOTFS}/cross-tools/include is unreasonable
pushd ${BUILDMIPS64ELROOTFS}
[ -d "mpfr-64" ] || mkdir mpfr-64
cd mpfr-64
[ -f "${METADATAMIPS64ELROOTFS}/mpfr_config64" ] || \
  CC="${CC} ${BUILD64}" \
  LDFLAGS="-Wl,-rpath-link,${PREFIXMIPS64ELROOTFS}/usr/lib64:${PREFIXMIPS64ELROOTFS}/lib64 ${BUILD64}" \
  ${SRCMIPS64ELROOTFS}/mpfr-${MPFR_VERSION}/configure --prefix=/usr --enable-shared \
  --build=${CROSS_HOST} --host=${CROSS_TARGET64} --libdir=/usr/lib64 \
  --with-gmp-include=${PREFIXMIPS64ELROOTFS}/cross-tools/include \
  --with-gmp-lib=${PREFIXMIPS64ELROOTFS}/usr/lib64 || \
    die "***config mpfr64 error" && \
      touch ${METADATAMIPS64ELROOTFS}/mpfr_config64
[ -f "${METADATAMIPS64ELROOTFS}/mpfr_build64" ] || \
  make -j${JOBS} || \
    die "***build mpfr64 error" && \
      touch ${METADATAMIPS64ELROOTFS}/mpfr_build64
[ -f "${METADATAMIPS64ELROOTFS}/mpfr_install64" ] || \
  make DESTDIR=${PREFIXMIPS64ELROOTFS} install || \
    die "***install mpfr64 error" && \
      touch ${METADATAMIPS64ELROOTFS}/mpfr_install64
[ -f "${METADATAMIPS64ELROOTFS}/mpfr_rm64_la" ] || \
  rm -v ${PREFIXMIPS64ELROOTFS}/usr/lib64/libmpfr.la || \
    die "rm mpfr64 la files error" && \
      touch ${METADATAMIPS64ELROOTFS}/mpfr_rm64_la
popd

pushd ${BUILDMIPS64ELROOTFS}
[ -d mpc-32 ] || cp -ar ${SRCMIPS64ELROOTFS}/mpc-${MPC_VERSION} mpc-32
cd mpc-32
[ -f "${METADATAMIPS64ELROOTFS}/mpc_config32" ] || \
  CC="${CC} ${BUILD32}" CXX="${CXX} ${BUILD32}" \
  LDFLAGS="-Wl,-rpath-link,${PREFIXMIPS64ELROOTFS}/usr/lib:${PREFIXMIPS64ELROOTFS}/lib ${BUILD32}" \
  ./configure --prefix=/usr --enable-shared \
  --build=${CROSS_HOST} --host=${CROSS_TARGET32} \
  --with-gmp-include=${PREFIXMIPS64ELROOTFS}/cross-tools/include \
  --with-gmp-lib=${PREFIXMIPS64ELROOTFS}/usr/lib \
  --with-mpfr-include=${PREFIXMIPS64ELROOTFS}/cross-tools/include \
  --with-mpfr-lib=${PREFIXMIPS64ELROOTFS}/usr/lib || \
    die "***config mpc32 error" && \
      touch ${METADATAMIPS64ELROOTFS}/mpc_config32
[ -f "${METADATAMIPS64ELROOTFS}/mpc_build32" ] || \
  make -j${JOBS} || \
    die "***build mpc32 error" && \
      touch ${METADATAMIPS64ELROOTFS}/mpc_build32
[ -f "${METADATAMIPS64ELROOTFS}/mpc_install32" ] || \
  make DESTDIR=${PREFIXMIPS64ELROOTFS} install || \
    die "***install mpc32 error" && \
      touch ${METADATAMIPS64ELROOTFS}/mpc_install32
popd

pushd ${BUILDMIPS64ELROOTFS}
[ -d mpc-n32 ] || cp -ar ${SRCMIPS64ELROOTFS}/mpc-${MPC_VERSION} mpc-n32
cd mpc-n32
[ -f "${METADATAMIPS64ELROOTFS}/mpc_confign32" ] || \
  CC="${CC} ${BUILDN32}" \
  LDFLAGS="-Wl,-rpath-link,${PREFIXMIPS64ELROOTFS}/usr/lib32:${PREFIXMIPS64ELROOTFS}/lib32 ${BUILDN32}" \
  ./configure --prefix=/usr --enable-shared \
  --build=${CROSS_HOST} --host=${CROSS_TARGET64} --libdir=/usr/lib32 \
  --with-gmp-include=${PREFIXMIPS64ELROOTFS}/cross-tools/include \
  --with-gmp-lib=${PREFIXMIPS64ELROOTFS}/usr/lib32 \
  --with-mpfr-include=${PREFIXMIPS64ELROOTFS}/cross-tools/include \
  --with-mpfr-lib=${PREFIXMIPS64ELROOTFS}/usr/lib32 || \
    die "***config mpcn32 error" && \
      touch ${METADATAMIPS64ELROOTFS}/mpc_confign32
[ -f "${METADATAMIPS64ELROOTFS}/mpc_buildn32" ] || \
  make -j${JOBS} || \
    die "***build mpcn32 error" && \
      touch ${METADATAMIPS64ELROOTFS}/mpc_buildn32
[ -f "${METADATAMIPS64ELROOTFS}/mpc_installn32" ] || \
  make DESTDIR=${PREFIXMIPS64ELROOTFS} install || \
    die "***install mpcn32 error" && \
      touch ${METADATAMIPS64ELROOTFS}/mpc_installn32
popd

pushd ${BUILDMIPS64ELROOTFS}
[ -d mpc-64 ] || cp -ar ${SRCMIPS64ELROOTFS}/mpc-${MPC_VERSION} mpc-64
cd mpc-64
[ -f "${METADATAMIPS64ELROOTFS}/mpc_config64" ] || \
  CC="${CC} ${BUILD64}" \
  LDFLAGS="-Wl,-rpath-link,${PREFIXMIPS64ELROOTFS}/usr/lib64:${PREFIXMIPS64ELROOTFS}/lib64 ${BUILD64}" \
  ./configure --prefix=/usr --enable-shared \
  --build=${CROSS_HOST} --host=${CROSS_TARGET64} --libdir=/usr/lib64 \
  --with-gmp-include=${PREFIXMIPS64ELROOTFS}/cross-tools/include \
  --with-gmp-lib=${PREFIXMIPS64ELROOTFS}/usr/lib64 \
  --with-mpfr-include=${PREFIXMIPS64ELROOTFS}/cross-tools/include \
  --with-mpfr-lib=${PREFIXMIPS64ELROOTFS}/usr/lib64 || \
    die "***config mpc64 error" && \
      touch ${METADATAMIPS64ELROOTFS}/mpc_config64
[ -f "${METADATAMIPS64ELROOTFS}/mpc_build64" ] || \
  make -j${JOBS} || \
    die "***build mpc64 error" && \
      touch ${METADATAMIPS64ELROOTFS}/mpc_build64
[ -f "${METADATAMIPS64ELROOTFS}/mpc_install64" ] || \
  make DESTDIR=${PREFIXMIPS64ELROOTFS} install || \
    die "***install mpc64 error" && \
      touch ${METADATAMIPS64ELROOTFS}/mpc_install64
popd

pushd ${BUILDMIPS64ELROOTFS}
[ -d "ppl-32" ] || mkdir ppl-32
cd ppl-32
[ -f "${METADATAMIPS64ELROOTFS}/ppl_config32" ] || \
  CPPFLAGS="-fexceptions -I${PREFIXMIPS64ELROOTFS}/cross-tools/include" \
  CC="${CC} ${BUILD32}" CXX="${CXX} ${BUILD32}" \
  LDFLAGS="-Wl,-rpath-link,${PREFIXMIPS64ELROOTFS}/usr/lib:${PREFIXMIPS64ELROOTFS}/lib ${BUILD32}" \
  ${SRCMIPS64ELROOTFS}/ppl-${PPL_VERSION}/configure --prefix=/usr \
  --build=${CROSS_HOST} --host=${CROSS_TARGET32} \
  --with-libgmp-prefix=${PREFIXMIPS64ELROOTFS}/usr \
  --with-libgmpxx-prefix=${PREFIXMIPS64ELROOTFS}/usr \
  --enable-shared --disable-optimization \
  --enable-check=quick || \
    die "***config ppl32 error" && \
      touch ${METADATAMIPS64ELROOTFS}/ppl_config32
[ -f "${METADATAMIPS64ELROOTFS}/ppl_build32" ] || \
  make -j${JOBS} || \
    die "***build ppl32 error" && \
      touch ${METADATAMIPS64ELROOTFS}/ppl_build32
[ -f "${METADATAMIPS64ELROOTFS}/ppl_install32" ] || \
  make DESTDIR=${PREFIXMIPS64ELROOTFS} install || \
    die "***install ppl32 error" && \
      touch ${METADATAMIPS64ELROOTFS}/ppl_install32
rm -v ${PREFIXMIPS64ELROOTFS}/usr/lib/lib{ppl,ppl_c,pwl}.la
mv -v ${PREFIXMIPS64ELROOTFS}/usr/bin/ppl-config{,-32}
mv -v ${PREFIXMIPS64ELROOTFS}/usr/include/ppl{,-32}.hh
popd

pushd ${BUILDMIPS64ELROOTFS}
[ -d "ppl-n32" ] || mkdir ppl-n32
cd ppl-n32
[ -f "${METADATAMIPS64ELROOTFS}/ppl_confign32" ] || \
  CPPFLAGS="-fexceptions -I${PREFIXMIPS64ELROOTFS}/cross-tools/include" \
  CC="${CC} ${BUILDN32}" CXX="${CXX} ${BUILDN32}" \
  LDFLAGS="-Wl,-rpath-link,${PREFIXMIPS64ELROOTFS}/usr/lib32:${PREFIXMIPS64ELROOTFS}/lib32 ${BUILDN32}" \
  ${SRCMIPS64ELROOTFS}/ppl-${PPL_VERSION}/configure --prefix=/usr --libdir=/usr/lib32 \
  --build=${CROSS_HOST} --host=${CROSS_TARGET64} \
  --with-libgmp-prefix=${PREFIXMIPS64ELROOTFS}/usr \
  --with-libgmpxx-prefix=${PREFIXMIPS64ELROOTFS}/usr \
  --enable-shared --disable-optimization \
  --enable-check=quick --libdir=/usr/lib32 || \
    die "***config ppl-n32 error" && \
      touch ${METADATAMIPS64ELROOTFS}/ppl_confign32
[ -f "${METADATAMIPS64ELROOTFS}/ppl_buildn32" ] || \
  make -j${JOBS} || \
    die "***build ppln32 error" && \
      touch ${METADATAMIPS64ELROOTFS}/ppl_buildn32
[ -f "${METADATAMIPS64ELROOTFS}/ppl_installn32" ] || \
  make DESTDIR=${PREFIXMIPS64ELROOTFS} install || \
    die "***install ppl-n32 error" && \
      touch ${METADATAMIPS64ELROOTFS}/ppl_installn32
rm -v ${PREFIXMIPS64ELROOTFS}/usr/lib32/lib{ppl,ppl_c,pwl}.la
mv -v ${PREFIXMIPS64ELROOTFS}/usr/bin/ppl-config{,-n32}
mv -v ${PREFIXMIPS64ELROOTFS}/usr/include/ppl{,-n32}.hh
popd

pushd ${BUILDMIPS64ELROOTFS}
[ -d "ppl-64" ] || mkdir ppl-64
cd ppl-64
[ -f "${METADATAMIPS64ELROOTFS}/ppl_config64" ] || \
  CPPFLAGS="-fexceptions -I${PREFIXMIPS64ELROOTFS}/cross-tools/include" \
  CC="${CC} ${BUILD64}" CXX="${CXX} ${BUILD64}" \
  LDFLAGS="-Wl,-rpath-link,${PREFIXMIPS64ELROOTFS}/usr/lib64:${PREFIXMIPS64ELROOTFS}/lib64 ${BUILD64}" \
  ${SRCMIPS64ELROOTFS}/ppl-${PPL_VERSION}/configure --prefix=/usr --libdir=/usr/lib64 \
  --build=${CROSS_HOST} --host=${CROSS_TARGET64} \
  --with-libgmp-prefix=${PREFIXMIPS64ELROOTFS}/usr \
  --with-libgmpxx-prefix=${PREFIXMIPS64ELROOTFS}/usr \
  --enable-shared --disable-optimization \
  --enable-check=quick --libdir=/usr/lib64 || \
    die "***config ppl64 error" && \
      touch ${METADATAMIPS64ELROOTFS}/ppl_config64
[ -f "${METADATAMIPS64ELROOTFS}/ppl_build64" ] || \
  make -j${JOBS} || \
    die "***build ppl64 error" && \
      touch ${METADATAMIPS64ELROOTFS}/ppl_build64
[ -f "${METADATAMIPS64ELROOTFS}/ppl_install64" ] || \
  make DESTDIR=${PREFIXMIPS64ELROOTFS} install || \
    die "***install ppl64 error" && \
      touch ${METADATAMIPS64ELROOTFS}/ppl_install64
rm -v ${PREFIXMIPS64ELROOTFS}/usr/lib/lib{ppl,ppl_c,pwl}.la
mv -v ${PREFIXMIPS64ELROOTFS}/usr/bin/ppl-config{,-n32}
mv -v ${PREFIXMIPS64ELROOTFS}/usr/include/ppl{,-n32}.hh
popd

pushd ${BUILDMIPS64ELROOTFS}
[ -d cloog-32 ] || mkdir cloog-32
cd cloog-32
[ -f "${METADATAMIPS64ELROOTFS}/cloog_config32" ] || \
  CPPFLAGS="-fexceptions -I${PREFIXMIPS64ELROOTFS}/cross-tools/include" \
  LDFLAGS="-Wl,-rpath-link,${PREFIXMIPS64ELROOTFS}/usr/lib:${PREFIXMIPS64ELROOTFS}/lib ${BUILD32}" \
  CC="${CC} ${BUILD32}" ${SRCMIPS64ELROOTFS}/cloog-${CLOOG_VERSION}/configure \
  --build=${CROSS_HOST} --host=${CROSS_TARGET32} \
  --prefix=/usr --enable-shared --with-gmp --with-ppl || \
    die "config cloog32 error" && \
      touch ${METADATAMIPS64ELROOTFS}/cloog_config32
[ -f "${METADATAMIPS64ELROOTFS}/cloog_build32" ] || \
  make -j${JOBS} || \
    die "***build cloog32 error" && \
      touch ${METADATAMIPS64ELROOTFS}/cloog_build32
[ -f "${METADATAMIPS64ELROOTFS}/cloog_install32" ] || \
  make DESTDIR=${PREFIXMIPS64ELROOTFS} install || \
    die "***install cloog32 error" && \
      touch ${METADATAMIPS64ELROOTFS}/cloog_install32
#[ -f "${METADATAMIPS64ELROOTFS}/cloog_rm32_la" ] || \
#  rm -v ${PREFIXMIPS64ELROOTFS}/usr/lib/libcloog.la || \
#    die "rm cloog32 la files error" && \
#      touch ${METADATAMIPS64ELROOTFS}/cloog_rm32_la
popd

pushd ${BUILDMIPS64ELROOTFS}
[ -d cloog-n32 ] || mkdir cloog-n32
cd cloog-n32
[ -f "${METADATAMIPS64ELROOTFS}/cloog_confign32" ] || \
  CPPFLAGS="-fexceptions -I${PREFIXMIPS64ELROOTFS}/cross-tools/include" \
  LDFLAGS="-Wl,-rpath-link,${PREFIXMIPS64ELROOTFS}/usr/lib32:${PREFIXMIPS64ELROOTFS}/lib32 ${BUILDN32}" \
  CC="${CC} ${BUILDN32}" ${SRCMIPS64ELROOTFS}/cloog-${CLOOG_VERSION}/configure \
  --build=${CROSS_HOST} --host=${CROSS_TARGET64} --libdir=/usr/lib32 \
  --prefix=/usr --enable-shared --with-gmp --with-ppl || \
    die "config cloogn32 error" && \
      touch ${METADATAMIPS64ELROOTFS}/cloog_confign32
[ -f "${METADATAMIPS64ELROOTFS}/cloog_buildn32" ] || \
  make -j${JOBS} || \
    die "***build cloogn32 error" && \
      touch ${METADATAMIPS64ELROOTFS}/cloog_buildn32
[ -f "${METADATAMIPS64ELROOTFS}/cloog_installn32" ] || \
  make DESTDIR=${PREFIXMIPS64ELROOTFS} install || \
    die "***install cloog error" && \
      touch ${METADATAMIPS64ELROOTFS}/cloog_installn32
#[ -f "${METADATAMIPS64ELROOTFS}/cloog_rmn32_la" ] || \
#  rm -v ${PREFIXMIPS64ELROOTFS}/usr/lib32/libcloog.la || \
#    die "rm cloogn32 files error" && \
#      touch ${METADATAMIPS64ELROOTFS}/cloog_rmn32_la
popd

pushd ${BUILDMIPS64ELROOTFS}
[ -d cloog-64 ] || mkdir cloog-64
cd cloog-64
[ -f "${METADATAMIPS64ELROOTFS}/cloog_config64" ] || \
[ -f "config.log" ] || CPPFLAGS="-fexceptions -I${PREFIXMIPS64ELROOTFS}/cross-tools/include" \
  LDFLAGS="-Wl,-rpath-link,${PREFIXMIPS64ELROOTFS}/usr/lib64:${PREFIXMIPS64ELROOTFS}/lib64 ${BUILD64}" \
  CC="${CC} ${BUILD64}" ${SRCMIPS64ELROOTFS}/cloog-${CLOOG_VERSION}/configure \
  --build=${CROSS_HOST} --host=${CROSS_TARGET64} --libdir=/usr/lib64 \
  --prefix=/usr --enable-shared --with-gmp --with-ppl || \
    die "config cloog64 error" && \
      touch ${METADATAMIPS64ELROOTFS}/cloog_config64
[ -f "${METADATAMIPS64ELROOTFS}/cloog_build64" ] || \
  make -j${JOBS} || \
    die "***build cloog64 error" && \
      touch ${METADATAMIPS64ELROOTFS}/cloog_build64
[ -f "${METADATAMIPS64ELROOTFS}/cloog_install64" ] || \
  make DESTDIR=${PREFIXMIPS64ELROOTFS} install || \
    die "***install cloog64 error" && \
      touch ${METADATAMIPS64ELROOTFS}/cloog_install64
#[ -f "${METADATAMIPS64ELROOTFS}/cloog_rm64_la" ] || \
#  rm -v ${PREFIXMIPS64ELROOTFS}/usr/lib64/libcloog.la || \
#    die "rm cloog64 files error" && \
#      touch ${METADATAMIPS64ELROOTFS}/cloog_rm64_la
popd

pushd ${BUILDMIPS64ELROOTFS}
[ -d "zlib-32" ] || cp -ar ${SRCMIPS64ELROOTFS}/zlib-${ZLIB_VERSION} zlib-32
cd zlib-32
[ -f "${METADATAMIPS64ELROOTFS}/zlib_config32" ] || \
  CC="${CC} ${BUILD32}" CXX="${CXX} ${BUILD32}" \
  LDFLAGS="-Wl,-rpath-link,${PREFIXMIPS64ELROOTFS}/usr/lib:${PREFIXMIPS64ELROOTFS}/lib ${BUILD32}" \
  ./configure --prefix=/usr --shared || \
    die "***config zlib32 error" && \
      touch ${METADATAMIPS64ELROOTFS}/zlib_config32
[ -f "${METADATAMIPS64ELROOTFS}/zlib_build32" ] || \
  make -j${JOBS} || \
    die "***build zlib32 error" && \
      touch ${METADATAMIPS64ELROOTFS}/zlib_build32
[ -f "${METADATAMIPS64ELROOTFS}/zlib_install32" ] || \
  make install DESTDIR=${PREFIXMIPS64ELROOTFS} || \
    die "***install zlib32 error" && \
      touch ${METADATAMIPS64ELROOTFS}/zlib_install32
[ -f "${METADATAMIPS64ELROOTFS}/zlib_update32_files" ] || \
  mv -v ${PREFIXMIPS64ELROOTFS}/usr/lib/libz.so.* ${PREFIXMIPS64ELROOTFS}/lib && \
  ln -sfv ../../lib/libz.so.1 ${PREFIXMIPS64ELROOTFS}/usr/lib/libz.so && \
  chmod -v 644 ${PREFIXMIPS64ELROOTFS}/usr/lib/libz.a || \
    die "update zlib32 files error" && \
      touch ${METADATAMIPS64ELROOTFS}/zlib_update32_files
popd

pushd ${BUILDMIPS64ELROOTFS}
[ -d "zlib-n32" ] || cp -ar ${SRCMIPS64ELROOTFS}/zlib-${ZLIB_VERSION} zlib-n32
cd zlib-n32
[ -f "${METADATAMIPS64ELROOTFS}/zlib_confign32" ] || \
  CC="${CC} ${BUILDN32}" CXX="${CXX} ${BUILDN32}" \
  LDFLAGS="-Wl,-rpath-link,${PREFIXMIPS64ELROOTFS}/usr/lib32:${PREFIXMIPS64ELROOTFS}/lib32 ${BUILDN32}" \
  ./configure --prefix=/usr --shared --libdir=/usr/lib32 || \
    die "***config zlibn32 error" && \
      touch ${METADATAMIPS64ELROOTFS}/zlib_confign32
[ -f "${METADATAMIPS64ELROOTFS}/zlib_buildn32" ] || \
  make -j${JOBS} || \
    die "***build zlibn32 error" && \
      touch ${METADATAMIPS64ELROOTFS}/zlib_buildn32
[ -f "${METADATAMIPS64ELROOTFS}/zlib_installn32" ] || \
  make install DESTDIR=${PREFIXMIPS64ELROOTFS} || \
    die "***install zlibn32 error" && \
      touch ${METADATAMIPS64ELROOTFS}/zlib_installn32
[ -f "${METADATAMIPS64ELROOTFS}/zlib_updaten32_files" ] || \
  mv -v ${PREFIXMIPS64ELROOTFS}/usr/lib32/libz.so.* ${PREFIXMIPS64ELROOTFS}/lib32 && \
  ln -sfv ../../lib32/libz.so.1 ${PREFIXMIPS64ELROOTFS}/usr/lib32/libz.so && \
  chmod -v 644 ${PREFIXMIPS64ELROOTFS}/usr/lib32/libz.a || \
    die "update zlibn32 files error" && \
      touch ${METADATAMIPS64ELROOTFS}/zlib_updaten32_files
popd

pushd ${BUILDMIPS64ELROOTFS}
[ -d "zlib-64" ] || cp -ar ${SRCMIPS64ELROOTFS}/zlib-${ZLIB_VERSION} zlib-64
cd zlib-64
[ -f "${METADATAMIPS64ELROOTFS}/zlib_config64" ] || \
  CC="${CC} ${BUILD64}" CXX="${CXX} ${BUILD64}" \
  LDFLAGS="-Wl,-rpath-link,${PREFIXMIPS64ELROOTFS}/usr/lib64:${PREFIXMIPS64ELROOTFS}/lib64 ${BUILD64}" \
  ./configure --prefix=/usr --shared --libdir=/usr/lib64 || \
    die "***config zlib64 error" && \
      touch ${METADATAMIPS64ELROOTFS}/zlib_config64
[ -f "${METADATAMIPS64ELROOTFS}/zlib_build64" ] || \
  make -j${JOBS} || \
    die "***build zlib64 error" && \
      touch ${METADATAMIPS64ELROOTFS}/zlib_build64
[ -f "${METADATAMIPS64ELROOTFS}/zlib_install64" ] || \
  make install DESTDIR=${PREFIXMIPS64ELROOTFS} || \
    die "***install zlib64 error" && \
      touch ${METADATAMIPS64ELROOTFS}/zlib_install64
[ -f "${METADATAMIPS64ELROOTFS}/zlib_update64_files" ] || \
  mv -v ${PREFIXMIPS64ELROOTFS}/usr/lib64/libz.so.* ${PREFIXMIPS64ELROOTFS}/lib64 && \
  ln -sfv ../../lib64/libz.so.1 ${PREFIXMIPS64ELROOTFS}/usr/lib64/libz.so && \
  chmod -v 644 ${PREFIXMIPS64ELROOTFS}/usr/lib64/libz.a || \
    die "update zlib64 files error" && \
      touch ${METADATAMIPS64ELROOTFS}/zlib_update64_files
popd

#pushd ${SRCMIPS64ELROOTFS}
#[ -d "expat-${EXPAT_VERSION}" ] \
#  || tar xf ${TARBALL}/expat-${EXPAT_VERSION}.${EXPAT_SUFFIX}
#cd expat-${EXPAT_VERSION}
#[ -f "config.log" ] || ./configure --prefix=/usr \
#  --build=${CROSS_HOST} --host=${CROSS_TARGET64} \
#  --target=${CROSS_TARGET64} \
#  || die "***config expat error"
#make -j${JOBS} || die "***build expat error"
#make prefix=${PREFIXMIPS64ELROOTFS}/usr install || die "***install expat error"
#popd
#
#pushd ${SRCMIPS64ELROOTFS}
#[ -d "dbus-${DBUS_VERSION}" ] \
#  || tar xf ${TARBALL}/dbus-${DBUS_VERSION}.${DBUS_SUFFIX}
#cd dbus-${DBUS_VERSION}
#[ -f "config.log" ] || ./configure --prefix=/usr \
#  --build=${CROSS_HOST} --host=${CROSS_TARGET64} \
#  --target=${CROSS_TARGET64} \
#  || die "***config dbus error"
#make -j${JOBS} || die "***build dbus error"
#make DESTDIR=${PREFIXMIPS64ELROOTFS} install || die "***install dbus error"
#popd
#
#pushd ${SRCMIPS64ELROOTFS}
#[ -d "glib-${GLIB_VERSION}" ] \
#  || tar xf ${TARBALL}/glib-${GLIB_VERSION}.${GLIB_SUFFIX}
#cd glib-${GLIB_VERSION}
#cat > config.cache << EOF
#glib_cv_stack_grows=false
#glib_cv_uscore=false
#ac_cv_func_posix_getpwuid_r=false
#ac_cv_func_posix_getgrgid_r=false
#EOF
#[ -f "config.log" ] || \
#  ./configure --prefix=/usr \
#  --build=${CROSS_HOST} --host=${CROSS_TARGET64} \
#  --target=${CROSS_TARGET64} --sysconfdir=/etc \
#  --cache-file=config.cache --enable-debug=no \
#  || die "***config glib error"
#make -j${JOBS} || die "***build glib error"
#make DESTDIR=${PREFIXMIPS64ELROOTFS} install || die "***install glib error"
#popd
#
pushd ${BUILDMIPS64ELROOTFS}
[ -d "binutils-cross-build" ] || mkdir binutils-cross-build
cd binutils-cross-build
[ -f "${METADATAMIPS64ELROOTFS}/binutils_cross_config" ] || \
  CC="${CC} ${BUILD64}" \
  LDFLAGS="-Wl,-rpath-link,${PREFIXMIPS64ELROOTFS}/usr/lib64:${PREFIXMIPS64ELROOTFS}/lib64:${PREFIXMIPS64ELROOTFS}/usr/lib32:${PREFIXMIPS64ELROOTFS}/lib32:${PREFIXMIPS64ELROOTFS}/usr/lib:${PREFIXMIPS64ELROOTFS}/lib ${BUILD64}" \
  ${SRCMIPS64ELROOTFS}/binutils-${BINUTILS_VERSION}/configure --prefix=/usr \
  --build=${CROSS_HOST} --host=${CROSS_TARGET64} \
  --target=${CROSS_TARGET64} --enable-shared --enable-64-bit-bfd \
  --libdir=/usr/lib64 || \
    die "***config file error" && \
      touch ${METADATAMIPS64ELROOTFS}/binutils_cross_config
[ -f "${METADATAMIPS64ELROOTFS}/binutils_cross_configure_host" ] || \
  make configure-host || \
    die "config binutils host error" && \
      touch ${METADATAMIPS64ELROOTFS}/binutils_cross_configure_host
[ -f "${METADATAMIPS64ELROOTFS}/binutils_cross_build" ] || \
  make tooldir=/usr || \
    die "***build binutils error" && \
      touch ${METADATAMIPS64ELROOTFS}/binutils_cross_build
[ -f "${METADATAMIPS64ELROOTFS}/binutils_cross_install" ] || \
  make DESTDIR=${PREFIXMIPS64ELROOTFS} tooldir=/usr install || \
    die "***install binutils error" && \
      touch ${METADATAMIPS64ELROOTFS}/binutils_cross_install
[ -f "${METADATAMIPS64ELROOTFS}/binutils_cross_copy_libiberty" ] || \
  cp -v ${SRCMIPS64ELROOTFS}/binutils-${BINUTILS_VERSION}/include/libiberty.h \
        ${PREFIXMIPS64ELROOTFS}/usr/include || \
    die "copy binutils libiberty error" && \
      touch ${METADATAMIPS64ELROOTFS}/binutils_cross_copy_libiberty
popd

pushd ${SRCMIPS64ELROOTFS}/gcc-${GCC_VERSION}
[ -f "${METADATAMIPS64ELROOTFS}/gcc_cross_update_files" ] || \
  cp libiberty/Makefile.in{,.orig} && \
  sed 's/install_to_$(INSTALL_DEST) //' libiberty/Makefile.in.orig > \
  libiberty/Makefile.in && \
#  cp gcc/gccbug.in{,.orig} && \
#  sed 's/@have_mktemp_command@/yes/' gcc/gccbug.in.orig > gcc/gccbug.in && \
  cp gcc/Makefile.in{,.orig} && \
  sed 's@\./fixinc\.sh@-c true@' gcc/Makefile.in.orig > gcc/Makefile.in || \
    die "gcc update files error" && \
      touch ${METADATAMIPS64ELROOTFS}/gcc_cross_update_files
popd

pushd ${BUILDMIPS64ELROOTFS}
[ -d "gcc-cross-build" ] || mkdir gcc-cross-build
cd gcc-cross-build
[ -f "${METADATAMIPS64ELROOTFS}/gcc_cross_config" ] || \
  CC="${CC} ${BUILD64}" CXX="${CXX} ${BUILD64}" \
  LDFLAGS="-Wl,-rpath-link,${PREFIXMIPS64ELROOTFS}/usr/lib64:${PREFIXMIPS64ELROOTFS}/lib64:${PREFIXMIPS64ELROOTFS}/usr/lib32:${PREFIXMIPS64ELROOTFS}/lib32:${PREFIXMIPS64ELROOTFS}/usr/lib:${PREFIXMIPS64ELROOTFS}/lib" \
  ${SRCMIPS64ELROOTFS}/gcc-${GCC_VERSION}/configure --prefix=/usr --libexecdir=/usr/lib \
  --build=${CROSS_HOST} --host=${CROSS_TARGET64} --target=${CROSS_TARGET64} \
  --enable-shared --enable-threads=posix --enable-__cxa_atexit \
  --enable-c99 --enable-long-long --enable-clocale=gnu --with-abi=64 \
  --enable-languages=c,c++ --disable-libstdcxx-pch --libdir=/usr/lib64 \
  --with-gmp-include=${PREFIXMIPS64ELROOTFS}/cross-tools/include \
  --with-gmp-lib=${PREFIXMIPS64ELROOTFS}/usr/lib64 \
  --with-mpfr-include=${PREFIXMIPS64ELROOTFS}/cross-tools/include \
  --with-mpfr-lib=${PREFIXMIPS64ELROOTFS}/usr/lib64 \
  --enable-cloog-backend=isl || \
    die "***configure gcc error" && \
      touch ${METADATAMIPS64ELROOTFS}/gcc_cross_config
[ -f "${METADATAMIPS64ELROOTFS}/gcc_cross_update_Makefile" ] || \
  `cp Makefile{,.orig} && \
  sed "/^HOST_\(GMP\|PPL\|CLOOG\)\(LIBS\|INC\)/s:-[IL]/\(lib\|include\)::" \
      Makefile.orig > Makefile` || \
    die "gcc cross update Makefile error" && \
      touch ${METADATAMIPS64ELROOTFS}/gcc_cross_update_Makefile
[ -f "${METADATAMIPS64ELROOTFS}/gcc_cross_build" ] || \
  make -j${JOBS} || \
    die "***build gcc error" && \
      touch ${METADATAMIPS64ELROOTFS}/gcc_cross_build
[ -f "${METADATAMIPS64ELROOTFS}/gcc_cross_install" ] || \
  make DESTDIR=${PREFIXMIPS64ELROOTFS} install || \
    die "***install gcc error" && \
      touch ${METADATAMIPS64ELROOTFS}/gcc_cross_install
[ -f "${METADATAMIPS64ELROOTFS}/gcc_cross_ln_lib.gcc" ] || \
  ln -sfv ../usr/bin/cpp ${PREFIXMIPS64ELROOTFS}/lib && \
  ln -sfv gcc ${PREFIXMIPS64ELROOTFS}/usr/bin/cc || \
    die "link gcc lib/gcc error" && \
      touch ${METADATAMIPS64ELROOTFS}/gcc_cross_ln_lib.gcc
popd

pushd ${BUILDMIPS64ELROOTFS}
[ -d "sed-cross-build" ] || mkdir "sed-cross-build"
cd sed-cross-build
[ -f "${METADATAMIPS64ELROOTFS}/sed_cross_config" ] || \
  CC="${CC} ${BUILD64}" ${SRCMIPS64ELROOTFS}/sed-${SED_VERSION}/configure \
  --build=${CROSS_HOST} --host=${CROSS_TARGET64} \
  --prefix=/usr --bindir=/bin || \
    die "***config sed error" && \
      touch ${METADATAMIPS64ELROOTFS}/sed_cross_config
[ -f "${METADATAMIPS64ELROOTFS}/sed_cross_build" ] || \
  make -j${JOBS} || \
    die "***build sed error" && \
      touch ${METADATAMIPS64ELROOTFS}/sed_cross_build
[ -f "${METADATAMIPS64ELROOTFS}/sed_cross_html_build" ] || \
  make html || \
    die "***build sed html error" && \
      touch ${METADATAMIPS64ELROOTFS}/sed_cross_html_build
[ -f "${METADATAMIPS64ELROOTFS}/sed_cross_install" ] || \
  make DESTDIR=${PREFIXMIPS64ELROOTFS} install || \
    die "***install sed error" && \
      touch ${METADATAMIPS64ELROOTFS}/sed_cross_install
[ -f "${METADATAMIPS64ELROOTFS}/sed_cross_html_install" ] || \
  make -C doc DESTDIR=${PREFIXMIPS64ELROOTFS} install-html || \
    die "***install sed html error" && \
      touch ${METADATAMIPS64ELROOTFS}/sed_cross_html_install
popd

pushd ${BUILDMIPS64ELROOTFS}
[ -d "ncurses-32" ] || mkdir ncurses-32
cd ncurses-32
[ -f "${METADATAMIPS64ELROOTFS}/ncurses_config32" ] || \
  CC="${CC} ${BUILD32}" CXX="${CXX} ${BUILD32}" \
  ${SRCMIPS64ELROOTFS}/ncurses-${NCURSES_VERSION}/configure \
  --build=${CROSS_HOST} --host=${CROSS_TARGET32} \
  --prefix=/usr --libdir=/lib --with-shared \
  --enable-widec --without-debug --without-ada \
  --with-manpage-format=normal \
  --with-default-terminfo-dir=/usr/share/terminfo || \
    die "***config ncurses32 error" && \
      touch ${METADATAMIPS64ELROOTFS}/ncurses_config32
[ -f "${METADATAMIPS64ELROOTFS}/ncurses_build32" ] || \
  make -j${JOBS} || \
    die "***build ncurses32 error" && \
      touch ${METADATAMIPS64ELROOTFS}/ncurses_build32
[ -f "${METADATAMIPS64ELROOTFS}/ncurses_install32" ] || \
  make DESTDIR=${PREFIXMIPS64ELROOTFS} install || \
    die "***install ncurses32 error" && \
      touch ${METADATAMIPS64ELROOTFS}/ncurses_install32
mv -v ${PREFIXMIPS64ELROOTFS}/usr/bin/ncursesw5-config{,-32}
mv -v ${PREFIXMIPS64ELROOTFS}/lib/lib{panelw,menuw,formw,ncursesw,ncurses++w}.a \
      ${PREFIXMIPS64ELROOTFS}/usr/lib
rm -v /lib/lib{ncursesw,menuw,panelw,formw}.so
ln -svf ../../lib/libncursesw.so.5 ${PREFIXMIPS64ELROOTFS}/usr/lib/libncursesw.so
ln -svf ../../lib/libmenuw.so.5 ${PREFIXMIPS64ELROOTFS}/usr/lib/libmenuw.so
ln -svf ../../lib/libpanelw.so.5 ${PREFIXMIPS64ELROOTFS}/usr/lib/libpanelw.so
ln -svf ../../lib/libformw.so.5 ${PREFIXMIPS64ELROOTFS}/usr/lib/libformw.so
for lib in curses ncurses form panel menu ; do
  echo "INPUT(-l${lib}w)" > ${PREFIXMIPS64ELROOTFS}/usr/lib/lib${lib}.so;
  ln -sfv lib${lib}w.a ${PREFIXMIPS64ELROOTFS}/usr/lib/lib${lib}.a;
done
ln -sfv libcurses.so ${PREFIXMIPS64ELROOTFS}/usr/lib/libcursesw.so
ln -sfv libncurses.so ${PREFIXMIPS64ELROOTFS}/usr/lib/libcurses.so
ln -sfv libncursesw.a ${PREFIXMIPS64ELROOTFS}/usr/lib/libcursesw.a
ln -sfv libncurses.a ${PREFIXMIPS64ELROOTFS}/usr/lib/libcurses.a
ln -sfv libncurses++w.a ${PREFIXMIPS64ELROOTFS}/usr/lib/libncurses++.a
ln -sfv ncursesw5-config-32 ${PREFIXMIPS64ELROOTFS}/usr/bin/ncurses5-config-32
ln -sfv ../share/terminfo ${PREFIXMIPS64ELROOTFS}/usr/lib/terminfo
popd

pushd ${BUILDMIPS64ELROOTFS}
[ -d "ncurses-n32" ] || mkdir ncurses-n32
cd ncurses-n32
[ -f "${METADATAMIPS64ELROOTFS}/ncurses_confign32" ] || \
  CC="${CC} ${BUILDN32}" CXX="${CXX} ${BUILDN32}" \
  ${SRCMIPS64ELROOTFS}/ncurses-${NCURSES_VERSION}/configure \
  --build=${CROSS_HOST} --host=${CROSS_TARGET64} \
  --prefix=/usr --libdir=/lib32 --with-shared \
  --enable-widec --without-debug --without-ada \
  --with-manpage-format=normal \
  --with-default-terminfo-dir=/usr/share/terminfo || \
    die "***config ncursesn32 error" && \
      touch ${METADATAMIPS64ELROOTFS}/ncurses_confign32
[ -f "${METADATAMIPS64ELROOTFS}/ncurses_buildn32" ] || \
make -j${JOBS} || \
  die "***build ncursesn32 error" && \
    touch ${METADATAMIPS64ELROOTFS}/ncurses_buildn32
[ -f "${METADATAMIPS64ELROOTFS}/ncurses_installn32" ] || \
make DESTDIR=${PREFIXMIPS64ELROOTFS} install || \
  die "***install ncursesn32 error" && \
    touch ${METADATAMIPS64ELROOTFS}/ncurses_installn32
mv -v ${PREFIXMIPS64ELROOTFS}/usr/bin/ncursesw5-config{,-n32}
mv -v ${PREFIXMIPS64ELROOTFS}/lib32/lib{panelw,menuw,formw,ncursesw,ncurses++w}.a \
  ${PREFIXMIPS64ELROOTFS}/usr/lib32
rm -v /lib32/lib{ncursesw,menuw,panelw,formw}.so
ln -svf ../../lib32/libncursesw.so.5 ${PREFIXMIPS64ELROOTFS}/usr/lib32/libncursesw.so
ln -svf ../../lib32/libmenuw.so.5 ${PREFIXMIPS64ELROOTFS}/usr/lib32/libmenuw.so
ln -svf ../../lib32/libpanelw.so.5 ${PREFIXMIPS64ELROOTFS}/usr/lib32/libpanelw.so
ln -svf ../../lib32/libformw.so.5 ${PREFIXMIPS64ELROOTFS}/usr/lib32/libformw.so
for lib in curses ncurses form panel menu ; do
  echo "INPUT(-l${lib}w)" > ${PREFIXMIPS64ELROOTFS}/usr/lib32/lib${lib}.so;
  ln -sfv lib${lib}w.a ${PREFIXMIPS64ELROOTFS}/usr/lib32/lib${lib}.a;
done
ln -sfv libcurses.so ${PREFIXMIPS64ELROOTFS}/usr/lib32/libcursesw.so
ln -sfv libncurses.so ${PREFIXMIPS64ELROOTFS}/usr/lib32/libcurses.so
ln -sfv libncursesw.a ${PREFIXMIPS64ELROOTFS}/usr/lib32/libcursesw.a
ln -sfv libncurses.a ${PREFIXMIPS64ELROOTFS}/usr/lib32/libcurses.a
ln -sfv libncurses++w.a ${PREFIXMIPS64ELROOTFS}/usr/lib32/libncurses++.a
ln -sfv ncursesw5-config-n32 ${PREFIXMIPS64ELROOTFS}/usr/bin/ncurses5-config-n32
ln -sfv ../share/terminfo ${PREFIXMIPS64ELROOTFS}/usr/lib32/terminfo
popd

pushd ${BUILDMIPS64ELROOTFS}
[ -d "ncurses-64" ] || mkdir ncurses-64
cd ncurses-64
[ -f "${METADATAMIPS64ELROOTFS}/ncurses_config64" ] || \
  CC="${CC} ${BUILD64}" CXX="${CXX} ${BUILD64}" \
  ${SRCMIPS64ELROOTFS}/ncurses-${NCURSES_VERSION}/configure \
  --build=${CROSS_HOST} --host=${CROSS_TARGET64} \
  --prefix=/usr --libdir=/lib64 --with-shared \
  --enable-widec --without-debug --without-ada \
  --with-manpage-format=normal \
  --with-default-terminfo-dir=/usr/share/terminfo || \
    die "***config ncurses64 error" && \
      touch ${METADATAMIPS64ELROOTFS}/ncurses_config64
[ -f "${METADATAMIPS64ELROOTFS}/ncurses_build64" ] || \
make -j${JOBS} || \
  die "***build ncurses64 error" && \
    touch ${METADATAMIPS64ELROOTFS}/ncurses_build64
[ -f "${METADATAMIPS64ELROOTFS}/ncurses_install64" ] || \
make DESTDIR=${PREFIXMIPS64ELROOTFS} install || \
  die "***install ncurses64 error" && \
    touch ${METADATAMIPS64ELROOTFS}/ncurses_install64
mv -v ${PREFIXMIPS64ELROOTFS}/usr/bin/ncursesw5-config{,-64}
ln -svf multiarch_wrapper ${PREFIXMIPS64ELROOTFS}/usr/bin/ncursesw5-config
mv -v ${PREFIXMIPS64ELROOTFS}/lib64/lib{panelw,menuw,formw,ncursesw,ncurses++w}.a \
  ${PREFIXMIPS64ELROOTFS}/usr/lib64
rm -v ${PREFIXMIPS64ELROOTFS}/lib64/lib{ncursesw,menuw,panelw,formw}.so
ln -svf ../../lib64/libncursesw.so.5 ${PREFIXMIPS64ELROOTFS}/usr/lib64/libncursesw.so
ln -svf ../../lib64/libmenuw.so.5 ${PREFIXMIPS64ELROOTFS}/usr/lib64/libmenuw.so
ln -svf ../../lib64/libpanelw.so.5 ${PREFIXMIPS64ELROOTFS}/usr/lib64/libpanelw.so
ln -svf ../../lib64/libformw.so.5 ${PREFIXMIPS64ELROOTFS}/usr/lib64/libformw.so
for lib in curses ncurses form panel menu ; do
  echo "INPUT(-l${lib}w)" > ${PREFIXMIPS64ELROOTFS}/usr/lib64/lib${lib}.so;
  ln -sfv lib${lib}w.a ${PREFIXMIPS64ELROOTFS}/usr/lib64/lib${lib}.a;
done
ln -sfv libcurses.so ${PREFIXMIPS64ELROOTFS}/usr/lib64/libcursesw.so
ln -sfv libncurses.so ${PREFIXMIPS64ELROOTFS}/usr/lib64/libcurses.so
ln -sfv libncursesw.a ${PREFIXMIPS64ELROOTFS}/usr/lib64/libcursesw.a
ln -sfv libncurses.a ${PREFIXMIPS64ELROOTFS}/usr/lib64/libcurses.a
ln -sfv libncurses++w.a ${PREFIXMIPS64ELROOTFS}/usr/lib64/libncurses++.a
ln -sfv ncursesw5-config-64 ${PREFIXMIPS64ELROOTFS}/usr/bin/ncurses5-config-64
ln -sfv ncursesw5-config ${PREFIXMIPS64ELROOTFS}/usr/bin/ncurses5-config
ln -sfv ../share/terminfo ${PREFIXMIPS64ELROOTFS}/usr/lib64/terminfo
popd

pushd ${BUILDMIPS64ELROOTFS}
[ -d util-linux-32 ] || \
  mkdir util-linux-32
cd util-linux-32
[ -f "${METADATAMIPS64ELROOTFS}/util-linux_create32_config.cache" ] || \
  `cat > config.cache << EOF
scanf_cv_type_modifier=ms
EOF` || \
    die "create util-linux32 config.cache" && \
      touch ${METADATAMIPS64ELROOTFS}/util-linux_create32_config.cache
[ -f "${METADATAMIPS64ELROOTFS}/util-linux_config32" ] || \
  CC="${CC} ${BUILD32}" \
  ${SRCMIPS64ELROOTFS}/util-${UTIL_VERSION}/configure \
  --build=${CROSS_HOST} --host=${CROSS_TARGET32} \
  --enable-arch --enable-partx --disable-wall \
  --enable-write --disable-makeinstall-chown \
  --cache-file=config.cache --libdir=/lib \
  --disable-login --disable-su || \
    die "***config util-linux32 error" && \
      touch ${METADATAMIPS64ELROOTFS}/util-linux_config32
[ -f "${METADATAMIPS64ELROOTFS}/util-linux_build32" ] || \
  make -j${JOBS} || \
    die "***build util-linux32 error" && \
      touch ${METADATAMIPS64ELROOTFS}/util-linux_build32
[ -f "${METADATAMIPS64ELROOTFS}/util-linux_install32" ] || \
  make DESTDIR=${PREFIXMIPS64ELROOTFS} install || \
    die "***install util-linux32 error" && \
      touch ${METADATAMIPS64ELROOTFS}/util-linux_install32
[ -f "${METADATAMIPS64ELROOTFS}/util-linux_rm32_la" ] || \
  rm ${PREFIXMIPS64ELROOTFS}/usr/lib/libuuid.la ${PREFIXMIPS64ELROOTFS}/usr/lib/libblkid.la || \
    die "rm util-linux32 la files" && \
      touch ${METADATAMIPS64ELROOTFS}/util-linux_rm32_la
popd

pushd ${BUILDMIPS64ELROOTFS}
[ -d util-linux-n32 ] || \
  mkdir util-linux-n32
cd util-linux-n32
[ -f "${METADATAMIPS64ELROOTFS}/util-linux_createn32_config.cache" ] || \
  `cat > config.cache << EOF
scanf_cv_type_modifier=ms
EOF` || \
    die "create util-linuxn32 config.cache error" && \
      touch ${METADATAMIPS64ELROOTFS}/util-linux_createn32_config.cache
[ -f "${METADATAMIPS64ELROOTFS}/util-linux_confign32" ] || \
  CC="${CC} ${BUILDN32}" \
  ${SRCMIPS64ELROOTFS}/util-${UTIL_VERSION}/configure \
  --build=${CROSS_HOST} --host=${CROSS_TARGET64} \
  --enable-arch --enable-partx --disable-wall \
  --enable-write --disable-makeinstall-chown \
  --cache-file=config.cache --libdir=/lib32 \
  --disable-login --disable-su || \
    die "***config util-linuxn32 error" && \
      touch ${METADATAMIPS64ELROOTFS}/util-linux_confign32
[ -f "${METADATAMIPS64ELROOTFS}/util-linux_buildn32" ] || \
  make -j${JOBS} || \
    die "***build util-linuxn32 error" && \
      touch ${METADATAMIPS64ELROOTFS}/util-linux_buildn32
[ -f "${METADATAMIPS64ELROOTFS}/util-linux_installn32" ] || \
  make DESTDIR=${PREFIXMIPS64ELROOTFS} install || \
    die "***install util-linuxn32 error" && \
      touch ${METADATAMIPS64ELROOTFS}/util-linux_installn32
[ -f "${METADATAMIPS64ELROOTFS}/util-linux_rmn32_la_files" ] || \
  rm ${PREFIXMIPS64ELROOTFS}/usr/lib32/libuuid.la ${PREFIXMIPS64ELROOTFS}/usr/lib32/libblkid.la || \
    die "rm util-linuxn32 la files" && \
      touch ${METADATAMIPS64ELROOTFS}/util-linux_rmn32_la_files
popd

pushd ${BUILDMIPS64ELROOTFS}
[ -d util-linux-64 ] || \
  mkdir util-linux-64
cd util-linux-64
[ -f "${METADATAMIPS64ELROOTFS}/util-linux_create64_config.cache" ] || \
  `cat > config.cache << EOF
scanf_cv_type_modifier=ms
EOF` || \
    die "create util-linux64 config.cache" && \
      touch ${METADATAMIPS64ELROOTFS}/util-linux_create64_config.cache
[ -f "${METADATAMIPS64ELROOTFS}/util-linux_config64" ] || \
  CC="${CC} ${BUILD64}" \
  ${SRCMIPS64ELROOTFS}/util-${UTIL_VERSION}/configure \
  --build=${CROSS_HOST} --host=${CROSS_TARGET64} \
  --enable-arch --enable-partx --disable-wall \
  --enable-write --disable-makeinstall-chown \
  --cache-file=config.cache --libdir=/lib64 || \
    die "***config util-linux64 error" && \
      touch ${METADATAMIPS64ELROOTFS}/util-linux_config64
[ -f "${METADATAMIPS64ELROOTFS}/util-linux_build64" ] || \
  make -j${JOBS} || \
    die "***build util-linux64 error" && \
      touch ${METADATAMIPS64ELROOTFS}/util-linux_build64
[ -f "${METADATAMIPS64ELROOTFS}/util-linux_install64" ] || \
  make DESTDIR=${PREFIXMIPS64ELROOTFS} install || \
    die "***install util-linux64 error" && \
      touch ${METADATAMIPS64ELROOTFS}/util-linux_install64
[ -f "${METADATAMIPS64ELROOTFS}/util-linux_rm64_la_files" ] || \
  rm ${PREFIXMIPS64ELROOTFS}/usr/lib64/libuuid.la ${PREFIXMIPS64ELROOTFS}/usr/lib64/libblkid.la || \
    die "rm util-linux la files error" && \
      touch ${METADATAMIPS64ELROOTFS}/util-linux_rm64_la_files
[ -f "${METADATAMIPS64ELROOTFS}/util-linux_move_logger" ] || \
  mv -v ${PREFIXMIPS64ELROOTFS}/usr/bin/logger ${PREFIXMIPS64ELROOTFS}/bin || \
    die "move util-linux logger error" && \
      touch ${METADATAMIPS64ELROOTFS}/util-linux_move_logger
popd

pushd ${BUILDMIPS64ELROOTFS}
[ -d e2fs-32 ] || mkdir e2fs-32
cd e2fs-32
[ -f "${METADATAMIPS64ELROOTFS}/e2fs_config32" ] || \
  PKG_CONFIG=true LDFLAGS="-lblkid -luuid" \
  CC="${CC} ${BUILD32}" ${SRCMIPS64ELROOTFS}/e2fsprogs-${E2FSPROGS_VERSION}/configure \
  --build=${CROSS_HOST} --host=${CROSS_TARGET32} --prefix=/usr \
  --with-root-prefix="" --enable-elf-shlibs --disable-libblkid \
  --disable-libuuid --disable-fsck --disable-uuidd || \
    die "***config e2fsprogs32 error" && \
      touch ${METADATAMIPS64ELROOTFS}/e2fs_config32
[ -f "${METADATAMIPS64ELROOTFS}/e2fs_build32" ] || \
  make -j${JOBS} || \
    die "***build e2fsprogs32 error" && \
      touch ${METADATAMIPS64ELROOTFS}/e2fs_build32
[ -f "${METADATAMIPS64ELROOTFS}/e2fs_build32_libs" ] || \
  make -j${JOBS} libs || \
    die "***build e2fsprogs32 libs error" && \
      touch ${METADATAMIPS64ELROOTFS}/e2fs_build32_libs
[ -f "${METADATAMIPS64ELROOTFS}/e2fs_install32" ] || \
  make DESTDIR=${PREFIXMIPS64ELROOTFS} install-libs || \
    die "***install e2fsprogs32 libs error" && \
      touch ${METADATAMIPS64ELROOTFS}/e2fs_install32
rm -v ${PREFIXMIPS64ELROOTFS}/usr/lib/lib{com_err,e2p,ext2fs,ss}.so
ln -sv ../../lib/libcom_err.so.2 ${PREFIXMIPS64ELROOTFS}/usr/lib/libcom_err.so
ln -sv ../../lib/libe2p.so.2 ${PREFIXMIPS64ELROOTFS}/usr/lib/libe2p.so
ln -sv ../../lib/libext2fs.so.2 ${PREFIXMIPS64ELROOTFS}/usr/lib/libext2fs.so
ln -sv ../../lib/libss.so.2 ${PREFIXMIPS64ELROOTFS}/usr/lib/libss.so
popd

pushd ${SRCMIPS64ELROOTFS}
cd e2fsprogs-${E2FSPROGS_VERSION}
cp configure configure-bk
[ -f "${METADATAMIPS64ELROOTFS}/e2fs_updaten32_configure" ] || \
  sed -i '/libdir.*=.*\/lib/s@/lib@/lib32@g' configure || \
    die "update e2fsn32 configure error" && \
      touch ${METADATAMIPS64ELROOTFS}/e2fs_updaten32_configure
popd

pushd ${BUILDMIPS64ELROOTFS}
[ -d e2fs-n32 ] || \
  mkdir e2fs-n32
cd e2fs-n32
# LDFLAGS="-lblkid -luuid"
[ -f "${METADATAMIPS64ELROOTFS}/e2fs_confign32" ] || \
  PKG_CONFIG=true LDFLAGS="-lblkid -luuid" \
  CC="${CC} ${BUILDN32}" ${SRCMIPS64ELROOTFS}/e2fsprogs-${E2FSPROGS_VERSION}/configure \
  --build=${CROSS_HOST} --host=${CROSS_TARGET64} --prefix=/usr \
  --with-root-prefix="" --enable-elf-shlibs --disable-libblkid \
  --disable-libuuid --disable-fsck --disable-uuidd || \
    die "***config e2fsprogsn32 error" && \
      touch ${METADATAMIPS64ELROOTFS}/e2fs_confign32
[ -f "${METADATAMIPS64ELROOTFS}/e2fs_buildn32" ] || \
  make -j${JOBS} || \
    die "***build e2fsprogsn32 error" && \
      touch ${METADATAMIPS64ELROOTFS}/e2fs_buildn32
[ -f "${METADATAMIPS64ELROOTFS}/e2fs_build32_libs" ] || \
  make -j${JOBS} libs || \
    die "***build e2fsprogsn32 libs error" && \
      touch ${METADATAMIPS64ELROOTFS}/e2fs_build32_libs
[ -f "${METADATAMIPS64ELROOTFS}/e2fs_installn32" ] || \
  make DESTDIR=${PREFIXMIPS64ELROOTFS} install-libs || \
    die "***install e2fsprogsn32 libs error" && \
      touch ${METADATAMIPS64ELROOTFS}/e2fs_installn32
rm -v ${PREFIXMIPS64ELROOTFS}/usr/lib32/lib{com_err,e2p,ext2fs,ss}.so
ln -sv ../../lib32/libcom_err.so.2 ${PREFIXMIPS64ELROOTFS}/usr/lib32/libcom_err.so
ln -sv ../../lib32/libe2p.so.2 ${PREFIXMIPS64ELROOTFS}/usr/lib32/libe2p.so
ln -sv ../../lib32/libext2fs.so.2 ${PREFIXMIPS64ELROOTFS}/usr/lib32/libext2fs.so
ln -sv ../../lib32/libss.so.2 ${PREFIXMIPS64ELROOTFS}/usr/lib32/libss.so
popd

pushd ${SRCMIPS64ELROOTFS}
cd e2fsprogs-${E2FSPROGS_VERSION}
cp configure-bk configure
[ -f "${METADATAMIPS64ELROOTFS}/e2fs_update64_configure" ] || \
  sed -i '/libdir.*=.*\/lib/s@/lib@/lib64@g' configure || \
    die "update e2fs64 configure error" && \
      touch ${METADATAMIPS64ELROOTFS}/e2fs_update64_configure
popd

pushd ${BUILDMIPS64ELROOTFS}
[ -d e2fs-64 ] || \
  mkdir e2fs-64
cd e2fs-64
# LDFLAGS="-lblkid -luuid"
[ -f "${METADATAMIPS64ELROOTFS}/e2fs_config64" ] || \
  PKG_CONFIG=true LDFLAGS="-lblkid -luuid" \
  CC="${CC} ${BUILD64}" ${SRCMIPS64ELROOTFS}/e2fsprogs-${E2FSPROGS_VERSION}/configure \
  --build=${CROSS_HOST} --host=${CROSS_TARGET64} --prefix=/usr \
  --with-root-prefix="" --enable-elf-shlibs --disable-libblkid \
  --disable-libuuid --disable-fsck --disable-uuidd || \
    die "***config e2fsprogs error" && \
      touch ${METADATAMIPS64ELROOTFS}/e2fs_config64
[ -f "${METADATAMIPS64ELROOTFS}/e2fs_build64" ] || \
  make -j${JOBS} || \
    die "***build e2fsprogs error" && \
      touch ${METADATAMIPS64ELROOTFS}/e2fs_build64
[ -f "${METADATAMIPS64ELROOTFS}/e2fs_build64_libs" ] || \
  make -j${JOBS} libs || \
    die "***build e2fsprogs error" && \
      touch ${METADATAMIPS64ELROOTFS}/e2fs_build64_libs
[ -f "${METADATAMIPS64ELROOTFS}/e2fs_install64" ] || \
  make DESTDIR=${PREFIXMIPS64ELROOTFS} install-libs || \
    die "***install e2fsprogs libs error" && \
      touch ${METADATAMIPS64ELROOTFS}/e2fs_install64
rm -v ${PREFIXMIPS64ELROOTFS}/usr/lib64/lib{com_err,e2p,ext2fs,ss}.so
ln -sv ../../lib64/libcom_err.so.2 ${PREFIXMIPS64ELROOTFS}/usr/lib64/libcom_err.so
ln -sv ../../lib64/libe2p.so.2 ${PREFIXMIPS64ELROOTFS}/usr/lib64/libe2p.so
ln -sv ../../lib64/libext2fs.so.2 ${PREFIXMIPS64ELROOTFS}/usr/lib64/libext2fs.so
ln -sv ../../lib64/libss.so.2 ${PREFIXMIPS64ELROOTFS}/usr/lib64/libss.so
popd

pushd ${SRCMIPS64ELROOTFS}/coreutils-${COREUTILS_VERSION}
  touch man/uname.1 man/hostname.1
popd

pushd ${BUILDMIPS64ELROOTFS}
[ -d "coreutils-cross-build" ] || mkdir coreutils-cross-build
cd coreutils-cross-build
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
[ -f "${METADATAMIPS64ELROOTFS}/coreutils_cross_config" ] || \
  CC="${CC} ${BUILD64}" CXX="${CXX} ${BUILD64}" \
  CPPFLAGS="-I${PREFIXMIPS64ELROOTFS}/cross-tools/include" \
  ${SRCMIPS64ELROOTFS}/coreutils-${COREUTILS_VERSION}/configure \
  --build=${CROSS_HOST} --host=${CROSS_TARGET64} \
  --prefix=/usr --cache-file=config.cache \
  --enable-no-install-program=kill,uptime \
  --enable-install-program=hostname || \
    die "***config coreutils error" && \
      touch ${METADATAMIPS64ELROOTFS}/coreutils_cross_config
[ -f "${METADATAMIPS64ELROOTFS}/coreutils_cross_build" ] || \
  make -j${JOBS} || \
    die "***build coreutils error" && \
      touch ${METADATAMIPS64ELROOTFS}/coreutils_cross_build
[ -f "${METADATAMIPS64ELROOTFS}/coreutils_cross_install" ] || \
  make DESTDIR=${PREFIXMIPS64ELROOTFS} install || \
    die "***install coreutils error" && \
      touch ${METADATAMIPS64ELROOTFS}/coreutils_cross_install
mv -v ${PREFIXMIPS64ELROOTFS}/usr/bin/{cat,chgrp,chmod,chown,cp,date} ${PREFIXMIPS64ELROOTFS}/bin
mv -v ${PREFIXMIPS64ELROOTFS}/usr/bin/{dd,df,echo,false,hostname,ln,ls,mkdir} ${PREFIXMIPS64ELROOTFS}/bin
mv -v ${PREFIXMIPS64ELROOTFS}/usr/bin/{mv,pwd,rm,rmdir,stty,true,uname} ${PREFIXMIPS64ELROOTFS}/bin
mv -v ${PREFIXMIPS64ELROOTFS}/usr/bin/chroot ${PREFIXMIPS64ELROOTFS}/usr/sbin
mv -v ${PREFIXMIPS64ELROOTFS}/usr/bin/{'[',basename,head,install,nice} ${PREFIXMIPS64ELROOTFS}/bin
mv -v ${PREFIXMIPS64ELROOTFS}/usr/bin/{readlink,sleep,sync,test,touch} ${PREFIXMIPS64ELROOTFS}/bin
ln -sfv ../../bin/install ${PREFIXMIPS64ELROOTFS}/usr/bin
popd

pushd ${BUILDMIPS64ELROOTFS}
[ -d "iana-etc-cross-build" ] || cp -ar ${SRCMIPS64ELROOTFS}/iana-etc-${IANA_VERSION} iana-etc-cross-build
cd iana-etc-cross-build
[ -f "${METADATAMIPS64ELROOTFS}/iana-etc_cross_build" ] || \
  make CC="${CC} ${BUILD64}" CXX="${CXX} ${BUILD64}" -j${JOBS} || \
    die "***build iana-etc error" && \
      touch ${METADATAMIPS64ELROOTFS}/iana-etc_cross_build
[ -f "${METADATAMIPS64ELROOTFS}/iana-etc_cross_install" ] || \
  make DESTDIR=${PREFIXMIPS64ELROOTFS} install || \
    die "***install iana-etc error" && \
      touch ${METADATAMIPS64ELROOTFS}/iana-etc_cross_install
popd

pushd ${BUILDMIPS64ELROOTFS}
[ -d "m4-cross-build" ] || mkdir "m4-cross-build"
cd m4-cross-build
[ -f "${METADATAMIPS64ELROOTFS}/m4_cross_create_config.cache" ] || \
  `cat > config.cache << EOF
gl_cv_func_btowc_eof=yes
gl_cv_func_mbrtowc_incomplete_state=yes
gl_cv_func_mbrtowc_sanitycheck=yes
gl_cv_func_mbrtowc_null_arg=yes
gl_cv_func_mbrtowc_retval=yes
gl_cv_func_mbrtowc_nul_retval=yes
gl_cv_func_wcrtomb_retval=yes
gl_cv_func_wctob_works=yes
EOF` || \
    die "create m4 config.cache" && \
      touch ${METADATAMIPS64ELROOTFS}/m4_cross_create_config.cache
[ -f "${METADATAMIPS64ELROOTFS}/m4_cross_config" ] || \
  CC="${CC} ${BUILD64}" ${SRCMIPS64ELROOTFS}/m4-${M4_VERSION}/configure \
  --build=${CROSS_HOST} --host=${CROSS_TARGET64} --prefix=/usr \
  --cache-file=config.cache || \
    die "***config m4 error" && \
      touch ${METADATAMIPS64ELROOTFS}/m4_cross_config
[ -f "${METADATAMIPS64ELROOTFS}/m4_cross_build" ] || \
  make -j${JOBS} || \
    die "***build m4 error" && \
      touch ${METADATAMIPS64ELROOTFS}/m4_cross_build
[ -f "${METADATAMIPS64ELROOTFS}/m4_cross_install" ] || \
  make DESTDIR=${PREFIXMIPS64ELROOTFS} install || \
    die "***install m4 error" && \
      touch ${METADATAMIPS64ELROOTFS}/m4_cross_install
popd

pushd ${SRCMIPS64ELROOTFS}/bison-${BISON_VERSION}
[ -f "${METADATAMIPS64ELROOTFS}/bison_cross_update_config.h" ] || \
  `cat >> config.h << "EOF"
#define YYENABLE_NLS 1
EOF` || \
    die "update bison config.h" && \
      touch ${METADATAMIPS64ELROOTFS}/bison_cross_update_config.h
popd

pushd ${BUILDMIPS64ELROOTFS}
[ -d "bison-32" ] || \
  mkdir "bison-32"
cd bison-32
[ -f "${METADATAMIPS64ELROOTFS}/bison_create32_config.cache" ] || \
  echo "ac_cv_prog_lex_is_flex=yes" > config.cache || \
    die "create bison32 config.cache error" && \
      touch ${METADATAMIPS64ELROOTFS}/bison_create32_config.cache
[ -f "${METADATAMIPS64ELROOTFS}/bison_config32" ] || \
  CC="${CC} ${BUILD32}" \
  ${SRCMIPS64ELROOTFS}/bison-${BISON_VERSION}/configure \
  --prefix=/usr --cache-file=config.cache \
  --build=${CROSS_HOST} --host=${CROSS_TARGET32} || \
    die "***config bison32 error" && \
      touch ${METADATAMIPS64ELROOTFS}/bison_config32
[ -f "${METADATAMIPS64ELROOTFS}/bison_build32" ] || \
  make -j${JOBS} || \
    die "***build bison32 error" && \
      touch ${METADATAMIPS64ELROOTFS}/bison_build32
[ -f "${METADATAMIPS64ELROOTFS}/bison_install32" ] || \
  make DESTDIR=${PREFIXMIPS64ELROOTFS} install || \
    die "***install bison32 error" && \
      touch ${METADATAMIPS64ELROOTFS}/bison_install32
popd

pushd ${BUILDMIPS64ELROOTFS}
[ -d "bison-n32" ] || mkdir "bison-n32"
cd bison-n32
[ -f "${METADATAMIPS64ELROOTFS}/bison_createn32_config.cache" ] || \
  echo "ac_cv_prog_lex_is_flex=yes" > config.cache || \
    die "create bisonn32 config.cache" && \
      touch ${METADATAMIPS64ELROOTFS}/bison_createn32_config.cache
[ -f "${METADATAMIPS64ELROOTFS}/bison_confign32" ] || \
  CC="${CC} ${BUILDN32}" \
  ${SRCMIPS64ELROOTFS}/bison-${BISON_VERSION}/configure \
  --prefix=/usr --cache-file=config.cache \
  --build=${CROSS_HOST} --host=${CROSS_TARGET64} \
  --libdir=/usr/lib32 || \
    die "***config bisonn32 error" && \
      touch ${METADATAMIPS64ELROOTFS}/bison_confign32
[ -f "${METADATAMIPS64ELROOTFS}/bison_buildn32" ] || \
  make -j${JOBS} || \
    die "***build bisonn32 error" && \
      touch ${METADATAMIPS64ELROOTFS}/bison_buildn32
[ -f "${METADATAMIPS64ELROOTFS}/bison_installn32" ] || \
  make DESTDIR=${PREFIXMIPS64ELROOTFS} install || \
    die "***install bisonn32 error" && \
      touch ${METADATAMIPS64ELROOTFS}/bison_installn32
popd

pushd ${BUILDMIPS64ELROOTFS}
[ -d "bison-64" ] || \
  mkdir "bison-64"
cd bison-64
[ -f "${METADATAMIPS64ELROOTFS}/bison_create64_config.cache" ] || \
  echo "ac_cv_prog_lex_is_flex=yes" > config.cache || \
    die "create bison64 config.cache error" && \
      touch ${METADATAMIPS64ELROOTFS}/bison_create64_config.cache
[ -f "${METADATAMIPS64ELROOTFS}/bison_config64" ] || \
  CC="${CC} ${BUILDN32}" \
  ${SRCMIPS64ELROOTFS}/bison-${BISON_VERSION}/configure \
  --prefix=/usr --cache-file=config.cache \
  --build=${CROSS_HOST} --host=${CROSS_TARGET64} \
  --libdir=/usr/lib64 || \
    die "***config bison64 error" && \
      touch ${METADATAMIPS64ELROOTFS}/bison_config64
[ -f "${METADATAMIPS64ELROOTFS}/bison_build64" ] || \
  make -j${JOBS} || \
    die "***build bison64 error" && \
      touch ${METADATAMIPS64ELROOTFS}/bison_build64
[ -f "${METADATAMIPS64ELROOTFS}/bison_install64" ] || \
  make DESTDIR=${PREFIXMIPS64ELROOTFS} install || \
    die "***install bison64 error" && \
      touch ${METADATAMIPS64ELROOTFS}/bison_install64
popd

pushd ${BUILDMIPS64ELROOTFS}
[ -d procps-32 ] || \
  cp -r ${SRCMIPS64ELROOTFS}/procps-${PROCPS_VERSION} procps-32
cd procps-32
[ -f "${METADATAMIPS64ELROOTFS}/procps_build32" ] || \
  make DESTDIR=${PREFIXMIPS64ELROOTFS} CC="${CC} ${BUILD32}" CPPFLAGS= lib64=lib m64= || \
    die "***build procps32 error" && \
      touch ${METADATAMIPS64ELROOTFS}/procps_build32
[ -f "${METADATAMIPS64ELROOTFS}/procps_install32" ] || \
  make DESTDIR=${PREFIXMIPS64ELROOTFS} CC="${CC} ${BUILD32}" lib64=lib m64= ldconfig= \
  install="install -D" install || \
    die "***install procps-32 error" && \
      touch ${METADATAMIPS64ELROOTFS}/procps_install32
popd

pushd ${BUILDMIPS64ELROOTFS}
[ -d procps-n32 ] || \
  cp -r ${SRCMIPS64ELROOTFS}/procps-${PROCPS_VERSION} procps-n32
cd procps-n32
[ -f "${METADATAMIPS64ELROOTFS}/procps_buildn32" ] || \
  make DESTDIR=${PREFIXMIPS64ELROOTFS} CC="${CC} ${BUILDN32}" CPPFLAGS= lib64=lib32 m64= || \
    die "***build procpsn32 error" && \
      touch ${METADATAMIPS64ELROOTFS}/procps_buildn32
[ -f "${METADATAMIPS64ELROOTFS}/procps_installn32" ] || \
  make DESTDIR=${PREFIXMIPS64ELROOTFS} CC="${CC} ${BUILDN32}" lib64=lib32 m64= ldconfig= \
  install="install -D" install || \
    die "***install procpsn32 error" && \
      touch ${METADATAMIPS64ELROOTFS}/procps_installn32
popd

pushd ${BUILDMIPS64ELROOTFS}
[ -d procps-64 ] || \
  cp -r ${SRCMIPS64ELROOTFS}/procps-${PROCPS_VERSION} procps-64
cd procps-64
[ -f "${METADATAMIPS64ELROOTFS}/procps_build64" ] || \
  make DESTDIR=${PREFIXMIPS64ELROOTFS} CC="${CC} ${BUILD64}" CPPFLAGS= lib64=lib64 m64= || \
    die "***build procps64 error" && \
      touch ${METADATAMIPS64ELROOTFS}/procps_build64
[ -f "${METADATAMIPS64ELROOTFS}/procps_install64" ] || \
  make DESTDIR=${PREFIXMIPS64ELROOTFS} CC="${CC} ${BUILD64}" lib64=lib64 m64= ldconfig= \
  install="install -D" install || \
    die "***install procps64 error" && \
      touch ${METADATAMIPS64ELROOTFS}/procps_install64
popd

pushd ${BUILDMIPS64ELROOTFS}
[ -d "libtool-32" ] || \
  mkdir "libtool-32"
cd libtool-32
[ -f "${METADATAMIPS64ELROOTFS}/libtool_create32_config.cache" ] || \
  echo "lt_cv_sys_dlsearch_path='/lib /usr/lib /usr/local/lib /opt/lib'" > config.cache || \
    die "create libtool32 config.cache" && \
      touch ${METADATAMIPS64ELROOTFS}/libtool_create32_config.cache
[ -f "${METADATAMIPS64ELROOTFS}/libtool_config32" ] || \
  CC="${CC} ${BUILD32}" \
  ${SRCMIPS64ELROOTFS}/libtool-${LIBTOOL_VERSION}/configure \
  --build=${CROSS_HOST} --host=${CROSS_TARGET32} --prefix=/usr \
  --cache-file=config.cache || \
    die "***config libtool32 error" && \
      touch ${METADATAMIPS64ELROOTFS}/libtool_config32
[ -f "${METADATAMIPS64ELROOTFS}/libtool_build32" ] || \
  make -j${JOBS} || \
    die "***build libtool32 error" && \
      touch ${METADATAMIPS64ELROOTFS}/libtool_build32
[ -f "${METADATAMIPS64ELROOTFS}/libtool_install32" ] || \
  make DESTDIR=${PREFIXMIPS64ELROOTFS} install || \
    die "***install libtool32 error" && \
      touch ${METADATAMIPS64ELROOTFS}/libtool_install32
[ -f "${METADATAMIPS64ELROOTFS}/libtool_update32_name" ] || \
  mv -v ${PREFIXMIPS64ELROOTFS}/usr/bin/libtool{,-32} || \
    die "libtool update32 name" && \
      touch ${METADATAMIPS64ELROOTFS}/libtool_update32_name
popd

pushd ${BUILDMIPS64ELROOTFS}
[ -d "libtool-n32" ] || \
  mkdir "libtool-n32"
cd libtool-n32
[ -f "${METADATAMIPS64ELROOTFS}/libtool_createn32_config.cache" ] || \
  echo "lt_cv_sys_dlsearch_path='/lib32 /usr/lib32 /usr/local/lib32 /opt/lib32'" > config.cache || \
    die "create libtooln32 config.cache" && \
      touch ${METADATAMIPS64ELROOTFS}/libtool_createn32_config.cache
[ -f "${METADATAMIPS64ELROOTFS}/libtool_confign32" ] || \
  CC="${CC} ${BUILDN32}" \
  ${SRCMIPS64ELROOTFS}/libtool-${LIBTOOL_VERSION}/configure \
  --build=${CROSS_HOST} --host=${CROSS_TARGET64} --prefix=/usr \
  --libdir=/usr/lib32 --cache-file=config.cache || \
    die "***config libtooln32 error" && \
      touch ${METADATAMIPS64ELROOTFS}/libtool_confign32
[ -f "${METADATAMIPS64ELROOTFS}/libtool_buildn32" ] || \
  make -j${JOBS} || \
    die "***build libtooln32 error" && \
      touch ${METADATAMIPS64ELROOTFS}/libtool_buildn32
[ -f "${METADATAMIPS64ELROOTFS}/libtool_installn32" ] || \
  make DESTDIR=${PREFIXMIPS64ELROOTFS} install || \
    die "***install libtooln32 error" && \
      touch ${METADATAMIPS64ELROOTFS}/libtool_installn32
[ -f "${METADATAMIPS64ELROOTFS}/libtool_updaten32_name" ] || \
  mv -v ${PREFIXMIPS64ELROOTFS}/usr/bin/libtool{,-n32} || \
    die "libtool updaten32 name" && \
      touch ${METADATAMIPS64ELROOTFS}/libtool_updaten32_name
popd

pushd ${BUILDMIPS64ELROOTFS}
[ -d "libtool-64" ] || \
  mkdir "libtool-64"
cd libtool-64
[ -f "${METADATAMIPS64ELROOTFS}/libtool_create64_config.cache" ] || \
  echo "lt_cv_sys_dlsearch_path='/lib64 /usr/lib64 /usr/local/lib64 /opt/lib64'" > config.cache || \
    die "create libtool64 config.cache" && \
      touch ${METADATAMIPS64ELROOTFS}/libtool_create64_config.cache
[ -f "${METADATAMIPS64ELROOTFS}/libtool_config64" ] || \
  CC="${CC} ${BUILD64}" \
  ${SRCMIPS64ELROOTFS}/libtool-${LIBTOOL_VERSION}/configure \
  --build=${CROSS_HOST} --host=${CROSS_TARGET64} --prefix=/usr \
  --libdir=/usr/lib64 --cache-file=config.cache || \
    die "***config libtool64 error" && \
      touch ${METADATAMIPS64ELROOTFS}/libtool_config64
[ -f "${METADATAMIPS64ELROOTFS}/libtool_build64" ] || \
  make -j${JOBS} || \
    die "***build libtool64 error" && \
      touch ${METADATAMIPS64ELROOTFS}/libtool_build64
[ -f "${METADATAMIPS64ELROOTFS}/libtool_install64" ] || \
  make DESTDIR=${PREFIXMIPS64ELROOTFS} install || \
    die "***install libtool64 error" && \
      touch ${METADATAMIPS64ELROOTFS}/libtool_install64
[ -f "${METADATAMIPS64ELROOTFS}/libtool_update64_name" ] || \
  mv -v ${PREFIXMIPS64ELROOTFS}/usr/bin/libtool{,-64} || \
    die "libtool update64 name" && \
      touch ${METADATAMIPS64ELROOTFS}/libtool_update64_name
[ -f "${METADATAMIPS64ELROOTFS}/libtool_link_wrapper" ] || \
  ln -s multiarch_wrapper ${PREFIXMIPS64ELROOTFS}/usr/bin/libtool || \
    die "libtool link wrapper error" && \
      touch ${METADATAMIPS64ELROOTFS}/libtool_link_wrapper
popd

pushd ${SRCMIPS64ELROOTFS}/flex-${FLEX_VERSION}
[ -f "${METADATAMIPS64ELROOTFS}/flex_cross_update_makefile" ] || \
  cp -v Makefile.in{,.orig} && \
  sed "s/-I@includedir@//g" Makefile.in.orig > Makefile.in || \
    die "update flex Makefile error" && \
      touch ${METADATAMIPS64ELROOTFS}/flex_cross_update_makefile
popd

pushd ${BUILDMIPS64ELROOTFS}
[ -d flex-32 ] || \
  mkdir flex-32
cd flex-32
[ -f "${METADATAMIPS64ELROOTFS}/flex_create32_config.cache" ] || \
  `cat > config.cache << EOF
ac_cv_func_malloc_0_nonnull=yes
ac_cv_func_realloc_0_nonnull=yes
EOF` || \
    die "create flex32 config.cache" && \
      touch ${METADATAMIPS64ELROOTFS}/flex_create32_config.cache
[ -f "${METADATAMIPS64ELROOTFS}/flex_config32" ] || \
  CC="${CC} ${BUILD32}" \
  ${SRCMIPS64ELROOTFS}/flex-${FLEX_VERSION}/configure \
  --build=${CROSS_HOST} --host=${CROSS_TARGET32} \
  --prefix=/usr --cache-file=config.cache || \
    die "***config flex32 error" && \
      touch ${METADATAMIPS64ELROOTFS}/flex_config32
[ -f "${METADATAMIPS64ELROOTFS}/flex_build32_libfl" ] || \
  make CC="${CC} ${BUILD32} -fPIC" libfl.a || \
    die "***build flex32 libfl.a error" && \
      touch ${METADATAMIPS64ELROOTFS}/flex_build32_libfl
[ -f "${METADATAMIPS64ELROOTFS}/flex_build32" ] || \
  make -j${JOBS} || \
    die "***build flex32 error" && \
      touch ${METADATAMIPS64ELROOTFS}/flex_build32
[ -f "${METADATAMIPS64ELROOTFS}/flex_install32" ] || \
  make DESTDIR=${PREFIXMIPS64ELROOTFS} install || \
    die "***install flex32 error" && \
      touch ${METADATAMIPS64ELROOTFS}/flex_install32
[ -f "${METADATAMIPS64ELROOTFS}/flex_link32_libfl" ] || \
  ln -sfv libfl.a ${PREFIXMIPS64ELROOTFS}/usr/lib/libl.a || \
    die "link flex32 libfl error" && \
      touch ${METADATAMIPS64ELROOTFS}/flex_link32_libfl
popd

pushd ${BUILDMIPS64ELROOTFS}
[ -d flex-n32 ] || \
  mkdir flex-n32
cd flex-n32
[ -f "${METADATAMIPS64ELROOTFS}/flex_createn32_config.cache" ] || \
  `cat > config.cache << EOF
ac_cv_func_malloc_0_nonnull=yes
ac_cv_func_realloc_0_nonnull=yes
EOF` || \
    die "flex createn32 config.cache error" && \
      touch ${METADATAMIPS64ELROOTFS}/flex_createn32_config.cache
[ -f "${METADATAMIPS64ELROOTFS}/flex_confign32" ] || \
  CC="${CC} ${BUILDN32}" \
  ${SRCMIPS64ELROOTFS}/flex-${FLEX_VERSION}/configure \
  --build=${CROSS_HOST} --host=${CROSS_TARGET64} \
  --prefix=/usr --cache-file=config.cache \
  --libdir=/usr/lib32 || \
    die "***config flexn32 error" && \
      touch ${METADATAMIPS64ELROOTFS}/flex_confign32
[ -f "${METADATAMIPS64ELROOTFS}/flex_buildn32_libfl" ] || \
  make CC="${CC} ${BUILDN32} -fPIC" libfl.a || \
    die "***build flexn32 libfl.a error" && \
      touch ${METADATAMIPS64ELROOTFS}/flex_buildn32_libfl
[ -f "${METADATAMIPS64ELROOTFS}/flex_buildn32" ] || \
  make -j${JOBS} || \
    die "***build flexn32 error" && \
      touch ${METADATAMIPS64ELROOTFS}/flex_buildn32
[ -f "${METADATAMIPS64ELROOTFS}/flex_installn32" ] || \
  make DESTDIR=${PREFIXMIPS64ELROOTFS} install || \
    die "***install flexn32 error" && \
      touch ${METADATAMIPS64ELROOTFS}/flex_installn32
[ -f "${METADATAMIPS64ELROOTFS}/flex_linkn32_libfl" ] || \
  ln -sfv libfl.a ${PREFIXMIPS64ELROOTFS}/usr/lib32/libl.a || \
    die "link flexn32 libfl error" && \
      touch ${METADATAMIPS64ELROOTFS}/flex_linkn32_libfl
popd

pushd ${BUILDMIPS64ELROOTFS}
[ -d flex-64 ] || \
  mkdir flex-64
cd flex-64
[ -f "${METADATAMIPS64ELROOTFS}/flex_create64_config.cache" ] || \
  `cat > config.cache << EOF
ac_cv_func_malloc_0_nonnull=yes
ac_cv_func_realloc_0_nonnull=yes
EOF` || \
    die "create flex64 config.cache" && \
      touch ${METADATAMIPS64ELROOTFS}/flex_create64_config.cache
[ -f "${METADATAMIPS64ELROOTFS}/flex_config64" ] || \
  CC="${CC} ${BUILD64}" \
  ${SRCMIPS64ELROOTFS}/flex-${FLEX_VERSION}/configure \
  --build=${CROSS_HOST} --host=${CROSS_TARGET64} \
  --prefix=/usr --cache-file=config.cache \
  --libdir=/usr/lib64 || \
    die "***config flex64 error" && \
      touch ${METADATAMIPS64ELROOTFS}/flex_config64
[ -f "${METADATAMIPS64ELROOTFS}/flex_build64_libfl" ] || \
  make CC="${CC} ${BUILD64} -fPIC" libfl.a || \
    die "***build flex64 libfl.a error" && \
      touch ${METADATAMIPS64ELROOTFS}/flex_build64_libfl
[ -f "${METADATAMIPS64ELROOTFS}/flex_build64" ] || \
  make -j${JOBS} || \
    die "***build flex64 error" && \
      touch ${METADATAMIPS64ELROOTFS}/flex_build64
[ -f "${METADATAMIPS64ELROOTFS}/flex_install64" ] || \
  make DESTDIR=${PREFIXMIPS64ELROOTFS} install || \
    die "***install flex64 error" && \
      touch ${METADATAMIPS64ELROOTFS}/flex_install64
[ -f "${METADATAMIPS64ELROOTFS}/flex_link64_libfl" ] || \
  ln -sfv libfl.a ${PREFIXMIPS64ELROOTFS}/usr/lib64/libl.a || \
    die "link flexn64 libfl error" && \
      touch ${METADATAMIPS64ELROOTFS}/flex_link64_libfl
popd

pushd ${BUILDMIPS64ELROOTFS}
[ -f "${METADATAMIPS64ELROOTFS}/flex_cross_create_script" ] || \
  `cat > ${PREFIXMIPS64ELROOTFS}/usr/bin/lex << "EOF"
#!/bin/sh
# Begin /usr/bin/lex

exec /usr/bin/flex -l "$@"

# End /usr/bin/lex
EOF` && \
  chmod -v 755 ${PREFIXMIPS64ELROOTFS}/usr/bin/lex || \
    die "create flex script error" && \
      touch ${METADATAMIPS64ELROOTFS}/flex_cross_create_script
popd

pushd ${BUILDMIPS64ELROOTFS}
[ -d "iproute2-cross-build" ] || \
  cp -ar ${SRCMIPS64ELROOTFS}/iproute2-${IPROUTE2_VERSION} iproute2-cross-build
cd iproute2-cross-build
for dir in ip misc tc; do
  cp ${dir}/Makefile{,.orig};
  sed 's/0755 -s/0755/' ${dir}/Makefile.orig > ${dir}/Makefile;
done;
cp misc/Makefile{,.orig}
sed '/^TARGETS/s@arpd@@g' misc/Makefile.orig > misc/Makefile
[ -f "${METADATAMIPS64ELROOTFS}/iproute2_cross_build" ] || \
  make DESTDIR=${PREFIXMIPS64ELROOTFS} CC="${CC} ${BUILD64}" \
  DOCDIR=/usr/share/doc/iproute2 \
  MANDIR=/usr/share/man LIBDIR=/usr/lib64 || \
    die "***build iproute2 error" && \
      touch ${METADATAMIPS64ELROOTFS}/iproute2_cross_build
[ -f "${METADATAMIPS64ELROOTFS}/iproute2_cross_install" ] || \
  make DESTDIR=${PREFIXMIPS64ELROOTFS} CC="${CC} ${BUILD64}" \
  DOCDIR=/usr/share/doc/iproute2 \
  MANDIR=/usr/share/man  LIBDIR=/usr/lib64 install || \
    die "***install iproute2 error" && \
      touch ${METADATAMIPS64ELROOTFS}/iproute2_cross_install
popd

pushd ${BUILDMIPS64ELROOTFS}
cd perl-${PERL_VERSION}
[ -f "${METADATAMIPS64ELROOTFS}/perl_cross_config" ] || \
  LD=${CC} ./configure --prefix=/usr --target=${CROSS_TARGET64} \
  -A ccflags=-mabi=64 -A cccdlflags=-mabi=64 -A ccdlflags=-mabi=64 \
  -A cppflags=-mabi=64 -A lldlflags=-mabi=64 -A ldflags=-mabi=64 \
  -A lddlflags="-mabi=64 -shared" || \
    die "config cross perl error" && \
      touch ${METADATAMIPS64ELROOTFS}/perl_cross_config
[ -f "${METADATAMIPS64ELROOTFS}/perl_cross_build" ] || \
  make LD=${CC} || \
    die "build cross perl error" && \
      touch ${METADATAMIPS64ELROOTFS}/perl_cross_build
[ -f "${METADATAMIPS64ELROOTFS}/perl_cross_install" ] || \
  make DESTDIR=${PREFIXMIPS64ELROOTFS} LD=${CC} install || \
    die "install cross perl error" && \
      touch ${METADATAMIPS64ELROOTFS}/perl_cross_install
popd

pushd ${BUILDMIPS64ELROOTFS}
[ -d "python-cross-build" ] || \
  cp -ar ${SRCMIPS64ELROOTFS}/Python-${PYTHON_VERSION} python-cross-build
cd python-cross-build
[ -f "${METADATAMIPS64ELROOTFS}/python-cross-update-patch" ] || \
  sed -e 's/\${SYSROOT}/${PREFIXMIPS64ELROOTFS}/g' \
         ${PATCH}/python-3.3-cross-mips64.patch > tmp.patch || \
    die "python update patch error" && \
      touch ${METADATAMIPS64ELROOTFS}/python-cross-update-patch
[ -f "${METADATAMIPS64ELROOTFS}/python-cross-patch" ] || \
  patch -p1 < tmp.patch || \
    die "patch cross python error" && \
      touch ${METADATAMIPS64ELROOTFS}/python-cross-patch
cat > config.cache << EOF
ac_cv_file__dev_ptmx=no
ac_cv_file__dev_ptc=no
EOF
[ -f "${METADATAMIPS64ELROOTFS}/python_cross_config" ] || \
  CC="${CC} ${BUILD64}" \
  CXX="${CXX} ${BUILD64}" \
  LDFLAGS="-L${PREFIXMIPS64ELROOTFS}/cross-tools/lib64 ${BUILD64}" \
  ./configure --prefix=/usr \
  --build=${CROSS_HOST} --host=${CROSS_TARGET64} \
  --libdir=/lib64 \
  --cache-file=config.cache || \
    die "***config python_cross64 error" && \
      touch ${METADATAMIPS64ELROOTFS}/python_cross_config
[ -f "${METADATAMIPS64ELROOTFS}/python_cross_build" ] || \
  make CC="${CC} ${BUILD64}" -j${JOBS} || \
    die "***build cross python error" && \
      touch ${METADATAMIPS64ELROOTFS}/python_cross_build
[ -f "${METADATAMIPS64ELROOTFS}/python_cross_install" ] || \
  make DESTDIR=${PREFIXMIPS64ELROOTFS} install || \
    die "***install python_cross error" && \
      touch ${METADATAMIPS64ELROOTFS}/python_cross_install
popd

pushd ${BUILDMIPS64ELROOTFS}
[ -d "readline-32" ] || \
  mkdir readline-32
cd readline-32
[ -f "${METADATAMIPS64ELROOTFS}/readline_config32" ] || \
  CC="${CC} ${BUILD32}" CXX="${CXX} ${BUILD32}" \
  ${SRCMIPS64ELROOTFS}/readline-${READLINE_VERSION}/configure \
  --build=${CROSS_HOST} --host=${CROSS_TARGET32} \
  --prefix=/usr --libdir=/lib || \
    die "***config readline32 error" && \
      touch ${METADATAMIPS64ELROOTFS}/readline_config32
[ -f "${METADATAMIPS64ELROOTFS}/readline_build32_with_ncurses" ] || \
  make SHLIB_LIBS=-lncurses || \
    die "build readline32 with ncurses error" && \
      touch ${METADATAMIPS64ELROOTFS}/readline_build32_with_ncurses
[ -f "${METADATAMIPS64ELROOTFS}/readline_build32" ] || \
  make -j${JOBS} || \
    die "***build readline32 error" && \
      touch ${METADATAMIPS64ELROOTFS}/readline_build32
[ -f "${METADATAMIPS64ELROOTFS}/readline_install32" ] || \
  make DESTDIR=${PREFIXMIPS64ELROOTFS} install || \
    die "***install readline32 error" && \
      touch ${METADATAMIPS64ELROOTFS}/readline_install32
[ -f "${METADATAMIPS64ELROOTFS}/readline_install_doc" ] || \
  make DESTDIR=${PREFIXMIPS64ELROOTFS} install-doc || \
    die "***install readline32 doc error" && \
      touch ${METADATAMIPS64ELROOTFS}/readline_install_doc
[ -f "${METADATAMIPS64ELROOTFS}/readline_move32_libs.a" ] || \
  mv -v ${PREFIXMIPS64ELROOTFS}/lib/lib{readline,history}.a ${PREFIXMIPS64ELROOTFS}/usr/lib || \
    die "move readline32 libs.a" && \
      touch ${METADATAMIPS64ELROOTFS}/readline_move32_libs.a
[ -f "${METADATAMIPS64ELROOTFS}/readline_rm32_lib.so" ] || \
  rm -v ${PREFIXMIPS64ELROOTFS}/lib/lib{readline,history}.so || \
    die "rm readline32 lib.so" && \
      touch ${METADATAMIPS64ELROOTFS}/readline_rm32_lib.so
[ -f "${METADATAMIPS64ELROOTFS}/readline_link32_libreadline.so" ] || \
  ln -sfv ../../lib/libreadline.so.6 ${PREFIXMIPS64ELROOTFS}/usr/lib/libreadline.so || \
    die "link readline32 libreadline.so" && \
      touch ${METADATAMIPS64ELROOTFS}/readline_link32_libreadline.so
[ -f "${METADATAMIPS64ELROOTFS}/readline_link32_libhistory.so" ] || \
  ln -sfv ../../lib/libhistory.so.6 ${PREFIXMIPS64ELROOTFS}/usr/lib/libhistory.so || \
    die "link readline32 libhistory.so" && \
      touch ${METADATAMIPS64ELROOTFS}/readline_link32_libhistory.so
popd

pushd ${BUILDMIPS64ELROOTFS}
[ -d "readline-n32" ] || \
  mkdir readline-n32
cd readline-n32
[ -f "${METADATAMIPS64ELROOTFS}/readline_confign32" ] || \
  CC="${CC} ${BUILDN32}" CXX="${CXX} ${BUILDN32}" \
  ${SRCMIPS64ELROOTFS}/readline-${READLINE_VERSION}/configure \
  --build=${CROSS_HOST} --host=${CROSS_TARGET64} \
  --prefix=/usr --libdir=/lib32 || \
    die "***config readlinen32 error" && \
      touch ${METADATAMIPS64ELROOTFS}/readline_confign32
[ -f "${METADATAMIPS64ELROOTFS}/readline_buildn32_with_ncurses" ] || \
  make SHLIB_LIBS=-lncurses || \
    die "build readlinen32 with ncurses" && \
      touch ${METADATAMIPS64ELROOTFS}/readline_buildn32_with_ncurses
[ -f "${METADATAMIPS64ELROOTFS}/readline_buildn32" ] || \
  make -j${JOBS} || \
    die "***build readlinen32 error" && \
      touch ${METADATAMIPS64ELROOTFS}/readline_buildn32
[ -f "${METADATAMIPS64ELROOTFS}/readline_installn32" ] || \
  make DESTDIR=${PREFIXMIPS64ELROOTFS} install || \
    die "***install readlinen32 error" && \
      touch ${METADATAMIPS64ELROOTFS}/readline_installn32
[ -f "${METADATAMIPS64ELROOTFS}/readline_installn32_doc" ] || \
  make DESTDIR=${PREFIXMIPS64ELROOTFS} install-doc || \
    die "***install readlinen32 doc error" && \
      touch ${METADATAMIPS64ELROOTFS}/readline_installn32_doc
[ -f "${METADATAMIPS64ELROOTFS}/readline_moven32_libs.a" ] || \
  mv -v ${PREFIXMIPS64ELROOTFS}/lib32/lib{readline,history}.a ${PREFIXMIPS64ELROOTFS}/usr/lib32 || \
    die "move readlinen32 libs.a" && \
      touch ${METADATAMIPS64ELROOTFS}/readline_moven32_libs.a
[ -f "${METADATAMIPS64ELROOTFS}/readline_rmn32_lib.so" ] || \
  rm -v ${PREFIXMIPS64ELROOTFS}/lib32/lib{readline,history}.so || \
    die "rm readlinen32 lib.so" && \
      touch ${METADATAMIPS64ELROOTFS}/readline_rmn32_lib.so
[ -f "${METADATAMIPS64ELROOTFS}/readline_linkn32_libreadline.so" ] || \
  ln -sfv ../../lib32/libreadline.so.6 ${PREFIXMIPS64ELROOTFS}/usr/lib32/libreadline.so || \
    die "link readlinen32 libreadline.so" && \
      touch ${METADATAMIPS64ELROOTFS}/readline_linkn32_libreadline.so
[ -f "${METADATAMIPS64ELROOTFS}/readline_linkn32_libhistory.so" ] || \
  ln -sfv ../../lib32/libhistory.so.6 ${PREFIXMIPS64ELROOTFS}/usr/lib32/libhistory.so || \
    die "link readlinen32 libhistory.so" && \
      touch ${METADATAMIPS64ELROOTFS}/readline_linkn32_libhistory.so
popd

pushd ${BUILDMIPS64ELROOTFS}
[ -d "readline-64" ] || \
  mkdir readline-64
cd readline-64
[ -f "${METADATAMIPS64ELROOTFS}/readline_config64" ] || \
  CC="${CC} ${BUILD64}" CXX="${CXX} ${BUILD64}" \
  ${SRCMIPS64ELROOTFS}/readline-${READLINE_VERSION}/configure \
  --build=${CROSS_HOST} --host=${CROSS_TARGET64} \
  --prefix=/usr --libdir=/lib64 || \
    die "***config readline64 error" && \
      touch ${METADATAMIPS64ELROOTFS}/readline_config64
[ -f "${METADATAMIPS64ELROOTFS}/readline_build64" ] || \
  make -j${JOBS} || \
    die "***build readline64 error" && \
      touch ${METADATAMIPS64ELROOTFS}/readline_build64
[ -f "${METADATAMIPS64ELROOTFS}/readline_install64" ] || \
  make DESTDIR=${PREFIXMIPS64ELROOTFS} install || \
    die "***install readline64 error" && \
      touch ${METADATAMIPS64ELROOTFS}/readline_install64
[ -f "${METADATAMIPS64ELROOTFS}/readline_install64_doc" ] || \
  make DESTDIR=${PREFIXMIPS64ELROOTFS} install-doc || \
    die "***install readline64 doc error" && \
      touch ${METADATAMIPS64ELROOTFS}/readline_install64_doc
[ -f "${METADATAMIPS64ELROOTFS}/readline_move64_libs.a" ] || \
  mv -v ${PREFIXMIPS64ELROOTFS}/lib64/lib{readline,history}.a ${PREFIXMIPS64ELROOTFS}/usr/lib64 || \
    die "move readline64 libs.a" && \
      touch ${METADATAMIPS64ELROOTFS}/readline_move64_libs.a
[ -f "${METADATAMIPS64ELROOTFS}/readline_rm64_lib.so" ] || \
  rm -v ${PREFIXMIPS64ELROOTFS}/lib64/lib{readline,history}.so || \
    die "rm readline64 lib.so" && \
      touch ${METADATAMIPS64ELROOTFS}/readline_rm64_lib.so
[ -f "${METADATAMIPS64ELROOTFS}/readline_link64_libreadline.so" ] || \
  ln -sfv ../../lib64/libreadline.so.6 ${PREFIXMIPS64ELROOTFS}/usr/lib64/libreadline.so || \
    die "link readline64 libreadline.so" && \
      touch ${METADATAMIPS64ELROOTFS}/readline_link64_libreadline.so
[ -f "${METADATAMIPS64ELROOTFS}/readline_link64_libhistory.so" ] || \
  ln -sfv ../../lib64/libhistory.so.6 ${PREFIXMIPS64ELROOTFS}/usr/lib64/libhistory.so || \
    die "link readline64 libhistory.so" && \
      touch ${METADATAMIPS64ELROOTFS}/readline_link64_libhistory.so
popd

pushd ${BUILDMIPS64ELROOTFS}
[ -d "autoconf-cross-build" ] || mkdir autoconf-cross-build
cd autoconf-cross-build
[ -f "${METADATAMIPS64ELROOTFS}/autoconf_cross_config" ] || \
  CC="${CC} ${BUILD64}" ${SRCMIPS64ELROOTFS}/autoconf-${AUTOCONF_VERSION}/configure \
  --build=${CROSS_HOST} --host=${CROSS_TARGET64} --prefix=/usr || \
    die "***config autoconf error" && \
      touch ${METADATAMIPS64ELROOTFS}/autoconf_cross_config
[ -f "${METADATAMIPS64ELROOTFS}/autoconf_cross_build" ] || \
  make -j${JOBS} || \
    die "***build autoconf error" && \
      touch ${METADATAMIPS64ELROOTFS}/autoconf_cross_build
[ -f "${METADATAMIPS64ELROOTFS}/autoconf_cross_install" ] || \
  make DESTDIR=${PREFIXMIPS64ELROOTFS} install || \
    die "***install autoconf error" && \
      touch ${METADATAMIPS64ELROOTFS}/autoconf_cross_install
popd

pushd ${BUILDMIPS64ELROOTFS}
[ -d "automake-cross-build" ] || mkdir automake-cross-build
cd automake-cross-build
[ -f "${METADATAMIPS64ELROOTFS}/automake_cross_config" ] || \
  CC="${CC} ${BUILD64}" ${SRCMIPS64ELROOTFS}/automake-${AUTOMAKE_VERSION}/configure \
  --build=${CROSS_HOST} --host=${CROSS_TARGET64} --prefix=/usr || \
    die "***config automake error" && \
      touch ${METADATAMIPS64ELROOTFS}/automake_cross_config
[ -f "${METADATAMIPS64ELROOTFS}/automake_cross_build" ] || \
  make -j${JOBS} || \
    die "***build automake error" && \
      touch ${METADATAMIPS64ELROOTFS}/automake_cross_build
[ -f "${METADATAMIPS64ELROOTFS}/automake_cross_install" ] || \
  make DESTDIR=${PREFIXMIPS64ELROOTFS} install || \
    die "***install automake error" && \
      touch ${METADATAMIPS64ELROOTFS}/automake_cross_install
popd

pushd ${SRCMIPS64ELROOTFS}/bash-${BASH_VERSION}
[ -f "${METADATAMIPS64ELROOTFS}/bash_patch" ] || \
  patch -Np1 -i ${PATCH}/bash-4.2-branch_update-4.patch || \
    die "patch bash error" && \
      touch ${METADATAMIPS64ELROOTFS}/bash_patch
popd

pushd ${BUILDMIPS64ELROOTFS}
[ -d "bash-cross-build" ] || mkdir bash-cross-build
cd bash-cross-build
[ -f "${METADATAMIPS64ELROOTFS}/bash_cross_create_config.cache" ] || \
  `cat > config.cache << "EOF"
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
EOF` || \
    die "create bash config.cache error" && \
      touch ${METADATAMIPS64ELROOTFS}/bash_cross_create_config.cache
[ -f "${METADATAMIPS64ELROOTFS}/bash_cross_config" ] || \
  CC="${CC} ${BUILD64}" CXX="${CXX} ${BUILD64}" \
  ${SRCMIPS64ELROOTFS}/bash-${BASH_VERSION}/configure \
  --build=${CROSS_HOST} --host=${CROSS_TARGET64} \
  --prefix=/usr --bindir=/bin --cache-file=config.cache \
  --without-bash-malloc --with-installed-readline || \
    die "***config bash error" && \
      touch ${METADATAMIPS64ELROOTFS}/bash_cross_config
[ -f "${METADATAMIPS64ELROOTFS}/bash_cross_build" ] || \
  make -j${JOBS} || \
    die "***build bash error" && \
      touch ${METADATAMIPS64ELROOTFS}/bash_cross_build
[ -f "${METADATAMIPS64ELROOTFS}/bash_cross_install" ] || \
  make DESTDIR=${PREFIXMIPS64ELROOTFS} htmldir=/usr/share/doc/bash-4.2 install || \
    die "***install bash error" && \
      touch ${METADATAMIPS64ELROOTFS}/bash_cross_install
[ -f "${METADATAMIPS64ELROOTFS}/bash_cross_link_install" ] || \
  ln -svf bash ${PREFIXMIPS64ELROOTFS}/bin/sh || \
    die "***link bash error" && \
      touch ${METADATAMIPS64ELROOTFS}/bash_cross_link_install
popd

pushd ${BUILDMIPS64ELROOTFS}
[ -d "bzip2-32" ] || \
  cp -ar ${SRCMIPS64ELROOTFS}/bzip2-${BZIP2_VERSION} bzip2-32
cd bzip2-32
cp Makefile{,.orig}
sed -e "/^all:/s/ test//" Makefile.orig > Makefile
sed -i -e 's:ln -s -f $(PREFIX)/bin/:ln -s :' Makefile
[ -f "${METADATAMIPS64ELROOTFS}/bzip_build32_libz2_so" ] || \
  make -f Makefile-libbz2_so CC="${CC} ${BUILD32}" CXX="${CXX} ${BUILD32}" \
  AR="${AR}" RANLIB="${RANLIB}" || \
    die "bzip32 make -f Makefile-libbz2_so error" && \
      touch ${METADATAMIPS64ELROOTFS}/bzip_build32_libz2_so
[ -f "${METADATAMIPS64ELROOTFS}/bzip_clean32" ] || \
  make clean || \
    die "clean bzip32 error" && \
      touch ${METADATAMIPS64ELROOTFS}/bzip_clean32
[ -f "${METADATAMIPS64ELROOTFS}/bzip_build32" ] || \
  make CC="${CC} ${BUILD32}" CXX="${CXX} ${BUILD32}" AR="${AR}" \
  RANLIB="${RANLIB}" || \
    die "***build bzip32 error" && \
      touch ${METADATAMIPS64ELROOTFS}/bzip_build32
#make PREFIX=${PREFIXMIPS64ELROOTFS}/usr install || die "install bzip2 error"
#cp -v bzip2-shared ${PREFIXMIPS64ELROOTFS}/bin/bzip2
cp -v libbz2.a ${PREFIXMIPS64ELROOTFS}/usr/lib
cp -av libbz2.so* ${PREFIXMIPS64ELROOTFS}/lib
ln -sfv ../../lib/libbz2.so.1.0 ${PREFIXMIPS64ELROOTFS}/usr/lib/libbz2.so
#rm -v ${PREFIXMIPS64ELROOTFS}/usr/bin/{bunzip2,bzcat,bzip2}
#ln -sfv bzip2 ${PREFIXMIPS64ELROOTFS}/bin/bunzip2
#ln -sfv bzip2 ${PREFIXMIPS64ELROOTFS}/bin/bzcat
popd

pushd ${BUILDMIPS64ELROOTFS}
[ -d "bzip2-n32" ] || \
  cp -ar ${SRCMIPS64ELROOTFS}/bzip2-${BZIP2_VERSION} bzip2-n32
cd bzip2-n32
cp Makefile{,.orig} && \
sed -e "/^all:/s/ test//" Makefile.orig > Makefile
sed -i -e 's:ln -s -f $(PREFIX)/bin/:ln -s :' Makefile
sed -i 's@/lib\(/\| \|$\)@/lib32\1@g' Makefile
[ -f "${METADATAMIPS64ELROOTFS}/bzip_buildn32_libz2_so" ] || \
  make -f Makefile-libbz2_so CC="${CC} ${BUILDN32}" CXX="${CXX} ${BUILDN32}" \
  AR="${AR}" RANLIB="${RANLIB}" || \
    die "bzipn32 make -f Makefile-libbz2_so error" && \
      touch ${METADATAMIPS64ELROOTFS}/bzip_buildn32_libz2_so
[ -f "${METADATAMIPS64ELROOTFS}/bzip_cleann32" ] || \
  make clean || \
    die "clean bzipn32 error" && \
      touch ${METADATAMIPS64ELROOTFS}/bzip_cleann32
[ -f "${METADATAMIPS64ELROOTFS}/bzip_buildn32" ] || \
  make CC="${CC} ${BUILDN32}" CXX="${CXX} ${BUILDN32}" AR="${AR}" \
  RANLIB="${RANLIB}" || \
    die "***build bzipn32 error" && \
      touch ${METADATAMIPS64ELROOTFS}/bzip_buildn32
#make PREFIX=${PREFIXMIPS64ELROOTFS}/usr install || die "install bzip2 error"
#cp -v bzip2-shared ${PREFIXMIPS64ELROOTFS}/bin/bzip2
cp -v libbz2.a ${PREFIXMIPS64ELROOTFS}/usr/lib32
cp -av libbz2.so* ${PREFIXMIPS64ELROOTFS}/lib32
ln -sfv ../../lib32/libbz2.so.1.0 ${PREFIXMIPS64ELROOTFS}/usr/lib32/libbz2.so
#rm -v ${PREFIXMIPS64ELROOTFS}/usr/bin/{bunzip2,bzcat,bzip2}
#ln -sfv bzip2 ${PREFIXMIPS64ELROOTFS}/bin/bunzip2
#ln -sfv bzip2 ${PREFIXMIPS64ELROOTFS}/bin/bzcat
popd

pushd ${BUILDMIPS64ELROOTFS}
[ -d "bzip2-64" ] || \
  cp -ar ${SRCMIPS64ELROOTFS}/bzip2-${BZIP2_VERSION} bzip2-64
cd bzip2-64
cp Makefile{,.orig} && \
sed -e "/^all:/s/ test//" Makefile.orig > Makefile
sed -i -e 's:ln -s -f $(PREFIX)/bin/:ln -s :' Makefile
sed -i 's@/lib\(/\| \|$\)@/lib64\1@g' Makefile
[ -f "${METADATAMIPS64ELROOTFS}/bzip_build64_libz2_so" ] || \
  make -f Makefile-libbz2_so CC="${CC} ${BUILD64}" CXX="${CXX} ${BUILD64}" \
  AR="${AR}" RANLIB="${RANLIB}" || \
    die "bzip64 make -f Makefile-libbz2_so error" && \
      touch ${METADATAMIPS64ELROOTFS}/bzip_build64_libz2_so
[ -f "${METADATAMIPS64ELROOTFS}/bzip_clean64" ] || \
  make clean || \
    die "clean bzip64 error" && \
      touch ${METADATAMIPS64ELROOTFS}/bzip_clean64
[ -f "${METADATAMIPS64ELROOTFS}/bzip_build64" ] || \
  make CC="${CC} ${BUILD64}" CXX="${CXX} ${BUILD64}" AR="${AR}" \
  RANLIB="${RANLIB}" || \
    die "***build bzip64 error" && \
      touch ${METADATAMIPS64ELROOTFS}/bzip_build64
[ -f "${METADATAMIPS64ELROOTFS}/bzip64_install" ] || \
  make PREFIX=${PREFIXMIPS64ELROOTFS}/usr install || \
    die "install bzip2 error" && \
      touch ${METADATAMIPS64ELROOTFS}/bzip64_install
cp -v bzip2-shared ${PREFIXMIPS64ELROOTFS}/bin/bzip2
cp -av libbz2.so* ${PREFIXMIPS64ELROOTFS}/lib64
ln -sfv ../../lib64/libbz2.so.1.0 ${PREFIXMIPS64ELROOTFS}/usr/lib64/libbz2.so
rm -v ${PREFIXMIPS64ELROOTFS}/usr/bin/{bunzip2,bzcat,bzip2}
ln -sfv bzip2 ${PREFIXMIPS64ELROOTFS}/bin/bunzip2
ln -sfv bzip2 ${PREFIXMIPS64ELROOTFS}/bin/bzcat
popd

pushd ${BUILDMIPS64ELROOTFS}
[ -d diffutils-cross-build ] || \
  cp -ar ${SRCMIPS64ELROOTFS}/diffutils-${DIFFUTILS_VERSION} diffutils-cross-build
cd diffutils-cross-build
[ -f "${METADATAMIPS64ELROOTFS}/diffutils_cross_config" ] || \
  CC="${CC} ${BUILD64}" \
  ${SRCMIPS64ELROOTFS}/diffutils-${DIFFUTILS_VERSION}/configure --prefix=/usr \
  --build=${CROSS_HOST} --host=${CROSS_TARGET64} || \
    die "***config diffutils error" && \
      touch ${METADATAMIPS64ELROOTFS}/diffutils_cross_config
[ -f "${METADATAMIPS64ELROOTFS}/diffutils_cross_update_files" ] || \
  sed -i 's@\(^#define DEFAULT_EDITOR_PROGRAM \).*@\1"vi"@' lib/config.h || \
    die "update diffutils error" && \
      touch ${METADATAMIPS64ELROOTFS}/diffutils_cross_update_files
touch man/*.1
[ -f "${METADATAMIPS64ELROOTFS}/diffutils_cross_build" ] || \
  make -j${JOBS} || \
    die "***build diffutils error" && \
      touch ${METADATAMIPS64ELROOTFS}/diffutils_cross_build
[ -f "${METADATAMIPS64ELROOTFS}/diffutils_cross_install" ] || \
  make DESTDIR=${PREFIXMIPS64ELROOTFS} install || \
    die "***install diffutils error" && \
      touch ${METADATAMIPS64ELROOTFS}/diffutils_cross_install
popd

pushd ${BUILDMIPS64ELROOTFS}
[ -d file-32 ] || mkdir file-32
cd file-32
[ -f "${METADATAMIPS64ELROOTFS}/file_config32" ] || \
  CC="${CC} ${BUILD32}" \
  ${SRCMIPS64ELROOTFS}/file-${FILE11_VERSION}/configure --prefix=/usr \
  --build=${CROSS_HOST} --host=${CROSS_TARGET32} || \
    die "***config file32 error" && \
      touch ${METADATAMIPS64ELROOTFS}/file_config32
[ -f "${METADATAMIPS64ELROOTFS}/file_build32" ] || \
  make -j${JOBS} || \
    die "***build file32 error" && \
      touch ${METADATAMIPS64ELROOTFS}/file_build32
[ -f "${METADATAMIPS64ELROOTFS}/file_install32" ] || \
  make DESTDIR=${PREFIXMIPS64ELROOTFS} install || \
    die "***install file32 error" && \
      touch ${METADATAMIPS64ELROOTFS}/file_install32
popd

pushd ${BUILDMIPS64ELROOTFS}
[ -d file-n32 ] || \
  mkdir file-n32
cd file-n32
[ -f "${METADATAMIPS64ELROOTFS}/file_confign32" ] || \
  CC="${CC} ${BUILDN32}" \
  ${SRCMIPS64ELROOTFS}/file-${FILE11_VERSION}/configure --prefix=/usr \
  --build=${CROSS_HOST} --host=${CROSS_TARGET64} --libdir=/usr/lib32 || \
    die "***config filen32 error" && \
      touch ${METADATAMIPS64ELROOTFS}/file_confign32
[ -f "${METADATAMIPS64ELROOTFS}/file_buildn32" ] || \
  make -j${JOBS} || \
    die "***build filen32 error" && \
      touch ${METADATAMIPS64ELROOTFS}/file_buildn32
[ -f "${METADATAMIPS64ELROOTFS}/file_installn32" ] || \
  make DESTDIR=${PREFIXMIPS64ELROOTFS} install || \
    die "***install filen32 error" && \
      touch ${METADATAMIPS64ELROOTFS}/file_installn32
popd

pushd ${BUILDMIPS64ELROOTFS}
[ -d file-64 ] || \
  mkdir file-64
cd file-64
[ -f "${METADATAMIPS64ELROOTFS}/file_config64" ] || \
  CC="${CC} ${BUILD64}" \
  ${SRCMIPS64ELROOTFS}/file-${FILE11_VERSION}/configure --prefix=/usr \
  --build=${CROSS_HOST} --host=${CROSS_TARGET64} --libdir=/usr/lib64 || \
    die "***config file64 error" && \
      touch ${METADATAMIPS64ELROOTFS}/file_config64
[ -f "${METADATAMIPS64ELROOTFS}/file_build64" ] || \
  make -j${JOBS} || \
    die "***build file64 error" && \
      touch ${METADATAMIPS64ELROOTFS}/file_build64
[ -f "${METADATAMIPS64ELROOTFS}/file_install64" ] || \
  make DESTDIR=${PREFIXMIPS64ELROOTFS} install || \
    die "***install file64 error" && \
      touch ${METADATAMIPS64ELROOTFS}/file_install64
popd

pushd ${BUILDMIPS64ELROOTFS}
[ -d "findutils-cross-build" ] || mkdir findutils-cross-build
cd findutils-cross-build
[ -f "${METADATAMIPS64ELROOTFS}/findutils_cross_create_config.cache" ] || \
  `cat > config.cache << EOF
gl_cv_func_wcwidth_works=yes
gl_cv_header_working_fcntl_h=yes
ac_cv_func_fnmatch_gnu=yes
EOF` || \
    die "create diffutils config.cache error" && \
      touch ${METADATAMIPS64ELROOTFS}/findutils_cross_create_config.cache

[ -f "${METADATAMIPS64ELROOTFS}/findutils_cross_config" ] || \
  CC="${CC} ${BUILD64}" \
  ${SRCMIPS64ELROOTFS}/findutils-${FINDUTILS_VERSION}/configure \
  --build=${CROSS_HOST} --host=${CROSS_TARGET64} \
  --prefix=/usr --cache-file=config.cache \
  --libexecdir=/usr/lib64/locate \
  --localstatedir=/var/lib64/locate || \
    die "***config findutils error" && \
      touch ${METADATAMIPS64ELROOTFS}/findutils_cross_config
[ -f "${METADATAMIPS64ELROOTFS}/findutils_cross_buildusr" ] || \
  make -j${JOBS} || \
    die "***build findutils error" && \
      touch ${METADATAMIPS64ELROOTFS}/findutils_cross_buildusr
[ -f "${METADATAMIPS64ELROOTFS}/findutils_cross_installusr" ] || \
  make DESTDIR=${PREFIXMIPS64ELROOTFS} install || \
    die "***install findutils error" && \
      touch ${METADATAMIPS64ELROOTFS}/findutils_cross_installusr
mv -v ${PREFIXMIPS64ELROOTFS}/usr/bin/find ${PREFIXMIPS64ELROOTFS}/bin
cp ${PREFIXMIPS64ELROOTFS}/usr/bin/updatedb{,.orig}
sed 's@find:=${BINDIR}@find:=/bin@' ${PREFIXMIPS64ELROOTFS}/usr/bin/updatedb.orig > \
    ${PREFIXMIPS64ELROOTFS}/usr/bin/updatedb
rm ${PREFIXMIPS64ELROOTFS}/usr/bin/updatedb.orig
popd

pushd ${BUILDMIPS64ELROOTFS}
[ -d "gawk-cross-build" ] || mkdir gawk-cross-build
cd gawk-cross-build
[ -f "${METADATAMIPS64ELROOTFS}/gawk_cross_configusr" ] || \
[ -f "config.log" ] || \
  CC="${CC} ${BUILD64}" \
  ${SRCMIPS64ELROOTFS}/gawk-${GAWK_VERSION}/configure \
  --build=${CROSS_HOST} --host=${CROSS_TARGET64} \
  --prefix=/usr --libexecdir=/usr/lib64 \
  --disable-libsigsegv || \
    die "***config gawk error" && \
      touch ${METADATAMIPS64ELROOTFS}/gawk_cross_configusr
[ -f "${METADATAMIPS64ELROOTFS}/gawk_cross_buildusr" ] || \
  make -j${JOBS} || \
    die "***build gawk error" && \
      touch ${METADATAMIPS64ELROOTFS}/gawk_cross_buildusr
[ -f "${METADATAMIPS64ELROOTFS}/gawk_cross_installusr" ] || \
  make DESTDIR=${PREFIXMIPS64ELROOTFS} install || \
    die "***install gawk error" && \
      touch ${METADATAMIPS64ELROOTFS}/gawk_cross_installusr
popd

pushd ${BUILDMIPS64ELROOTFS}
[ -d gettext-32 ] || \
  mkdir gettext-32
cd gettext-32
#cd gettext-tools
#echo "gl_cv_func_wcwidth_works=yes" > config.cache
[ -f "${METADATAMIPS64ELROOTFS}/gettext_create32_config.cache" ] || \
  `cat > config.cache << EOF
am_cv_func_iconv_works=yes
gl_cv_func_wcwidth_works=yes
gt_cv_func_printf_posix=yes
gt_cv_int_divbyzero_sigfpe=yes
EOF` || \
    die "create gettext32 config.cache error" && \
      touch ${METADATAMIPS64ELROOTFS}/gettext_create32_config.cache
[ -f "${METADATAMIPS64ELROOTFS}/gettext_config32" ] || \
  CC="${CC} ${BUILD32}" CXX="${CXX} ${BUILD32}" \
  ${SRCMIPS64ELROOTFS}/gettext-${GETTEXT_VERSION}/configure --build=${CROSS_HOST} \
  --host=${CROSS_TARGET32} \
  --prefix=/usr --cache-file=config.cache || \
    die "***config gettext32 error" && \
      touch ${METADATAMIPS64ELROOTFS}/gettext_config32
#make -C gnulib-lib || die "***build gettext-32 gnulib-lib error"
#make -C src msgfmt || die "***build gettext-32 msgfmt error"
#cp -v src/msgfmt /tools/bin || die "***install gettext-32 error"
[ -f "${METADATAMIPS64ELROOTFS}/gettext_build32" ] || \
  make -j${JOBS} || \
    die "***build gettext32 error" && \
      touch ${METADATAMIPS64ELROOTFS}/gettext_build32
[ -f "${METADATAMIPS64ELROOTFS}/gettext_install32" ] || \
  make  DESTDIR=${PREFIXMIPS64ELROOTFS} install || \
    die "***install gettext32 error" && \
      touch ${METADATAMIPS64ELROOTFS}/gettext_install32
popd

pushd ${BUILDMIPS64ELROOTFS}
[ -d gettext-n32 ] || \
  mkdir gettext-n32
cd gettext-n32
#cd gettext-tools
#echo "gl_cv_func_wcwidth_works=yes" > config.cache
[ -f "${METADATAMIPS64ELROOTFS}/gettext_createn32_config.cache" ] || \
  `cat > config.cache << EOF
am_cv_func_iconv_works=yes
gl_cv_func_wcwidth_works=yes
gt_cv_func_printf_posix=yes
gt_cv_int_divbyzero_sigfpe=yes
EOF` || \
    die "create gettextn32 config.cache error" && \
      touch ${METADATAMIPS64ELROOTFS}/gettext_createn32_config.cache
[ -f "${METADATAMIPS64ELROOTFS}/gettext_confign32" ] || \
[ -f "config.log" ] || \
  CC="${CC} ${BUILDN32}" CXX="${CXX} ${BUILDN32}"  \
  ${SRCMIPS64ELROOTFS}/gettext-${GETTEXT_VERSION}/configure \
  --host=${CROSS_TARGET64} --build=${CROSS_HOST} \
  --prefix=/usr --cache-file=config.cache --libdir=/usr/lib32 || \
    die "***config gettextn32 error" && \
      touch ${METADATAMIPS64ELROOTFS}/gettext_confign32
#make -C gnulib-lib || die "***build gettext-n32 gnulib-lib error"
#make -C src msgfmt || die "***build gettext-n32 msgfmt error"
#cp -v src/msgfmt /tools/bin || die "***install gettext-n32 error"
[ -f "${METADATAMIPS64ELROOTFS}/gettext_buildn32" ] || \
  make -j${JOBS} || \
    die "***build gettextn32 error" && \
      touch ${METADATAMIPS64ELROOTFS}/gettext_buildn32
[ -f "${METADATAMIPS64ELROOTFS}/gettext_installn32" ] || \
  make  DESTDIR=${PREFIXMIPS64ELROOTFS} install || \
    die "***install gettextn32 error" && \
      touch ${METADATAMIPS64ELROOTFS}/gettext_installn32
popd

pushd ${BUILDMIPS64ELROOTFS}
[ -d gettext-64 ] || \
  mkdir gettext-64
cd gettext-64
#cd gettext-tools
#echo "gl_cv_func_wcwidth_works=yes" > config.cache
[ -f "${METADATAMIPS64ELROOTFS}/gettext_create64_config.cache" ] || \
  `cat > config.cache << EOF
am_cv_func_iconv_works=yes
gl_cv_func_wcwidth_works=yes
gt_cv_func_printf_posix=yes
gt_cv_int_divbyzero_sigfpe=yes
EOF` || \
    die "create gettext64 config.cache error" && \
      touch ${METADATAMIPS64ELROOTFS}/gettext_create64_config.cache
[ -f "${METADATAMIPS64ELROOTFS}/gettext_config64" ] || \
  CC="${CC} ${BUILD64}"  CXX="${CXX} ${BUILD64}" \
  ${SRCMIPS64ELROOTFS}/gettext-${GETTEXT_VERSION}/configure \
  --host=${CROSS_TARGET64} --build=${CROSS_HOST} \
  --prefix=/usr --cache-file=config.cache --libdir=/usr/lib64 || \
    die "***config gettext64 error" && \
      touch ${METADATAMIPS64ELROOTFS}/gettext_config64
#make -C gnulib-lib || die "***build gettext-64 gnulib-lib error"
#make -C src msgfmt || die "***build gettext-64 msgfmt error"
#cp -v src/msgfmt /tools/bin || die "***install gettext-64 error"
[ -f "${METADATAMIPS64ELROOTFS}/gettext_build64" ] || \
  make -j${JOBS} || \
    die "***build gettext64 error" && \
      touch ${METADATAMIPS64ELROOTFS}/gettext_build64
[ -f "${METADATAMIPS64ELROOTFS}/gettext_install64" ] || \
  make  DESTDIR=${PREFIXMIPS64ELROOTFS} install || \
    die "***install gettext64 error" && \
      touch ${METADATAMIPS64ELROOTFS}/gettext_install64
popd

pushd ${BUILDMIPS64ELROOTFS}
[ -d "grep-cross-build" ] || mkdir grep-cross-build
cd grep-cross-build
[ -f "${METADATAMIPS64ELROOTFS}/grep_cross_config" ] || \
  CC="${CC} ${BUILD64}" \
  ${SRCMIPS64ELROOTFS}/grep-${GREP_VERSION}/configure \
  --build=${CROSS_HOST} --host=${CROSS_TARGET64} \
  --prefix=/usr --bindir=/bin --disable-perl-regexp || \
    die "***config grep error" && \
      touch ${METADATAMIPS64ELROOTFS}/grep_cross_config
[ -f "${METADATAMIPS64ELROOTFS}/grep_cross_build" ] || \
  make -j${JOBS} || \
    die "***build grep error" && \
      touch ${METADATAMIPS64ELROOTFS}/grep_cross_build
[ -f "${METADATAMIPS64ELROOTFS}/grep_cross_install" ] || \
  make DESTDIR=${PREFIXMIPS64ELROOTFS} install || \
    die "***install grep error" && \
      touch ${METADATAMIPS64ELROOTFS}/grep_cross_install
popd

pushd ${SRCMIPS64ELROOTFS}/groff-${GROFF_VERSION}
# FIXME This is a sub dir config, it's very strange.
  pushd src/libs/gnulib/
  [ -f "${METADATAMIPS64ELROOTFS}/groff_cross_config_gnulib" ] || \
    CC="${CC} ${BUILD64}" CXX="${CXX} ${BUILD64}" \
    ./configure --build=${CROSS_HOST} --host=${CROSS_TARGET64} \
    --prefix=/usr --libdir=/usr/lib64 || \
      die "confgure groff/src/libs/gnulib" && \
        touch ${METADATAMIPS64ELROOTFS}/groff_cross_config_gnulib
  popd
[ -f "${METADATAMIPS64ELROOTFS}/groff_cross_config" ] || \
  CC="${CC} ${BUILD64}" CXX="${CXX} ${BUILD64}" \
  PAGE=A4 ./configure --host=${CROSS_TARGET64} --build=${CROSS_HOST} \
  --prefix=/usr --libdir=/usr/lib64 || \
    die "***config groffusr error" && \
      touch ${METADATAMIPS64ELROOTFS}/groff_cross_config
[ -f "${METADATAMIPS64ELROOTFS}/groff_cross_build" ] || \
  make TROFFBIN=troff GROFFBIN=groff GROFF_BIN_PATH= || \
    die "***build groffusr error" && \
      touch ${METADATAMIPS64ELROOTFS}/groff_cross_build
[ -f "${METADATAMIPS64ELROOTFS}/groff_cross_install" ] || \
  make DESTDIR=${PREFIXMIPS64ELROOTFS} install || \
    die "***install groffusr error" && \
      touch ${METADATAMIPS64ELROOTFS}/groff_cross_install
[ -f "${METADATAMIPS64ELROOTFS}/groff_cross_link_files" ] || \
  ln -sfv soelim ${PREFIXMIPS64ELROOTFS}/usr/bin/zsoelim && \
  ln -sfv eqn ${PREFIXMIPS64ELROOTFS}/usr/bin/geqn && \
  ln -sfv tbl ${PREFIXMIPS64ELROOTFS}/usr/bin/gtbl || \
    die "link groff files error" && \
      touch ${METADATAMIPS64ELROOTFS}/groff_cross_link_files
popd

pushd ${SRCMIPS64ELROOTFS}/gzip-${GZIP_VERSION}
[ -f "${METADATAMIPS64ELROOTFS}/gzip_update_files" ] || \
  `for file in $(grep -lr futimens *); do \
    sed -ie "s/futimens/gl_&/" ${file}; \
  done;` || \
    die "gzip update files error" && \
      touch ${METADATAMIPS64ELROOTFS}/gzip_update_files
popd

pushd ${BUILDMIPS64ELROOTFS}
[ -d "gzip-cross-build" ] || mkdir gzip-cross-build
cd gzip-cross-build
[ -f "${METADATAMIPS64ELROOTFS}/gzip_cross_configusr" ] || \
  CC="${CC} ${BUILD64}" ${SRCMIPS64ELROOTFS}/gzip-${GZIP_VERSION}/configure \
  --build=${CROSS_HOST} --host=${CROSS_TARGET64} \
  --prefix=/usr --bindir=/bin || \
    die "***config gzip error" && \
      touch ${METADATAMIPS64ELROOTFS}/gzip_cross_configusr
[ -f "${METADATAMIPS64ELROOTFS}/gzip_cross_buildusr" ] || \
  make -j${JOBS} || \
    die "***build gzip error" && \
      touch ${METADATAMIPS64ELROOTFS}/gzip_cross_buildusr
[ -f "${METADATAMIPS64ELROOTFS}/gzip_cross_installusr" ] || \
  make DESTDIR=${PREFIXMIPS64ELROOTFS} install || \
    die "***install gzip error" && \
      touch ${METADATAMIPS64ELROOTFS}/gzip_cross_installusr
[ -f "${METADATAMIPS64ELROOTFS}/bzip_cross_move_install" ] || \
  mv ${PREFIXMIPS64ELROOTFS}/bin/z{egrep,cmp,diff,fgrep,force,grep,less,more,new} \
     ${PREFIXMIPS64ELROOTFS}/usr/bin || \
    die "move bzip install files" && \
      touch ${METADATAMIPS64ELROOTFS}/bzip_cross_move_install
popd

pushd ${BUILDMIPS64ELROOTFS}
cd iputils-${IPUTILS_VERSION}
[ -f ${METADATAMIPS64ELROOTFS}/iputils_patchfix ] || \
  patch -Np1 -i ${PATCH}/iputils-s20101006-fixes-1.patch || \
    die "***patch fix iputils error" && \
      touch ${METADATAMIPS64ELROOTFS}/iputils_patchfix
[ -f ${METADATAMIPS64ELROOTFS}/iputils_patchdoc ] || \
  patch -Np1 -i ${PATCH}/iputils-s20101006-doc-1.patch || \
    die "***patch doc iputils error" && \
      touch ${METADATAMIPS64ELROOTFS}/iputils_patchdoc

[ -f "${METADATAMIPS64ELROOTFS}/iputils_cross_build" ] || \
  make CC="${CC} ${BUILD64}" \
  IPV4_TARGETS="tracepath ping clockdiff rdisc" \
  IPV6_TARGETS="tracepath6 traceroute6" -j${JOBS} || \
    die "***build iputils error" && \
      touch ${METADATAMIPS64ELROOTFS}/iputils_cross_build
[ -f "${METADATAMIPS64ELROOTFS}/iputils_cross_install_ping" ] || \
  install -v -m755 ping ${PREFIXMIPS64ELROOTFS}/bin || \
    die "install iputils ping error" && \
      touch ${METADATAMIPS64ELROOTFS}/iputils_cross_install_ping
#install -v -m755 arping ${PREFIXMIPS64ELROOTFS}/usr/bin
[ -f "${METADATAMIPS64ELROOTFS}/iputils_cross_install_clockdiff" ] || \
  install -v -m755 clockdiff ${PREFIXMIPS64ELROOTFS}/usr/bin || \
    die "install iputils clockdiff error" && \
      touch ${METADATAMIPS64ELROOTFS}/iputils_cross_install_clockdiff
[ -f "${METADATAMIPS64ELROOTFS}/iputils_cross_install_rdisc" ] || \
  install -v -m755 rdisc ${PREFIXMIPS64ELROOTFS}/usr/bin || \
    die "install iputils rdisc error" && \
      touch ${METADATAMIPS64ELROOTFS}/iputils_cross_install_rdisc
[ -f "${METADATAMIPS64ELROOTFS}/iputils_cross_install_tracepath" ] || \
  install -v -m755 tracepath ${PREFIXMIPS64ELROOTFS}/usr/bin || \
    die "install iputils tracepath error" && \
      touch ${METADATAMIPS64ELROOTFS}/iputils_cross_install_tracepath
[ -f "${METADATAMIPS64ELROOTFS}/iputils_cross_install_trace" ] || \
  install -v -m755 trace{path,route}6 ${PREFIXMIPS64ELROOTFS}/usr/bin || \
    die "iputils install trace error" && \
      touch ${METADATAMIPS64ELROOTFS}/iputils_cross_install_trace
[ -f "${METADATAMIPS64ELROOTFS}/iputils_cross_isntall_doc" ] || \
  install -v -m644 doc/*.8 ${PREFIXMIPS64ELROOTFS}/usr/share/man/man8 || \
    die "iputils install doc error" && \
      touch ${METADATAMIPS64ELROOTFS}/iputils_cross_isntall_doc
popd

pushd ${SRCMIPS64ELROOTFS}/kbd-${KBD_VERSION}
[ -f "${METADATAMIPS64ELROOTFS}/kbd_patch" ] || \
  patch -p1 < ${PATCH}/kbd-${KBD_VERSION}-es.po_fix-1.patch || \
    die "patch kbd error" && \
      touch ${METADATAMIPS64ELROOTFS}/kbd_patch
popd

pushd ${BUILDMIPS64ELROOTFS}
[ -d "kbd-cross-build" ] || mkdir kbd-cross-build
cd kbd-cross-build
[ -f "${METADATAMIPS64ELROOTFS}/kbd_cross_create_config.cache" ] || \
  `cat > config.cache << EOF
ac_cv_func_setpgrp_void=yes
ac_cv_func_malloc_0_nonnull=yes
ac_cv_func_realloc_0_nonnull=yes
EOF` || \
    die "create bkd config.cache" && \
      touch ${METADATAMIPS64ELROOTFS}/kbd_cross_create_config.cache
[ -f "${METADATAMIPS64ELROOTFS}/bkd_cross_config" ] || \
[ -f "config.log" ] || \
  CC="${CC} ${BUILD64}" \
  ${SRCMIPS64ELROOTFS}/kbd-${KBD_VERSION}/configure \
  --build=${CROSS_HOST} --host=${CROSS_TARGET64} \
  --prefix=/usr --cache-file=config.cache || \
    die "***config kbd error" && \
      touch ${METADATAMIPS64ELROOTFS}/bkd_cross_config
[ -f "${METADATAMIPS64ELROOTFS}/kbd_cross_build" ] || \
  make CC="${CC} ${BUILD64}" -j${JOBS} || \
    die "***build kbd error" && \
      touch ${METADATAMIPS64ELROOTFS}/kbd_cross_build
[ -f "${METADATAMIPS64ELROOTFS}/kbd_cross_install" ] || \
  make DESTDIR=${PREFIXMIPS64ELROOTFS} install || \
    die "***install kbd error" && \
      touch ${METADATAMIPS64ELROOTFS}/kbd_cross_install
[ -f "${METADATAMIPS64ELROOTFS}/kbd_cross_move_install" ] || \
  mv -v ${PREFIXMIPS64ELROOTFS}/usr/bin/{kbd_mode,dumpkeys,loadkeys,openvt,setfont} \
        ${PREFIXMIPS64ELROOTFS}/bin || \
    die "move kbd install files" && \
      touch ${METADATAMIPS64ELROOTFS}/kbd_cross_move_install
popd

pushd ${BUILDMIPS64ELROOTFS}
[ -d "less-cross-buildusr" ] || \
  cp -ar ${SRCMIPS64ELROOTFS}/less-${LESS_VERSION} less-cross-buildusr
cd less-cross-buildusr
[ -f "${METADATAMIPS64ELROOTFS}/less_cross_configusr" ] || \
  CC="${CC} ${BUILD64}" \
  CXX="${CXX} ${BUILD64}" \
  ${SRCMIPS64ELROOTFS}/less-${LESS_VERSION}/configure \
  --build=${CROSS_HOST} --host=${CROSS_TARGET64} \
  --prefix=/usr --sysconfdir=/etc || \
    die "***config less error" && \
      touch ${METADATAMIPS64ELROOTFS}/less_cross_configusr
[ -f "${METADATAMIPS64ELROOTFS}/less_cross_buildusr" ] || \
  make -j${JOBS} || \
    die "***build less error" && \
      touch ${METADATAMIPS64ELROOTFS}/less_cross_buildusr
[ -f "${METADATAMIPS64ELROOTFS}/less_cross_installusr" ] || \
  make prefix=${PREFIXMIPS64ELROOTFS}/usr install || \
    die "***install less error" && \
      touch ${METADATAMIPS64ELROOTFS}/less_cross_installusr
[ -f "${METADATAMIPS64ELROOTFS}/less_cross_move_install" ] || \
  mv -v ${PREFIXMIPS64ELROOTFS}/usr/bin/less ${PREFIXMIPS64ELROOTFS}/bin || \
    die "move less install" && \
      touch ${METADATAMIPS64ELROOTFS}/less_cross_move_install
popd

pushd ${BUILDMIPS64ELROOTFS}
[ -d "make-cross-buildusr" ] || mkdir make-cross-buildusr
cd make-cross-buildusr
[ -f "${METADATAMIPS64ELROOTFS}/make_cross_config" ] || \
  CC="${CC} ${BUILD64}" \
  ${SRCMIPS64ELROOTFS}/make-${MAKE_VERSION}/configure --prefix=/usr \
  --build=${CROSS_HOST} --host=${CROSS_TARGET64} || \
    die "***config make error" && \
      touch ${METADATAMIPS64ELROOTFS}/make_cross_config
[ -f "${METADATAMIPS64ELROOTFS}/make_cross_build" ] || \
  make -j${JOBS} || \
    die "***build make error" && \
      touch ${METADATAMIPS64ELROOTFS}/make_cross_build
[ -f "${METADATAMIPS64ELROOTFS}/make_cross_install" ] || \
  make DESTDIR=${PREFIXMIPS64ELROOTFS} install || \
    die "***install make error" && \
      touch ${METADATAMIPS64ELROOTFS}/make_cross_install
popd

pushd ${BUILDMIPS64ELROOTFS}
[ -d "man-cross-build" ] || \
  cp -ar ${SRCMIPS64ELROOTFS}/man-${MAN_VERSION} man-cross-build
cd man-cross-build

[ -f "${METADATAMIPS64ELROOTFS}/man_cross_update_files" ] || \
  cp configure{,.orig} && \
  sed -e "/PREPATH=/s@=.*@=\"$(eval echo ${PREFIXMIPS64ELROOTFS}/{,usr/}{sbin,bin})\"@g" \
      -e 's@-is@&R@g' configure.orig > configure && \
  cp src/man.conf.in{,.orig} && \
  sed -e 's@MANPATH./usr/man@#&@g' \
      -e 's@MANPATH./usr/local/man@#&@g' \
      src/man.conf.in.orig > src/man.conf.in || \
    die "man update files error" && \
      touch ${METADATAMIPS64ELROOTFS}/man_cross_update_files

[ -f "${METADATAMIPS64ELROOTFS}/man_cross_config" ] || \
  CC="${CC} ${BUILD64}" ./configure -confdir=/etc || \
    die "***config man error" && \
      touch ${METADATAMIPS64ELROOTFS}/man_cross_config

[ -f "${METADATAMIPS64ELROOTFS}/man_cross_update_conf_script" ] || \
  cp conf_script{,.orig} && \
  sed "s@${PREFIXMIPS64ELROOTFS}@@" conf_script.orig > conf_script || \
    die "update man conf_script error" && \
      touch ${METADATAMIPS64ELROOTFS}/man_cross_update_conf_script
[ -f "${METADATAMIPS64ELROOTFS}/man_cross_compile_makemes" ] || \
  gcc src/makemsg.c -o src/makemsg || \
    die "build makemsg error" && \
      touch ${METADATAMIPS64ELROOTFS}/man_cross_compile_makemes
[ -f "${METADATAMIPS64ELROOTFS}/man_cross_build" ] || \
  make -j${JOBS} || \
    die "***build man error" && \
      touch ${METADATAMIPS64ELROOTFS}/man_cross_build
[ -f "${METADATAMIPS64ELROOTFS}/man_cross_install" ] || \
  make DESTDIR=${PREFIXMIPS64ELROOTFS} PREFIX="" install || \
    die "***install man error" && \
      touch ${METADATAMIPS64ELROOTFS}/man_cross_install
popd

pushd ${BUILDMIPS64ELROOTFS}
[ -d "module-init-cross-buildusr" ] || mkdir module-init-cross-buildusr
cd module-init-cross-buildusr
[ -f "${METADATAMIPS64ELROOTFS}/module-init-tools_cross_config" ] || \
  CC="${CC} ${BUILD64}" CXX="${CXX} ${BUILD64}" \
  ${SRCMIPS64ELROOTFS}/module-init-tools-${MODULE_VERSION}/configure \
  --build=${CROSS_HOST} --host=${CROSS_TARGET64} \
  --prefix=/usr --bindir=/bin --libdir=/usr/lib64 \
  --sbindir=/sbin --libexecdir=/usr/lib64 --enable-zlib-dynamic || \
    die "***config module-init-tools error" && \
      touch ${METADATAMIPS64ELROOTFS}/module-init-tools_cross_config
[ -f "${METADATAMIPS64ELROOTFS}/module-init-tools_cross_build" ] || \
  make DOCBOOKTOMAN= || \
    die "***build module-init-tools error" && \
      touch ${METADATAMIPS64ELROOTFS}/module-init-tools_cross_build
[ -f "${METADATAMIPS64ELROOTFS}/module-init-tools_cross_install" ] || \
  make DESTDIR=${PREFIXMIPS64ELROOTFS} INSTALL=install install || \
    die "***install module-init-tools error" && \
      touch ${METADATAMIPS64ELROOTFS}/module-init-tools_cross_install
popd

pushd ${BUILDMIPS64ELROOTFS}
[ -d "patch-cross-buildusr" ] || mkdir patch-cross-buildusr
cd patch-cross-buildusr
[ -f "${METADATAMIPS64ELROOTFS}/patch_cross_create_config.cache" ] || \
  `cat > config.cache << EOF
ac_cv_path_ed_PROGRAM=ed
ac_cv_func_strnlen_working=yes
EOF` || \
    die "create patch config.cache error" && \
      touch ${METADATAMIPS64ELROOTFS}/patch_cross_create_config.cache
[ -f "${METADATAMIPS64ELROOTFS}/patch_cross_config" ] || \
  CC="${CC} ${BUILD64}" \
  ${SRCMIPS64ELROOTFS}/patch-${PATCH_VERSION}/configure \
  --build=${CROSS_HOST} --host=${CROSS_TARGET64} \
  --prefix=/usr --cache-file=config.cache || \
    die "***config patch error" && \
      touch ${METADATAMIPS64ELROOTFS}/patch_cross_config
[ -f "${METADATAMIPS64ELROOTFS}/patch_cross_build" ] || \
  make -j${JOBS} || \
    die "***build patch error" && \
      touch ${METADATAMIPS64ELROOTFS}/patch_cross_build
[ -f "${METADATAMIPS64ELROOTFS}/patch_cross_install" ] || \
  make prefix=${PREFIXMIPS64ELROOTFS}/usr install || \
    die "***install patch error" && \
      touch ${METADATAMIPS64ELROOTFS}/patch_cross_install
popd

pushd ${BUILDMIPS64ELROOTFS}
[ -d "psmisc-cross-buildusr" ] || mkdir psmisc-cross-buildusr
cd psmisc-cross-buildusr
[ -f "${METADATAMIPS64ELROOTFS}/psmisc_cross_create_config.cache" ] || \
  `cat > config.cache << EOF
ac_cv_func_malloc_0_nonnull=yes
ac_cv_func_realloc_0_nonnull=yes
EOF` || \
    die "create psmisc config.cache" && \
      touch ${METADATAMIPS64ELROOTFS}/psmisc_cross_create_config.cache
[ -f "${METADATAMIPS64ELROOTFS}/psmisc_cross_config" ] || \
[ -f "config.log" ] || CC="${CC} ${BUILD64}" \
  ${SRCMIPS64ELROOTFS}/psmisc-${PSMISC_VERSION}/configure \
  --build=${CROSS_HOST} --host=${CROSS_TARGET64} \
  --prefix=/usr --exec-prefix="" --cache-file=config.cache || \
    die "***config psmisc error" && \
      touch ${METADATAMIPS64ELROOTFS}/psmisc_cross_config
[ -f "${METADATAMIPS64ELROOTFS}/psmisc_cross_build" ] || \
  make -j${JOBS} || \
    die "***build psmisc error" && \
      touch ${METADATAMIPS64ELROOTFS}/psmisc_cross_build
[ -f "${METADATAMIPS64ELROOTFS}/psmisc_cross_install" ] || \
  make DESTDIR=${PREFIXMIPS64ELROOTFS} install || \
    die "***install psmisc error" && \
      touch ${METADATAMIPS64ELROOTFS}/psmisc_cross_install
[ -f "${METADATAMIPS64ELROOTFS}/psmisc_cross_update_install" ] || \
  mv -v ${PREFIXMIPS64ELROOTFS}/bin/pstree* ${PREFIXMIPS64ELROOTFS}/usr/bin && \
  ln -sfv killall ${PREFIXMIPS64ELROOTFS}/bin/pidof || \
    die "update psmisc install files error" && \
      touch ${METADATAMIPS64ELROOTFS}/psmisc_cross_update_install
popd

pushd ${BUILDMIPS64ELROOTFS}
[ -d "shadow-cross-buildusr" ] || \
  cp -ar ${SRCMIPS64ELROOTFS}/shadow-${SHADOW_VERSION} shadow-cross-buildusr
cd shadow-cross-buildusr
[ -f "${METADATAMIPS64ELROOTFS}/shadow_cross_create_config.cache" ] || \
  `cat > config.cache << EOF
ac_cv_func_setpgrp_void=yes
EOF` || \
    die "create shadow config.cache" && \
      touch ${METADATAMIPS64ELROOTFS}/shadow_cross_create_config.cache
[ -f "${METADATAMIPS64ELROOTFS}/shadow_cross_configusr" ] || \
  CC="${CC} ${BUILD64}" \
  ./configure \
  --build=${CROSS_HOST} --host=${CROSS_TARGET64} \
  --sysconfdir=/etc --without-libpam \
  --without-audit --without-selinux \
  --cache-file=config.cache || \
    die "***config shadow error" && \
      touch ${METADATAMIPS64ELROOTFS}/shadow_cross_configusr
cp src/Makefile{,.orig}
sed 's/groups$(EXEEXT) //' src/Makefile.orig > src/Makefile
for mkf in $(find man -name Makefile); do
  cp ${mkf}{,.orig};
  sed -e '/groups.1.xml/d' -e 's/groups.1 //' ${mkf}.orig > ${mkf};
done;

[ -f "${METADATAMIPS64ELROOTFS}/shadow_cross_buildusr" ] || \
  make -j${JOBS} || \
    die "***build shadow error" && \
      touch ${METADATAMIPS64ELROOTFS}/shadow_cross_buildusr
[ -f "${METADATAMIPS64ELROOTFS}/shadow_cross_installusr" ] || \
  make DESTDIR=${PREFIXMIPS64ELROOTFS} install || \
    die "***install shadow error" && \
      touch ${METADATAMIPS64ELROOTFS}/shadow_cross_installusr

cp ${PREFIXMIPS64ELROOTFS}/etc/login.defs login.defs.orig
sed -e's@#MD5_CRYPT_ENAB.no@MD5_CRYPT_ENAB yes@' \
    -e 's@/var/spool/mail@/var/mail@' \
    login.defs.orig > ${PREFIXMIPS64ELROOTFS}/etc/login.defs
mv -v ${PREFIXMIPS64ELROOTFS}/usr/bin/passwd ${PREFIXMIPS64ELROOTFS}/bin
popd

pushd ${BUILDMIPS64ELROOTFS}
[ -d "gdb-cross-buildusr" ] || mkdir gdb-cross-buildusr
cd gdb-cross-buildusr
[ -f "${METADATAMIPS64ELROOTFS}/gdb_cross_configusr" ] || \
  CC="${CC} ${BUILD64}" CXX="${CXX} ${BUILD64}" \
  ${SRCMIPS64ELROOTFS}/gdb-${GDB_VERSION}/configure \
  --prefix=${PREFIXMIPS64ELROOTFS} \
  --build=${CROSS_HOST} --host=${CROSS_TARGET64} --target=${CROSS_TARGET64} \
  --with-gmp=${PREFIXMIPS64ELROOTFS}/cross-tools \
  --with-mpfr=${PREFIXMIPS64ELROOTFS}/cross-tools \
  --with-mpc=${PREFIXMIPS64ELROOTFS}/cross-tools || \
    die "config gdb error" && \
      touch ${METADATAMIPS64ELROOTFS}/gdb_cross_configusr
[ -f "${METADATAMIPS64ELROOTFS}/gdb_cross_build" ] || \
  make -j${JOBS} || \
    die "***build gdb error" && \
      touch ${METADATAMIPS64ELROOTFS}/gdb_cross_build
[ -f "${METADATAMIPS64ELROOTFS}/gdb_cross_install" ] || \
  make install || \
    die "***install gdb error" && \
      touch ${METADATAMIPS64ELROOTFS}/gdb_cross_install
popd

# Use make, not make -j${JOBS}
pushd ${BUILDMIPS64ELROOTFS}
[ -d libestr-32 ] || \
  mkdir libestr-32
cd libestr-32
[ -f "${METADATAMIPS64ELROOTFS}/libestr_create32_config.cache" ] || \
  `cat > config.cache << EOF
ac_cv_func_malloc_0_nonnull=yes
ac_cv_func_realloc_0_nonnull=yes
EOF` || \
    die "create libestr32 config.cache error" && \
      touch ${METADATAMIPS64ELROOTFS}/libestr_create32_config.cache
[ -f "${METADATAMIPS64ELROOTFS}/libestr_config32" ] || \
  CC="${CC} ${BUILD32}" \
  ${SRCMIPS64ELROOTFS}/libestr-${LIBESTR_VERSION}/configure \
  --build=${CROSS_HOST} --host=${CROSS_TARGET32} \
  --prefix=/usr --sbindir=/sbin \
  --cache-file=config.cache || \
    die "***config libestr32 error" && \
      touch ${METADATAMIPS64ELROOTFS}/libestr_config32
[ -f "${METADATAMIPS64ELROOTFS}/libestr_build32" ] || \
  make -j${JOBS} || \
    die "***build libestr32 error" && \
      touch ${METADATAMIPS64ELROOTFS}/libestr_build32
[ -f "${METADATAMIPS64ELROOTFS}/libestr_install32" ] || \
  make DESTDIR=${PREFIXMIPS64ELROOTFS} install || \
    die "***install libestr32 error" && \
      touch ${METADATAMIPS64ELROOTFS}/libestr_install32
[ -f "${METADATAMIPS64ELROOTFS}/libestr_rm32_la_files" ] || \
  rm ${PREFIXMIPS64ELROOTFS}/usr/lib/libestr.la || \
    die "rm libestr32 la files error" && \
      touch ${METADATAMIPS64ELROOTFS}/libestr_rm32_la_files
popd

pushd ${BUILDMIPS64ELROOTFS}
[ -d libestr-n32 ] || \
  mkdir libestr-n32
cd libestr-n32
[ -f "${METADATAMIPS64ELROOTFS}/libestr_createn32_config.cache" ] || \
  `cat > config.cache << EOF
ac_cv_func_malloc_0_nonnull=yes
ac_cv_func_realloc_0_nonnull=yes
EOF` || \
    die "libestr createn32 config.cache" && \
      touch ${METADATAMIPS64ELROOTFS}/libestr_createn32_config.cache
[ -f "${METADATAMIPS64ELROOTFS}/libestr_confign32" ] || \
  CC="${CC} ${BUILDN32}" \
  ${SRCMIPS64ELROOTFS}/libestr-${LIBESTR_VERSION}/configure \
  --build=${CROSS_HOST} --host=${CROSS_TARGET64} \
  --prefix=/usr --sbindir=/sbin \
  --cache-file=config.cache --libdir=/usr/lib32 || \
    die "***config libestrn32 error" && \
      touch ${METADATAMIPS64ELROOTFS}/libestr_confign32
[ -f "${METADATAMIPS64ELROOTFS}/libestr_buildn32" ] || \
  make -j${JOBS} || \
    die "***build libestrn32 error" && \
      touch ${METADATAMIPS64ELROOTFS}/libestr_buildn32
[ -f "${METADATAMIPS64ELROOTFS}/libestr_installn32" ] || \
  make DESTDIR=${PREFIXMIPS64ELROOTFS} install || \
    die "***install libestrn32 error" && \
      touch ${METADATAMIPS64ELROOTFS}/libestr_installn32
[ -f "${METADATAMIPS64ELROOTFS}/libestr_rmn32_la_files" ] || \
  rm ${PREFIXMIPS64ELROOTFS}/usr/lib32/libestr.la || \
    die "rm libestrn32 la files error" && \
      touch ${METADATAMIPS64ELROOTFS}/libestr_rmn32_la_files
popd

pushd ${BUILDMIPS64ELROOTFS}
[ -d libestr-64 ] || \
  mkdir libestr-64
cd libestr-64
[ -f "${METADATAMIPS64ELROOTFS}/libestr_create64_config.cache" ] || \
  `cat > config.cache << EOF
ac_cv_func_malloc_0_nonnull=yes
ac_cv_func_realloc_0_nonnull=yes
EOF` || \
    die "create libestr64 config.cache" && \
      touch ${METADATAMIPS64ELROOTFS}/libestr_create64_config.cache
[ -f "${METADATAMIPS64ELROOTFS}/libestr_config64" ] || \
  CC="${CC} ${BUILD64}" \
  ${SRCMIPS64ELROOTFS}/libestr-${LIBESTR_VERSION}/configure \
  --build=${CROSS_HOST} --host=${CROSS_TARGET64} \
  --prefix=/usr --sbindir=/sbin \
  --cache-file=config.cache --libdir=/usr/lib64 || \
    die "***config libestr64 error" && \
      touch ${METADATAMIPS64ELROOTFS}/libestr_config64
[ -f "${METADATAMIPS64ELROOTFS}/libestr_build64" ] || \
  make -j${JOBS} || \
    die "***build libestr64 error" && \
      touch ${METADATAMIPS64ELROOTFS}/libestr_build64
[ -f "${METADATAMIPS64ELROOTFS}/libestr_install64" ] || \
  make DESTDIR=${PREFIXMIPS64ELROOTFS} install || \
    die "***install libestr64 error" && \
      touch ${METADATAMIPS64ELROOTFS}/libestr_install64
[ -f "${METADATAMIPS64ELROOTFS}/libestr_rm64_la_files" ] || \
rm ${PREFIXMIPS64ELROOTFS}/usr/lib64/libestr.la || \
  die "rm libestr64 la files error" && \
    touch ${METADATAMIPS64ELROOTFS}/libestr_rm64_la_files
popd

# Use make, not make -j${JOBS}
pushd ${BUILDMIPS64ELROOTFS}
[ -d libee-32 ] || mkdir libee-32
cd libee-32
[ -f "${METADATAMIPS64ELROOTFS}/libee_create32_config.cache" ] || \
  `cat > config.cache << EOF
ac_cv_func_malloc_0_nonnull=yes
ac_cv_func_realloc_0_nonnull=yes
EOF` || \
    die "create libee32 config.cache" && \
      touch ${METADATAMIPS64ELROOTFS}/libee_create32_config.cache
[ -f "${METADATAMIPS64ELROOTFS}/libee_config32" ] || PKG_CONFIG=true \
  CC="${CC} ${BUILD32}" \
  LDFLAGS="-lestr" \
  PKG_CONFIG_LIBDIR=${PREFIXMIPS64ELROOTFS}/usr/lib \
  PKG_CONFIG_PATH=${PREFIXMIPS64ELROOTFS}/usr/lib/pkgconfig \
  ${SRCMIPS64ELROOTFS}/libee-${LIBEE_VERSION}/configure --build=${CROSS_HOST} \
  --host=${CROSS_TARGET32} --prefix=/usr --sbindir=/sbin \
  --cache-file=config.cache || \
    die "***config libee32 error" && \
      touch ${METADATAMIPS64ELROOTFS}/libee_config32
[ -f "${METADATAMIPS64ELROOTFS}/libee_build32" ] || \
  make || \
    die "***build libee32 error" && \
      touch ${METADATAMIPS64ELROOTFS}/libee_build32
[ -f "${METADATAMIPS64ELROOTFS}/libee_install32" ] || \
  make DESTDIR=${PREFIXMIPS64ELROOTFS} install || \
    die "***install libee32 error" && \
      touch ${METADATAMIPS64ELROOTFS}/libee_install32
[ -f "${METADATAMIPS64ELROOTFS}/libee_rm32_la_files" ] || \
  rm ${PREFIXMIPS64ELROOTFS}/usr/lib/libee.la || \
    die "rm libee32 la files" && \
      touch ${METADATAMIPS64ELROOTFS}/libee_rm32_la_files
popd

pushd ${BUILDMIPS64ELROOTFS}
[ -d libee-n32 ] || \
  mkdir libee-n32
cd libee-n32
[ -f "${METADATAMIPS64ELROOTFS}/libee_createn32_config.cache" ] || \
  `cat > config.cache << EOF
ac_cv_func_malloc_0_nonnull=yes
ac_cv_func_realloc_0_nonnull=yes
EOF` || \
    die "create libee32 config.cache" && \
      touch ${METADATAMIPS64ELROOTFS}/libee_createn32_config.cache
[ -f "${METADATAMIPS64ELROOTFS}/libee_confign32" ] || PKG_CONFIG=true \
  CC="${CC} ${BUILDN32}" \
  LDFLAGS="-lestr" \
  PKG_CONFIG_LIBDIR=${PREFIXMIPS64ELROOTFS}/usr/lib32 \
  PKG_CONFIG_PATH=${PREFIXMIPS64ELROOTFS}/usr/lib32/pkgconfig \
  ${SRCMIPS64ELROOTFS}/libee-${LIBEE_VERSION}/configure --build=${CROSS_HOST} \
  --host=${CROSS_TARGET64} --prefix=/usr --sbindir=/sbin \
  --cache-file=config.cache --libdir=/usr/lib32 || \
    die "***config libeen32 error" && \
      touch ${METADATAMIPS64ELROOTFS}/libee_confign32
[ -f "${METADATAMIPS64ELROOTFS}/libee_buildn32" ] || \
  make || \
    die "***build libeen32 error" && \
      touch ${METADATAMIPS64ELROOTFS}/libee_buildn32
[ -f "${METADATAMIPS64ELROOTFS}/libee_installn32" ] || \
  make DESTDIR=${PREFIXMIPS64ELROOTFS} install || \
    die "***install libeen32 error" && \
      touch ${METADATAMIPS64ELROOTFS}/libee_installn32
[ -f "${METADATAMIPS64ELROOTFS}/libee_rmn32_la_files" ] || \
  rm ${PREFIXMIPS64ELROOTFS}/usr/lib32/libee.la || \
    die "rm libn32 la files error" && \
      touch ${METADATAMIPS64ELROOTFS}/libee_rmn32_la_files
popd

pushd ${BUILDMIPS64ELROOTFS}
[ -d libee-64 ] || \
  mkdir libee-64
cd libee-64
[ -f "${METADATAMIPS64ELROOTFS}/libee_create64_config.cache" ] || \
  `cat > config.cache << EOF
ac_cv_func_malloc_0_nonnull=yes
ac_cv_func_realloc_0_nonnull=yes
EOF` || \
    die "create libee64 config.cache error" && \
      touch ${METADATAMIPS64ELROOTFS}/libee_create64_config.cache
[ -f "${METADATAMIPS64ELROOTFS}/libee_config64" ] || PKG_CONFIG=true \
  CC="${CC} ${BUILD64}" \
  LDFLAGS="-lestr" \
  PKG_CONFIG_LIBDIR=${PREFIXMIPS64ELROOTFS}/usr/lib64 \
  PKG_CONFIG_PATH=${PREFIXMIPS64ELROOTFS}/usr/lib64/pkgconfig \
  ${SRCMIPS64ELROOTFS}/libee-${LIBEE_VERSION}/configure --build=${CROSS_HOST} \
  --host=${CROSS_TARGET64} --prefix=/usr --sbindir=/sbin \
  --cache-file=config.cache --libdir=/usr/lib64 || \
    die "***config libee64 error" && \
      touch ${METADATAMIPS64ELROOTFS}/libee_config64
[ -f "${METADATAMIPS64ELROOTFS}/libee_build64" ] || \
make || \
  die "***build libee64 error" && \
    touch ${METADATAMIPS64ELROOTFS}/libee_build64
[ -f "${METADATAMIPS64ELROOTFS}/libee_install64" ] || \
make DESTDIR=${PREFIXMIPS64ELROOTFS} install || \
  die "***install libee64 error" && \
    touch ${METADATAMIPS64ELROOTFS}/libee_install64
[ -f "${METADATAMIPS64ELROOTFS}/libee_rm64_la_files" ] || \
  rm ${PREFIXMIPS64ELROOTFS}/usr/lib64/libee.la || \
    die "rm libee64 la files" && \
      touch ${METADATAMIPS64ELROOTFS}/libee_rm64_la_files
popd

# FIXME rebuild later, need build libestr
pushd ${BUILDMIPS64ELROOTFS}
[ -d "rsyslog-cross-buildusr" ] || mkdir rsyslog-cross-buildusr
cd rsyslog-cross-buildusr
[ -f "${METADATAMIPS64ELROOTFS}/rsyslog_cross_create_config.cache" ] || \
  `cat > config.cache << EOF
ac_cv_func_malloc_0_nonnull=yes
ac_cv_func_realloc_0_nonnull=yes
EOF` || \
    die "create rsyslog config.cache error" && \
      touch ${METADATAMIPS64ELROOTFS}/rsyslog_cross_create_config.cache
[ -f "${METADATAMIPS64ELROOTFS}/rsyslog_cross_config" ] || \
  CC="${CC} ${BUILD64}" \
  PKG_CONFIG_LIBDIR=${PREFIXMIPS64ELROOTFS}/usr/lib64/ \
  PKG_CONFIG_PATH=${PREFIXMIPS64ELROOTFS}/usr/lib64/pkgconfig \
  LDFLAGS="-L${PREFIXMIPS64ELROOTFS}/usr/lib64/ -lestr" \
  ${SRCMIPS64ELROOTFS}/rsyslog-${RSYSLOG_VERSION}/configure \
  --build=${CROSS_HOST} --host=${CROSS_TARGET64} \
  --prefix=/usr --sbindir=/sbin --cache-file=config.cache || \
    die "***config rsyslog error" && \
      touch ${METADATAMIPS64ELROOTFS}/rsyslog_cross_config
[ -f "${METADATAMIPS64ELROOTFS}/rsyslog_cross_build" ] || \
  make -j${JOBS} || \
    die "***build rsyslog error" && \
      touch ${METADATAMIPS64ELROOTFS}/rsyslog_cross_build
[ -f "${METADATAMIPS64ELROOTFS}/rsyslog_cross_install" ] || \
  make DESTDIR=${PREFIXMIPS64ELROOTFS} install || \
    die "***install rsyslog error" && \
      touch ${METADATAMIPS64ELROOTFS}/rsyslog_cross_install
[ -f "${METADATAMIPS64ELROOTFS}/rsylog_cross_install_rsyslog.d" ] || \
  install -dv ${PREFIXMIPS64ELROOTFS}/etc/rsyslog.d || \
    die "install rsyslog.d error" && \
      touch ${METADATAMIPS64ELROOTFS}/rsylog_cross_install_rsyslog.d
popd

[ -f "${METADATAMIPS64ELROOTFS}/create_rsyslog.conf" ] || \
`cat > ${PREFIXMIPS64ELROOTFS}/etc/rsyslog.conf << "EOF"
# Begin /etc/rsyslog.conf

# PREFIXMIPS64ELROOTFS configuration of rsyslog. For more info use man rsyslog.conf

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
daemon.*                              -/var/log/daemon.log
kern.*                                -/var/log/kern.log
lpr.*                                 -/var/log/lpr.log
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
  die "create rsyslog.conf error" && \
    touch ${METADATAMIPS64ELROOTFS}/create_rsyslog.conf

pushd ${BUILDMIPS64ELROOTFS}
[ -d "sysvinit-cross-buildusr" ] || \
  cp -ar ${SRCMIPS64ELROOTFS}/sysvinit-${SYSVINIT_VERSION} sysvinit-cross-buildusr
cd sysvinit-cross-buildusr
[ -f "${METADATAMIPS64ELROOTFS}/sysvinit_cross_update_files" ] || \
  cp -v src/Makefile src/Makefile.orig && \
  sed -e 's@/dev/initctl@$(ROOT)&@g' \
      -e 's@\(mknod \)-m \([0-9]* \)\(.* \)p@\1\3p; chmod \2\3@g' \
      -e '/^ifeq/s/$(ROOT)//' \
      -e 's@/usr/lib@$(ROOT)&@' \
      src/Makefile.orig > src/Makefile || \
    die "update sysvinit files" && \
      touch ${METADATAMIPS64ELROOTFS}/sysvinit_cross_update_files
[ -f "${METADATAMIPS64ELROOTFS}/sysvinit_cross_build_clobber" ] || \
  make -C src clobber  || \
    die "***build sysvinit clobber error***" && \
      touch ${METADATAMIPS64ELROOTFS}/sysvinit_cross_build_clobber
[ -f "${METADATAMIPS64ELROOTFS}/sysvinit_cross_build" ] || \
  make -C src ROOT=${PREFIXMIPS64ELROOTFS} CC="${CC} ${BUILD64}" || \
    die "***build sysvinit error***" && \
      touch ${METADATAMIPS64ELROOTFS}/sysvinit_cross_build
[ -f "${METADATAMIPS64ELROOTFS}/sysvinit_cross_install" ] || \
  make -C src ROOT=${PREFIXMIPS64ELROOTFS} INSTALL="install" install || \
    die "***install sysvinit error" && \
      touch ${METADATAMIPS64ELROOTFS}/sysvinit_cross_install
popd

[ -f "${METADATAMIPS64ELROOTFS}/create_inittab" ] || \
`cat > ${PREFIXMIPS64ELROOTFS}/etc/inittab << "EOF"
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

1:2345:respawn:/sbin/agetty -I '\033(K' tty1 9600
2:2345:respawn:/sbin/agetty -I '\033(K' tty2 9600
3:2345:respawn:/sbin/agetty -I '\033(K' tty3 9600
4:2345:respawn:/sbin/agetty -I '\033(K' tty4 9600
5:2345:respawn:/sbin/agetty -I '\033(K' tty5 9600
6:2345:respawn:/sbin/agetty -I '\033(K' tty6 9600

c0:12345:respawn:/sbin/agetty 115200 ttyS0 vt100

# End /etc/inittab

EOF` || \
  die "create inittab error" && \
    touch ${METADATAMIPS64ELROOTFS}/create_inittab

pushd ${BUILDMIPS64ELROOTFS}
[ -d "tar-cross-buildusr" ] || mkdir tar-cross-buildusr
cd tar-cross-buildusr
[ -f "${METADATAMIPS64ELROOTFS}/tar_cross_create_config.cache" ] || \
  `cat > config.cache << EOF
gl_cv_func_wcwidth_works=yes
gl_cv_func_btowc_eof=yes
ac_cv_func_malloc_0_nonnull=yes
ac_cv_func_realloc_0_nonnull=yes
gl_cv_func_mbrtowc_incomplete_state=yes
gl_cv_func_mbrtowc_nul_retval=yes
gl_cv_func_mbrtowc_null_arg=yes
gl_cv_func_mbrtowc_retval=yes
gl_cv_func_wcrtomb_retval=yes
EOF` || \
    die "create tar config.cache error" && \
      touch ${METADATAMIPS64ELROOTFS}/tar_cross_create_config.cache
[ -f "${METADATAMIPS64ELROOTFS}/tar_cross_config" ] || \
  CC="${CC} ${BUILD64}" ${SRCMIPS64ELROOTFS}/tar-${TAR_VERSION}/configure \
  --build=${CROSS_HOST} --host=${CROSS_TARGET64} \
  --prefix=/usr --bindir=/bin --libexecdir=/usr/sbin \
  --cache-file=config.cache || \
    die "***config tar error" && \
      touch ${METADATAMIPS64ELROOTFS}/tar_cross_config
[ -f "${METADATAMIPS64ELROOTFS}/tar_cross_build" ] || \
  make -j${JOBS} || \
    die "***build tar error" && \
      touch ${METADATAMIPS64ELROOTFS}/tar_cross_build
[ -f "${METADATAMIPS64ELROOTFS}/tar_cross_install" ] || \
  make DESTDIR=${PREFIXMIPS64ELROOTFS} install || \
    die "***install tar error" && \
      touch ${METADATAMIPS64ELROOTFS}/tar_cross_install
popd

pushd ${BUILDMIPS64ELROOTFS}
[ -d "texinfo-cross-buildusr" ] || mkdir texinfo-cross-buildusr
cd texinfo-cross-buildusr
[ -f "${METADATAMIPS64ELROOTFS}/texinfo_cross_config" ] || \
  CC="${CC} ${BUILD64}" \
  ${SRCMIPS64ELROOTFS}/texinfo-${TEXINFO_VERSION}/configure --prefix=/usr \
  --build=${CROSS_HOST} --host=${CROSS_TARGET64} || \
    die "***config texinfo error" && \
      touch ${METADATAMIPS64ELROOTFS}/texinfo_cross_config
[ -f "${METADATAMIPS64ELROOTFS}/texinfo_cross_build_lib" ] || \
  make -C tools/gnulib/lib || \
    die "***build texinfo lib error" && \
      touch ${METADATAMIPS64ELROOTFS}/texinfo_cross_build_lib
[ -f "${METADATAMIPS64ELROOTFS}/texinfo_cross_build_tools" ] || \
  make -C tools || \
    die "***build texinfo tools error" && \
      touch ${METADATAMIPS64ELROOTFS}/texinfo_cross_build_tools
[ -f "${METADATAMIPS64ELROOTFS}/texinfo_cross_build" ] || \
  make -j${JOBS} || \
    die "***build texinfo error" && \
      touch ${METADATAMIPS64ELROOTFS}/texinfo_cross_build
[ -f "${METADATAMIPS64ELROOTFS}/texinfo_cross_install" ] || \
  make DESTDIR=${PREFIXMIPS64ELROOTFS} install || \
    die "***install texinfo error" && \
      touch ${METADATAMIPS64ELROOTFS}/texinfo_cross_install
cd ${PREFIXMIPS64ELROOTFS}/usr/share/info
rm dir
for f in *; do
  install-info ${f} dir 2 > /dev/null;
done;
popd

pushd ${BUILDMIPS64ELROOTFS}
[ -d kmod-32 ] || \
  mkdir kmod-32
cd kmod-32
[ -f "${METADATAMIPS64ELROOTFS}/kmod_config32" ] || \
  CC="${CC} ${BUILD32}" PKG_CONFIG_LIBDIR=${PREFIXMIPS64ELROOTFS}/usr/lib \
  PKG_CONFIG_PATH=${PREFIXMIPS64ELROOTFS}/usr/lib/pkgconfig \
  ${SRCMIPS64ELROOTFS}/kmod-${KMOD_VERSION}/configure --prefix=/usr \
  --build=${CROSS_HOST} --host=${CROSS_TARGET32} --target=${CROSS_TARGET64} \
  --with-rootlibdir=/lib --bindir=/bin --sysconfdir=/etc --libdir=/usr/lib || \
    die "config kmod32 error" && \
      touch ${METADATAMIPS64ELROOTFS}/kmod_config32
[ -f "${METADATAMIPS64ELROOTFS}/kmod_build32" ] || \
  make -j${JOBS} || \
    die "build kmod32 error" && \
      touch ${METADATAMIPS64ELROOTFS}/kmod_build32
[ -f "${METADATAMIPS64ELROOTFS}/kmod_install32" ] || \
  make DESTDIR=${PREFIXMIPS64ELROOTFS} install || \
    die "install kmod32 error" && \
      touch ${METADATAMIPS64ELROOTFS}/kmod_install32
popd

pushd ${BUILDMIPS64ELROOTFS}
[ -d kmod-n32 ] || \
  mkdir kmod-n32
cd kmod-n32
[ -f "${METADATAMIPS64ELROOTFS}/kmod_confign32" ] || \
  CC="${CC} ${BUILDN32}" \
  PKG_CONFIG_LIBDIR=${PREFIXMIPS64ELROOTFS}/usr/lib32 \
  PKG_CONFIG_PATH=${PREFIXMIPS64ELROOTFS}/usr/lib32/pkgconfig \
  ${SRCMIPS64ELROOTFS}/kmod-${KMOD_VERSION}/configure --prefix=/usr \
  --build=${CROSS_HOST} --host=${CROSS_TARGET64} --target=${CROSS_TARGET64} \
  --with-rootlibdir=/lib32 --bindir=/bin --sysconfdir=/etc \
  --libdir=/usr/lib32 || \
    die "config kmodn32 error" && \
      touch ${METADATAMIPS64ELROOTFS}/kmod_confign32
[ -f "${METADATAMIPS64ELROOTFS}/kmod_buildn32" ] || \
  make -j${JOBS} || \
    die "build kmodn32 error" && \
      touch ${METADATAMIPS64ELROOTFS}/kmod_buildn32
[ -f "${METADATAMIPS64ELROOTFS}/kmod_installn32" ] || \
  make DESTDIR=${PREFIXMIPS64ELROOTFS} install || \
    die "install kmodn32 error" && \
      touch ${METADATAMIPS64ELROOTFS}/kmod_installn32
popd

pushd ${BUILDMIPS64ELROOTFS}
[ -d kmod-64 ] || \
  mkdir kmod-64
cd kmod-64
[ -f "${METADATAMIPS64ELROOTFS}/kmod_config64" ] || \
  CC="${CC} ${BUILD64}" \
  PKG_CONFIG_LIBDIR=${PREFIXMIPS64ELROOTFS}/usr/lib64 \
  PKG_CONFIG_PATH=${PREFIXMIPS64ELROOTFS}/usr/lib64/pkgconfig \
  ${SRCMIPS64ELROOTFS}/kmod-${KMOD_VERSION}/configure --prefix=/usr \
  --build=${CROSS_HOST} --host=${CROSS_TARGET64} --target=${CROSS_TARGET64} \
  --with-rootlibdir=/lib64 --bindir=/bin --sysconfdir=/etc \
  --libdir=/usr/lib64 || \
    die "config kmod64 error" && \
      touch ${METADATAMIPS64ELROOTFS}/kmod_config64
[ -f "${METADATAMIPS64ELROOTFS}/kmod_build64" ] || \
  make -j${JOBS} || \
    die "build kmod64 error" && \
      touch ${METADATAMIPS64ELROOTFS}/kmod_build64
[ -f "${METADATAMIPS64ELROOTFS}/kmod_install64" ] || \
  make DESTDIR=${PREFIXMIPS64ELROOTFS} install || \
    die "install kmod64 error" && \
      touch ${METADATAMIPS64ELROOTFS}/kmod_install64

ln -sv kmod ${PREFIXMIPS64ELROOTFS}/bin/lsmod
ln -sv ../bin/kmod ${PREFIXMIPS64ELROOTFS}/sbin/depmod
ln -sv ../bin/kmod ${PREFIXMIPS64ELROOTFS}/sbin/insmod
ln -sv ../bin/kmod ${PREFIXMIPS64ELROOTFS}/sbin/modprobe
ln -sv ../bin/kmod ${PREFIXMIPS64ELROOTFS}/sbin/modinfo
ln -sv ../bin/kmod ${PREFIXMIPS64ELROOTFS}/sbin/rmmod
popd

pushd ${PREFIXMIPS64ELROOTFS}/usr/share/misc
[ -f pci.ids ] || \
  patch -p1 < ${PATCH}/pci-ids-2.0.patch || \
    die "patch pci patch error"
popd

# FIXME Now we use --disable-gudev, so the glib is disabled
pushd ${BUILDMIPS64ELROOTFS}
[ -d udev-32 ] || mkdir udev-32
cd udev-32
[ -f "${METADATAMIPS64ELROOTFS}/udev_config32" ] || \
  PKG_CONFIG=true CC="${CC} ${BUILD32}" \
  LDFLAGS="-lblkid -luuid -lkmod" \
  ${SRCMIPS64ELROOTFS}/udev-${UDEV_VERSION}/configure \
  --build=${CROSS_HOST} --host=${CROSS_TARGET32} \
  --exec-prefix="" --sysconfdir=/etc \
  --libexecdir=/lib --libdir=/usr/lib --disable-gudev \
  --disable-extras --with-pci-ids-path=${PREFIXMIPS64ELROOTFS}/usr/share/misc || \
    die "***config udev32 error" && \
      touch ${METADATAMIPS64ELROOTFS}/udev_config32
[ -f "${METADATAMIPS64ELROOTFS}/udev_build32" ] || \
  make -j${JOBS} || \
    die "***build udev32 error" && \
      touch ${METADATAMIPS64ELROOTFS}/udev_build32
[ -f "${METADATAMIPS64ELROOTFS}/udev_install32" ] || \
  make DESTDIR=${PREFIXMIPS64ELROOTFS} install || \
    die "***install udev32 error" && \
      touch ${METADATAMIPS64ELROOTFS}/udev_install32
popd

pushd ${BUILDMIPS64ELROOTFS}
[ -d udev-n32 ] || \
  mkdir udev-n32
cd udev-n32
[ -f "${METADATAMIPS64ELROOTFS}/udev_confign32" ] || \
  PKG_CONFIG=true CC="${CC} ${BUILDN32}" \
  LDFLAGS="-lblkid -luuid -lkmod" \
  ${SRCMIPS64ELROOTFS}/udev-${UDEV_VERSION}/configure \
  --build=${CROSS_HOST} --host=${CROSS_TARGET64} \
  --exec-prefix="" --sysconfdir=/etc \
  --libexecdir=/lib32 --libdir=/usr/lib32 --disable-gudev \
  --disable-extras --with-pci-ids-path=${PREFIXMIPS64ELROOTFS}/usr/share/misc || \
    die "***config udevn32 error" && \
      touch ${METADATAMIPS64ELROOTFS}/udev_confign32
[ -f "${METADATAMIPS64ELROOTFS}/udev_buildn32" ] || \
  make -j${JOBS} || \
    die "***build udevn32 error" && \
      touch ${METADATAMIPS64ELROOTFS}/udev_buildn32
[ -f "${METADATAMIPS64ELROOTFS}/udev_installn32" ] || \
  make DESTDIR=${PREFIXMIPS64ELROOTFS} install || \
    die "***install udevn32 error" && \
      touch ${METADATAMIPS64ELROOTFS}/udev_installn32
popd

pushd ${BUILDMIPS64ELROOTFS}
[ -d udev-64 ] || \
  mkdir udev-64
cd udev-64
[ -f "${METADATAMIPS64ELROOTFS}/udev_config64" ] || \
  PKG_CONFIG=true CC="${CC} ${BUILD64}" \
  LDFLAGS="-lblkid -luuid -lkmod" \
  ${SRCMIPS64ELROOTFS}/udev-${UDEV_VERSION}/configure \
  --build=${CROSS_HOST} --host=${CROSS_TARGET64} \
  --exec-prefix="" --sysconfdir=/etc \
  --libexecdir=/lib64 --libdir=/usr/lib64 --disable-gudev \
  --disable-extras --with-pci-ids-path=${PREFIXMIPS64ELROOTFS}/usr/share/misc || \
    die "***config udev64 error" && \
      touch ${METADATAMIPS64ELROOTFS}/udev_config64
[ -f "${METADATAMIPS64ELROOTFS}/udev_build64" ] || \
  make -j${JOBS} || \
    die "***build udev64 error" && \
      touch ${METADATAMIPS64ELROOTFS}/udev_build64
[ -f "${METADATAMIPS64ELROOTFS}/udev_install64" ] || \
  make DESTDIR=${PREFIXMIPS64ELROOTFS} install || \
    die "***install udev64 error" && \
      touch ${METADATAMIPS64ELROOTFS}/udev_install64
[ -f "${METADATAMIPS64ELROOTFS}/udev_install_firmware" ] || \
  install -dv ${PREFIXMIPS64ELROOTFS}/lib/firmware || \
    die "install udev firmware error" && \
      touch ${METADATAMIPS64ELROOTFS}/udev_install_firmware
popd

pushd ${SRCMIPS64ELROOTFS}/${VIM_DIR}
[ -f "${METADATAMIPS64ELROOTFS}/vim_patch" ] || \
  patch -Np1 -i ${PATCH}/vim-7.3-branch_update-4.patch || \
    die "*** patch vim error" && \
      touch ${METADATAMIPS64ELROOTFS}/vim_patch

[ -f "${METADATAMIPS64ELROOTFS}/vim_cross_update_feature" ] || \
  `cat >> src/feature.h << "EOF"
#define SYS_VIMRC_FILE "/etc/vimrc"
EOF` || \
    die "update vim feature" && \
      touch ${METADATAMIPS64ELROOTFS}/vim_cross_update_feature
popd

pushd ${BUILDMIPS64ELROOTFS}
[ -d "vim-buildusr" ] || cp -ar ${SRCMIPS64ELROOTFS}/${VIM_DIR} vim-buildusr
cd vim-buildusr
[ -f "${METADATAMIPS64ELROOTFS}/vim_create_config.cache" ] || \
  `cat > src/auto/config.cache << "EOF"
vim_cv_getcwd_broken=no
vim_cv_memmove_handles_overlap=yes
vim_cv_stat_ignores_slash=no
vim_cv_terminfo=yes
vim_cv_tgent=zero
vim_cv_toupper_broken=no
vim_cv_tty_group=world
ac_cv_sizeof_int=4
EOF` || \
    die "create vim config.cache error" && \
      touch ${METADATAMIPS64ELROOTFS}/vim_create_config.cache
[ -f "${METADATAMIPS64ELROOTFS}/vim_config" ] || \
  CC="${CC} ${BUILD64}" CXX="${CXX} ${BUILD64}" \
  CPPFLAGS="-DUNUSED=" ./configure --build=${CROSS_HOST} \
  --host=${CROSS_TARGET64} \
  --prefix=/usr --enable-multibyte --enable-gui=no \
  --disable-gtktest --disable-xim --with-features=normal \
  --disable-gpm --without-x --disable-netbeans \
  --with-tlib=ncurses || \
    die "***config vim error" && \
      touch ${METADATAMIPS64ELROOTFS}/vim_config
[ -f "${METADATAMIPS64ELROOTFS}/vim_build" ] || \
  make -j${JOBS} || \
    die "***build vim error" && \
      touch ${METADATAMIPS64ELROOTFS}/vim_build
[ -f "${METADATAMIPS64ELROOTFS}/vim_install" ] || \
  make DESTDIR=${PREFIXMIPS64ELROOTFS}  install || \
    die "***install vim error" && \
      touch ${METADATAMIPS64ELROOTFS}/vim_install
[ -f "${METADATAMIPS64ELROOTFS}/vim_install_update" ] || \
  ln -sfv vim ${PREFIXMIPS64ELROOTFS}/usr/bin/vi && \
  ln -sfnv ../vim/vim72/doc ${PREFIXMIPS64ELROOTFS}/usr/share/doc/vim-7.2 || \
    die "install vim update" && \
      touch ${METADATAMIPS64ELROOTFS}/vim_install_update
#cat > /tools/etc/vimrc << "EOF"
#" Begin /etc/vimrc
#
#set nocompatible
#set backspace=2
#set ruler
#syntax on
#
#" End /etc/vimrc
#EOF
popd

pushd ${BUILDMIPS64ELROOTFS}
[ -d xz-32 ] || mkdir xz-32
cd xz-32
[ -f "${METADATAMIPS64ELROOTFS}/xz_config32" ] || \
  CC="${CC} ${BUILD32}" \
  ${SRCMIPS64ELROOTFS}/xz-${XZ_VERSION}/configure --prefix=/usr \
  --build=${CROSS_HOST} --host=${CROSS_TARGET32} --libdir=/lib || \
    die "***config xz32 error" && \
      touch ${METADATAMIPS64ELROOTFS}/xz_config32
[ -f "${METADATAMIPS64ELROOTFS}/xz_build32" ] || \
  make -j${JOBS} || \
    die "***build xz32 error" && \
      touch ${METADATAMIPS64ELROOTFS}/xz_build32
[ -f "${METADATAMIPS64ELROOTFS}/xz_install32" ] || \
  make DESTDIR=${PREFIXMIPS64ELROOTFS} pkgconfigdir=/usr/lib/pkgconfig \
  install || \
    die "***install xz32 error" && \
      touch ${METADATAMIPS64ELROOTFS}/xz_install32
#mv -v ${PREFIXMIPS64ELROOTFS}/usr/bin/{xz,lzma,lzcat,unlzma,unxz,xzcat} ${PREFIXMIPS64ELROOTFS}/bin
mv -v ${PREFIXMIPS64ELROOTFS}/lib/liblzma.a ${PREFIXMIPS64ELROOTFS}/usr/lib
popd

pushd ${BUILDMIPS64ELROOTFS}
[ -d xz-n32 ] || mkdir xz-n32
cd xz-n32
[ -f "${METADATAMIPS64ELROOTFS}/xz_confign32" ] || \
  CC="${CC} ${BUILDN32}" \
  ${SRCMIPS64ELROOTFS}/xz-${XZ_VERSION}/configure --build=${CROSS_HOST} \
  --host=${CROSS_TARGET64} --libdir=/lib32 \
  --prefix=/usr || \
    die "***config xz32 error" && \
      touch ${METADATAMIPS64ELROOTFS}/xz_confign32
[ -f "${METADATAMIPS64ELROOTFS}/xz_buildn32" ] || \
  make -j${JOBS} || \
    die "***build xz32 error" && \
      touch ${METADATAMIPS64ELROOTFS}/xz_buildn32
[ -f "${METADATAMIPS64ELROOTFS}/xz_installn32" ] || \
  make DESTDIR=${PREFIXMIPS64ELROOTFS} pkgconfigdir=/usr/lib32/pkgconfig install || \
    die "***install xz32 error" && \
      touch ${METADATAMIPS64ELROOTFS}/xz_installn32
#mv -v ${PREFIXMIPS64ELROOTFS}/usr/bin/{xz,lzma,lzcat,unlzma,unxz,xzcat} ${PREFIXMIPS64ELROOTFS}/bin
mv -v ${PREFIXMIPS64ELROOTFS}/lib32/liblzma.a ${PREFIXMIPS64ELROOTFS}/usr/lib32
popd

pushd ${BUILDMIPS64ELROOTFS}
[ -d xz-64 ] || mkdir xz-64
cd xz-64
[ -f "${METADATAMIPS64ELROOTFS}/xz_config64" ] || \
[ -f "config.log" ] || CC="${CC} ${BUILD64}" \
  ${SRCMIPS64ELROOTFS}/xz-${XZ_VERSION}/configure --build=${CROSS_HOST} \
  --host=${CROSS_TARGET64} --libdir=/lib64 \
  --prefix=/usr || \
    die "***config xz64 error" && \
      touch ${METADATAMIPS64ELROOTFS}/xz_config64
[ -f "${METADATAMIPS64ELROOTFS}/xz_build64" ] || \
  make -j${JOBS} || \
    die "***build xz error" && \
      touch ${METADATAMIPS64ELROOTFS}/xz_build64
[ -f "${METADATAMIPS64ELROOTFS}/xz_install64" ] || \
  make DESTDIR=${PREFIXMIPS64ELROOTFS} pkgconfigdir=/usr/lib64/pkgconfig install || \
    die "***install xz64 error" && \
      touch ${METADATAMIPS64ELROOTFS}/xz_install64
mv -v ${PREFIXMIPS64ELROOTFS}/usr/bin/{xz,lzma,lzcat,unlzma,unxz,xzcat} ${PREFIXMIPS64ELROOTFS}/bin
mv -v ${PREFIXMIPS64ELROOTFS}/lib64/liblzma.a ${PREFIXMIPS64ELROOTFS}/usr/lib64
popd

##pushd ${SRCMIPS64ELROOTFS}
##[ -d dhcpcd-${DHCPCD_VERSION} ] \
##  || tar xf  ${TARBALL}/dhcpcd-${DHCPCD_VERSION}.${DHCPCD_SUFFIX}
##cd dhcpcd-${DHCPCD_VERSION}
##./configure --target=${CROSS_TARGET64}
##make PREFIX=/usr BINDIR=/sbin SYSCONFDIR=/etc \
##    DBDIR=/var/lib/dhcpcd LIBEXECDIR=/usr/lib/dhcpcd
##make PREFIX=/usr BINDIR=/sbin SYSCONFDIR=/etc \
##    DBDIR=/var/lib/dhcpcd LIBEXECDIR=/usr/lib/dhcpcd \
##        DESTDIR=${PREFIXMIPS64ELROOTFS} install
##popd

pushd ${SRCMIPS64ELROOTFS}/bootscripts-cross-lfs-${BOOTSCRIPTS_VERSION}
[ -f "${METADATAMIPS64ELROOTFS}/bootscript_install_boot" ] || \
  make CC="${CC} ${BUILD64}" DESTDIR=${PREFIXMIPS64ELROOTFS} install-bootscripts || \
   die "install bootscripts error" && \
     touch ${METADATAMIPS64ELROOTFS}/bootscript_install_boot
[ -f "${METADATAMIPS64ELROOTFS}/bootscript_install_network" ] || \
  make DESTDIR=${PREFIXMIPS64ELROOTFS} install-network || \
   die "install network error" && \
     touch ${METADATAMIPS64ELROOTFS}/bootscript_install_network
popd

#########################################################################
#
# Now we add config file to the file system.
#
#########################################################################

[ -f "${METADATAMIPS64ELROOTFS}/create_clock_files" ] || \
  `cat > ${PREFIXMIPS64ELROOTFS}/etc/sysconfig/clock << "EOF"
# Begin /etc/sysconfig/clock

UTC=1

# End /etc/sysconfig/clock
EOF` || die "Create clock error"


`cat > ${PREFIXMIPS64ELROOTFS}/etc/inputrc << "EOF"
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
EOF` || die "Create inputrc error"


`cat > ${PREFIXMIPS64ELROOTFS}/etc/sysconfig/network << EOF
HOSTNAME=mips64el-gnu-linux
EOF` || die "create network error"

`cat > ${PREFIXMIPS64ELROOTFS}/etc/hosts << "EOF"
# Begin /etc/hosts (network card version)

127.0.0.1 localhost

# End /etc/hosts (network card version)
EOF` || die "crete host error"

`cat > ${PREFIXMIPS64ELROOTFS}/etc/resolv.conf << "EOF"
# Generated by NetworkManager
nameserver 127.0.1.1
EOF` || \
    die "crete resolv.conf error" && \
      touch ${METADATAMIPS64ELROOTFS}/create_clock_files

[ -d ${PREFIXMIPS64ELROOTFS}/etc/sysconfig/network-devices ] || \
  mkdir -pv ${PREFIXMIPS64ELROOTFS}/etc/sysconfig/network-devices
pushd ${PREFIXMIPS64ELROOTFS}/etc/sysconfig/network-devices &&
[ -d ifconfig.eth0 ] || mkdir -v ifconfig.eth0 &&
[ -f "${METADATAMIPS64ELROOTFS}/create_ipv4" ] || \
  `cat > ifconfig.eth0/ipv4 << "EOF"
ONBOOT=yes
SERVICE=ipv4-static
IP=192.168.1.1
GATEWAY=192.168.1.2
PREFIX=24
BROADCAST=192.168.1.255
EOF` || \
    die "create static ip address error" && \
      touch ${METADATAMIPS64ELROOTFS}/create_ipv4
popd

echo 2

[ -f "${METADATAMIPS64ELROOTFS}/create_fstab" ] || \
  `cat > ${PREFIXMIPS64ELROOTFS}/etc/fstab << "EOF"
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
      touch ${METADATAMIPS64ELROOTFS}/create_fstab

cat > ${PREFIXMIPS64ELROOTFS}/root/.bash_profile << EOF
set +h
PS1='\u:\w\$ '
LC_ALL=POSIX
PATH=$PATH:/bin:/usr/bin:/sbin:/usr/sbin
export LC_ALL PATH PS1

source .bashrc
EOF

cat > ${PREFIXMIPS64ELROOTFS}/root/.bashrc << EOF
set +h
umask 022

export PYTHONHOME=/usr
EOF

pushd ${BUILDMIPS64ELROOTFS}
[ -d linux-kernel ] || \
  cp -ar ${SRCMIPS64ELROOTFS}/linux-${LINUX_VERSION} linux-kernel
cd linux-kernel
[ -f "${METADATAMIPS64ELROOTFS}/linux_patch_mips64el_defconfig" ] || \
  patch -p1 < ${PATCH}/linux-mips64el-multilib-defconfig.patch || \
    die "patch mips64el-multilib-defconfig error" && \
      touch ${METADATAMIPS64ELROOTFS}/linux_patch_mips64el_defconfig
make mrproper || die "clean linux error"
[ -f "${METADATAMIPS64ELROOTFS}/linux_config_mips64el_mul" ] || \
  make ARCH=mips mips64el_multilib_defconfig || \
    die "config mips64el_multilib_defconfig error" && \
      touch ${METADATAMIPS64ELROOTFS}/linux_config_mips64el_mul
#make ARCH=mips CROSS_COMPILE=${CROSS_TARGET64}- menuconfig || \
#  die "config linux error"
[ -f "${METADATAMIPS64ELROOTFS}/linux_build_kernel" ] || \
  make -j${JOBS} ARCH=mips CROSS_COMPILE=${CROSS_TARGET64}- \
  CFLAGS="${BUILD64}" || \
    die "build linux error" && \
      touch ${METADATAMIPS64ELROOTFS}/linux_build_kernel
[ -f "${METADATAMIPS64ELROOTFS}/linux_install_modules" ] || \
  make ARCH=mips CROSS_COMPILE=${CROSS_TARGET64}- CFLAGS="${BUILD64}" \
  INSTALL_MOD_PATH=${PREFIXMIPS64ELROOTFS} modules_install || \
    die "install linux module error" && \
      touch ${METADATAMIPS64ELROOTFS}/linux_install_modules
[ -f "${METADATAMIPS64ELROOTFS}/linux_cp_vmlinux" ] || \
  cp vmlinux ${PREFIXMIPS64ELROOTFS}/boot/ || \
    die "cp vmlinux error" && \
      touch ${METADATAMIPS64ELROOTFS}/linux_cp_vmlinux
[ -f "${METADATAMIPS64ELROOTFS}/linux_cp_vmlinux.32" ] || \
  cp vmlinux.32 ${PREFIXMIPS64ELROOTFS}/boot/ || \
    die "cp vmlinux.32 error" && \
      touch ${METADATAMIPS64ELROOTFS}/linux_cp_vmlinux.32
[ -f "${METADATAMIPS64ELROOTFS}/linux_cp_system.map" ] || \
  cp System.map ${PREFIXMIPS64ELROOTFS}/boot/System.map-2.6.30.1 || \
    die "cp System.map error" && \
      touch ${METADATAMIPS64ELROOTFS}/linux_cp_system.map
[ -f "${METADATAMIPS64ELROOTFS}/linux_cp_config" ] || \
  cp .config ${PREFIXMIPS64ELROOTFS}/boot/config-2.6.30.1 || \
    die "cp config file error" && \
      touch ${METADATAMIPS64ELROOTFS}/linux_cp_config
popd

[ -f "${METADATAMIPS64ELROOTFS}/create_clfs-release" ] || \
`cat > ${PREFIXMIPS64ELROOTFS}/etc/clfs-release << EOF
PREFIXMIPS64ELROOTFS-Sysroot
EOF` || \
    die "create version number error" && \
      touch ${METADATAMIPS64ELROOTFS}/create_clfs-release

##################### remove cross-tools ######################################
#rm -rf ${PREFIXMIPS64ELROOTFS}/cross-tools

################ Change Own Ship ########################
[ -f "${METADATAMIPS64ELROOTFS}/change_all_own" ] || \
  sudo chown -Rv 0:0 ${PREFIXMIPS64ELROOTFS} || \
    die "change_all_own" && \
      touch ${METADATAMIPS64ELROOTFS}/change_all_own
[ -f "${METADATAMIPS64ELROOTFS}/touch_run_utmp" ] || \
  sudo touch ${PREFIXMIPS64ELROOTFS}/{,var/}run/utmp \
             ${PREFIXMIPS64ELROOTFS}/var/log/{btmp,lastlog,wtmp} || \
    die "touch run/utmp error" && \
      touch ${METADATAMIPS64ELROOTFS}/touch_run_utmp
[ -f "${METADATAMIPS64ELROOTFS}/chmod_run.utmp" ] || \
  sudo chmod -v 664 ${PREFIXMIPS64ELROOTFS}/{,var/}run/utmp \
                    ${PREFIXMIPS64ELROOTFS}/var/log/lastlog || \
    die "Change utmp/lastlog group error" && \
      touch ${METADATAMIPS64ELROOTFS}/chmod_run.utmp
[ -f "${METADATAMIPS64ELROOTFS}/chgrp_write" ] || \
  sudo chgrp -v 4 ${PREFIXMIPS64ELROOTFS}/usr/bin/write || \
    die "Change write group error" && \
      touch ${METADATAMIPS64ELROOTFS}/chgrp_write
[ -f "${METADATAMIPS64ELROOTFS}/chmod_write" ] || \
  sudo chmod g+s ${PREFIXMIPS64ELROOTFS}/usr/bin/write || \
    die "Change write mode error" && \
      touch ${METADATAMIPS64ELROOTFS}/chmod_write
[ -f "${METADATAMIPS64ELROOTFS}/mknod_null" ] || \
  sudo mknod -m 0666 ${PREFIXMIPS64ELROOTFS}/dev/null c 1 3 || \
    die "Create null error" && \
      touch ${METADATAMIPS64ELROOTFS}/mknod_null
[ -f "${METADATAMIPS64ELROOTFS}/mknod_console" ] || \
  sudo mknod -m 0600 ${PREFIXMIPS64ELROOTFS}/dev/console c 5 1 || \
    die "Create console error" && \
      touch ${METADATAMIPS64ELROOTFS}/mknod_console
[ -f "${METADATAMIPS64ELROOTFS}/mknod_rtc0" ] || \
  sudo mknod -m 0666 ${PREFIXMIPS64ELROOTFS}/dev/rtc0 c 254 0 || \
    die "Create rtc0 error" && \
      touch ${METADATAMIPS64ELROOTFS}/mknod_rtc0
[ -f "${METADATAMIPS64ELROOTFS}/link_rtc0" ] || \
  sudo ln -sv ${PREFIXMIPS64ELROOTFS}/dev/rtc0 \
              ${PREFIXMIPS64ELROOTFS}/dev/rtc || \
    die "Link rtc error" && \
      touch ${METADATAMIPS64ELROOTFS}/link_rtc0

pushd ${PREFIXMIPS64ELROOTFS}/lib64/
#[ -f "${METADATAMIPS64ELROOTFS}/link_libblkid" ] || \
#  sudo ln -sv /lib/libblkid.so.1.1.0 libblkid.so.1 || \
#    die "link libblkid error" && \
#      touch ${METADATAMIPS64ELROOTFS}/link_libblkid
#[ -f "${METADATAMIPS64ELROOTFS}/link_libcom_error" ] || \
#  sudo ln -sv /lib/libcom_err.so.2.1 libcom_err.so.2 || \
#    die "link libcom_error error" && \
#      touch ${METADATAMIPS64ELROOTFS}/link_libcom_error
#[ -f "${METADATAMIPS64ELROOTFS}/link_libe2p" ] || \
#  sudo ln -sv /lib/libe2p.so.2.3 libe2p.so.2 || \
#    die "link libe2p error" && \
#      touch ${METADATAMIPS64ELROOTFS}/link_libe2p
#[ -f "${METADATAMIPS64ELROOTFS}/link_libext2fs" ] || \
#  sudo ln -sv /lib/libext2fs.so.2.4 libext2fs.so.2 || \
#    die "link libext2fs error" && \
#      touch ${METADATAMIPS64ELROOTFS}/link_libext2fs
#[ -f "${METADATAMIPS64ELROOTFS}/link_libmount" ] || \
#  sudo ln -sv /lib/libmount.so.1.1.0 libmount.so.1 || \
#    die "link libmount error" && \
#      touch ${METADATAMIPS64ELROOTFS}/link_libmount
#[ -f "${METADATAMIPS64ELROOTFS}/link_libncursesw" ] || \
#  sudo ln -sv /lib/libncursesw.so.5.9 libncursesw.so.5 || \
#    die "link libncursesw error" && \
#      touch ${METADATAMIPS64ELROOTFS}/link_libncursesw
#[ -f "${METADATAMIPS64ELROOTFS}/link_libuuid" ] || \
#  sudo ln -sv /lib/libuuid.so.1.3.0 libuuid.so.1 || \
#    die "link libuuid error" && \
#      touch ${METADATAMIPS64ELROOTFS}/link_libuuid
#[ -f "${METADATAMIPS64ELROOTFS}/link_libz" ] || \
#  sudo ln -sv /lib/libz.so.1.2.7 libz.so.1 || \
#    die "link libz error" && \
#      touch ${METADATAMIPS64ELROOTFS}/link_libz
#[ -f "${METADATAMIPS64ELROOTFS}/link_libss" ] || \
#  sudo ln -sv /lib/libss.so.2.0 libss.so.2 || \
#    die "link libss error" && \
#      touch ${METADATAMIPS64ELROOTFS}/link_libss
[ -f "${METADATAMIPS64ELROOTFS}/link_libgcc_s" ] || \
  sudo ln -sv /usr/lib64/libgcc_s.so.1 libgcc_s.so.1 || \
    die "link libgcc_s error" && \
      touch ${METADATAMIPS64ELROOTFS}/link_libgcc_s
#[ -f "${METADATAMIPS64ELROOTFS}/link_libee" ] || \
#  sudo ln -sv /usr/lib/libee.so.0.0.0 libee.so.0 || \
#    die "link libee error" && \
#      touch ${METADATAMIPS64ELROOTFS}/link_libee
#[ -f "${METADATAMIPS64ELROOTFS}/link_libkmod" ] || \
#  sudo ln -sv /usr/lib/libkmod.so.2.1.2 libkmod.so.2 || \
#    die "link libkmod error" && \
#      touch ${METADATAMIPS64ELROOTFS}/link_libkmod
#[ -f "${METADATAMIPS64ELROOTFS}/link_libestr" ] || \
#  sudo ln -sv /usr/lib/libestr.so.0.0.0 libestr.so.0 || \
#    die "link libestr error" && \
#      touch ${METADATAMIPS64ELROOTFS}/link_libestr
popd

######################## Create Image ##########################################
pushd ${PREFIXGNULINUX}
[ -f ${METADATAMIPS64ELROOTFS}/mips64el_rootfs_ddimg ] || \
 dd if=/dev/zero of=mips64el-rootfs.img bs=1M count=10K || \
    die "***dd mips64el rootfs.img error" && \
      touch ${METADATAMIPS64ELROOTFS}/mips64el_rootfs_ddimg
[ -f ${METADATAMIPS64ELROOTFS}/mips64el_rootfs_mkfsimg ] || \
  echo y | mkfs.ext3 mips64el-rootfs.img || \
    die "***mkfs mipsel rootfs.img error" && \
      touch ${METADATAMIPS64ELROOTFS}/mips64el_rootfs_mkfsimg
[ -f ${METADATAMIPS64ELROOTFS}/mips64el_rootfs_dirmnt ] || \
  [ -d mnt_tmp ] || mkdir mnt_tmp || \
    die "***mkdir mnt error" && \
      touch ${METADATAMIPS64ELROOTFS}/mips64el_rootfs_dirmnt
[ -f ${METADATAMIPS64ELROOTFS}/mips64el_rootfs_mnt ] || \
  sudo mount -o loop mips64el-rootfs.img ./mnt_tmp || \
    die "***mount mips64el rootfs.img error" && \
      touch ${METADATAMIPS64ELROOTFS}/mips64el_rootfs_mnt
[ -f ${METADATAMIPS64ELROOTFS}/mips64el_rootfs_copy ] || \
  sudo cp -ar ${PREFIXMIPS64ELROOTFS}/* ./mnt_tmp/ || \
    die "***copy to mipsel rootfs.img error" && \
      touch ${METADATAMIPS64ELROOTFS}/mips64el_rootfs_copy
[ -f ${METADATAMIPS64ELROOTFS}/mips64el_rootfs_umnt ] || \
  sudo umount ./mnt_tmp/ || \
    die "***copy to mips64el rootfs.img error" && \
      touch ${METADATAMIPS64ELROOTFS}/mips64el_rootfs_umnt
[ -f ${METADATAMIPS64ELROOTFS}/mips64el_rootfs_rmmnt ] || \
  rm -rf  mnt_tmp || \
    die "***remove mnt error" && \
      touch ${METADATAMIPS64ELROOTFS}/mips64el_rootfs_rmmnt
popd

