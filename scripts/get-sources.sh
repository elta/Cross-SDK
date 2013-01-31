#! /bin/bash

source source.sh

[ -d "${TARBALL}" ] || mkdir -p "${TARBALL}"
[ -d "${SRC_LIVE}" ] || mkdir -p "${SRC_LIVE}"
[ -d "${METADATADOWN}" ] || mkdir -p "${METADATADOWN}"

pushd ${METADATADOWN}

[ -f autoconf_download ] || \
download "autoconf-${AUTOCONF_VERSION}.${AUTOCONF_SUFFIX}" \
  "${AUTOCONF_URL}/autoconf-${AUTOCONF_VERSION}.${AUTOCONF_SUFFIX}" || \
  die "download autoconf error" && \
    touch autoconf_download

[ -f automake_download ] || \
download "automake-${AUTOMAKE_VERSION}.${AUTOMAKE_SUFFIX}" \
  "${AUTOMAKE_URL}/automake-${AUTOMAKE_VERSION}.${AUTOMAKE_SUFFIX}" || \
  die "download automake error" && \
    touch automake_download

[ -f bash_download ] || \
download "bash-${BASH_VERSION}.${BASH_SUFFIX}" \
  "${BASH_URL}/bash-${BASH_VERSION}.${BASH_SUFFIX}" || \
  die "download bash error" && \
    touch bash_download

[ -f binutils_download ] || \
download "binutils-${BINUTILS_VERSION}.${BINUTILS_SUFFIX}" \
  "${BINUTILS_URL}/binutils-${BINUTILS_VERSION}.${BINUTILS_SUFFIX}" || \
  die "download binutils error" && \
    touch binutils_download

[ -f bison_download ] || \
download "bison-${BISON_VERSION}.${BISON_SUFFIX}" \
  "${BISON_URL}/bison-${BISON_VERSION}.${BISON_SUFFIX}" || \
  die "download bison error" && \
    touch bison_download

[ -f bootscripts_download ] || \
download "bootscripts-cross-lfs-${BOOTSCRIPTS_VERSION}.${BOOTSCRIPTS_SUFFIX}" \
  "${BOOTSCRIPTS_URL}/bootscripts-cross-lfs-${BOOTSCRIPTS_VERSION}.${BOOTSCRIPTS_SUFFIX}" || \
  die "download bootscripts error" && \
    touch bootscripts_download

[ -f busybox_download ] || \
download "busybox-${BUSYBOX_VERSION}.${BUSYBOX_SUFFIX}" \
  "${BUSYBOX_URL}/busybox-${BUSYBOX_VERSION}.${BUSYBOX_SUFFIX}" || \
  die "download busybox error" && \
    touch busybox_download

[ -f bzip2_download ] || \
download "bzip2-${BZIP2_VERSION}.${BZIP2_SUFFIX}" \
  "${BZIP2_URL}/bzip2-${BZIP2_VERSION}.${BZIP2_SUFFIX}" || \
  die "download bzip2 error" && \
    touch bzip2_download

[ -f cloog_download ] || \
download "cloog-${CLOOG_VERSION}.${CLOOG_SUFFIX}" \
  "${CLOOG_URL}/cloog-${CLOOG_VERSION}.${CLOOG_SUFFIX}" || \
  die "download cloog error" && \
    touch cloog_download

[ -f coreutils_download ] || \
download "coreutils-${COREUTILS_VERSION}.${COREUTILS_SUFFIX}" \
  "${COREUTILS_URL}/coreutils-${COREUTILS_VERSION}.${COREUTILS_SUFFIX}" || \
  die "download coreutils error" && \
    touch coreutils_download

[ -f dbus_download ] || \
download "dbus-${DBUS_VERSION}.${DBUS_SUFFIX}" \
  "${DBUS_URL}/dbus-${DBUS_VERSION}.${DBUS_SUFFIX}" || \
  die "download dbus error" && \
    touch dbus_download

[ -f dejagnu_download ] || \
download "dejagnu-${DEJAGNU_VERSION}.${DEJAGNU_SUFFIX}" \
  "${DEJAGNU_URL}/dejagnu-${DEJAGNU_VERSION}.${DEJAGNU_SUFFIX}" || \
  die "download dejagnu error" && \
    touch dejagnu_download

