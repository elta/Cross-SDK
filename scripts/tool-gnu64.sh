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
### 64bit gnu extract
#################################################################
pushd ${SRC64}
[ -f ${METADATA64}/gmp_extract ] || \
tar xf ${TARBALL}/gmp-${GMP_VERSION}.${GMP_SUFFIX} && \
  touch ${METADATA64}/gmp_extract

[ -f ${METADATA64}/mpfr_extract ] || \
tar xf ${TARBALL}/mpfr-${MPFR_VERSION}.${MPFR_SUFFIX} && \
  touch ${METADATA64}/mpfr_extract

[ -f ${METADATA64}/mpc_extract ] || \
tar xf ${TARBALL}/mpc-${MPC_VERSION}.${MPC_SUFFIX} && \
  touch ${METADATA64}/mpc_extract

[ -f ${METADATA64}/ppl_extract ] || \
tar xf ${TARBALL}/ppl-${PPL_VERSION}.${PPL_SUFFIX} && \
  touch ${METADATA64}/ppl_extract

[ -f ${METADATA64}/cloog_extract ] || \
tar xf ${TARBALL}/cloog-${CLOOG_VERSION}.${CLOOG_SUFFIX} && \
  touch ${METADATA64}/cloog_extract

[ -f ${METADATA64}/binutils_extract ] || \
tar xf ${TARBALL}/binutils-${BINUTILS_VERSION}.${BINUTILS_SUFFIX} && \
  touch ${METADATA64}/binutils_extract

[ -f ${METADATA64}/gcc_extract ] || \
tar xf ${TARBALL}/gcc-${GCC_VERSION}.${GCC_SUFFIX} && \
  touch ${METADATA64}/gcc_extract

[ -f ${METADATA64}/glibc_extract ] || \
tar xf ${TARBALL}/glibc-${GLIBC_VERSION}.${GLIBC_SUFFIX} &&\
  touch ${METADATA64}/glibc_extract

[ -f ${METADATA64}/gdb_extract ] || \
tar xf ${TARBALL}/gdb-${GDB_VERSION}.${GDB_SUFFIX} && \
  touch ${METADATA64}/gdb_extract
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
### 64bit gnu build
#################################################################
pushd ${SRCS}
cd linux-${LINUX_VERSION}
make distclean
[ -f ${METADATA64}/linux_headers_install ] || make mrproper
[ -f ${METADATA64}/linux_headers_install ] || \
  make ARCH=mips headers_check || die "***check headers error 64bit"
[ -f ${METADATA64}/linux_headers_install ] || \
  make ARCH=mips INSTALL_HDR_PATH=${SYSROOT64}/usr headers_install || \
    die "***install headers error 64bit" && \
      touch ${METADATA64}/linux_headers_install
make distclean
popd

pushd ${SRC64}
unset CFLAGS
[ -d "gmp-${GMP_VERSION}" ] \
  || tar xf ${TARBALL}/gmp-${GMP_VERSION}.${GMP_SUFFIX}
cd gmp-${GMP_VERSION}
[ -f ${METADATA64}/gmp_configure ] || \
CPPFLAGS=-fexceptions ./configure \
  --prefix=${PREFIX64} --enable-cxx || die "***config gmp error 64bit" && \
    touch ${METADATA64}/gmp_configure
[ -f ${METADATA64}/gmp_build ] || \
make -j${JOBS} || die "***build gmp error 64bit" && \
  touch ${METADATA64}/gmp_build
[ -f ${METADATA64}/gmp_install ] || \
make install || die "***install gmp error 64bit" && \
touch ${METADATA64}/gmp_install
export CFLAGS="-w"
popd

pushd ${SRC64}
[ -d "mpfr-${MPFR_VERSION}" ] \
  || tar xf ${TARBALL}/mpfr-${MPFR_VERSION}.${MPFR_SUFFIX}
cd mpfr-${MPFR_VERSION}
[ -f ${METADATA64}/mpfr_configure ] || \
LDFLAGS="-Wl,-rpath,${PREFIX64}/lib" \
./configure --prefix=${PREFIX64} \
    --enable-shared --with-gmp=${PREFIX64} || \
      die "***config mpfr error 64bit" && \
        touch ${METADATA64}/mpfr_configure
[ -f ${METADATA64}/mpfr_build ] || \
make -j${JOBS} || die "***build mpfr error 64bit" && \
  touch ${METADATA64}/mpfr_build
[ -f ${METADATA64}/mpfr_install ] || \
make install || die "***install mpfr error 64bit" && \
  touch ${METADATA64}/mpfr_install
popd

pushd ${SRC64}
[ -d "mpc-${MPC_VERSION}" ] \
  || tar xf ${TARBALL}/mpc-${MPC_VERSION}.${MPC_SUFFIX}
