---
title: Dart 2 Migration Guide
description: Tips for migrating your web app from Dart 1.x to Dart 2.
---

The development environment for web apps is different in Dart 2 from Dart 1.x.
Dart 2 drops `pub serve` and `pub build`, replacing them with a new build system.
Dart 2 no longer supports the Dartium browser;
instead, you use Chrome and an incremental Dart-to-JavaScript compiler
called [dartdevc.][dartdevc]

To migrate to Dart 2, you'll need to edit your web app's
`pubspec.yaml` and `web/index.html` files.
You'll almost certainly need to edit your Dart code, as well,
due to changes in the Dart language and libraries.

**This page is under construction.**
Soon this page will guide you through migrating from Dart 1.x to Dart 2.
In the meantime, see these resources:

* [Dart 2 Updates:][dart-2]
  Information about changes in Dart 2, and how to migrate your code from Dart 1.x.
* [dartdevc: The Dart Dev Compiler][dartdevc]:
  Describes how to prepare your code for dartdevc, build with dartdevc, and
  test with dartdevc.
* [Getting started with build_runner:][Getting started with build_runner]
  Describes how to use the new build system. For example, it shows how to use
  `build_runner` (instead of `pub serve`) as a development server.
* [Changelog for the dev version of this site:][Documentation changelog]
  Lists changes made to this site's documentation and examples.

[dart-2]: {{site.dartlang}}/dart-2
[dartdevc]: /tools/dartdevc
[Documentation changelog]: {{site.dev-url}}/changelog
[Getting started with build_runner]: https://github.com/dart-lang/build/blob/master/docs/getting_started.md#getting-started-with-build_runner