#! /bin/bash

source source.sh

[ -d "${SRCGNU32}" ] || mkdir -p "${SRCGNU32}"
[ -d "${BUILDGNU32}" ] || mkdir -p "${BUILDGNU32}"
[ -d "${METADATAGNU32}" ] || mkdir -p "${METADATAGNU32}"

export PATH=${PATH}:${PREFIXGNU32}/bin

#################################################################
### 32bit gnu extract
#################################################################
pushd ${SRCGNU32}
[ -f ${METADATAGNU32}/linux_extract ] || \
tar xf ${TARBALL}/linux-${LINUX_VERSION}.${LINUX_SUFFIX} || \
  die "extract linux error" && \
    touch ${METADATAGNU32}/linux_extract

[ -f ${METADATAGNU32}/gmp_extract ] || \
tar xf ${TARBALL}/gmp-${GMP_VERSION}.${GMP_SUFFIX} || \
  die "extract gmp error" && \
    touch ${METADATAGNU32}/gmp_extract

[ -f ${METADATAGNU32}/mpfr_extract ] || \
tar xf ${TARBALL}/mpfr-${MPFR_VERSION}.${MPFR_SUFFIX} || \
  die "extract mpfr error" && \
    touch ${METADATAGNU32}/mpfr_extract

[ -f ${METADATAGNU32}/mpc_extract ] || \
tar xf ${TARBALL}/mpc-${MPC_VERSION}.${MPC_SUFFIX} || \
  die "extract mpc error" && \
    touch ${METADATAGNU32}/mpc_extract

[ -f ${METADATAGNU32}/ppl_extract ] || \
tar xf ${TARBALL}/ppl-${PPL_VERSION}.${PPL_SUFFIX} || \
  die "extract ppl error" && \
    touch ${METADATAGNU32}/ppl_extract

[ -f ${METADATAGNU32}/cloog_extract ] || \
tar xf ${TARBALL}/cloog-${CLOOG_VERSION}.${CLOOG_SUFFIX} || \
  die "extract cloog error" && \
    touch ${METADATAGNU32}/cloog_extract

[ -f ${METADATAGNU32}/binutils_extract ] || \
tar xf ${TARBALL}/binutils-${BINUTILS_VERSION}.${BINUTILS_SUFFIX} || \
  die "extract binutils error" && \
    touch ${METADATAGNU32}/binutils_extract

[ -f ${METADATAGNU32}/gcc_extract ] || \
tar xf ${TARBALL}/gcc-${GCC_VERSION}.${GCC_SUFFIX} || \
  die "extract gcc error" && \
    touch ${METADATAGNU32}/gcc_extract

[ -f ${METADATAGNU32}/eglibc_extract ] || \
tar xf ${TARBALL}/eglibc-${EGLIBC_VERSION}-r21467.${EGLIBC_SUFFIX} || \
  die "extract eglibc error" && \
    touch ${METADATAGNU32}/eglibc_extract

pushd ${SRCGNU32}/eglibc-${EGLIBC_VERSION}
[ -f ${METADATAGNU32}/eglibc_ports_extract ] || \
tar xf ${TARBALL}/eglibc-ports-${EGLIBCPORTS_VERSION}-r21467.${EGLIBCPORTS_SUFFIX} || \
  die "extract eglibc ports error" && \
    touch ${METADATAGNU32}/eglibc_ports_extract
popd

[ -f ${METADATAGNU32}/gdb_extract ] || \
tar xf ${TARBALL}/gdb-${GDB_VERSION}.${GDB_SUFFIX} || \
  die "extract gdb error" && \
    touch ${METADATAGNU32}/gdb_extract
popd

#################################################################
### 32bit gnu build
#################################################################
pushd ${SRCGNU32}
cd linux-${LINUX_VERSION}
make distclean
[ -f ${METADATAGNU32}/linux_headers_install ] || make mrproper
[ -f ${METADATAGNU32}/linux_headers_install ] || \
  make ARCH=mips headers_check || die "***check headers error 32bit"
[ -f ${METADATAGNU32}/linux_headers_install ] || \
  make ARCH=mips INSTALL_HDR_PATH=${SYSROOTGNU32}/usr headers_install || \
    die "***install headers error 32bit" && \
      touch ${METADATAGNU32}/linux_headers_install
make distclean
popd

pushd ${SRCGNU32}
unset CFLAGS
[ -d "gmp-${GMP_VERSION}" ] \
  || tar xf ${TARBALL}/gmp-${GMP_VERSION}.${GMP_SUFFIX}
