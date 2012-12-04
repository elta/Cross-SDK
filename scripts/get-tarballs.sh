#! /bin/bash

source source.sh

[ -d "${TARBALL}" ] || mkdir -p "${TARBALL}"
[ -d "${SRC_LIVE}" ] || mkdir -p "${SRC_LIVE}"
[ -d "${METADATADOWN}" ] || mkdir -p "${METADATADOWN}"

pushd ${METADATADOWN}

#arcload-0.5.tar.bz2
#[ -f arcload_download ] || \
#download "arcload-${ARCLOAD_VERSION}.${ARCLOAD_SUFFIX}" \
#  "${ARCLOAD_URL}/arcload-${ARCLOAD_VERSION}.${ARCLOAD_SUFFIX}" || \
#  die "download arcload error" && \
#    touch arcload_download

#autoconf-2.69.tar.xz
[ -f autoconf_download ] || \
download "autoconf-${AUTOCONF_VERSION}.${AUTOCONF_SUFFIX}" \
  "${AUTOCONF_URL}/autoconf-${AUTOCONF_VERSION}.${AUTOCONF_SUFFIX}" || \
  die "download autoconf error" && \
    touch autoconf_download

#automake-1.12.3.tar.xz
[ -f automake_download ] || \
download "automake-${AUTOMAKE_VERSION}.${AUTOMAKE_SUFFIX}" \
  "${AUTOMAKE_URL}/automake-${AUTOMAKE_VERSION}.${AUTOMAKE_SUFFIX}" || \
  die "download automake error" && \
    touch automake_download

#bash-4.2.tar.gz
[ -f bash_download ] || \
download "bash-${BASH_VERSION}.${BASH_SUFFIX}" \
  "${BASH_URL}/bash-${BASH_VERSION}.${BASH_SUFFIX}" || \
  die "download bash error" && \
    touch bash_download

#binutils-2.22.tar.bz2
[ -f binutils_download ] || \
download "binutils-${BINUTILS_VERSION}.${BINUTILS_SUFFIX}" \
  "${BINUTILS_URL}/binutils-${BINUTILS_VERSION}.${BINUTILS_SUFFIX}" || \
  die "download binutils error" && \
    touch binutils_download

#bison-2.5.tar.bz2
[ -f bison_download ] || \
download "bison-${BISON_VERSION}.${BISON_SUFFIX}" \
  "${BISON_URL}/bison-${BISON_VERSION}.${BISON_SUFFIX}" || \
  die "download bison error" && \
    touch bison_download

#bootscripts-cross-lfs-2.0-pre1.tar.bz2
[ -f bootscripts_download ] || \
download "bootscripts-cross-lfs-${BOOTSCRIPTS_VERSION}.${BOOTSCRIPTS_SUFFIX}" \
  "${BOOTSCRIPTS_URL}/bootscripts-cross-lfs-${BOOTSCRIPTS_VERSION}.${BOOTSCRIPTS_SUFFIX}" || \
  die "download bootscripts error" && \
    touch bootscripts_download

#busybox-1.20.1.tar.bz2
[ -f busybox_download ] || \
download "busybox-${BUSYBOX_VERSION}.${BUSYBOX_SUFFIX}" \
  "${BUSYBOX_URL}/busybox-${BUSYBOX_VERSION}.${BUSYBOX_SUFFIX}" || \
  die "download busybox error" && \
    touch busybox_download

#bzip2-1.0.6.tar.gz
[ -f bzip2_download ] || \
download "bzip2-${BZIP2_VERSION}.${BZIP2_SUFFIX}" \
  "${BZIP2_URL}/bzip2-${BZIP2_VERSION}.${BZIP2_SUFFIX}" || \
  die "download bzip2 error" && \
    touch bzip2_download

#cloog-0.16.3.tar.gz
[ -f cloog_download ] || \
download "cloog-${CLOOG_VERSION}.${CLOOG_SUFFIX}" \
  "${CLOOG_URL}/cloog-${CLOOG_VERSION}.${CLOOG_SUFFIX}" || \
  die "download cloog error" && \
    touch cloog_download

