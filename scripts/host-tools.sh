#! /bin/bash

source source.sh

[ -d "${SRCHOSTTOOLS}" ] || mkdir -p "${SRCHOSTTOOLS}"
[ -d "${METADATAHOSTTOOLS}" ] || mkdir -p "${METADATAHOSTTOOLS}"

pushd ${SRCHOSTTOOLS}
[ -f ${METADATAHOSTTOOLS}/autoconf_extract ] || \
  tar xvf ${TARBALL}/autoconf-${AUTOCONF_VERSION}.${AUTOCONF_SUFFIX} || \
    die "extract autoconf error" && \
      touch ${METADATAHOSTTOOLS}/autoconf_extract
[ -f ${METADATAHOSTTOOLS}/automake_extract ] || \
  tar vxf ${TARBALL}/automake-${AUTOMAKE_VERSION}.${AUTOMAKE_SUFFIX} || \
    die "extract automake error" && \
      touch ${METADATAHOSTTOOLS}/automake_extract
[ -f ${METADATAHOSTTOOLS}/bash_extract ] || \
  tar vxf ${TARBALL}/bash-${BASH_VERSION}.${BASH_SUFFIX} || \
    die "extract bash error" && \
      touch ${METADATAHOSTTOOLS}/bash_extract
[ -f ${METADATAHOSTTOOLS}/coreutils_extract ] || \
  tar vxf ${TARBALL}/coreutils-${COREUTILS_VERSION}.${COREUTILS_SUFFIX} || \
    die "extract coreutils error" && \
      touch ${METADATAHOSTTOOLS}/coreutils_extract
[ -f ${METADATAHOSTTOOLS}/gawk_extract ] || \
  tar vxf ${TARBALL}/gawk-${GAWK_VERSION}.${GAWK_SUFFIX} || \
    die "extract gawk error" && \
      touch ${METADATAHOSTTOOLS}/gawk_extract
[ -f ${METADATAHOSTTOOLS}/gettext_extract ] || \
  tar vxf ${TARBALL}/gettext-${GETTEXT_VERSION}.${GETTEXT_SUFFIX} || \
    die "extract gettext error" && \
      touch ${METADATAHOSTTOOLS}/gettext_extract
[ -f ${METADATAHOSTTOOLS}/grep_extract ] || \
  tar vxf ${TARBALL}/grep-${GREP_VERSION}.${GREP_SUFFIX} || \
    die "extract grep error" && \
      touch ${METADATAHOSTTOOLS}/grep_extract
[ -f ${METADATAHOSTTOOLS}/libiconv_extract ] || \
  tar xvf ${TARBALL}/libiconv-${LIBICONV_VERSION}.${LIBICONV_SUFFIX} || \
    die "extract libiconv error" && \
      touch ${METADATAHOSTTOOLS}/libiconv_extract
[ -f ${METADATAHOSTTOOLS}/libtool_extract ] || \
  tar vxf ${TARBALL}/libtool-${LIBTOOL_VERSION}.${LIBTOOL_SUFFIX} || \
    die "extract libtool error" && \
      touch ${METADATAHOSTTOOLS}/libtool_extract
[ -f ${METADATAHOSTTOOLS}/sed_extract ] || \
  tar vxf ${TARBALL}/sed-${SED_VERSION}.${SED_SUFFIX} || \
    die "extract sed error" && \
      touch ${METADATAHOSTTOOLS}/sed_extract
[ -f ${METADATAHOSTTOOLS}/texinfo_extract ] || \
  tar vxf ${TARBALL}/texinfo-${TEXINFO_VERSION}a.${TEXINFO_SUFFIX} || \
    die "extract texinfo error" && \
      touch ${METADATAHOSTTOOLS}/texinfo_extract
[ -f ${METADATAHOSTTOOLS}/zlib_extract ] || \
  tar vxf ${TARBALL}/zlib-${ZLIB_VERSION}.${ZLIB_SUFFIX} || \
    die "extract zlib error" && \
      touch ${METADATAHOSTTOOLS}/zlib_extract
popd

pushd ${SRCHOSTTOOLS}
cd autoconf-${AUTOCONF_VERSION}/
[ -f ${METADATAHOSTTOOLS}/autoconf_configure ] || \
  ./configure --prefix=${PREFIXHOSTTOOLS} || \
    die "configure autoconf error" && \
      touch ${METADATAHOSTTOOLS}/autoconf_configure
