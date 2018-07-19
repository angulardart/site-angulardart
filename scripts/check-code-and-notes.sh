#!/usr/bin/env bash

set -e -o pipefail

[[ -z "$DART_SITE_ENV_DEFS" ]] && . ./scripts/env-set.sh

keys="code note fmt sdk"
if [[ $1 == -h ]]; then
  echo "Usage: selectively test any one of the following: $keys"
  exit 0
fi

ARGS=$(tr [:upper:] [:lower:] <<< "$*")
: ${ARGS:=$keys}

errorMessage="
Error: some code excerpts need to be refreshed.
Rerun './scripts/refresh-code-excerpts.sh' locally.
"

if [[ $ARGS == *code* ]]; then
  travis_fold start refresh_code_excerpts
  echo "Doc code excerpts: checking freshness"
  echo
  (set -x; ./scripts/refresh-code-excerpts.sh) || (printf "$errorMessage" && exit 1)
  travis_fold end refresh_code_excerpts
fi

if [[ $ARGS == *note* ]]; then
  travis_fold start note_refresh
  echo "Angular/note pages: checking freshness"
  echo
  (set -x; gulp note-refresh; gulp git-status-exit-on-change --filter=/angular/note/)
  travis_fold end note_refresh
fi

if [[ $ARGS == *fmt* ]]; then
  travis_fold start dartfmt
  (set -x; gulp dartfmt)
  travis_fold end dartfmt
fi

if [[ $ARGS == *sdk* ]]; then
  travis_fold start SDK_constraints
  echo "SDK constraints: checking that example constraints match angular's"
  echo
  (set -x;
  diff <(grep sdk: examples/ng/doc/quickstart/pubspec.yaml) \
        <(sed -e s/\"/\'/g site-angular/angular/pubspec.yaml | grep sdk:)
  )
  travis_fold end SDK_constraints
fi
