#! /bin/bash

source source.env

[ -f "${METADATAHOSTTOOLS}/host_tools_finished" ] || \
  source host-tools.step || \
    die "build host-tools error" && \
      touch ${METADATAHOSTTOOLS}/host_tools_finished

[ -f "${METADATAMIPSELTOOLCHAIN}/mipsel_tools_finished" ] || \
  source mipsel-linux-gnu.step || \
    die "build mipsel tools error" && \
      touch ${METADATAMIPSELTOOLCHAIN}/mipsel_tools_finished

[ -f "${METADATABUSYBOX_32}/mipsel_busybox_finished" ] || \
  source mipsel-busybox.step || \
    die "build mipsel busybox error" && \
      touch ${METADATABUSYBOX_32}/mipsel_busybox_finished

[ -f "${METADATAMIPSELKERNEL}/linux_kernel_finished" ] || \
  source mipsel-linux.step || \
    die "build mipsel linux kernel and modules error" && \
      touch ${METADATAMIPSELKERNEL}/linux_kernel_finished
