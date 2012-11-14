#! /bin/bash

export JOBS=16

export BZ=tar.bz2
export GZ=tar.gz
export XZ=tar.xz

export LINUX_VERSION=3.3.7
export LINUX_SUFFIX=${BZ}
export FILE_VERSION=5.09
export FILE_SUFFIX=${GZ}
export M4_VERSION=1.4.16
export M4_SUFFIX=${BZ}
export NCURSES_VERSION=5.9
export NCURSES_SUFFIX=${GZ}
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
export EGLIBC_VERSION=2.15
export EGLIBC_SUFFIX=${BZ}
export TERMCAP_VERSION=1.3.1
export TERMCAP_SUFFIX=${GZ}
export GDB_VERSION=7.4.1
export GDB_SUFFIX=${BZ}
export QEMU_VERSION=1.0.1
export BUSYBOX_VERSION=1.19.4
export BUSYBOX_SUFFIX=${BZ}

function die() {
  echo "$1"
  exit 1
}

[ -e build.sh ]
export SCRIPT="$(pwd)"
export TARBALL=${SCRIPT}/../tarballs
export PATCH=${SCRIPT}/../patches
export SRCS=${SCRIPT}/../srcs
export SRC=${SCRIPT}/../../src/mips64el-pure64-linux/stage1
export BUILD=${SCRIPT}/../../build/mips64el-pure64-linux/stage1

