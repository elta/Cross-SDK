#! /bin/bash

source common/source.env

[ -d "${TARBALL}" ] || mkdir -p "${TARBALL}"
[ -d "${LIVE_SRC}" ] || mkdir -p "${LIVE_SRC}"
[ -d "${METADATADOWN}" ] || mkdir -p "${METADATADOWN}"

pushd ${METADATADOWN}

[ -f autoconf_download ] && \
	[ "`cat autoconf_download`" = "autoconf-${AUTOCONF_VERSION}.${AUTOCONF_SUFFIX}" ] || \
download "autoconf-${AUTOCONF_VERSION}.${AUTOCONF_SUFFIX}" \
  "${AUTOCONF_URL}/autoconf-${AUTOCONF_VERSION}.${AUTOCONF_SUFFIX}" || \
  die "download autoconf error" && \
		echo -n "autoconf-${AUTOCONF_VERSION}.${AUTOCONF_SUFFIX}" > autoconf_download 

[ -f automake_download ] && \
	[ "`cat automake_download`" = "automake-${AUTOMAKE_VERSION}.${AUTOMAKE_SUFFIX}" ] || \
download "automake-${AUTOMAKE_VERSION}.${AUTOMAKE_SUFFIX}" \
  "${AUTOMAKE_URL}/automake-${AUTOMAKE_VERSION}.${AUTOMAKE_SUFFIX}" || \
  die "download automake error" && \
		echo -n "automake-${AUTOMAKE_VERSION}.${AUTOMAKE_SUFFIX}" > automake_download

[ -f bash_download ] && \
	[ "`cat bash_download`" = "bash-${BASH_VERSION}.${BASH_SUFFIX}" ] || \
download "bash-${BASH_VERSION}.${BASH_SUFFIX}" \
  "${BASH_URL}/bash-${BASH_VERSION}.${BASH_SUFFIX}" || \
  die "download bash error" && \
		echo -n "bash-${BASH_VERSION}.${BASH_SUFFIX}" > bash_download

[ -f bash_completion_download ] && \
	[ "`cat bash_completion_download`" = "bash-completion-${BASHCOMPLETION_VERSION}.${BASHCOMPLETION_SUFFIX}" ] || \
download "bash-completion-${BASHCOMPLETION_VERSION}.${BASHCOMPLETION_SUFFIX}" \
  "${BASHCOMPLETION_URL}/bash-completion-${BASHCOMPLETION_VERSION}.${BASHCOMPLETION_SUFFIX}" || \
  die "download bash bash-completion error" && \
		echo -n "bash-completion-${BASHCOMPLETION_VERSION}.${BASHCOMPLETION_SUFFIX}" > bash_completion_download

[ -f binutils_download ] && \
	[ "`cat binutils_download`" = "binutils-${BINUTILS_VERSION}.${BINUTILS_SUFFIX}" ] || \
download "binutils-${BINUTILS_VERSION}.${BINUTILS_SUFFIX}" \
  "${BINUTILS_URL}/binutils-${BINUTILS_VERSION}.${BINUTILS_SUFFIX}" || \
  die "download binutils error" && \
		echo -n "binutils-${BINUTILS_VERSION}.${BINUTILS_SUFFIX}" > binutils_download

[ -f bison_download ] && \
	[ "`cat bison_download`" = "bison-${BISON_VERSION}.${BISON_SUFFIX}" ] || \
download "bison-${BISON_VERSION}.${BISON_SUFFIX}" \
  "${BISON_URL}/bison-${BISON_VERSION}.${BISON_SUFFIX}" || \
  die "download bison error" && \
		echo -n "bison-${BISON_VERSION}.${BISON_SUFFIX}" > bison_download

[ -f bootscripts_download ] && \
	[ "`cat bootscripts_download`" = "bootscripts-cross-lfs-${BOOTSCRIPTS_VERSION}.${BOOTSCRIPTS_SUFFIX}" ] || \
download "bootscripts-cross-lfs-${BOOTSCRIPTS_VERSION}.${BOOTSCRIPTS_SUFFIX}" \
  "${BOOTSCRIPTS_URL}/bootscripts-cross-lfs-${BOOTSCRIPTS_VERSION}.${BOOTSCRIPTS_SUFFIX}" || \
  die "download bootscripts error" && \
		echo -n "bootscripts-cross-lfs-${BOOTSCRIPTS_VERSION}.${BOOTSCRIPTS_SUFFIX}" > bootscripts_download

[ -f busybox_download ] && \
	[ "`cat busybox_download`" = "busybox-${BUSYBOX_VERSION}.${BUSYBOX_SUFFIX}" ] || \
download "busybox-${BUSYBOX_VERSION}.${BUSYBOX_SUFFIX}" \
  "${BUSYBOX_URL}/busybox-${BUSYBOX_VERSION}.${BUSYBOX_SUFFIX}" || \
  die "download busybox error" && \
		echo -n "busybox-${BUSYBOX_VERSION}.${BUSYBOX_SUFFIX}" > busybox_download

[ -f bzip2_download ] && \
	[ "`cat bzip2_download`" = "bzip2-${BZIP2_VERSION}.${BZIP2_SUFFIX}" ] || \
download "bzip2-${BZIP2_VERSION}.${BZIP2_SUFFIX}" \
  "${BZIP2_URL}/bzip2-${BZIP2_VERSION}.${BZIP2_SUFFIX}" || \
  die "download bzip2 error" && \
		echo -n "bzip2-${BZIP2_VERSION}.${BZIP2_SUFFIX}" > bzip2_download