#colo-1.22.tar.gz
[ -f colo_download ] || \
download "colo-${COLO_VERSION}.${COLO_SUFFIX}" \
  "${COLO_URL}/colo-${COLO_VERSION}.${COLO_SUFFIX}" || \
  die "download colo error" && \
    touch colo_download

#coreutils-8.16.tar.xz
[ -f coreutils_download ] || \
download "coreutils-${COREUTILS_VERSION}.${COREUTILS_SUFFIX}" \
  "${COREUTILS_URL}/coreutils-${COREUTILS_VERSION}.${COREUTILS_SUFFIX}" || \
  die "download coreutils error" && \
    touch coreutils_download

#dejagnu-1.5.tar.gz
[ -f dejagnu_download ] || \
download "dejagnu-${DEJAGNU_VERSION}.${DEJAGNU_SUFFIX}" \
  "${DEJAGNU_URL}/dejagnu-${DEJAGNU_VERSION}.${DEJAGNU_SUFFIX}" || \
  die "download dejagnu error" && \
    touch dejagnu_download

#dhcpcd-5.5.6.tar.bz2
[ -f dhcpcd_download ] || \
download "dhcpcd-${DHCPCD_VERSION}.${DHCPCD_SUFFIX}" \
  "${DHCPCD_URL}/dhcpcd-${DHCPCD_VERSION}.${DHCPCD_SUFFIX}" || \
  die "download dhcpcd error" && \
    touch dhcpcd_download

#diffutils-3.2.tar.xz
[ -f diffutils_download ] || \
download "diffutils-${DIFFUTILS_VERSION}.${DIFFUTILS_SUFFIX}" \
  "${DIFFUTILS_URL}/diffutils-${DIFFUTILS_VERSION}.${DIFFUTILS_SUFFIX}" || \
  die "download diffutils error" && \
    touch diffutils_download

#dvhtool_1.0.1.orig.tar.gz
[ -f dvhtool_download ] || \
download "dvhtool_${DVHTOOL_VERSION}.${DVHTOOL_SUFFIX}" \
  "${DVHTOOL_URL}/dvhtool_${DVHTOOL_VERSION}.${DVHTOOL_SUFFIX}" || \
  die "download dvhtool error" && \
    touch dvhtool_download

#e2fsprogs-1.42.3.tar.bz2
[ -f e2fsprogs_download ] || \
download "e2fsprogs-${E2FSPROGS_VERSION}.${E2FSPROGS_SUFFIX}" \
  "${E2FSPROGS_URL}/e2fsprogs-${E2FSPROGS_VERSION}.${E2FSPROGS_SUFFIX}" || \
  die "download e2fsprogs error" && \
    touch e2fsprogs_download

#eglibc-2.15.tar.bz2
[ -f eglibc_download ] || \
download "eglibc-${EGLIBC_VERSION}-r21467.${EGLIBC_SUFFIX}" \
  "${EGLIBC_URL}/eglibc-${EGLIBC_VERSION}-r21467.${EGLIBC_SUFFIX}" || \
  die "download eglibc error" && \
    touch eglibc_download

#eglibc-ports-2.15.tar.xz
[ -f eglibcports_download ] || \
download "eglibc-ports-${EGLIBCPORTS_VERSION}-r21467.${EGLIBCPORTS_SUFFIX}" \
  "${EGLIBCPORTS_URL}/eglibc-ports-${EGLIBCPORTS_VERSION}-r21467.${EGLIBCPORTS_SUFFIX}" || \
  die "download eglibc-ports error" && \
    touch eglibcports_download

#expect5.45.tar.gz 
[ -f expect_download ] || \
download "expect${EXPECT_VERSION}.${EXPECT_SUFFIX}" \
  "${EXPECT_URL}/expect${EXPECT_VERSION}.${EXPECT_SUFFIX}" || \
  die "download expect error" && \
    touch expect_download

#file-5.09.tar.gz
[ -f file-5.09_download ] || \
download "file-${FILE9_VERSION}.${FILE9_SUFFIX}" \
  "${FILE9_URL}/file-${FILE9_VERSION}.${FILE9_SUFFIX}" || \
  die "download file error" && \
    touch file-5.09_download

