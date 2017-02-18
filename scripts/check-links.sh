#!/usr/bin/env bash

set -e -o pipefail

[[ -z "$NGIO_ENV_DEFS" ]] && . ./scripts/env-set.sh

PORT=4001
export CHECK_EXIT_CODE=0

set -x
firebase serve --port $PORT > /dev/null &
FBS_PID=$!

sleep 4

linkcheck :4001 --skip-file ./scripts/config/linkcheck-skip-list.txt \
  | tee $TMP/linkcheck-log.txt

set +x

if ! grep '^\s*0 errors' $TMP/linkcheck-log.txt | wc -l > /dev/null; then
  CHECK_EXIT_CODE=1
fi

kill $FBS_PID

exit $CHECK_EXIT_CODE
