#!/usr/bin/env bash

set -e -o pipefail

[[ -z "$NGIO_ENV_DEFS" ]] && . ./scripts/env-set.sh

# NG_RELEASE=$(node -p 'require("./src/_data/pkg-vers.json").angular.vers')

if [[ -e "$NG_REPO" ]]; then
  echo Angular repo is already present at: $NG_REPO
else
  travis_fold start get_repos_ng
  echo CLONING Angular from GitHub ...
  set -x
  git clone https://github.com/dart-lang/angular.git $NG_REPO
  # git -C $NG_REPO fetch origin refs/tags/$NG_RELEASE
  # git -C $NG_REPO checkout tags/$NG_RELEASE -b $NG_RELEASE
  set +x
  travis_fold end get_repos_ng
fi

echo PWD `pwd`
echo INSTALLED repos:
ls -ld ../a*
