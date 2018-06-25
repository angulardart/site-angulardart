#!/usr/bin/env bash

set -e -o pipefail

[[ -z "$DART_SITE_ENV_DEFS" ]] && . ./scripts/env-set.sh

if [[ -n "$TRAVIS" ]]; then
  ./scripts/env-info-and-check.sh
  # travis_fold start before_install.update_apt_get
  #   (set -x; sudo apt-get update --yes)
  # travis_fold end before_install.update_apt_get
fi

travis_fold start before_install.npm_install_shared
  (set -x; npm install --global gulp-cli --no-optional)
travis_fold end before_install.npm_install_shared

travis_fold start before_install.webdev
  (set -x; pub global activate webdev)
travis_fold end before_install.webdev

./scripts/install-dart-sdk.sh

if [[ -z "$CI_TASK" || "$CI_TASK" == build* ]]; then
  # Jekyll needs Ruby and the Ruby bundler
  travis_fold start before_install.ruby_bundler
    (set -x; gem install bundler)
  travis_fold end before_install.ruby_bundler

  travis_fold start before_install.npm_install_shared
    (set -x; npm install --global diff2html-cli firebase-tools superstatic --no-optional)
  travis_fold end before_install.npm_install_shared

  travis_fold start before_install.dartdoc
    (set -x; pub global activate dartdoc)
  travis_fold end before_install.dartdoc

  ./scripts/get-ng-repo.sh
fi

travis_fold start before_install.pub_upgrade
pub upgrade
travis_fold end before_install.pub_upgrade
