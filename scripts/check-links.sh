#!/usr/bin/env bash

set -e -o pipefail

[[ -z "$NGIO_ENV_DEFS" ]] && . ./scripts/env-set.sh

PORT=4001
export CHECK_EXIT_CODE=0

if [ ! -e "publish" ]; then
  echo "Site not built, skipping link check."
  exit $CHECK_EXIT_CODE
fi

set -x
((superstatic --port $PORT > /dev/null  2>&1) \
  || echo "Failed to launch superstatic server. Maybe it is already running?") &
SERVER_PID=$!

sleep 4

linkcheck :$PORT --skip-file ./scripts/config/linkcheck-skip-list.txt \
  | tee $TMP/linkcheck-log.txt

set +x

if ! grep '^\s*0 errors' $TMP/linkcheck-log.txt | wc -l > /dev/null; then
  CHECK_EXIT_CODE=1
fi

kill $SERVER_PID

exit $CHECK_EXIT_CODE