cd gmp-${GMP_VERSION}
[ -f ${METADATAGNU32}/gmp_configure ] || \
CPPFLAGS=-fexceptions ./configure \
  --prefix=${PREFIXGNU32} --enable-cxx || die "***config gmp error 32bit" && \
    touch ${METADATAGNU32}/gmp_configure
[ -f ${METADATAGNU32}/gmp_build ] || \
make -j${JOBS} || die "***build gmp error 32bit" && \
  touch ${METADATAGNU32}/gmp_build
[ -f ${METADATAGNU32}/gmp_install ] || \
make install || die "***install gmp error 32bit" && \
touch ${METADATAGNU32}/gmp_install
export CFLAGS="-w"
popd

pushd ${SRCGNU32}
[ -d "mpfr-${MPFR_VERSION}" ] \
  || tar xf ${TARBALL}/mpfr-${MPFR_VERSION}.${MPFR_SUFFIX}
cd mpfr-${MPFR_VERSION}
[ -f ${METADATAGNU32}/mpfr_configure ] || \
LDFLAGS="-Wl,-rpath,${PREFIXGNU32}/lib" \
./configure --prefix=${PREFIXGNU32} \
    --enable-shared --with-gmp=${PREFIXGNU32} || \
      die "***config mpfr error 32bit" && \
        touch ${METADATAGNU32}/mpfr_configure
[ -f ${METADATAGNU32}/mpfr_build ] || \
make -j${JOBS} || die "***build mpfr error 32bit" && \
  touch ${METADATAGNU32}/mpfr_build
[ -f ${METADATAGNU32}/mpfr_install ] || \
make install || die "***install mpfr error 32bit" && \
  touch ${METADATAGNU32}/mpfr_install
popd

pushd ${SRCGNU32}
[ -d "mpc-${MPC_VERSION}" ] \
  || tar xf ${TARBALL}/mpc-${MPC_VERSION}.${MPC_SUFFIX}
cd mpc-${MPC_VERSION}
[ -f ${METADATAGNU32}/mpc_configure ] || \
LDFLAGS="-Wl,-rpath,${PREFIXGNU32}/lib" \
./configure --prefix=${PREFIXGNU32} \
  --with-gmp=${PREFIXGNU32} \
  --with-mpfr=${PREFIXGNU32} || die "***config mpc error 32bit" && \
     touch ${METADATAGNU32}/mpc_configure
[ -f ${METADATAGNU32}/mpc_build ] || \
make -j${JOBS} || die "***config mpc error 32bit" && \
  touch ${METADATAGNU32}/mpc_build
[ -f ${METADATAGNU32}/mpc_install ] || \
make install || die "***install mpc error 32bit" && \
  touch ${METADATAGNU32}/mpc_install
popd

pushd ${SRCGNU32}
[ -d "ppl-${PPL_VERSION}" ] \
  || tar xf ${TARBALL}/ppl-${PPL_VERSION}.${PPL_SUFFIX}
cd ppl-${PPL_VERSION}
[ -f ${METADATAGNU32}/ppl_configure ] || \
CPPFLAGS="-I${PREFIXGNU32}/include" \
  LDFLAGS="-Wl,-rpath,${PREFIXGNU32}/lib" \
  ./configure --prefix=${PREFIXGNU32} --enable-shared \
  --enable-interfaces="c,cxx" --disable-optimization \
  --with-libgmp-prefix=${PREFIXGNU32} \
  --with-libgmpxx-prefix=${PREFIXGNU32} || die "***config ppl error 32bit" && \
    touch ${METADATAGNU32}/ppl_configure
[ -f ${METADATAGNU32}/ppl_build ] || \
make -j${JOBS} || die "***build ppl error 32bit" && \
  touch ${METADATAGNU32}/ppl_build
[ -f ${METADATAGNU32}/ppl_install ] || \
make install || die "***install ppl error 32bit" && \
  touch ${METADATAGNU32}/ppl_install
popd

pushd ${SRCGNU32}
[ -d "cloog-${CLOOG_VERSION}" ] \
  || tar xf ${TARBALL}/cloog-${CLOOG_VERSION}.${CLOOG_SUFFIX}
cd cloog-${CLOOG_VERSION}
cp -v configure{,.orig}
sed -e "/LD_LIBRARY_PATH=/d" \
  configure.orig > configure