cd mpc-${MPC_VERSION}
[ -f ${METADATA64}/mpc_configure ] || \
LDFLAGS="-Wl,-rpath,${PREFIX64}/lib" \
./configure --prefix=${PREFIX64} \
  --with-gmp=${PREFIX64} \
  --with-mpfr=${PREFIX64} || die "***config mpc error 64bit" && \
     touch ${METADATA64}/mpc_configure
[ -f ${METADATA64}/mpc_build ] || \
make -j${JOBS} || die "***config mpc error 64bit" && \
  touch ${METADATA64}/mpc_build
[ -f ${METADATA64}/mpc_install ] || \
make install || die "***install mpc error 64bit" && \
  touch ${METADATA64}/mpc_install
popd

pushd ${SRC64}
[ -d "ppl-${PPL_VERSION}" ] \
  || tar xf ${TARBALL}/ppl-${PPL_VERSION}.${PPL_SUFFIX}
cd ppl-${PPL_VERSION}
[ -f ${METADATA64}/ppl_configure ] || \
CPPFLAGS="-I${PREFIX64}/include" \
  LDFLAGS="-Wl,-rpath,${PREFIX64}/lib" \
  ./configure --prefix=${PREFIX64} --enable-shared \
  --enable-interfaces="c,cxx" --disable-optimization \
  --with-libgmp-prefix=${PREFIX64} \
  --with-libgmpxx-prefix=${PREFIX64} || die "***config ppl error 64bit" && \
    touch ${METADATA64}/ppl_configure
[ -f ${METADATA64}/ppl_build ] || \
make -j${JOBS} || die "***build ppl error 64bit" && \
  touch ${METADATA64}/ppl_build
[ -f ${METADATA64}/ppl_install ] || \
make install || die "***install ppl error 64bit" && \
  touch ${METADATA64}/ppl_install
popd

pushd ${SRC64}
[ -d "cloog-${CLOOG_VERSION}" ] \
  || tar xf ${TARBALL}/cloog-${CLOOG_VERSION}.${CLOOG_SUFFIX}
cd cloog-${CLOOG_VERSION}
cp -v configure{,.orig}
sed -e "/LD_LIBRARY_PATH=/d" \
  configure.orig > configure
[ -f ${METADATA64}/cloog_configure ] || \
LDFLAGS="-Wl,-rpath,${PREFIX64}/lib" \
  ./configure --prefix=${PREFIX64} --enable-shared \
  --with-gmp-prefix=${PREFIX64} || die "***config cloog error 64bit" && \
    touch ${METADATA64}/cloog_configure
[ -f ${METADATA64}/cloog_build ] || \
make -j${JOBS} || die "***build cloog error 64bit" && \
    touch ${METADATA64}/cloog_build
[ -f ${METADATA64}/cloog_install ] || \
  make install || die "***install cloog error 64bit" && \
    touch ${METADATA64}/cloog_install
popd

pushd ${BUILD64}
[ -d "binutils-build" ] || mkdir binutils-build
cd binutils-build
[ -f "${METADATA64}/binutils_configure" ] || AS="as" AR="ar" \
  ${SRC64}/binutils-${BINUTILS_VERSION}/configure \
  --prefix=${PREFIX64} --host=${CROSS_HOST} --target=${CROSS_TARGET64} \
  --with-sysroot=${SYSROOT64} --with-lib-path=${SYSROOT64}/usr/lib \
  --disable-nls --enable-shared --enable-64-bit-bfd \
  --enable-cloog-backend=isl --enable-poison-system-directories \
  --with-gmp=${PREFIX64} --with-mpfr=${PREFIX64} \
  --with-ppl=${PREFIX64} --with-cloog=${PREFIX64} \
  --with-build-sysroot=${SYSROOT64} || \
    die "***config 64bit binutils error" && \
      touch ${METADATA64}/binutils_configure
[ -f ${METADATA64}/binutils_build ] || \
  make configure-host || die "config 64bit binutils host error"
[ -f ${METADATA64}/binutils_build ] || \
  make -j${JOBS} || die "***build 64bit binutils error" && \
    touch ${METADATA64}/binutils_build
[ -f ${METADATA64}/binutils_install ] || \
  make install || die "***install 64bit binutils error" && \
    touch ${METADATA64}/binutils_install
popd

