#! /bin/bash

export JOBS=16

export BZ=tar.bz2
export GZ=tar.gz
export XZ=tar.xz

export GMP_VERSION=5.0.5
export GMP_SUFFIX=${XZ}
export MPFR_VERSION=3.1.0
export MPFR_SUFFIX=${BZ}
export MPC_VERSION=0.9
export MPC_SUFFIX=${GZ}
export PPL_VERSION=0.11.2
export PPL_SUFFIX=${BZ}
export CLOOG_VERSION=0.16.3
export CLOOG_SUFFIX=${GZ}
export ZLIB_VERSION=1.2.7
export ZLIB_SUFFIX=${BZ}
export BINUTILS_VERSION=2.22
export BINUTILS_SUFFIX=${BZ}
export GCC_VERSION=4.6.3
export GCC_SUFFIX=${BZ}
export NCURSES_VERSION=5.9
export NCURSES_SUFFIX=${GZ}
export BASH_VERSION=4.2
export BASH_SUFFIX=${GZ}
export BISON_VERSION=2.5
export BISON_SUFFIX=${BZ}
export BZIP2_VERSION=1.0.6
export BZIP2_SUFFIX=${GZ}
export COREUTILS_VERSION=8.16
export COREUTILS_SUFFIX=${XZ}
export DIFFUTILS_VERSION=3.2
export DIFFUTILS_SUFFIX=${XZ}
export FINDUTILS_VERSION=4.4.2
export FINDUTILS_SUFFIX=${GZ}
export FILE_VERSION=5.11
export FILE_SUFFIX=${GZ}
export FLEX_VERSION=2.5.35
export FLEX_SUFFIX=${BZ}
export GAWK_VERSION=4.0.1
export GAWK_SUFFIX=${XZ}
export GETTEXT_VERSION=0.18.1.1
export GETTEXT_SUFFIX=${GZ}
export GREP_VERSION=2.12
export GREP_SUFFIX=${XZ}
export GZIP_VERSION=1.4
export GZIP_SUFFIX=${XZ}
export M4_VERSION=1.4.16
export M4_SUFFIX=${BZ}
export MAKE_VERSION=3.82
export MAKE_SUFFIX=${BZ}
export PATCH_VERSION=2.6.1
export PATCH_SUFFIX=${BZ}
export SED_VERSION=4.2.1
export SED_SUFFIX=${BZ}
export TAR_VERSION=1.26
export TAR_SUFFIX=${BZ}
export TEXINFO_VERSION=4.13
export TEXINFO_SUFFIX=${GZ}
export VIM_VERSION=7.3
export VIM_DIR=vim73
export VIM_SUFFIX=${BZ}
export XZ_VERSION=5.0.3
export XZ_SUFFIX=${XZ}

function die() {
  echo "$1"
  exit 1
}

[ -e build.sh ]
export SCRIPT="$(pwd)"
export TARBALL=${SCRIPT}/../tarballs
export PATCH=${SCRIPT}/../patches
export SRCS=${SCRIPT}/../srcs
export SRC=${SCRIPT}/../src/mipsel-unknown-linux/stage2
export BUILD=${SCRIPT}/../build/mipsel-unknown-linux/stage2

#[[ $# -eq 1 ]] || die "usage: build.sh PREFIX"
export CROSS_SDK_TOOLS=${SCRIPT}/../sdk
export CROSS=${CROSS_SDK_TOOLS}/mipsel/
export PATH=$PATH:/cross-tools/bin/

[ -d "${SRC}" ] || mkdir -p "${SRC}"
[ -d "${BUILD}" ] || mkdir -p "${BUILD}"

unset CFLAGS
unset CXXFLAGS
export CFLAGS="-w"
export CROSS_HOST=${MACHTYPE}
export CROSS_TARGET="mipsel-unknown-linux-gnu"
export BUILD32="-mabi=32"

export CC="${CROSS_TARGET}-gcc"
export CXX="${CROSS_TARGET}-g++"
export AR="${CROSS_TARGET}-ar"
export AS="${CROSS_TARGET}-as"
export RANLIB="${CROSS_TARGET}-ranlib"
export LD="${CROSS_TARGET}-ld"
export STRIP="${CROSS_TARGET}-strip"

[ -d "${CROSS_SDK_TOOLS}" ] || mkdir -p ${CROSS_SDK_TOOLS}
[ -d "${CROSS}" ] || mkdir -p ${CROSS}
[ -d "${CROSS}/tools" ] || mkdir -p ${CROSS}/tools
[ -d "/tools" ] || sudo ln -s ${CROSS}/tools /
[ -d "${CROSS}/cross-tools" ] || mkdir -p ${CROSS}/cross-tools
[ -d "/cross-tools" ] || sudo ln -s ${CROSS}/cross-tools /

