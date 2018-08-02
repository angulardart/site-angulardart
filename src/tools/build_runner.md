---
layout: angular
title: Build_runner
description: A tool for building, serving, and testing web apps (and more).
---
<?code-excerpt path-base="examples/ng/doc"?>

This page describes the [build_runner][] package and its commands.

You don't usually need to use build_runner directly, except for running
component tests from the command line. Instead, use the [webdev][] tool to build
and serve apps.

## Setting up build_runner

To use `build_runner`, add these dev dependencies to your app's pubspec:

<?code-excerpt "quickstart/pubspec.yaml (build dependencies)" title?>
```
  dev_dependencies:
    # ···
    build_runner: ^0.10.0
    build_test: ^0.10.2
    build_web_compilers: ^0.4.0
```

The `build_test` package is optional; add it if you'll be testing your app.

As usual after `pubspec.yaml` changes, run `pub get` or `pub upgrade`:

```terminal
$ pub get
```

## Build config files {#config}

You can customize build_runner behavior using build config files. The default
build config filename is `build.yaml`.

You can also create named config files like <code> build.<i>name</i>.yaml</code>.
For example, if you have a build config file named `build.debug.yaml`, use it
&mdash; instead of `build.yaml` &mdash; like this:

```terminal
$ pub run build_runner build --config debug
```

For more information see [Customizing builds][]
and [build_web_compilers configuration.][build_web_compilers configuration]

## Command: test {#test}

Use the `test` command to run your app's [component tests][]:

```
pub run build_runner test [--fail-on-severe] -- -p <platform>
```

The optional `--fail-on-severe` flag prevents tests from being run if there is a
severe build error. For a complete list of command line options run `pub run
build_runner test -h`.

Arguments after `--` are passed directly to the [test package][] runner. To see
all command-line options for the test runner, use this command: `pub run
build_runner test -- -h`.

For example, this is how you'd run component tests in Chrome:

```terminal
$ pub run build_runner test --fail-on-severe -- -p chrome
```

## Other commands

The [webdev][] tool is built on [build_runner][]. You'll generally use webdev to
build and serve apps, unless you need direct access to all of the underlying
build_runner command options.

### Command: build {#build}

Use the `build` command to build your web app:

```
pub run build_runner build [--release] [--output <dirname>] ...
```

The first build is the slowest. After that, assets are cached on disk and
incremental builds are much faster.

To continuously run builds as you edit, use the `watch` command.

By default, `build_runner` uses the [dartdevc][] web compiler. To build a
production version of your app, add `--release`, which uses the [dart2js][]
compiler:

```terminal
$ pub run build_runner build --release
```

For more information, see [Switching to dart2js.][Switching to dart2js]

### Command: serve {#serve}

To run a development server, use the `serve` command:

```terminal
$ pub run build_runner serve
```

By default this serves the `web` and `test` directories, on ports `8080` and `8081` respectively.

While the `serve` command runs, every change you save triggers a rebuild.

## More information

- [Getting started with build_runner][]
- [Running component tests][]

[build_runner]: https://pub.dartlang.org/packages/build_runner
[build_web_compilers configuration]: https://github.com/dart-lang/build/tree/master/build_web_compilers#configuration
[component tests]: /angular/guide/testing/component
[Customizing builds]: https://github.com/dart-lang/build/blob/master/build_config/README.md
[dart2js]: /tools/dart2js
[dartdevc]: /tools/dartdevc
[Getting started with build_runner]: https://github.com/dart-lang/build/blob/master/docs/getting_started.md
[Switching to dart2js]: https://github.com/dart-lang/build/blob/master/docs/getting_started.md#switching-to-dart2js
[test package]: https://pub.dartlang.org/packages/test
[Running component tests]: /angular/guide/testing/component/running-tests
[webdev]: /tools/webdev
