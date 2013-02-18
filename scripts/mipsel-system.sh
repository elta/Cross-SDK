#! /bin/bash

source source.env

[ -f "${METADATAHOSTTOOLS}/host_tools_finished" ] || \
  source host-tools.step || \
    die "build host-tools error" && \
      touch ${METADATAHOSTTOOLS}/host_tools_finished

echo $(pwd)
[ -f "${METADATAMIPSELTOOLCHAIN}/mipsel_tools_finished" ] || \
  source mipsel-linux-gnu.step || \
    die "build mipsel tools error" && \
      touch ${METADATAMIPSELTOOLCHAIN}/mipsel_tools_finished

echo $(pwd)
[ -f "${METADATAMIPSELROOTFS}/mipsel_rootfs_finished" ] || \
  source mipsel-gnu-rootfs.step || \
    die "build mipsel rootfs error" && \
      touch ${METADATAMIPSELROOTFS}/mipsel_rootfs_finished

echo $(pwd)
[ -f "${METADATAMIPSELKERNEL}/linux_kernel_finished" ] || \
  source mipsel-linux.step || \
    die "build mipsel linux kernel and modules error" && \
      touch ${METADATAMIPSELKERNEL}/linux_kernel_finished
