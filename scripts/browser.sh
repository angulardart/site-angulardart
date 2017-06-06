#!/usr/bin/env bash

set -e -o pipefail

[[ -z "$NGIO_ENV_DEFS" ]] && . ./scripts/env-set.sh > /dev/null

if [[ $CI_TASK == build* ]]; then
  echo "We don't launch the content_shell for CI_TASK == $CI_TASK"
else
  set -x
  sh -e /etc/init.d/xvfb start
  t=0; until (xdpyinfo -display :99 &> /dev/null || test $t -gt 10); do sleep 1; let t=$t+1; done
  content_shell --run-layout-test --disable-gpu-early-init --disable-gpu
  set +x
fi
