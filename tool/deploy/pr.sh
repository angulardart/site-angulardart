#!/usr/bin/env bash

set -e -o pipefail

if [[ -z $TRAVIS_JOB_ID ]]; then
  echo "Not on Travis. Skipping PR auto-deploy."
elif [[ -z $FIREBASE_TOKEN ]]; then
  echo "No FIREBASE_TOKEN. Skipping PR auto-deploy."
elif [[ $TRAVIS_REPO_SLUG == dart-lang* && \
      $TASK == *build* && \
      $TRAVIS_PULL_REQUEST != false ]];
then
  AUTO_STAGING_FB_PROJ_ID="$(($TRAVIS_JOB_ID % 2))"
  ./tool/shared/deploy.sh auto-staging-$AUTO_STAGING_FB_PROJ_ID
elif [[ $TRAVIS_PULL_REQUEST == false ]]; then
  echo "Travis event type: $TRAVIS_EVENT_TYPE"
  echo "Not a PR. Skipping PR auto-deploy."
fi
