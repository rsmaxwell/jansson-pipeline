#!/bin/sh

BASEDIR=$(dirname "$0")
SCRIPT_DIR=$(cd $BASEDIR && pwd)
PIPELINE_DIR=$(dirname $SCRIPT_DIR)
PIPELINE_PACKAGE_DIR=${PIPELINE_DIR}/package
PIPELINE_DIST_DIR=${PIPELINE_DIR}/dist

. ${PIPELINE_PACKAGE_DIR}/info

mvn --batch-mode --errors deploy:deploy-file \
	-DgroupId=${GROUPID} \
	-DartifactId=${ARTIFACTID} \
	-Dversion=${VERSION} \
	-Dpackaging=${PACKAGING} \
	-Dfile=${PIPELINE_DIST_DIR}/${ZIPFILE} \
	-DrepositoryId=${REPOSITORYID} \
	-Durl=${REPOSITORY_URL}

