#!/bin/sh

BASEDIR=$(dirname "$0")
SCRIPT_DIR=$(cd $BASEDIR && pwd)
PIPELINE_DIR=$(dirname $SCRIPT_DIR)
PIPELINE_PACKAGE_DIR=${PIPELINE_DIR}/package
PIPELINE_DOWNLOADS_DIR=${PIPELINE_DIR}/downloads

. ${BUILD_DIR}/buildinfo


if [ -f ${HOME}/.m2/maven-repository-info ]; then
    . ${HOME}/.m2/maven-repository-info
elif [ -f ./maven-repository-info ]; then
    . ./maven-repository-info
fi

if [ -z "${MAVEN_REPOSITORY_BASE_URL}" ]; then
    echo "'MAVEN_REPOSITORY_BASE_URL' is not defined"
    exit 1
fi

REPOSITORY_URL="${MAVEN_REPOSITORY_BASE_URL}/${REPOSITORY}"




mvn --batch-mode --errors dependency:get \
	-DremoteRepositories=${REPOSITORY_URL} \
	-DgroupId=${GROUPID} \
	-DartifactId=${ARTIFACTID} \
	-Dversion=${VERSION} \
	-Dpackaging=${PACKAGING} \
	-Dtransitive=false
result=$?
if [ ! ${result} -eq 0 ]; then
    echo "deployment failed"
    echo "Error: $0[${LINENO}] result: ${result}"
    exit 1
fi


mkdir -p ${PIPELINE_DOWNLOADS_DIR}
cd ${PIPELINE_DOWNLOADS_DIR}


mvn --batch-mode --errors dependency:copy \
	-Dartifact=${GROUPID}:${ARTIFACTID}:${VERSION}:${PACKAGING} \
	-DoutputDirectory=.
result=$?
if [ ! ${result} -eq 0 ]; then
    echo "deployment failed"
    echo "Error: $0[${LINENO}] result: ${result}"
    exit 1
fi


echo "Success"

