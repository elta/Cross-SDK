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

[ -f ${METADATAUNIVERSAL}/clang_extract ] || \
cd llvm-${LLVM_VERSION}/tools && \
tar xf ${TARBALL}/clang-${CLANG_VERSION}.${CLANG_SUFFIX} || \
  die "extract clang error" && \
    touch ${METADATAUNIVERSAL}/clang_extract
popd

#################################################################
### llvm build
#################################################################
pushd ${BUILDUNIVERSAL}
[ -d "llvm-build" ] || mkdir llvm-build
cd llvm-build
[ -f "${METADATAUNIVERSAL}/llvm_configure" ] || \
  cmake -DCMAKE_INSTALL_PREFIX=${PREFIXLLVM} \
        -DLLVM_TARGETS_TO_BUILD="X86;Mips" \
  ${SRCUNIVERSAL}/llvm-${LLVM_VERSION} || \
    die "***config llvm error" &&
      touch ${METADATAUNIVERSAL}/llvm_configure
[ -f "${METADATAUNIVERSAL}/llvm_build" ] || \
  make -j${JOBS} || die "***build llvm error" && \
    touch ${METADATAUNIVERSAL}/llvm_build
[ -f "${METADATAUNIVERSAL}/llvm_install" ] || \
  make install || die "***install llvm error" && \
    touch ${METADATAUNIVERSAL}/llvm_install
popd
