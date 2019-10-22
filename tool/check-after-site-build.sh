#!/usr/bin/env bash

set -e -o pipefail

source ./tool/shared/env-set-check.sh

if [[ -n $TRAVIS && $TASK != build* ]]; then
  echo "check-all: nothing to check since this isn't a build task."
  exit 0;
fi

if [[ $TRAVIS_EVENT_TYPE == cron ]]; then
  CHECK_LINK_ARGS=--external
fi

travis_fold start check_links
  (set -x; ./tool/shared/check-links.sh $CHECK_LINK_ARGS)
travis_fold end check_links

# Check output from Jekyll plugin
travis_fold start check_for_bad_filenames
if [[ -e code-excerpt-log.txt ]]; then
  (set -x; grep -i 'CODE EXCERPT not found' code-excerpt-log.txt && exit 1)
fi
travis_fold end check_for_bad_filenames

travis_fold start check_for_code_excerpt_misformatting_in_html
(set -x; ./tool/check-for-code-excerpt-misformatting.sh)
travis_fold end check_for_code_excerpt_misformatting_in_html

travis_fold start check_for_numbered_files_in_html
(set -x; ./tool/check-for-numbered-files-in-html.sh)
travis_fold end check_for_numbered_files_in_html
