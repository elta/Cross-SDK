#! /bin/bash

source source.sh

[ -d "${SRCGNU64}" ] || mkdir -p "${SRCGNU64}"
[ -d "${BUILDGNU64}" ] || mkdir -p "${BUILDGNU64}"
[ -d "${METADATAGNU64}" ] || mkdir -p "${METADATAGNU64}"

export PATH=${PATH}:${PREFIXGNU64}/bin

#################################################################
### 64bit gnu extract
#################################################################
pushd ${SRCGNU64}
[ -f ${METADATAGNU64}/linux_extract ] || \
tar xf ${TARBALL}/linux-${LINUX_VERSION}.${LINUX_SUFFIX} || \
  die "extract linux error" && \
    touch ${METADATAGNU64}/linux_extract

[ -f ${METADATAGNU64}/gmp_extract ] || \
tar xf ${TARBALL}/gmp-${GMP_VERSION}.${GMP_SUFFIX} || \
  die "extract gmp error" && \
    touch ${METADATAGNU64}/gmp_extract

[ -f ${METADATAGNU64}/mpfr_extract ] || \
tar xf ${TARBALL}/mpfr-${MPFR_VERSION}.${MPFR_SUFFIX} || \
  die "extract mpfr error" && \
    touch ${METADATAGNU64}/mpfr_extract

[ -f ${METADATAGNU64}/mpc_extract ] || \
tar xf ${TARBALL}/mpc-${MPC_VERSION}.${MPC_SUFFIX} || \
  die "extract mpc error" && \
    touch ${METADATAGNU64}/mpc_extract

[ -f ${METADATAGNU64}/ppl_extract ] || \
tar xf ${TARBALL}/ppl-${PPL_VERSION}.${PPL_SUFFIX} || \
  die "extract ppl error" && \
    touch ${METADATAGNU64}/ppl_extract

[ -f ${METADATAGNU64}/cloog_extract ] || \
tar xf ${TARBALL}/cloog-${CLOOG_VERSION}.${CLOOG_SUFFIX} || \
  die "extract cloog error" && \
    touch ${METADATAGNU64}/cloog_extract

[ -f ${METADATAGNU64}/binutils_extract ] || \
tar xf ${TARBALL}/binutils-${BINUTILS_VERSION}.${BINUTILS_SUFFIX} || \
  die "extract binutils error" && \
    touch ${METADATAGNU64}/binutils_extract

[ -f ${METADATAGNU64}/gcc_extract ] || \
tar xf ${TARBALL}/gcc-${GCC_VERSION}.${GCC_SUFFIX} || \
  die "extract gcc error" && \
    touch ${METADATAGNU64}/gcc_extract

[ -f ${METADATAGNU64}/glibc_extract ] || \
tar xf ${TARBALL}/glibc-${GLIBC_VERSION}.${GLIBC_SUFFIX} || \
  die "extract glibc error" && \
    touch ${METADATAGNU64}/glibc_extract

[ -f ${METADATAGNU64}/gdb_extract ] || \
tar xf ${TARBALL}/gdb-${GDB_VERSION}.${GDB_SUFFIX} || \
  die "extract gdb error" && \
    touch ${METADATAGNU64}/gdb_extract
popd

#################################################################
### 64bit gnu build
#################################################################
pushd ${SRCGNU64}
cd linux-${LINUX_VERSION}
make distclean
[ -f ${METADATAGNU64}/linux_headers_install ] || make mrproper
[ -f ${METADATAGNU64}/linux_headers_install ] || \
  make ARCH=mips headers_check || die "***check headers error 64bit"
[ -f ${METADATAGNU64}/linux_headers_install ] || \
  make ARCH=mips INSTALL_HDR_PATH=${SYSROOTGNU64}/usr headers_install || \
    die "***install headers error 64bit" && \
      touch ${METADATAGNU64}/linux_headers_install
make distclean
popd

pushd ${SRCGNU64}
unset CFLAGS
[ -d "gmp-${GMP_VERSION}" ] \
  || tar xf ${TARBALL}/gmp-${GMP_VERSION}.${GMP_SUFFIX}
cd gmp-${GMP_VERSION}
[ -f ${METADATAGNU64}/gmp_configure ] || \
CPPFLAGS=-fexceptions ./configure \
  --prefix=${PREFIXGNU64} --enable-cxx || die "***config gmp error 64bit" && \
    touch ${METADATAGNU64}/gmp_configure
