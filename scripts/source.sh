#! /bin/bash

export JOBS=3

export BZ=tar.bz2
export GZ=tar.gz
export XZ=tar.xz

###########################################################
# Version/suffix and url
###########################################################

export AUTOCONF_VERSION=2.69
export AUTOCONF_SUFFIX=${XZ}
export AUTOCONF_URL=http://ftp.gnu.org/gnu/autoconf
export AUTOMAKE_VERSION=1.13.1
export AUTOMAKE_SUFFIX=${XZ}
export AUTOMAKE_URL=http://ftp.gnu.org/gnu/automake
export BASH_VERSION=4.2
export BASH_SUFFIX=${GZ}
export BASH_URL=http://ftp.gnu.org/gnu/bash
export BINUTILS_VERSION=2.23.1
export BINUTILS_SUFFIX=${BZ}
export BINUTILS_URL=http://ftp.gnu.org/gnu/binutils
export BISON_VERSION=2.7
export BISON_SUFFIX=${XZ}
export BISON_URL=http://ftp.gnu.org/gnu/bison
export BOOTSCRIPTS_VERSION=2.0-pre1
export BOOTSCRIPTS_SUFFIX=${BZ}
export BOOTSCRIPTS_URL=http://cross-lfs.org/~cosmo/sources
export BUSYBOX_VERSION=1.20.2
export BUSYBOX_SUFFIX=${BZ}
export BUSYBOX_URL=http://www.busybox.net/downloads
export BZIP2_VERSION=1.0.6
export BZIP2_SUFFIX=${GZ}
export BZIP2_URL=http://www.bzip.org/1.0.6
export CLOOG_VERSION=0.16.1
export CLOOG_SUFFIX=${GZ}
export CLOOG_URL=http://www.bastoul.net/cloog/pages/download
export COREUTILS_VERSION=8.20
export COREUTILS_SUFFIX=${XZ}
export COREUTILS_URL=http://ftp.gnu.org/gnu/coreutils
export DBUS_VERSION=1.6.8
export DBUS_SUFFIX=${GZ}
export DBUS_URL=http://dbus.freedesktop.org/releases/dbus
export DEJAGNU_VERSION=1.5
export DEJAGNU_SUFFIX=${GZ}
export DEJAGNU_URL=http://ftp.gnu.org/gnu/dejagnu
export DHCPCD_VERSION=5.6.1
export DHCPCD_SUFFIX=${BZ}
export DHCPCD_URL=http://roy.aydogan.net/dhcpcd
export DIFFUTILS_VERSION=3.2
export DIFFUTILS_SUFFIX=${XZ}
export DIFFUTILS_URL=http://ftp.gnu.org/gnu/diffutils
export DVHTOOL_VERSION=1.0.1.orig
export DVHTOOL_SUFFIX=${GZ}
export DVHTOOL_URL=http://ftp.debian.org/debian/pool/main/d/dvhtool
export E2FSPROGS_VERSION=1.42.3
export E2FSPROGS_SUFFIX=${BZ}
export E2FSPROGS_URL=http://www.kernel.org/pub/linux/kernel/people/tytso/e2fsprogs/v1.42.3
export EXPAT_VERSION=2.1.0
export EXPAT_SUFFIX=${GZ}
export EXPAT_URL=http://jaist.dl.sourceforge.net/project/expat/expat/2.1.0
export EXPECT_VERSION=5.45
export EXPECT_SUFFIX=${GZ}
export EXPECT_URL=http://downloads.sourceforge.net/project/expect/Expect/5.45
export FILE_VERSION=5.11
export FILE_SUFFIX=${GZ}
export FILE_URL=ftp://ftp.astron.com/pub/file
export FINDUTILS_VERSION=4.4.2
export FINDUTILS_SUFFIX=${GZ}
export FINDUTILS_URL=http://ftp.gnu.org/gnu/findutils
export FLEX_VERSION=2.5.37
export FLEX_SUFFIX=${BZ}
export FLEX_URL=http://downloads.sourceforge.net/flex
export GAWK_VERSION=4.0.2
export GAWK_SUFFIX=${XZ}
export GAWK_URL=http://ftp.gnu.org/gnu/gawk
export GCC_VERSION=4.7.2
export GCC_SUFFIX=${BZ}
export GCC_URL=ftp://gcc.gnu.org/pub/gcc/releases/gcc-4.7.2
export GDB_VERSION=7.5.1
export GDB_SUFFIX=${BZ}
export GDB_URL=http://ftp.gnu.org/gnu/gdb
export GETTEXT_VERSION=0.18.2
export GETTEXT_SUFFIX=${GZ}
export GETTEXT_URL=http://ftp.gnu.org/gnu/gettext
export GLIB_VERSION=2.28.8
export GLIB_SUFFIX=${XZ}
export GLIB_URL=http://ftp.acc.umu.se/pub/gnome/sources/glib/2.28
export GLIBC_VERSION=2.17
export GLIBC_SUFFIX=${XZ}
export GLIBC_URL=http://ftp.gnu.org/gnu/libc
export GMP_VERSION=5.0.5
export GMP_SUFFIX=${XZ}
export GMP_URL=http://ftp.gnu.org/gnu/gmp
export GREP_VERSION=2.14
export GREP_SUFFIX=${XZ}
export GREP_URL=http://ftp.gnu.org/gnu/grep
export GROFF_VERSION=1.22.1
export GROFF_SUFFIX=${GZ}
export GROFF_URL=http://ftp.gnu.org/gnu/groff
export GZIP_VERSION=1.5
export GZIP_SUFFIX=${XZ}
export GZIP_URL=http://ftp.gnu.org/gnu/gzip
export IANA_VERSION=2.30
export IANA_SUFFIX=${BZ}
export IANA_URL=http://ftp.cross-lfs.org/pub/clfs/conglomeration/iana-etc
export IPROUTE2_VERSION=3.7.0
export IPROUTE2_SUFFIX=${XZ}
export IPROUTE2_URL=http://www.kernel.org/pub//linux/utils/net/iproute2
export IPUTILS_VERSION=s20121221
export IPUTILS_SUFFIX=${BZ}
export IPUTILS_URL=http://www.skbuff.net/iputils
export JSONC_VERSION=0.9
export JSONC_SUFFIX=${GZ}
export JSONC_URL=http://oss.metaparadigm.com/json-c
export KBD_VERSION=1.15.3
export KBD_SUFFIX=${BZ}
export KBD_URL=http://fossies.org/linux/misc
export KMOD_VERSION=12
export KMOD_SUFFIX=${XZ}
export KMOD_URL=http://www.kernel.org/pub//linux/utils/kernel/kmod
export LESS_VERSION=451
export LESS_SUFFIX=${GZ}
export LESS_URL=http://www.greenwoodsoftware.com/less
export LIBEE_VERSION=0.4.1
export LIBEE_SUFFIX=${GZ}
export LIBEE_URL=http://www.libee.org/download/files/download
export LIBESTR_VERSION=0.1.4
export LIBESTR_SUFFIX=${GZ}
export LIBESTR_URL=http://libestr.adiscon.com/files/download
export LIBTOOL_VERSION=2.4.2
export LIBTOOL_SUFFIX=${XZ}
export LIBTOOL_URL=http://ftp.gnu.org/gnu/libtool
export LINUX_VERSION=3.7.4
export LINUX_SUFFIX=${XZ}
export LINUX_URL=http://www.kernel.org/pub/linux/kernel/v3.0
export LLVM_VERSION=3.2.src
export LLVM_SUFFIX=${GZ}
export LLVM_URL=http://llvm.org/releases/3.2
export CLANG_VERSION=3.2.src
export CLANG_SUFFIX=${GZ}
export CLANG_URL=http://llvm.org/releases/3.2
export CRT_VERSION=3.2.src
export CRT_SUFFIX=${GZ}
export CRT_URL=http://llvm.org/releases/3.2
export M4_VERSION=1.4.16
export M4_SUFFIX=${BZ}
export M4_URL=http://ftp.gnu.org/gnu/m4
export MAKE_VERSION=3.82
export MAKE_SUFFIX=${BZ}
export MAKE_URL=http://ftp.gnu.org/gnu/make
export MAN_VERSION=1.6g
export MAN_SUFFIX=${GZ}
export MAN_URL=http://primates.ximian.com/~flucifredi/man
export MANPAGES_VERSION=3.45
export MANPAGES_SUFFIX=${XZ}
export MANPAGES_URL=http://www.kernel.org/pub//linux/docs/man-pages
export MODULE_VERSION=3.16
export MODULE_SUFFIX=${GZ}
export MODULE_URL=http://pkgs.fedoraproject.org/repo/pkgs/module-init-tools/module-init-tools-3.16.tar.gz/743d2511a639814fa428b82b9f659e4f
export MPC_VERSION=1.0.1
export MPC_SUFFIX=${GZ}
export MPC_URL=http://www.multiprecision.org/mpc/download
export MPFR_VERSION=3.1.1
export MPFR_SUFFIX=${XZ}
export MPFR_URL=http://ftp.gnu.org/gnu/mpfr
export NCURSES_VERSION=5.9
export NCURSES_SUFFIX=${GZ}
export NCURSES_URL=ftp://ftp.gnu.org/pub/gnu/ncurses
export OPENSSL_VERSION=1.0.1c
export OPENSSL_SUFFIX=${GZ}
export OPENSSL_URL=http://www.openssl.org/source
export PATCH_VERSION=2.7
export PATCH_SUFFIX=${BZ}
export PATCH_URL=http://ftp.gnu.org/gnu/patch
export PERL_VERSION=5.16.0
export PERL_SUFFIX=${GZ}
export PERL_URL=http://www.cpan.org/src/5.0
export PERLCROSS_VERSION=5.16.0-cross-0.7.1
export PERLCROSS_SUFFIX=${GZ}
export PERLCROSS_URL=http://http://prdownload.berlios.de/perlcross
export PKG_VERSION=0.27.1
export PKG_SUFFIX=${GZ}
export PKG_URL=http://pkgconfig.freedesktop.org/releases
export PPL_VERSION=0.12.1
export PPL_SUFFIX=${XZ}
export PPL_URL=http://bugseng.com/products/ppl/download/ftp/releases/0.12.1
export PROCPS_VERSION=3.2.8
export PROCPS_SUFFIX=${GZ}
export PROCPS_URL=http://fossies.org/linux/misc
export PSMISC_VERSION=22.20
export PSMISC_SUFFIX=${GZ}
export PSMISC_URL=http://downloads.sourceforge.net/psmisc
export PYTHON_VERSION=3.3.0
export PYTHON_SUFFIX=${BZ}
export PYTHON_URL=http://www.python.org/ftp/python/3.3.0
export READLINE_VERSION=6.2
export READLINE_SUFFIX=${GZ}
export READLINE_URL=http://ftp.gnu.org/gnu/readline
export RSYSLOG_VERSION=6.2.0
export RSYSLOG_SUFFIX=${GZ}
export RSYSLOG_URL=http://www.rsyslog.com/files/download/rsyslog
export SED_VERSION=4.2.2
export SED_SUFFIX=${BZ}
export SED_URL=http://ftp.gnu.org/gnu/sed
export SHADOW_VERSION=4.1.5
export SHADOW_SUFFIX=${BZ}
export SHADOW_URL=http://pkg-shadow.alioth.debian.org/releases
export SYSFSUTILS_VERSION=2.1.0
export SYSFSUTILS_SUFFIX=${GZ}
export SYSFSUTILS_URL=http://pkgs.fedoraproject.org/repo/pkgs/sysfsutils/sysfsutils-2.1.0.tar.gz/14e7dcd0436d2f49aa403f67e1ef7ddc
export SYSVINIT_VERSION=2.88dsf
export SYSVINIT_SUFFIX=${BZ}
export SYSVINIT_URL=http://download.savannah.gnu.org/releases/sysvinit
export TAR_VERSION=1.26
export TAR_SUFFIX=${BZ}
export TAR_URL=http://ftp.gnu.org/gnu/tar
export TERMCAP_VERSION=1.3.1
export TERMCAP_SUFFIX=${GZ}
export TERMCAP_URL=http://fossies.org/unix/misc/old
export TEXINFO_VERSION=4.13
export TEXINFO_SUFFIX=${GZ}
export TEXINFO_URL=http://ftp.gnu.org/gnu/texinfo
export UBOOT_VERSION=2013.01
export UBOOT_SUFFIX=${BZ}
export UBOOT_URL=http://ftp.denx.de/pub/u-boot
export UDEV_VERSION=182
export UDEV_SUFFIX=${XZ}
export UDEV_URL=http://www.kernel.org/pub//linux/utils/kernel/hotplug
export UTIL_VERSION=linux-2.20.1
export UTIL_SUFFIX=${BZ}
export UTIL_URL=http://www.kernel.org/pub//linux/utils/util-linux/v2.20
export VIM_VERSION=7.3
export VIM_SUFFIX=${BZ}
export VIM_URL=ftp://ftp.vim.org/pub/vim/unix
export VIM_DIR=vim73
export XZ_VERSION=5.0.4
export XZ_SUFFIX=${XZ}
export XZ_URL=http://tukaani.org/xz
export ZLIB_VERSION=1.2.7
export ZLIB_SUFFIX=${BZ}
export ZLIB_URL=http://pkgs.fedoraproject.org/repo/pkgs/zlib/zlib-1.2.7.tar.bz2/2ab442d169156f34c379c968f3f482dd
export QTC_VERSION=2.5.2-src
export QTC_SUFFIX=${GZ}
export QTC_URL=http://releases.qt-project.org/qtcreator/2.5.2/
export QEMU_VERSION=1.3.0
export QEMU_SUFFIX=${BZ}
export QEMU_URL=http://wiki.qemu-project.org/download/

