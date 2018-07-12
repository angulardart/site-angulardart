#!/usr/bin/env bash

set -e -o pipefail

[[ -z "$DART_SITE_ENV_DEFS" ]] && . ./scripts/env-set.sh

errorMessage="
Error: some code excerpts need to be refreshed.
Rerun './scripts/refresh-code-excerpts.sh' locally.
"

travis_fold start refresh_code_excerpts
(set -x; ./scripts/refresh-code-excerpts.sh) || (printf "$errorMessage" && exit 1)
travis_fold end refresh_code_excerpts

travis_fold start note_refresh
(set -x; gulp note-refresh; gulp git-status-exit-on-change --filter=/angular/note/)
travis_fold end note_refresh

travis_fold start dartfmt
(set -x; gulp dartfmt)
travis_fold end dartfmt
