#! /bin/bash

source source.env

[ -d "${SRCHOSTTOOLS}" ] || mkdir -p "${SRCHOSTTOOLS}"
[ -d "${METADATAHOSTTOOLS}" ] || mkdir -p "${METADATAHOSTTOOLS}"

pushd ${SRCHOSTTOOLS}
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

[ -f ${METADATAHOSTTOOLS}/make_extract ] || \
  tar vxf ${TARBALL}/make-${MAKE_VERSION}.${MAKE_SUFFIX} || \
    die "extract make error" && \
      touch ${METADATAHOSTTOOLS}/make_extract

[ -f ${METADATAHOSTTOOLS}/sed_extract ] || \
  tar vxf ${TARBALL}/sed-${SED_VERSION}.${SED_SUFFIX} || \
    die "extract sed error" && \
      touch ${METADATAHOSTTOOLS}/sed_extract

[ -f ${METADATAHOSTTOOLS}/texinfo_extract ] || \
  tar vxf ${TARBALL}/texinfo-${TEXINFO_VERSION}a.${TEXINFO_SUFFIX} || \
    die "extract texinfo error" && \
      touch ${METADATAHOSTTOOLS}/texinfo_extract

[ -f ${METADATAHOSTTOOLS}/perl_extract ] || \
  tar xf ${TARBALL}/perl-${PERL_VERSION}.${PERL_SUFFIX} || \
    die "***extract perl error" && \
      touch ${METADATAHOSTTOOLS}/perl_extract

[ -f ${METADATAHOSTTOOLS}/python_extract ] || \
  tar xf ${TARBALL}/python-${PYTHON_VERSION}.${PYTHON_SUFFIX} || \
    die "***extract python error" && \
      touch ${METADATAHOSTTOOLS}/python_extract
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
cd make-${MAKE_VERSION}
[ -f ${METADATAHOSTTOOLS}/make_configure ] || \
  ./configure --prefix=${PREFIXHOSTTOOLS} || \
    die "configure sed error" && \
      touch ${METADATAHOSTTOOLS}/make_configure
[ -f ${METADATAHOSTTOOLS}/make_build ] || \
  make -j${JOBS} || \
    die "build make error" && \
      touch ${METADATAHOSTTOOLS}/make_build
[ -f ${METADATAHOSTTOOLS}/make_install ] || \
  make install || \
    die "install make error" && \
      touch ${METADATAHOSTTOOLS}/make_install
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
