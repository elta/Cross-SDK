#! /bin/bash

source source.sh

pushd ${SRC_LIVE}
cd openocd
git pull
popd

pushd ${SRC_LIVE}
cd llvmlinux
git pull
popd

pushd ${SRC_LIVE}
cd bionic
git pull
popd

pushd ${SRC_LIVE}
cd crossprojectmanager
git pull
popd
