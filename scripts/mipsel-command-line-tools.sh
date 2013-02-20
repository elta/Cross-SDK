#! /bin/bash

source common/source.env

[ -f "${METADATAHOSTTOOLS}/host_tools_finished" ] || \
  source common/host-tools.step || \
    die "build host-tools error" && \
      touch ${METADATAHOSTTOOLS}/host_tools_finished

[ -f "${METADATAMIPSELTOOLCHAIN}/mipsel_tools_finished" ] || \
  source mipsel/mipsel-linux-gnu.step || \
    die "build mipsel tools error" && \
      touch ${METADATAMIPSELTOOLCHAIN}/mipsel_tools_finished

[ -f "${METADATAUNIVERSAL}/mips_llvm_finished" ] || \
  source common/mips-llvm.step || \
    die "build llvm error" && \
      touch ${METADATAUNIVERSAL}/mips_llvm_finished

[ -f "${METADATAUNIVERSAL}/mips_qemu_finished" ] || \
  source common/mips-qemu.step || \
    die "build mips qemu error" && \
      touch ${METADATAUNIVERSAL}/mips_qemu_finished
