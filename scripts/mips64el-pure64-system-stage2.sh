#! /bin/bash

source source.sh

[ -d "${SRCPURE64ELSTAGE2}" ] || mkdir -p "${SRCPURE64ELSTAGE2}"
[ -d "${BUILDPURE64ELSTAGE2}" ] || mkdir -p "${BUILDPURE64ELSTAGE2}"

[ -d "${PREFIX}" ] || mkdir -p ${PREFIX}
[ -d "${PREFIXPURE64EL}" ] || mkdir -p ${PREFIXPURE64EL}
[ -d "${PREFIXPURE64EL}/tools" ] || mkdir -p ${PREFIXPURE64EL}/tools
[ -d "/tools" ] || sudo ln -s ${PREFIXPURE64EL}/tools /
[ -d "${PREFIXPURE64EL}/cross-tools" ] || mkdir -p ${PREFIXPURE64EL}/cross-tools
[ -d "/cross-tools" ] || sudo ln -s ${PREFIXPURE64EL}/cross-tools /

[ -f "/cross-tools/bin/${CROSS_TARGET64}-gcc" ] || die "No tool chain found"

export PATH=${PATH}:/cross-tools/bin/

export CC="${CROSS_TARGET64}-gcc"
export CXX="${CROSS_TARGET64}-g++"
export AR="${CROSS_TARGET64}-ar"
export AS="${CROSS_TARGET64}-as"
export RANLIB="${CROSS_TARGET64}-ranlib"
export LD="${CROSS_TARGET64}-ld"
export STRIP="${CROSS_TARGET64}-strip"

pushd ${SRCPURE64ELSTAGE2}
[ -d "gmp-${GMP_VERSION}" ] \
  || tar xf ${TARBALL}/gmp-${GMP_VERSION}.${GMP_SUFFIX}
cd gmp-${GMP_VERSION}
[ -f "config.log" ] || HOST_CC=gcc \
  CPPFLAGS=-fexceptions CC="${CC} ${BUILD64}" \
  CXX="${CXX} ${BUILD64}" ./configure --prefix=/tools \
  --build=${CROSS_HOST} --host=${CROSS_TARGET64} \
  --enable-cxx || die "***config gmp error"
make -j${JOBS} || die "***make gmp error"
make install || die "***install gmp error"
popd

pushd ${SRCPURE64ELSTAGE2}
[ -d "mpfr-${MPFR_VERSION}" ] \
  || tar xf ${TARBALL}/mpfr-${MPFR_VERSION}.${MPFR_SUFFIX}
cd mpfr-${MPFR_VERSION}
[ -f "config.log" ] || CC="${CC} ${BUILD64}"  \
  ./configure --prefix=/tools \
  --build=${CROSS_HOST} --host=${CROSS_TARGET64} \
  --enable-shared || die "***config mpfr error"
make -j${JOBS} || die "***build mpfr error"
make install || die "***install mpfr error"
popd

pushd ${SRCPURE64ELSTAGE2}
[ -d "mpc-${MPC_VERSION}" ] \
  || tar xf ${TARBALL}/mpc-${MPC_VERSION}.${MPC_SUFFIX}
cd mpc-${MPC_VERSION}
[ -f "config.log" ] || CC="${CC} ${BUILD64}" \
  EGREP="grep -E" ./configure --prefix=/tools \
  --build=${CROSS_HOST} --host=${CROSS_TARGET64} \
  || die "***config mpc error"
make -j${JOBS} || die "***build mpc error"
make install || die "***install mpc error"
popd


pushd ${SRCPURE64ELSTAGE2}
[ -d "ppl-${PPL_VERSION}" ] \
  || tar xf ${TARBALL}/ppl-${PPL_VERSION}.${PPL_SUFFIX}
cd ppl-${PPL_VERSION}
[ -f "config.log" ] || 
CC="${CC} ${BUILD64}" ./configure --prefix=/tools \
  --build=${CROSS_HOST} --host=${CROSS_TARGET64} \
  --enable-interfaces="c,cxx" --enable-shared \
  --disable-optimization --with-libgmp-prefix=/tools \
  --with-libgmpxx-prefix=/tools \
  || die "***config file error"
