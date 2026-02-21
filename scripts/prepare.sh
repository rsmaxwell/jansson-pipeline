#!/bin/bash


# ----------------------------
# Version / repository selection
# ----------------------------

# Returns tag name (without leading 'v') if HEAD is exactly tagged; empty otherwise
get_exact_release_tag() {
  local t
  t="$(git describe --tags --exact-match 2>/dev/null || true)"
  [[ -n "$t" ]] && echo "${t#v}" || true
}

# Derive a non-snapshot base version:
# - if exact tag exists, use it (handled earlier)
# - else use latest vX.Y.Z tag and bump patch
# - else fallback 0.0.0
derive_base_version() {
  local latest
  latest="$(git describe --tags --match 'v[0-9]*.[0-9]*.[0-9]*' --abbrev=0 2>/dev/null || true)"
  if [[ -n "$latest" ]]; then
    latest="${latest#v}"
    IFS=. read -r major minor patch <<<"$latest"
    patch=$((patch + 1))
    echo "${major}.${minor}.${patch}"
    return 0
  fi
  echo "0.0.0"
}

# Prefer a real Jenkins BUILD_ID if present
BUILD_ID="${BUILD_ID:-}"

# 1) Release build if HEAD is exactly tagged
RELEASE_TAG="$(get_exact_release_tag)"
if [[ -n "$RELEASE_TAG" ]]; then
  VERSION="$RELEASE_TAG"
  REPOSITORY="releases"
  REPOSITORYID="releases"

# 2) CI build (immutable integration)
elif [[ -n "$BUILD_ID" ]]; then
  BASE_VERSION="$(derive_base_version)"
  VERSION="${BASE_VERSION}-build-${BUILD_ID}"
  REPOSITORY="integration"
  REPOSITORYID="integration"

# 3) Ad-hoc / local snapshots
else
  BASE_VERSION="$(derive_base_version)"
  VERSION="${BASE_VERSION}-SNAPSHOT"
  REPOSITORY="snapshots"
  REPOSITORYID="snapshots"
  BUILD_ID="(none)"
fi

# ----------------------------
# 
# ----------------------------


BASEDIR=$(dirname "$0")
SCRIPT_DIR=$(cd $BASEDIR && pwd)
PIPELINE_DIR=$(dirname $SCRIPT_DIR)
PIPELINE_BUILD_DIR=${PIPELINE_DIR}/build







PROJECT=jansson

mkdir -p ${PIPELINE_BUILD_DIR}
cd ${PIPELINE_BUILD_DIR}




cat > versioninfo <<EOL
PROJECT="${PROJECT}"
REPOSITORY="${REPOSITORY}"
REPOSITORYID="${REPOSITORYID}"
EOL

pwd
ls -al 
cat versioninfo


