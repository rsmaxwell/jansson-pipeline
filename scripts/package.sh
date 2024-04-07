#!/bin/sh


BASEDIR=$(dirname "$0")
SCRIPT_DIR=$(cd $BASEDIR && pwd)
PIPELINE_DIR=$(dirname $SCRIPT_DIR)
PIPELINE_BUILD_DIR=${PIPELINE_DIR}/build
PIPELINE_PACKAGE_DIR=${PIPELINE_DIR}/package
PIPELINE_DIST_DIR=${PIPELINE_DIR}/dist
PROJECT_DIR=${PIPELINE_DIR}/project
PROJECT_BUILD_DIR=${PROJECT_DIR}/src

cd ${PIPELINE_BUILD_DIR}

. ./machineinfo




if [ -z "${BUILD_ID}" ]; then
    SUFFIX="-SNAPSHOT"
    REPOSITORY=snapshots
    REPOSITORYID=snapshots
else
    SUFFIX=".${BUILD_ID}"
    REPOSITORY=releases
    REPOSITORYID=releases
fi

grep "PACKAGE_VERSION=" ${PROJECT_DIR}/configure > versioninfo
echo "SUFFIX=\"${SUFFIX}\""                     >> versioninfo
echo "REPOSITORY=\"${REPOSITORY}\""             >> versioninfo
echo "REPOSITORYID=\"${REPOSITORYID}\""         >> versioninfo

. ./versioninfo




rm -rf ${PIPELINE_PACKAGE_DIR} ${PIPELINE_DIST_DIR}
mkdir -p ${PIPELINE_PACKAGE_DIR} ${PIPELINE_DIST_DIR}

cd ${PIPELINE_PACKAGE_DIR}
cp ${PROJECT_BUILD_DIR}/.libs/libjansson.so .
cp ${PROJECT_BUILD_DIR}/.libs/libjansson.exp .
cp ${PROJECT_BUILD_DIR}/.libs/libjansson.la .
cp ${PROJECT_BUILD_DIR}/jansson.h .
cp ${PROJECT_BUILD_DIR}/jansson.def .


VERSION="${PACKAGE_VERSION}${SUFFIX}"

echo "PACKAGE_VERSION=\"${PACKAGE_VERSION}\""       > info.sh
echo "VERSION=\"${VERSION}\""                      >> info.sh
echo "BUILD_ID=\"${BUILD_ID}\""                    >> info.sh
echo "TIMESTAMP=\"$(date '+%Y-%m-%d %H:%M:%S')\""  >> info.sh
echo "GIT_COMMIT=\"${GIT_COMMIT:-(none)}\""        >> info.sh
echo "GIT_BRANCH=\"${GIT_BRANCH:-(none)}\""        >> info.sh
echo "GIT_URL=\"${GIT_URL:-(none)}\""              >> info.sh






ARTIFACTID=${PROJECT}_${FAMILY}_${ARCHITECTURE}
PACKAGING=zip
ZIPFILE=${ARTIFACTID}_${VERSION}.${PACKAGING}

zip ${PIPELINE_DIST_DIR}/${ZIPFILE} *
