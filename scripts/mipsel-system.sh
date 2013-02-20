#! /bin/bash

source source.env

export MOD="gnu-rootfs"

[ -f "${METADATAHOSTTOOLS}/host_tools_finished" ] || \
  source host-tools.step || \
    die "build host-tools error" && \
      touch ${METADATAHOSTTOOLS}/host_tools_finished

[ -f "${METADATAMIPSELTOOLCHAIN}/mipsel_tools_finished" ] || \
  source mipsel-linux-gnu.step || \
    die "build mipsel tools error" && \
      touch ${METADATAMIPSELTOOLCHAIN}/mipsel_tools_finished

[ -f "${METADATAMIPSELKERNEL}/linux_kernel_finished" ] || \
  source mipsel-linux.step || \
    die "build mipsel linux kernel and modules error" && \
      touch ${METADATAMIPSELKERNEL}/linux_kernel_finished

[ -f "${METADATAMIPSELROOTFS}/mipsel_rootfs_finished" ] || \
  source mipsel-gnu-rootfs.step || \
    die "build mipsel rootfs error" && \
      touch ${METADATAMIPSELROOTFS}/mipsel_rootfs_finished

[ -f "${METADATAMIPSELROOTFSCREATEIMG}/mipsel_rootfs_create_img_finished" ] || \
  source mipsel-gnu-rootfs-img.step || \
    die "create mipsel rootfs img error" && \
      touch ${METADATAMIPSELROOTFSCREATEIMG}/mipsel_rootfs_create_img_finished
