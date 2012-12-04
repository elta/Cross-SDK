#! /bin/bash

source source.sh

[ -d "${SRCRTEMS64}" ] || mkdir -p "${SRCRTEMS64}"
[ -d "${BUILDRTEMS64}" ] || mkdir -p "${BUILDRTEMS64}"
[ -d "${METADATARTEMS64}" ] || mkdir -p "${METADATARTEMS64}"

export PATH=${PATH}:${PREFIXRTEMS64}/bin

#################################################################
### 64bit rtems extract
#################################################################
pushd ${SRCRTEMS64}
[ -f ${METADATARTEMS64}/gmp_extract ] || \
tar xf ${TARBALL}/gmp-${GMP_VERSION}.${GMP_SUFFIX} || \
  die "extract gmp error" && \
    touch ${METADATARTEMS64}/gmp_extract

[ -f ${METADATARTEMS64}/mpfr_extract ] || \
tar xf ${TARBALL}/mpfr-${MPFR_VERSION}.${MPFR_SUFFIX} || \
  die "extract mpfr error" && \
    touch ${METADATARTEMS64}/mpfr_extract

[ -f ${METADATARTEMS64}/mpc_extract ] || \
tar xf ${TARBALL}/mpc-${MPC_VERSION}.${MPC_SUFFIX} || \
  die "extract mpc error" && \
    touch ${METADATARTEMS64}/mpc_extract

[ -f ${METADATARTEMS64}/autoconf_extract ] || \
tar xf ${TARBALL}/autoconf-${AUTOCONF_VERSION}.${AUTOCONF_SUFFIX} || \
  die "extract autoconf error" && \
    touch ${METADATARTEMS64}/autoconf_extract

[ -f ${METADATARTEMS64}/automake_extract ] || \
tar xf ${TARBALL}/automake-${AUTOMAKE_VERSION}.${AUTOMAKE_SUFFIX} || \
  die "extract automake error" && \
    touch ${METADATARTEMS64}/automake_extract

[ -f ${METADATARTEMS64}/binutils_extract ] || \
tar xf ${TARBALL}/binutils-${BINUTILS_VERSION}.${BINUTILS_SUFFIX} || \
  die "extract binutils error" && \
    touch ${METADATARTEMS64}/binutils_extract

[ -f ${METADATARTEMS64}/gcc_extract ] || \
tar xf ${TARBALL}/gcc-${GCC_VERSION}.${GCC_SUFFIX} || \
  die "extract gcc error" && \
    touch ${METADATARTEMS64}/gcc_extract

[ -f ${METADATARTEMS64}/newlib_extract ] || \
tar xf ${TARBALL}/newlib-${NEWLIB_VERSION}.${NEWLIB_SUFFIX}|| \
  die "extract newlib error" && \
    touch ${METADATARTEMS64}/newlib_extract

[ -f ${METADATARTEMS64}/gdb_extract ] || \
tar xf ${TARBALL}/gdb-${GDB_VERSION}.${GDB_SUFFIX} || \
  die "extract gdb error" && \
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

[ -f ${METADATARTEMS64}/binutils_patched2 ] || \
patch -p1 < ${PATCH}/0001-MIPS-Add-mips-el-rtems-stubs.patch || \
  die "patch 64bit binutils error2" && \
  touch ${METADATARTEMS64}/binutils_patched2
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

[ -f ${METADATARTEMS64}/gdb_patched2 ] || \
patch -p1 < ${PATCH}/0002-MIPS-Add-mips-el-rtems-stubs.patch || \
  die "patch 64bit gdb error2" && \
  touch ${METADATARTEMS64}/gdb_patched2
popd

pushd ${SRCRTEMS64}/gcc-${GCC_VERSION}
[ -f ${METADATARTEMS64}/newlib_linked ] || \
ln -s ../newlib-${NEWLIB_VERSION}/newlib || \
  die "link 64bit newlib error"&& \
  touch ${METADATARTEMS64}/newlib_linked
popd

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
  --prefix=${PREFIXRTEMS64} || \
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
  --prefix=${PREFIXRTEMS64} || \
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
  --prefix=${PREFIXRTEMS64} --target=${CROSS_RTEMSTARGET64} \
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
  --prefix=${PREFIXRTEMS64} --target=${CROSS_RTEMSTARGET64} \
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
  --prefix=${PREFIXRTEMS64} --target=${CROSS_RTEMSTARGET64} \
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