#file-5.11.tar.gz
[ -f file-5.11_download ] || \
download "file-${FILE11_VERSION}.${FILE11_SUFFIX}" \
  "${FILE11_URL}/file-${FILE11_VERSION}.${FILE11_SUFFIX}" || \
  die "download file2 error" && \
    touch file-5.11_download

#findutils-4.4.2.tar.gz
[ -f findutils_download ] || \
download "findutils-${FINDUTILS_VERSION}.${FINDUTILS_SUFFIX}" \
  "${FINDUTILS_URL}/findutils-${FINDUTILS_VERSION}.${FINDUTILS_SUFFIX}" || \
  die "download findutils error" && \
    touch findutils_download

#flex-2.5.35.tar.bz2
[ -f flex_download ] || \
download "flex-${FLEX_VERSION}.${FLEX_SUFFIX}" \
  "${FLEX_URL}/flex-${FLEX_VERSION}.${FLEX_SUFFIX}" || \
  die "download flex error" && \
    touch flex_download

#gawk-4.0.1.tar.xz
[ -f gawk_download ] || \
download "gawk-${GAWK_VERSION}.${GAWK_SUFFIX}" \
  "${GAWK_URL}/gawk-${GAWK_VERSION}.${GAWK_SUFFIX}" || \
  die "download gawk error" && \
    touch gawk_download

#gcc-4.6.3.tar.bz2
[ -f gcc_download ] || \
download "gcc-${GCC_VERSION}.${GCC_SUFFIX}" \
  "${GCC_URL}/gcc-${GCC_VERSION}.${GCC_SUFFIX}" || \
  die "download gcc error" && \
    touch gcc_download

#gdb-7.4.tar.bz2
[ -f gdb_download ] || \
download "gdb-${GDB_VERSION}.${GDB_SUFFIX}" \
  "${GDB_URL}/gdb-${GDB_VERSION}.${GDB_SUFFIX}" || \
  die "download gdb error" && \
    touch gdb_download

#gettext-0.18.1.1.tar.gz
[ -f gettext_download ] || \
download "gettext-${GETTEXT_VERSION}.${GETTEXT_SUFFIX}" \
  "${GETTEXT_URL}/gettext-${GETTEXT_VERSION}.${GETTEXT_SUFFIX}" || \
  die "download gettext error" && \
    touch gettext_download

#glib-2.28.8.tar.xz
[ -f glib_download ] || \
download "glib-${GLIB_VERSION}.${GLIB_SUFFIX}" \
  "${GLIB_URL}/glib-${GLIB_VERSION}.${GLIB_SUFFIX}" || \
  die "download glib error" && \
    touch glib_download

#gmp-5.0.5.tar.bz2
[ -f gmp_download ] || \
download "gmp-${GMP_VERSION}.${GMP_SUFFIX}" \
  "${GMP_URL}/gmp-${GMP_VERSION}.${GMP_SUFFIX}" || \
  die "download gmp error" && \
    touch gmp_download

#grep-2.12.tar.xz
[ -f grep_download ] || \
download "grep-${GREP_VERSION}.${GREP_SUFFIX}" \
  "${GREP_URL}/grep-${GREP_VERSION}.${GREP_SUFFIX}" || \
  die "download grep error" && \
    touch grep_download

#groff-1.21.tar.gz
[ -f groff_download ] || \
download "groff-${GROFF_VERSION}.${GROFF_SUFFIX}" \
  "${GROFF_URL}/groff-${GROFF_VERSION}.${GROFF_SUFFIX}" || \
  die "download groff error" && \
    touch groff_download

#gzip-1.4.tar.gz
[ -f gzip_download ] || \
download "gzip-${GZIP_VERSION}.${GZIP_SUFFIX}" \
  "${GZIP_URL}/gzip-${GZIP_VERSION}.${GZIP_SUFFIX}" || \
  die "download gzip error" && \
    touch gzip_download

#iana-etc-2.30.tar.bz2
[ -f iana-etc_download ] || \
download "iana-etc-${IANA_VERSION}.${IANA_SUFFIX}" \
  "${IANA_URL}/iana-etc-${IANA_VERSION}.${IANA_SUFFIX}" || \
  die "download iana-etc error" && \
    touch iana-etc_download

