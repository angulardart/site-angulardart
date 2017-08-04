#!/usr/bin/env bash

set -e -o pipefail

[[ -z "$NGIO_ENV_DEFS" ]] && . ./scripts/env-set.sh

if [[ -n $TRAVIS && $CI_TASK != build* ]]; then
  echo "check-all: nothing to check since this isn't a build task."
  exit 0;
fi

travis_fold start check_links
(set -x; ./scripts/check-links.sh)
travis_fold end check_links

travis_fold start check_code_excerpts
(set -x; ./scripts/check-code-excerpts.sh)
travis_fold end check_code_excerpts
