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
export QTC_VERSION=2.5.2-src
export TERMCAP_VERSION=1.3.1
export TERMCAP_SUFFIX=${GZ}

function die() {
  echo "$1"
  exit 1
}

export SCRIPT="$(pwd)"
export TARBALL=${SCRIPT}/../tarballs
export PATCH=${SCRIPT}/../patches

export METADATARTEMS32=${SCRIPT}/../metadata/rtems32

export SRCRTEMS32=${SCRIPT}/../src/mips-rtems-tool

export BUILDRTEMS32=${SCRIPT}/../build/mips-rtems-tool

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

[ -d "${SRCRTEMS32}" ] || mkdir -p "${SRCRTEMS32}"

[ -d "${BUILDRTEMS32}" ] || mkdir -p "${BUILDRTEMS32}"

[ -d "${METADATARTEMS32}" ] || mkdir -p "${METADATARTEMS32}"

#################################################################
### 32bit rtems extract
#################################################################
pushd ${SRCRTEMS32}
[ -f ${METADATARTEMS32}/gmp_extract ] || \
(tar xf ${TARBALL}/gmp-${GMP_VERSION}.${GMP_SUFFIX} || \
  die "extract gmp error" ) && \
    touch ${METADATARTEMS32}/gmp_extract

[ -f ${METADATARTEMS32}/mpfr_extract ] || \
(tar xf ${TARBALL}/mpfr-${MPFR_VERSION}.${MPFR_SUFFIX} || \
  die "extract mpfr error" ) && \
    touch ${METADATARTEMS32}/mpfr_extract

[ -f ${METADATARTEMS32}/mpc_extract ] || \
(tar xf ${TARBALL}/mpc-${MPC_VERSION}.${MPC_SUFFIX} || \
  die "extract mpc error" ) && \
    touch ${METADATARTEMS32}/mpc_extract

[ -f ${METADATARTEMS32}/autoconf_extract ] || \
(tar xf ${TARBALL}/autoconf-${AUTOCONF_VERSION}.${AUTOCONF_SUFFIX} || \
  die "extract autoconf error" ) && \
    touch ${METADATARTEMS32}/autoconf_extract

[ -f ${METADATARTEMS32}/automake_extract ] || \
(tar xf ${TARBALL}/automake-${AUTOMAKE_VERSION}.${AUTOMAKE_SUFFIX} || \
  die "extract automake error" ) && \
    touch ${METADATARTEMS32}/automake_extract

[ -f ${METADATARTEMS32}/binutils_extract ] || \
(tar xf ${TARBALL}/binutils-${BINUTILS_VERSION}.${BINUTILS_SUFFIX} || \
  die "extract binutils error" ) && \
    touch ${METADATARTEMS32}/binutils_extract

[ -f ${METADATARTEMS32}/gcc_extract ] || \
(tar xf ${TARBALL}/gcc-${GCC_VERSION}.${GCC_SUFFIX} || \
  die "extract gcc error" ) && \
    touch ${METADATARTEMS32}/gcc_extract

[ -f ${METADATARTEMS32}/newlib_extract ] || \
(tar xf ${TARBALL}/newlib-${NEWLIB_VERSION}.${NEWLIB_SUFFIX}|| \
  die "extract newlib error" ) && \
    touch ${METADATARTEMS32}/newlib_extract

[ -f ${METADATARTEMS32}/gdb_extract ] || \
(tar xf ${TARBALL}/gdb-${GDB_VERSION}.${GDB_SUFFIX} || \
  die "extract gdb error" ) && \
    touch ${METADATARTEMS32}/gdb_extract
popd

#################################################################
### 32bit rtems patch
#################################################################
pushd ${SRCRTEMS32}/binutils-${BINUTILS_VERSION}
[ -f ${METADATARTEMS32}/binutils_patched ] || \
patch -p1 < ${PATCH}/binutils-2.22-rtems4.11-20120427.diff || \
  die "patch 32bit binutils error" && \
  touch ${METADATARTEMS32}/binutils_patched

[ -f ${METADATARTEMS32}/binutils_patched2 ] || \
patch -p1 < ${PATCH}/0001-MIPS-Add-mips-el-rtems-stubs.patch || \
  die "patch 32bit binutils error2" && \
  touch ${METADATARTEMS32}/binutils_patched2
popd

pushd ${SRCRTEMS32}/gcc-${GCC_VERSION}
[ -f ${METADATARTEMS32}/gcc_patched ] || \
patch -p1 < ${PATCH}/gcc-core-4.6.3-rtems4.11-20120303.diff || \
  die "patch 32bit gcc error" && \
  touch ${METADATARTEMS32}/gcc_patched