[ -f ${METADATAGNU32}/cloog_configure ] || \
LDFLAGS="-Wl,-rpath,${PREFIXGNU32}/lib" \
  ./configure --prefix=${PREFIXGNU32} --enable-shared \
  --with-gmp-prefix=${PREFIXGNU32} || die "***config cloog error 32bit" && \
    touch ${METADATAGNU32}/cloog_configure
[ -f ${METADATAGNU32}/cloog_build ] || \
make -j${JOBS} || die "***build cloog error 32bit" && \
    touch ${METADATAGNU32}/cloog_build
[ -f ${METADATAGNU32}/cloog_install ] || \
  make install || die "***install cloog error 32bit" && \
    touch ${METADATAGNU32}/cloog_install
popd

pushd ${BUILDGNU32}
[ -d "binutils-build" ] || mkdir binutils-build
cd binutils-build
[ -f "${METADATAGNU32}/binutils_configure" ] || AS="as" AR="ar" \
  ${SRCGNU32}/binutils-${BINUTILS_VERSION}/configure \
  --prefix=${PREFIXGNU32} --host=${CROSS_HOST} --target=${CROSS_TARGET32} \
  --with-sysroot=${SYSROOTGNU32} --with-lib-path=${SYSROOTGNU32}/usr/lib \
  --disable-nls --enable-shared \
  --enable-cloog-backend=isl --enable-poison-system-directories \
  --with-gmp=${PREFIXGNU32} --with-mpfr=${PREFIXGNU32} \
  --with-ppl=${PREFIXGNU32} --with-cloog=${PREFIXGNU32} \
  --with-build-sysroot=${SYSROOTGNU32} || \
    die "***config 32bit binutils error" && \
      touch ${METADATAGNU32}/binutils_configure
[ -f ${METADATAGNU32}/binutils_build ] || \
  make configure-host || die "config 32bit binutils host error"
[ -f ${METADATAGNU32}/binutils_build ] || \
  make -j${JOBS} || die "***build 32bit binutils error" && \
    touch ${METADATAGNU32}/binutils_build
[ -f ${METADATAGNU32}/binutils_install ] || \
  make install || die "***install 32bit binutils error" && \
    touch ${METADATAGNU32}/binutils_install
popd

pushd ${BUILDGNU32}
[ -d "gcc-build-stage1" ] || mkdir gcc-build-stage1
cd gcc-build-stage1
[ -f "${METADATAGNU32}/gcc_stage1_configure" ] || \
  AR=ar LDFLAGS="-Wl,-rpath,${PREFIXGNU32}/lib" \
  ${SRCGNU32}/gcc-${GCC_VERSION}/configure \
  --prefix=${PREFIXGNU32} --build=${CROSS_HOST} --host=${CROSS_HOST} \
  --target=${CROSS_TARGET32} --with-sysroot=${SYSROOTGNU32} \
  --with-local-prefix=${SYSROOTGNU32}/usr --disable-nls \
  --disable-shared \
  --without-headers --with-newlib --disable-decimal-float \
  --disable-libgomp --disable-libmudflap --disable-libssp \
  --disable-threads --enable-languages=c \
  --enable-cloog-backend=isl \
  --with-gmp=${PREFIXGNU32} --with-mpfr=${PREFIXGNU32} \
  --with-ppl=${PREFIXGNU32} --with-cloog=${PREFIXGNU32} \
  --enable-poison-system-directories --with-build-sysroot=${SYSROOTGNU32} || \
    die "***config 32bit gcc stage1 error" && \
      touch ${METADATAGNU32}/gcc_stage1_configure
[ -f "${METADATAGNU32}/gcc_stage1_build" ] || \
  make -j${JOBS} all-gcc all-target-libgcc || \
    die "***build 32bit gcc stage1 error" && \
      touch ${METADATAGNU32}/gcc_stage1_build
[ -f "${METADATAGNU32}/gcc_stage1_install" ] || \
  make install-gcc install-target-libgcc || \
    die "***install 32bit gcc stage1 error" && \
      touch ${METADATAGNU32}/gcc_stage1_install
popd

pushd ${SRCGNU32}
cd eglibc-${EGLIBC_VERSION}
cp -v Makeconfig{,.orig}
sed -e 's/-lgcc_eh//g' Makeconfig.orig > Makeconfig
popd

