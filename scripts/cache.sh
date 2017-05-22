#!/usr/bin/env bash

set -e -o pipefail

[[ -z "$NGIO_ENV_DEFS" ]] && . ./scripts/env-set.sh > /dev/null

cd `dirname $0`/..

# BASE="$NGIO_REPO/public/docs/ts"
BASE="src/angular"
TS_BASE="$BASE/_jade/ts"
LATEST="$TS_BASE/latest"
CACHE="$TS_BASE/_cache"

# FILES is a list of files we try to keep in sync (TS _cache vs latest).
# For a list of files that are excluded, see the diff -x arguments in cacheDiffSummary().
# Files after toh-pt6.jade in the list below are still monitored, but no longer Jade extended.
FILES="
guide/architecture.jade
guide/attribute-directives.jade
guide/dependency-injection.jade
guide/displaying-data.jade
guide/hierarchical-dependency-injection.jade
guide/index.jade
guide/learning-angular.jade
guide/lifecycle-hooks.jade
guide/security.jade
guide/server-communication.jade
tutorial/index.jade
tutorial/toh-pt1.jade
tutorial/toh-pt2.jade
tutorial/toh-pt3.jade
tutorial/toh-pt4.jade
tutorial/toh-pt5.jade
tutorial/toh-pt6.jade
glossary.jade
guide/component-styles.jade
guide/pipes.jade
guide/structural-directives.jade
guide/template-syntax.jade"
# Files we no longer sync:
#   quickstart.jade
#   _quickstart_repo.jade

# Create patch for ts/latest relative to ts/_cache or main Dart doc soure
function cacheCreatePatchFiles() {
    local FILE_PATTERN=""
    if [[ -n "$1" ]]; then
        FILE_PATTERN="$1"
    fi

    local allFound=true;

    for f in $FILES; do
        local tsPath="$LATEST/$f";
        local dartPath="$CACHE/$f";
        if ! grep -e '^extends /_jade/ts' "$BASE/$f" | wc -l > /dev/null; then
          dartPath="$BASE/$f";
          if [[ "$f" == "guide/learning-angular.jade" ]]; then
            dartPath=${dartPath/%.jade/.md}
          fi
        fi
        local destPath="$TS_BASE/patch/$f.patch";
        local destDir=`dirname $destPath`;
        if [[ -e $tsPath ]]; then
            [[ -d "$destDir" ]] || (set -x; mkdir -p $destDir);
            case "$f" in
                (*$FILE_PATTERN*)
                    (set -x; git diff --no-index "./$tsPath" "./$dartPath" > "$destPath" || true);
                    (if [[ ! -s "$destPath" ]]; then rm -f "$destPath"; fi);;
                (*)
                    echo "SKIPPED $f";;
            esac
        else
            echo Cannot find $tsPath
            allFound=false;
        fi
    done

    [[ $allFound ]] || exit 1;
}

# Apply a patch:
#   patch -p0 file-to-be-patched.jade path-to-patch-file

function cacheRefresh() {
    local FILE_PATTERN="*"
    if [[ -n "$1" ]]; then
        FILE_PATTERN="$1"
    else
        echo "Argument missing: specify shell file glob pattern of files to be refreshed."
        exit 1;
    fi

    local allFound=true;
    
    for f in $FILES; do
        local srcPath="$LATEST/$f";
        local destPath="$CACHE/$f";
        local destDir=`dirname $destPath`;
        if [[ -e $srcPath ]]; then
            [[ -d "$destDir" ]] || (set -x; mkdir $destDir);
            case "$f" in
                (*$FILE_PATTERN*)
                    (set -x; cp $srcPath $destPath);;
                (*)
                    echo "SKIPPED $f";;
            esac
        else
            echo Cannot find $srcPath
            allFound=false;
        fi
    done

    [[ $allFound ]] || exit 1;
}

function cacheDiffSummary() {
    # We skip files (via -x) that have diverged too much and are no longer being synced.
    diff -qr \
        -x "_util*.jade" \
        -x "setup.jade" \
        "$CACHE/" "$LATEST/" | \
        grep -v "^Only in"
}

function cacheDiff() {
    local FILES="*$1*"
    cd $CACHE;
    # List files
    find . -name "$FILES" ! -name "*~" -exec diff -q {} ../latest/{} \;
    # Show differences
    find . -name "$FILES" ! -name "*~" -exec diff    {} ../latest/{} \;
}

function usage() {
    echo "Usage: cache.sh [options]"
    echo "  (-ds|--diff-summary)  list names of cache files that differ from ts/latest"
    echo "  (-d|--diff) pat       diff cache and latest subdirectories"
    echo "  (-l|--list)           list files subject to caching"
    echo "  (-r|--refresh) pat    refresh files in cache matching pattern"
    echo "  (-q|--mk-patch) [pat] create patch file(s) for files matching pattern"
}

case "$1" in
    (-ds|--diff-summary)  shift; cacheDiffSummary $@;;
    (-d|--diff)           shift; cacheDiff $@;;
    (-l|--list)           shift; printf "$FILES\n\n";;
    (-r|--refresh)        shift; cacheRefresh $@;;
    (-q|--mk-patch)       shift; cacheCreatePatchFiles $@;;
    (*)   usage;
esac
