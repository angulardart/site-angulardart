---
layout: angular
title: AngularDart Changelog
description: A summary of changes to the AngularDart documentation and examples.
---

This page summarizes changes to the AngularDart documentation and examples.
Many of these changes are due to new releases of
AngularDart, AngularDart Components, or the Dart SDK.
Others are the result of new recommendations or documentation.

Also see:

* [History of commits to AngularDart documentation](https://github.com/dart-lang/site-webdev/commits/master/src/angular)
* [History of commits to AngularDart examples](https://github.com/dart-lang/site-webdev/commits/master/examples/ng/doc)
* Package changelogs:
  * [`angular2` changelog][]
  * [`angular` changelog][]
  * [`angular_components` changelog](https://pub.dartlang.org/packages/angular_components#pub-pkg-tab-changelog)


## Testing docs, part 2 (August 2017)

Created several test-related pages.
The original page, [Testing](/angular/guide/testing),
is now mostly a table of contents.

All of these pages are drafts, and we'd appreciate your feedback.

- [Component testing](/angular/guide/testing/component)
  - [Running component tests](/angular/guide/testing/component/running-tests)
  - <span>Writing component tests</span>
    - [Basics](/angular/guide/testing/component/basics): pubspec config, test
      API fundamentals
    - [Page objects](/angular/guide/testing/component/page-objects): field annotation, initialization and more
    - [Simulating user action](/angular/guide/testing/component/simulating-user-action): click, type, clear
    - [Services](/angular/guide/testing/component/services): local, external, mock or real
    - [`@Input()` and `@Output()`](/angular/guide/testing/component/input-and-output)
    - [Routing components](/angular/guide/testing/component/routing-components): mocking the router or platform location
- [End-to-end (E2E) testing](/angular/guide/testing/e2e) _(placeholder)_


## AngularDart 4.0 alpha (July-August 2017)

<aside class="alert alert-info" markdown="1">
**Note:**
These changes aren't yet visible on webdev.dartlang.org,
but you can see a preview at
[webdev-dartlang-org-dev.firebaseapp.com/angular.](https://webdev-dartlang-org-dev.firebaseapp.com/angular)
</aside>

All pubspecs and imports changed, as well as API doc URLs,
due to the `angular2` package changing its name to `angular`.
We expect some imports (and API doc URLs) to change again before 4.0 is stable,
because the forms implementation is moving into a new package (`angular_forms`).

* Updated package versions in `pubspec.yaml`:
  * `angular`: `^3.1.0` &rarr; `^4.0.0-alpha+2`
  * `angular_components`: `^0.5.2` &rarr; `^0.6.0-alpha+2`
  * `angular_test`: `^1.0.0-beta+2` &rarr; `^1.0.0-beta+5`
* Updated transformers in `pubspec.yaml`:
  * `angular2` &rarr; `angular`
  * Removed `resolved_identifiers` entry from the `angular` transformer
  * Removed `reflection_remover` transformer entry
  * Added `test/**_test.dart` as an `angular: entry_points:` for packages
    with component tests
  * Added `angular_router: ^1.0.0` for packages using the router
* Changed imports in Dart files:
  * `angular2/angular2.dart` &rarr; `angular/angular.dart`
  * `angular2/common.dart` &rarr; `angular/angular.dart`
  * `angular2/platform/browser.dart` &rarr; `angular/angular.dart`
  * `angular2/platform/common.dart` &rarr; `angular/angular.dart`
  * `angular2/router.dart` &rarr; `angular_router/angular_router.dart`
* Other Dart file changes:
  * `FORM_DIRECTIVES` &rarr; `formDirectives`
  * `const Provider(x,y)` &rarr; `const Provider<T>(x,y)` for a provider of `T` instances;
     this is a first step towards [strongly-typed providers](https://github.com/dart-lang/angular/issues/407)

{% comment %}
    * In Dart files that use form directives
    (those that use `COMMON_DIRECTIVES` or `FORM_DIRECTIVES`)
    add an import of ... [PENDING: fix].
    * [PENDING: add any other import changes here...]
{% endcomment %}
* Changed API doc URLs
  * The `angular2` &rarr; `angular` change affected API doc URLs. <br>
    Example:
    [.../angular2/NgFor-class](/angular/api/angular2/NgFor-class)
    &rarr;
    [.../angular/NgFor-class](https://webdev-dartlang-org-dev.firebaseapp.com/angular/api/angular/NgFor-class)
{% comment %}
  * router
{% endcomment %}

More information:

* [`angular` changelog][]
* [Diff between 4-dev and master branches](https://github.com/dart-lang/site-webdev/compare/4-dev)
* [History for site-webdev/examples/ng (4-dev branch)](https://github.com/dart-lang/site-webdev/commits/4-dev/examples/ng)
* [4.0 prep tracking issue](https://github.com/dart-lang/site-webdev/issues/670)


## API doc changes (July 2017)

Because `common.dart` is going away in 4.0, we changed API doc generation.
We also fixed some bugs in the API doc homepage
and added import information for each library.

* `angular2.common` &rarr; `angular2` <br>
  Example: .../angular2.common/NgFor-class &rarr;
  [.../angular2/NgFor-class](/angular/api/angular2/NgFor-class)
* [The AngularDart API doc homepage](/angular/api)
  now shows an `import` statement next to each library's heading.


## Dart 1.24 (June 2017)

We did initial work to prepare the examples to use
the Dart development compiler (dartdevc):

* Updated `pubspec.yaml` to make dartdevc the default development compiler.
* Moved most implementation Dart files under `lib/src/*`,
  instead of `lib/*`, to improve dartdevc performance.

More information:
* [Preparing your code](/tools/dartdevc#preparing-your-code) in the
[dartdevc documentation](/tools/dartdevc)
* [Dart 1.24 announcement](http://news.dartlang.org/2017/06/dart-124-faster-edit-refresh-cycle-on.html)
* [PR #744](https://github.com/dart-lang/site-webdev/pull/744/files) and other
  ["src reorg" PRs](https://github.com/dart-lang/site-webdev/pulls?utf8=%E2%9C%93&q=is%3Apr%20%22src%20reorg%22)
* [PR #684](https://github.com/dart-lang/site-webdev/pull/684/files)
  (pubspec changes)


## AngularDart 3.1 (May 2017)

The examples changed to update the release and reflect new recommendations.

* Replaced `core.dart` imports:
  `angular2/core.dart` &rarr; `angular2/angular2.dart`
* To prepare for 3.1's experimental compiler, in each example:
  * Removed `platform_directives` from `pubspec.yaml`,
    moving the directives it listed
    to the relevant components' `directives` lists.
  * Removed `platform_pipes` from `pubspec.yaml`,
    moving `COMMON_PIPES` to the relevant components' `pipes` lists.
* Updated the `angular2` dependency in each example's pubspec:
  `^3.0.0` &rarr; `^3.1.0`.

Here's an example of moving the directive and pipe lists:

<?code-excerpt title="OLD: pubspec.yaml"?>
```
transformers:
- angular2:
    platform_directives:
    - 'package:angular2/common.dart#CORE_DIRECTIVES'
    platform_pipes:
    - 'package:angular2/common.dart#COMMON_PIPES'
```

<?code-excerpt title="NEW: component file (Dart)"?>
```
@Component(
  ...
  directives: const [CORE_DIRECTIVES],
  pipes: const [COMMON_PIPES])
```

Common directive constants include `COMMON_DIRECTIVES`, `CORE_DIRECTIVES`,
`FORM_DIRECTIVES`, and `ROUTER_DIRECTIVES`.


More information:

* [`angular2` changelog](https://pub.dartlang.org/packages/angular2#pub-pkg-tab-changelog)
* [PR #625](https://github.com/dart-lang/site-webdev/pull/625/files?w=1)
  (moves directive and pipe lists from pubspecs to components)


## Testing doc and code, part 1 (March-April 2017)

Created an initial [Testing page](/angular/guide/testing) and
added component tests to the tutorial examples.

Pubspec updates:

* Added `angular_test` and `test` to the `dev_dependencies` list.
* Added the `reflection_remover` and `pub_serve` transformers.

More information:

* [PR #478](https://github.com/dart-lang/site-webdev/pull/478/files) (initial text and toh-0 tests)
* [PR #567](https://github.com/dart-lang/site-webdev/pull/567/files?w=1) (toh-6 tests)

[`angular` changelog]: https://pub.dartlang.org/packages/angular/versions/4.0.0-alpha%2B2#pub-pkg-tab-changelog
[`angular2` changelog]: https://pub.dartlang.org/packages/angular2#pub-pkg-tab-changelog