[[ $# -eq 1 ]] || die "usage: build.sh PREFIX"
export CROSS="$1"
export PATH=$PATH:/cross-tools/bin/

[ -d "${SRC}" ] || mkdir -p "${SRC}"
[ -d "${BUILD}" ] || mkdir -p "${BUILD}"

unset CFLAGS
unset CXXFLAGS
export CFLAGS="-w"
export CROSS_HOST=${MACHTYPE}
export CROSS_TARGET="mips64el-unknown-linux-gnu"
export BUILD64="-mabi=64"

mkdir -p ${CROSS}
mkdir -p ${CROSS}/tools
sudo ln -s ${CROSS}/tools /
mkdir -p ${CROSS}/cross-tools
sudo ln -s ${CROSS}/cross-tools /

pushd ${SRC}
[ -d "linux-${LINUX_VERSION}" ] \
  || tar xf ${TARBALL}/linux-${LINUX_VERSION}.${LINUX_SUFFIX}
cd linux-${LINUX_VERSION}
[ -d "/tools/include" ] || mkdir -p /tools/include
make mrproper
make ARCH=mips headers_check || die "***check headers error"
make ARCH=mips INSTALL_HDR_PATH=dest headers_install \
  || die "***install headers error"
cp -r dest/include/* /tools/include || die "***copy headers error"
popd

pushd ${SRC}
[ -d "file-${FILE_VERSION}" ] \
  || tar xf ${TARBALL}/file-${FILE_VERSION}.${FILE_SUFFIX}
cd file-${FILE_VERSION}
[ -f "config.log" ] || ./configure --prefix=/cross-tools \
  || die "***config file error"
make -j${JOBS} || die "***build file error"
make install || die "***install file error"
popd

pushd ${SRC}
[ -d "m4-${M4_VERSION}" ] \
  || tar xf ${TARBALL}/m4-${M4_VERSION}.${M4_SUFFIX}
cd m4-${M4_VERSION}
[ -f "config.log" ] || ./configure --prefix=/cross-tools \
  || die "***config m4 error"
make -j${JOBS} || die "***build m4 error"
make install || die "***install m4 error"
popd

pushd ${SRC}
[ -d "ncurses-${NCURSES_VERSION}" ] \
  || tar xf ${TARBALL}/ncurses-${NCURSES_VERSION}.${NCURSES_SUFFIX}
cd ncurses-${NCURSES_VERSION}
patch -Np1 -i ${PATCH}/ncurses-5.9-bash_fix-1.patch \
  || die "***patch ncurses error"
[ -f "config.log" ] || ./configure --prefix=/cross-tools \
                                   --without-debug --without-shared\
  || die "***config ncurses error"
make -C include || die "***build ncurses include error"
make -C progs tic || die "***build ncurses tic error"
install -m755 progs/tic /cross-tools/bin || die "***install ncurses error"
popd

pushd ${SRC}
[ -d "gmp-${GMP_VERSION}" ] \
  || tar xf ${TARBALL}/gmp-${GMP_VERSION}.${GMP_SUFFIX}
cd gmp-${GMP_VERSION}
[ -f "config.log" ] || CPPFLAGS=-fexceptions \
  ./configure --prefix=/cross-tools --enable-cxx \
  || die "***config gmp error"
make -j${JOBS} || die "***build gmp error"
make install || die "***install gmp error"
popd

pushd ${SRC}
[ -d "mpfr-${MPFR_VERSION}" ] \
  || tar xf ${TARBALL}/mpfr-${MPFR_VERSION}.${MPFR_SUFFIX}
cd mpfr-${MPFR_VERSION}
[ -f "config.log" ] || LDFLAGS="-Wl,-rpath,/cross-tools/lib" \
  ./configure --prefix=/cross-tools --with-gmp=/cross-tools --enable-shared \
  || die "***config mpfr error"
make -j${JOBS} || die "***build mpfr error"
make install || die "***install mpfr error"
popd

pushd ${SRC}
[ -d "mpc-${MPC_VERSION}" ] \
  || tar xf ${TARBALL}/mpc-${MPC_VERSION}.${MPC_SUFFIX}
cd mpc-${MPC_VERSION}
[ -f "config.log" ] || LDFLAGS="-Wl,-rpath,/cross-tools/lib" \
  ./configure --prefix=/cross-tools \
  --with-gmp=/cross-tools --with-mpfr=/cross-tools \
  || die "***config mpc error"
make -j${JOBS} || die "***build mpc error"
make install || die "***install mpc error"
popd

pushd ${SRC}
[ -d "ppl-${PPL_VERSION}" ] \
  || tar xf ${TARBALL}/ppl-${PPL_VERSION}.${PPL_SUFFIX}
cd ppl-${PPL_VERSION}
[ -f "config.log" ] || CPPFLAGS="-I/cross-tools/include" \
                       LDFLAGS="-Wl,-rpath,/cross-tools/lib" \
  ./configure --prefix=/cross-tools --enable-shared \
  --enable-interfaces="c,cxx" --disable-optimization \
  --with-libgmp-prefix=/cross-tools \
  --with-libgmpxx-prefix=/cross-tools \
  || die "***config ppl error"
make -j${JOBS} || die "***build ppl error"
make install || die "***install ppl error"
popd

pushd ${SRC}
[ -d "cloog-${CLOOG_VERSION}" ] \
  || tar xf ${TARBALL}/cloog-${CLOOG_VERSION}.${CLOOG_SUFFIX}
cd cloog-${CLOOG_VERSION}
cp -v configure{,.orig}
sed -e "/LD_LIBRARY_PATH=/d"     configure.orig > configure
[ -f "config.log" ] || LDFLAGS="-Wl,-rpath,/cross-tools/lib" \
  ./configure --prefix=/cross-tools --enable-shared \
              --with-gmp-prefix=/cross-tools || die "cloog config error"
make -j${JOBS} || die "***build cloog error"
make install || die "***install cloog error"
popd

pushd ${SRC}
[ -d "binutils-${BINUTILS_VERSION}" ] \
  || tar xf ${TARBALL}/binutils-${BINUTILS_VERSION}.${BINUTILS_SUFFIX}
popd

pushd ${BUILD}
[ -d "binutils-build" ] || mkdir binutils-build
cd binutils-build
[ -f "config.log" ] || AS="as" AR="ar" \
  ${SRC}/binutils-${BINUTILS_VERSION}/configure \
  --prefix=/cross-tools --host=${CROSS_HOST} --target=${CROSS_TARGET} \
  --with-sysroot=${CROSS} --with-lib-path=/tools/lib \
  --disable-nls --enable-shared --enable-64-bit-bfd --disable-multilib \
  --with-ppl=/cross-tools --with-cloog=/cross-tools --enable-cloog-backend=isl \
  || die "***config binutils error"
make configure-host || die "config binutils host error"
make -j${JOBS} || die "***build binutils error"
make install || die "***install binutils error"
cp ${SRC}/binutils-${BINUTILS_VERSION}/include/libiberty.h /tools/include \
  || die "***copy binutils header error"
popd

pushd ${SRC}
[ -d "gcc-${GCC_VERSION}" ] \
  || tar xf ${TARBALL}/gcc-${GCC_VERSION}.${GCC_SUFFIX}
cd gcc-${GCC_VERSION}
patch -Np1 -i ${PATCH}/gcc-4.6.2-pure64_specs-1.patch \
|| die "***patch gcc error"
patch -Np1 -i ${PATCH}/gcc-4.6.2-mips_fix-1.patch \
|| die "***patch gcc mips error"
echo -en '#undef STANDARD_INCLUDE_DIR\n#define STANDARD_INCLUDE_DIR "/tools/include/"\n\n' >> gcc/config/linux.h
echo -en '\n#undef STANDARD_STARTFILE_PREFIX_1\n#define STANDARD_STARTFILE_PREFIX_1 "/tools/lib/"\n' >> gcc/config/linux.h
echo -en '\n#undef STANDARD_STARTFILE_PREFIX_2\n#define STANDARD_STARTFILE_PREFIX_2 ""\n' >> gcc/config/linux.h
cp gcc/Makefile.in{,.orig}
sed -e "s@\(^CROSS_SYSTEM_HEADER_DIR =\).*@\1 /tools/include@g"     gcc/Makefile.in.orig > gcc/Makefile.in
touch /tools/include/limits.h
popd

pushd ${BUILD}
[ -d "gcc-build-stage1" ] || mkdir gcc-build-stage1
cd gcc-build-stage1
[ -f "config.log" ] || AR=ar LDFLAGS="-Wl,-rpath,/cross-tools/lib" \
  ${SRC}/gcc-${GCC_VERSION}/configure \
  --prefix=/cross-tools --build=${CROSS_HOST} --host=${CROSS_HOST} \
  --target=${CROSS_TARGET} --with-sysroot=${CROSS} \
  --with-local-prefix=/tools --disable-nls \
  --disable-shared --with-mpfr=/cross-tools --with-gmp=/cross-tools \
  --with-ppl=/cross-tools --with-cloog=/cross-tools \
  --without-headers --with-newlib --disable-decimal-float \
  --disable-libgomp --disable-libmudflap --disable-libssp \
  --disable-threads --enable-languages=c --with-abi=64 \
  --disable-multilib --enable-cloog-backend=isl \
  || die "***config gcc stage1 error"
make -j${JOBS} all-gcc all-target-libgcc || die "***build gcc stage1 error"
make install-gcc install-target-libgcc || die "***install gcc stage1 error"
popd

pushd ${SRC}
[ -d "eglibc-${EGLIBC_VERSION}" ] \
  || tar xf ${TARBALL}/eglibc-${EGLIBC_VERSION}.${EGLIBC_SUFFIX}
cd eglibc-${EGLIBC_VERSION}
cp Makeconfig{,.orig}
sed -e 's/-lgcc_eh//g' Makeconfig.orig > Makeconfig
cp config.make.in{,.orig}
sed '/ldd-rewrite-script/s:@:&:' config.make.in.orig > config.make.in
popd

pushd ${BUILD}
[ -d "eglibc-build-n64" ] || mkdir eglibc-build-n64
cd eglibc-build-n64
cat > config.cache << "EOF"
libc_cv_forced_unwind=yes
libc_cv_c_cleanup=yes
libc_cv_gnu89_inline=yes
libc_cv_ssp=no
EOF
[ -f "config.log" ] || BUILD_CC="gcc" CC="${CROSS_TARGET}-gcc ${BUILD64}" \
                       AR="${CROSS_TARGET}-ar" RANLIB="${CROSS_TARGET}-ranlib" \
  CFLAGS_FOR_TARGET="-O2"   CFLAGS+="-O2" \
  ${SRC}/eglibc-${EGLIBC_VERSION}/configure \
  --prefix=/tools --host=${CROSS_TARGET} --build=${CROSS_HOST} \
  --disable-profile --enable-add-ons \
  --with-tls --enable-kernel=2.6.0 --with-__thread \
  --with-binutils=/cross-tools/bin --with-headers=/tools/include \
  --cache-file=config.cache \
  || die "***config n64 eglibc error"
make -j${JOBS} || die "***build n64 eglibc error"
make install inst_vardbdir=/tools/var/db \
  || die "***install n64 eglibc error"
popd

pushd ${BUILD}
[ -d "gcc-build-stage2" ] || mkdir gcc-build-stage2
cd gcc-build-stage2
[ -f "config.log" ] || AR=ar LDFLAGS="-Wl,-rpath,/cross-tools/lib" \
  ${SRC}/gcc-${GCC_VERSION}/configure \
  --prefix=/cross-tools --build=${CROSS_HOST} --target=${CROSS_TARGET} \
  --host=${CROSS_HOST} --with-sysroot=${CROSS} \
  --with-local-prefix=/tools --disable-nls \
  --enable-shared --enable-languages=c,c++ --enable-__cxa_atexit \
  --with-mpfr=/cross-tools --with-gmp=/cross-tools --enable-c99 \
  --with-ppl=/cross-tools --with-cloog=/cross-tools \
  --enable-long-long --enable-threads=posix --with-abi=64 \
  --disable-multilib --enable-cloog-backend=isl \
  || die "***config gcc stage2 error"
make -j${JOBS} \
     AS_FOR_TARGET="${CROSS_TARGET}-as" \
     LD_FOR_TARGET="${CROSS_TARGET}-ld" \
  || die "***build gcc stage2 error"
make install || die "***install gcc stage2 error"
popd