#iproute2-3.3.0.tar.xz
[ -f iproute2_download ] || \
download "iproute2-${IPROUTE2_VERSION}.${IPROUTE2_SUFFIX}" \
  "${IPROUTE2_URL}/iproute2-${IPROUTE2_VERSION}.${IPROUTE2_SUFFIX}" || \
  die "download iproute error" && \
    touch iproute2_download

#iputils-s20101006.tar.bz2
[ -f iputils_download ] || \
download "iputils-${IPUTILS_VERSION}.${IPUTILS_SUFFIX}" \
  "${IPUTILS_URL}/iputils-${IPUTILS_VERSION}.${IPUTILS_SUFFIX}" || \
  die "download iputils error" && \
    touch iputils_download

#kbd-1.15.3.tar.gz
[ -f kbd_download ] || \
download "kbd-${KBD_VERSION}.${KBD_SUFFIX}" \
  "${KBD_URL}/kbd-${KBD_VERSION}.${KBD_SUFFIX}" || \
  die "download kbd error" && \
    touch kbd_download

#kmod-8.tar.xz
[ -f kmod_download ] || \
download "kmod-${KMOD_VERSION}.${KMOD_SUFFIX}" \
  "${KMOD_URL}/kmod-${KMOD_VERSION}.${KMOD_SUFFIX}" || \
  die "download kmod error" && \
    touch kmod_download

#less-444.tar.gz
[ -f less_download ] || \
download "less-${LESS_VERSION}.${LESS_SUFFIX}" \
  "${LESS_URL}/less-${LESS_VERSION}.${LESS_SUFFIX}" || \
  die "download less error" && \
    touch less_download

#libee-0.4.1.tar.gz
[ -f libee_download ] || \
download "libee-${LIBEE_VERSION}.${LIBEE_SUFFIX}" \
  "${LIBEE_URL}/libee-${LIBEE_VERSION}.${LIBEE_SUFFIX}" || \
  die "download libee error" && \
    touch libee_download

#libestr-0.1.0.tar.gz
[ -f libestr_download ] || \
download "libestr-${LIBESTR_VERSION}.${LIBESTR_SUFFIX}" \
  "${LIBESTR_URL}/libestr-${LIBESTR_VERSION}.${LIBESTR_SUFFIX}" || \
  die "download libestr error" && \
    touch libestr_download

#libtool-2.4.2.tar.xz
[ -f libtool_download ] || \
download "libtool-${LIBTOOL_VERSION}.${LIBTOOL_SUFFIX}" \
  "${LIBTOOL_URL}/libtool-${LIBTOOL_VERSION}.${LIBTOOL_SUFFIX}" || \
  die "download libtool error" && \
    touch libtool_download

#linux-3.3.7.tar.bz2
[ -f linux_download ] || \
download "linux-${LINUX_VERSION}.${LINUX_SUFFIX}" \
  "${LINUX_URL}/linux-${LINUX_VERSION}.${LINUX_SUFFIX}" || \
  die "download linux error" && \
    touch linux_download

#llvm-3.1.tar.bz2
[ -f llvm_download ] || \
download "llvm-${LLVM_VERSION}.${LLVM_SUFFIX}" \
  "${LLVM_URL}/llvm-${LLVM_VERSION}.${LLVM_SUFFIX}" || \
  die "download llvm error" && \
    touch llvm_download

#clang-3.1.src.tar.gz
[ -f clang_download ] || \
download "clang-${CLANG_VERSION}.${CLANG_SUFFIX}" \
  "${CLANG_URL}/clang-${CLANG_VERSION}.${CLANG_SUFFIX}" || \
  die "download clang error" && \
    touch clang_download

#compiler-rt-3.1.src.tar.gz
[ -f crt_download ] || \
download "compiler-rt-${CRT_VERSION}.${CRT_SUFFIX}" \
  "${CRT_URL}/compiler-rt-${CRT_VERSION}.${CRT_SUFFIX}" || \
  die "download compiler-rt error" && \
    touch crt_download

#m4-1.4.16.tar.bz2
[ -f m4_download ] || \
download "m4-${M4_VERSION}.${M4_SUFFIX}" \
  "${M4_URL}/m4-${M4_VERSION}.${M4_SUFFIX}" || \
  die "download m4 error" && \
    touch m4_download