[ -f dhcpcd_download ] || \
download "dhcpcd-${DHCPCD_VERSION}.${DHCPCD_SUFFIX}" \
  "${DHCPCD_URL}/dhcpcd-${DHCPCD_VERSION}.${DHCPCD_SUFFIX}" || \
  die "download dhcpcd error" && \
    touch dhcpcd_download

[ -f diffutils_download ] || \
download "diffutils-${DIFFUTILS_VERSION}.${DIFFUTILS_SUFFIX}" \
  "${DIFFUTILS_URL}/diffutils-${DIFFUTILS_VERSION}.${DIFFUTILS_SUFFIX}" || \
  die "download diffutils error" && \
    touch diffutils_download

[ -f dvhtool_download ] || \
download "dvhtool_${DVHTOOL_VERSION}.${DVHTOOL_SUFFIX}" \
  "${DVHTOOL_URL}/dvhtool_${DVHTOOL_VERSION}.${DVHTOOL_SUFFIX}" || \
  die "download dvhtool error" && \
    touch dvhtool_download

[ -f e2fsprogs_download ] || \
download "e2fsprogs-${E2FSPROGS_VERSION}.${E2FSPROGS_SUFFIX}" \
  "${E2FSPROGS_URL}/e2fsprogs-${E2FSPROGS_VERSION}.${E2FSPROGS_SUFFIX}" || \
  die "download e2fsprogs error" && \
    touch e2fsprogs_download

[ -f elfutils_download ] || \
download "elfutils-${ELFUTILS_VERSION}.${ELFUTILS_SUFFIX}" \
  "${ELFUTILS_URL}/elfutils-${ELFUTILS_VERSION}.${ELFUTILS_SUFFIX}" || \
  die "download elfutils error" && \
    touch elfutils_download

[ -f expat_download ] || \
download "expat-${EXPAT_VERSION}.${EXPAT_SUFFIX}" \
  "${EXPAT_URL}/expat-${EXPAT_VERSION}.${EXPAT_SUFFIX}" || \
  die "download expat error" && \
    touch expat_download

[ -f expect_download ] || \
download "expect${EXPECT_VERSION}.${EXPECT_SUFFIX}" \
  "${EXPECT_URL}/expect${EXPECT_VERSION}.${EXPECT_SUFFIX}" || \
  die "download expect error" && \
    touch expect_download

[ -f file_download ] || \
download "file-${FILE_VERSION}.${FILE_SUFFIX}" \
  "${FILE_URL}/file-${FILE_VERSION}.${FILE_SUFFIX}" || \
  die "download file error" && \
    touch file_download

[ -f findutils_download ] || \
download "findutils-${FINDUTILS_VERSION}.${FINDUTILS_SUFFIX}" \
  "${FINDUTILS_URL}/findutils-${FINDUTILS_VERSION}.${FINDUTILS_SUFFIX}" || \
  die "download findutils error" && \
    touch findutils_download

[ -f flex_download ] || \
download "flex-${FLEX_VERSION}.${FLEX_SUFFIX}" \
  "${FLEX_URL}/flex-${FLEX_VERSION}.${FLEX_SUFFIX}" || \
  die "download flex error" && \
    touch flex_download

[ -f gawk_download ] || \
download "gawk-${GAWK_VERSION}.${GAWK_SUFFIX}" \
  "${GAWK_URL}/gawk-${GAWK_VERSION}.${GAWK_SUFFIX}" || \
  die "download gawk error" && \
    touch gawk_download

[ -f gcc_download ] || \
download "gcc-${GCC_VERSION}.${GCC_SUFFIX}" \
  "${GCC_URL}/gcc-${GCC_VERSION}.${GCC_SUFFIX}" || \
  die "download gcc error" && \
    touch gcc_download

[ -f gdb_download ] || \
download "gdb-${GDB_VERSION}.${GDB_SUFFIX}" \
  "${GDB_URL}/gdb-${GDB_VERSION}.${GDB_SUFFIX}" || \
  die "download gdb error" && \
    touch gdb_download

[ -f gettext_download ] || \
download "gettext-${GETTEXT_VERSION}.${GETTEXT_SUFFIX}" \
  "${GETTEXT_URL}/gettext-${GETTEXT_VERSION}.${GETTEXT_SUFFIX}" || \
  die "download gettext error" && \
    touch gettext_download

