# The webdev site

[![Build Status](https://travis-ci.org/dart-lang/site-webdev.svg?branch=master)](https://travis-ci.org/dart-lang/site-webdev)

This repo implements the [webdev.dartlang.org](http://webdev.dartlang.org) website. It uses the tools and infrastructure of
www.dartlang.org (which is implemented in [github.com/dart-lang/site-www](https://github.com/dart-lang/site-www)).

**Prerequisites** for building this site (assuming that you already have a local copy of the repo):

- [Dart](https://www.dartlang.org/install), aim for the latest version.
- Node v6; instructions below assume use of [nvm](https://github.com/creationix/nvm).
  (HomeBrew users shall set the `NVM_DIR` env as instructed after `brew install nvm`.)
- The ruby gem `bundler`. (HomeBrew users can get it with: `brew install ruby` and `gem install bundler`)

**Installation** instructions:

1. `nvm install 6` (on clean install) and/or `nvm use 6`
1. `source ./scripts/env-set.sh`
1. `./scripts/before-install.sh`
1. `./scripts/get-ng-repo.sh` (optional).<br>
   This step ensures that a local `dart-lang/angular2` repo is present as a sibling to this repo;
   and that `angular-dart` is an alias to `angular2`.
1. `./scripts/install.sh`

Once everything's installed, you can build and serve:

- `gulp build` # use --fast to avoid running dartdoc when API docs already exist
- `firebase serve --port 4001`

Or, to build, serve, and have a watcher for changes:

- `./scripts/serve_local.sh`

Or, to make sure everything's created from scratch:

```
source ./scripts/env-set.sh    # avoids errors if your environment's not quite right
nvm use 6                      # makes sure you're using the right version of node
gulp clean && gulp build --clean; ./scripts/serve_local.sh
```

Various useful gulp tasks:

- `gulp clean` # deletes `publish`
- `gulp clean && gulp build --clean` # really cleans up
- `gulp build --dgeni-log=info` # trace at `info` level (`warn` is default)
- `gulp build-deploy` # build and deploy to active firebase project

See the [dart-lang/site-www README](https://github.com/dart-lang/site-www/blob/master/README.md) for more setup and build instructions.