popd

pushd ${SRCRTEMS32}/newlib-${NEWLIB_VERSION}
[ -f ${METADATARTEMS32}/newlib_patched ] || \
patch -p1 < ${PATCH}/newlib-1.20.0-rtems4.11-20120718.diff || \
  die "patch 32bit newlib error" && \
  touch ${METADATARTEMS32}/newlib_patched
popd

pushd ${SRCRTEMS32}/gdb-${GDB_VERSION}
[ -f ${METADATARTEMS32}/gdb_patched ] || \
patch -p1 < ${PATCH}/gdb-7.4-rtems4.11-20120125.diff || \
  die "patch 32bit gdb error" && \
  touch ${METADATARTEMS32}/gdb_patched

[ -f ${METADATARTEMS32}/gdb_patched2 ] || \
patch -p1 < ${PATCH}/0002-MIPS-Add-mips-el-rtems-stubs.patch || \
  die "patch 32bit gdb error2" && \
  touch ${METADATARTEMS32}/gdb_patched2
popd

pushd ${SRCRTEMS32}/gcc-${GCC_VERSION}
[ -f ${METADATARTEMS32}/newlib_linked ] || \
ln -s ../newlib-${NEWLIB_VERSION}/newlib || \
  die "link 32bit newlib error" && \
  touch ${METADATARTEMS32}/newlib_linked
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
### 32bit rtems build
#################################################################
pushd ${SRCRTEMS32}
cd gmp-${GMP_VERSION}
unset CFLAGS
[ -f "${METADATARTEMS32}/gmp_configure" ] || \
  ./configure --prefix=${BUILDRTEMS32}/gmp --disable-shared --enable-static || \
    die "***config 32bit rtems gmp error" && \
      touch ${METADATARTEMS32}/gmp_configure
[ -f ${METADATARTEMS32}/gmp_build ] || \
  make -j${JOBS} || die "***build 32bit rtems gmp error" && \
    touch ${METADATARTEMS32}/gmp_build
[ -f ${METADATARTEMS32}/gmp_install ] || \
  make install || die "***install 32bit rtems gmp error" && \
    touch ${METADATARTEMS32}/gmp_install
export CFLAGS="-w"
popd

pushd ${SRCRTEMS32}
cd mpfr-${MPFR_VERSION}
[ -f "${METADATARTEMS32}/mpfr_configure" ] || \
  ./configure --prefix=${BUILDRTEMS32}/mpfr --with-gmp=${BUILDRTEMS32}/gmp \
  --disable-shared --enable-static || \
    die "***config 32bit rtems mpfr error" && \
      touch ${METADATARTEMS32}/mpfr_configure
[ -f "${METADATARTEMS32}/mpfr_build" ] || \
  make -j${JOBS} || die "***build 32bit rtems mpfr error" && \
    touch ${METADATARTEMS32}/mpfr_build
[ -f "${METADATARTEMS32}/mpfr_install" ] || \
  make install || die "***install 32bit rtems mpfr error" && \
    touch ${METADATARTEMS32}/mpfr_install
popd

pushd ${SRCRTEMS32}
cd mpc-${MPC_VERSION}
[ -f "${METADATARTEMS32}/mpc_configure" ] || \
  ./configure --prefix=${BUILDRTEMS32}/mpc \
  --with-gmp=${BUILDRTEMS32}/gmp --with-mpfr=${BUILDRTEMS32}/mpfr \
  --disable-shared --enable-static || \
    die "***config 32bit rtems mpc error" && \
      touch ${METADATARTEMS32}/mpc_configure
[ -f ${METADATARTEMS32}/mpc_build ] || \
  make -j${JOBS} || die "***build 32bit rtems mpc error" && \
    touch ${METADATARTEMS32}/mpc_build
[ -f ${METADATARTEMS32}/mpc_install ] || \
  make install || die "***install 32bit rtems mpc error" && \
    touch ${METADATARTEMS32}/mpc_install
popd

pushd ${BUILDRTEMS32}
[ -d "autoconf-build" ] || mkdir autoconf-build
cd autoconf-build
[ -f "${METADATARTEMS32}/autoconf_configure" ] || \
  ${SRCRTEMS32}/autoconf-${AUTOCONF_VERSION}/configure \
  --prefix=${RTEMSPREFIX32} || \
    die "***config 32bit rtems autoconf error" && \
      touch ${METADATARTEMS32}/autoconf_configure
