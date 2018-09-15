#!/usr/bin/env bash

set -e -o pipefail

ROBOTS_FILE=publish/robots.txt

NO_ROBOTS_FILE=src/_no-robots.txt
SRC_ROBOTS_FILE=src/robots.txt

if [[ "$1" == '--robots-ok' ]]; then
  shift
  # Jekyll would normally have created the robots file, but in case it
  # has been erased (say, by a previous invocation of this script):
  if [[ ! -e $ROBOTS_FILE ]]; then
    (set -x; cp $SRC_ROBOTS_FILE $ROBOTS_FILE)
  fi
else
  (set -x; cp $NO_ROBOTS_FILE $ROBOTS_FILE)
  # Note that if $NO_ROBOTS_FILE were named 'robots.txt' then, by default,
  # Jekyll would generate a site that could not be crawled, including by
  # our linkchecker. To avoid that, we only copy over the "no robots" file
  # _after_ our linkchecker has run (which is assumed to be done _before_
  # this script is invoked), but before deploying.
fi

echo "Using robots file ($ROBOTS_FILE):"
cat $ROBOTS_FILE
echo

FB_PROJ=$1
: ${FB_PROJ:=default}

echo "================ Deploy to Firebase ($FB_PROJ) ========================"
npx firebase deploy --non-interactive --token "$FIREBASE_TOKEN" --project $FB_PROJ
