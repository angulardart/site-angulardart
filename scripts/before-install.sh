#!/usr/bin/env bash

set -e -o pipefail

[[ -z "$NGIO_ENV_DEFS" ]] && . ./scripts/env-set.sh

if [[ -n "$TRAVIS" ]]; then
  ./scripts/env-info-and-check.sh
  # travis_fold start before_install.update_apt_get
  #   (set -x; sudo apt-get update --yes)
  # travis_fold end before_install.update_apt_get
fi

travis_fold start before_install.npm_install_shared
  (set -x; npm install --global gulp-cli --no-optional)
travis_fold end before_install.npm_install_shared

./scripts/install-dart-sdk.sh

if [[ -z "$CI_TASK" || "$CI_TASK" == build* ]]; then
  # Jekyll needs Ruby and the Ruby bundler
  travis_fold start before_install.ruby_bundler
    (set -x; gem install bundler)
  travis_fold end before_install.ruby_bundler

  travis_fold start before_install.npm_install_shared
    (set -x; npm install --global diff2html-cli firebase-tools superstatic --no-optional)
  travis_fold end before_install.npm_install_shared
  
  travis_fold start before_install.ceu
    (set -x; pub global activate --source git https://github.com/chalin/code_excerpt_updater.git)
  travis_fold end before_install.ceu

  travis_fold start before_install.linkcheck
    (set -x; pub global activate linkcheck)
  travis_fold end before_install.linkcheck

  travis_fold start before_install.stagehand
    (set -x; pub global activate stagehand)
  travis_fold end before_install.stagehand

  travis_fold start before_install.dartdoc
    (set -x; pub global activate dartdoc)
  travis_fold end before_install.dartdoc

  ./scripts/get-ng-repo.sh
fi

# Setup required for use of content_shell:
if [[ $CI_TASK == e2e* || $CI_TASK == test* ]]; then
  travis_fold start before_install.content_shell_prereq
    set -x
    sudo sh -c "echo ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true | debconf-set-selections"
    sudo apt-get install --yes ttf-indic-fonts ttf-mscorefonts-installer ttf-dejavu-core ttf-kochi-gothic ttf-kochi-mincho fonts-tlwg-garuda
    # ttf-thai-tlwg # Package 'ttf-thai-tlwg' has no installation candidate
    if [[ ! -e /usr/share/fonts/truetype/msttcorefonts/Arial.ttf ]]; then
      # Adapted from https://stackoverflow.com/a/37887105/3046255; original idea by @zoechi:
      # https://github.com/dart-lang/test/issues/415#issuecomment-202776591
      sudo mkdir -p /usr/share/fonts/truetype/msttcorefonts/
      pushd /usr/share/fonts/truetype/msttcorefonts/
      sudo ln -s ../dejavu/DejaVuSans-Bold.ttf Arial.ttf
      sudo ln -s ../dejavu/DejaVuSans-Bold.ttf Arial_Bold.ttf
      sudo ln -s ../dejavu/DejaVuSans-Bold.ttf Arial_Bold_Italic.ttf
      sudo ln -s ../dejavu/DejaVuSans-Bold.ttf Arial_Italic.ttf
      sudo ln -s ../dejavu/DejaVuSans-Bold.ttf Comic_Sans_MS.ttf
      sudo ln -s ../dejavu/DejaVuSans-Bold.ttf Comic_Sans_MS_Bold.ttf
      sudo ln -s ../dejavu/DejaVuSans-Bold.ttf Courier_New.ttf
      sudo ln -s ../dejavu/DejaVuSans-Bold.ttf Courier_New_Bold.ttf
      sudo ln -s ../dejavu/DejaVuSans-Bold.ttf Courier_New_Bold_Italic.ttf
      sudo ln -s ../dejavu/DejaVuSans-Bold.ttf Courier_New_Italic.ttf
      sudo ln -s ../dejavu/DejaVuSans-Bold.ttf Georgia.ttf
      sudo ln -s ../dejavu/DejaVuSans-Bold.ttf Georgia_Bold.ttf
      sudo ln -s ../dejavu/DejaVuSans-Bold.ttf Georgia_Bold_Italic.ttf
      sudo ln -s ../dejavu/DejaVuSans-Bold.ttf Georgia_Italic.ttf
      sudo ln -s ../dejavu/DejaVuSans-Bold.ttf Impact.ttf
      sudo ln -s ../dejavu/DejaVuSans-Bold.ttf Trebuchet_MS.ttf
      sudo ln -s ../dejavu/DejaVuSans-Bold.ttf Trebuchet_MS_Bold.ttf
      sudo ln -s ../dejavu/DejaVuSans-Bold.ttf Trebuchet_MS_Bold_Italic.ttf
      sudo ln -s ../dejavu/DejaVuSans-Bold.ttf Trebuchet_MS_Italic.ttf
      sudo ln -s ../dejavu/DejaVuSans-Bold.ttf Times_New_Roman.ttf
      sudo ln -s ../dejavu/DejaVuSans-Bold.ttf Times_New_Roman_Bold.ttf
      sudo ln -s ../dejavu/DejaVuSans-Bold.ttf Times_New_Roman_Bold_Italic.ttf
      sudo ln -s ../dejavu/DejaVuSans-Bold.ttf Times_New_Roman_Italic.ttf
      sudo ln -s ../dejavu/DejaVuSans-Bold.ttf Verdana.ttf
      sudo ln -s ../dejavu/DejaVuSans-Bold.ttf Verdana_Bold.ttf
      sudo ln -s ../dejavu/DejaVuSans-Bold.ttf Verdana_Bold_Italic.ttf
      sudo ln -s ../dejavu/DejaVuSans-Bold.ttf Verdana_Italic.ttf
      popd
    fi
    set +x
  travis_fold end before_install.content_shell_prereq
fi
