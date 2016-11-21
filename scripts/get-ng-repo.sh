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
  # Temporary until we eliminate use of NG2DART_REPO
  ln -s ${NG2_REPO/..\//} $NG2DART_REPO
  set +x
  travis_fold end get_repos_ng2
fi

if [[ -e "$NGIO_REPO" ]]; then
  echo Angular.io repo is already present at: $NGIO_REPO
elif [[ -n "$TRAVIS" ]]; then
  travis_fold start get_repos_ng_io
  echo GETTING Angular.io from GitHub ...
  (set -x; git clone https://github.com/angular/angular.io.git $NGIO_REPO)
  echo Apply active PRs, if any
  for i in `grep -Ev '\#|^\s*$' ./scripts/config/ngio-active-prs.txt`; do
    echo FETCHING PR $i;
    cd $NGIO_REPO
    (set -x; git fetch origin pull/$i/head:$i);
    (set -x; git merge $i)
    cd `dirname $0`/..
  done
  travis_fold end get_repos_ng_io
fi

echo PWD `pwd`
echo INSTALLED repos:
ls -ld ../a*
