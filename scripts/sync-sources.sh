#! /bin/bash

source common/source.env

[ -d "${METADATADOWN}" ] || mkdir -p "${METADATADOWN}"

pushd ${METADATADOWN}
echo -n "autoconf-${AUTOCONF_VERSION}.${AUTOCONF_SUFFIX}" > autoconf_download
echo -n "automake-${AUTOMAKE_VERSION}.${AUTOMAKE_SUFFIX}" > automake_download
echo -n "bash-${BASH_VERSION}.${BASH_SUFFIX}" > bash_download
echo -n "bash-completion-${BASHCOMPLETION_VERSION}.${BASHCOMPLETION_SUFFIX}" > bash_completion_download
echo -n "binutils-${BINUTILS_VERSION}.${BINUTILS_SUFFIX}" > binutils_download
echo -n "bison-${BISON_VERSION}.${BISON_SUFFIX}" > bison_download
echo -n "bootscripts-cross-lfs-${BOOTSCRIPTS_VERSION}.${BOOTSCRIPTS_SUFFIX}" > bootscripts_download
echo -n "bzip2-${BZIP2_VERSION}.${BZIP2_SUFFIX}" > bzip2_download
echo -n "cloog-${CLOOG_VERSION}.${CLOOG_SUFFIX}" > cloog_download
echo -n "coreutils-${COREUTILS_VERSION}.${COREUTILS_SUFFIX}" > coreutils_download
echo -n "dbus-${DBUS_VERSION}.${DBUS_SUFFIX}" > dbus_download
echo -n "dejagnu-${DEJAGNU_VERSION}.${DEJAGNU_SUFFIX}" > dejagnu_download
echo -n "dhcpcd-${DHCPCD_VERSION}.${DHCPCD_SUFFIX}" > dhcpcd_download
echo -n "diffutils-${DIFFUTILS_VERSION}.${DIFFUTILS_SUFFIX}" > diffutils_download
echo -n "dvhtool_${DVHTOOL_VERSION}.${DVHTOOL_SUFFIX}" > dvhtool_download
echo -n "e2fsprogs-${E2FSPROGS_VERSION}.${E2FSPROGS_SUFFIX}" > e2fsprogs_download
echo -n "elfutils-${ELFUTILS_VERSION}.${ELFUTILS_SUFFIX}" > elfutils_download
echo -n "expat-${EXPAT_VERSION}.${EXPAT_SUFFIX}" > expat_download
echo -n "expect${EXPECT_VERSION}.${EXPECT_SUFFIX}" > expect_download
echo -n "findutils-${FINDUTILS_VERSION}.${FINDUTILS_SUFFIX}" > findutils_download
echo -n "flex-${FLEX_VERSION}.${FLEX_SUFFIX}" > flex_download
echo -n "gawk-${GAWK_VERSION}.${GAWK_SUFFIX}" > gawk_download
echo -n "gcc-${GCC_VERSION}.${GCC_SUFFIX}" > gcc_download
echo -n "gdb-${GDB_VERSION}.${GDB_SUFFIX}" > gdb_download
echo -n "gettext-${GETTEXT_VERSION}.${GETTEXT_SUFFIX}" > gettext_download
echo -n "glib-${GLIB_VERSION}.${GLIB_SUFFIX}" > glib_download
echo -n "glibc-${GLIBC_VERSION}.${GLIBC_SUFFIX}" > glibc_download
echo -n "gmp-${GMP_VERSION}.${GMP_SUFFIX}" > gmp_download
echo -n "grep-${GREP_VERSION}.${GREP_SUFFIX}" > grep_download
echo -n "groff-${GROFF_VERSION}.${GROFF_SUFFIX}" > groff_download
echo -n "gzip-${GZIP_VERSION}.${GZIP_SUFFIX}" > gzip_download
echo -n "iana-etc-${IANA_VERSION}.${IANA_SUFFIX}" > iana-etc_download
echo -n "iproute2-${IPROUTE2_VERSION}.${IPROUTE2_SUFFIX}" > iproute2_download
echo -n "iputils-${IPUTILS_VERSION}.${IPUTILS_SUFFIX}" > iputils_download
echo -n "json-c-${JSONC_VERSION}.${JSONC_SUFFIX}" > jsonc_download
echo -n "kbd-${KBD_VERSION}.${KBD_SUFFIX}" > kbd_download
echo -n "kmod-${KMOD_VERSION}.${KMOD_SUFFIX}" > kmod_download
echo -n "less-${LESS_VERSION}.${LESS_SUFFIX}" > less_download
echo -n "libee-${LIBEE_VERSION}.${LIBEE_SUFFIX}" > libee_download
echo -n "libelf-${LIBELF_VERSION}.${LIBELF_SUFFIX}"  > libelf_download
echo -n "libestr-${LIBESTR_VERSION}.${LIBESTR_SUFFIX}" > libestr_download
echo -n "libtool-${LIBTOOL_VERSION}.${LIBTOOL_SUFFIX}" > libtool_download
echo -n "libiconv-${LIBICONV_VERSION}.${LIBICONV_SUFFIX}" >  libiconv_download
echo -n "linux-${LINUX_VERSION}.${LINUX_SUFFIX}" >  linux_download
echo -n "llvm-${LLVM_VERSION}.${LLVM_SUFFIX}" > llvm_download
echo -n "cfe-${CLANG_VERSION}.${CLANG_SUFFIX}" > clang_download
echo -n "compiler-rt-${CRT_VERSION}.${CRT_SUFFIX}" > crt_download
echo -n "m4-${M4_VERSION}.${M4_SUFFIX}" > m4_download
echo -n "make-${MAKE_VERSION}.${MAKE_SUFFIX}" > make_download
echo -n "man-${MAN_VERSION}.${MAN_SUFFIX}" > man_download
echo -n "man-pages-${MANPAGES_VERSION}.${MANPAGES_SUFFIX}" > man-pages_download
echo -n "module-init-tools-${MODULE_VERSION}.${MODULE_SUFFIX}" > module-init-tools_download
echo -n "mpc-${MPC_VERSION}.${MPC_SUFFIX}" > mpc_download
echo -n "mpfr-${MPFR_VERSION}.${MPFR_SUFFIX}" > mpfr_download
echo -n "ncurses-${NCURSES_VERSION}.${NCURSES_SUFFIX}" > ncurses_download
echo -n "openssl-${OPENSSL_VERSION}.${OPENSSL_SUFFIX}" > openssl_download
echo -n "patch-${PATCH_VERSION}.${PATCH_SUFFIX}" > patch_download
echo -n "perl-${PERL_VERSION}.${PERL_SUFFIX}" > perl_download
echo -n "perl-${PERLCROSS_VERSION}.${PERLCROSS_SUFFIX}" > perlcross_download
echo -n "pkg-config-${PKG_VERSION}.${PKG_SUFFIX}" > pkg-config_download
echo -n "ppl-${PPL_VERSION}.${PPL_SUFFIX}" > ppl_download
echo -n "procps-${PROCPS_VERSION}.${PROCPS_SUFFIX}" > procps_download
echo -n "psmisc-${PSMISC_VERSION}.${PSMISC_SUFFIX}" > psmisc_download
echo -n "python-${PYTHON_VERSION}.${PYTHON_SUFFIX}" > python_download
echo -n "readline-${READLINE_VERSION}.${READLINE_SUFFIX}" > readline_download
echo -n "rsyslog-${RSYSLOG_VERSION}.${RSYSLOG_SUFFIX}" > rsyslog_download
echo -n "sed-${SED_VERSION}.${SED_SUFFIX}" > sed_download
echo -n "shadow-${SHADOW_VERSION}.${SHADOW_SUFFIX}" > shadow_download
echo -n "sysfsutils-${SYSFSUTILS_VERSION}.${SYSFSUTILS_SUFFIX}" > sysfsutils_download
echo -n "sysvinit-${SYSVINIT_VERSION}.${SYSVINIT_SUFFIX}" > sysvinit_download
echo -n "tar-${TAR_VERSION}.${TAR_SUFFIX}" > tar_download
echo -n "termcap-${TERMCAP_VERSION}.${TERMCAP_SUFFIX}" > termcap_download
echo -n "texinfo-${TEXINFO_VERSION}a.${TEXINFO_SUFFIX}" > texinfo_download
echo -n "udev-${UDEV_VERSION}.${UDEV_SUFFIX}" > udev_download
echo -n "util-${UTIL_VERSION}.${UTIL_SUFFIX}" > util-linux_download
echo -n "vim-${VIM_VERSION}.${VIM_SUFFIX}" > vim_download
echo -n "xz-${XZ_VERSION}.${XZ_SUFFIX}" > xz_download
echo -n "zlib-${ZLIB_VERSION}.${ZLIB_SUFFIX}" > zlib_download
echo -n "qemu-${QEMU_VERSION}.${QEMU_SUFFIX}" > qemu_download
echo -n "openocd-${QEMU_VERSION}.${QEMU_SUFFIX}" > ocd_download
popd
