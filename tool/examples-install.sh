#!/usr/bin/env bash

set -e -o pipefail

source ./tool/shared/env-set-check.sh

NGDOCEX=examples/ng/doc

travis_fold start install.e2e
(
  set -x
  (cd $NGDOCEX && npm install --no-optional)
  npm run webdriver:update --prefix $NGDOCEX
  npx gulp add-example-boilerplate
)
travis_fold end install.e2e
