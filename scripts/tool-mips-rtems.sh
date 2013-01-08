#! /bin/bash

source source.sh

[ -d "${SRCRTEMS32}" ] || mkdir -p "${SRCRTEMS32}"
[ -d "${BUILDRTEMS32}" ] || mkdir -p "${BUILDRTEMS32}"
[ -d "${METADATARTEMS32}" ] || mkdir -p "${METADATARTEMS32}"

export PATH=${PATH}:${PREFIXRTEMS32}/bin

#################################################################
### 32bit rtems extract
#################################################################
pushd ${SRCRTEMS32}
[ -f ${METADATARTEMS32}/gmp_extract ] || \
tar xf ${TARBALL}/gmp-${GMP_VERSION}.${GMP_SUFFIX} || \
  die "extract gmp error" && \
    touch ${METADATARTEMS32}/gmp_extract

[ -f ${METADATARTEMS32}/mpfr_extract ] || \
tar xf ${TARBALL}/mpfr-${MPFR_VERSION}.${MPFR_SUFFIX} || \
  die "extract mpfr error" && \
    touch ${METADATARTEMS32}/mpfr_extract

[ -f ${METADATARTEMS32}/mpc_extract ] || \
tar xf ${TARBALL}/mpc-${MPC_VERSION}.${MPC_SUFFIX} || \
  die "extract mpc error" && \
    touch ${METADATARTEMS32}/mpc_extract

[ -f ${METADATARTEMS32}/autoconf_extract ] || \
tar xf ${TARBALL}/autoconf-${AUTOCONF_VERSION}.${AUTOCONF_SUFFIX} || \
  die "extract autoconf error" && \
    touch ${METADATARTEMS32}/autoconf_extract

[ -f ${METADATARTEMS32}/automake_extract ] || \
tar xf ${TARBALL}/automake-${AUTOMAKE_RTEMS_VERSION}.${AUTOMAKE_RTEMS_SUFFIX} || \
  die "extract automake error" && \
    touch ${METADATARTEMS32}/automake_extract

[ -f ${METADATARTEMS32}/binutils_extract ] || \
tar xf ${TARBALL}/binutils-${BINUTILS_VERSION}.${BINUTILS_SUFFIX} || \
  die "extract binutils error" && \
    touch ${METADATARTEMS32}/binutils_extract

[ -f ${METADATARTEMS32}/gcc_extract ] || \
tar xf ${TARBALL}/gcc-${GCC_VERSION}.${GCC_SUFFIX} || \
  die "extract gcc error" && \
    touch ${METADATARTEMS32}/gcc_extract

[ -f ${METADATARTEMS32}/newlib_extract ] || \
tar xf ${TARBALL}/newlib-${NEWLIB_VERSION}.${NEWLIB_SUFFIX}|| \
  die "extract newlib error" && \
    touch ${METADATARTEMS32}/newlib_extract

[ -f ${METADATARTEMS32}/gdb_extract ] || \
tar xf ${TARBALL}/gdb-${GDB_VERSION}.${GDB_SUFFIX} || \
  die "extract gdb error" && \
    touch ${METADATARTEMS32}/gdb_extract
popd

#################################################################
### 32bit rtems patch
#################################################################
pushd ${SRCRTEMS32}/gcc-${GCC_VERSION}
[ -f ${METADATARTEMS32}/gcc_patched ] || \
patch -p1 < ${PATCH}/gcc-4.7.2-rtems4.11-20121026.diff || \
  die "patch 32bit gcc error" && \
  touch ${METADATARTEMS32}/gcc_patched
popd

pushd ${SRCRTEMS32}/newlib-${NEWLIB_VERSION}
[ -f ${METADATARTEMS32}/newlib_patched ] || \
patch -p1 < ${PATCH}/newlib-1.20.0-rtems4.11-20121011.diff || \
  die "patch 32bit newlib error" && \
  touch ${METADATARTEMS32}/newlib_patched
popd

pushd ${SRCRTEMS32}/gdb-${GDB_VERSION}
[ -f ${METADATARTEMS32}/gdb_patched ] || \
patch -p1 < ${PATCH}/gdb-7.5.1-rtems4.11-20121130.diff || \
  die "patch 32bit gdb error" && \
  touch ${METADATARTEMS32}/gdb_patched
popd


#################################################################
### 32bit newlib link
#################################################################

pushd ${SRCRTEMS32}/gcc-${GCC_VERSION}
[ -f ${METADATARTEMS32}/newlib_linked ] || \
ln -s ../newlib-${NEWLIB_VERSION}/newlib || \
  die "link 32bit newlib error" && \
  touch ${METADATARTEMS32}/newlib_linked
popd

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
  --prefix=${PREFIXRTEMS32} || \
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
  ${SRCRTEMS32}/automake-${AUTOMAKE_RTEMS_VERSION}/configure \
  --prefix=${PREFIXRTEMS32} || \
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
  --prefix=${PREFIXRTEMS32} --target=${CROSS_RTEMSTARGET32} \
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
  --prefix=${PREFIXRTEMS32} --target=${CROSS_RTEMSTARGET32} \
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
  --prefix=${PREFIXRTEMS32} --target=${CROSS_RTEMSTARGET32} \
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
