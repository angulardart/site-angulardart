#!/usr/bin/env bash

source ./tool/shared/install.sh

# Site specific setup:

if [[ "$TASK" == e2e* ]]; then
  ./tool/examples-install.sh
fi
