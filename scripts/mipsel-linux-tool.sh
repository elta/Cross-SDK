#! /bin/bash

source source.env

[ -d "${SRCMIPSELTOOLCHAIN}" ] || mkdir -p "${SRCMIPSELTOOLCHAIN}"
[ -d "${BUILDMIPSELTOOLCHAIN}" ] || mkdir -p "${BUILDMIPSELTOOLCHAIN}"
[ -d "${METADATAMIPSELTOOLCHAIN}" ] || mkdir -p "${METADATAMIPSELTOOLCHAIN}"
[ -d "${PREFIXMIPSELROOTFS}" ] || mkdir -p "${PREFIXMIPSELROOTFS}"

mkdir -p ${PREFIXMIPSELTOOLCHAIN}
mkdir -p ${PREFIXMIPSELROOTFS}/usr/include
mkdir -p ${PREFIXMIPSELROOTFS}/{etc,bin}
export PATH=${PREFIXHOSTTOOLS}/bin:${PREFIXMIPSELTOOLCHAIN}/bin:$PATH

###############################################################
# mipsel sysroot extract
###############################################################

pushd ${BUILDMIPSELTOOLCHAIN}
[ -f ${METADATAMIPSELTOOLCHAIN}/linux_extract ] || \
  tar xf ${TARBALL}/linux-${LINUX_VERSION}.${LINUX_SUFFIX} || \
    die "***extract linux error" && \
      touch ${METADATAMIPSELTOOLCHAIN}/linux_extract
popd

pushd ${SRCMIPSELTOOLCHAIN}
[ -f ${METADATAMIPSELTOOLCHAIN}/gmp_extract ] || \
  tar xf ${TARBALL}/gmp-${GMP_VERSION}.${GMP_SUFFIX} || \
    die "***extract gmp error" && \
      touch ${METADATAMIPSELTOOLCHAIN}/gmp_extract
[ -f ${METADATAMIPSELTOOLCHAIN}/groff_extract_cross ] || \
  tar xf ${TARBALL}/groff-${GROFF_VERSION}.${GROFF_SUFFIX} || \
    die "***extract groff cross error" && \
      touch ${METADATAMIPSELTOOLCHAIN}/groff_extract_cross

[ -f ${METADATAMIPSELTOOLCHAIN}/mpfr_extract ] || \
  tar xf ${TARBALL}/mpfr-${MPFR_VERSION}.${MPFR_SUFFIX} || \
    die "***extract mpfr error" && \
      touch ${METADATAMIPSELTOOLCHAIN}/mpfr_extract

[ -f ${METADATAMIPSELTOOLCHAIN}/mpc_extract ] || \
  tar xf ${TARBALL}/mpc-${MPC_VERSION}.${MPC_SUFFIX} || \
    die "***extract mpc error" && \
      touch ${METADATAMIPSELTOOLCHAIN}/mpc_extract

[ -f ${METADATAMIPSELTOOLCHAIN}/ppl_extract ] || \
  tar xf ${TARBALL}/ppl-${PPL_VERSION}.${PPL_SUFFIX} || \
    die "***extract ppl error" && \
      touch ${METADATAMIPSELTOOLCHAIN}/ppl_extract

[ -f ${METADATAMIPSELTOOLCHAIN}/cloog_extract ] || \
  tar xf ${TARBALL}/cloog-${CLOOG_VERSION}.${CLOOG_SUFFIX} || \
    die "***extract cloog error" && \
      touch ${METADATAMIPSELTOOLCHAIN}/cloog_extract

[ -f ${METADATAMIPSELTOOLCHAIN}/binutils_extract ] || \
  tar xf ${TARBALL}/binutils-${BINUTILS_VERSION}.${BINUTILS_SUFFIX} || \
    die "***extract binutils error" && \
      touch ${METADATAMIPSELTOOLCHAIN}/binutils_extract

[ -f ${METADATAMIPSELTOOLCHAIN}/gcc_extract ] || \
  tar xf ${TARBALL}/gcc-${GCC_VERSION}.${GCC_SUFFIX} || \
    die "***extract gcc error" && \
      touch ${METADATAMIPSELTOOLCHAIN}/gcc_extract

