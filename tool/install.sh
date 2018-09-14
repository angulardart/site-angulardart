#!/usr/bin/env bash

source ./tool/shared/install.sh

# site-webdev specific setup:

if [[ "$TASK" == e2e* ]]; then
  ./tool/examples-install.sh
fi
