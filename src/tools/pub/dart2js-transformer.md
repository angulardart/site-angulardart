---
layout: default
title: "Configuring the Built-in dart2js Transformer for Pub"
description: "How to configure the dart2js transformer in your pubspec file."
permalink: /tools/pub/dart2js-transformer
---

The [pub serve](/tools/pub/pub-serve), [pub build](/tools/pub/pub-build),
and [pub run]({{site.dartlang}}/tools/pub/cmd/pub-run.html)
commands use the [dart2js](/tools/dart2js) compiler
(unless you specify another compiler)
to convert your Dart files to JavaScript.

You can configure dart2js in the
[pubspec]({{site.dartlang}}/tools/pub/pubspec.html) for your package.
To do this, add `$dart2js` (note the leading dollar sign) under the
`transformers:` field.
If present, `$dart2js` is usually the last transformer.

For example, by default, `pub` minifies an app when in release mode
(`pub build` defaults to `release` mode), but not otherwise
(`pub serve` defaults to `debug` mode).
The following example ensures that pub minifies the app in all situations:

{% prettify yaml %}
transformers:
- ...list of transformers...
- $dart2js:
    minify: true
{% endprettify %}

Some apps, for example, Chrome Apps and apps that run as Chrome extensions,
must generate the CSP (content-security policy) version of JavaScript.
You can do this by passing the `--csp` flag to dart2js with a value of `true`.

You can specify the `csp` flag in the pubspec file, as follows:

{% prettify yaml %}
transformers:
- chrome
- $dart2js:
    csp: true
{% endprettify %}

## Options

The following options are available. For more information on how these options
work, see the [documentation](/tools/dart2js#options) for dart2js:

{% prettify yaml %}
transformers:
- $dart2js:
    analyzeAll: true
    checked: true
    csp: true
    environment: {name: value, ...}
    minify: true
    sourceMaps: true
    suppressHints: true
    suppressWarnings: true
    terse: true
    verbose: true
{% endprettify %}

For command-line options not covered in this list,
see [Special-case options](#special-case-options).

## Excluding an asset

You can also exclude a particular asset, or set of assets,
from being processed by a transformer.
You can also configure a transformer to run
only on a particular asset, or set of assets.
For more information, see
[How to exclude assets]({{site.dartlang}}/tools/pub/assets-and-transformers.html#exclude-assets) in
[Pub Assets and Transformers]({{site.dartlang}}/tools/pub/assets-and-transformers.html).

## Special-case options

`commandLineOptions: [...args...]`

To specify one or more dart2js options that have no corresponding pub option,
use `commandLineOptions`.

The following example illustrates how to specify `--enable-foo`
and `--enable-bar` configuration options:

{% prettify yaml %}
transformers:
- angular2:
    entry_points: web/main.dart
- dart_to_js_script_rewriter
[[highlight]]- $dart2js:[[/highlight]]
    [[highlight]]commandLineOptions: [--enable-foo, --enable-bar][[/highlight]]
{% endprettify %}
