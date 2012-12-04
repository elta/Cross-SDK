#! /bin/bash

source source.sh


[ -d "${SRCBARE64}" ] || mkdir -p "${SRCBARE64}"
[ -d "${BUILDBARE64}" ] || mkdir -p "${BUILDBARE64}"
[ -d "${METADATABARE64}" ] || mkdir -p "${METADATABARE64}"

export PATH=${PATH}:${PREFIXBARE64}/bin

#################################################################
### 64bit bare extract
#################################################################
pushd ${SRCBARE64}
[ -f ${METADATABARE64}/gmp_extract ] || \
tar xf ${TARBALL}/gmp-${GMP_VERSION}.${GMP_SUFFIX} || \
  die "extract gmp error" && \
    touch ${METADATABARE64}/gmp_extract

[ -f ${METADATABARE64}/mpfr_extract ] || \
tar xf ${TARBALL}/mpfr-${MPFR_VERSION}.${MPFR_SUFFIX} || \
  die "extract mpfr error" && \
    touch ${METADATABARE64}/mpfr_extract

[ -f ${METADATABARE64}/mpc_extract ] || \
tar xf ${TARBALL}/mpc-${MPC_VERSION}.${MPC_SUFFIX} || \
  die "extract mpc error" && \
    touch ${METADATABARE64}/mpc_extract

[ -f ${METADATABARE64}/binutils_extract ] || \
tar xf ${TARBALL}/binutils-${BINUTILS_VERSION}.${BINUTILS_SUFFIX} || \
  die "extract binutils error" && \
    touch ${METADATABARE64}/binutils_extract

[ -f ${METADATABARE64}/gcc_extract ] || \
tar xf ${TARBALL}/gcc-${GCC_VERSION}.${GCC_SUFFIX} || \
  die "extract gcc error" && \
    touch ${METADATABARE64}/gcc_extract

[ -f ${METADATABARE64}/newlib_extract ] || \
tar xf ${TARBALL}/newlib-${NEWLIB_VERSION}.${NEWLIB_SUFFIX} || \
  die "extract newlib error" && \
    touch ${METADATABARE64}/newlib_extract

[ -f ${METADATABARE64}/gdb_extract ] || \
tar xf ${TARBALL}/gdb-${GDB_VERSION}.${GDB_SUFFIX} || \
  die "extract gdb error" && \
    touch ${METADATABARE64}/gdb_extract
popd

#################################################################
### 64bit bare build
#################################################################
pushd ${SRCBARE64}
unset CFLAGS
cd gmp-${GMP_VERSION}
[ -f "${METADATABARE64}/gmp_configure" ] || \
  ./configure --prefix=${BUILDBARE64}/gmp --disable-shared --enable-static || \
    die "***config 64bit bare gmp error" && \
      touch ${METADATABARE64}/gmp_configure
[ -f ${METADATABARE64}/gmp_build ] || \
  make -j${JOBS} || die "***build 64bit bare gmp error" && \
    touch ${METADATABARE64}/gmp_build
[ -f ${METADATABARE64}/gmp_install ] || \
  make install || die "***install 64bit bare gmp error" && \
    touch ${METADATABARE64}/gmp_install
export CFLAGS="-w"
popd

pushd ${SRCBARE64}
cd mpfr-${MPFR_VERSION}
[ -f "${METADATABARE64}/mpfr_configure" ] || \
  ./configure --prefix=${BUILDBARE64}/mpfr --with-gmp=${BUILDBARE64}/gmp \
  --disable-shared --enable-static || \
    die "***config 64bit bare mpfr error" && \
      touch ${METADATABARE64}/mpfr_configure
[ -f "${METADATABARE64}/mpfr_build" ] || \
  make -j${JOBS} || die "***build 64bit bare mpfr error" && \
    touch ${METADATABARE64}/mpfr_build
[ -f "${METADATABARE64}/mpfr_install" ] || \
  make install || die "***install 64bit bare mpfr error" && \
    touch ${METADATABARE64}/mpfr_install
popd

pushd ${SRCBARE64}
cd mpc-${MPC_VERSION}
[ -f "${METADATABARE64}/mpc_configure" ] || \
  ./configure --prefix=${BUILDBARE64}/mpc \
  --with-gmp=${BUILDBARE64}/gmp --with-mpfr=${BUILDBARE64}/mpfr \
  --disable-shared --enable-static || \
    die "***config 64bit bare mpc error" && \
      touch ${METADATABARE64}/mpc_configure
[ -f ${METADATABARE64}/mpc_build ] || \
  make -j${JOBS} || die "***build 64bit bare mpc error" && \
    touch ${METADATABARE64}/mpc_build
[ -f ${METADATABARE64}/mpc_install ] || \
  make install || die "***install 64bit bare mpc error" && \
    touch ${METADATABARE64}/mpc_install
popd

pushd ${BUILDBARE64}
[ -d "binutils-build" ] || mkdir binutils-build
cd binutils-build
[ -f "${METADATABARE64}/binutils_configure" ] || AS="as" AR="ar" \
  ${SRCBARE64}/binutils-${BINUTILS_VERSION}/configure \
  --prefix=${PREFIXBARE64} --target=${CROSS_BARETARGET64} \
  --disable-nls --enable-interwork --disable-shared \
  --enable-threads --with-gcc --with-gnu-as --with-gnu-ld \
  --with-gmp=${BUILDBARE64}/gmp --with-mpfr=${BUILDBARE64}/mpfr \
  --with-mpc=${BUILDBARE64}/mpc || \
    die "***config 64bit bare binutils error" && \
      touch ${METADATABARE64}/binutils_configure
