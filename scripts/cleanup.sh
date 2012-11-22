#! /bin/bash

export SCRIPT="$(pwd)"

export METADATA=${SCRIPT}/../metadata/
export SRC=${SCRIPT}/../src/
export BUILD=${SCRIPT}/../build/

export TOOLS=/tools
export CROSS_TOOLS=/cross-tools

[ -d ${METADATA} ] && rm -rf ${METADATA}
[ -d ${SRC} ] && rm -rf ${SRC}
[ -d ${BUILD} ] && rm -rf ${BUILD}

[ -d ${TOOLS} ] && sudo rm -rf ${TOOLS}
[ -d ${CROSS_TOOLS} ] && sudo rm -rf ${CROSS_TOOLS}
