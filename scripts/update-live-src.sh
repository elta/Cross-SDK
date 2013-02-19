#! /bin/bash

source source.env

pushd ${LIVE_SRC}
cd crossprojectmanager
git pull
popd