[ -f ${METADATAMIPSELTOOLCHAIN}/glibc_extract ] || \
  tar xf ${TARBALL}/glibc-${GLIBC_VERSION}.${GLIBC_SUFFIX} || \
    die "***extract glibc error" && \
      touch ${METADATAMIPSELTOOLCHAIN}/glibc_extract

[ -f ${METADATAMIPSELTOOLCHAIN}/file_extract ] || \
  tar xf ${TARBALL}/file-${FILE_VERSION}.${FILE_SUFFIX} || \
    die "***extract file error" && \
      touch ${METADATAMIPSELTOOLCHAIN}/file_extract

[ -f ${METADATAMIPSELTOOLCHAIN}/ncurses_extract ] || \
  tar xf ${TARBALL}/ncurses-${NCURSES_VERSION}.${NCURSES_SUFFIX} || \
    die "***extract ncurses error" && \
      touch ${METADATAMIPSELTOOLCHAIN}/ncurses_extract

[ -f ${METADATAMIPSELTOOLCHAIN}/gdb_extract ] || \
  tar xf ${TARBALL}/gdb-${GDB_VERSION}.${GDB_SUFFIX} || \
    die "***extractjgdb error" && \
      touch ${METADATAMIPSELTOOLCHAIN}/gdb_extract
[ -f ${METADATAMIPSELTOOLCHAIN}/shadow_extract ] || \
  tar xf ${TARBALL}/shadow-${SHADOW_VERSION}.${SHADOW_SUFFIX} || \
    die "***extract shadow error" && \
      touch ${METADATAMIPSELTOOLCHAIN}/shadow_extract
popd

pushd ${BUILDMIPSELTOOLCHAIN}
cd linux-${LINUX_VERSION}
[ -f ${METADATAMIPSELTOOLCHAIN}/linux_mrproper ] || \
  make mrproper || \
    die "***make mrproper error" && \
      touch ${METADATAMIPSELTOOLCHAIN}/linux_mrproper
[ -f ${METADATAMIPSELTOOLCHAIN}/linux_headers_check ] || \
  make ARCH=mips headers_check || \
    die "***check headers error" && \
      touch ${METADATAMIPSELTOOLCHAIN}/linux_headers_check
[ -f ${METADATAMIPSELTOOLCHAIN}/linux_headers_install ] || \
  make ARCH=mips INSTALL_HDR_PATH=dest headers_install || \
    die "***install headers error" && \
      touch ${METADATAMIPSELTOOLCHAIN}/linux_headers_install
