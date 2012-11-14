#! /bin/bash

export JOBS=3

export BZ=tar.bz2
export GZ=tar.gz
export XZ=tar.xz

export AUTOCONF_VERSION=2.69
export AUTOCONF_SUFFIX=${XZ}
export AUTOMAKE_VERSION=1.12.1
export AUTOMAKE_SUFFIX=${XZ}
export LLVM_VERSION=3.1
export LLVM_SUFFIX=${BZ}
export LINUX_VERSION=3.3.7
export LINUX_SUFFIX=${BZ}
export GMP_VERSION=5.0.5
export GMP_SUFFIX=${BZ}
export MPFR_VERSION=3.1.0
export MPFR_SUFFIX=${BZ}
export MPC_VERSION=0.9
export MPC_SUFFIX=${GZ}
export PPL_VERSION=0.11.2
export PPL_SUFFIX=${BZ}
export CLOOG_VERSION=0.16.3
export CLOOG_SUFFIX=${GZ}
export BINUTILS_VERSION=2.22
export BINUTILS_SUFFIX=${BZ}
export GCC_VERSION=4.6.3
export GCC_SUFFIX=${BZ}
export GLIBC_VERSION=2.15
export GLIBC_SUFFIX=${BZ}
export NEWLIB_VERSION=1.20.0
export NEWLIB_SUFFIX=${GZ}
export GDB_VERSION=7.4
export GDB_SUFFIX=${BZ}
export QEMU_VERSION=1.1.1
export QTC_VERSION=2.5.2
export TERMCAP_VERSION=1.3.1
export TERMCAP_SUFFIX=${GZ}

function die() {
  echo "$1"
  exit 1
}

export SCRIPT="$(pwd)"
export TARBALL=${SCRIPT}/../tarballs
export PATCH=${SCRIPT}/../patches

export METADATAUNIVERSAL=${SCRIPT}/../../metadata/universal
export METADATA64=${SCRIPT}/../../metadata/gnu64
export METADATA32=${SCRIPT}/../../metadata/gnu32
export METADATARTEMS64=${SCRIPT}/../../metadata/rtems64
export METADATARTEMS32=${SCRIPT}/../../metadata/rtems32
export METADATABARE64=${SCRIPT}/../../metadata/elf64
export METADATABARE32=${SCRIPT}/../../metadata/elf32

export SRCS=${SCRIPT}/../srcs
export SRCUNIVERSAL=${SCRIPT}/../../src/universal
export SRC64=${SCRIPT}/../../src/mips64-linux-tool
export SRC32=${SCRIPT}/../../src/mips-linux-tool
export SRCRTEMS64=${SCRIPT}/../../src/mips64-rtems-tool
export SRCRTEMS32=${SCRIPT}/../../src/mips-rtems-tool
export SRCBARE64=${SCRIPT}/../../src/mips64-elf-tool
export SRCBARE32=${SCRIPT}/../../src/mips-elf-tool

export BUILDUNIVERSAL=${SCRIPT}/../../build/universal
export BUILD64=${SCRIPT}/../../build/mips64-linux-tool
export BUILD32=${SCRIPT}/../../build/mips-linux-tool
export BUILDRTEMS64=${SCRIPT}/../../build/mips64-rtems-tool
export BUILDRTEMS32=${SCRIPT}/../../build/mips-rtems-tool
export BUILDBARE64=${SCRIPT}/../../build/mips64-elf-tool
export BUILDBARE32=${SCRIPT}/../../build/mips-elf-tool