[ -f glib_download ] || \
download "glib-${GLIB_VERSION}.${GLIB_SUFFIX}" \
  "${GLIB_URL}/glib-${GLIB_VERSION}.${GLIB_SUFFIX}" || \
  die "download glib error" && \
    touch glib_download

[ -f glibc_download ] || \
download "glibc-${GLIBC_VERSION}.${GLIBC_SUFFIX}" \
  "${GLIBC_URL}/glibc-${GLIBC_VERSION}.${GLIBC_SUFFIX}" || \
  die "download glibc error" && \
    touch glibc_download

[ -f gmp_download ] || \
download "gmp-${GMP_VERSION}.${GMP_SUFFIX}" \
  "${GMP_URL}/gmp-${GMP_VERSION}.${GMP_SUFFIX}" || \
  die "download gmp error" && \
    touch gmp_download

[ -f grep_download ] || \
download "grep-${GREP_VERSION}.${GREP_SUFFIX}" \
  "${GREP_URL}/grep-${GREP_VERSION}.${GREP_SUFFIX}" || \
  die "download grep error" && \
    touch grep_download

[ -f groff_download ] || \
download "groff-${GROFF_VERSION}.${GROFF_SUFFIX}" \
  "${GROFF_URL}/groff-${GROFF_VERSION}.${GROFF_SUFFIX}" || \
  die "download groff error" && \
    touch groff_download

[ -f gzip_download ] || \
download "gzip-${GZIP_VERSION}.${GZIP_SUFFIX}" \
  "${GZIP_URL}/gzip-${GZIP_VERSION}.${GZIP_SUFFIX}" || \
  die "download gzip error" && \
    touch gzip_download

[ -f iana-etc_download ] || \
download "iana-etc-${IANA_VERSION}.${IANA_SUFFIX}" \
  "${IANA_URL}/iana-etc-${IANA_VERSION}.${IANA_SUFFIX}" || \
  die "download iana-etc error" && \
    touch iana-etc_download

[ -f iproute2_download ] || \
download "iproute2-${IPROUTE2_VERSION}.${IPROUTE2_SUFFIX}" \
  "${IPROUTE2_URL}/iproute2-${IPROUTE2_VERSION}.${IPROUTE2_SUFFIX}" || \
  die "download iproute error" && \
    touch iproute2_download

[ -f iputils_download ] || \
download "iputils-${IPUTILS_VERSION}.${IPUTILS_SUFFIX}" \
  "${IPUTILS_URL}/iputils-${IPUTILS_VERSION}.${IPUTILS_SUFFIX}" || \
  die "download iputils error" && \
    touch iputils_download

[ -f jsonc_download ] || \
download "json-c-${JSONC_VERSION}.${JSONC_SUFFIX}" \
  "${JSONC_URL}/json-c-${JSONC_VERSION}.${JSONC_SUFFIX}" || \
  die "download json-c error" && \
    touch jsonc_download

[ -f kbd_download ] || \
download "kbd-${KBD_VERSION}.${KBD_SUFFIX}" \
  "${KBD_URL}/kbd-${KBD_VERSION}.${KBD_SUFFIX}" || \
  die "download kbd error" && \
    touch kbd_download

[ -f kmod_download ] || \
download "kmod-${KMOD_VERSION}.${KMOD_SUFFIX}" \
  "${KMOD_URL}/kmod-${KMOD_VERSION}.${KMOD_SUFFIX}" || \
  die "download kmod error" && \
    touch kmod_download

[ -f less_download ] || \
download "less-${LESS_VERSION}.${LESS_SUFFIX}" \
  "${LESS_URL}/less-${LESS_VERSION}.${LESS_SUFFIX}" || \
  die "download less error" && \
    touch less_download

[ -f libee_download ] || \
download "libee-${LIBEE_VERSION}.${LIBEE_SUFFIX}" \
  "${LIBEE_URL}/libee-${LIBEE_VERSION}.${LIBEE_SUFFIX}" || \
  die "download libee error" && \
    touch libee_download

