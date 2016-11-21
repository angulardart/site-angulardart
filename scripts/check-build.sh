#!/usr/bin/env bash

set -e -o pipefail

[[ -z "$NGIO_ENV_DEFS" ]] && . ./scripts/env-set.sh

JADE_LOG=./jade-log.txt
CHECK_EXIT_CODE=0

travis_fold start check_build

travis_fold start check_build.errors
echo Errors reported by Jade:
if grep -v '^Warning' $JADE_LOG | wc -l > /dev/null; then
  grep -v '^Warning' $JADE_LOG
  CHECK_EXIT_CODE=1
fi
travis_fold end check_build.errors

# Commenting the following out becase typically, the full log has already been shown; don't show it again
# echo
# travis_fold start check_build.warnings
# echo Full Jade log:
# cat $JADE_LOG
# travis_fold end check_build.warnings

exit $CHECK_EXIT_CODE