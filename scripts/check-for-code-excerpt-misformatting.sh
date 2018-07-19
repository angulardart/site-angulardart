#!/usr/bin/env bash

# `find` exit code reflects whether it encountered errors during the search.
# We ignore such errors, so don't exit on a pipefail.
# set -e -o pipefail

LOGFILE=$TMP/log-for-code-excerpt-misformatting.txt

# Don't check API pages because they contain examples with templates
# containing </pre> closing tags.

find publish -type f -name "*.html" ! -path "publish/api/**" \
  -exec grep '&lt;/pre&gt;' {} + > $LOGFILE

if [[ -s $LOGFILE ]]; then
  echo "ERROR: Some code excerpts are misformatted in HTML files. This is usually due to"
  echo "a bug in code excerpt processing components (like the Jekyll prettify.rb plugin):"
  echo
  cat $LOGFILE | sort
  exit 1
fi

exit 0