[ -f cloog_download ] && \
	[ "`cat cloog_download`" = "cloog-${CLOOG_VERSION}.${CLOOG_SUFFIX}" ] || \
download "cloog-${CLOOG_VERSION}.${CLOOG_SUFFIX}" \
  "${CLOOG_URL}/cloog-${CLOOG_VERSION}.${CLOOG_SUFFIX}" || \
  die "download cloog error" && \
		echo -n "cloog-${CLOOG_VERSION}.${CLOOG_SUFFIX}" > cloog_download

[ -f coreutils_download ] && \
	[ "`cat coreutils_download`" = "coreutils-${COREUTILS_VERSION}.${COREUTILS_SUFFIX}" ] || \
download "coreutils-${COREUTILS_VERSION}.${COREUTILS_SUFFIX}" \
  "${COREUTILS_URL}/coreutils-${COREUTILS_VERSION}.${COREUTILS_SUFFIX}" || \
  die "download coreutils error" && \
		echo -n "coreutils-${COREUTILS_VERSION}.${COREUTILS_SUFFIX}" > coreutils_download

[ -f dbus_download ] && \
	[ "`cat dbus_download`" = "dbus-${DBUS_VERSION}.${DBUS_SUFFIX}" ]	|| \
download "dbus-${DBUS_VERSION}.${DBUS_SUFFIX}" \
  "${DBUS_URL}/dbus-${DBUS_VERSION}.${DBUS_SUFFIX}" || \
  die "download dbus error" && \
		echo -n "dbus-${DBUS_VERSION}.${DBUS_SUFFIX}" > dbus_download

[ -f dejagnu_download ] && \
	[ "`cat dejagnu_download`" = "dejagnu-${DEJAGNU_VERSION}.${DEJAGNU_SUFFIX}" ] || \
download "dejagnu-${DEJAGNU_VERSION}.${DEJAGNU_SUFFIX}" \
  "${DEJAGNU_URL}/dejagnu-${DEJAGNU_VERSION}.${DEJAGNU_SUFFIX}" || \
  die "download dejagnu error" && \
		echo -n "dejagnu-${DEJAGNU_VERSION}.${DEJAGNU_SUFFIX}" > dejagnu_download

[ -f dhcpcd_download ] && \
	[ "`cat dhcpcd_download`" = "dhcpcd-${DHCPCD_VERSION}.${DHCPCD_SUFFIX}" ] || \
download "dhcpcd-${DHCPCD_VERSION}.${DHCPCD_SUFFIX}" \
  "${DHCPCD_URL}/dhcpcd-${DHCPCD_VERSION}.${DHCPCD_SUFFIX}" || \
  die "download dhcpcd error" && \
		echo -n "dhcpcd-${DHCPCD_VERSION}.${DHCPCD_SUFFIX}" > dhcpcd_download

[ -f diffutils_download ] && \
	[ "`cat diffutils_download`" = "diffutils-${DIFFUTILS_VERSION}.${DIFFUTILS_SUFFIX}" ] || \
download "diffutils-${DIFFUTILS_VERSION}.${DIFFUTILS_SUFFIX}" \
  "${DIFFUTILS_URL}/diffutils-${DIFFUTILS_VERSION}.${DIFFUTILS_SUFFIX}" || \
  die "download diffutils error" && \
		echo -n "diffutils-${DIFFUTILS_VERSION}.${DIFFUTILS_SUFFIX}" > diffutils_download

[ -f dvhtool_download ] && \
	[ "`cat dvhtool_download`" = "dvhtool_${DVHTOOL_VERSION}.${DVHTOOL_SUFFIX}" ] || \
download "dvhtool_${DVHTOOL_VERSION}.${DVHTOOL_SUFFIX}" \
  "${DVHTOOL_URL}/dvhtool_${DVHTOOL_VERSION}.${DVHTOOL_SUFFIX}" || \
  die "download dvhtool error" && \
		echo -n "dvhtool_${DVHTOOL_VERSION}.${DVHTOOL_SUFFIX}" > dvhtool_download

[ -f e2fsprogs_download ] && \
	[ "`cat e2fsprogs_download`" = "e2fsprogs-${E2FSPROGS_VERSION}.${E2FSPROGS_SUFFIX}" ] || \
download "e2fsprogs-${E2FSPROGS_VERSION}.${E2FSPROGS_SUFFIX}" \
  "${E2FSPROGS_URL}/e2fsprogs-${E2FSPROGS_VERSION}.${E2FSPROGS_SUFFIX}" || \
  die "download e2fsprogs error" && \
		echo -n "e2fsprogs-${E2FSPROGS_VERSION}.${E2FSPROGS_SUFFIX}" > e2fsprogs_download

[ -f elfutils_download ] && \
	[ "`cat elfutils_download`" = "elfutils-${ELFUTILS_VERSION}.${ELFUTILS_SUFFIX}" ] || \
download "elfutils-${ELFUTILS_VERSION}.${ELFUTILS_SUFFIX}" \
  "${ELFUTILS_URL}/elfutils-${ELFUTILS_VERSION}.${ELFUTILS_SUFFIX}" || \
  die "download elfutils error" && \
		echo -n "elfutils-${ELFUTILS_VERSION}.${ELFUTILS_SUFFIX}" > elfutils_download

[ -f expat_download ] && \
	[ "`cat expat_download`" = "expat-${EXPAT_VERSION}.${EXPAT_SUFFIX}" ] || \
