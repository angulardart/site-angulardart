#!/usr/bin/env bash

set -e -o pipefail

[[ -z "$NGIO_ENV_DEFS" ]] && . ./scripts/env-set.sh

PORT=4001
export CHECK_EXIT_CODE=0

if [ ! -e "publish" ]; then
  echo "Site not built, skipping link check."
  exit $CHECK_EXIT_CODE
elif [ -n "$FIREBASE_TOKEN" ]; then
  FB_TOKEN_OPTN="--token $FIREBASE_TOKEN"
elif [ -n "$TRAVIS" ]; then
  echo "===================================================================="
  echo "Warning: Travis requires that FIREBASE_TOKEN be set so that firebase"
  echo "Warning: serve can run. It isn't set, so skipping link check."
  echo "===================================================================="
  exit $CHECK_EXIT_CODE
fi

set -x
: ${FB_PROJ:=dev}
firebase serve --port $PORT $FB_TOKEN_OPTN --project $FB_PROJ > /dev/null &
FBS_PID=$!

sleep 4

pub global run linkcheck :$PORT --skip-file ./scripts/config/linkcheck-skip-list.txt \
  | tee $TMP/linkcheck-log.txt

set +x

if ! grep '^\s*0 errors' $TMP/linkcheck-log.txt | wc -l > /dev/null; then
  CHECK_EXIT_CODE=1
fi

kill $FBS_PID

exit $CHECK_EXIT_CODE
