#! /bin/bash

source common/source.env

pushd ${LIVE_SRC}
cd crossprojectmanager
git pull
popd
