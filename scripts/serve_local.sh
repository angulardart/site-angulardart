#!/usr/bin/env bash

set -e -o pipefail

cd `dirname $0`/..

bundle exec jekyll build --incremental --watch &
j_pid=$!
firebase serve --port 4001 &
f_pid=$!
echo "cached PIDs: $j_pid, $f_pid"
trap "{ kill $j_pid; kill $f_pid; exit 0;}" SIGINT
wait
