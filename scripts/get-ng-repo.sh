#!/usr/bin/env bash

set -e -o pipefail

[[ -z "$NGIO_ENV_DEFS" ]] && . ./scripts/env-set.sh

if [[ -e "$NG2_REPO" ]]; then
  echo Angular repo is already present at: $NG2_REPO
else
  travis_fold start get_repos_ng2
  echo GETTING Angular from GitHub ...
  set -x
  git clone https://github.com/dart-lang/angular2.git $NG2_REPO
  git -C $NG2_REPO fetch origin refs/tags/$LATEST_RELEASE
  git -C $NG2_REPO checkout tags/$LATEST_RELEASE -b $LATEST_RELEASE
  set +x
  travis_fold end get_repos_ng2
fi

# Temporary until we eliminate use of NG2DART_REPO
if [[ -e "$NG2DART_REPO" ]]; then
  echo Angular repo alias is already present at: $NG2DART_REPO
else
  (set -x; ln -s ${NG2_REPO/..\//} $NG2DART_REPO)
fi

if [[ -e "$NG2EX_REPO" ]]; then
  echo angular2_api_examples repo is already present at: $NG2EX_REPO
else
  travis_fold start get_ng2_api_ex
  echo GETTING angular2_api_examples from GitHub ...
  (set -x; git clone https://github.com/dart-lang/angular2_api_examples.git $NG2EX_REPO)
  travis_fold end get_ng2_api_ex
fi

echo PWD `pwd`
echo INSTALLED repos:
ls -ld ../a*