#make-3.82.tar.bz2
[ -f make_download ] || \
download "make-${MAKE_VERSION}.${MAKE_SUFFIX}" \
  "${MAKE_URL}/make-${MAKE_VERSION}.${MAKE_SUFFIX}" || \
  die "download make error" && \
    touch make_download

#man-1.6g.tar.gz
[ -f man_download ] || \
download "man-${MAN_VERSION}.${MAN_SUFFIX}" \
  "${MAN_URL}/man-${MAN_VERSION}.${MAN_SUFFIX}" || \
  die "download man error" && \
    touch man_download

#man-pages-3.41.tar.xz
[ -f man-pages_download ] || \
download "man-pages-${MANPAGES_VERSION}.${MANPAGES_SUFFIX}" \
  "${MANPAGES_URL}/man-pages-${MANPAGES_VERSION}.${MANPAGES_SUFFIX}" || \
  die "download man-pages error" && \
    touch man-pages_download

#module-init-tools-3.15.tar.xz
[ -f module-init-tools_download ] || \
download "module-init-tools-${MODULE_VERSION}.${MODULE_SUFFIX}" \
  "${MODULE_URL}/module-init-tools-${MODULE_VERSION}.${MODULE_SUFFIX}" || \
  die "download moudle-init-tools error" && \
    touch module-init-tools_download

#mpc-0.9.tar.gz
[ -f mpc_download ] || \
download "mpc-${MPC_VERSION}.${MPC_SUFFIX}" \
  "${MPC_URL}/mpc-${MPC_VERSION}.${MPC_SUFFIX}" || \
  die "download mpc error" && \
    touch mpc_download

#mpfr-3.1.0.tar.bz2
[ -f mpfr_download ] || \
download "mpfr-${MPFR_VERSION}.${MPFR_SUFFIX}" \
  "${MPFR_URL}/mpfr-${MPFR_VERSION}.${MPFR_SUFFIX}" || \
  die "download mpfr error" && \
    touch mpfr_download

#ncurses-5.9.tar.gz
[ -f ncurses_download ] || \
download "ncurses-${NCURSES_VERSION}.${NCURSES_SUFFIX}" \
  "${NCURSES_URL}/ncurses-${NCURSES_VERSION}.${NCURSES_SUFFIX}" || \
  die "download ncurses error" && \
    touch ncurses_download

#newlib-1.20.0.tar.gz
[ -f newlib_download ] || \
download "newlib-${NEWLIB_VERSION}.${NEWLIB_SUFFIX}" \
  "${NEWLIB_URL}/newlib-${NEWLIB_VERSION}.${NEWLIB_SUFFIX}" || \
  die "download newlib error" && \
    touch newlib_download

#openssl-1.0.1c.tar.gz
[ -f openssl_download ] || \
download "openssl-${OPENSSL_VERSION}.${OPENSSL_SUFFIX}" \
  "${OPENSSL_URL}/openssl-${OPENSSL_VERSION}.${OPENSSL_SUFFIX}" || \
  die "download openssl error" && \
    touch openssl_download

#patch-2.6.1.tar.bz2
[ -f patch_download ] || \
download "patch-${PATCH_VERSION}.${PATCH_SUFFIX}" \
  "${PATCH_URL}/patch-${PATCH_VERSION}.${PATCH_SUFFIX}" || \
  die "download patch error" && \
    touch patch_download

#perl-5.14.2.tar.bz2
[ -f perl_download ] || \
download "perl-${PERL_VERSION}.${PERL_SUFFIX}" \
  "${PERL_URL}/perl-${PERL_VERSION}.${PERL_SUFFIX}" || \
  die "download perl error" && \
    touch perl_download

#pkg-config-0.26.tar.gz
[ -f pkg-config_download ] || \
download "pkg-config-${PKG_VERSION}.${PKG_SUFFIX}" \
  "${PKG_URL}/pkg-config-${PKG_VERSION}.${PKG_SUFFIX}" || \
  die "download pkg-config error" && \
    touch pkg-config_download

#ppl-0.11.2.tar.bz2
[ -f ppl_download ] || \
download "ppl-${PPL_VERSION}.${PPL_SUFFIX}" \
  "${PPL_URL}/ppl-${PPL_VERSION}.${PPL_SUFFIX}" || \
  die "download ppl error" && \
    touch ppl_download

