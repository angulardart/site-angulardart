#!/usr/bin/env bash

set -e -o pipefail

[[ -z "$NGIO_ENV_DEFS" ]] && . ./scripts/env-set.sh
[[ -n "$TRAVIS" ]] && . ./scripts/env-info-and-check.sh

travis_fold start before_install.npm_install
(set -x; npm install -g firebase-tools@3.5 gulp --no-optional)
travis_fold end before_install.npm_install

travis_fold start before_install.linkcheck
(set -x; pub global activate linkcheck)
travis_fold end before_install.linkcheck

travis_fold start before_install.dartdoc
echo "Use git repo version of dartdoc until most recent changes have made it into the SDK."
echo "Also see dartdoc command usage in gulp/dartdoc.js."
(set -x; pub global activate dartdoc)
travis_fold end before_install.dartdoc