[ -f ${METADATAGNU64}/gmp_build ] || \
make -j${JOBS} || die "***build gmp error 64bit" && \
  touch ${METADATAGNU64}/gmp_build
[ -f ${METADATAGNU64}/gmp_install ] || \
make install || die "***install gmp error 64bit" && \
touch ${METADATAGNU64}/gmp_install
export CFLAGS="-w"
popd

pushd ${SRCGNU64}
[ -d "mpfr-${MPFR_VERSION}" ] \
  || tar xf ${TARBALL}/mpfr-${MPFR_VERSION}.${MPFR_SUFFIX}
cd mpfr-${MPFR_VERSION}
[ -f ${METADATAGNU64}/mpfr_configure ] || \
LDFLAGS="-Wl,-rpath,${PREFIXGNU64}/lib" \
./configure --prefix=${PREFIXGNU64} \
    --enable-shared --with-gmp=${PREFIXGNU64} || \
      die "***config mpfr error 64bit" && \
        touch ${METADATAGNU64}/mpfr_configure
[ -f ${METADATAGNU64}/mpfr_build ] || \
make -j${JOBS} || die "***build mpfr error 64bit" && \
  touch ${METADATAGNU64}/mpfr_build
[ -f ${METADATAGNU64}/mpfr_install ] || \
make install || die "***install mpfr error 64bit" && \
  touch ${METADATAGNU64}/mpfr_install
popd

pushd ${SRCGNU64}
[ -d "mpc-${MPC_VERSION}" ] \
  || tar xf ${TARBALL}/mpc-${MPC_VERSION}.${MPC_SUFFIX}
cd mpc-${MPC_VERSION}
[ -f ${METADATAGNU64}/mpc_configure ] || \
LDFLAGS="-Wl,-rpath,${PREFIXGNU64}/lib" \
./configure --prefix=${PREFIXGNU64} \
  --with-gmp=${PREFIXGNU64} \
  --with-mpfr=${PREFIXGNU64} || die "***config mpc error 64bit" && \
     touch ${METADATAGNU64}/mpc_configure
[ -f ${METADATAGNU64}/mpc_build ] || \
make -j${JOBS} || die "***config mpc error 64bit" && \
  touch ${METADATAGNU64}/mpc_build
[ -f ${METADATAGNU64}/mpc_install ] || \
make install || die "***install mpc error 64bit" && \
  touch ${METADATAGNU64}/mpc_install
popd

pushd ${SRCGNU64}
[ -d "ppl-${PPL_VERSION}" ] \
  || tar xf ${TARBALL}/ppl-${PPL_VERSION}.${PPL_SUFFIX}
cd ppl-${PPL_VERSION}
[ -f ${METADATAGNU64}/ppl_configure ] || \
  CPPFLAGS="-I${PREFIXGNU64}/include" \
  LDFLAGS="-Wl,-rpath,${PREFIXGNU64}/lib" \
  ./configure --prefix=${PREFIXGNU64} --enable-shared \
  --enable-interfaces="c,cxx" --disable-optimization \
  --with-gmp=${PREFIXGNU64} || \
  die "***config ppl error 64bit" && \
    touch ${METADATAGNU64}/ppl_configure
[ -f ${METADATAGNU64}/ppl_build ] || \
make -j${JOBS} || die "***build ppl error 64bit" && \
  touch ${METADATAGNU64}/ppl_build
[ -f ${METADATAGNU64}/ppl_install ] || \
make install || die "***install ppl error 64bit" && \
  touch ${METADATAGNU64}/ppl_install
popd

pushd ${SRCGNU64}
[ -d "cloog-${CLOOG_VERSION}" ] \
  || tar xf ${TARBALL}/cloog-${CLOOG_VERSION}.${CLOOG_SUFFIX}
cd cloog-${CLOOG_VERSION}
cp -v configure{,.orig}
sed -e "/LD_LIBRARY_PATH=/d" \
  configure.orig > configure
[ -f ${METADATAGNU64}/cloog_configure ] || \
LDFLAGS="-Wl,-rpath,${PREFIXGNU64}/lib" \
  ./configure --prefix=${PREFIXGNU64} --enable-shared \
  --with-gmp-prefix=${PREFIXGNU64} || die "***config cloog error 64bit" && \
    touch ${METADATAGNU64}/cloog_configure
