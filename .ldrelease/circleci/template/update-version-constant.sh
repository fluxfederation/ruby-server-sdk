#!/bin/bash

set -ue

# Helper script used for projects that have a version string constant in their code in this format:
#     VERSION = "x.x.x"
# update-version-constant <path containing source files> <filename pattern for source files>

SOURCE_PATH=$1
FILENAME_PATTERN=$2

echo
SOURCE_FILES_WITH_VERSION=$(grep -rl --include "${FILENAME_PATTERN}" "^ *VERSION *= *['\"][^'\"]*['\"]" "${SOURCE_PATH}" || true)
if [ -z "${SOURCE_FILES_WITH_VERSION}" ]; then
  echo "No source files have a line that sets VERSION; the default update-version.sh cannot work"
  exit 1
fi
SOURCE_FILES_COUNT=$(awk '{print NF}' <<< "${SOURCE_FILES_WITH_VERSION}")
if [ "${SOURCE_FILES_COUNT}" != 1 ]; then
  echo "More than one source file has a line that sets VERSION; the default update-version.sh cannot work"
  exit 1
fi

echo "Setting version in ${SOURCE_FILES_WITH_VERSION} to ${LD_RELEASE_VERSION}"

FILE_TEMP="${SOURCE_FILES_WITH_VERSION}.tmp"
sed "s/^\( *VERSION *= ['\"]\)[^'\"]*\(['\"]\)/\1${LD_RELEASE_VERSION}\2/g" "${SOURCE_FILES_WITH_VERSION}" > "${FILE_TEMP}"
if grep -q "['\"]${LD_RELEASE_VERSION}['\"']" "${FILE_TEMP}"; then
  mv "${FILE_TEMP}" "${SOURCE_FILES_WITH_VERSION}"
else
  echo "Version update failed" >&2
  cat "${FILE_TEMP}"
  exit 1
fi
