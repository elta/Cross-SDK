#! /bin/bash

export SCRIPT="$(pwd)"

export METADATA=${SCRIPT}/../metadata
export SRC=${SCRIPT}/../src
export BUILD=${SCRIPT}/../build

[ -d ${METADATA} ] && \
  for dir in `ls ${METADATA}`; do \
    [ "${dir}" != "download" ] && \
    rm -rf ${METADATA}/${dir}; \
  done;

[ -d ${SRC} ] && rm -rf ${SRC}
[ -d ${SRC} ] && rm -rf ${SRC}
[ -d ${BUILD} ] && rm -rf ${BUILD}
[ -d ${BUILD} ] && rm -rf ${BUILD}