[ -f ${METADATAMIPSELTOOLCHAIN}/linux_headers_copy ] || \
  cp -r dest/include/* ${PREFIXMIPSELROOTFS}/usr/include || \
    die "***copy headers error" && \
      touch ${METADATAMIPSELTOOLCHAIN}/linux_headers_copy
[ -f ${METADATAMIPSELTOOLCHAIN}/linux_headers_find ] || \
  find ${PREFIXMIPSELROOTFS}/usr/include -name .install \
  -or -name ..install.cmd | xargs rm -fv || \
    die "***install headers error" && \
      touch ${METADATAMIPSELTOOLCHAIN}/linux_headers_find
popd

pushd ${BUILDMIPSELTOOLCHAIN}
[ -d "gmp_build" ] || mkdir gmp_build
cd gmp_build
[ -f ${METADATAMIPSELTOOLCHAIN}/gmp_configure ] || \
  CPPFLAGS=-fexceptions \
    ${SRCMIPSELTOOLCHAIN}/gmp-${GMP_VERSION}/configure \
    --prefix=${PREFIXMIPSELTOOLCHAIN} --enable-cxx || \
      die "***config gmp error" && \
        touch ${METADATAMIPSELTOOLCHAIN}/gmp_configure
[ -f ${METADATAMIPSELTOOLCHAIN}/gmp_build ] || \
  make -j${JOBS} || die "***build gmp error" && \
    touch ${METADATAMIPSELTOOLCHAIN}/gmp_build
[ -f ${METADATAMIPSELTOOLCHAIN}/gmp_install ] || \
  make install || die "***install gmp error" && \
    touch ${METADATAMIPSELTOOLCHAIN}/gmp_install
popd

pushd ${BUILDMIPSELTOOLCHAIN}
[ -d "mpfr_build" ] || mkdir mpfr_build
cd mpfr_build
[ -f ${METADATAMIPSELTOOLCHAIN}/mpfr_configure ] || \
  LDFLAGS="-Wl,-rpath,${PREFIXMIPSELTOOLCHAIN}/lib" \
  ${SRCMIPSELTOOLCHAIN}/mpfr-${MPFR_VERSION}/configure \
  --prefix=${PREFIXMIPSELTOOLCHAIN} \
  --with-gmp=${PREFIXMIPSELTOOLCHAIN} --enable-shared || \
    die "***config mpfr error" && \
      touch ${METADATAMIPSELTOOLCHAIN}/mpfr_configure
[ -f ${METADATAMIPSELTOOLCHAIN}/mpfr_build ] || \
  make -j${JOBS} || \
    die "***build mpfr error" && \
      touch ${METADATAMIPSELTOOLCHAIN}/mpfr_build
[ -f ${METADATAMIPSELTOOLCHAIN}/mpfr_install ] || \
  make install || \
    die "***install mpfr error" && \
      touch ${METADATAMIPSELTOOLCHAIN}/mpfr_install
popd

pushd ${BUILDMIPSELTOOLCHAIN}
[ -d "mpc_build" ] || mkdir mpc_build
cd mpc_build
[ -f ${METADATAMIPSELTOOLCHAIN}/mpc_configure ] || \
  LDFLAGS="-Wl,-rpath,${PREFIXMIPSELTOOLCHAIN}/lib" \
  ${SRCMIPSELTOOLCHAIN}/mpc-${MPC_VERSION}/configure \
  --prefix=${PREFIXMIPSELTOOLCHAIN} \
  --with-gmp=${PREFIXMIPSELTOOLCHAIN} \
  --with-mpfr=${PREFIXMIPSELTOOLCHAIN} || \
    die "***config mpc error" && \
      touch ${METADATAMIPSELTOOLCHAIN}/mpc_configure
[ -f ${METADATAMIPSELTOOLCHAIN}/mpc_build ] || \
  make -j${JOBS} || die "***build mpc error" && \
    touch ${METADATAMIPSELTOOLCHAIN}/mpc_build
[ -f ${METADATAMIPSELTOOLCHAIN}/mpc_install ] || \
  make install || die "***install mpc error" && \
    touch ${METADATAMIPSELTOOLCHAIN}/mpc_install
popd

pushd ${BUILDMIPSELTOOLCHAIN}
[ -d "ppl_build" ] || mkdir ppl_build
cd ppl_build
[ -f ${METADATAMIPSELTOOLCHAIN}/ppl_configure ] || \
  LDFLAGS="-Wl,-rpath,${PREFIXMIPSELTOOLCHAIN}/lib" \
  ${SRCMIPSELTOOLCHAIN}/ppl-${PPL_VERSION}/configure \
  --prefix=${PREFIXMIPSELTOOLCHAIN} --enable-shared \
  --enable-interfaces="c,cxx" --disable-optimization \
  --with-gmp=${PREFIXMIPSELTOOLCHAIN} || \
    die "***config ppl error" && \
      touch ${METADATAMIPSELTOOLCHAIN}/ppl_configure
[ -f ${METADATAMIPSELTOOLCHAIN}/ppl_build ] || \
  make -j${JOBS} || die "***build ppl error" && \
    touch ${METADATAMIPSELTOOLCHAIN}/ppl_build
[ -f ${METADATAMIPSELTOOLCHAIN}/ppl_install ] || \
  make install || die "***install ppl error" && \
    touch ${METADATAMIPSELTOOLCHAIN}/ppl_install
popd

pushd ${BUILDMIPSELTOOLCHAIN}
[ -d "cloog_build" ] || mkdir cloog_build
cd cloog_build
[ -f ${METADATAMIPSELTOOLCHAIN}/cloog_configure ] || \
  LDFLAGS="-Wl,-rpath,${PREFIXMIPSELTOOLCHAIN}/lib" \
  ${SRCMIPSELTOOLCHAIN}/cloog-${CLOOG_VERSION}/configure \
  --prefix=${PREFIXMIPSELTOOLCHAIN} --enable-shared \
  --with-gmp-prefix=${PREFIXMIPSELTOOLCHAIN} || \
    die "***config cloog error" && \
      touch ${METADATAMIPSELTOOLCHAIN}/cloog_configure
[ -f ${METADATAMIPSELTOOLCHAIN}/cloog_build ] || \
  make -j${JOBS} || die "***build cloog error" && \
    touch ${METADATAMIPSELTOOLCHAIN}/cloog_build
[ -f ${METADATAMIPSELTOOLCHAIN}/cloog_install ] || \
  make install || die "***install cloog error" && \
    touch ${METADATAMIPSELTOOLCHAIN}/cloog_install
popd

pushd ${BUILDMIPSELTOOLCHAIN}
[ -d "binutils-build" ] || mkdir binutils-build
cd binutils-build
[ -f ${METADATAMIPSELTOOLCHAIN}/binutils_configure ] || \
  AS="as" AR="ar" \
  ${SRCMIPSELTOOLCHAIN}/binutils-${BINUTILS_VERSION}/configure \
  --prefix=${PREFIXMIPSELTOOLCHAIN} \
  --host=${CROSS_HOST} --target=${CROSS_TARGET32} \
  --with-sysroot=${PREFIXMIPSELROOTFS} --disable-nls \
  --enable-shared \
  --disable-multilib || \
    die "***config binutils error" && \
      touch ${METADATAMIPSELTOOLCHAIN}/binutils_configure
[ -f ${METADATAMIPSELTOOLCHAIN}/binutils_build_host ] || \
  make configure-host || \
    die "config binutils host error" && \
      touch ${METADATAMIPSELTOOLCHAIN}/binutils_build_host
[ -f ${METADATAMIPSELTOOLCHAIN}/binutils_build ] || \
  make -j${JOBS} || \
    die "***build binutils error" && \
      touch ${METADATAMIPSELTOOLCHAIN}/binutils_build
[ -f ${METADATAMIPSELTOOLCHAIN}/binutils_install ] || \
  make install || \
    die "***install binutils error" && \
      touch ${METADATAMIPSELTOOLCHAIN}/binutils_install
[ -f ${METADATAMIPSELTOOLCHAIN}/binutils_headers_copy ] || \
  cp ${SRCMIPSELTOOLCHAIN}/binutils-${BINUTILS_VERSION}/include/libiberty.h ${PREFIXMIPSELROOTFS}/usr/include || \
    die "***copy binutils header error" && \
      touch ${METADATAMIPSELTOOLCHAIN}/binutils_headers_copy
popd

pushd ${BUILDMIPSELTOOLCHAIN}
[ -d "gcc-static-build" ] || mkdir gcc-static-build
cd gcc-static-build
[ -f ${METADATAMIPSELTOOLCHAIN}/gcc_static_configure ] || \
  AR=ar LDFLAGS="-Wl,-rpath,${PREFIXMIPSELTOOLCHAIN}/lib" \
  ${SRCMIPSELTOOLCHAIN}/gcc-${GCC_VERSION}/configure \
  --prefix=${PREFIXMIPSELTOOLCHAIN} \
  --build=${CROSS_HOST} --host=${CROSS_HOST} \
  --target=${CROSS_TARGET32} --with-sysroot=${PREFIXMIPSELROOTFS} \
  --disable-multilib --disable-nls \
  --without-headers --with-newlib --disable-decimal-float \
  --disable-libgomp --disable-libmudflap --disable-libssp \
  --with-mpfr=${PREFIXMIPSELTOOLCHAIN} \
  --with-gmp=${PREFIXMIPSELTOOLCHAIN} \
  --with-ppl=${PREFIXMIPSELTOOLCHAIN} \
  --with-cloog=${PREFIXMIPSELTOOLCHAIN} \
  --with-mpc=${PREFIXMIPSELTOOLCHAIN} \
  --disable-shared --disable-threads --enable-languages=c \
  --enable-cloog-backend=isl || \
    die "***config gcc static stage1 error" && \
      touch ${METADATAMIPSELTOOLCHAIN}/gcc_static_configure
[ -f ${METADATAMIPSELTOOLCHAIN}/gcc_static_build ] || \
  make -j${JOBS} all-gcc all-target-libgcc || \
    die "***build gcc static stage1 error" && \
      touch ${METADATAMIPSELTOOLCHAIN}/gcc_static_build
[ -f ${METADATAMIPSELTOOLCHAIN}/gcc_static_install ] || \
  make install-gcc install-target-libgcc || \
    die "***install gcc static stage1 error" && \
      touch ${METADATAMIPSELTOOLCHAIN}/gcc_static_install
popd

pushd ${SRCMIPSELTOOLCHAIN}
if [ ${HOSTOS} = "Darwin" ]; then
cd glibc-${GLIBC_VERSION}
[ -f "${METADATAMIPSELTOOLCHAIN}/glibc_macos_patch" ] || \
  patch -p1 < ${PATCH}/glibc-2.17-os-x-build.patch || \
    die "***patch glibc for macosx error" && \
      touch ${METADATAMIPSELTOOLCHAIN}/glibc_macos_patch
fi
popd

pushd ${BUILDMIPSELTOOLCHAIN}
[ -d "glibc-build" ] || mkdir glibc-build
cd glibc-build
[ -f ${METADATAMIPSELTOOLCHAIN}/glibc_config ] || \
cat > config.cache << "EOF"
lic_cv_forced_unwind=yes
libc_cv_c_cleanup=yes
libc_cv_gnu89_inline=yes
EOF
cat > configparms << EOF
install_root=${PREFIXMIPSELROOTFS}
EOF
[ -f ${METADATAMIPSELTOOLCHAIN}/glibc_configure ] || \
  BUILD_CC="gcc" CC="${CROSS_TARGET32}-gcc" \
  AR="${CROSS_TARGET32}-ar" \
  RANLIB="${CROSS_TARGET32}-ranlib" \
  CFLAGS_FOR_TARGET="-O2" CFLAGS+="-O2" \
  ${SRCMIPSELTOOLCHAIN}/glibc-${GLIBC_VERSION}/configure \
  --prefix=/usr \
  --libexecdir=/usr/lib/glibc --host=${CROSS_TARGET32} \
  --build=${CROSS_HOST} \
  --disable-profile --enable-add-ons --with-tls --enable-kernel=2.6.0 \
  --with-__thread --with-binutils=${PREFIXMIPSELTOOLCHAIN}/bin \
  --with-headers=${PREFIXMIPSELROOTFS}/usr/include \
  --cache-file=config.cache ||\
    die "***config glibc error" && \
      touch ${METADATAMIPSELTOOLCHAIN}/glibc_configure
[ -f ${METADATAMIPSELTOOLCHAIN}/glibc_build ] || \
  make || die "***build glibc error" && \
    touch ${METADATAMIPSELTOOLCHAIN}/glibc_build
[ -f ${METADATAMIPSELTOOLCHAIN}/glibc_install ] || \
  make install || \
    die "***install glibc error" && \
      touch ${METADATAMIPSELTOOLCHAIN}/glibc_install
popd

pushd ${BUILDMIPSELTOOLCHAIN}
[ -d "gcc-build" ] || mkdir gcc-build
cd gcc-build
[ -f ${METADATAMIPSELTOOLCHAIN}/gcc_configure ] || \
  AR=ar LDFLAGS="-Wl,-rpath,${PREFIXMIPSELTOOLCHAIN}/lib" \
  ${SRCMIPSELTOOLCHAIN}/gcc-${GCC_VERSION}/configure \
  --prefix=${PREFIXMIPSELTOOLCHAIN} \
  --build=${CROSS_HOST} --host=${CROSS_HOST} \
  --target=${CROSS_TARGET32} \
  --disable-multilib --with-sysroot=${PREFIXMIPSELROOTFS} --disable-nls \
  --enable-shared --enable-languages=c,c++ --enable-__cxa_atexit \
  --with-mpfr=${PREFIXMIPSELTOOLCHAIN} \
  --with-gmp=${PREFIXMIPSELTOOLCHAIN} \
  --with-ppl=${PREFIXMIPSELTOOLCHAIN} \
  --with-cloog=${PREFIXMIPSELTOOLCHAIN} \
  --with-mpc=${PREFIXMIPSELTOOLCHAIN} \
  --enable-c99 --enable-long-long --enable-threads=posix \
  --enable-cloog-backend=isl || \
    die "***config gcc stage2 error" && \
      touch ${METADATAMIPSELTOOLCHAIN}/gcc_configure
[ -f ${METADATAMIPSELTOOLCHAIN}/gcc_build ] || \
  make -j${JOBS} \
  AS_FOR_TARGET="${CROSS_TARGET32}-as" \
  LD_FOR_TARGET="${CROSS_TARGET32}-ld" || \
    die "***build gcc stage2 error" && \
      touch ${METADATAMIPSELTOOLCHAIN}/gcc_build
[ -f ${METADATAMIPSELTOOLCHAIN}/gcc_install ] || \
  make install || \
    die "***install gcc stage2 error" && \
      touch ${METADATAMIPSELTOOLCHAIN}/gcc_install
popd

pushd ${BUILDMIPSELTOOLCHAIN}
[ -d "file_build" ] || mkdir file_build
cd file_build
[ -f ${METADATAMIPSELTOOLCHAIN}/file_configure ] || \
  ${SRCMIPSELTOOLCHAIN}/file-${FILE_VERSION}/configure \
  --prefix=${PREFIXMIPSELTOOLCHAIN} || \
    die "***config file error" && \
      touch ${METADATAMIPSELTOOLCHAIN}/file_configure
[ -f ${METADATAMIPSELTOOLCHAIN}/file_build ] || \
  make -j${JOBS} || \
    die "***build file error" && \
      touch ${METADATAMIPSELTOOLCHAIN}/file_build
[ -f ${METADATAMIPSELTOOLCHAIN}/file_install ] || \
  make install || \
    die "***install file error" && \
      touch ${METADATAMIPSELTOOLCHAIN}/file_install
popd

pushd ${BUILDMIPSELTOOLCHAIN}
[ -d "groff_build" ] || mkdir groff_build
cd groff_build
[ -f ${METADATAMIPSELTOOLCHAIN}/groff_configure ] || \
  PAGE=A4 ${SRCMIPSELTOOLCHAIN}/groff-${GROFF_VERSION}/configure \
  --prefix=${PREFIXMIPSELTOOLCHAIN} --without-x || \
    die "***config groff error" && \
      touch ${METADATAMIPSELTOOLCHAIN}/groff_configure
[ -f ${METADATAMIPSELTOOLCHAIN}/groff_build ] || \
  make -j${JOBS} || \
    die "***build groff error" && \
      touch ${METADATAMIPSELTOOLCHAIN}/groff_build
[ -f ${METADATAMIPSELTOOLCHAIN}/groff_install ] || \
  make install || \
    die "***install groff error" && \
      touch ${METADATAMIPSELTOOLCHAIN}/groff_install
popd

pushd ${SRCMIPSELTOOLCHAIN}
cd shadow-${SHADOW_VERSION}
[ -f ${METADATAMIPSELTOOLCHAIN}/shadow_patch ] || \
  patch -p1 < ${PATCH}/shadow-${SHADOW_VERSION}-sysroot_hacks-1.patch || \
    die "Patch shadow error" && \
      touch ${METADATAMIPSELTOOLCHAIN}/shadow_patch
popd

pushd ${BUILDMIPSELTOOLCHAIN}
[ -d "shadow_build" ] || mkdir shadow_build
cd shadow_build
cat > config.cache << EOF
shadow_cv_passwd_dir="${PREFIXMIPSELROOTFS}/bin"
EOF
cat >> config.cache << EOF
ac_cv_func_lckpwdf=no
EOF
[ -f ${METADATAMIPSELTOOLCHAIN}/shadow_configure ] || \
  ${SRCMIPSELTOOLCHAIN}/shadow-${SHADOW_VERSION}/configure \
  --prefix=${PREFIXMIPSELTOOLCHAIN} \
  --sbindir=${PREFIXMIPSELTOOLCHAIN}/bin \
  --sysconfdir=$PREFIXMIPSELROOTFS/etc \
  --disable-shared --without-libpam \
  --without-audit --without-selinux \
  --program-prefix=${CROSS_TARGET32}- \
  --without-nscd --cache-file=config.cache || \
    die "***config shadow error" && \
      touch ${METADATAMIPSELTOOLCHAIN}/shadow_configure
[ -f ${METADATAMIPSELTOOLCHAIN}/cp_config ] || \
  cp config.h{,.orig} || \
    die "***copy config error" && \
      touch ${METADATAMIPSELTOOLCHAIN}/cp_config
[ -f ${METADATAMIPSELTOOLCHAIN}/cp_config_sed ] || \
  sed "/PASSWD_PROGRAM/s/passwd/${CROSS_TARGET32}-&/" config.h.orig > config.h || \
    die "***sed config.h error" && \
      touch ${METADATAMIPSELTOOLCHAIN}/cp_config_sed
[ -f ${METADATAMIPSELTOOLCHAIN}/shadow_build ] || \
  make -j${JOBS} || \
    die "***build shadow error" && \
      touch ${METADATAMIPSELTOOLCHAIN}/shadow_build
[ -f ${METADATAMIPSELTOOLCHAIN}/shadow_install ] || \
  make install || \
    die "***install shadow error" && \
      touch ${METADATAMIPSELTOOLCHAIN}/shadow_install
popd

pushd ${SRCMIPSELTOOLCHAIN}
cd ncurses-${NCURSES_VERSION}
[ -f ${METADATAMIPSELTOOLCHAIN}/ncurses_patch ] || \
  patch -Np1 -i ${PATCH}/ncurses-5.9-bash_fix-1.patch || \
    die "***patch ncurses error" && \
      touch ${METADATAMIPSELTOOLCHAIN}/ncurses_patch
popd

pushd ${BUILDMIPSELTOOLCHAIN}
[ -d "ncurses_build" ] || mkdir ncurses_build
cd ncurses_build
[ -f ${METADATAMIPSELTOOLCHAIN}/ncurses_configure ] || \
  ${SRCMIPSELTOOLCHAIN}/ncurses-${NCURSES_VERSION}/configure \
  --prefix=${PREFIXMIPSELTOOLCHAIN} \
  --without-debug --without-shared || \
    die "***config ncurses error" && \
      touch ${METADATAMIPSELTOOLCHAIN}/ncurses_configure
[ -f ${METADATAMIPSELTOOLCHAIN}/ncurses_include_build ] || \
  make -C include || \
    die "***build ncurses include error" && \
      touch ${METADATAMIPSELTOOLCHAIN}/ncurses_include_build
[ -f ${METADATAMIPSELTOOLCHAIN}/ncurses_tic_build ] || \
  make -C progs tic || \
    die "***build ncurses tic error" && \
      touch ${METADATAMIPSELTOOLCHAIN}/ncurses_tic_build
[ -f ${METADATAMIPSELTOOLCHAIN}/ncurses_install ] || \
  install -m755 progs/tic ${PREFIXMIPSELTOOLCHAIN}/bin || \
    die "***install ncurses error" && \
      touch ${METADATAMIPSELTOOLCHAIN}/ncurses_install
popd

touch ${METADATAMIPSELTOOLCHAIN}/mipsel_tools_finished
