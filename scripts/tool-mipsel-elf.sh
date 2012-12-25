#! /bin/bash

source source.sh

[ -d "${SRCBARE32}" ] || mkdir -p "${SRCBARE32}"
[ -d "${BUILDBARE32}" ] || mkdir -p "${BUILDBARE32}"
[ -d "${METADATABARE32}" ] || mkdir -p "${METADATABARE32}"

export PATH=${PATH}:${PREFIXBARE32}/bin

#################################################################
### 32bit bare extract
#################################################################
pushd ${SRCBARE32}
[ -f ${METADATABARE32}/gmp_extract ] || \
tar xf ${TARBALL}/gmp-${GMP_VERSION}.${GMP_SUFFIX} || \
  die "extract gmp error" && \
    touch ${METADATABARE32}/gmp_extract

[ -f ${METADATABARE32}/mpfr_extract ] || \
tar xf ${TARBALL}/mpfr-${MPFR_VERSION}.${MPFR_SUFFIX} || \
  die "extract mpfr error" && \
    touch ${METADATABARE32}/mpfr_extract

[ -f ${METADATABARE32}/mpc_extract ] || \
tar xf ${TARBALL}/mpc-${MPC_VERSION}.${MPC_SUFFIX} || \
  die "extract mpc error" && \
    touch ${METADATABARE32}/mpc_extract

[ -f ${METADATABARE32}/binutils_extract ] || \
tar xf ${TARBALL}/binutils-${BINUTILS_VERSION}.${BINUTILS_SUFFIX} || \
  die "extract binutils error" && \
    touch ${METADATABARE32}/binutils_extract

[ -f ${METADATABARE32}/gcc_extract ] || \
tar xf ${TARBALL}/gcc-${GCC_VERSION}.${GCC_SUFFIX} || \
  die "extract gcc error" && \
    touch ${METADATABARE32}/gcc_extract

[ -f ${METADATABARE32}/newlib_extract ] || \
tar xf ${TARBALL}/newlib-${NEWLIB_VERSION}.${NEWLIB_SUFFIX} || \
  die "extract newlib error" && \
    touch ${METADATABARE32}/newlib_extract

[ -f ${METADATABARE32}/gdb_extract ] || \
tar xf ${TARBALL}/gdb-${GDB_VERSION}.${GDB_SUFFIX} || \
  die "extract gdb error" && \
    touch ${METADATABARE32}/gdb_extract
popd

#################################################################
### 32bit bare build
#################################################################
pushd ${SRCBARE32}
cd gmp-${GMP_VERSION}
unset CFLAGS
[ -f "${METADATABARE32}/gmp_configure" ] || \
  ./configure --prefix=${BUILDBARE32}/gmp --disable-shared --enable-static || \
    die "***config 32bit bare gmp error" && \
      touch ${METADATABARE32}/gmp_configure
[ -f ${METADATABARE32}/gmp_build ] || \
  make -j${JOBS} || die "***build 32bit bare gmp error" && \
    touch ${METADATABARE32}/gmp_build
[ -f ${METADATABARE32}/gmp_install ] || \
  make install || die "***install 32bit bare gmp error" && \
    touch ${METADATABARE32}/gmp_install
export CFLAGS="-w"
popd

pushd ${SRCBARE32}
cd mpfr-${MPFR_VERSION}
[ -f "${METADATABARE32}/mpfr_configure" ] || \
  ./configure --prefix=${BUILDBARE32}/mpfr --with-gmp=${BUILDBARE32}/gmp \
  --disable-shared --enable-static || \
    die "***config 32bit bare mpfr error" && \
      touch ${METADATABARE32}/mpfr_configure
[ -f "${METADATABARE32}/mpfr_build" ] || \
  make -j${JOBS} || die "***build 32bit bare mpfr error" && \
    touch ${METADATABARE32}/mpfr_build
[ -f "${METADATABARE32}/mpfr_install" ] || \
  make install || die "***install 32bit bare mpfr error" && \
    touch ${METADATABARE32}/mpfr_install
popd

pushd ${SRCBARE32}
cd mpc-${MPC_VERSION}
[ -f "${METADATABARE32}/mpc_configure" ] || \
  ./configure --prefix=${BUILDBARE32}/mpc \
  --with-gmp=${BUILDBARE32}/gmp --with-mpfr=${BUILDBARE32}/mpfr \
  --disable-shared --enable-static || \
    die "***config 32bit bare mpc error" && \
      touch ${METADATABARE32}/mpc_configure
[ -f ${METADATABARE32}/mpc_build ] || \
  make -j${JOBS} || die "***build 32bit bare mpc error" && \
    touch ${METADATABARE32}/mpc_build
[ -f ${METADATABARE32}/mpc_install ] || \
  make install || die "***install 32bit bare mpc error" && \
    touch ${METADATABARE32}/mpc_install
popd

pushd ${BUILDBARE32}
[ -d "binutils-build" ] || mkdir binutils-build
cd binutils-build
[ -f "${METADATABARE32}/binutils_configure" ] || AS="as" AR="ar" \
  ${SRCBARE32}/binutils-${BINUTILS_VERSION}/configure \
  --prefix=${PREFIXBARE32} --target=${CROSS_BARETARGET32} \
  --disable-nls --enable-interwork --disable-shared \
  --enable-threads --with-gcc --with-gnu-as --with-gnu-ld \
  --with-gmp=${BUILDBARE32}/gmp --with-mpfr=${BUILDBARE32}/mpfr \
  --with-mpc=${BUILDBARE32}/mpc || \
    die "***config 32bit bare binutils error" && \
      touch ${METADATABARE32}/binutils_configure
