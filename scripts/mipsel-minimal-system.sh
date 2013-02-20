#! /bin/bash

source source.env

export MOD="busybox"

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

[ -f "${METADATABUSYBOX_32}/mipsel_busybox_finished" ] || \
  source mipsel-busybox.step || \
    die "build mipsel busybox error" && \
      touch ${METADATABUSYBOX_32}/mipsel_busybox_finished

[ -f "${METADATAMIPSELBUSYBOXCREATEIMG}/mipsel_busybox_create_img_finished" ] || \
  source mipsel-busybox-create-img.step || \
    die "create mipsel busybox img error" && \
      touch ${METADATAMIPSELBUSYBOXCREATEIMG}/mipsel_busybox_create_img_finished
