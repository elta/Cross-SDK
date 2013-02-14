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
[ -f "${METADATAMIPSELKERNEL}/linux_kernel_finished" ] || \
  source mipsel-linux-kernel.step || \
    die "build mipsel linux kernel and modules error" && \
      touch ${METADATAMIPSELKERNEL}/linux_kernel_finished
[ -f "${METADATAMIPSELROOTFS}/mipsel_rootfs_finished" ] || \
  source mipsel-linux-rootfs.step || \
    die "build mipsel rootfs error" && \
      touch ${METADATAMIPSELROOTFS}/mipsel_rootfs_finished
