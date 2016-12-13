#!/usr/bin/env bash

set -e -o pipefail

[[ -z "$NGIO_ENV_DEFS" ]] && . ./scripts/env-set.sh

travis_fold start ngio
echo Install $NGIO_REPO
cd $NGIO_REPO

travis_fold start ngio.install
npm install --no-optional
travis_fold end ngio.install

travis_fold end ngio
