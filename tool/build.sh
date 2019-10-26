#!/usr/bin/env bash

set -e -o pipefail

source ./tool/shared/env-set-check.sh

function _usage() {
  echo "Usage: $(basename $0) [--help] [--check|--check-links[-external-on-cron] ...check-link-options]";
  echo ""
  echo "  --check        Run all post-build checks, including link checks, but not external-on-cron."
  echo "  --check-links  Perform link checking after the build. Can be followed by check-link options."
  echo "  --check-links-external-on-cron"
  echo "                 Perform link checking, including external links, after the build when part of a CRON build."
}

while [[ "$1" == -* ]]; do
  case "$1" in
    --check)
      CHECKS=1; shift;;
    --check-links|--check-links-external-on-cron)
      if [[ "$1" == *external* && "$TRAVIS_EVENT_TYPE" == cron ]]; then
        EXTRA_CHECK_LINK_ARGS=--external
      fi;
      CHECK_LINKS=1; shift;
      # Use remaining arguments for call to check-links
      break;;
    -h|--help)
      _usage;
      exit 0;;
    *)
      echo "ERROR: Unrecognized option: $1. Use --help for details.";
      exit 1;;
  esac
done

travis_fold start ci_info
  ./tool/shared/write-ci-info.sh -v
travis_fold end ci_info

travis_fold start build_site
  (
    set -x;
    npx gulp build --clean --shallow-clone-example-apps;
    ls -l publish/examples
  )
travis_fold end build_site

if [[ -n "$CHECKS" || -n "$CHECK_LINKS" ]]; then
  travis_fold start build_site_checks
    (set -x; ./tool/check-after-site-build.sh)
  travis_fold end build_site_checks
fi

if [[ -n "$CHECKS" || -n "$CHECK_LINKS" ]]; then
  travis_fold start check_links
    (
      set -x;
      ./tool/shared/check-links.sh $EXTRA_CHECK_LINK_ARGS $*;
    )
  travis_fold end check_links
fi