make -j${JOBS} || die "***build ppl error"
make install || die "***install ppl error"
popd

pushd ${SRCPURE64ELSTAGE2}
[ -d "cloog-${CLOOG_VERSION}" ] \
  || tar xf ${TARBALL}/cloog-${CLOOG_VERSION}.${CLOOG_SUFFIX}
cd cloog-${CLOOG_VERSION}
cp -v configure{,.orig}
sed -e "/LD_LIBRARY_PATH=/d" \
    configure.orig > configure
[ -f "config.log" ] || 
CC="${CC} ${BUILD64}" ./configure --prefix=/tools \
  --build=${CROSS_HOST} --host=${CROSS_TARGET64} \
  --enable-shared --with-gmp-prefix=/tools \
  || die "***config file error"
make -j${JOBS} || die "***build cloog error"
make install || die "***install cloog error"
popd

pushd ${SRCPURE64ELSTAGE2}
[ -d "zlib-${ZLIB_VERSION}" ] \
  || tar xf ${TARBALL}/zlib-${ZLIB_VERSION}.${ZLIB_SUFFIX}
cd zlib-${ZLIB_VERSION}
[ -f "config.log" ] || CC="${CC} ${BUILD64}" \
  ./configure --prefix=/tools   || die "***config zlib error"
make -j${JOBS} || die "***build zlib error"
make install || die "***install zlib error"
popd

pushd ${SRCPURE64ELSTAGE2}
[ -d "binutils-${BINUTILS_VERSION}" ] \
  || tar xf ${TARBALL}/binutils-${BINUTILS_VERSION}.${BINUTILS_SUFFIX}
popd

pushd ${BUILDPURE64ELSTAGE2}
[ -d "binutils-build" ] || mkdir binutils-build
cd binutils-build
[ -f "config.log" ] || CC="${CC} ${BUILD64}" \
  ${SRCPURE64ELSTAGE2}/binutils-${BINUTILS_VERSION}/configure \
  --prefix=/tools --build=${CROSS_HOST} --host=${CROSS_TARGET64} \
  --target=${CROSS_TARGET64} --with-lib-path=/tools/lib --disable-nls \
  --enable-shared --enable-64-bit-bfd --disable-multilib \
  --with-ppl=/tools --with-cloog=/tools \
  --enable-cloog-backend=isl || die "***config file error"
make configure-host || die "config binutils host error"
make -j${JOBS} || die "***build binutils error"
make install || die "***install binutils error"
popd

pushd ${SRCPURE64ELSTAGE2}
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
popd

pushd ${BUILDPURE64ELSTAGE2}
[ -d "gcc-build" ] \
  || mkdir gcc-build
cd gcc-build
[ -f "config.log" ] || CC="${CC} ${BUILD64}" \
  CXX="${CXX} ${BUILD64}" ${SRCPURE64ELSTAGE2}/gcc-${GCC_VERSION}/configure \
  --prefix=/tools --disable-multilib \
  --build=${CROSS_HOST} --host=${CROSS_TARGET64} \
  --target=${CROSS_TARGET64} --libexecdir=/tools/lib \
  --with-local-prefix=/tools --enable-long-long \
  --enable-c99 --enable-shared --enable-threads=posix \
  --disable-nls --enable-__cxa_atexit \
  --enable-languages=c,c++ --disable-libstdcxx-pch \
  --enable-cloog-backend=isl || die "***config gcc error"
cp -v Makefile{,.orig}
sed "/^HOST_\(GMP\|PPL\|CLOOG\)\(LIBS\|INC\)/s:-[IL]/\(lib\|include\)::" \
    Makefile.orig > Makefile
make AS_FOR_TARGET="${AS}" LD_FOR_TARGET="${LD}" \
  || die "***build gcc error"
make install || die "***install gcc error"
popd

pushd ${SRCPURE64ELSTAGE2}
[ -d "ncurses-${NCURSES_VERSION}" ] \
  || tar xf ${TARBALL}/ncurses-${NCURSES_VERSION}.${NCURSES_SUFFIX}
cd ncurses-${NCURSES_VERSION}
patch -Np1 -i ${PATCH}/ncurses-5.9-bash_fix-1.patch \
  || die "***patch ncurses error"
