# This bash file is meant to be source'd, not executed.

# On Travis we sometimes need to update rvm so that we can get a recent ruby:
rvm get stable
rvm install 2.3
rvm use 2.3