[ -f ${METADATAGNU64}/cloog_build ] || \
make -j${JOBS} || die "***build cloog error 64bit" && \
    touch ${METADATAGNU64}/cloog_build
[ -f ${METADATAGNU64}/cloog_install ] || \
  make install || die "***install cloog error 64bit" && \
    touch ${METADATAGNU64}/cloog_install
popd

pushd ${BUILDGNU64}
[ -d "binutils-build" ] || mkdir binutils-build
cd binutils-build
[ -f "${METADATAGNU64}/binutils_configure" ] || AS="as" AR="ar" \
  ${SRCGNU64}/binutils-${BINUTILS_VERSION}/configure \
  --prefix=${PREFIXGNU64} --host=${CROSS_HOST} --target=${CROSS_TARGET64} \
  --with-sysroot=${SYSROOTGNU64} --with-lib-path=${SYSROOTGNU64}/usr/lib \
  --disable-nls --enable-shared --enable-64-bit-bfd \
  --enable-cloog-backend=isl --enable-poison-system-directories \
  --with-gmp=${PREFIXGNU64} --with-mpfr=${PREFIXGNU64} \
  --with-ppl=${PREFIXGNU64} --with-cloog=${PREFIXGNU64} \
  --with-build-sysroot=${SYSROOTGNU64} || \
    die "***config 64bit binutils error" && \
      touch ${METADATAGNU64}/binutils_configure
[ -f ${METADATAGNU64}/binutils_build ] || \
  make configure-host || die "config 64bit binutils host error"
[ -f ${METADATAGNU64}/binutils_build ] || \
  make -j${JOBS} || die "***build 64bit binutils error" && \
    touch ${METADATAGNU64}/binutils_build
[ -f ${METADATAGNU64}/binutils_install ] || \
  make install || die "***install 64bit binutils error" && \
    touch ${METADATAGNU64}/binutils_install
popd

pushd ${BUILDGNU64}
[ -d "gcc-build-stage1" ] || mkdir gcc-build-stage1
cd gcc-build-stage1
[ -f "${METADATAGNU64}/gcc_stage1_configure" ] || \
  AR=ar LDFLAGS="-Wl,-rpath,${PREFIXGNU64}/lib" \
  ${SRCGNU64}/gcc-${GCC_VERSION}/configure \
  --prefix=${PREFIXGNU64} --build=${CROSS_HOST} --host=${CROSS_HOST} \
  --target=${CROSS_TARGET64} --with-sysroot=${SYSROOTGNU64} \
  --with-local-prefix=${SYSROOTGNU64}/usr --disable-nls \
  --disable-shared \
  --without-headers --with-newlib --disable-decimal-float \
  --disable-libgomp --disable-libmudflap --disable-libssp \
  --disable-threads --enable-languages=c \
  --enable-cloog-backend=isl \
  --with-gmp=${PREFIXGNU64} --with-mpfr=${PREFIXGNU64} \
  --with-ppl=${PREFIXGNU64} --with-cloog=${PREFIXGNU64} \
  --enable-poison-system-directories --with-build-sysroot=${SYSROOTGNU64} || \
    die "***config 64bit gcc stage1 error" && \
      touch ${METADATAGNU64}/gcc_stage1_configure
[ -f "${METADATAGNU64}/gcc_stage1_build" ] || \
  make -j${JOBS} all-gcc all-target-libgcc || \
    die "***build 64bit gcc stage1 error" && \
      touch ${METADATAGNU64}/gcc_stage1_build
[ -f "${METADATAGNU64}/gcc_stage1_install" ] || \
  make install-gcc install-target-libgcc || \
    die "***install 64bit gcc stage1 error" && \
      touch ${METADATAGNU64}/gcc_stage1_install
popd

#################################################################
### 64bit gnu patch
#################################################################
pushd ${SRCGNU64}
cd glibc-${GLIBC_VERSION}
cp -v Makeconfig{,.orig}
sed -e 's/-lgcc_eh//g' Makeconfig.orig > Makeconfig
popd

pushd ${SRCGNU64}
if [ $(uname) = "Darwin" ]; then
cd glibc-${GLIBC_VERSION}
[ -f "${METADATAGNU64}/glibc_macos_patch" ] || \
  patch -p1 < ${PATCH}/glibc-2.17-os-x-build.patch || \
    die "***patch glibc for macosx error" && \
      touch ${METADATAGNU64}/glibc_macos_patch
fi
popd

