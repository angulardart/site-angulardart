#!/usr/bin/env bash

jekyll build --watch &
j_pid=$!
firebase serve --port 4001 &
f_pid=$!
echo "catched PIDs: $j_pid, $f_pid"
trap "{ kill $j_pid; kill $f_pid; exit 0;}" SIGINT
wait
