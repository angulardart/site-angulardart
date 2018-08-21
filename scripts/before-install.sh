#!/usr/bin/env bash

set -e -o pipefail

[[ -z "$DART_SITE_ENV_DEFS" ]] && . ./scripts/env-set.sh


if [[ "$1" == --force ]]; then FORCE=1; shift; fi

if [[ -n "$TRAVIS" || -n "$FORCE" || "$1" == --up* ]]; then
  PUB_CMD="upgrade"
  if [[ -n "$1" ]]; then shift; fi
else
  PUB_CMD="get"
fi

if [[ -n "$TRAVIS" ]]; then
  ./scripts/env-info-and-check.sh
  # travis_fold start before_install.update_apt_get
  #   (set -x; sudo apt-get update --yes)
  # travis_fold end before_install.update_apt_get
fi

function pub_global_activate() {
  PKG="$1"
  if [[ -n "$TRAVIS" || -n "$FORCE" || ! $(pub global run $PKG -h) ]]; then
    echo "INFO: activating $PKG"
    (set -x; pub global activate $PKG)
  else
    echo "INFO: pub global activate $PKG, already activated"
    echo "INFO: package already activated: $PKG (pub global activate $PKG)"
  fi
}

function npm_global_install() {
  PKG="$1"
  CMD=${PKG/@*/}
  CMD=${CMD/-cli/}
  CMD=${CMD/-tools/}
  if [[ -n "$TRAVIS" || -n "$FORCE" || -z "$(type -t $CMD)" ]]; then
    echo "INFO: installing $PKG ($CMD)"
    (set -x; npm install --global $PKG --no-optional)
  else
    echo "INFO: package already installed: $PKG ($CMD)"
  fi
}

travis_fold start before_install.npm_install_shared
  npm_global_install gulp-cli
travis_fold end before_install.npm_install_shared

travis_fold start before_install.webdev
  pub_global_activate webdev
travis_fold end before_install.webdev

./scripts/install-dart-sdk.sh

if [[ -z "$CI_TASK" || "$CI_TASK" == build* ]]; then
  # Jekyll needs Ruby and the Ruby bundler
  PKG="bundler"
  travis_fold start before_install.ruby_bundler
    if [[ -n "$TRAVIS" || -n "$FORCE" || -z "$(type -t $PKG)" ]]; then
      (set -x; gem install $PKG)
    else
      echo "INFO: package already installed: $PKG"
    fi
  travis_fold end before_install.ruby_bundler

  travis_fold start before_install.npm_install_shared
      npm_global_install diff2html-cli
      npm_global_install firebase-tools@4.0.3
      npm_global_install superstatic@5.0.2
  travis_fold end before_install.npm_install_shared

  travis_fold start before_install.dartdoc
    pub_global_activate dartdoc
  travis_fold end before_install.dartdoc

  ./scripts/get-ng-repo.sh
fi

travis_fold start before_install.pub
  echo "pub $PUB_CMD"
  pub $PUB_CMD
travis_fold end before_install.pub
