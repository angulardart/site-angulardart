#!/usr/bin/env bash

set -e -o pipefail

readonly webdevRepoDir="$(cd "$(dirname "$0")/.." && pwd)"

function usage() {
  echo $1; echo
  echo "Usage: $(basename $0) [--api] [path-to-src-file-or-folder]"; echo
  exit 1;
}

if [[ $1 == '-h' || $1 == '--help' ]]; then usage; fi

[[ -z "$NGIO_ENV_DEFS" ]] && . $webdevRepoDir/scripts/env-set.sh

if [[ -z "$CEU_REPO" || ! -e $CEU_REPO ]]; then
  echo "ERROR: expect to find repo at $CEU_REPO. Ensure that you have it checked out."
  exit 1
fi

ARGS='--escape-ng-interpolation --indentation 2'

if [[ $1 == '--api' ]]; then
  API='/_api'
  shift
  ARGS='--no-escape-ng-interpolation'
fi

SRC="$1"
: ${SRC:="$webdevRepoDir/src/angular"}
[[ -e $SRC ]] || usage "ERROR: source file/folder does not exist: '$SRC'"

FRAG="$webdevRepoDir/tmp/_fragments$API"
[[ -e $FRAG ]] || usage "ERROR: fragments folder does not exist: '$FRAG'"

echo "Source:     $SRC"
echo "Fragments:  $FRAG"
echo "Other args: $ARGS"
LOG_FILE=$TMP/check-code-excerpts-log.txt
dart $CEU_REPO/bin/code_excerpt_updater.dart \
  --fragment-dir-path "$FRAG" \
  $ARGS \
  --write-in-place \
  "$SRC" 2>&1 | tee $LOG_FILE
LOG=$(cat $LOG_FILE)

[[ $LOG == *" 0 out of"* && $LOG != *Error* ]]