[ -f "config.log" ] || CC="${CC} ${BUILD64}" \
  CXX="${CXX} ${BUILD64}" ./configure --prefix=/tools \
  --with-shared --build=${CROSS_HOST} --host=${CROSS_TARGET64} \
  --without-debug --without-ada --enable-overwrite \
  --with-build-cc=gcc || die "***config ncurses error"
make -j${JOBS} || die "***build ncurses error"
make install || die "***install ncurses error"
popd

pushd ${SRCPURE64ELSTAGE2}
[ -d "bash-${BASH_VERSION}" ] \
  || tar xf ${TARBALL}/bash-${BASH_VERSION}.${BASH_SUFFIX}
cd bash-${BASH_VERSION}
patch -Np1 -i ${PATCH}/bash-4.2-branch_update-4.patch
cat > config.cache << "EOF"
ac_cv_func_mmap_fixed_mapped=yes
ac_cv_func_strcoll_works=yes
ac_cv_func_working_mktime=yes
bash_cv_func_sigsetjmp=present
bash_cv_getcwd_malloc=yes
bash_cv_job_control_missing=present
bash_cv_printf_a_format=yes
bash_cv_sys_named_pipes=present
bash_cv_ulimit_maxfds=yes
bash_cv_under_sys_siglist=yes
bash_cv_unusable_rtsigs=no
gt_cv_int_divbyzero_sigfpe=yes
EOF
[ -f "config.log" ] || CC="${CC} ${BUILD64}" \
  CXX="${CXX} ${BUILD64}" ./configure --prefix=/tools \
  --build=${CROSS_HOST} --host=${CROSS_TARGET64} \
  --without-bash-malloc --cache-file=config.cache \
  || die "***config bash error"
make -j${JOBS} || die "***build bash error"
make install || die "***install bash error"
ln -s bash /tools/bin/sh || die "***link bash error"
popd

pushd ${SRCPURE64ELSTAGE2}
[ -d "bison-${BISON_VERSION}" ] \
  || tar xf ${TARBALL}/bison-${BISON_VERSION}.${BISON_SUFFIX}
cd bison-${BISON_VERSION}
[ -f "config.log" ] || CC="${CC} ${BUILD64}" \
  ./configure --prefix=/tools --build=${CROSS_HOST} \
  --host=${CROSS_TARGET64} || die "***config bison error"
make -j${JOBS} || die "***build bison error"
make install || die "***install bison error"
popd

pushd ${SRCPURE64ELSTAGE2}
[ -d "bzip2-${BZIP2_VERSION}" ] \
  || tar xf ${TARBALL}/bzip2-${BZIP2_VERSION}.${BZIP2_SUFFIX}
cd bzip2-${BZIP2_VERSION}
cp -v Makefile{,.orig}
sed -e 's@^\(all:.*\) test@\1@g' Makefile.orig > Makefile
make CC="${CC} ${BUILD64}" AR="${AR}" RANLIB="${RANLIB}" \
  || die "***build bzip2 error"
make PREFIX=/tools install || die "install bzip2 error"
popd

pushd ${SRCPURE64ELSTAGE2}
[ -d "coreutils-${COREUTILS_VERSION}" ] \
  || tar xf ${TARBALL}/coreutils-${COREUTILS_VERSION}.${COREUTILS_SUFFIX}
cd coreutils-${COREUTILS_VERSION}
touch man/uname.1 man/hostname.1
cat > config.cache << EOF
fu_cv_sys_stat_statfs2_bsize=yes
gl_cv_func_working_mkstemp=yes
EOF
[ -f "config.log" ] || CC="${CC} ${BUILD64}" \
  ./configure --prefix=/tools --build=${CROSS_HOST} \
  --host=${CROSS_TARGET64} --enable-install-program=hostname \
  --cache-file=config.cache || die "***config coreutils error"
make -j${JOBS} || die "***build coreutils error"
make install || die "***install coreutils error"
popd

pushd ${SRCPURE64ELSTAGE2}
[ -d "diffutils-${DIFFUTILS_VERSION}" ] \
  || tar xf ${TARBALL}/diffutils-${DIFFUTILS_VERSION}.${DIFFUTILS_SUFFIX}