export OPENOCD_GITURL=git://openocd.git.sourceforge.net/gitroot/openocd/openocd
export LLVMLINUX_GITURL=http://git.linuxfoundation.org/llvmlinux.git
export CROSSPROJECTMANAGER_GITURL=https://github.com/elta/crossprojectmanager.git

###########################################################
# Build flags
###########################################################

unset CFLAGS
unset CXXFLAGS
export CFLAGS="-w"
export CROSS_HOST=${MACHTYPE}
export CROSS_TARGET64="mips64el-unknown-linux-gnu"
export CROSS_TARGET32="mipsel-unknown-linux-gnu"
export QEMU_TARGET="mips64el-softmmu,mipsel-softmmu"

export BUILD32="-mabi=32"
export BUILDN32="-mabi=n32"
export BUILD64="-mabi=64"

###########################################################
# Basic directory info
###########################################################

export SCRIPT="$(pwd)"
export PATCH=${SCRIPT}/../patches
export TARBALL=${SCRIPT}/../tarballs
export SRC_LIVE=${SCRIPT}/../src_live

###########################################################
# Prefixes
###########################################################

export PREFIX=${SCRIPT}/../sdk
export PREFIXGNULINUX=${PREFIX}/gnu-linux
export PREFIXGNU64=${PREFIX}/gnu64
export PREFIXGNU32=${PREFIX}/gnu32
export PREFIXQEMU=${PREFIX}/qemu
export PREFIXLLVM=${PREFIX}/llvm
export PREFIXQTC=${PREFIX}/qt-creator
export PREFIXMIPSELROOTFS=${PREFIX}/mipsel-rootfs/
export PREFIXKERNEL=${PREFIX}/kernel
export PREFIXMIPS64ELROOTFS=${PREFIX}/mips64el-rootfs

