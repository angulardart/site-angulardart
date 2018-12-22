---
title: Dart Tools for the Web
short-title: Tools
description: The tools that support web development using Dart.
show_breadcrumbs: false
---

This page lists specialized tools for developing web apps.
For information about general tools for Dart apps, see
[Dart Tools.]({{site.dartlang}}/tools)

## Recommended IDE {#ides}

If you don't already have a favorite IDE,
we recommend WebStorm, which comes with Dart support.

<a href="/tools/webstorm">
<img src="{% asset webstorm.svg @path %}" alt="WebStorm icon" width="48"><br>
<b>WebStorm</b>
</a>

See [Dart Tools]({{site.dartlang}}/tools#ides-and-editors)
for a list of other IDEs.

## SDK

Although [DartPad][]{: target="_blank"} is a great way to experiment with
Dart code, once you're ready to develop a web app, you need to
[install the Dart SDK.](/tools/sdk)

## Command-line tools

In addition to the [other Dart tools]({{site.dartlang}}/tools)
included in the SDK, the following tools
offer specialized support for web programming.

[webdev](/tools/webdev)
: A command line interface (CLI) for Dart web app development,
  including building and serving web apps.

[dart2js](/tools/dart2js)
: The original Dart-to-JavaScript compiler, with tree shaking.
  IDEs and the webdev CLI use dart2js when building web apps for deployment.

[dartdevc](/tools/dartdevc)
: The Dart dev compiler, a modular Dart-to-JavaScript compiler.
  IDEs and the webdev CLI use dartdevc when running a development server.

[build_runner](/tools/webdev)
: A build package that's used by the webdev CLI.
  You can use it directly for [testing](/tools/webdev#test)
  or if you need more configurability than webdev provides.

[DartPad]: {{site.custom.dartpad.direct-link}}