#procps-3.2.8.tar.gz
[ -f procps_download ] || \
download "procps-${PROCPS_VERSION}.${PROCPS_SUFFIX}" \
  "${PROCPS_URL}/procps-${PROCPS_VERSION}.${PROCPS_SUFFIX}" || \
  die "download procps error" && \
    touch procps_download

#psmisc-22.17.tar.gz
[ -f psmisc_download ] || \
download "psmisc-${PSMISC_VERSION}.${PSMISC_SUFFIX}" \
  "${PSMISC_URL}/psmisc-${PSMISC_VERSION}.${PSMISC_SUFFIX}" || \
  die "download psmisc error" && \
    touch psmisc_download

#readline-6.2.tar.gz
[ -f readline_download ] || \
download "readline-${READLINE_VERSION}.${READLINE_SUFFIX}" \
  "${READLINE_URL}/readline-${READLINE_VERSION}.${READLINE_SUFFIX}" || \
  die "download readline error" && \
    touch readline_download

#rsyslog-6.2.0.tar.gz
[ -f rsyslog_download ] || \
download "rsyslog-${RSYSLOG_VERSION}.${RSYSLOG_SUFFIX}" \
  "${RSYSLOG_URL}/rsyslog-${RSYSLOG_VERSION}.${RSYSLOG_SUFFIX}" || \
  die "download rsyslog error" && \
    touch rsyslog_download

#sed-4.2.1.tar.bz2
[ -f sed_download ] || \
download "sed-${SED_VERSION}.${SED_SUFFIX}" \
  "${SED_URL}/sed-${SED_VERSION}.${SED_SUFFIX}" || \
  die "download sed error" && \
    touch sed_download

#shadow-4.1.5.tar.bz2
[ -f shadow_download ] || \
download "shadow-${SHADOW_VERSION}.${SHADOW_SUFFIX}" \
  "${SHADOW_URL}/shadow-${SHADOW_VERSION}.${SHADOW_SUFFIX}" || \
  die "download shadow error" && \
    touch shadow_download

#sysfsutils-2.1.0.tar.gz
[ -f sysfsutils_download ] || \
download "sysfsutils-${SYSFSUTILS_VERSION}.${SYSFSUTILS_SUFFIX}" \
  "${SYSFSUTILS_URL}/sysfsutils-${SYSFSUTILS_VERSION}.${SYSFSUTILS_SUFFIX}" || \
  die "download sysfsutils error" && \
    touch sysfsutils_download

#sysvinit-2.88dsf.tar.bz2
[ -f sysvinit_download ] || \
download "sysvinit-${SYSVINIT_VERSION}.${SYSVINIT_SUFFIX}" \
  "${SYSVINIT_URL}/sysvinit-${SYSVINIT_VERSION}.${SYSVINIT_SUFFIX}" || \
  die "download sysvinit error" && \
    touch sysvinit_download

#tar-1.26.tar.bz2
[ -f tar_download ] || \
download "tar-${TAR_VERSION}.${TAR_SUFFIX}" \
  "${TAR_URL}/tar-${TAR_VERSION}.${TAR_SUFFIX}" || \
  die "download tar error" && \
    touch tar_download

#tcl8.5.11-src.tar.gz
[ -f tcl_download ] || \
download "tcl${TCL_VERSION}.${TCL_SUFFIX}" \
  "${TCL_URL}/tcl${TCL_VERSION}.${TCL_SUFFIX}" || \
  die "download tcl error" && \
    touch tcl_download

#termcap-1.3.1.tar.gz
[ -f termcap_download ] || \
download "termcap-${TERMCAP_VERSION}.${TERMCAP_SUFFIX}" \
  "${TERMCAP_URL}/termcap-${TERMCAP_VERSION}.${TERMCAP_SUFFIX}" || \
  die "download termcap error" && \
    touch termcap_download

#texinfo-4.13a.tar.gz
[ -f texinfo_download ] || \
download "texinfo-${TEXINFO_VERSION}.${TEXINFO_SUFFIX}" \
  "${TEXINFO_URL}/texinfo-${TEXINFO_VERSION}.${TEXINFO_SUFFIX}" || \
  die "download texinfo error" && \
    touch texinfo_download

