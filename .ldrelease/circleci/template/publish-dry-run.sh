#!/bin/bash

set -ue

echo "DRY RUN: not publishing to RubyGems, only copying gem"

cp ./*.gem "${LD_RELEASE_ARTIFACTS_DIR}"