pushd ${SRC}
[ -d "gmp-${GMP_VERSION}" ] \
  || tar xf ${TARBALL}/gmp-${GMP_VERSION}.${GMP_SUFFIX}
cd gmp-${GMP_VERSION}
[ -f "config.log" ] || HOST_CC=gcc \
  CPPFLAGS=-fexceptions CC="${CC} ${BUILD32}" \
  CXX="${CXX} ${BUILD32}" ./configure --prefix=/tools \
  --build=${CROSS_HOST} --host=${CROSS_TARGET} \
  --enable-cxx || die "***config gmp error"
make -j${JOBS} || die "***make gmp error"
make install || die "***install gmp error"
popd

pushd ${SRC}
[ -d "mpfr-${MPFR_VERSION}" ] \
  || tar xf ${TARBALL}/mpfr-${MPFR_VERSION}.${MPFR_SUFFIX}
cd mpfr-${MPFR_VERSION}
[ -f "config.log" ] || CC="${CC} ${BUILD32}"  \
  ./configure --prefix=/tools \
  --build=${CROSS_HOST} --host=${CROSS_TARGET} \
  --enable-shared || die "***config mpfr error"
make -j${JOBS} || die "***build mpfr error"
make install || die "***install mpfr error"
popd

pushd ${SRC}
[ -d "mpc-${MPC_VERSION}" ] \
  || tar xf ${TARBALL}/mpc-${MPC_VERSION}.${MPC_SUFFIX}
cd mpc-${MPC_VERSION}
[ -f "config.log" ] || CC="${CC} ${BUILD32}" \
  EGREP="grep -E" ./configure --prefix=/tools \
  --build=${CROSS_HOST} --host=${CROSS_TARGET} \
  || die "***config mpc error"
make -j${JOBS} || die "***build mpc error"
make install || die "***install mpc error"
popd


pushd ${SRC}
[ -d "ppl-${PPL_VERSION}" ] \
  || tar xf ${TARBALL}/ppl-${PPL_VERSION}.${PPL_SUFFIX}
cd ppl-${PPL_VERSION}
[ -f "config.log" ] ||
CC="${CC} ${BUILD32}" ./configure --prefix=/tools \
  --build=${CROSS_HOST} --host=${CROSS_TARGET} \
  --enable-interfaces="c,cxx" --enable-shared \
  --disable-optimization --with-libgmp-prefix=/tools \
  --with-libgmpxx-prefix=/tools \
  || die "***config file error"
make -j${JOBS} || die "***build ppl error"
make install || die "***install ppl error"
popd

pushd ${SRC}
[ -d "cloog-${CLOOG_VERSION}" ] \
  || tar xf ${TARBALL}/cloog-${CLOOG_VERSION}.${CLOOG_SUFFIX}
cd cloog-${CLOOG_VERSION}
cp -v configure{,.orig}
sed -e "/LD_LIBRARY_PATH=/d" \
    configure.orig > configure
[ -f "config.log" ] ||
CC="${CC} ${BUILD32}" ./configure --prefix=/tools \
  --build=${CROSS_HOST} --host=${CROSS_TARGET} \
  --enable-shared --with-gmp-prefix=/tools \
  || die "***config file error"
make -j${JOBS} || die "***build cloog error"
make install || die "***install cloog error"
popd

pushd ${SRC}
[ -d "zlib-${ZLIB_VERSION}" ] \
  || tar xf ${TARBALL}/zlib-${ZLIB_VERSION}.${ZLIB_SUFFIX}
cd zlib-${ZLIB_VERSION}
[ -f "config.log" ] || CC="${CC} ${BUILD32}" \
  ./configure --prefix=/tools   || die "***config zlib error"
make -j${JOBS} || die "***build zlib error"
make install || die "***install zlib error"
popd

pushd ${SRC}
[ -d "binutils-${BINUTILS_VERSION}" ] \
  || tar xf ${TARBALL}/binutils-${BINUTILS_VERSION}.${BINUTILS_SUFFIX}
popd

pushd ${BUILD}
[ -d "binutils-build" ] || mkdir binutils-build
cd binutils-build
[ -f "config.log" ] || CC="${CC} ${BUILD32}" \
  ${SRC}/binutils-${BINUTILS_VERSION}/configure \
  --prefix=/tools --build=${CROSS_HOST} --host=${CROSS_TARGET} \
  --target=${CROSS_TARGET} --with-lib-path=/tools/lib --disable-nls \
  --enable-shared --disable-multilib \
  --with-ppl=/tools --with-cloog=/tools \
  --enable-cloog-backend=isl || die "***config file error"