download "expat-${EXPAT_VERSION}.${EXPAT_SUFFIX}" \
  "${EXPAT_URL}/expat-${EXPAT_VERSION}.${EXPAT_SUFFIX}" || \
  die "download expat error" && \
		echo -n "expat-${EXPAT_VERSION}.${EXPAT_SUFFIX}" > expat_download

[ -f expect_download ] && \
	[ "`cat expect_download`" = "expect${EXPECT_VERSION}.${EXPECT_SUFFIX}" ] || \
download "expect${EXPECT_VERSION}.${EXPECT_SUFFIX}" \
  "${EXPECT_URL}/expect${EXPECT_VERSION}.${EXPECT_SUFFIX}" || \
  die "download expect error" && \
		echo -n "expect${EXPECT_VERSION}.${EXPECT_SUFFIX}" > expect_download

[ -f findutils_download ] && \
	[ "`cat findutils_download`" = "findutils-${FINDUTILS_VERSION}.${FINDUTILS_SUFFIX}" ] || \
download "findutils-${FINDUTILS_VERSION}.${FINDUTILS_SUFFIX}" \
  "${FINDUTILS_URL}/findutils-${FINDUTILS_VERSION}.${FINDUTILS_SUFFIX}" || \
  die "download findutils error" && \
		echo -n "findutils-${FINDUTILS_VERSION}.${FINDUTILS_SUFFIX}" > findutils_download

[ -f flex_download ] && \
	[ "`cat flex_download`" = "flex-${FLEX_VERSION}.${FLEX_SUFFIX}" ] || \
download "flex-${FLEX_VERSION}.${FLEX_SUFFIX}" \
  "${FLEX_URL}/flex-${FLEX_VERSION}.${FLEX_SUFFIX}" || \
  die "download flex error" && \
		echo -n "flex-${FLEX_VERSION}.${FLEX_SUFFIX}" > flex_download

[ -f gawk_download ] && \
	[ "`cat gawk_download`" = "gawk-${GAWK_VERSION}.${GAWK_SUFFIX}" ] || \
download "gawk-${GAWK_VERSION}.${GAWK_SUFFIX}" \
  "${GAWK_URL}/gawk-${GAWK_VERSION}.${GAWK_SUFFIX}" || \
  die "download gawk error" && \
		echo -n "gawk-${GAWK_VERSION}.${GAWK_SUFFIX}" > gawk_download

[ -f gcc_download ] && \
	[ "`cat gcc_download`" = "gcc-${GCC_VERSION}.${GCC_SUFFIX}" ] || \
download "gcc-${GCC_VERSION}.${GCC_SUFFIX}" \
  "${GCC_URL}/gcc-${GCC_VERSION}.${GCC_SUFFIX}" || \
  die "download gcc error" && \
		echo -n "gcc-${GCC_VERSION}.${GCC_SUFFIX}" > gcc_download

[ -f gdb_download ] && \
	[ "`cat gdb_download`" = "gdb-${GDB_VERSION}.${GDB_SUFFIX}" ] || \
download "gdb-${GDB_VERSION}.${GDB_SUFFIX}" \
  "${GDB_URL}/gdb-${GDB_VERSION}.${GDB_SUFFIX}" || \
  die "download gdb error" && \
		echo -n "gdb-${GDB_VERSION}.${GDB_SUFFIX}" > gdb_download

[ -f gettext_download ] && \
	[ "`cat gettext_download`" = "gettext-${GETTEXT_VERSION}.${GETTEXT_SUFFIX}" ] || \
download "gettext-${GETTEXT_VERSION}.${GETTEXT_SUFFIX}" \
  "${GETTEXT_URL}/gettext-${GETTEXT_VERSION}.${GETTEXT_SUFFIX}" || \
  die "download gettext error" && \
		echo -n "gettext-${GETTEXT_VERSION}.${GETTEXT_SUFFIX}" > gettext_download

[ -f glib_download ] && \
	[ "`cat glib_download`" = "glib-${GLIB_VERSION}.${GLIB_SUFFIX}" ] || \
download "glib-${GLIB_VERSION}.${GLIB_SUFFIX}" \
  "${GLIB_URL}/glib-${GLIB_VERSION}.${GLIB_SUFFIX}" || \
  die "download glib error" && \
		echo -n "glib-${GLIB_VERSION}.${GLIB_SUFFIX}" > glib_download

[ -f glibc_download ] && \
	[ "`cat glibc_download`" = "glibc-${GLIBC_VERSION}.${GLIBC_SUFFIX}" ] || \
download "glibc-${GLIBC_VERSION}.${GLIBC_SUFFIX}" \
  "${GLIBC_URL}/glibc-${GLIBC_VERSION}.${GLIBC_SUFFIX}" || \
  die "download glibc error" && \
		echo -n "glibc-${GLIBC_VERSION}.${GLIBC_SUFFIX}" > glibc_download

[ -f gmp_download ] && \
	[ "`cat gmp_download`" = "gmp-${GMP_VERSION}.${GMP_SUFFIX}" ] || \
download "gmp-${GMP_VERSION}.${GMP_SUFFIX}" \
  "${GMP_URL}/gmp-${GMP_VERSION}.${GMP_SUFFIX}" || \
  die "download gmp error" && \
		echo -n "gmp-${GMP_VERSION}.${GMP_SUFFIX}" > gmp_download

[ -f grep_download ] && \
	[ "`cat grep_download`" = "grep-${GREP_VERSION}.${GREP_SUFFIX}" ] || \