[[ $# -eq 1 ]] || die "usage: $0 PREFIX"
export PREFIX="$1"
export PREFIX64=${PREFIX}/gnu64
export PREFIX32=${PREFIX}/gnu32
export RTEMSPREFIX64=${PREFIX}/rtems64
export RTEMSPREFIX32=${PREFIX}/rtems32
export BAREPREFIX64=${PREFIX}/elf64
export BAREPREFIX32=${PREFIX}/elf32
export QEMUPREFIX=${PREFIX}/qemu
export LLVMPREFIX=${PREFIX}/llvm
export QTCPREFIX=${PREFIX}/qt-creator
export PATH=${PATH}:${PREFIX64}/bin:${PREFIX32}/bin:${RTEMSPREFIX64}/bin:${RTEMSPREFIX32}/bin:${BAREPREFIX64}/bin:${BAREPREFIX32}/bin

[ -d "${SRCUNIVERSAL}" ] ||  mkdir -p "${SRCUNIVERSAL}"
[ -d "${SRC64}" ] || mkdir -p "${SRC64}"
[ -d "${SRC32}" ] || mkdir -p "${SRC32}"
[ -d "${SRCRTEMS64}" ] || mkdir -p "${SRCRTEMS64}"
[ -d "${SRCRTEMS32}" ] || mkdir -p "${SRCRTEMS32}"
[ -d "${SRCBARE64}" ] || mkdir -p "${SRCBARE64}"
[ -d "${SRCBARE32}" ] || mkdir -p "${SRCBARE32}"

[ -d "${BUILDUNIVERSAL}" ] ||  mkdir -p "${BUILDUNIVERSAL}"
[ -d "${BUILD64}" ] || mkdir -p "${BUILD64}"
[ -d "${BUILD32}" ] || mkdir -p "${BUILD32}"
[ -d "${BUILDRTEMS64}" ] || mkdir -p "${BUILDRTEMS64}"
[ -d "${BUILDRTEMS32}" ] || mkdir -p "${BUILDRTEMS32}"
[ -d "${BUILDBARE64}" ] || mkdir -p "${BUILDBARE64}"
[ -d "${BUILDBARE32}" ] || mkdir -p "${BUILDBARE32}"

[ -d "${METADATAUNIVERSAL}" ] || mkdir -p "${METADATAUNIVERSAL}"
[ -d "${METADATA64}" ] || mkdir -p "${METADATA64}"
[ -d "${METADATA32}" ] || mkdir -p "${METADATA32}"
[ -d "${METADATARTEMS64}" ] || mkdir -p "${METADATARTEMS64}"
[ -d "${METADATARTEMS32}" ] || mkdir -p "${METADATARTEMS32}"
[ -d "${METADATABARE64}" ] || mkdir -p "${METADATABARE64}"
[ -d "${METADATABARE32}" ] || mkdir -p "${METADATABARE32}"

#################################################################
### 64bit rtems extract
#################################################################
pushd ${SRCRTEMS64}
[ -f ${METADATARTEMS64}/gmp_extract ] || \
tar xf ${TARBALL}/gmp-${GMP_VERSION}.${GMP_SUFFIX} && \
  touch ${METADATARTEMS64}/gmp_extract

[ -f ${METADATARTEMS64}/mpfr_extract ] || \
tar xf ${TARBALL}/mpfr-${MPFR_VERSION}.${MPFR_SUFFIX} && \
  touch ${METADATARTEMS64}/mpfr_extract

[ -f ${METADATARTEMS64}/mpc_extract ] || \
tar xf ${TARBALL}/mpc-${MPC_VERSION}.${MPC_SUFFIX} && \
  touch ${METADATARTEMS64}/mpc_extract

[ -f ${METADATARTEMS64}/autoconf_extract ] || \
tar xf ${TARBALL}/autoconf-${AUTOCONF_VERSION}.${AUTOCONF_SUFFIX} && \
  touch ${METADATARTEMS64}/autoconf_extract

[ -f ${METADATARTEMS64}/automake_extract ] || \
tar xf ${TARBALL}/automake-${AUTOMAKE_VERSION}.${AUTOMAKE_SUFFIX} && \
  touch ${METADATARTEMS64}/automake_extract

[ -f ${METADATARTEMS64}/binutils_extract ] || \
tar xf ${TARBALL}/binutils-${BINUTILS_VERSION}.${BINUTILS_SUFFIX} && \
  touch ${METADATARTEMS64}/binutils_extract

[ -f ${METADATARTEMS64}/gcc_extract ] || \
tar xf ${TARBALL}/gcc-${GCC_VERSION}.${GCC_SUFFIX} && \
  touch ${METADATARTEMS64}/gcc_extract

[ -f ${METADATARTEMS64}/newlib_extract ] || \
tar xf ${TARBALL}/newlib-${NEWLIB_VERSION}.${NEWLIB_SUFFIX} &&\
  touch ${METADATARTEMS64}/newlib_extract

[ -f ${METADATARTEMS64}/gdb_extract ] || \
tar xf ${TARBALL}/gdb-${GDB_VERSION}.${GDB_SUFFIX} && \
  touch ${METADATARTEMS64}/gdb_extract
popd

#################################################################
### 64bit rtems patch
#################################################################
pushd ${SRCRTEMS64}/binutils-${BINUTILS_VERSION}
[ -f ${METADATARTEMS64}/binutils_patched ] || \
patch -p1 < ${PATCH}/binutils-2.22-rtems4.11-20120427.diff || \
  die "patch 64bit binutils error" && \
  touch ${METADATARTEMS64}/binutils_patched
popd

pushd ${SRCRTEMS64}/gcc-${GCC_VERSION}
[ -f ${METADATARTEMS64}/gcc_patched ] || \
patch -p1 < ${PATCH}/gcc-core-4.6.3-rtems4.11-20120303.diff || \
  die "patch 64bit gcc error" && \
  touch ${METADATARTEMS64}/gcc_patched
popd

pushd ${SRCRTEMS64}/newlib-${NEWLIB_VERSION}
[ -f ${METADATARTEMS64}/newlib_patched ] || \
patch -p1 < ${PATCH}/newlib-1.20.0-rtems4.11-20120718.diff || \
  die "patch 64bit newlib error" && \
  touch ${METADATARTEMS64}/newlib_patched
popd

pushd ${SRCRTEMS64}/gdb-${GDB_VERSION}
[ -f ${METADATARTEMS64}/gdb_patched ] || \
patch -p1 < ${PATCH}/gdb-7.4-rtems4.11-20120125.diff || \
  die "patch 64bit gdb error" && \
  touch ${METADATARTEMS64}/gdb_patched
popd

pushd ${SRCRTEMS64}/gcc-${GCC_VERSION}
[ -f ${METADATARTEMS64}/newlib_linked ] || \
ln -s ../newlib-${NEWLIB_VERSION}/newlib || \
  die "link 64bit newlib error"&& \
  touch ${METADATARTEMS64}/newlib_linked
popd

unset CFLAGS
unset CXXFLAGS
export CFLAGS="-w"
export CROSS_HOST=${MACHTYPE}
export CROSS_TARGET64="mips64el-unknown-linux-gnu"
export CROSS_TARGET32="$(echo ${CROSS_TARGET64}| sed -e 's/64//g')"
export CROSS_RTEMSTARGET64="mips64el-rtems4.11"
export CROSS_RTEMSTARGET32="mipsel-rtems4.11"
export CROSS_BARETARGET64="mips64el-unknown-elf"
export CROSS_BARETARGET32="mipsel-unknown-elf"
export SYSROOT64=${PREFIX64}/${CROSS_TARGET64}/sys-root
export SYSROOT32=${PREFIX32}/${CROSS_TARGET32}/sys-root
export O32="-mabi=32"
export N32="-mabi=n32"
export N64="-mabi=64"
export QEMU_TARGET="mips64el-softmmu,mipsel-softmmu,mipsel-linux-user"

#################################################################
### 64bit rtems build
#################################################################
pushd ${SRCRTEMS64}
unset CFLAGS
cd gmp-${GMP_VERSION}
[ -f "${METADATARTEMS64}/gmp_configure" ] || \
  ./configure --prefix=${BUILDRTEMS64}/gmp --disable-shared --enable-static || \
    die "***config 64bit rtems gmp error" && \
      touch ${METADATARTEMS64}/gmp_configure
[ -f ${METADATARTEMS64}/gmp_build ] || \
  make -j${JOBS} || die "***build 64bit rtems gmp error" && \
    touch ${METADATARTEMS64}/gmp_build
[ -f ${METADATARTEMS64}/gmp_install ] || \
  make install || die "***install 64bit rtems gmp error" && \
    touch ${METADATARTEMS64}/gmp_install
export CFLAGS="-w"
popd

pushd ${SRCRTEMS64}
cd mpfr-${MPFR_VERSION}
[ -f "${METADATARTEMS64}/mpfr_configure" ] || \
  ./configure --prefix=${BUILDRTEMS64}/mpfr --with-gmp=${BUILDRTEMS64}/gmp \
  --disable-shared --enable-static || \
    die "***config 64bit rtems mpfr error" && \
      touch ${METADATARTEMS64}/mpfr_configure
[ -f "${METADATARTEMS64}/mpfr_build" ] || \
  make -j${JOBS} || die "***build 64bit rtems mpfr error" && \
    touch ${METADATARTEMS64}/mpfr_build
[ -f "${METADATARTEMS64}/mpfr_install" ] || \
  make install || die "***install 64bit rtems mpfr error" && \
    touch ${METADATARTEMS64}/mpfr_install
popd

pushd ${SRCRTEMS64}
cd mpc-${MPC_VERSION}
[ -f "${METADATARTEMS64}/mpc_configure" ] || \
  ./configure --prefix=${BUILDRTEMS64}/mpc \
  --with-gmp=${BUILDRTEMS64}/gmp --with-mpfr=${BUILDRTEMS64}/mpfr \
  --disable-shared --enable-static || \
    die "***config 64bit rtems mpc error" && \
      touch ${METADATARTEMS64}/mpc_configure
[ -f ${METADATARTEMS64}/mpc_build ] || \
  make -j${JOBS} || die "***build 64bit rtems mpc error" && \
    touch ${METADATARTEMS64}/mpc_build
[ -f ${METADATARTEMS64}/mpc_install ] || \
  make install || die "***install 64bit rtems mpc error" && \
    touch ${METADATARTEMS64}/mpc_install
popd

pushd ${BUILDRTEMS64}
[ -d "autoconf-build" ] || mkdir autoconf-build
cd autoconf-build
[ -f "${METADATARTEMS64}/autoconf_configure" ] || \
  ${SRCRTEMS64}/autoconf-${AUTOCONF_VERSION}/configure \
  --prefix=${RTEMSPREFIX64} || \
    die "***config 64bit rtems autoconf error" && \
      touch ${METADATARTEMS64}/autoconf_configure
[ -f ${METADATARTEMS64}/autoconf_build ] || \
  make -j${JOBS} all || die "***build 64bit rtems autoconf error" && \
    touch ${METADATARTEMS64}/autoconf_build
[ -f ${METADATARTEMS64}/autoconf_install ] || \
  make install || die "***install 64bit rtems autoconf error" && \
    touch ${METADATARTEMS64}/autoconf_install
popd

pushd ${BUILDRTEMS64}
[ -d "automake-build" ] || mkdir automake-build
cd automake-build
[ -f "${METADATARTEMS64}/automake_configure" ] || \
  ${SRCRTEMS64}/automake-${AUTOMAKE_VERSION}/configure \
  --prefix=${RTEMSPREFIX64} || \
    die "***config 64bit rtems automake error" && \
      touch ${METADATARTEMS64}/automake_configure
[ -f ${METADATARTEMS64}/automake_build ] || \
  make -j${JOBS} all || die "***build 64bit rtems automake error" && \
    touch ${METADATARTEMS64}/automake_build
[ -f ${METADATARTEMS64}/automake_install ] || \
  make install || die "***install 64bit rtems automake error" && \
    touch ${METADATARTEMS64}/automake_install
popd

pushd ${BUILDRTEMS64}
[ -d "binutils-build" ] || mkdir binutils-build
cd binutils-build
[ -f "${METADATARTEMS64}/binutils_configure" ] || AS="as" AR="ar" \
  ${SRCRTEMS64}/binutils-${BINUTILS_VERSION}/configure \
  --prefix=${RTEMSPREFIX64} --target=${CROSS_RTEMSTARGET64} \
  --with-gmp=${BUILDRTEMS64}/gmp --with-mpfr=${BUILDRTEMS64}/mpfr \
  --with-mpc=${BUILDRTEMS64}/mpc || \
    die "***config 64bit rtems binutils error" && \
      touch ${METADATARTEMS64}/binutils_configure
[ -f ${METADATARTEMS64}/binutils_build ] || \
  make -j${JOBS} all || die "***build 64bit rtems binutils error" && \
    touch ${METADATARTEMS64}/binutils_build
[ -f ${METADATARTEMS64}/binutils_install ] || \
  make install || die "***install 64bit rtems binutils error" && \
    touch ${METADATARTEMS64}/binutils_install
popd

pushd ${BUILDRTEMS64}
[ -d "gcc-build" ] || mkdir gcc-build
cd gcc-build
[ -f "${METADATARTEMS64}/gcc_configure" ] || \
  AR="ar" AS="as" \
  ${SRCRTEMS64}/gcc-${GCC_VERSION}/configure \
  --prefix=${RTEMSPREFIX64} --target=${CROSS_RTEMSTARGET64} \
  --with-gnu-as --with-gnu-ld --with-newlib --verbose \
  --enable-threads --enable-languages="c,c++" \
  --with-gmp=${BUILDRTEMS64}/gmp --with-mpfr=${BUILDRTEMS64}/mpfr \
  --with-mpc=${BUILDRTEMS64}/mpc || \
    die "***config 64bit rtems gcc error" && \
      touch ${METADATARTEMS64}/gcc_configure
[ -f "${METADATARTEMS64}/gcc_build" ] || \
  make -j${JOBS} all || die "***build 64bit rtems gcc error" && \
      touch ${METADATARTEMS64}/gcc_build
[ -f "${METADATARTEMS64}/gcc_install" ] || \
  make install || die "***install 64bit rtems gcc error" && \
      touch ${METADATARTEMS64}/gcc_install
popd

pushd ${BUILDRTEMS64}
[ -d "gdb-build" ] || mkdir gdb-build
cd gdb-build
[ -f "${METADATARTEMS64}/gdb_configure" ] || \
  ${SRCRTEMS64}/gdb-${GDB_VERSION}/configure \
  --prefix=${RTEMSPREFIX64} --target=${CROSS_RTEMSTARGET64} \
  --with-gmp=${BUILDRTEMS64}/gmp --with-mpfr=${BUILDRTEMS64}/mpfr \
  --with-mpc=${BUILDRTEMS64}/mpc || \
    die "***config 64bit rtems gdb error" && \
      touch ${METADATARTEMS64}/gdb_configure
[ -f "${METADATARTEMS64}/gdb_build" ] || \
  make -j${JOBS} || die "***build 64bit rtems gdb error" && \
    touch ${METADATARTEMS64}/gdb_build
[ -f "${METADATARTEMS64}/gdb_install" ] || \
  make install || die "***install 64bit rtems gdb error" && \
    touch ${METADATARTEMS64}/gdb_install
popd