#tk8.5.11-src.tar.gz
[ -f tk_download ] || \
download "tk${TK_VERSION}.${TK_SUFFIX}" \
  "${TK_URL}/tk${TK_VERSION}.${TK_SUFFIX}" || \
  die "download tk error" && \
    touch tk_download

#uClibc-0.9.33.2.tar.xz
[ -f uClibc_download ] || \
download "uClibc-${UCLIBC_VERSION}.${UCLIBC_SUFFIX}" \
  "${UCLIBC_URL}/uClibc-${UCLIBC_VERSION}.${UCLIBC_SUFFIX}" || \
  die "download uClibc error" && \
    touch uClibc_download

#udev-182.tar.xz
[ -f udev_download ] || \
download "udev-${UDEV_VERSION}.${UDEV_SUFFIX}" \
  "${UDEV_URL}/udev-${UDEV_VERSION}.${UDEV_SUFFIX}" || \
  die "download udev error" && \
    touch udev_download

#util-linux-2.20.1.tar.bz2
[ -f util-linux_download ] || \
download "util-${UTIL_VERSION}.${UTIL_SUFFIX}" \
  "${UTIL_URL}/util-${UTIL_VERSION}.${UTIL_SUFFIX}" || \
  die "download util-linux error" && \
    touch util-linux_download

#vim-7.3.tar.bz2
[ -f vim_download ] || \
download "vim-${VIM_VERSION}.${VIM_SUFFIX}" \
  "${VIM_URL}/vim-${VIM_VERSION}.${VIM_SUFFIX}" || \
  die "download vim error" && \
    touch vim_download

#wxGTK-2.8.8.tar.bz2
[ -f wxGTK_download ] || \
download "wxGTK-${WXGTK_VERSION}.${WXGTK_SUFFIX}" \
  "${WXGTK_URL}/wxGTK-${WXGTK_VERSION}.${WXGTK_SUFFIX}" || \
  die "download wxGTK error" && \
    touch wxGTK_download

#xz-5.0.3.tar.bz2
[ -f xz_download ] || \
download "xz-${XZ_VERSION}.${XZ_SUFFIX}" \
  "${XZ_URL}/xz-${XZ_VERSION}.${XZ_SUFFIX}" || \
  die "download xz error" && \
    touch xz_download

#zlib-1.2.7.tar.bz2
[ -f zlib_download ] || \
download "zlib-${ZLIB_VERSION}.${ZLIB_SUFFIX}" \
  "${ZLIB_URL}/zlib-${ZLIB_VERSION}.${ZLIB_SUFFIX}" || \
  die "download zlib error" && \
    touch zlib_download

#qt-creator-2.5.2-src.tar.gz
[ -f qt-creator_download ] || \
download "qt-creator-${QTC_VERSION}.${QTC_SUFFIX}" \
  "${QTC_URL}/qt-creator-${QTC_VERSION}.${QTC_SUFFIX}" || \
  die "download qt-creator error" && \
    touch qt-creator_download
popd

pushd ${SRC_LIVE}
#qemu
[ -f ${METADATADOWN}/qemu_git ] || \
  git clone ${QEMU_GITURL} || \
  die "download qemu error" && \
    touch ${METADATADOWN}/qemu_git

#openocd
[ -f ${METADATADOWN}/openocd_git ] || \
  git clone ${OPENOCD_GITURL} || \
  die "download openocd error" && \
    touch ${METADATADOWN}/openocd_git

#uboot
[ -f ${METADATADOWN}/uboot_git ] || \
  git clone ${UBOOT_GITURL} || \
  die "download uboot error" && \
    touch ${METADATADOWN}/uboot_git

[ -f ${METADATADOWN}/rtems_git ] || \
  git clone ${RTEMS_GITURL} || \
  die "download rtems error" && \
    touch ${METADATADOWN}/rtems_git

#crossprojectmanager
[ -f ${METADATADOWN}/crossprojectmanager_git ] || \
  git clone ${CROSSPROJECTMANAGER_GITURL} || \
  die "download IDE plugin error" && \
    touch ${METADATADOWN}/crossprojectmanager_git
popd
