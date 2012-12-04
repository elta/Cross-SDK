#! /bin/bash

source source.sh

[ -d "${SRCUNIVERSAL}" ] ||  mkdir -p "${SRCUNIVERSAL}"
[ -d "${BUILDUNIVERSAL}" ] ||  mkdir -p "${BUILDUNIVERSAL}"
[ -d "${METADATAUNIVERSAL}" ] || mkdir -p "${METADATAUNIVERSAL}"

#################################################################
### universal extract
#################################################################
pushd ${SRCUNIVERSAL}
[ -f ${METADATAUNIVERSAL}/llvm_extract ] || \
tar xf ${TARBALL}/llvm-${LLVM_VERSION}.${LLVM_SUFFIX} || \
  die "extract llvm error" && \
    touch ${METADATAUNIVERSAL}/llvm_extract
popd

#################################################################
### qemu build
#################################################################
pushd ${BUILDUNIVERSAL}
[ -d "qemu-build" ] || mkdir qemu-build
cd qemu-build
[ -f "${METADATAUNIVERSAL}/qemu_configure" ] || \
  ${SRC_LIVE}/qemu/configure \
  --prefix=${PREFIXQEMU} --target-list=${QEMU_TARGET} \
  --enable-debug-tcg || \
    die "***config qemu error" &&
      touch ${METADATAUNIVERSAL}/qemu_configure
[ -f "${METADATAUNIVERSAL}/qemu_build" ] || \
  make -j${JOBS} || die "***build qemu error" && \
    touch ${METADATAUNIVERSAL}/qemu_build
[ -f "${METADATAUNIVERSAL}/qemu_install" ] || \
  make install || die "***install qemu error" && \
    touch ${METADATAUNIVERSAL}/qemu_install
popd
