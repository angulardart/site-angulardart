#!/usr/bin/env bash

set -e -o pipefail

[[ -z "$NGIO_ENV_DEFS" ]] && . ./scripts/env-set.sh

if [[ -z "$CEU_REPO" || ! -e $CEU_REPO ]]; then
  echo "ERROR: expect to find repo at $CEU_REPO. Ensure that you have it checked out."
  exit 1
fi

LOG=$(dart \
  $CEU_REPO/bin/code_excerpt_updater.dart \
    --fragment-dir-path tmp/_fragments \
    --indentation 2 \
    --write-in-place \
    src/angular)
echo $LOG

[[ $LOG == *" 0 out of"* ]]
