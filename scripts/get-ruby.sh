# This bash file is meant to be source'd, not executed.

if ! rvm version | grep -q '(latest)'; then
  rvm get stable
fi
rvm install 2.4.2
rvm use 2.4.2