export SYSROOTGNU64=${PREFIXGNU64}/${CROSS_TARGET64}/sys-root/
export SYSROOTGNU32=${PREFIXGNU32}/${CROSS_TARGET32}/sys-root/

###########################################################
# Busybox info
###########################################################

export MOUNT_POINT=busybox_mount

export BUSYBOXO32_IMAGE=busybox-o32.img
export BUSYBOXMUL64_IMAGE=busybox-mul64.img

###########################################################
# METADATA info
###########################################################

export METADATA=${SCRIPT}/../metadata
export METADATADOWN=${METADATA}/download
export METADATABUSYBOXMUL64=${METADATA}/busybox-mul64
export METADATABUSYBOXPURE64=${METADATA}/busybox-pure64
export METADATABUSYBOXN32=${METADATA}/busybox-n32
export METADATABUSYBOXO32=${METADATA}/busybox-o32
export METADATAKERNEL64=${METADATA}/kernel-64
export METADATAKERNELN32=${METADATA}/kernel-n32
export METADATAKERNELO32=${METADATA}/kernel-o32
export METADATAGNU32=${METADATA}/gnu32
export METADATAGNU64=${METADATA}/gnu64
export METADATAUNIVERSAL=${METADATA}/universal
export METADATAMIPSELROOTFS=${METADATA}/mipsel-rootfs
export METADATAMIPS64ELROOTFS=${METADATA}/mips64el-rootfs

