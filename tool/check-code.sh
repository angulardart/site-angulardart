#!/usr/bin/env bash

set -e -o pipefail

source ./tool/shared/env-set-check.sh

readonly rootDir="$(cd "$(dirname "$0")/.." && pwd)"

keys="analyze freshness format sdk"
if [[ $1 == -h ]]; then
  echo "Usage: selectively test any one of the following: $keys"
  exit 0
fi

ARGS=$(tr [:upper:] [:lower:] <<< "$*")
: ${ARGS:=$keys}

errorMessage="
Error: some code excerpts need to be refreshed. You'll need to
rerun '$rootDir/tool/refresh-code-excerpts.sh' locally, and re-commit.
"

if [[ $ARGS == *analyze* ]]; then
  # Run the analyzer over all examples except those that make use of the
  # pageloader package, since those example need to be built before they are
  # analyzed. Note that all examples are analyzed anyways, it is just convenient
  # to do it all upfront, and it doesn't (as of now) make the build run for any
  # longer.

  travis_fold start refresh_code_excerpts
    echo "Running Dart analyzer over examples"
    echo
    (set -x;
      # Skip analysis of examples tests using pageloader.
      npx gulp analyze --skip=doc/t
    )
  travis_fold end refresh_code_excerpts
fi

if [[ $ARGS == *freshness* ]]; then
  travis_fold start refresh_code_excerpts
    echo "Doc code excerpts: checking freshness"
    echo
    (
      set -x;
      $rootDir/tool/refresh-code-excerpts.sh
    ) || (
      printf "$errorMessage" && git diff &&
      exit 1
    )
  travis_fold end refresh_code_excerpts
fi

if [[ $ARGS == *format* ]]; then
  travis_fold start dartfmt
    (set -x; npx gulp dartfmt)
  travis_fold end dartfmt
fi

if [[ $ARGS == *sdk* ]]; then
  travis_fold start SDK_constraints
    echo "SDK constraints: checking that example constraints match angular's"
    echo
    EX_SDK_VERS=$(set -x; grep sdk: examples/ng/doc/quickstart/pubspec.yaml)
    echo $EX_SDK_VERS
    NG_SDK_VERS_RAW=$(set -x; grep sdk: site-angular/angular/pubspec.yaml)
    NG_SDK_VERS=${NG_SDK_VERS_RAW//\"/\'}
    echo $NG_SDK_VERS

    # Allow NG min SDK to be a dev release while our examples use stable;
    # e.g., in 2.5.0-dev.1.0 strip out the -dev.1.0.
    NG_SDK_VERS_STABLE=${NG_SDK_VERS//-dev.[0-9].[0-9]/}
    if [[ "$NG_SDK_VERS" != "$NG_SDK_VERS_STABLE" ]]; then
      echo "Extracting stable versions from the constraint:"
      NG_SDK_VERS="$NG_SDK_VERS_STABLE"
      echo $NG_SDK_VERS
    fi

    if [[ "$EX_SDK_VERS" != "$NG_SDK_VERS" ]]; then
      echo "Versions don't match. Update example pubspec SDK contraints to match Angular's.";
      exit 1;
    else
      echo "Versions match (ignoring possible -dev.x.y suffix).";
    fi
  travis_fold end SDK_constraints
fi
