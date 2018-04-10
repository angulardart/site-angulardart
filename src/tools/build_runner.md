---
layout: angular
title: Build_runner
description: A tool for building, serving, and testing web apps (and more).
permalink: /tools/build_runner
---
<?code-excerpt path-base="examples/ng/doc"?>

The [build_runner][] package provides a way to build, serve, and test web apps.
Use `build_runner` instead of the deprecated `pub build` and `pub serve` commands.

## Setting up build_runner

To use `build_runner`, add these dev dependencies to your app's pubspec:

<?code-excerpt "quickstart/pubspec.yaml (build dependencies)" title?>
```
  dev_dependencies:
    # ···
    build_runner: ^0.8.2
    build_test: ^0.10.0
    build_web_compilers: ^0.3.6
```

The `build_test` package is optional; add it if you'll be testing your app.

As usual after `pubspec.yaml` changes, run `pub get` or `pub upgrade`:

```terminal
$ pub get
```

<a id="build"></a>
## Command: build

Use the `build` command to build your web app:

```
pub run build_runner build [--config <name>] [--output <dirname>] ...
```

The first build is the slowest. After that, assets are cached on disk and
incremental builds are faster.

To continuously run builds as you edit, use the `watch` command.

By default, `build_runner` uses the [dartdevc][] web compiler.
To build a production version of your app, specify [dart2js][] on the command line:

```terminal
$ pub run build_runner build --define "build_web_compilers|entrypoint=compiler=dart2js"
```

Alternatively, you can use a [build config file](#config), as described below.
For more information, see [Switching to dart2js.][Switching to dart2js]

<a id="serve"></a>
## Command: serve

To run a development server, use the `serve` command:

```terminal
$ pub run build_runner serve
```

By default this serves the `web` and `test` directories, on ports `8080` and `8081` respectively.
{% comment %}
[I'm not sure how relevant it is to include this here.]
To serve different folders on specific ports, provide `<folder>:<port>` arguments to the
`serve` command, like this, for example:

```terminal
$ pub run build_runner serve example:8000 web:8001
```
{% endcomment %}

While the `serve` command runs, every change you save triggers a rebuild.

<a id="config"></a>
## Build config file

Rather than pass build options on the command line, you can save them to
a build config file. The default build config filename is `build.yaml`.

You can also create named config files like <code> build.<i>name</i>.yaml</code>.
For example, if you have a build config file named `build.release.yaml`, use it
&mdash; instead of `build.yaml` &mdash; like this:

```terminal
$ pub run build_runner build --config release
```

<a id="dart2js-build-config"></a>
Here's an example of what that file might contain:

<?code-excerpt "quickstart/build.release.yaml" title?>
```
  targets:
    $default:
      builders:
        build_web_compilers|entrypoint:
          generate_for:
            - web/main.dart
          options:
            compiler: dart2js
            dart2js_args:
              - --fast-startup
              - --minify
              - --trust-type-annotations
              # Consult https://webdev.dartlang.org/tools/dart2js#size-and-speed-options
              # before enabling the following option:
              # - --trust-primitives
```

## More information

- [Getting started with build_runner][]
- [Running component tests][]

[build_runner]: https://pub.dartlang.org/packages/build_runner
[dart2js]: /tools/dart2js
[dartdevc]: /tools/dartdevc
[Getting started with build_runner]: https://github.com/dart-lang/build/blob/master/docs/getting_started.md
[Switching to dart2js]: https://github.com/dart-lang/build/blob/master/docs/getting_started.md#switching-to-dart2js
[Running component tests]: /angular/guide/testing/component/running-tests