[ -f ${METADATAHOSTTOOLS}/autoconf_build ] || \
  make -j${JOBS} || \
    die "build autoconf error" && \
      touch ${METADATAHOSTTOOLS}/autoconf_build
[ -f ${METADATAHOSTTOOLS}/autoconf_install ] || \
  make install || \
    die "install autoconf error" && \
      touch ${METADATAHOSTTOOLS}/autoconf_install
popd

pushd ${SRCHOSTTOOLS}
cd automake-${AUTOMAKE_VERSION}
[ -f ${METADATAHOSTTOOLS}/automake_configure ] || \
  ./configure --prefix=${PREFIXHOSTTOOLS} || \
    die "configure automake error" && \
      touch ${METADATAHOSTTOOLS}/automake_configure
[ -f ${METADATAHOSTTOOLS}/automake_build ] || \
  make -j${JOBS} || \
    die "build automake error" && \
      touch ${METADATAHOSTTOOLS}/automake_build
[ -f ${METADATAHOSTTOOLS}/automake_install ] || \
  make install || \
    die "install automake error" && \
      touch ${METADATAHOSTTOOLS}/automake_install
popd


pushd ${SRCHOSTTOOLS}
cd bash-${BASH_VERSION}
[ -f ${METADATAHOSTTOOLS}/bash_configure ] || \
  ./configure --prefix=${PREFIXHOSTTOOLS} || \
    die "configure bash error" && \
      touch ${METADATAHOSTTOOLS}/bash_configure
[ -f ${METADATAHOSTTOOLS}/bash_build ] || \
  make -j${JOBS} || \
    die "build bash error" && \
      touch ${METADATAHOSTTOOLS}/bash_build
[ -f ${METADATAHOSTTOOLS}/bash_install ] || \
  make install || \
    die "install bash error" && \
      touch ${METADATAHOSTTOOLS}/bash_install
popd

pushd ${SRCHOSTTOOLS}
cd coreutils-${COREUTILS_VERSION}
[ -f ${METADATAHOSTTOOLS}/coreutils_patch ] || \
  patch -p1 < ${PATCH}/coreutils-8.20-host-tool.patch  || \
    die "patch coreutils error" && \
      touch ${METADATAHOSTTOOLS}/coreutils_patch
[ -f ${METADATAHOSTTOOLS}/coreutils_configure ] || \
  ./configure --prefix=${PREFIXHOSTTOOLS} || \
    die "configure coreutils error" && \
      touch ${METADATAHOSTTOOLS}/coreutils_configure
[ -f ${METADATAHOSTTOOLS}/coreutils_build ] || \
  make -j${JOBS} || \
    die "build coreutils error" && \
      touch ${METADATAHOSTTOOLS}/coreutils_build
[ -f ${METADATAHOSTTOOLS}/coreutils_install ] || \
  make install || \
    die "install coreutils error" && \
      touch ${METADATAHOSTTOOLS}/coreutils_install
popd

pushd ${SRCHOSTTOOLS}
cd gawk-${GAWK_VERSION}
[ -f ${METADATAHOSTTOOLS}/gawk_configure ] || \
  ./configure --prefix=${PREFIXHOSTTOOLS} || \
    die "configure gawk error" && \
      touch ${METADATAHOSTTOOLS}/gawk_configure
[ -f ${METADATAHOSTTOOLS}/gawk_build ] || \
  make -j${JOBS} || \
    die "build gawk error" && \
      touch ${METADATAHOSTTOOLS}/gawk_build
[ -f ${METADATAHOSTTOOLS}/gawk_install ] || \
  make install || \
    die "install gawk error" && \
      touch ${METADATAHOSTTOOLS}/gawk_install
popd

pushd ${SRCHOSTTOOLS}
cd gettext-${GETTEXT_VERSION}
[ -f ${METADATAHOSTTOOLS}/gettext_configure ] || \
  ./configure --prefix=${PREFIXHOSTTOOLS} || \
    die "configure gettext error" && \
      touch ${METADATAHOSTTOOLS}/gettext_configure
[ -f ${METADATAHOSTTOOLS}/gettext_build ] || \
  make -j${JOBS} || \
    die "build gettext error" && \
      touch ${METADATAHOSTTOOLS}/gettext_build
[ -f ${METADATAHOSTTOOLS}/gettext_install ] || \
  make install || \
    die "install gettext error" && \
      touch ${METADATAHOSTTOOLS}/gettext_install
popd

