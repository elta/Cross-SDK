#! /bin/bash

source common/source.env

pushd ${LIVE_SRC}
cd qt-crossprojectmanager
git pull
popd