cd diffutils-${DIFFUTILS_VERSION}
[ -f "config.log" ] || CC="${CC} ${BUILD64}" \
  ./configure --prefix=/tools --build=${CROSS_HOST} \
  --host=${CROSS_TARGET64} || die "***config diffutils error"
make -j${JOBS} || die "***build diffutils error"
make install || die "***install diffutils error"
popd

pushd ${SRCPURE64ELSTAGE2}
[ -d "findutils-${FINDUTILS_VERSION}" ] \
  || tar xf ${TARBALL}/findutils-${FINDUTILS_VERSION}.${FINDUTILS_SUFFIX}
cd findutils-${FINDUTILS_VERSION}
echo "gl_cv_func_wcwidth_works=yes" > config.cache
echo "ac_cv_func_fnmatch_gnu=yes" >> config.cache
[ -f "config.log" ] || CC="${CC} ${BUILD64}" \
  ./configure --prefix=/tools --build=${CROSS_HOST} \
  --host=${CROSS_TARGET64} --cache-file=config.cache \
  || die "***config findutils error"
make -j${JOBS} || die "***build findutils error"
make install || die "***install findutils error"
popd

pushd ${SRCPURE64ELSTAGE2}
[ -d "file-${FILE_VERSION}" ] \
  || tar xf ${TARBALL}/file-${FILE_VERSION}.${FILE_SUFFIX}
cd file-${FILE_VERSION}
[ -f "config.log" ] || CC="${CC} ${BUILD64}" \
  ./configure --prefix=/tools --build=${CROSS_HOST} \
  --host=${CROSS_TARGET64} || die "***config file error"
make -j${JOBS} || die "***build file error"
make install || die "***install file error"
popd

pushd ${SRCPURE64ELSTAGE2}
[ -d "flex-${FLEX_VERSION}" ] \
  || tar xf ${TARBALL}/flex-${FLEX_VERSION}.${FLEX_SUFFIX}
cd flex-${FLEX_VERSION}
patch -Np1 -i ${PATCH}/flex-2.5.35-gcc44-1.patch \
  || die "***patch flex error"
cat > config.cache << EOF
ac_cv_func_malloc_0_nonnull=yes
ac_cv_func_realloc_0_nonnull=yes
EOF
[ -f "config.log" ] || CC="${CC} ${BUILD64}" \
  ./configure --prefix=/tools --build=${CROSS_HOST} \
  --host=${CROSS_TARGET64} --cache-file=config.cache \
  || die "***config flex error"
make -j${JOBS} || die "***build flex error"
make install || die "***install flex error"
popd

pushd ${SRCPURE64ELSTAGE2}
[ -d "gawk-${GAWK_VERSION}" ] \
  || tar xf ${TARBALL}/gawk-${GAWK_VERSION}.${GAWK_SUFFIX}
cd gawk-${GAWK_VERSION}
[ -f "config.log" ] || CC="${CC} ${BUILD64}" \
  ./configure --prefix=/tools --build=${CROSS_HOST} \
  --host=${CROSS_TARGET64} || die "***config gawk error"
make -j${JOBS} || die "***build gawk error"
make install || die "***install gawk error"
popd

pushd ${SRCPURE64ELSTAGE2}
[ -d "gettext-${GETTEXT_VERSION}" ] \
  || tar xf ${TARBALL}/gettext-${GETTEXT_VERSION}.${GETTEXT_SUFFIX}
cd gettext-${GETTEXT_VERSION}
cd gettext-tools
echo "gl_cv_func_wcwidth_works=yes" > config.cache
[ -f "config.log" ] || CC="${CC} ${BUILD64}" \
  CXX="${CXX} ${BUILD64}" ./configure --prefix=/tools \
  --disable-shared --build=${CROSS_HOST} \
  --host=${CROSS_TARGET64} --cache-file=config.cache \
  || die "***config gettext error"
make -C gnulib-lib || die "***build gettext gnulib-lib error"
make -C src msgfmt || die "***build gettext msgfmt error"
cp -v src/msgfmt /tools/bin || die "***install gettext error"
popd

pushd ${SRCPURE64ELSTAGE2}
[ -d "grep-${GREP_VERSION}" ] \
  || tar xf ${TARBALL}/grep-${GREP_VERSION}.${GREP_SUFFIX}
