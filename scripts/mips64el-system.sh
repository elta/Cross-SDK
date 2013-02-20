#! /bin/bash

source common/source.env

export MOD="gnu-rootfs"

[ -f "${METADATAHOSTTOOLS}/host_tools_finished" ] || \
  source common/host-tools.step || \
    die "build host-tools error" && \
      touch ${METADATAHOSTTOOLS}/host_tools_finished

[ -f "${METADATAMIPS64ELTOOLCHAIN}/mips64el_tools_finished" ] || \
  source mips64el/mips64el-linux-gnu.step || \
    die "build mips64el tools error" && \
      touch ${METADATAMIPS64ELTOOLCHAIN}/mips64el_tools_finished

[ -f "${METADATAMIPS64ELKERNEL}/linux_n32_64_kernel_finished" ] || \
  source mips64el/mips64el-linux.step || \
    die "build mips64el linux n32/64 kernel and modules error" && \
      touch ${METADATAMIPS64ELKERNEL}/linux_n32_64_kernel_finished

[ -f "${METADATAMIPS64ELROOTFS}/mips64el_rootfs_finished" ] || \
  source mips64el/mips64el-gnu-rootfs.step || \
    die "build mipsel rootfs error" && \
      touch ${METADATAMIPS64ELROOTFS}/mips64el_rootfs_finished

[ -f "${METADATAMIPS64ELROOTFSCREATEIMG}/mips64el_rootfs_create_img_finished" ] || \
  source mips64el/mips64el-gnu-rootfs-img.step || \
    die "create mipsel rootfs img error" && \
      touch ${METADATAMIPS64ELROOTFSCREATEIMG}/mips64el_rootfs_create_img_finished
