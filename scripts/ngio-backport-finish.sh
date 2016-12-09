#!/usr/bin/env bash

set -e -o pipefail

[[ -z "$NGIO_ENV_DEFS" ]] && . ./scripts/env-set.sh

# Clean out Jekyll frontmatter from jade files
find $NGIO_REPO/public/docs/dart/latest ! -path "*/api/angular*" -name "*.jade" \
  -print -exec \
  perl -i -e 'undef $/; $s = <>; $s =~ s/^[\s\S]*\/\/- FilePath: [^\s]+\n//; print $s' {} \;