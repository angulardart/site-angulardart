#!/usr/bin/env bash

set -e -o pipefail

if [[ -z $TRAVIS ]]; then
  exit 0;
fi

AUTO_STAGING_FB_PROJ_ID="$(($TRAVIS_JOB_ID % 2))"

if [[ $TRAVIS_REPO_SLUG == dart-lang* && \
      $CI_TASK == build* && \
      $TRAVIS_PULL_REQUEST != false ]];
then
  ./scripts/deploy/firebase.sh auto-staging-$AUTO_STAGING_FB_PROJ_ID
elif [[ $TRAVIS_PULL_REQUEST == false ]]; then
  echo "Travis event type: $TRAVIS_EVENT_TYPE"
  echo "Not a PR. Skipping PR auto-deploy."
fi