make configure-host || die "config binutils host error"
make -j${JOBS} || die "***build binutils error"
make install || die "***install binutils error"
popd

pushd ${SRC}
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

pushd ${BUILD}
[ -d "gcc-build" ] \
  || mkdir gcc-build
cd gcc-build
[ -f "config.log" ] || CC="${CC} ${BUILD32}" \
  CXX="${CXX} ${BUILD32}" ${SRC}/gcc-${GCC_VERSION}/configure \
  --prefix=/tools --disable-multilib \
  --build=${CROSS_HOST} --host=${CROSS_TARGET} \
  --target=${CROSS_TARGET} --libexecdir=/tools/lib \
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

pushd ${SRC}
[ -d "ncurses-${NCURSES_VERSION}" ] \
  || tar xf ${TARBALL}/ncurses-${NCURSES_VERSION}.${NCURSES_SUFFIX}
cd ncurses-${NCURSES_VERSION}
patch -Np1 -i ${PATCH}/ncurses-5.9-bash_fix-1.patch \
  || die "***patch ncurses error"
[ -f "config.log" ] || CC="${CC} ${BUILD32}" \
  CXX="${CXX} ${BUILD32}" ./configure --prefix=/tools \
  --with-shared --build=${CROSS_HOST} --host=${CROSS_TARGET} \
  --without-debug --without-ada --enable-overwrite \
  --with-build-cc=gcc || die "***config ncurses error"
make -j${JOBS} || die "***build ncurses error"
make install || die "***install ncurses error"
popd

pushd ${SRC}
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
[ -f "config.log" ] || CC="${CC} ${BUILD32}" \
  CXX="${CXX} ${BUILD32}" ./configure --prefix=/tools \
  --build=${CROSS_HOST} --host=${CROSS_TARGET} \
  --without-bash-malloc --cache-file=config.cache \
  || die "***config bash error"
make -j${JOBS} || die "***build bash error"
make install || die "***install bash error"
ln -s bash /tools/bin/sh || die "***link bash error"
popd

pushd ${SRC}
[ -d "bison-${BISON_VERSION}" ] \
  || tar xf ${TARBALL}/bison-${BISON_VERSION}.${BISON_SUFFIX}
cd bison-${BISON_VERSION}
[ -f "config.log" ] || CC="${CC} ${BUILD32}" \
  ./configure --prefix=/tools --build=${CROSS_HOST} \
  --host=${CROSS_TARGET} || die "***config bison error"
make -j${JOBS} || die "***build bison error"
make install || die "***install bison error"
popd

pushd ${SRC}
[ -d "bzip2-${BZIP2_VERSION}" ] \
  || tar xf ${TARBALL}/bzip2-${BZIP2_VERSION}.${BZIP2_SUFFIX}
cd bzip2-${BZIP2_VERSION}
cp -v Makefile{,.orig}
sed -e 's@^\(all:.*\) test@\1@g' Makefile.orig > Makefile
make CC="${CC} ${BUILD32}" AR="${AR}" RANLIB="${RANLIB}" \
  || die "***build bzip2 error"
make PREFIX=/tools install || die "install bzip2 error"
popd

pushd ${SRC}
[ -d "coreutils-${COREUTILS_VERSION}" ] \
  || tar xf ${TARBALL}/coreutils-${COREUTILS_VERSION}.${COREUTILS_SUFFIX}
cd coreutils-${COREUTILS_VERSION}
touch man/uname.1 man/hostname.1
cat > config.cache << EOF
fu_cv_sys_stat_statfs2_bsize=yes
gl_cv_func_working_mkstemp=yes
EOF
[ -f "config.log" ] || CC="${CC} ${BUILD32}" \
  ./configure --prefix=/tools --build=${CROSS_HOST} \
  --host=${CROSS_TARGET} --enable-install-program=hostname \
  --cache-file=config.cache || die "***config coreutils error"
make -j${JOBS} || die "***build coreutils error"
make install || die "***install coreutils error"
popd

pushd ${SRC}
[ -d "diffutils-${DIFFUTILS_VERSION}" ] \
  || tar xf ${TARBALL}/diffutils-${DIFFUTILS_VERSION}.${DIFFUTILS_SUFFIX}
