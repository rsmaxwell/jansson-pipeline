#!/bin/sh


BASEDIR=$(dirname "$0")
SCRIPT_DIR=$(cd $BASEDIR && pwd)
PROJECT_DIR=$(dirname $SCRIPT_DIR)/project
BUILD_DIR=${PROJECT_DIR}/build
TEST_DIR=${PROJECT_DIR}/test

rm -rf ${TEST_DIR}
mkdir -p ${TEST_DIR}
cd ${TEST_DIR}



${BUILD_DIR}/example-c