download "grep-${GREP_VERSION}.${GREP_SUFFIX}" \
  "${GREP_URL}/grep-${GREP_VERSION}.${GREP_SUFFIX}" || \
  die "download grep error" && \
		echo -n "grep-${GREP_VERSION}.${GREP_SUFFIX}" > grep_download

[ -f groff_download ] && \
	[ "`cat groff_download`" = "groff-${GROFF_VERSION}.${GROFF_SUFFIX}" ] || \
download "groff-${GROFF_VERSION}.${GROFF_SUFFIX}" \
  "${GROFF_URL}/groff-${GROFF_VERSION}.${GROFF_SUFFIX}" || \
  die "download groff error" && \
		echo -n "groff-${GROFF_VERSION}.${GROFF_SUFFIX}" > groff_download

[ -f gzip_download ] && \
	[ "`cat gzip_download`" = "gzip-${GZIP_VERSION}.${GZIP_SUFFIX}" ] || \
download "gzip-${GZIP_VERSION}.${GZIP_SUFFIX}" \
  "${GZIP_URL}/gzip-${GZIP_VERSION}.${GZIP_SUFFIX}" || \
  die "download gzip error" && \
		echo -n "gzip-${GZIP_VERSION}.${GZIP_SUFFIX}" > gzip_download

[ -f iana-etc_download ] && \
	[ "`cat iana-etc_download`" = "iana-etc-${IANA_VERSION}.${IANA_SUFFIX}" ] || \
download "iana-etc-${IANA_VERSION}.${IANA_SUFFIX}" \
  "${IANA_URL}/iana-etc-${IANA_VERSION}.${IANA_SUFFIX}" || \
  die "download iana-etc error" && \
		echo -n "iana-etc-${IANA_VERSION}.${IANA_SUFFIX}" > iana-etc_download

[ -f iproute2_download ] && \
	[ "`cat iproute2_download`" = "iproute2-${IPROUTE2_VERSION}.${IPROUTE2_SUFFIX}" ] || \
download "iproute2-${IPROUTE2_VERSION}.${IPROUTE2_SUFFIX}" \
  "${IPROUTE2_URL}/iproute2-${IPROUTE2_VERSION}.${IPROUTE2_SUFFIX}" || \
  die "download iproute error" && \
		echo -n "iproute2-${IPROUTE2_VERSION}.${IPROUTE2_SUFFIX}" > iproute2_download

[ -f iputils_download ] && \
	[ "`cat iputils_download`" = "iputils-${IPUTILS_VERSION}.${IPUTILS_SUFFIX}" ] || \
download "iputils-${IPUTILS_VERSION}.${IPUTILS_SUFFIX}" \
  "${IPUTILS_URL}/iputils-${IPUTILS_VERSION}.${IPUTILS_SUFFIX}" || \
  die "download iputils error" && \
		echo -n "iputils-${IPUTILS_VERSION}.${IPUTILS_SUFFIX}" > iputils_download

[ -f jsonc_download ] && \
	[ "`cat jsonc_download`" = "json-c-${JSONC_VERSION}.${JSONC_SUFFIX}" ] || \
download "json-c-${JSONC_VERSION}.${JSONC_SUFFIX}" \
  "${JSONC_URL}/json-c-${JSONC_VERSION}.${JSONC_SUFFIX}" || \
  die "download json-c error" && \
		echo -n "json-c-${JSONC_VERSION}.${JSONC_SUFFIX}" > jsonc_download

[ -f kbd_download ] && \
	[ "`cat kbd_download`" = "kbd-${KBD_VERSION}.${KBD_SUFFIX}" ] || \
download "kbd-${KBD_VERSION}.${KBD_SUFFIX}" \
  "${KBD_URL}/kbd-${KBD_VERSION}.${KBD_SUFFIX}" || \
  die "download kbd error" && \
		echo -n "kbd-${KBD_VERSION}.${KBD_SUFFIX}" > kbd_download

[ -f kmod_download ] && \
	[ "`cat kmod_download`" = "kmod-${KMOD_VERSION}.${KMOD_SUFFIX}" ] || \
download "kmod-${KMOD_VERSION}.${KMOD_SUFFIX}" \
  "${KMOD_URL}/kmod-${KMOD_VERSION}.${KMOD_SUFFIX}" || \
  die "download kmod error" && \
		echo -n "kmod-${KMOD_VERSION}.${KMOD_SUFFIX}" > kmod_download

[ -f less_download ] && \
	[ "`cat less_download`" = "less-${LESS_VERSION}.${LESS_SUFFIX}" ] || \
download "less-${LESS_VERSION}.${LESS_SUFFIX}" \
  "${LESS_URL}/less-${LESS_VERSION}.${LESS_SUFFIX}" || \
  die "download less error" && \
		echo -n "less-${LESS_VERSION}.${LESS_SUFFIX}" > less_download

[ -f libee_download ] && \
	[ "`cat libee_download`" = "libee-${LIBEE_VERSION}.${LIBEE_SUFFIX}" ] || \
download "libee-${LIBEE_VERSION}.${LIBEE_SUFFIX}" \
  "${LIBEE_URL}/libee-${LIBEE_VERSION}.${LIBEE_SUFFIX}" || \
  die "download libee error" && \
		echo -n "libee-${LIBEE_VERSION}.${LIBEE_SUFFIX}" > libee_download