cd diffutils-${DIFFUTILS_VERSION}
[ -f "config.log" ] || CC="${CC} ${BUILD32}" \
  ./configure --prefix=/tools --build=${CROSS_HOST} \
  --host=${CROSS_TARGET} || die "***config diffutils error"
make -j${JOBS} || die "***build diffutils error"
make install || die "***install diffutils error"
popd

pushd ${SRC}
[ -d "findutils-${FINDUTILS_VERSION}" ] \
  || tar xf ${TARBALL}/findutils-${FINDUTILS_VERSION}.${FINDUTILS_SUFFIX}
cd findutils-${FINDUTILS_VERSION}
echo "gl_cv_func_wcwidth_works=yes" > config.cache
echo "ac_cv_func_fnmatch_gnu=yes" >> config.cache
[ -f "config.log" ] || CC="${CC} ${BUILD32}" \
  ./configure --prefix=/tools --build=${CROSS_HOST} \
  --host=${CROSS_TARGET} --cache-file=config.cache \
  || die "***config findutils error"
make -j${JOBS} || die "***build findutils error"
make install || die "***install findutils error"
popd

pushd ${SRC}
[ -d "file-${FILE_VERSION}" ] \
  || tar xf ${TARBALL}/file-${FILE_VERSION}.${FILE_SUFFIX}
cd file-${FILE_VERSION}
[ -f "config.log" ] || CC="${CC} ${BUILD32}" \
  ./configure --prefix=/tools --build=${CROSS_HOST} \
  --host=${CROSS_TARGET} || die "***config file error"
make -j${JOBS} || die "***build file error"
make install || die "***install file error"
popd

pushd ${SRC}
[ -d "flex-${FLEX_VERSION}" ] \
  || tar xf ${TARBALL}/flex-${FLEX_VERSION}.${FLEX_SUFFIX}
cd flex-${FLEX_VERSION}
patch -Np1 -i ${PATCH}/flex-2.5.35-gcc44-1.patch \
  || die "***patch flex error"
cat > config.cache << EOF
ac_cv_func_malloc_0_nonnull=yes
ac_cv_func_realloc_0_nonnull=yes
EOF
[ -f "config.log" ] || CC="${CC} ${BUILD32}" \
  ./configure --prefix=/tools --build=${CROSS_HOST} \
  --host=${CROSS_TARGET} --cache-file=config.cache \
  || die "***config flex error"
make -j${JOBS} || die "***build flex error"
make install || die "***install flex error"
popd

pushd ${SRC}
[ -d "gawk-${GAWK_VERSION}" ] \
  || tar xf ${TARBALL}/gawk-${GAWK_VERSION}.${GAWK_SUFFIX}
cd gawk-${GAWK_VERSION}
[ -f "config.log" ] || CC="${CC} ${BUILD32}" \
  ./configure --prefix=/tools --build=${CROSS_HOST} \
  --host=${CROSS_TARGET} || die "***config gawk error"
make -j${JOBS} || die "***build gawk error"
make install || die "***install gawk error"
popd

pushd ${SRC}
[ -d "gettext-${GETTEXT_VERSION}" ] \
  || tar xf ${TARBALL}/gettext-${GETTEXT_VERSION}.${GETTEXT_SUFFIX}
cd gettext-${GETTEXT_VERSION}
cd gettext-tools
echo "gl_cv_func_wcwidth_works=yes" > config.cache
[ -f "config.log" ] || CC="${CC} ${BUILD32}" \
  CXX="${CXX} ${BUILD32}" ./configure --prefix=/tools \
  --disable-shared --build=${CROSS_HOST} \
  --host=${CROSS_TARGET} --cache-file=config.cache \
  || die "***config gettext error"
make -C gnulib-lib || die "***build gettext gnulib-lib error"
make -C src msgfmt || die "***build gettext msgfmt error"
cp -v src/msgfmt /tools/bin || die "***install gettext error"
popd

pushd ${SRC}
[ -d "grep-${GREP_VERSION}" ] \
  || tar xf ${TARBALL}/grep-${GREP_VERSION}.${GREP_SUFFIX}
cd grep-${GREP_VERSION}
cat > config.cache << EOF
ac_cv_func_malloc_0_nonnull=yes
ac_cv_func_realloc_0_nonnull=yes
EOF
[ -f "config.log" ] || CC="${CC} ${BUILD32}" \
  ./configure --prefix=/tools --build=${CROSS_HOST} \
  --host=${CROSS_TARGET} --disable-perl-regexp \
  --without-included-regex --cache-file=config.cache \
  || die "***config grep error"
make -j${JOBS} || die "***build grep error"
make install || die "***install grep error"
popd