pushd ${BUILD64}
[ -d "gcc-build-stage1" ] || mkdir gcc-build-stage1
cd gcc-build-stage1
[ -f "${METADATA64}/gcc_stage1_configure" ] || \
  AR=ar LDFLAGS="-Wl,-rpath,${PREFIX64}/lib" \
  ${SRC64}/gcc-${GCC_VERSION}/configure \
  --prefix=${PREFIX64} --build=${CROSS_HOST} --host=${CROSS_HOST} \
  --target=${CROSS_TARGET64} --with-sysroot=${SYSROOT64} \
  --with-local-prefix=${SYSROOT64}/usr --disable-nls \
  --disable-shared \
  --without-headers --with-newlib --disable-decimal-float \
  --disable-libgomp --disable-libmudflap --disable-libssp \
  --disable-threads --enable-languages=c \
  --enable-cloog-backend=isl \
  --with-gmp=${PREFIX64} --with-mpfr=${PREFIX64} \
  --with-ppl=${PREFIX64} --with-cloog=${PREFIX64} \
  --enable-poison-system-directories --with-build-sysroot=${SYSROOT64} || \
    die "***config 64bit gcc stage1 error" && \
      touch ${METADATA64}/gcc_stage1_configure
[ -f "${METADATA64}/gcc_stage1_build" ] || \
  make -j${JOBS} all-gcc all-target-libgcc || \
    die "***build 64bit gcc stage1 error" && \
      touch ${METADATA64}/gcc_stage1_build
[ -f "${METADATA64}/gcc_stage1_install" ] || \
  make install-gcc install-target-libgcc || \
    die "***install 64bit gcc stage1 error" && \
      touch ${METADATA64}/gcc_stage1_install
popd

pushd ${BUILD64}
[ -d "glibc-build-o32" ] || mkdir glibc-build-o32
cd glibc-build-o32
cat > config.cache << "EOF"
libc_cv_forced_unwind=yes
libc_cv_c_cleanup=yes
libc_cv_gnu89_inline=yes
libc_cv_ssp=no
EOF
cat > configparms << EOF
install_root=${SYSROOT64}
EOF
[ -f "${METADATA64}/glibc_configure_32" ] || \
  BUILD_CC="gcc" CC="${CROSS_TARGET64}-gcc ${O32}" \
  AR="${CROSS_TARGET64}-ar" RANLIB="${CROSS_TARGET64}-ranlib" \
  CFLAGS_FOR_TARGET="-O2" CFLAGS="-O2" \
  ${SRC64}/glibc-${GLIBC_VERSION}/configure \
  --prefix=/usr --host=${CROSS_TARGET32} --build=${CROSS_HOST} \
  --disable-profile --enable-add-ons \
  --with-tls --enable-kernel=2.6.0 --with-__thread \
  --with-binutils=${PREFIX64}/bin --with-headers=${SYSROOT64}/usr/include \
  --cache-file=config.cache || \
    die "***config o32 glibc error" && \
      touch ${METADATA64}/glibc_configure_32
[ -f "${METADATA64}/glibc_build_32" ] || \
  make -j${JOBS} || die "***build o32 glibc error" && \
    touch ${METADATA64}/glibc_build_32
[ -f "${METADATA64}/glibc_install_32" ] || \
  make install inst_vardbdir=${SYSROOT64}/var/db || \
    die "***install o32 glibc error" && \
      touch ${METADATA64}/glibc_install_32
popd

pushd ${BUILD64}
[ -d "glibc-build-n32" ] || mkdir glibc-build-n32
cd glibc-build-n32
cat > config.cache << "EOF"
libc_cv_forced_unwind=yes
libc_cv_c_cleanup=yes
libc_cv_gnu89_inline=yes
libc_cv_ssp=no
EOF
cat > configparms << EOF
install_root=${SYSROOT64}
slibdir=/lib32
EOF
[ -f "${METADATA64}/glibc_configure_n32" ] || \
  BUILD_CC="gcc" CC="${CROSS_TARGET64}-gcc ${N32}" \
  AR="${CROSS_TARGET64}-ar" RANLIB="${CROSS_TARGET64}-ranlib" \
  CFLAGS_FOR_TARGET="-O2" CFLAGS="-O2" \
  ${SRC64}/glibc-${GLIBC_VERSION}/configure \
  --prefix=/usr --host=${CROSS_TARGET64} --build=${CROSS_HOST} \
  --libdir=/usr/lib32 \
  --disable-profile --enable-add-ons \
  --with-tls --enable-kernel=2.6.0 --with-__thread \
  --with-binutils=${PREFIX64}/bin --with-headers=${SYSROOT64}/usr/include \
  --cache-file=config.cache || \
    die "***config n32 glibc error" && \
      touch ${METADATA64}/glibc_configure_n32
[ -f "${METADATA64}/glibc_build_n32" ] || \
  make -j${JOBS} || die "***build n32 glibc error" && \
    touch ${METADATA64}/glibc_build_n32