[ -f libelf_download ] && \
	[ "`cat libelf_download`" = "libelf-${LIBELF_VERSION}.${LIBELF_SUFFIX}" ] || \
download "libelf-${LIBELF_VERSION}.${LIBELF_SUFFIX}" \
  "${LIBELF_URL}/libelf-${LIBELF_VERSION}.${LIBELF_SUFFIX}" || \
  die "download libelf error" && \
		echo -n "libelf-${LIBELF_VERSION}.${LIBELF_SUFFIX}"  > libelf_download

[ -f libestr_download ] && \
	[ "`cat libestr_download`" = "libestr-${LIBESTR_VERSION}.${LIBESTR_SUFFIX}" ] || \
download "libestr-${LIBESTR_VERSION}.${LIBESTR_SUFFIX}" \
  "${LIBESTR_URL}/libestr-${LIBESTR_VERSION}.${LIBESTR_SUFFIX}" || \
  die "download libestr error" && \
    echo -n "libestr-${LIBESTR_VERSION}.${LIBESTR_SUFFIX}" > libestr_download

[ -f libtool_download ] && \
	[ "`cat libtool_download`" = "libtool-${LIBTOOL_VERSION}.${LIBTOOL_SUFFIX}" ] || \
download "libtool-${LIBTOOL_VERSION}.${LIBTOOL_SUFFIX}" \
  "${LIBTOOL_URL}/libtool-${LIBTOOL_VERSION}.${LIBTOOL_SUFFIX}" || \
  die "download libtool error" && \
    echo -n "libtool-${LIBTOOL_VERSION}.${LIBTOOL_SUFFIX}" > libtool_download

[ -f libiconv_download ] && \
	[ "`cat libiconv_download`" = "libiconv-${LIBICONV_VERSION}.${LIBICONV_SUFFIX}" ] || \
download "libiconv-${LIBICONV_VERSION}.${LIBICONV_SUFFIX}" \
  "${LIBICONV_URL}/libiconv-${LIBICONV_VERSION}.${LIBICONV_SUFFIX}" || \
  die "download libiconv error" && \
    echo -n "libiconv-${LIBICONV_VERSION}.${LIBICONV_SUFFIX}" >  libiconv_download

[ -f linux_download ] && \
	[ "`cat linux_download`" = "linux-${LINUX_VERSION}.${LINUX_SUFFIX}" ] || \
download "linux-${LINUX_VERSION}.${LINUX_SUFFIX}" \
  "${LINUX_URL}/linux-${LINUX_VERSION}.${LINUX_SUFFIX}" || \
  die "download linux error" && \
    echo -n "linux-${LINUX_VERSION}.${LINUX_SUFFIX}" >  linux_download

[ -f llvm_download ] && \
	[ "`cat llvm_download`" = "llvm-${LLVM_VERSION}.${LLVM_SUFFIX}" ] || \
download "llvm-${LLVM_VERSION}.${LLVM_SUFFIX}" \
  "${LLVM_URL}/llvm-${LLVM_VERSION}.${LLVM_SUFFIX}" || \
  die "download llvm error" && \
    echo -n "llvm-${LLVM_VERSION}.${LLVM_SUFFIX}" > llvm_download

[ -f clang_download ] && \
	[ "`cat clang_download`" = "clang-${CLANG_VERSION}.${CLANG_SUFFIX}" ] || \
download "clang-${CLANG_VERSION}.${CLANG_SUFFIX}" \
  "${CLANG_URL}/clang-${CLANG_VERSION}.${CLANG_SUFFIX}" || \
  die "download clang error" && \
    echo -n "clang-${CLANG_VERSION}.${CLANG_SUFFIX}" > clang_download

[ -f crt_download ] && \
	[ "`cat crt_download`" = "compiler-rt-${CRT_VERSION}.${CRT_SUFFIX}" ] || \
download "compiler-rt-${CRT_VERSION}.${CRT_SUFFIX}" \
  "${CRT_URL}/compiler-rt-${CRT_VERSION}.${CRT_SUFFIX}" || \
  die "download compiler-rt error" && \
		echo -n "compiler-rt-${CRT_VERSION}.${CRT_SUFFIX}" > crt_download

[ -f m4_download ] && \
	[ "`cat m4_download`" = "m4-${M4_VERSION}.${M4_SUFFIX}" ] || \
download "m4-${M4_VERSION}.${M4_SUFFIX}" \
  "${M4_URL}/m4-${M4_VERSION}.${M4_SUFFIX}" || \
  die "download m4 error" && \
		echo -n "m4-${M4_VERSION}.${M4_SUFFIX}" > m4_download

[ -f make_download ] && \
	[ "`cat make_download`" = "make-${MAKE_VERSION}.${MAKE_SUFFIX}" ] || \
download "make-${MAKE_VERSION}.${MAKE_SUFFIX}" \
  "${MAKE_URL}/make-${MAKE_VERSION}.${MAKE_SUFFIX}" || \
  die "download make error" && \
		echo -n "make-${MAKE_VERSION}.${MAKE_SUFFIX}" > make_download

[ -f man_download ] && \
	[ "`cat man_download`" = "man-${MAN_VERSION}.${MAN_SUFFIX}" ] || \
download "man-${MAN_VERSION}.${MAN_SUFFIX}" \
  "${MAN_URL}/man-${MAN_VERSION}.${MAN_SUFFIX}" || \
  die "download man error" && \
		echo -n "man-${MAN_VERSION}.${MAN_SUFFIX}" > man_download