[ -f libestr_download ] || \
download "libestr-${LIBESTR_VERSION}.${LIBESTR_SUFFIX}" \
  "${LIBESTR_URL}/libestr-${LIBESTR_VERSION}.${LIBESTR_SUFFIX}" || \
  die "download libestr error" && \
    touch libestr_download

[ -f libtool_download ] || \
download "libtool-${LIBTOOL_VERSION}.${LIBTOOL_SUFFIX}" \
  "${LIBTOOL_URL}/libtool-${LIBTOOL_VERSION}.${LIBTOOL_SUFFIX}" || \
  die "download libtool error" && \
    touch libtool_download

[ -f libiconv_download ] || \
download "libiconv-${LIBICONV_VERSION}.${LIBICONV_SUFFIX}" \
  "${LIBICONV_URL}/libiconv-${LIBICONV_VERSION}.${LIBICONV_SUFFIX}" || \
  die "download libiconv error" && \
    touch libiconv_download

[ -f linux_download ] || \
download "linux-${LINUX_VERSION}.${LINUX_SUFFIX}" \
  "${LINUX_URL}/linux-${LINUX_VERSION}.${LINUX_SUFFIX}" || \
  die "download linux error" && \
    touch linux_download

[ -f llvm_download ] || \
download "llvm-${LLVM_VERSION}.${LLVM_SUFFIX}" \
  "${LLVM_URL}/llvm-${LLVM_VERSION}.${LLVM_SUFFIX}" || \
  die "download llvm error" && \
    touch llvm_download

[ -f clang_download ] || \
download "clang-${CLANG_VERSION}.${CLANG_SUFFIX}" \
  "${CLANG_URL}/clang-${CLANG_VERSION}.${CLANG_SUFFIX}" || \
  die "download clang error" && \
    touch clang_download

[ -f crt_download ] || \
download "compiler-rt-${CRT_VERSION}.${CRT_SUFFIX}" \
  "${CRT_URL}/compiler-rt-${CRT_VERSION}.${CRT_SUFFIX}" || \
  die "download compiler-rt error" && \
    touch crt_download

[ -f m4_download ] || \
download "m4-${M4_VERSION}.${M4_SUFFIX}" \
  "${M4_URL}/m4-${M4_VERSION}.${M4_SUFFIX}" || \
  die "download m4 error" && \
    touch m4_download

[ -f make_download ] || \
download "make-${MAKE_VERSION}.${MAKE_SUFFIX}" \
  "${MAKE_URL}/make-${MAKE_VERSION}.${MAKE_SUFFIX}" || \
  die "download make error" && \
    touch make_download

[ -f man_download ] || \
download "man-${MAN_VERSION}.${MAN_SUFFIX}" \
  "${MAN_URL}/man-${MAN_VERSION}.${MAN_SUFFIX}" || \
  die "download man error" && \
    touch man_download

[ -f man-pages_download ] || \
download "man-pages-${MANPAGES_VERSION}.${MANPAGES_SUFFIX}" \
  "${MANPAGES_URL}/man-pages-${MANPAGES_VERSION}.${MANPAGES_SUFFIX}" || \
  die "download man-pages error" && \
    touch man-pages_download

[ -f module-init-tools_download ] || \
download "module-init-tools-${MODULE_VERSION}.${MODULE_SUFFIX}" \
  "${MODULE_URL}/module-init-tools-${MODULE_VERSION}.${MODULE_SUFFIX}" || \
  die "download moudle-init-tools error" && \
    touch module-init-tools_download

[ -f mpc_download ] || \
download "mpc-${MPC_VERSION}.${MPC_SUFFIX}" \
  "${MPC_URL}/mpc-${MPC_VERSION}.${MPC_SUFFIX}" || \
  die "download mpc error" && \
    touch mpc_download

[ -f mpfr_download ] || \
download "mpfr-${MPFR_VERSION}.${MPFR_SUFFIX}" \
  "${MPFR_URL}/mpfr-${MPFR_VERSION}.${MPFR_SUFFIX}" || \
  die "download mpfr error" && \
    touch mpfr_download

[ -f ncurses_download ] || \
download "ncurses-${NCURSES_VERSION}.${NCURSES_SUFFIX}" \
  "${NCURSES_URL}/ncurses-${NCURSES_VERSION}.${NCURSES_SUFFIX}" || \
  die "download ncurses error" && \
    touch ncurses_download

