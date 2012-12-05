#! /bin/bash

source source.sh

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
