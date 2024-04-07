#!/bin/sh


FAMILY=""
ARCHITECTURE=""

case "$(uname -s)" in
    CYGWIN*) FAMILY="cygwin" ;;
    Linux*) 
        . /etc/os-release
        case ${ID} in
            ubuntu) FAMILY="linux" ;;
            alpine) FAMILY="alpine" ;;
            *) FAMILY="linux" ;;
        esac
        ;;
    *) FAMILY="unknown" ;;
esac

case "$(uname -m)" in 
  amd64|x86_64)   ARCHITECTURE="amd64" ;; 
  *) ARCHITECTURE="x86" ;; 
esac 



BASEDIR=$(dirname "$0")
SCRIPT_DIR=$(cd $BASEDIR && pwd)
PIPELINE_DIR=$(dirname $SCRIPT_DIR)
PIPELINE_BUILD_DIR=${PIPELINE_DIR}/build
PROJECT_DIR=${PIPELINE_DIR}/project
PROJECT_BUILD_DIR=${PROJECT_DIR}/src



cd ${PIPELINE_BUILD_DIR}
. ./versioninfo


cat > machineinfo <<EOL
FAMILY="${FAMILY}"
ARCHITECTURE="${ARCHITECTURE}"
EOL

pwd
ls -al 
cat machineinfo



cd ${PROJECT_BUILD_DIR}

autoreconf -i