[ -f openssl_download ] || \
download "openssl-${OPENSSL_VERSION}.${OPENSSL_SUFFIX}" \
  "${OPENSSL_URL}/openssl-${OPENSSL_VERSION}.${OPENSSL_SUFFIX}" || \
  die "download openssl error" && \
    touch openssl_download

[ -f patch_download ] || \
download "patch-${PATCH_VERSION}.${PATCH_SUFFIX}" \
  "${PATCH_URL}/patch-${PATCH_VERSION}.${PATCH_SUFFIX}" || \
  die "download patch error" && \
    touch patch_download

[ -f perl_download ] || \
download "perl-${PERL_VERSION}.${PERL_SUFFIX}" \
  "${PERL_URL}/perl-${PERL_VERSION}.${PERL_SUFFIX}" || \
  die "download perl error" && \
    touch perl_download

[ -f perlcross_download ] || \
download "perl-${PERLCROSS_VERSION}.${PERLCROSS_SUFFIX}" \
  "${PERLCROSS_URL}/perl-${PERLCROSS_VERSION}.${PERLCROSS_SUFFIX}/download" || \
  die "download perlcross error" && \
    touch perlcross_download

[ -f pkg-config_download ] || \
download "pkg-config-${PKG_VERSION}.${PKG_SUFFIX}" \
  "${PKG_URL}/pkg-config-${PKG_VERSION}.${PKG_SUFFIX}" || \
  die "download pkg-config error" && \
    touch pkg-config_download

[ -f ppl_download ] || \
download "ppl-${PPL_VERSION}.${PPL_SUFFIX}" \
  "${PPL_URL}/ppl-${PPL_VERSION}.${PPL_SUFFIX}" || \
  die "download ppl error" && \
    touch ppl_download

[ -f procps_download ] || \
download "procps-${PROCPS_VERSION}.${PROCPS_SUFFIX}" \
  "${PROCPS_URL}/procps-${PROCPS_VERSION}.${PROCPS_SUFFIX}" || \
  die "download procps error" && \
    touch procps_download

[ -f psmisc_download ] || \
download "psmisc-${PSMISC_VERSION}.${PSMISC_SUFFIX}" \
  "${PSMISC_URL}/psmisc-${PSMISC_VERSION}.${PSMISC_SUFFIX}" || \
  die "download psmisc error" && \
    touch psmisc_download

[ -f python_download ] || \
download "python-${PYTHON_VERSION}.${PYTHON_SUFFIX}" \
  "${PYTHON_URL}/Python-${PYTHON_VERSION}.${PYTHON_SUFFIX}" || \
  die "download python error" && \
    touch python_download

[ -f readline_download ] || \
download "readline-${READLINE_VERSION}.${READLINE_SUFFIX}" \
  "${READLINE_URL}/readline-${READLINE_VERSION}.${READLINE_SUFFIX}" || \
  die "download readline error" && \
    touch readline_download

[ -f rsyslog_download ] || \
download "rsyslog-${RSYSLOG_VERSION}.${RSYSLOG_SUFFIX}" \
  "${RSYSLOG_URL}/rsyslog-${RSYSLOG_VERSION}.${RSYSLOG_SUFFIX}" || \
  die "download rsyslog error" && \
    touch rsyslog_download

[ -f sed_download ] || \
download "sed-${SED_VERSION}.${SED_SUFFIX}" \
  "${SED_URL}/sed-${SED_VERSION}.${SED_SUFFIX}" || \
  die "download sed error" && \
    touch sed_download

[ -f shadow_download ] || \
download "shadow-${SHADOW_VERSION}.${SHADOW_SUFFIX}" \
  "${SHADOW_URL}/shadow-${SHADOW_VERSION}.${SHADOW_SUFFIX}" || \
  die "download shadow error" && \
    touch shadow_download

[ -f sysfsutils_download ] || \
download "sysfsutils-${SYSFSUTILS_VERSION}.${SYSFSUTILS_SUFFIX}" \
  "${SYSFSUTILS_URL}/sysfsutils-${SYSFSUTILS_VERSION}.${SYSFSUTILS_SUFFIX}" || \
  die "download sysfsutils error" && \
    touch sysfsutils_download

