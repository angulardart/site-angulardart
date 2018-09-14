#!/usr/bin/env bash

source ./tool/shared/before-install.sh

# site-webdev specific setup:

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

travis_fold start before_install.webdev
  pub_global_activate webdev
travis_fold end before_install.webdev

if [[ -z "$TASK" || "$TASK" == build* ]]; then
  travis_fold start before_install.dartdoc
    pub_global_activate dartdoc
  travis_fold end before_install.dartdoc

  # TODO(chalin): drop the following script and use site-angular submodule.
  #   Note that changes will be necessary in env-set.sh too.
  ./tool/get-ng-repo.sh
fi
