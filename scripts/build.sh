#!/bin/sh


BASEDIR=$(dirname "$0")
SCRIPT_DIR=$(cd $BASEDIR && pwd)
PIPELINE_DIR=$(dirname $SCRIPT_DIR)
PIPELINE_BUILD_DIR=${PIPELINE_DIR}/build
PROJECT_DIR=${PIPELINE_DIR}/project



cd ${PROJECT_DIR}

autoupdate
autoreconf -i

./configure

make

# sudo make install

