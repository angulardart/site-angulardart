#!/usr/bin/env bash

source ./tool/shared/install.sh

# Site specific setup:

if [[ -z "$TRAVIS" || "$TASK" == *e2e* ]]; then
  ./tool/examples-install.sh
fi