[ -f man-pages_download ] && \
	[ "`cat man-pages_download`" = "man-pages-${MANPAGES_VERSION}.${MANPAGES_SUFFIX}" ] || \
download "man-pages-${MANPAGES_VERSION}.${MANPAGES_SUFFIX}" \
  "${MANPAGES_URL}/man-pages-${MANPAGES_VERSION}.${MANPAGES_SUFFIX}" || \
  die "download man-pages error" && \
		echo -n "man-pages-${MANPAGES_VERSION}.${MANPAGES_SUFFIX}" > man-pages_download

[ -f module-init-tools_download ] && \
	[ "`cat module-init-tools_download`" = "module-init-tools-${MODULE_VERSION}.${MODULE_SUFFIX}" ] || \
download "module-init-tools-${MODULE_VERSION}.${MODULE_SUFFIX}" \
  "${MODULE_URL}/module-init-tools-${MODULE_VERSION}.${MODULE_SUFFIX}" || \
  die "download moudle-init-tools error" && \
    echo -n "module-init-tools-${MODULE_VERSION}.${MODULE_SUFFIX}" > module-init-tools_download

[ -f mpc_download ] && \
	[ "`cat mpc_download`" = "mpc-${MPC_VERSION}.${MPC_SUFFIX}" ] || \
download "mpc-${MPC_VERSION}.${MPC_SUFFIX}" \
  "${MPC_URL}/mpc-${MPC_VERSION}.${MPC_SUFFIX}" || \
  die "download mpc error" && \
		echo -n "mpc-${MPC_VERSION}.${MPC_SUFFIX}" > mpc_download

[ -f mpfr_download ] && \
	[ "`cat mpfr_download`" = "mpfr-${MPFR_VERSION}.${MPFR_SUFFIX}" ] || \
download "mpfr-${MPFR_VERSION}.${MPFR_SUFFIX}" \
  "${MPFR_URL}/mpfr-${MPFR_VERSION}.${MPFR_SUFFIX}" || \
  die "download mpfr error" && \
		echo -n "mpfr-${MPFR_VERSION}.${MPFR_SUFFIX}" > mpfr_download

[ -f ncurses_download ] && \
	[ "`cat ncurses_download`" = "ncurses-${NCURSES_VERSION}.${NCURSES_SUFFIX}" ] || \
download "ncurses-${NCURSES_VERSION}.${NCURSES_SUFFIX}" \
  "${NCURSES_URL}/ncurses-${NCURSES_VERSION}.${NCURSES_SUFFIX}" || \
  die "download ncurses error" && \
		echo -n "ncurses-${NCURSES_VERSION}.${NCURSES_SUFFIX}" > ncurses_download

[ -f openssl_download ] && \
	[ "`cat openssl_download`" = "openssl-${OPENSSL_VERSION}.${OPENSSL_SUFFIX}" ] || \
download "openssl-${OPENSSL_VERSION}.${OPENSSL_SUFFIX}" \
  "${OPENSSL_URL}/openssl-${OPENSSL_VERSION}.${OPENSSL_SUFFIX}" || \
  die "download openssl error" && \
		echo -n "openssl-${OPENSSL_VERSION}.${OPENSSL_SUFFIX}" > openssl_download

[ -f patch_download ] && \
	[ "`cat patch_download`" = "patch-${PATCH_VERSION}.${PATCH_SUFFIX}" ] || \
download "patch-${PATCH_VERSION}.${PATCH_SUFFIX}" \
  "${PATCH_URL}/patch-${PATCH_VERSION}.${PATCH_SUFFIX}" || \
  die "download patch error" && \
		echo -n "patch-${PATCH_VERSION}.${PATCH_SUFFIX}" > patch_download

[ -f perl_download ] && \
	[ "`cat perl_download`" = "perl-${PERL_VERSION}.${PERL_SUFFIX}" ] || \
download "perl-${PERL_VERSION}.${PERL_SUFFIX}" \
  "${PERL_URL}/perl-${PERL_VERSION}.${PERL_SUFFIX}" || \
  die "download perl error" && \
		echo -n "perl-${PERL_VERSION}.${PERL_SUFFIX}" > perl_download

[ -f perlcross_download ] && \
	[ "`cat perlcross_download`" = "perl-${PERLCROSS_VERSION}.${PERLCROSS_SUFFIX}" ] || \
download "perl-${PERLCROSS_VERSION}.${PERLCROSS_SUFFIX}" \
  "${PERLCROSS_URL}/perl-${PERLCROSS_VERSION}.${PERLCROSS_SUFFIX}/download" || \
  die "download perlcross error" && \
		echo -n "perl-${PERLCROSS_VERSION}.${PERLCROSS_SUFFIX}" > perlcross_download

[ -f pkg-config_download ] && \
	[ "`cat pkg-config_download`" = "pkg-config-${PKG_VERSION}.${PKG_SUFFIX}" ] || \
download "pkg-config-${PKG_VERSION}.${PKG_SUFFIX}" \
  "${PKG_URL}/pkg-config-${PKG_VERSION}.${PKG_SUFFIX}" || \
  die "download pkg-config error" && \
		echo -n "pkg-config-${PKG_VERSION}.${PKG_SUFFIX}" > pkg-config_download

[ -f ppl_download ] && \
	[ "`cat ppl_download`" = "ppl-${PPL_VERSION}.${PPL_SUFFIX}" ] || \