[ -f ${METADATABARE64}/binutils_build ] || \
  make -j${JOBS} all || die "***build 64bit bare binutils error" && \
    touch ${METADATABARE64}/binutils_build
[ -f ${METADATABARE64}/binutils_install ] || \
  make install || die "***install 64bit bare binutils error" && \
    touch ${METADATABARE64}/binutils_install
popd

pushd ${BUILDBARE64}
[ -d "gcc-build-stage1" ] || mkdir gcc-build-stage1
cd gcc-build-stage1
[ -f "${METADATABARE64}/gcc_configure_stage1" ] || \
  AR="ar" AS="as" \
  ${SRCBARE64}/gcc-${GCC_VERSION}/configure \
  --prefix=${PREFIXBARE64} --target=${CROSS_BARETARGET64} \
  --enable-interwork --enable-languages=c \
  --with-newlib --disable-nls --disable-shared --enable-threads \
  --with-gnu-as --with-gnu-ld \
  --without-headers --disable-libquadmath --disable-libssp \
  --with-gmp=${BUILDBARE64}/gmp --with-mpfr=${BUILDBARE64}/mpfr \
  --with-mpc=${BUILDBARE64}/mpc || \
    die "***config 64bit bare gcc stage1 error" && \
      touch ${METADATABARE64}/gcc_configure_stage1
[ -f "${METADATABARE64}/gcc_build_stage1" ] || \
  make -j${JOBS} all || die "***build 64bit bare gcc stage1 error" && \
    touch ${METADATABARE64}/gcc_build_stage1
[ -f "${METADATABARE64}/gcc_install_stage1" ] || \
  make install || die "***install 64bit bare gcc stage1 error" && \
    touch ${METADATABARE64}/gcc_install_stage1
popd

pushd ${BUILDBARE64}
[ -d "newlib-build" ] || mkdir newlib-build
cd newlib-build
[ -f "${METADATABARE64}/newlib_configure" ] || \
  ${SRCBARE64}/newlib-${NEWLIB_VERSION}/configure \
  --prefiPREFIXx=${BARE64} --target=${CROSS_BARETARGET64} \
  --enable-interwork --with-gnu-as --with-gnu-ld \
  --disable-nls || \
    die "***config 64bit newlib error" && \
      touch ${METADATABARE64}/newlib_configure
[ -f "${METADATABARE64}/newlib_build" ] || \
  make -j${JOBS} || die "***build 64bit newlib error" && \
    touch ${METADATABARE64}/newlib_build
[ -f "${METADATABARE64}/newlib_install" ] || \
  make install || die "***install 64bit newlib error"
    touch ${METADATABARE64}/newlib_install
popd

pushd ${BUILDBARE64}
[ -d "gcc-build-stage2" ] || mkdir gcc-build-stage2
cd gcc-build-stage2
[ -f "${METADATABARE64}/gcc_configure_stage2" ] || \
  AR="ar" AS="as" \
  ${SRCBARE64}/gcc-${GCC_VERSION}/configure \
  --prefix=${PREFIXBARE64} --target=${CROSS_BARETARGET64} \
  --enable-interwork --enable-languages=c,c++ \
  --with-newlib --disable-nls --disable-shared --enable-threads \
  --with-gnu-as --with-gnu-ld \
  --with-gmp=${BUILDBARE64}/gmp --with-mpfr=${BUILDBARE64}/mpfr \
  --with-mpc=${BUILDBARE64}/mpc || \
    die "***config 64bit bare gcc stage2 error" && \
      touch ${METADATABARE64}/gcc_configure_stage2
[ -f "${METADATABARE64}/gcc_build_stage2" ] || \
  make -j${JOBS} all || die "***build 64bit bare gcc stage2 error" && \
      touch ${METADATABARE64}/gcc_build_stage2
[ -f "${METADATABARE64}/gcc_install_stage2" ] || \
  make install || die "***install 64bit bare gcc stage2 error" && \
      touch ${METADATABARE64}/gcc_install_stage2
popd

pushd ${BUILDBARE64}
[ -d "gdb-build" ] || mkdir gdb-build
cd gdb-build
[ -f "${METADATABARE64}/gdb_configure" ] || \
  ${SRCBARE64}/gdb-${GDB_VERSION}/configure \
  --prefix=${PREFIXBARE64} --target=${CROSS_BARETARGET64} \
  --with-gmp=${BUILDBARE64}/gmp --with-mpfr=${BUILDBARE64}/mpfr \
  --with-mpc=${BUILDBARE64}/mpc || \
    die "***config 64bit bare gdb error" && \
      touch ${METADATABARE64}/gdb_configure
[ -f "${METADATABARE64}/gdb_build" ] || \
  make -j${JOBS} || die "***build 64bit bare gdb error" && \
    touch ${METADATABARE64}/gdb_build
[ -f "${METADATABARE64}/gdb_install" ] || \
  make install || die "***install 64bit bare gdb error" && \
    touch ${METADATABARE64}/gdb_install
popd
