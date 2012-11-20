#! /bin/bash

function die() {
  echo "$1"
  exit 1
}

[ -e mips-universal.sh ]
export SCRIPT="$(pwd)"
export TARBALL=${SCRIPT}/../tarballs
export PATCH=${SCRIPT}/../patches
export SRC_LIVE=${SCRIPT}/../src_live
export METADATADOWN=${SCRIPT}/../metadata/download
export SRC=${SCRIPT}/../src
export BUILD=${SCRIPT}/../build

pushd ${SRC_LIVE}
cd qemu
git pull
popd

pushd ${SRC_LIVE}
cd openocd
git pull
popd

pushd ${SRC_LIVE}
cd u-boot
git pull
popd

pushd ${SRC_LIVE}
cd rtems
git pull
popd

pushd ${SRC_LIVE}
cd crossprojectmanager
git pull
popd
