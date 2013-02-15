#! /bin/bash

source source.env

[ -f "${METADATAHOSTTOOLS}/host_tools_finished" ] || \
  source host-tools.step || \
    die "build host-tools error" && \
      touch ${METADATAHOSTTOOLS}/host_tools_finished

[ -f "${METADATAMIPS64ELTOOLCHAIN}/mips64el_tools_finished" ] || \
  source mips64el-linux-gnu.step || \
    die "build mips64el tools error" && \
      touch ${METADATAMIPS64ELTOOLCHAIN}/mips64el_tools_finished

[ -f "${METADATAUNIVERSAL}/mips_llvm_finished" ] || \
  source mips-llvm.step || \
    die "build llvm error" && \
      touch ${METADATAUNIVERSAL}/mips_llvm_finished

[ -f "${METADATAUNIVERSAL}/mips_qemu_finished" ] || \
  source mips-qemu.step || \
    die "build mips qemu error" && \
      touch ${METADATAUNIVERSAL}/mips_qemu_finished

[ -f "${METADATAUNIVERSAL}/qtc_finished" ] || \
  source qtc.step || \
    die "build qt creator error" && \
      touch ${METADATAUNIVERSAL}/qtc_finished
