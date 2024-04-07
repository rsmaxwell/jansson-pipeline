#!/bin/sh


BASEDIR=$(dirname "$0")
SCRIPT_DIR=$(cd $BASEDIR && pwd)
PIPELINE_DIR=$(dirname $SCRIPT_DIR)
PIPELINE_BUILD_DIR=${PIPELINE_DIR}/build
PIPELINE_DIST_DIR=${PIPELINE_DIR}/dist

cd ${PIPELINE_BUILD_DIR}

. ./machineinfo
. ./versioninfo

GROUPID=com.rsmaxwell.example
ARTIFACTID=${PROJECT}_${FAMILY}_${ARCHITECTURE}
VERSION="${PACKAGE_VERSION}${SUFFIX}"
PACKAGING=zip
URL=https://pluto.rsmaxwell.co.uk/archiva/repository/${REPOSITORY}
ZIPFILE=${ARTIFACTID}_${VERSION}.${PACKAGING}

cd ${PIPELINE_DIST_DIR}

mvn --batch-mode --errors deploy:deploy-file \
	-DgroupId=${GROUPID} \
	-DartifactId=${ARTIFACTID} \
	-Dversion=${VERSION} \
	-Dpackaging=${PACKAGING} \
	-Dfile=${ZIPFILE} \
	-DrepositoryId=${REPOSITORYID} \
	-Durl=${URL}

