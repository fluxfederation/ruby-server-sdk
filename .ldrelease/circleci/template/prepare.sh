#!/bin/bash

set -ue

echo "Using gem $(gem --version)"

# If the gemspec specifies a certain version of bundler, install that version and uninstall any
# other versions that were present.

GEMSPEC_BUNDLER_VERSION=$(sed -n -e "s/.*['\"]bundler['\"], *['\"]\([^'\"]*\)['\"]/\1/p" ./*.gemspec | tr -d ' ')
if [ -n "${GEMSPEC_BUNDLER_VERSION}" ]; then
  echo "Uninstalling previous bundler version(s)"
  gem uninstall bundler -a --silent
  echo "Installing bundler version ${GEMSPEC_BUNDLER_VERSION} specified by gemspec"
  gem install bundler -v "${GEMSPEC_BUNDLER_VERSION}" || { echo "installing bundler failed" >&2; exit 1; }
else
  echo "No specific bundler version found in gemspec; installing default"
  gem install bundler
fi