###########################################################
# SRC info
###########################################################

export SRC=${SCRIPT}/../src
export SRCBUSYBOXMUL64=${SRC}/busybox-mul64
export SRCBUSYBOXPURE64=${SRC}/busybox-pure64
export SRCBUSYBOXN32=${SRC}/busybox-n32
export SRCBUSYBOXO32=${SRC}/busybox-o32
export SRCKERNEL64=${SRC}/kernel-64
export SRCKERNELN32=${SRC}/kernel-n32
export SRCKERNELO32=${SRC}/kernel-o32
export SRCGNU32=${SRC}/mips-linux-tool
export SRCGNU64=${SRC}/mips64-linux-tool
export SRCUNIVERSAL=${SRC}/universal
export SRCMIPSELROOTFS=${SRC}/mipsel-rootfs
export SRCMIPS64ELROOTFS=${SRC}/mips64el-rootfs

###########################################################
# BUILD info
###########################################################

export BUILD=${SCRIPT}/../build
export BUILDBUSYBOXMUL64=${BUILD}/busybox-mul64
export BUILDBUSYBOXPURE64=${BUILD}/busybox-pure64
export BUILDBUSYBOXN32=${BUILD}/busybox-n32
export BUILDBUSYBOXO32=${BUILD}/busybox-o32
export BUILDKERNEL64=${BUILD}/kernel-64
export BUILDKERNELN32=${BUILD}/kernel-n32
export BUILDKERNELO32=${BUILD}/kernel-o32
export BUILDGNU32=${BUILD}/mips-linux-tool
export BUILDGNU64=${BUILD}/mips64-linux-tool
export BUILDUNIVERSAL=${BUILD}/universal
export BUILDMIPSELROOTFS=${BUILD}/mipsel-rootfs
export BUILDMIPS64ELROOTFS=${BUILD}/mips64el-rootfs

###########################################################
# Functions
###########################################################

function die() {
  echo "$1"
  exit 1
}

function download()
{
    [ -f $TARBALL/$1 ] && rm $TARBALL/$1
    wget -O "$TARBALL/$1" "$2"
}

function count_back ()
{
    echo "SDK Path Is: ${PREFIX}"

    for ((i = 5; i > 0; i--)); do
        echo -e "\rScript Will Start In $i Second     \c"
        sleep 1;
    done;

    echo -e "\rScript Begin:                                        "
}

###########################################################
# Wait 5 Second and begin script.
###########################################################

count_back