pushd ${SRC}
[ -d "gzip-${GZIP_VERSION}" ] \
  || tar xf ${TARBALL}/gzip-${GZIP_VERSION}.${GZIP_SUFFIX}
cd gzip-${GZIP_VERSION}
[ -f "config.log" ] || CC="${CC} ${BUILD32}" \
  ./configure --prefix=/tools \
  --build=${CROSS_HOST} --host=${CROSS_TARGET} \
  || die "***config gzip error"
make -j${JOBS} || die "***build gzip error"
make install || die "***install gzip error"
popd

pushd ${SRC}
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
[ -f "config.log" ] || CC="${CC} ${BUILD32}" \
  ./configure --prefix=/tools \
  --build=${CROSS_HOST} --host=${CROSS_TARGET} \
  --cache-file=config.cache || die "***config m4 error"
make -j${JOBS} || die "***build m4 error"
make install || die "***install m4 error"
popd

pushd ${SRC}
[ -d "make-${MAKE_VERSION}" ] \
  || tar xf ${TARBALL}/make-${MAKE_VERSION}.${MAKE_SUFFIX}
cd make-${MAKE_VERSION}
[ -f "config.log" ] || CC="${CC} ${BUILD32}" \
  ./configure --prefix=/tools \
  --build=${CROSS_HOST} --host=${CROSS_TARGET} \
  || die "***config make error"
make -j${JOBS} || die "***build make error"
make install || die "***install make error"
popd

pushd ${SRC}
[ -d "patch-${PATCH_VERSION}" ] \
  || tar xf ${TARBALL}/patch-${PATCH_VERSION}.${PATCH_SUFFIX}
cd patch-${PATCH_VERSION}
echo "ac_cv_func_strnlen_working=yes" > config.cache
[ -f "config.log" ] || CC="${CC} ${BUILD32}" \
  ./configure --prefix=/tools \
  --build=${CROSS_HOST} --host=${CROSS_TARGET} \
  --cache-file=config.cache \
  || die "***config patch error"
make -j${JOBS} || die "***build patch error"
make install || die "***install patch error"
popd

pushd ${SRC}
[ -d "sed-${SED_VERSION}" ] \
  || tar xf ${TARBALL}/sed-${SED_VERSION}.${SED_SUFFIX}
cd sed-${SED_VERSION}
[ -f "config.log" ] || CC="${CC} ${BUILD32}" \
  ./configure --prefix=/tools \
  --build=${CROSS_HOST} --host=${CROSS_TARGET} \
  || die "***config sed error"
make -j${JOBS} || die "***build sed error"
make install || die "***install sed error"
popd


pushd ${SRC}
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
[ -f "config.log" ] || CC="${CC} ${BUILD32}" \
  ./configure --prefix=/tools \
  --build=${CROSS_HOST} --host=${CROSS_TARGET} \
  --cache-file=config.cache \
  || die "***config tar error"
make -j${JOBS} || die "***build tar error"
make install || die "***install tar error"
popd

pushd ${SRC}
[ -d "texinfo-${TEXINFO_VERSION}" ] \
  || tar xf ${TARBALL}/texinfo-${TEXINFO_VERSION}a.${TEXINFO_SUFFIX}
cd texinfo-${TEXINFO_VERSION}
[ -f "config.log" ] || CC="${CC} ${BUILD32}" \
  ./configure --prefix=/tools \
  --build=${CROSS_HOST} --host=${CROSS_TARGET} \
  || die "***config texinfo error"
make -C tools/gnulib/lib || die "***build texinfo lib error" 
make -C tools || die "***build texinfo tools error"
make -j${JOBS} || die "***build texinfo error"
make install || die "***install texinfo error"
popd

pushd ${SRC}
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
[ -f "config.log" ] || CC="${CC} ${BUILD32}" \
  CXX="${CXX} ${BUILD32}" ./configure --build=${CROSS_HOST} \
  --host=${CROSS_TARGET} \
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

pushd ${SRC}
[ -d "xz-${XZ_VERSION}" ] \
  || tar xf ${TARBALL}/xz-${XZ_VERSION}.${XZ_SUFFIX}
cd xz-${XZ_VERSION}
[ -f "config.log" ] || CC="${CC} ${BUILD32}" \
  ./configure --prefix=/tools \
  --build=${CROSS_HOST} --host=${CROSS_TARGET} \
  || die "***config xz error"
make -j${JOBS} || die "***build xz error"
make install || die "***install xz error"
popd

sudo rm -rf /cross-tools /tools