cd grep-${GREP_VERSION}
cat > config.cache << EOF
ac_cv_func_malloc_0_nonnull=yes
ac_cv_func_realloc_0_nonnull=yes
EOF
[ -f "config.log" ] || CC="${CC} ${BUILD64}" \
  ./configure --prefix=/tools --build=${CROSS_HOST} \
  --host=${CROSS_TARGET64} --disable-perl-regexp \
  --without-included-regex --cache-file=config.cache \
  || die "***config grep error"
make -j${JOBS} || die "***build grep error"
make install || die "***install grep error"
popd

pushd ${SRCPURE64ELSTAGE2}
[ -d "gzip-${GZIP_VERSION}" ] \
  || tar xf ${TARBALL}/gzip-${GZIP_VERSION}.${GZIP_SUFFIX}
cd gzip-${GZIP_VERSION}
[ -f "config.log" ] || CC="${CC} ${BUILD64}" \
  ./configure --prefix=/tools \
  --build=${CROSS_HOST} --host=${CROSS_TARGET64} \
  || die "***config gzip error"
make -j${JOBS} || die "***build gzip error"
make install || die "***install gzip error"
popd

pushd ${SRCPURE64ELSTAGE2}
[ -d "m4-${M4_VERSION}" ] \
  || tar xf ${TARBALL}/m4-${M4_VERSION}.${M4_SUFFIX}
cd m4-${M4_VERSION}
cat > config.cache << EOF
gl_cv_func_btowc_eof=yes
gl_cv_func_mbrtowc_incomplete_state=yes
gl_cv_func_mbrtowc_sanitycheck=yes
gl_cv_func_mbrtowc_null_arg=yes
gl_cv_func_mbrtowc_retval=yes
gl_cv_func_mbrtowc_nul_retval=yes
gl_cv_func_wcrtomb_retval=yes
gl_cv_func_wctob_works=yes
EOF
[ -f "config.log" ] || CC="${CC} ${BUILD64}" \
  ./configure --prefix=/tools \
  --build=${CROSS_HOST} --host=${CROSS_TARGET64} \
  --cache-file=config.cache || die "***config m4 error"
make -j${JOBS} || die "***build m4 error"
make install || die "***install m4 error"
popd

pushd ${SRCPURE64ELSTAGE2}
[ -d "make-${MAKE_VERSION}" ] \
  || tar xf ${TARBALL}/make-${MAKE_VERSION}.${MAKE_SUFFIX}
cd make-${MAKE_VERSION}
[ -f "config.log" ] || CC="${CC} ${BUILD64}" \
  ./configure --prefix=/tools \
  --build=${CROSS_HOST} --host=${CROSS_TARGET64} \
  || die "***config make error"
make -j${JOBS} || die "***build make error"
make install || die "***install make error"
popd

pushd ${SRCPURE64ELSTAGE2}
[ -d "patch-${PATCH_VERSION}" ] \
  || tar xf ${TARBALL}/patch-${PATCH_VERSION}.${PATCH_SUFFIX}
cd patch-${PATCH_VERSION}
echo "ac_cv_func_strnlen_working=yes" > config.cache
[ -f "config.log" ] || CC="${CC} ${BUILD64}" \
  ./configure --prefix=/tools \
  --build=${CROSS_HOST} --host=${CROSS_TARGET64} \
  --cache-file=config.cache \
  || die "***config patch error"
make -j${JOBS} || die "***build patch error"
make install || die "***install patch error"
popd

pushd ${SRCPURE64ELSTAGE2}
[ -d "sed-${SED_VERSION}" ] \
  || tar xf ${TARBALL}/sed-${SED_VERSION}.${SED_SUFFIX}
cd sed-${SED_VERSION}
[ -f "config.log" ] || CC="${CC} ${BUILD64}" \
  ./configure --prefix=/tools \
  --build=${CROSS_HOST} --host=${CROSS_TARGET64} \
  || die "***config sed error"
make -j${JOBS} || die "***build sed error"
make install || die "***install sed error"
popd


pushd ${SRCPURE64ELSTAGE2}
[ -d "tar-${TAR_VERSION}" ] \
  || tar xf ${TARBALL}/tar-${TAR_VERSION}.${TAR_SUFFIX}