pushd ${SRCHOSTTOOLS}
cd grep-${GREP_VERSION}
[ -f ${METADATAHOSTTOOLS}/grep_configure ] || \
  ./configure --prefix=${PREFIXHOSTTOOLS} || \
    die "configure grep error" && \
      touch ${METADATAHOSTTOOLS}/grep_configure
[ -f ${METADATAHOSTTOOLS}/grep_build ] || \
  make -j${JOBS} || \
    die "build grep error" && \
      touch ${METADATAHOSTTOOLS}/grep_build
[ -f ${METADATAHOSTTOOLS}/grep_install ] || \
  make install || \
    die "install grep error" && \
      touch ${METADATAHOSTTOOLS}/grep_install
popd

pushd ${SRCHOSTTOOLS}
cd libtool-${LIBTOOL_VERSION}
[ -f ${METADATAHOSTTOOLS}/libtool_configure ] || \
  ./configure --prefix=${PREFIXHOSTTOOLS} || \
    die "configure libtool error" && \
      touch ${METADATAHOSTTOOLS}/libtool_configure
[ -f ${METADATAHOSTTOOLS}/libtool_build ] || \
  make -j${JOBS} || \
    die "build libtool error" && \
      touch ${METADATAHOSTTOOLS}/libtool_build
[ -f ${METADATAHOSTTOOLS}/libtool_install ] || \
  make install || \
    die "install libtool error" && \
      touch ${METADATAHOSTTOOLS}/libtool_install
popd

pushd ${SRCHOSTTOOLS}
cd sed-${SED_VERSION}
[ -f ${METADATAHOSTTOOLS}/sed_configure ] || \
  ./configure --prefix=${PREFIXHOSTTOOLS} || \
    die "configure sed error" && \
      touch ${METADATAHOSTTOOLS}/sed_configure
[ -f ${METADATAHOSTTOOLS}/sed_build ] || \
  make -j${JOBS} || \
    die "build sed error" && \
      touch ${METADATAHOSTTOOLS}/sed_build
[ -f ${METADATAHOSTTOOLS}/sed_install ] || \
  make install || \
    die "install sed error" && \
      touch ${METADATAHOSTTOOLS}/sed_install
popd

pushd ${SRCHOSTTOOLS}
cd texinfo-${TEXINFO_VERSION}
[ -f ${METADATAHOSTTOOLS}/texinfo_configure ] || \
  ./configure --prefix=${PREFIXHOSTTOOLS} || \
    die "configure texinfo error" && \
      touch ${METADATAHOSTTOOLS}/texinfo_configure
[ -f ${METADATAHOSTTOOLS}/texinfo_build ] || \
  make -j${JOBS} || \
    die "build texinfo error" && \
      touch ${METADATAHOSTTOOLS}/texinfo_build
[ -f ${METADATAHOSTTOOLS}/texinfo_install ] || \
  make install || \
    die "install texinfo error" && \
      touch ${METADATAHOSTTOOLS}/texinfo_install
popd

pushd ${SRCHOSTTOOLS}
cd zlib-${ZLIB_VERSION}
[ -f ${METADATAHOSTTOOLS}/zlib_configure ] || \
  ./configure --prefix=${PREFIXHOSTTOOLS} || \
    die "configure zlib error" && \
      touch ${METADATAHOSTTOOLS}/zlib_configure
[ -f ${METADATAHOSTTOOLS}/zlib_build ] || \
  make -j${JOBS} || \
    die "build zlib error" && \
      touch ${METADATAHOSTTOOLS}/zlib_build
[ -f ${METADATAHOSTTOOLS}/zlib_install ] || \
  make install || \
    die "install zlib error" && \
      touch ${METADATAHOSTTOOLS}/zlib_install
popd

pushd ${SRCHOSTTOOLS}
cd libiconv-${LIBICONV_VERSION}
[ -f ${METADATAHOSTTOOLS}/libiconv_configure ] || \
  ./configure --prefix=${PREFIXHOSTTOOLS} || \
    die "configure libiconv error" && \
      touch ${METADATAHOSTTOOLS}/libiconv_configure
[ -f ${METADATAHOSTTOOLS}/libiconv_build ] || \
  make -j${JOBS} || \
    die "build libiconv error" && \
      touch ${METADATAHOSTTOOLS}/libiconv_build
[ -f ${METADATAHOSTTOOLS}/libiconv_install ] || \
  make install || \
    die "install libiconv error" && \
      touch ${METADATAHOSTTOOLS}/libiconv_install
popd
