# The webdev site

[![Build Status](https://travis-ci.org/dart-lang/site-webdev.svg?branch=master)](https://travis-ci.org/dart-lang/site-webdev)
[![Join the chat at https://gitter.im/dart-lang/site-webdev](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/dart-lang/site-webdev?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

This repo implements the [webdev.dartlang.org](http://webdev.dartlang.org) website. It uses the tools and infrastructure of
www.dartlang.org (which is implemented in [github.com/dart-lang/site-www](https://github.com/dart-lang/site-www)), plus
some tools from the angular.io site ([github.com/angular/angular.io](https://github.com/angular/angular.io).

This site requires npm version 6. Getting started is something like this:

1. Have `angular.io` (angular/angular.io repo) and `angular-dart` (dart-lang/angular2 repo) directories (or links to them) next to the `site-webdev` directory.
1. `nvm use 6`
1. `bundle install`
1. `npm install -g firebase-tools`
1. `npm install`

Once everything's installed, you can build and serve:

1. `gulp build`
1. `./scripts/serve_local.sh`

See the [dart-lang/site-www README](https://github.com/dart-lang/site-www/blob/master/README.md) for more setup and build instructions.
