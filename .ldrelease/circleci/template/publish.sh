#!/bin/bash

set -ue

# Standard publish.sh for Ruby-based projects - we can assume build.sh has already been run

export GEM_HOST_API_KEY="$(cat "${LD_RELEASE_SECRETS_DIR}/ruby_gems_api_key")"

# Since all Releaser builds are clean builds, we can assume that the only .gem file here
# is the one we just built
for gemfile in ./*.gem; do
  echo "Running gem push $gemfile"
  gem push "$gemfile" || { echo "gem push failed" >&2; exit 1; }
done