pushd ${BUILDGNU64}
[ -d "glibc-build-o32" ] || mkdir glibc-build-o32
cd glibc-build-o32
cat > config.cache << "EOF"
libc_cv_forced_unwind=yes
libc_cv_c_cleanup=yes
libc_cv_gnu89_inline=yes
libc_cv_ssp=no
READELF=${CROSS_TARGET64}-readelf
NM=${CROSS_TARGET64}-nm
EOF
cat > configparms << EOF
install_root=${SYSROOTGNU64}
EOF
[ -f "${METADATAGNU64}/glibc_configure_32" ] || \
  BUILD_CC="gcc" CC="${CROSS_TARGET64}-gcc ${BUILD32}" \
  AR="${CROSS_TARGET64}-ar" RANLIB="${CROSS_TARGET64}-ranlib" \
  CFLAGS_FOR_TARGET="-O2" CFLAGS="-O2" \
  ${SRCGNU64}/glibc-${GLIBC_VERSION}/configure \
  --prefix=/usr --host=${CROSS_TARGET32} --build=${CROSS_HOST} \
  --disable-profile --enable-add-ons \
  --with-tls --enable-kernel=2.6.0 --with-__thread \
  --with-binutils=${PREFIXGNU64}/bin --with-headers=${SYSROOTGNU64}/usr/include \
  --cache-file=config.cache || \
    die "***config o32 glibc error" && \
      touch ${METADATAGNU64}/glibc_configure_32
[ -f "${METADATAGNU64}/glibc_build_32" ] || \
  make -j${JOBS} || die "***build o32 glibc error" && \
    touch ${METADATAGNU64}/glibc_build_32
[ -f "${METADATAGNU64}/glibc_install_32" ] || \
  make install inst_vardbdir=${SYSROOTGNU64}/var/db || \
    die "***install o32 glibc error" && \
      touch ${METADATAGNU64}/glibc_install_32
popd

pushd ${BUILDGNU64}
[ -d "glibc-build-n32" ] || mkdir glibc-build-n32
cd glibc-build-n32
cat > config.cache << "EOF"
libc_cv_forced_unwind=yes
libc_cv_c_cleanup=yes
libc_cv_gnu89_inline=yes
libc_cv_ssp=no
READELF=${CROSS_TARGET64}-readelf
NM=${CROSS_TARGET64}-nm
EOF
cat > configparms << EOF
install_root=${SYSROOTGNU64}
slibdir=/lib32
EOF
[ -f "${METADATAGNU64}/glibc_configure_n32" ] || \
  BUILD_CC="gcc" CC="${CROSS_TARGET64}-gcc ${BUILDN32}" \
  AR="${CROSS_TARGET64}-ar" RANLIB="${CROSS_TARGET64}-ranlib" \
  CFLAGS_FOR_TARGET="-O2" CFLAGS="-O2" \
  ${SRCGNU64}/glibc-${GLIBC_VERSION}/configure \
  --prefix=/usr --host=${CROSS_TARGET64} --build=${CROSS_HOST} \
  --libdir=/usr/lib32 \
  --disable-profile --enable-add-ons \
  --with-tls --enable-kernel=2.6.0 --with-__thread \
  --with-binutils=${PREFIXGNU64}/bin --with-headers=${SYSROOTGNU64}/usr/include \
  --cache-file=config.cache || \
    die "***config n32 glibc error" && \
      touch ${METADATAGNU64}/glibc_configure_n32
[ -f "${METADATAGNU64}/glibc_build_n32" ] || \
  make -j${JOBS} || die "***build n32 glibc error" && \
    touch ${METADATAGNU64}/glibc_build_n32
[ -f "${METADATAGNU64}/glibc_install_n32" ] || \
  make install inst_vardbdir=${SYSROOTGNU64}/var/db || \
    die "***install n32 glibc error" && \
      touch ${METADATAGNU64}/glibc_install_n32
popd

