#!/usr/bin/env bash

set -e -o pipefail

[[ -z "$NGIO_ENV_DEFS" ]] && . ./scripts/env-set.sh

JADE_LOG=./jade-log.txt
CHECK_EXIT_CODE=0

if [ ! -e $JADE_LOG ]; then
  echo check-build: no Jade log file, so no Jade errors to report.
else
  echo Errors reported by Jade:
  if grep -v '^Warning' $JADE_LOG | wc -l > /dev/null; then
    grep -v '^Warning' $JADE_LOG
    CHECK_EXIT_CODE=1
  fi
fi
exit $CHECK_EXIT_CODE