#! /bin/bash

source source.env

export MOD_ROOTFS=1

[ -f "${METADATAHOSTTOOLS}/host_tools_finished" ] || \
  source host-tools.step || \
    die "build host-tools error" && \
      touch ${METADATAHOSTTOOLS}/host_tools_finished

[ -f "${METADATAMIPS64ELTOOLCHAIN}/mips64el_tools_finished" ] || \
  source mips64el-linux-gnu.step || \
    die "build mips64el tools error" && \
      touch ${METADATAMIPS64ELTOOLCHAIN}/mips64el_tools_finished

[ -f "${METADATAMIPS64ELROOTFS}/mips64el_rootfs_finished" ] || \
  source mips64el-gnu-rootfs.step || \
    die "build mipsel rootfs error" && \
      touch ${METADATAMIPS64ELROOTFS}/mips64el_rootfs_finished

[ -f "${METADATAMIPS64ELKERNEL}/linux_n32_64_kernel_finished" ] || \
  source mips64el-linux.step || \
    die "build mips64el linux n32/64 kernel and modules error" && \
      touch ${METADATAMIPS64ELKERNEL}/linux_n32_64_kernel_finished