cd tar-${TAR_VERSION}
cat > config.cache << EOF
gl_cv_func_wcwidth_works=yes
gl_cv_func_btowc_eof=yes
ac_cv_func_malloc_0_nonnull=yes
ac_cv_func_realloc_0_nonnull=yes
gl_cv_func_mbrtowc_incomplete_state=yes
gl_cv_func_mbrtowc_nul_retval=yes
gl_cv_func_mbrtowc_null_arg=yes
gl_cv_func_mbrtowc_retval=yes
gl_cv_func_wcrtomb_retval=yes
EOF
[ -f "config.log" ] || CC="${CC} ${BUILD64}" \
  ./configure --prefix=/tools \
  --build=${CROSS_HOST} --host=${CROSS_TARGET64} \
  --cache-file=config.cache \
  || die "***config tar error"
make -j${JOBS} || die "***build tar error"
make install || die "***install tar error"
popd

pushd ${SRCPURE64ELSTAGE2}
[ -d "texinfo-${TEXINFO_VERSION}" ] \
  || tar xf ${TARBALL}/texinfo-${TEXINFO_VERSION}a.${TEXINFO_SUFFIX}
cd texinfo-${TEXINFO_VERSION}
[ -f "config.log" ] || CC="${CC} ${BUILD64}" \
  ./configure --prefix=/tools \
  --build=${CROSS_HOST} --host=${CROSS_TARGET64} \
  || die "***config texinfo error"
make -C tools/gnulib/lib || die "***build texinfo lib error" 
make -C tools || die "***build texinfo tools error"
make -j${JOBS} || die "***build texinfo error"
make install || die "***install texinfo error"
popd

pushd ${SRCPURE64ELSTAGE2}
[ -d "vim-${VIM_VERSION}" ] \
  || tar xf ${TARBALL}/vim-${VIM_VERSION}.${VIM_SUFFIX}
cd ${VIM_DIR}
patch -Np1 -i ${PATCH}/vim-7.3-branch_update-4.patch \
  || die "*** patch vim error"
sed -i "/using uint32_t/s/as_fn_error/#&/" src/auto/configure
cat > src/auto/config.cache << "EOF"
vim_cv_getcwd_broken=no
vim_cv_memmove_handles_overlap=yes
vim_cv_stat_ignores_slash=no
vim_cv_terminfo=yes
vim_cv_tgent=zero
vim_cv_toupper_broken=no
vim_cv_tty_group=world
ac_cv_sizeof_int=4
ac_cv_sizeof_long=4
ac_cv_sizeof_time_t=4
ac_cv_sizeof_off_t=4
EOF
echo '#define SYS_VIMRC_FILE "/tools/etc/vimrc"' >> src/feature.h
[ -f "config.log" ] || CC="${CC} ${BUILD64}" \
  CXX="${CXX} ${BUILD64}" ./configure --build=${CROSS_HOST} \
  --host=${CROSS_TARGET64} \
  --prefix=/tools --enable-multibyte --enable-gui=no \
  --disable-gtktest --disable-xim --with-features=normal \
  --disable-gpm --without-x --disable-netbeans \
  --with-tlib=ncurses \
  || die "***config vim error"
make -j${JOBS} || die "***build vim error"
make install || die "***install vim error"
ln -sv vim /tools/bin/vi
cat > /tools/etc/vimrc << "EOF"
" Begin /etc/vimrc

set nocompatible
set backspace=2
set ruler
syntax on

" End /etc/vimrc
EOF
popd

pushd ${SRCPURE64ELSTAGE2}
[ -d "xz-${XZ_VERSION}" ] \
  || tar xf ${TARBALL}/xz-${XZ_VERSION}.${XZ_SUFFIX}
cd xz-${XZ_VERSION}
[ -f "config.log" ] || CC="${CC} ${BUILD64}" \
  ./configure --prefix=/tools \
  --build=${CROSS_HOST} --host=${CROSS_TARGET64} \
  || die "***config xz error"
make -j${JOBS} || die "***build xz error"
make install || die "***install xz error"
popd

sudo rm -rf /cross-tools /tools
