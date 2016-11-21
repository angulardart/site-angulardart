#!/usr/bin/env bash

set -e -o pipefail

[[ -z "$NGIO_ENV_DEFS" ]] && . ./scripts/env-set.sh
[[ -n "$TRAVIS" ]] && . ./scripts/env-info-and-check.sh

travis_fold start before_install.npm_install
(set -x; npm install -g firebase-tools gulp --no-optional)
travis_fold end before_install.npm_install