pushd ${BUILDGNU64}
[ -d "glibc-build-n64" ] || mkdir glibc-build-n64
cd glibc-build-n64
cat > config.cache << "EOF"
libc_cv_forced_unwind=yes
libc_cv_c_cleanup=yes
libc_cv_gnu89_inline=yes
libc_cv_ssp=no
READELF=${CROSS_TARGET64}-readelf
NM=${CROSS_TARGET64}-nm
EOF
cat > configparms << EOF
install_root=${SYSROOTGNU64}
slibdir=/lib64
EOF
[ -f "${METADATAGNU64}/glibc_configure_64" ] || \
  BUILD_CC="gcc" CC="${CROSS_TARGET64}-gcc ${BUILD64}" \
  AR="${CROSS_TARGET64}-ar" RANLIB="${CROSS_TARGET64}-ranlib" \
  CFLAGS_FOR_TARGET="-O2" CFLAGS="-O2" \
  ${SRCGNU64}/glibc-${GLIBC_VERSION}/configure \
  --prefix=/usr --host=${CROSS_TARGET64} --build=${CROSS_HOST} \
  --libdir=/usr/lib64 \
  --disable-profile --enable-add-ons \
  --with-tls --enable-kernel=2.6.0 --with-__thread \
  --with-binutils=${PREFIXGNU64}/bin --with-headers=${SYSROOTGNU64}/usr/include \
  --cache-file=config.cache || \
    die "***config 64bit glibc error" && \
      touch ${METADATAGNU64}/glibc_configure_64
[ -f "${METADATAGNU64}/glibc_build_64" ] || \
  make -j${JOBS} || die "***build 64bit glibc error" && \
    touch ${METADATAGNU64}/glibc_build_64
[ -f "${METADATAGNU64}/glibc_install_64" ] || \
  make install inst_vardbdir=${SYSROOTGNU64}/var/db || \
    die "***install 64bit glibc error" && \
      touch ${METADATAGNU64}/glibc_install_64
popd

pushd ${BUILDGNU64}
[ -d "gcc-build-stage2" ] || mkdir gcc-build-stage2
cd gcc-build-stage2
[ -f "${METADATAGNU64}/gcc_stage2_configure" ] || \
  AR=ar LDFLAGS="-Wl,-rpath,${PREFIXGNU64}/lib" \
  ${SRCGNU64}/gcc-${GCC_VERSION}/configure \
  --prefix=${PREFIXGNU64} --build=${CROSS_HOST} --target=${CROSS_TARGET64} \
  --host=${CROSS_HOST} --with-sysroot=${SYSROOTGNU64} \
  --with-local-prefix=/${SYSROOTGNU64}/usr \
  --disable-nls \
  --enable-shared --enable-languages=c,c++ --enable-__cxa_atexit \
  --enable-c99 \
  --enable-long-long --enable-threads=posix \
  --enable-cloog-backend=isl \
  --with-gmp=${PREFIXGNU64} --with-mpfr=${PREFIXGNU64} \
  --with-ppl=${PREFIXGNU64} --with-cloog=${PREFIXGNU64} \
  --enable-poison-system-directories --with-build-sysroot=${SYSROOTGNU64} || \
    die "***config 64bit gcc stage2 error" && \
      touch ${METADATAGNU64}/gcc_stage2_configure
[ -f "${METADATAGNU64}/gcc_stage2_build" ] || \
  make -j${JOBS} \
    AS_FOR_TARGET="${CROSS_TARGET64}-as" \
    LD_FOR_TARGET="${CROSS_TARGET64}-ld" \
      || die "***build 64bit gcc stage2 error" && \
        touch ${METADATAGNU64}/gcc_stage2_build
[ -f "${METADATAGNU64}/gcc_stage2_install" ] || \
  make install || die "***install 64bit gcc stage2 error" && \
    touch ${METADATAGNU64}/gcc_stage2_install
popd

pushd ${BUILDGNU64}
[ -d "gdb-build" ] || mkdir gdb-build
cd gdb-build
[ -f "${METADATAGNU64}/gdb_configure" ] || \
  ${SRCGNU64}/gdb-${GDB_VERSION}/configure \
  --prefix=${PREFIXGNU64} --target=${CROSS_TARGET64} \
  --with-sysroot=${SYSROOTGNU64} --with-lib-path=${SYSROOTGNU64}/usr/lib \
  --enable-poison-system-directories --with-build-sysroot=${SYSROOTGNU64} || \
    die "***config 64bit gdb error" && \
      touch ${METADATAGNU64}/gdb_configure
[ -f "${METADATAGNU64}/gdb_build" ] || \
  make -j${JOBS} || die "***build 64bit gdb error" && \
    touch ${METADATAGNU64}/gdb_build
[ -f "${METADATAGNU64}/gdb_install" ] || \
  make install || die "***install 64bit gdb error" && \
    touch ${METADATAGNU64}/gdb_install
popd