download "ppl-${PPL_VERSION}.${PPL_SUFFIX}" \
  "${PPL_URL}/ppl-${PPL_VERSION}.${PPL_SUFFIX}" || \
  die "download ppl error" && \
		echo -n "ppl-${PPL_VERSION}.${PPL_SUFFIX}" > ppl_download

[ -f procps_download ] && \
	[ "`cat procps_download`" = "procps-${PROCPS_VERSION}.${PROCPS_SUFFIX}" ] || \
download "procps-${PROCPS_VERSION}.${PROCPS_SUFFIX}" \
  "${PROCPS_URL}/procps-${PROCPS_VERSION}.${PROCPS_SUFFIX}" || \
  die "download procps error" && \
		echo -n "procps-${PROCPS_VERSION}.${PROCPS_SUFFIX}" > procps_download

[ -f psmisc_download ] && \
	[ "`cat psmisc_download`" = "psmisc-${PSMISC_VERSION}.${PSMISC_SUFFIX}" ] || \
download "psmisc-${PSMISC_VERSION}.${PSMISC_SUFFIX}" \
  "${PSMISC_URL}/psmisc-${PSMISC_VERSION}.${PSMISC_SUFFIX}" || \
  die "download psmisc error" && \
		echo -n "psmisc-${PSMISC_VERSION}.${PSMISC_SUFFIX}" > psmisc_download

[ -f python_download ] && \
	[ "`cat python_download`" = "python-${PYTHON_VERSION}.${PYTHON_SUFFIX}" ] || \
download "python-${PYTHON_VERSION}.${PYTHON_SUFFIX}" \
  "${PYTHON_URL}/Python-${PYTHON_VERSION}.${PYTHON_SUFFIX}" || \
  die "download python error" && \
		echo -n "python-${PYTHON_VERSION}.${PYTHON_SUFFIX}" > python_download

[ -f readline_download ] && \
	[ "`cat readline_download`" = "readline-${READLINE_VERSION}.${READLINE_SUFFIX}" ] || \
download "readline-${READLINE_VERSION}.${READLINE_SUFFIX}" \
  "${READLINE_URL}/readline-${READLINE_VERSION}.${READLINE_SUFFIX}" || \
  die "download readline error" && \
		echo -n "readline-${READLINE_VERSION}.${READLINE_SUFFIX}" > readline_download

[ -f rsyslog_download ] && \
	[ "`cat rsyslog_download`" = "rsyslog-${RSYSLOG_VERSION}.${RSYSLOG_SUFFIX}" ] || \
download "rsyslog-${RSYSLOG_VERSION}.${RSYSLOG_SUFFIX}" \
  "${RSYSLOG_URL}/rsyslog-${RSYSLOG_VERSION}.${RSYSLOG_SUFFIX}" || \
  die "download rsyslog error" && \
		echo -n "rsyslog-${RSYSLOG_VERSION}.${RSYSLOG_SUFFIX}" > rsyslog_download

[ -f sed_download ] && \
	[ "`cat sed_download`" = "sed-${SED_VERSION}.${SED_SUFFIX}" ] || \
download "sed-${SED_VERSION}.${SED_SUFFIX}" \
  "${SED_URL}/sed-${SED_VERSION}.${SED_SUFFIX}" || \
  die "download sed error" && \
		echo -n "sed-${SED_VERSION}.${SED_SUFFIX}" > sed_download

[ -f shadow_download ] && \
	[ "`cat shadow_download`" = "shadow-${SHADOW_VERSION}.${SHADOW_SUFFIX}" ] || \
download "shadow-${SHADOW_VERSION}.${SHADOW_SUFFIX}" \
  "${SHADOW_URL}/shadow-${SHADOW_VERSION}.${SHADOW_SUFFIX}" || \
  die "download shadow error" && \
		echo -n "shadow-${SHADOW_VERSION}.${SHADOW_SUFFIX}" > shadow_download

[ -f sysfsutils_download ] && \
	[ "`cat sysfsutils_download`" = "sysfsutils-${SYSFSUTILS_VERSION}.${SYSFSUTILS_SUFFIX}" ] || \
download "sysfsutils-${SYSFSUTILS_VERSION}.${SYSFSUTILS_SUFFIX}" \
  "${SYSFSUTILS_URL}/sysfsutils-${SYSFSUTILS_VERSION}.${SYSFSUTILS_SUFFIX}" || \
  die "download sysfsutils error" && \
		echo -n "sysfsutils-${SYSFSUTILS_VERSION}.${SYSFSUTILS_SUFFIX}" > sysfsutils_download

[ -f sysvinit_download ] && \
	[ "`cat sysvinit_download`" = "sysvinit-${SYSVINIT_VERSION}.${SYSVINIT_SUFFIX}" ] || \
download "sysvinit-${SYSVINIT_VERSION}.${SYSVINIT_SUFFIX}" \
  "${SYSVINIT_URL}/sysvinit-${SYSVINIT_VERSION}.${SYSVINIT_SUFFIX}" || \
  die "download sysvinit error" && \
		echo -n "sysvinit-${SYSVINIT_VERSION}.${SYSVINIT_SUFFIX}" > sysvinit_download

[ -f tar_download ] && \
	[ "`cat tar_download`" = "tar-${TAR_VERSION}.${TAR_SUFFIX}" ] || \
download "tar-${TAR_VERSION}.${TAR_SUFFIX}" \
  "${TAR_URL}/tar-${TAR_VERSION}.${TAR_SUFFIX}" || \
  die "download tar error" && \
		echo -n "tar-${TAR_VERSION}.${TAR_SUFFIX}" > tar_download