[ -f sysvinit_download ] || \
download "sysvinit-${SYSVINIT_VERSION}.${SYSVINIT_SUFFIX}" \
  "${SYSVINIT_URL}/sysvinit-${SYSVINIT_VERSION}.${SYSVINIT_SUFFIX}" || \
  die "download sysvinit error" && \
    touch sysvinit_download

[ -f tar_download ] || \
download "tar-${TAR_VERSION}.${TAR_SUFFIX}" \
  "${TAR_URL}/tar-${TAR_VERSION}.${TAR_SUFFIX}" || \
  die "download tar error" && \
    touch tar_download

[ -f termcap_download ] || \
download "termcap-${TERMCAP_VERSION}.${TERMCAP_SUFFIX}" \
  "${TERMCAP_URL}/termcap-${TERMCAP_VERSION}.${TERMCAP_SUFFIX}" || \
  die "download termcap error" && \
    touch termcap_download

[ -f texinfo_download ] || \
download "texinfo-${TEXINFO_VERSION}a.${TEXINFO_SUFFIX}" \
  "${TEXINFO_URL}/texinfo-${TEXINFO_VERSION}a.${TEXINFO_SUFFIX}" || \
  die "download texinfo error" && \
    touch texinfo_download

[ -f udev_download ] || \
download "udev-${UDEV_VERSION}.${UDEV_SUFFIX}" \
  "${UDEV_URL}/udev-${UDEV_VERSION}.${UDEV_SUFFIX}" || \
  die "download udev error" && \
    touch udev_download

[ -f util-linux_download ] || \
download "util-${UTIL_VERSION}.${UTIL_SUFFIX}" \
  "${UTIL_URL}/util-${UTIL_VERSION}.${UTIL_SUFFIX}" || \
  die "download util-linux error" && \
    touch util-linux_download

[ -f vim_download ] || \
download "vim-${VIM_VERSION}.${VIM_SUFFIX}" \
  "${VIM_URL}/vim-${VIM_VERSION}.${VIM_SUFFIX}" || \
  die "download vim error" && \
    touch vim_download

[ -f xz_download ] || \
download "xz-${XZ_VERSION}.${XZ_SUFFIX}" \
  "${XZ_URL}/xz-${XZ_VERSION}.${XZ_SUFFIX}" || \
  die "download xz error" && \
    touch xz_download

[ -f zlib_download ] || \
download "zlib-${ZLIB_VERSION}.${ZLIB_SUFFIX}" \
  "${ZLIB_URL}/zlib-${ZLIB_VERSION}.${ZLIB_SUFFIX}" || \
  die "download zlib error" && \
    touch zlib_download

[ -f qt-creator_download ] || \
download "qt-creator-${QTC_VERSION}.${QTC_SUFFIX}" \
  "${QTC_URL}/qt-creator-${QTC_VERSION}.${QTC_SUFFIX}" || \
  die "download qt-creator error" && \
    touch qt-creator_download

[ -f qemu_download ] || \
download "qemu-${QEMU_VERSION}.${QEMU_SUFFIX}" \
  "${QEMU_URL}/qemu-${QEMU_VERSION}.${QEMU_SUFFIX}" || \
  die "download qemu error" && \
    touch qemu_download

[ -f uboot_download ] || \
download "u-boot-${UBOOT_VERSION}.${UBOOT_SUFFIX}" \
  "${UBOOT_URL}/u-boot-${UBOOT_VERSION}.${UBOOT_SUFFIX}" || \
  die "download u-boot error" && \
    touch uboot_download
popd

pushd ${SRC_LIVE}
[ -f ${METADATADOWN}/openocd_git ] || \
  git clone ${OPENOCD_GITURL} || \
  die "download openocd error" && \
    touch ${METADATADOWN}/openocd_git

[ -f ${METADATADOWN}/llvmlinux_git ] || \
  git clone ${LLVMLINUX_GITURL} || \
  die "download llvmlinux error" && \
    touch ${METADATADOWN}/llvmlinux_git

[ -f ${METADATADOWN}/crossprojectmanager_git ] || \
  git clone ${CROSSPROJECTMANAGER_GITURL} || \
  die "download IDE plugin error" && \
    touch ${METADATADOWN}/crossprojectmanager_git
popd
