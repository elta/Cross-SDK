#! /bin/bash

source source.env

[ -f "${METADATAHOSTTOOLS}/host_tools_finished" ] || \
  source host-tools.step || \
    die "build host-tools error" && \
      touch ${METADATAHOSTTOOLS}/host_tools_finished

[ -f "${METADATAMIPSELTOOLCHAIN}/mipsel_tools_finished" ] || \
  source mipsel-linux-tool.step || \
    die "build mipsel tools error" && \
      touch ${METADATAMIPSELTOOLCHAIN}/mipsel_tools_finished

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
