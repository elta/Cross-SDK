#! /bin/bash

source source.sh

pushd ${SRC_LIVE}
cd openocd
git pull
popd

pushd ${SRC_LIVE}
cd crossprojectmanager
git pull
popd
