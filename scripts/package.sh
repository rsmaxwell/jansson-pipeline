#!/bin/sh


BASEDIR=$(dirname "$0")
SCRIPT_DIR=$(cd $BASEDIR && pwd)
PIPELINE_DIR=$(dirname $SCRIPT_DIR)
PIPELINE_BUILD_DIR=${PIPELINE_DIR}/build
PIPELINE_PACKAGE_DIR=${PIPELINE_DIR}/package
PIPELINE_DIST_DIR=${PIPELINE_DIR}/dist
PROJECT_DIR=${PIPELINE_DIR}/project
PROJECT_BUILD_DIR=${PROJECT_DIR}/src


. ${PIPELINE_BUILD_DIR}/versioninfo
. ${PIPELINE_BUILD_DIR}/machineinfo


if [ -z "${BUILD_ID}" ]; then
    SUFFIX="-SNAPSHOT"
    REPOSITORY=snapshots
    REPOSITORYID=snapshots
else
    SUFFIX=""
    REPOSITORY=releases
    REPOSITORYID=releases
fi

grep "PACKAGE_VERSION=" ${PROJECT_DIR}/configure > /tmp/temp
. /tmp/temp
rm -rf /tmp/temp



rm -rf ${PIPELINE_PACKAGE_DIR} ${PIPELINE_DIST_DIR}
mkdir -p ${PIPELINE_PACKAGE_DIR} ${PIPELINE_DIST_DIR}

cd ${PIPELINE_PACKAGE_DIR}

cp ${PROJECT_BUILD_DIR}/.libs/libjansson.so .
cp ${PROJECT_BUILD_DIR}/.libs/libjansson.exp .
cp ${PROJECT_BUILD_DIR}/.libs/libjansson.la .
cp ${PROJECT_BUILD_DIR}/jansson.h .
cp ${PROJECT_BUILD_DIR}/jansson.def .


PROJECT=jansson
GROUPID="com.rsmaxwell.jansson"
VERSION="${PACKAGE_VERSION}${SUFFIX}"
ARTIFACTID=${PROJECT}_${FAMILY}_${ARCHITECTURE}
PACKAGING=zip
ZIPFILE=${ARTIFACTID}_${VERSION}.${PACKAGING}







cat <<EOT >> buildinfo
PACKAGE_VERSION="${PACKAGE_VERSION}"
VERSION="${VERSION}"
BUILD_ID="${BUILD_ID}"
BUILD_TIME="$(date '+%Y-%m-%d %H:%M:%S')"
GIT_COMMIT="${GIT_COMMIT}"
GIT_BRANCH="${GIT_BRANCH}"
GIT_URL="${GIT_URL}"
ARTIFACTID="${ARTIFACTID}"
PACKAGING="${PACKAGING}"
ZIPFILE="${ZIPFILE}"
PROJECT="${PROJECT}"
GROUPID="${GROUPID}"
FAMILY="${FAMILY}"
ARCHITECTURE="${ARCHITECTURE}"
REPOSITORY="${REPOSITORY}"
REPOSITORYID="${REPOSITORYID}"
EOT



zip ${PIPELINE_DIST_DIR}/${ZIPFILE} *