pushd ${BUILDGNU32}
[ -d "eglibc-build-o32" ] || mkdir eglibc-build-o32
cd eglibc-build-o32
cat > config.cache << "EOF"
libc_cv_forced_unwind=yes
libc_cv_c_cleanup=yes
libc_cv_gnu89_inline=yes
libc_cv_ssp=no
EOF
cat > configparms << EOF
install_root=${SYSROOTGNU32}
EOF
[ -f "${METADATAGNU32}/eglibc_configure_32" ] || \
  BUILD_CC="gcc" CC="${CROSS_TARGET32}-gcc" \
  AR="${CROSS_TARGET32}-ar" RANLIB="${CROSS_TARGET32}-ranlib" \
  CFLAGS_FOR_TARGET="-O2" CFLAGS="-O2" \
  ${SRCGNU32}/eglibc-${EGLIBC_VERSION}/configure \
  --prefix=/usr --host=${CROSS_TARGET32} --build=${CROSS_HOST} \
  --disable-profile --enable-add-ons \
  --with-tls --enable-kernel=2.6.0 --with-__thread \
  --with-binutils=${PREFIXGNU32}/bin --with-headers=${SYSROOTGNU32}/usr/include \
  --cache-file=config.cache || \
    die "***config 32bit eglibc error" && \
      touch ${METADATAGNU32}/eglibc_configure_32
[ -f "${METADATAGNU32}/eglibc_build_32" ] || \
  make -j${JOBS} || die "***build 32bit eglibc error" && \
    touch ${METADATAGNU32}/eglibc_build_32
[ -f "${METADATAGNU32}/eglibc_install_32" ] || \
  make install inst_vardbdir=${SYSROOTGNU32}/var/db || \
    die "***install 32bit eglibc error" && \
      touch ${METADATAGNU32}/eglibc_install_32
popd

pushd ${BUILDGNU32}
[ -d "gcc-build-stage2" ] || mkdir gcc-build-stage2
cd gcc-build-stage2
[ -f "${METADATAGNU32}/gcc_stage2_configure" ] || \
  AR=ar LDFLAGS="-Wl,-rpath,${PREFIXGNU32}/lib" \
  ${SRCGNU32}/gcc-${GCC_VERSION}/configure \
  --prefix=${PREFIXGNU32} --build=${CROSS_HOST} --target=${CROSS_TARGET32} \
  --host=${CROSS_HOST} --with-sysroot=${SYSROOTGNU32} \
  --with-local-prefix=/${SYSROOTGNU32}/usr \
  --disable-nls \
  --enable-shared --enable-languages=c,c++ --enable-__cxa_atexit \
  --enable-c99 \
  --enable-long-long --enable-threads=posix \
  --enable-cloog-backend=isl \
  --with-gmp=${PREFIXGNU32} --with-mpfr=${PREFIXGNU32} \
  --with-ppl=${PREFIXGNU32} --with-cloog=${PREFIXGNU32} \
  --enable-poison-system-directories --with-build-sysroot=${SYSROOTGNU32} || \
    die "***config 32bit gcc stage2 error" && \
      touch ${METADATAGNU32}/gcc_stage2_configure
[ -f "${METADATAGNU32}/gcc_stage2_build" ] || \
  make -j${JOBS} \
    AS_FOR_TARGET="${CROSS_TARGET32}-as" \
    LD_FOR_TARGET="${CROSS_TARGET32}-ld" \
      || die "***build 32bit gcc stage2 error" && \
        touch ${METADATAGNU32}/gcc_stage2_build
[ -f "${METADATAGNU32}/gcc_stage2_install" ] || \
  make install || die "***install 32bit gcc stage2 error" && \
    touch ${METADATAGNU32}/gcc_stage2_install
popd

pushd ${BUILDGNU32}
[ -d "gdb-build" ] || mkdir gdb-build
cd gdb-build
[ -f "${METADATAGNU32}/gdb_configure" ] || \
  ${SRCGNU32}/gdb-${GDB_VERSION}/configure \
  --prefix=${PREFIXGNU32} --target=${CROSS_TARGET32} \
  --with-sysroot=${SYSROOTGNU32} --with-lib-path=${SYSROOTGNU32}/usr/lib \
  --enable-poison-system-directories --with-build-sysroot=${SYSROOTGNU32} || \
    die "***config 32bit gdb error" && \
      touch ${METADATAGNU32}/gdb_configure
[ -f "${METADATAGNU32}/gdb_build" ] || \
  make -j${JOBS} || die "***build 32bit gdb error" && \
    touch ${METADATAGNU32}/gdb_build
[ -f "${METADATAGNU32}/gdb_install" ] || \
  make install || die "***install 32bit gdb error" && \
    touch ${METADATAGNU32}/gdb_install
popd
