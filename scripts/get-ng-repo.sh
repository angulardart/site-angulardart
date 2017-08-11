#!/usr/bin/env bash

set -e -o pipefail

[[ -z "$NGIO_ENV_DEFS" ]] && . ./scripts/env-set.sh

NG_RELEASE=$(node -p 'require("./src/_data/ng-pkg-vers.json").angular.vers')
ACX_RELEASE=v$(node -p 'require("./src/_data/ng-pkg-vers.json").angular_components.vers')

if [[ -e "$NG2_REPO" ]]; then
  echo Angular repo is already present at: $NG2_REPO
else
  travis_fold start get_repos_ng
  echo GETTING Angular $NG_RELEASE from GitHub ...
  set -x
  git clone https://github.com/dart-lang/angular2.git $NG2_REPO
  git -C $NG2_REPO fetch origin refs/tags/$NG_RELEASE
  git -C $NG2_REPO checkout tags/$NG_RELEASE -b $NG_RELEASE
  set +x
  travis_fold end get_repos_ng
fi

if [[ -e "$ACX_REPO" ]]; then
  echo Angular components repo is already present at: $ACX_REPO
else
  travis_fold start get_repos_acx
  echo GETTING Angular components $ACX_RELEASE repo from GitHub ...
  set -x
  git clone https://github.com/dart-lang/angular_components.git $ACX_REPO
  git -C $ACX_REPO fetch origin refs/tags/$ACX_RELEASE
  git -C $ACX_REPO checkout tags/$ACX_RELEASE -b $ACX_RELEASE
  set +x
  travis_fold end get_repos_acx
fi

if [[ -e "$CEU_REPO" ]]; then
  echo $CEU_REPO repo is already present.
else
  travis_fold start get_repos_ceu
  echo GETTING repo from GitHub ...
  set -x
  git clone https://github.com/chalin/code_excerpt_updater.git $CEU_REPO
  (cd $CEU_REPO; pub get)
  set +x
  travis_fold end get_repos_ceu
fi

echo PWD `pwd`
echo INSTALLED repos:
ls -ld ../a*