[ -f "${METADATA64}/glibc_install_n32" ] || \
  make install inst_vardbdir=${SYSROOT64}/var/db || \
    die "***install n32 glibc error" && \
      touch ${METADATA64}/glibc_install_n32
popd

pushd ${BUILD64}
[ -d "glibc-build-n64" ] || mkdir glibc-build-n64
cd glibc-build-n64
cat > config.cache << "EOF"
libc_cv_forced_unwind=yes
libc_cv_c_cleanup=yes
libc_cv_gnu89_inline=yes
libc_cv_ssp=no
EOF
cat > configparms << EOF
install_root=${SYSROOT64}
slibdir=/lib64
EOF
[ -f "${METADATA64}/glibc_configure_64" ] || \
  BUILD_CC="gcc" CC="${CROSS_TARGET64}-gcc ${N64}" \
  AR="${CROSS_TARGET64}-ar" RANLIB="${CROSS_TARGET64}-ranlib" \
  CFLAGS_FOR_TARGET="-O2" CFLAGS="-O2" \
  ${SRC64}/glibc-${GLIBC_VERSION}/configure \
  --prefix=/usr --host=${CROSS_TARGET64} --build=${CROSS_HOST} \
  --libdir=/usr/lib64 \
  --disable-profile --enable-add-ons \
  --with-tls --enable-kernel=2.6.0 --with-__thread \
  --with-binutils=${PREFIX64}/bin --with-headers=${SYSROOT64}/usr/include \
  --cache-file=config.cache || \
    die "***config 64bit glibc error" && \
      touch ${METADATA64}/glibc_configure_64
[ -f "${METADATA64}/glibc_build_64" ] || \
  make -j${JOBS} || die "***build 64bit glibc error" && \
    touch ${METADATA64}/glibc_build_64
[ -f "${METADATA64}/glibc_install_64" ] || \
  make install inst_vardbdir=${SYSROOT64}/var/db || \
    die "***install 64bit glibc error" && \
      touch ${METADATA64}/glibc_install_64
popd

pushd ${BUILD64}
[ -d "gcc-build-stage2" ] || mkdir gcc-build-stage2
cd gcc-build-stage2
[ -f "${METADATA64}/gcc_stage2_configure" ] || \
  AR=ar LDFLAGS="-Wl,-rpath,${PREFIX64}/lib" \
  ${SRC64}/gcc-${GCC_VERSION}/configure \
  --prefix=${PREFIX64} --build=${CROSS_HOST} --target=${CROSS_TARGET64} \
  --host=${CROSS_HOST} --with-sysroot=${SYSROOT64} \
  --with-local-prefix=/${SYSROOT64}/usr \
  --disable-nls \
  --enable-shared --enable-languages=c,c++ --enable-__cxa_atexit \
  --enable-c99 \
  --enable-long-long --enable-threads=posix \
  --enable-cloog-backend=isl \
  --with-gmp=${PREFIX64} --with-mpfr=${PREFIX64} \
  --with-ppl=${PREFIX64} --with-cloog=${PREFIX64} \
  --enable-poison-system-directories --with-build-sysroot=${SYSROOT64} || \
    die "***config 64bit gcc stage2 error" && \
      touch ${METADATA64}/gcc_stage2_configure
[ -f "${METADATA64}/gcc_stage2_build" ] || \
  make -j${JOBS} \
    AS_FOR_TARGET="${CROSS_TARGET64}-as" \
    LD_FOR_TARGET="${CROSS_TARGET64}-ld" \
      || die "***build 64bit gcc stage2 error" && \
        touch ${METADATA64}/gcc_stage2_build
[ -f "${METADATA64}/gcc_stage2_install" ] || \
  make install || die "***install 64bit gcc stage2 error" && \
    touch ${METADATA64}/gcc_stage2_install
popd

pushd ${BUILD64}
[ -d "gdb-build" ] || mkdir gdb-build
cd gdb-build
[ -f "${METADATA64}/gdb_configure" ] || \
  ${SRC64}/gdb-${GDB_VERSION}/configure \
  --prefix=${PREFIX64} --target=${CROSS_TARGET64} \
  --with-sysroot=${SYSROOT64} --with-lib-path=${SYSROOT64}/usr/lib \
  --enable-poison-system-directories --with-build-sysroot=${SYSROOT64} || \
    die "***config 64bit gdb error" && \
      touch ${METADATA64}/gdb_configure
[ -f "${METADATA64}/gdb_build" ] || \
  make -j${JOBS} || die "***build 64bit gdb error" && \
    touch ${METADATA64}/gdb_build
[ -f "${METADATA64}/gdb_install" ] || \
  make install || die "***install 64bit gdb error" && \
    touch ${METADATA64}/gdb_install
popd