[ -f termcap_download ] && \
	[ "`cat termcap_download`" = "termcap-${TERMCAP_VERSION}.${TERMCAP_SUFFIX}" ] || \
download "termcap-${TERMCAP_VERSION}.${TERMCAP_SUFFIX}" \
  "${TERMCAP_URL}/termcap-${TERMCAP_VERSION}.${TERMCAP_SUFFIX}" || \
  die "download termcap error" && \
		echo -n "termcap-${TERMCAP_VERSION}.${TERMCAP_SUFFIX}" > termcap_download

[ -f texinfo_download ] && \
	[ "`cat texinfo_download`" = "texinfo-${TEXINFO_VERSION}a.${TEXINFO_SUFFIX}" ] || \
download "texinfo-${TEXINFO_VERSION}a.${TEXINFO_SUFFIX}" \
  "${TEXINFO_URL}/texinfo-${TEXINFO_VERSION}a.${TEXINFO_SUFFIX}" || \
  die "download texinfo error" && \
		echo -n "texinfo-${TEXINFO_VERSION}a.${TEXINFO_SUFFIX}" > texinfo_download

[ -f udev_download ] && \
	[ "`cat udev_download`" = "udev-${UDEV_VERSION}.${UDEV_SUFFIX}" ] || \
download "udev-${UDEV_VERSION}.${UDEV_SUFFIX}" \
  "${UDEV_URL}/udev-${UDEV_VERSION}.${UDEV_SUFFIX}" || \
  die "download udev error" && \
		echo -n "udev-${UDEV_VERSION}.${UDEV_SUFFIX}" > udev_download

[ -f util-linux_download ] &&
	[ "`cat util-linux_download`" = "util-${UTIL_VERSION}.${UTIL_SUFFIX}" ] || \
download "util-${UTIL_VERSION}.${UTIL_SUFFIX}" \
  "${UTIL_URL}/util-${UTIL_VERSION}.${UTIL_SUFFIX}" || \
  die "download util-linux error" && \
		echo -n "util-${UTIL_VERSION}.${UTIL_SUFFIX}" > util-linux_download

[ -f vsftpd_download ] && \
	[ "`cat vsftpd_download`" = "vsftpd-${VSFTPD_VERSION}.${VSFTPD_SUFFIX}" ] || \
download "vsftpd-${VSFTPD_VERSION}.${VSFTPD_SUFFIX}" \
  "${VSFTPD_URL}/vsftpd-${VSFTPD_VERSION}.${VSFTPD_SUFFIX}" || \
  die "download vsftpd error" && \
		echo -n "vsftpd-${VSFTPD_VERSION}.${VSFTPD_SUFFIX}" > vsftpd_download

[ -f vim_download ] && \
	[ "`cat vim_download`" = "vim-${VIM_VERSION}.${VIM_SUFFIX}" ] || \
download "vim-${VIM_VERSION}.${VIM_SUFFIX}" \
  "${VIM_URL}/vim-${VIM_VERSION}.${VIM_SUFFIX}" || \
  die "download vim error" && \
		echo -n "vim-${VIM_VERSION}.${VIM_SUFFIX}" > vim_download

[ -f xz_download ] && \
	[ "`cat xz_download`" = "xz-${XZ_VERSION}.${XZ_SUFFIX}" ] || \
download "xz-${XZ_VERSION}.${XZ_SUFFIX}" \
  "${XZ_URL}/xz-${XZ_VERSION}.${XZ_SUFFIX}" || \
  die "download xz error" && \
		echo -n "xz-${XZ_VERSION}.${XZ_SUFFIX}" > xz_download

[ -f zlib_download ] && \
	[ "`cat zlib_download`" = "zlib-${ZLIB_VERSION}.${ZLIB_SUFFIX}" ] || \
download "zlib-${ZLIB_VERSION}.${ZLIB_SUFFIX}" \
  "${ZLIB_URL}/zlib-${ZLIB_VERSION}.${ZLIB_SUFFIX}" || \
  die "download zlib error" && \
		echo -n "zlib-${ZLIB_VERSION}.${ZLIB_SUFFIX}" > zlib_download

[ -f qt-creator_download ] && \
	 [ "`cat qt-creator_download`" = "qt-creator-${QTC_VERSION}.${QTC_SUFFIX}" ] || \
download "qt-creator-${QTC_VERSION}.${QTC_SUFFIX}" \
  "${QTC_URL}/qt-creator-${QTC_VERSION}.${QTC_SUFFIX}" || \
  die "download qt-creator error" && \
		echo -n "qt-creator-${QTC_VERSION}.${QTC_SUFFIX}" > qt-creator_download

[ -f qemu_download ] && \
	[ "`cat qemu_download`" = "qemu-${QEMU_VERSION}.${QEMU_SUFFIX}" ] || \
download "qemu-${QEMU_VERSION}.${QEMU_SUFFIX}" \
  "${QEMU_URL}/qemu-${QEMU_VERSION}.${QEMU_SUFFIX}" || \
  die "download qemu error" && \
		echo -n "qemu-${QEMU_VERSION}.${QEMU_SUFFIX}" > qemu_download
popd

pushd ${LIVE_SRC}
[ -f ${METADATADOWN}/crossprojectmanager_git ] || \
  git clone ${CROSSPROJECTMANAGER_GITURL} || \
  die "download IDE plugin error" && \
    touch ${METADATADOWN}/crossprojectmanager_git
popd
