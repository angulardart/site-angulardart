#!/usr/bin/env bash

set -e -o pipefail

readonly rootDir="$(cd "$(dirname "$0")/.." && pwd)"

function usage() {
  echo $1; echo
  echo "Usage: $(basename $0) [--help] [--log-at=LEVEL] [[--api] --legacy] [path-to-src-file-or-folder]";
  echo
  exit 1;
}

if [[ $1 == '-h' || $1 == '--help' ]]; then usage; fi

[[ -z "$DART_SITE_ENV_DEFS" ]] && . $rootDir/scripts/env-set.sh

if [[ $1 == --log-at* ]]; then LOG_AT="$1"; shift; fi

ARGS=''
FRAG="$rootDir/tmp/_fragments"

if [[ -e "$FRAG" ]]; then echo Deleting old "$FRAG"; rm -Rf "$FRAG"; fi

if [[ $1 == '--api' ]]; then
  API='/_api'; shift
  FRAG+=$API
  ARGS+='--no-escape-ng-interpolation '
else
  ARGS+='--escape-ng-interpolation '
fi

if [[ $1 == '--legacy' ]]; then
  shift
  gulp create-example-fragments $LOG_AT
else
  ARGS+='--yaml '
  [[ -z $API ]] || usage "ERROR: the legacy --api flag can only be used with --legacy"
  if [[ ! -e "pubspec.lock" ]]; then pub get; fi
  pub run build_runner build --delete-conflicting-outputs --config excerpt --output="$FRAG"
  echo
fi

[[ -e "$FRAG" ]] || usage "ERROR: fragments folder was not generated: '$FRAG'"

SRC="$1"
: ${SRC:="$rootDir/src"}
[[ -e $SRC ]] || usage "ERROR: source file/folder does not exist: '$SRC'"

ARGS+='--indentation 2 '
ARGS+='--replace='
# The replace expressions that follow must not contain (unencode/unescaped) spaces:
ARGS+='/\s*\/\/!<br>//g;' # Use //!<br> to force a line break (against dartfmt)
ARGS+='/ellipsis(<\w+>)?(\(\))?;?/.../g;' # ellipses; --> ...
ARGS+='/\/\*(\s*\.\.\.\s*)\*\//$1/g;' # /*...*/ --> ...
ARGS+='/\{\/\*-(\s*\.\.\.\s*)-\*\/\}/$1/g;' # {/*-...-*/} --> ... (removed brackets too)

echo "Source:     $SRC"
echo "Fragments:  $FRAG"
echo "Other args: $ARGS"
echo
LOG_FILE=$TMP/refresh-code-excerpts-log.txt
pub run code_excerpt_updater \
  --fragment-dir-path "$FRAG" \
  $ARGS \
  --write-in-place \
  "$SRC" 2>&1 | tee $LOG_FILE
LOG=$(cat $LOG_FILE)

[[ $LOG == *" 0 out of"* && $LOG != *Error* ]]