[ -f ${METADATARTEMS32}/autoconf_build ] || \
  make -j${JOBS} all || die "***build 32bit rtems autoconf error" && \
    touch ${METADATARTEMS32}/autoconf_build
[ -f ${METADATARTEMS32}/autoconf_install ] || \
  make install || die "***install 32bit rtems autoconf error" && \
    touch ${METADATARTEMS32}/autoconf_install
popd

pushd ${BUILDRTEMS32}
[ -d "automake-build" ] || mkdir automake-build
cd automake-build
[ -f "${METADATARTEMS32}/automake_configure" ] || \
  ${SRCRTEMS32}/automake-${AUTOMAKE_VERSION}/configure \
  --prefix=${RTEMSPREFIX32} || \
    die "***config 32bit rtems automake error" && \
      touch ${METADATARTEMS32}/automake_configure
[ -f ${METADATARTEMS32}/automake_build ] || \
  make -j${JOBS} all || die "***build 32bit rtems automake error" && \
    touch ${METADATARTEMS32}/automake_build
[ -f ${METADATARTEMS32}/automake_install ] || \
  make install || die "***install 32bit rtems automake error" && \
    touch ${METADATARTEMS32}/automake_install
popd

pushd ${BUILDRTEMS32}
[ -d "binutils-build" ] || mkdir binutils-build
cd binutils-build
[ -f "${METADATARTEMS32}/binutils_configure" ] || AS="as" AR="ar" \
  ${SRCRTEMS32}/binutils-${BINUTILS_VERSION}/configure \
  --prefix=${RTEMSPREFIX32} --target=${CROSS_RTEMSTARGET32} \
  --with-gmp=${BUILDRTEMS32}/gmp --with-mpfr=${BUILDRTEMS32}/mpfr \
  --with-mpc=${BUILDRTEMS32}/mpc || \
    die "***config 32bit rtems binutils error" && \
      touch ${METADATARTEMS32}/binutils_configure
[ -f ${METADATARTEMS32}/binutils_build ] || \
  make -j${JOBS} all || die "***build 32bit rtems binutils error" && \
    touch ${METADATARTEMS32}/binutils_build
[ -f ${METADATARTEMS32}/binutils_install ] || \
  make install || die "***install 32bit rtems binutils error" && \
    touch ${METADATARTEMS32}/binutils_install
popd

pushd ${BUILDRTEMS32}
[ -d "gcc-build" ] || mkdir gcc-build
cd gcc-build
[ -f "${METADATARTEMS32}/gcc_configure" ] || \
  AR="ar" AS="as" \
  ${SRCRTEMS32}/gcc-${GCC_VERSION}/configure \
  --prefix=${RTEMSPREFIX32} --target=${CROSS_RTEMSTARGET32} \
  --with-gnu-as --with-gnu-ld --with-newlib --verbose \
  --enable-threads --enable-languages="c,c++" \
  --with-gmp=${BUILDRTEMS32}/gmp --with-mpfr=${BUILDRTEMS32}/mpfr \
  --with-mpc=${BUILDRTEMS32}/mpc || \
    die "***config 32bit rtems gcc error" && \
      touch ${METADATARTEMS32}/gcc_configure
[ -f "${METADATARTEMS32}/gcc_build" ] || \
  make -j${JOBS} all || die "***build 32bit rtems gcc error" && \
      touch ${METADATARTEMS32}/gcc_build
[ -f "${METADATARTEMS32}/gcc_install" ] || \
  make install || die "***install 32bit rtems gcc error" && \
      touch ${METADATARTEMS32}/gcc_install
popd

pushd ${BUILDRTEMS32}
[ -d "gdb-build" ] || mkdir gdb-build
cd gdb-build
[ -f "${METADATARTEMS32}/gdb_configure" ] || \
  ${SRCRTEMS32}/gdb-${GDB_VERSION}/configure \
  --prefix=${RTEMSPREFIX32} --target=${CROSS_RTEMSTARGET32} \
  --with-gmp=${BUILDRTEMS32}/gmp --with-mpfr=${BUILDRTEMS32}/mpfr \
  --with-mpc=${BUILDRTEMS32}/mpc || \
    die "***config 32bit rtems gdb error" && \
      touch ${METADATARTEMS32}/gdb_configure
[ -f "${METADATARTEMS32}/gdb_build" ] || \
  make -j${JOBS} || die "***build 32bit rtems gdb error" && \
    touch ${METADATARTEMS32}/gdb_build
[ -f "${METADATARTEMS32}/gdb_install" ] || \
  make install || die "***install 32bit rtems gdb error" && \
    touch ${METADATARTEMS32}/gdb_install
popd
