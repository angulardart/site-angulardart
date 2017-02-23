#!/usr/bin/env bash
#
# Get the stagehand `web-angular-simple`

set -e -o pipefail

[[ -z "$NGIO_ENV_DEFS" ]] && . ./scripts/env-set.sh

TMP_QS="$TMP/angular_quickstart"

if [[ "$1" == '--clean' ]]; then
  rm -Rf "$TMP_QS";
fi

if [[ ! -e "$TMP_QS" ]]; then
  (set -x; mkdir -p "$TMP_QS")
fi

travis_fold start get_angular_quickstart
set -x
cd "$TMP_QS"
pub global run stagehand web-angular-simple
pub get
set +x
travis_fold end get_angular_quickstart
