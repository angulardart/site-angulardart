---
title: Dart 2 Migration Guide
description: Tips for migrating your web app from Dart 1.x to Dart 2.
---
{% assign ng5-url = site.dev-url -%}
{% assign ng5-desc = ' on the dev version of this site' -%}

<style>
del { color: rgba(255,0,0,.35); }
del code { color: darkred; }
</style>

<aside class="alert-warning alert" markdown="1">
  **This page is still under construction.**
</aside>

This page will guide you through migrating your Dart 1.x web app to Dart 2.
These changes are necessary because of the following:

- [Tooling changes](#tools):
  - **Chrome** replaces Dartium and content-shell.
  - A **new build system** replaces `pub build` and `pub serve`.
- Dart 2 [language and library changes.][dart-2]

## Tools

The development environment for web apps is different in Dart 2 from Dart 1.x.
Here are the highlights:

{:.table .table-striped}
| **Dart 1.x** | **Dart 2** |
| Dartium, content-shell | Chrome and [dartdevc][] |
| `pub build` | `pub run build_runner build`. See: [build_runner][] |
| `pub serve` | `pub run build_runner serve`. See: [build_runner][] |
| `pub run angular_test` | `pub run build_runner test -- -p chrome`. See: [Running tests][]{{ng5-desc}}

## Code

To migrate to Dart 2, you'll need to edit your web app's project files:

- `pubspec.yaml`, [see details below.](#pubspec)
- HTML files with `<script src="foo.dart"...>` elements,
  such as `web/index.html`. [See details below.](#web-index-html)
- Dart code, due to changes in the [Dart language and libraries.][dart-2]

For complete examples of migrated apps, compare the `master` and `5-dev` branches
of any one of the [angular-examples][] apps, such as these:

- [Quickstart][angular-examples/quickstart]
- [Tour of Heroes, part 5][angular-examples/toh-5]

### Pubspec

Make these changes to your `pubspec.yaml` file:

- Add new `dev_dependencies`:
  - `build_runner: {{site.data.pubspec.dev_dependencies.build_runner}}`
  - `build_test: {{site.data.pubspec.dev_dependencies.build_test}}`, if you are running tests
  - `build_web_compilers: {{site.data.pubspec.dev_dependencies.build_web_compilers}}`
- Drop `dev_dependencies`:
  - <del>`browser`</del>
  - <del>`dart_to_js_script_rewriter`</del>
- Upgrade to `test` version 0.12.30 or later; it runs Chrome tests headless by default.
- Drop all `transformers`:
  - <del>`angular`</del>
  - <del>`dart_to_js_script_rewriter`</del>
  - <del>`test/pub_serve`</del>

For example, here is a diff of
[angular-examples/quickstart/pubspec.yaml][]
with these changes applied.

<a id="web-index-html"></a>
### HTML with script elements

The most common example of a file with `<script>` elements is `web/index.html`.
You'll need to make these changes:

- Drop <del>`<script defer src="packages/browser/dart.js"></script>`</del>
- Replace <del>`<script defer src="foo.dart" type="application/dart"></script>`</del> by<br>
  `<script defer src="foo.dart.js"></script>`

Here is a diff of
[angular-examples/quickstart/web/index.html][]
with these changes applied.

## Additional resources

- [Dart 2 Updates:][dart-2]
  Information about changes in Dart 2, and how to migrate your code from Dart 1.x.
- [dartdevc: The Dart Dev Compiler][dartdevc]:
  Describes how to prepare your code for dartdevc, build with dartdevc, and
  test with dartdevc.
- [Getting started with build_runner:][Getting started with build_runner]
  Describes how to use the new build system. For example, it shows how to use
  `build_runner` (instead of `pub serve`) as a development server.
- [Changelog][Documentation changelog]{{ng5-desc}}:
  Lists changes made to this site's documentation and examples.

[angular-examples]: https://github.com/angular-examples
[angular-examples/quickstart]: https://github.com/angular-examples/quickstart/compare/master...5-dev
[angular-examples/quickstart/pubspec.yaml]: https://github.com/angular-examples/quickstart/compare/master...5-dev#diff-2
[angular-examples/quickstart/web/index.html]: https://github.com/angular-examples/quickstart/compare/master...5-dev#diff-4
[angular-examples/toh-5]: https://github.com/angular-examples/toh-5/compare/master...5-dev
[build_runner]: https://github.com/dart-lang/build/blob/master/build_runner/README.md
[dart-2]: {{site.dartlang}}/dart-2
{% comment %}This should be {{ng5-url}}/tools/dartdevc, but there aren't enough differences in the pages at the moment, so we'll let it point to master for now.{% endcomment %}
[dartdevc]: /tools/dartdevc
[Documentation changelog]: {{ng5-url}}/changelog
[Getting started with build_runner]: https://github.com/dart-lang/build/blob/master/docs/getting_started.md#getting-started-with-build_runner
[Running tests]: {{ng5-url}}/angular/guide/testing/component/running-tests
