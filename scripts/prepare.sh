#!/bin/sh


if [ -z "${BUILD_ID}" ]; then
    BUILD_ID="(none)"
    VERSION="0.0.1-SNAPSHOT"
    REPOSITORY=snapshots
    REPOSITORYID=snapshots
else
    VERSION="0.0.1.$((${BUILD_ID}))"
    REPOSITORY=releases
    REPOSITORYID=releases
fi


BASEDIR=$(dirname "$0")
SCRIPT_DIR=$(cd $BASEDIR && pwd)
PIPELINE_DIR=$(dirname $SCRIPT_DIR)
PIPELINE_BUILD_DIR=${PIPELINE_DIR}/build
PROJECT_DIR=${PIPELINE_DIR}/project
PROJECT_SOURCE_DIR=${PROJECT_DIR}/src
PROJECT=jansson

mkdir -p ${PIPELINE_BUILD_DIR}
cd ${PIPELINE_BUILD_DIR}

cat > versioninfo <<EOL
PROJECT="${PROJECT}"
VERSION="${VERSION}"
REPOSITORY="${REPOSITORY}"
REPOSITORYID="${REPOSITORYID}"
EOL

pwd
ls -al 
cat versioninfo