[ -f ${METADATABARE32}/binutils_build ] || \
  make -j${JOBS} all || die "***build 32bit bare binutils error" && \
    touch ${METADATABARE32}/binutils_build
[ -f ${METADATABARE32}/binutils_install ] || \
  make install || die "***install 32bit bare binutils error" && \
    touch ${METADATABARE32}/binutils_install
popd

pushd ${BUILDBARE32}
[ -d "gcc-build-stage" ] || mkdir gcc-build-stage1
cd gcc-build-stage1
[ -f "${METADATABARE32}/gcc_configure_stage1" ] || \
  AR="ar" AS="as" \
  ${SRCBARE32}/gcc-${GCC_VERSION}/configure \
  --prefix=${PREFIXBARE32} --target=${CROSS_BARETARGET32} \
  --enable-interwork --enable-languages=c \
  --with-newlib --disable-nls --disable-shared --enable-threads \
  --with-gnu-as --with-gnu-ld \
  --without-headers --disable-libquadmath --disable-libssp \
  --with-gmp=${BUILDBARE32}/gmp --with-mpfr=${BUILDBARE32}/mpfr \
  --with-mpc=${BUILDBARE32}/mpc || \
    die "***config 32bit bare gcc stage1 error" && \
      touch ${METADATABARE32}/gcc_configure_stage1
[ -f "${METADATABARE32}/gcc_build_stage1" ] || \
  make -j${JOBS} all || die "***build 32bit bare gcc stage1 error" && \
      touch ${METADATABARE32}/gcc_build_stage1
[ -f "${METADATABARE32}/gcc_install_stage1" ] || \
  make install || die "***install 32bit bare gcc stage1 error" && \
      touch ${METADATABARE32}/gcc_install_stage1
popd

pushd ${BUILDBARE32}
[ -d "newlib-build" ] || mkdir newlib-build
cd newlib-build
[ -f "${METADATABARE32}/newlib_configure" ] || \
  ${SRCBARE32}/newlib-${NEWLIB_VERSION}/configure \
  --prefix=${PREFIXBARE32} --target=${CROSS_BARETARGET32} \
  --enable-interwork --with-gnu-as --with-gnu-ld \
  --disable-nls || \
    die "***config 32bit newlib error" && \
      touch ${METADATABARE32}/newlib_configure
[ -f "${METADATABARE32}/newlib_build" ] || \
  make -j${JOBS} || die "***build 32bit newlib error" && \
    touch ${METADATABARE32}/newlib_build
[ -f "${METADATABARE32}/newlib_install" ] || \
  make install || die "***install 32bit newlib error"
    touch ${METADATABARE32}/newlib_install
popd

pushd ${BUILDBARE32}
[ -d "gcc-build-stage2" ] || mkdir gcc-build-stage2
cd gcc-build-stage2
[ -f "${METADATABARE32}/gcc_configure_stage2" ] || \
  AR="ar" AS="as" \
  ${SRCBARE32}/gcc-${GCC_VERSION}/configure \
  --prefix=${PREFIXBARE32} --target=${CROSS_BARETARGET32} \
  --enable-interwork --enable-languages=c,c++ \
  --with-newlib --disable-nls --disable-shared --enable-threads \
  --with-gnu-as --with-gnu-ld \
  --with-gmp=${BUILDBARE32}/gmp --with-mpfr=${BUILDBARE32}/mpfr \
  --with-mpc=${BUILDBARE32}/mpc || \
    die "***config 32bit bare gcc stage2 error" && \
      touch ${METADATABARE32}/gcc_configure_stage2
[ -f "${METADATABARE32}/gcc_build_stage2" ] || \
  make -j${JOBS} all || die "***build 32bit bare gcc stage2 error" && \
      touch ${METADATABARE32}/gcc_build_stage2
[ -f "${METADATABARE32}/gcc_install_stage2" ] || \
  make install || die "***install 32bit bare gcc stage2 error" && \
      touch ${METADATABARE32}/gcc_install_stage2
popd

pushd ${BUILDBARE32}
[ -d "gdb-build" ] || mkdir gdb-build
cd gdb-build
[ -f "${METADATABARE32}/gdb_configure" ] || \
  ${SRCBARE32}/gdb-${GDB_VERSION}/configure \
  --prefix=${PREFIXBARE32} --target=${CROSS_BARETARGET32} \
  --with-gmp=${BUILDBARE32}/gmp --with-mpfr=${BUILDBARE32}/mpfr \
  --with-mpc=${BUILDBARE32}/mpc || \
    die "***config 32bit bare gdb error" && \
      touch ${METADATABARE32}/gdb_configure
[ -f "${METADATABARE32}/gdb_build" ] || \
  make -j${JOBS} || die "***build 32bit bare gdb error" && \
    touch ${METADATABARE32}/gdb_build
[ -f "${METADATABARE32}/gdb_install" ] || \
  make install || die "***install 32bit bare gdb error" && \
    touch ${METADATABARE32}/gdb_install
popd
