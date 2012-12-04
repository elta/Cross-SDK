#! /bin/bash

source source.sh

[ -d "${SRCPURE64ELSTAGE1}" ] || mkdir -p "${SRCPURE64ELSTAGE1}"
[ -d "${BUILDPURE64ELSTAGE1}" ] || mkdir -p "${BUILDPURE64ELSTAGE1}"

[ -d "${PREFIX}" ] || mkdir -p ${PREFIX}
[ -d "${PREFIXPURE64EL}" ] || mkdir -p ${PREFIXPURE64EL}
[ -d "${PREFIXPURE64EL}/tools" ] || mkdir -p ${PREFIXPURE64EL}/tools
[ -d "/tools" ] || sudo ln -s ${PREFIXPURE64EL}/tools /
[ -d "${PREFIXPURE64EL}/cross-tools" ] || mkdir -p ${PREFIXPURE64EL}/cross-tools
[ -d "/cross-tools" ] || sudo ln -s ${PREFIXPURE64EL}/cross-tools /

export PATH=${PATH}:/cross-tools/bin/

pushd ${SRCPURE64ELSTAGE1}
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

pushd ${SRCPURE64ELSTAGE1}
[ -d "file-${FILE_VERSION}" ] \
  || tar xf ${TARBALL}/file-${FILE_VERSION}.${FILE_SUFFIX}
cd file-${FILE_VERSION}
[ -f "config.log" ] || ./configure --prefix=/cross-tools \
  || die "***config file error"
make -j${JOBS} || die "***build file error"
make install || die "***install file error"
popd

pushd ${SRCPURE64ELSTAGE1}
[ -d "m4-${M4_VERSION}" ] \
  || tar xf ${TARBALL}/m4-${M4_VERSION}.${M4_SUFFIX}
cd m4-${M4_VERSION}
[ -f "config.log" ] || ./configure --prefix=/cross-tools \
  || die "***config m4 error"
make -j${JOBS} || die "***build m4 error"
make install || die "***install m4 error"
popd

pushd ${SRCPURE64ELSTAGE1}
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

pushd ${SRCPURE64ELSTAGE1}
[ -d "gmp-${GMP_VERSION}" ] \
  || tar xf ${TARBALL}/gmp-${GMP_VERSION}.${GMP_SUFFIX}
cd gmp-${GMP_VERSION}
[ -f "config.log" ] || CPPFLAGS=-fexceptions \
  ./configure --prefix=/cross-tools --enable-cxx \
  || die "***config gmp error"
make -j${JOBS} || die "***build gmp error"
make install || die "***install gmp error"
popd

pushd ${SRCPURE64ELSTAGE1}
[ -d "mpfr-${MPFR_VERSION}" ] \
  || tar xf ${TARBALL}/mpfr-${MPFR_VERSION}.${MPFR_SUFFIX}
cd mpfr-${MPFR_VERSION}
[ -f "config.log" ] || LDFLAGS="-Wl,-rpath,/cross-tools/lib" \
  ./configure --prefix=/cross-tools --with-gmp=/cross-tools --enable-shared \
  || die "***config mpfr error"
make -j${JOBS} || die "***build mpfr error"
make install || die "***install mpfr error"
popd

pushd ${SRCPURE64ELSTAGE1}
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

pushd ${SRCPURE64ELSTAGE1}
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

pushd ${SRCPURE64ELSTAGE1}
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

pushd ${SRCPURE64ELSTAGE1}
[ -d "binutils-${BINUTILS_VERSION}" ] \
  || tar xf ${TARBALL}/binutils-${BINUTILS_VERSION}.${BINUTILS_SUFFIX}
popd

pushd ${BUILDPURE64ELSTAGE1}
[ -d "binutils-build" ] || mkdir binutils-build
cd binutils-build
[ -f "config.log" ] || AS="as" AR="ar" \
  ${SRCPURE64ELSTAGE1}/binutils-${BINUTILS_VERSION}/configure \
  --prefix=/cross-tools --host=${CROSS_HOST} --target=${CROSS_TARGET64} \
  --with-sysroot=${PREFIXPURE64EL} --with-lib-path=/tools/lib \
  --disable-nls --enable-shared --enable-64-bit-bfd --disable-multilib \
  --with-ppl=/cross-tools --with-cloog=/cross-tools --enable-cloog-backend=isl \
  || die "***config binutils error"
make configure-host || die "config binutils host error"
make -j${JOBS} || die "***build binutils error"
make install || die "***install binutils error"
cp ${SRCPURE64ELSTAGE1}/binutils-${BINUTILS_VERSION}/include/libiberty.h /tools/include \
  || die "***copy binutils header error"
popd

pushd ${SRCPURE64ELSTAGE1}
[ -d "gcc-${GCC_VERSION}" ] \
  || tar xf ${TARBALL}/gcc-${GCC_VERSION}.${GCC_SUFFIX}
