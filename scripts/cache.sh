#!/usr/bin/env bash

set -e -o pipefail

[[ -z "$NGIO_ENV_DEFS" ]] && . ./scripts/env-set.sh > /dev/null

cd `dirname $0`/..

BASE="$NGIO_REPO/public/docs/ts"
LATEST="$BASE/latest"
CACHE="$BASE/_cache"

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
glossary.jade
quickstart.jade
_quickstart_repo.jade
tutorial/index.jade
tutorial/toh-pt5.jade
tutorial/toh-pt6.jade
guide/component-styles.jade
guide/pipes.jade
guide/structural-directives.jade
guide/template-syntax.jade"

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
}

case "$1" in
    (-ds|--diff-summary)  shift; cacheDiffSummary $@;;
    (-d|--diff)           shift; cacheDiff $@;;
    (-l|--list)           shift; printf "$FILES\n\n";;
    (-r|--refresh)        shift; cacheRefresh $@;;
    (*)   usage;
esac
