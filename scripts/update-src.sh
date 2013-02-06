#! /bin/bash

source source.env

pushd ${SRC_LIVE}
cd llvmlinux
git pull
popd

pushd ${SRC_LIVE}
cd crossprojectmanager
git pull
popd
