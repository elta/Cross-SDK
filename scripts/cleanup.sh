#! /bin/bash

source common/source.env

[ -d ${METADATA} ] && \
  for dir in `ls ${METADATA}`; do \
    [ "${dir}" != "download" ] && \
    rm -rf ${METADATA}/${dir}; \
  done;

[ -d ${SRC} ] && rm -rf ${SRC}
[ -d ${SRC} ] && rm -rf ${SRC}
[ -d ${BUILD} ] && rm -rf ${BUILD}
[ -d ${BUILD} ] && rm -rf ${BUILD}
