---
layout: default
title: "Pub for the Web"
description: "Pub supports two commands specifically for web development."
permalink: /tools/pub/
---

You can use the [pub]({{site.dartlang}}/tools/pub/)
tool to manage Dart packages and assets. For more information, see
[Assets and Transformers]({{site.dartlang}}/tools/pub/assets-and-transformers).
Pub also has specialized commands to support web development.
The `pub serve` command starts up a dev server.
The `pub build` command builds a deployable version of your app,
running any required transformers.

To learn more, see the following reference pages:

* [pub build](pub-build)
* [pub serve](pub-serve)

## Writing transformers

When `pub` serves or builds an app, it can run one or more
transformers&mdash;for example, one transformer converts Dart
files into a single JavaScript file.

Transformers operate on assets, where an asset is
a resource, such as a Dart file, a CSS file, or an
image, that is intended to be part of a deployed package.

Learn about transformers on [dartlang]({{site.dartlang}}/tools).