cd gcc-${GCC_VERSION}
patch -Np1 -i ${PATCH}/gcc-4.6.3-specs-1.patch \
|| die "***patch gcc error"
patch -Np1 -i ${PATCH}/gcc-4.6.3-mips_fix-1.patch \
|| die "***patch gcc mips error"
echo -en '#undef STANDARD_INCLUDE_DIR\n#define STANDARD_INCLUDE_DIR "/tools/include/"\n\n' >> gcc/config/linux.h
echo -en '\n#undef STANDARD_STARTFILE_PREFIX_1\n#define STANDARD_STARTFILE_PREFIX_1 "/tools/lib/"\n' >> gcc/config/linux.h
echo -en '\n#undef STANDARD_STARTFILE_PREFIX_2\n#define STANDARD_STARTFILE_PREFIX_2 ""\n' >> gcc/config/linux.h
cp gcc/Makefile.in{,.orig}
sed -e "s@\(^CROSS_SYSTEM_HEADER_DIR =\).*@\1 /tools/include@g"     gcc/Makefile.in.orig > gcc/Makefile.in
touch /tools/include/limits.h
popd

pushd ${BUILDPURE64ELSTAGE1}
[ -d "gcc-build-stage1" ] || mkdir gcc-build-stage1
cd gcc-build-stage1
[ -f "config.log" ] || AR=ar LDFLAGS="-Wl,-rpath,/cross-tools/lib" \
  ${SRCPURE64ELSTAGE1}/gcc-${GCC_VERSION}/configure \
  --prefix=/cross-tools --build=${CROSS_HOST} --host=${CROSS_HOST} \
  --target=${CROSS_TARGET64} --with-sysroot=${PREFIXPURE64EL} \
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

pushd ${SRCPURE64ELSTAGE1}
[ -d "eglibc-${EGLIBC_VERSION}" ] \
  || tar xf ${TARBALL}/eglibc-${EGLIBC_VERSION}-r21467.${EGLIBC_SUFFIX}
cd eglibc-${EGLIBC_VERSION}
[ -d "ports" ] \
  || tar xf ${TARBALL}/eglibc-ports-${EGLIBCPORTS_VERSION}-r21467.${EGLIBCPORTS_SUFFIX}
cp Makeconfig{,.orig}
sed -e 's/-lgcc_eh//g' Makeconfig.orig > Makeconfig
cp config.make.in{,.orig}
sed '/ldd-rewrite-script/s:@:&:' config.make.in.orig > config.make.in
popd

pushd ${BUILDPURE64ELSTAGE1}
[ -d "eglibc-build-n64" ] || mkdir eglibc-build-n64
cd eglibc-build-n64
cat > config.cache << "EOF"
libc_cv_forced_unwind=yes
libc_cv_c_cleanup=yes
libc_cv_gnu89_inline=yes
libc_cv_ssp=no
EOF
[ -f "config.log" ] || BUILD_CC="gcc" CC="${CROSS_TARGET64}-gcc ${BUILD64}" \
                       AR="${CROSS_TARGET64}-ar" RANLIB="${CROSS_TARGET64}-ranlib" \
  CFLAGS_FOR_TARGET="-O2"   CFLAGS+="-O2" \
  ${SRCPURE64ELSTAGE1}/eglibc-${EGLIBC_VERSION}/configure \
  --prefix=/tools --host=${CROSS_TARGET64} --build=${CROSS_HOST} \
  --disable-profile --enable-add-ons \
  --with-tls --enable-kernel=2.6.0 --with-__thread \
  --with-binutils=/cross-tools/bin --with-headers=/tools/include \
  --cache-file=config.cache \
  || die "***config n64 eglibc error"
make -j${JOBS} || die "***build n64 eglibc error"
make install inst_vardbdir=/tools/var/db \
  || die "***install n64 eglibc error"
popd

pushd ${BUILDPURE64ELSTAGE1}
[ -d "gcc-build-stage2" ] || mkdir gcc-build-stage2
cd gcc-build-stage2
[ -f "config.log" ] || AR=ar LDFLAGS="-Wl,-rpath,/cross-tools/lib" \
  ${SRCPURE64ELSTAGE1}/gcc-${GCC_VERSION}/configure \
  --prefix=/cross-tools --build=${CROSS_HOST} --target=${CROSS_TARGET64} \
  --host=${CROSS_HOST} --with-sysroot=${PREFIXPURE64EL} \
  --with-local-prefix=/tools --disable-nls \
  --enable-shared --enable-languages=c,c++ --enable-__cxa_atexit \
  --with-mpfr=/cross-tools --with-gmp=/cross-tools --enable-c99 \
  --with-ppl=/cross-tools --with-cloog=/cross-tools \
  --enable-long-long --enable-threads=posix --with-abi=64 \
  --disable-multilib --enable-cloog-backend=isl \
  || die "***config gcc stage2 error"
make -j${JOBS} \
     AS_FOR_TARGET="${CROSS_TARGET64}-as" \
     LD_FOR_TARGET="${CROSS_TARGET64}-ld" \
  || die "***build gcc stage2 error"
make install || die "***install gcc stage2 error"
popd

sudo rm -rf /cross-tools /tools
