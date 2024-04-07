#!/bin/sh


BASEDIR=$(dirname "$0")
SCRIPT_DIR=$(cd $BASEDIR && pwd)
PIPELINE_DIR=$(dirname $SCRIPT_DIR)
PROJECT_DIR=${PIPELINE_DIR}/project




cd ${PROJECT_DIR}



make check

