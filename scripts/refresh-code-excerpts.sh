#!/usr/bin/env bash

set -e -o pipefail

readonly rootDir="$(cd "$(dirname "$0")/.." && pwd)"


function usage() {
  echo $1; echo
  echo "Usage: $(basename $0) [--log-at=LEVEL] [--api|--yaml] [path-to-src-file-or-folder]";
  echo
  exit 1;
}

if [[ $1 == '-h' || $1 == '--help' ]]; then usage; fi

[[ -z "$DART_SITE_ENV_DEFS" ]] && . $rootDir/scripts/env-set.sh

if [[ $1 == --log-at* ]]; then LOG_AT="$1"; shift; fi

ARGS='--no-escape-ng-interpolation '

if [[ $1 == '--api' ]]; then
  API='/_api'; shift
else
  ARGS='--escape-ng-interpolation '
fi

FRAG="$rootDir/tmp/_fragments$API"

if [[ $1 == '--yaml' ]]; then
  ARGS+='--yaml '; shift
  [[ -z $API ]] || usage "ERROR: the legacy --api flag cannot be used with --yaml"
  rm -Rf "$FRAG"
  pub run build_runner build --delete-conflicting-outputs --config doc --output="$FRAG"
  echo
else
  gulp create-example-fragments $LOG_AT
fi

SRC="$1"
: ${SRC:="$rootDir/src"}

ARGS+='--indentation 2 '
ARGS+='--replace='
ARGS+='/\/\/!<br>//g;' # Use //!<br> to force a line break (against dartfmt)
ARGS+='/ellipsis;?/.../g;' # ellipses; --> ...
ARGS+='/\/\*(\s*\.\.\.\s*)\*\//$1/g;' # /*...*/ --> ...
ARGS+='/\{\/\*-(\s*\.\.\.\s*)-\*\/\}/$1/g;' # {/*-...-*/} --> ... (removed brackets too)

[[ -e $SRC ]] || usage "ERROR: source file/folder does not exist: '$SRC'"
[[ -e $FRAG ]] || usage "ERROR: fragments folder does not exist: '$FRAG'"

echo "Source:     $SRC"
echo "Fragments:  $FRAG"
echo "Other args: $ARGS"
echo
LOG_FILE=$TMP/refresh-code-excerpts-log.txt
pub global run code_excerpt_updater \
  --fragment-dir-path "$FRAG" \
  $ARGS \
  --write-in-place \
  "$SRC" 2>&1 | tee $LOG_FILE
LOG=$(cat $LOG_FILE)

[[ $LOG == *" 0 out of"* && $LOG != *Error* ]]
