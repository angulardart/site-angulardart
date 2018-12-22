---
title: Changelog
description: A summary of changes to the site documentation and examples.
---

This page summarizes changes to this site's documentation and examples.
Many of these changes are due to new releases of
AngularDart, AngularDart Components, or the Dart SDK.
Others are the result of new recommendations or documentation.

Also see:

{% if site.branch == 'master' and site.data.pkg-vers.angular.next-vers and site.dev-url -%}
* [Changelog for the {{site.data.pkg-vers.angular.next-vers}} (dev) version of this site]({{site.dev-url}}/changelog)
{%- endif %}
* [History of commits to AngularDart documentation](https://github.com/dart-lang/site-webdev/commits/master/src/angular)
* [History of commits to AngularDart examples](https://github.com/dart-lang/site-webdev/commits/master/examples/ng/doc)
* Package changelogs:
  * [`angular` changelog][]
  * [`angular_components` changelog](https://pub.dartlang.org/packages/angular_components#-changelog-tab-)

## Introduction and navigation changes (December 2018)

We've changed the introductory text and site navigation
to more clearly differentiate between the core Dart web platform and
frameworks like [AngularDart][] and [Hummingbird][] that build on it.

## AngularDart 5.2 / Dart 2.1 (December 2018)

- Updated **Dart SDK and Angular package [versions](/version)** in `pubspec.yaml`:
  - `sdk: '>=2.1.0 <3.0.0'`
  - `angular: ^5.2.0`
  - `angular_components: ^0.11.0`
  - `angular_forms: ^2.1.1`
  - `angular_router: ^2.0.0-alpha+21`
  - `angular_test: ^2.2.0`
- Ran [dartfix,][dartfix] which changed one `class` to a `mixin`.


## AngularDart 5.0 beta / Dart 2.0 beta (July 2018)

- Updated **Dart SDK and Angular package [versions](/version)** in `pubspec.yaml`:
  - `sdk: '>=2.0.0-dev.64.2 <3.0.0'`
  - `angular: ^5.0.0-beta+2`
  - `angular_components: ^0.9.0-beta`
  - `angular_forms: ^2.0.0-beta+2`
  - `angular_router: ^2.0.0-alpha+17`
  - `angular_test: ^2.0.0-beta+2`

- Switched to **new [build system][webdev]**:
  - Added new `dev_dependencies`:
    - `build_runner: ^0.9.0`
    - `build_test: ^0.10.2`
    - `build_web_compilers: ^0.4.0`
  - Dropped `dev_dependencies`:
    - <del>`browser`</del>
    - <del>`dart_to_js_script_rewriter`</del>
  - Dropped all old pub `transformers`:
    - <del>`angular`</del>
    - <del>`dart_to_js_script_rewriter`</del>
    - <del>`test/pub_serve`</del>

- Adjusted `web/index.html` files because Dartium is no longer supported:
    - Dropped <del>`<script defer src="packages/browser/dart.js"></script>`</del>
    - Replaced `<script defer src="main.dart" type="application/dart"></script>` by<br>
      `<script defer src="main.dart.js"></script>`
  - Note: `test` version 0.12.30 or later runs chrome tests headless by default.
    We were already using version 0.12.30 along with the Angular 4 examples.

- Added error option to `analysis_options.yaml`:
  - `uri_has_not_been_generated: ignore`

- Changed **app launching** code in `web/main.dart` files:
  - Replaced `import 'package:angular_app/app_component.dart'` by<br>
    `import 'package:angular_app/app_component.template.dart' as ng;`
  - Replaced `bootstrap(AppComponent)` with `runApp(ng.AppComponentNgFactory)`

- Switched to **compile-time dependency injection**:
  - Switched to using typed <code><i>Foo</i>Provider()</code> expressions.

    {:.table .table-striped}
    | Angular 4.x provider | Angular 5 provider |
    |--|--
    | Bare class name `C` | `ClassProvider(C)`
    | `Provider(C, useClass: D)` | `ClassProvider(C, useClass: D)`
    | `Provider(C, useValue: v)` | `ValueProvider(C, v)`
    | `Provider(C, useFactory: f, deps: d)` | `FactoryProvider(C, f)`<br>_(Compile-time DI makes explicitly declaring `deps` unnecessary)_
    | `Provider(C, useExisting: D)` | `ExistingProvider(C, D)`

    For examples, see **Files changed** in the [dependency-injection diff][].

  - Switched to static configuration of root injectors in `web/main.dart` files
    that formerly bootstrapped providers. For example, see `web/main.dart` under
    the **Files changed** tab of the [toh-5 diff][].

- Updated all `test/*_test.dart` files and their **Angular entry points**:
  - Dropped <del>`@Tags(const ['aot'])`</del>
  - Added `import 'foo_test.template.dart' as ng;` in the test file for `foo` components
  - For every function `bar()` annotated with `@AngularEntrypoint()`:
    - Dropped <del>`@AngularEntrypoint()`</del>
    - Replaced `new NgTestBed<AppComponent>().addProviders(providers)` with<br>
      `NgTestBed.forComponent<AppComponent>(ng.FooComponentNgFactory, rootInjector: injector);`
      where `injector` is an injector factory created by
      a newly added `@GenerateInjector`-annotated `injector` field
      (as described above).
  - Examples:
    - See `test/app_test.dart` under the **Files changed** tab of the [quickstart diff][]
    - See `test/dashboard.dart` under the **Files changed** tab of the [toh-5 diff][])

- Adjusted to new **template syntax**:
  - _Binding syntax_:
    - <code>bindon-<i>target</i></code> for [two-way bindings][]
      is no longer supported. Use <code>[(<i>target</i>)]</code> instead.
    - <code>ref-<i>var</i></code> for [template reference variables][]
      is no longer supported. Use <code>#<i>var</i></code> instead.
  - [ngFor][] _microsyntax_ statements must be separated using semicolon (`;`).<br>
      Using a space or comma to separate statements is no longer supported.

- Switched to use of new **Angular router** API:
  There are many Dart file changes (too many to list all here) including:
  - `APP_BASE_HREF` &rarr; `appBaseHref`
  - `ROUTER_DIRECTIVES` &rarr; `routerDirectives`
  - `ROUTER_PROVIDERS` &rarr; `routerProviders`,
    and provide through [runApp()][] (recommended)

- Other Dart file changes:
  -  `CORE_DIRECTIVES` &rarr; `coreDirectives`
  - `COMMON_PIPES` &rarr; `commonPipes`
  - Template-syntax example changes due to the [deprecation of `QueryList`](https://github.com/dart-lang/angular/blob/master/doc/deprecated_query_list.md)
    - Replaced `QueryList<T>` with `List<T>`
    - Switched to using setter to detect changes to view children (`@ViewChildren()`)

Dart 2 specific changes:

- Dart file changes:
  - Dropped `new` keywords
  - Dropped unnecessary `const` keywords
  - Replaced `Future<Null>` with `Future<void>`

Angular doc changes:

- Added a description of `@Component` `export` parameters to the
  [Template Syntax](/angular/guide/template-syntax) page.
- [Component Styles](/angular/guide/component-styles): dropped "Template inline styles" and
  "Template link tags" section since both forms of template styling are now ignored.

More information:

* [`angular` changelog][]
* [5.0 prep tracking issue](https://github.com/dart-lang/site-webdev/issues/1369)
* [Diff between 4.x and 5-dev branches](https://github.com/dart-lang/site-webdev/compare/4.x...master)
* Diff between 4.x and 5-dev branches for selected example apps:
  - Starter app: [quickstart diff]
  - Tutorial services example: [toh-4 diff]({{site.ghNgEx}}/toh-4/compare/4.x...master)
  - Tutorial router example: [toh-5 diff][]
  - Router example: [router diff]({{site.ghNgEx}}/router/compare/4.x...master)
  - Dependency injection example: [dependency-injection diff][]

## HTML library tour (December 2017)

We've moved the dart:html section from the
[Dart library tour]({{site.dartlang}}/guides/libraries/library-tour)
to a new home on this site:
[A Tour of the dart:html Library](/guides/html-library-tour).

## Forms (October 2017)

Updated the [forms][] page and its example app to use custom CSS classes instead of the
`ng-*` classes associated with the deprecated `NgControlStatus`.

## Router _HashLocationStrategy_ (October 2017)

Switched to using [HashLocationStrategy][] in the [Router][] example and the
[Tutorial][].

In this way, features like deep linking into the example apps work as expected
when no server-side support is available (such as with [GitHub Pages][] and with
`pub serve`, which is often used during app development). For details, see
[Which location strategy to use][].

[Which location strategy to use]: /angular/guide/router/1#which-location-strategy-to-use
[GitHub Pages]: https://pages.github.com/
[HashLocationStrategy]: /api/angular_router/angular_router/HashLocationStrategy-class
[Router]: /angular/guide/router
[Tutorial]: /angular/tutorial

## AngularDart 4.0.0 (August 2017)

All pubspecs and imports changed, as well as API doc URLs,
due to the `angular2` package changing its name to `angular`.

* Updated package versions in `pubspec.yaml`:
  * `angular`: `^3.1.0` &rarr; `^4.0.0`
  * `angular_components`: `^0.5.3` &rarr; `^0.6.0`
  * `angular_test`: `^1.0.0-beta` &rarr; `^1.0.0`
  * Added `angular_forms: ^1.0.0` for examples using forms
  * Added `angular_router: ^1.0.0` for examples using the router
* Updated transformers in `pubspec.yaml`:
  * `angular2` &rarr; `angular`
  * Removed `resolved_identifiers` entry from the `angular` transformer
  * Removed `reflection_remover` transformer entry
  * Added `test/**_test.dart` as an `angular: entry_points:` for examples
    with component tests
* Changed imports in Dart files:
  * `angular2/angular2.dart` &rarr; `angular/angular.dart`
  * `angular2/common.dart` &rarr; `angular/angular.dart`
  * `angular2/platform/browser.dart` &rarr; `angular/angular.dart`
  * `angular2/platform/common.dart` &rarr; `angular/angular.dart`
  * `angular2/router.dart` &rarr; `angular_router/angular_router.dart`
  * Added `angular_forms/angular_forms.dart` to files using `formDirectives`
* Other Dart file changes:
  * `FORM_DIRECTIVES` &rarr; `formDirectives`
  * `COMMON_DIRECTIVES` &rarr; `CORE_DIRECTIVES, formDirectives`
  * `const Provider(x,y)` &rarr; `const Provider<T>(x,y)` for a provider of `T` instances;
     this is a first step towards [strongly-typed providers](https://github.com/dart-lang/angular/issues/407)
  * Changed `ElementRef` to `Element`, which requires an import of `dart:html`
  * Changed the CSS pseudo selector `/deep/` to `::ng-deep`
  * Changed a component ([PR#950][]) to use the new `exports` parameter of `@Component`
    ([RFC#374][]) to export enums to the component template
  * Switched from the use of `@Component` `inputs` and `outputs` parameters to appropriate
    `@Input()` and `@Output()` annotations.
  * Switched from the use of `<glyph>` (GlyphComponent) to `<material-icon>`
  ([MaterialIconComponent](/api/angular_components/angular_components/MaterialIconComponent-class))
* Changed API doc URLs
  * The `angular2` &rarr; `angular` change affected API doc URLs. <br>
    Example:
    .../angular2/NgFor-class
    &rarr;
    [.../angular/NgFor-class](/api/angular/angular/NgFor-class)
  * `angular2` &rarr; `angular_forms` for forms API elements, such as `formDirectives`
  * `angular2` &rarr; `angular_router` for router API elements, such as `Route`
* Removed documentation for native view encapsulation since it is no longer supported.

More information:

* [`angular` changelog][]
* [Diff between 3.x and 4-dev branches](https://github.com/dart-lang/site-webdev/compare/3.x...4-dev)
* [History for site-webdev/examples/ng (4-dev branch)](https://github.com/dart-lang/site-webdev/commits/4-dev/examples/ng)
* [4.0 prep tracking issue](https://github.com/dart-lang/site-webdev/issues/670)

[PR#950]: https://github.com/dart-lang/site-webdev/pull/950
[RFC#374]: https://github.com/dart-lang/angular/issues/374

## API reference (August 2017)

The API entries from both the `angular` and `angular_components` packages
have been combined into a single unified [API reference](/api).

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
    - [Routing components](/angular/guide/testing/component/routing-components)
- [End-to-end (E2E) testing](/angular/guide/testing/e2e) _(placeholder)_

## API doc changes (July 2017)

Because `common.dart` is going away in 4.0, we changed API doc generation.
We also fixed some bugs in the API doc homepage
and added import information for each library.

* `angular2.common` &rarr; `angular2` <br>
  Example: .../angular2.common/NgFor-class &rarr; .../angular2/NgFor-class
* [The API doc homepage](/api)
  now shows an `import` statement next to each library's heading.


## Dart 1.24 (June 2017)

We did initial work to prepare the examples to use
the Dart development compiler (dartdevc):

* Updated `pubspec.yaml` to make dartdevc the default development compiler.
* Moved most implementation Dart files under `lib/src/*`,
  instead of `lib/*`, to improve dartdevc performance.

More information:
* [dartdevc documentation](/tools/dartdevc)
* [Dart 1.24 announcement](http://news.dartlang.org/2017/06/dart-124-faster-edit-refresh-cycle-on.html)
* [PR #744](https://github.com/dart-lang/site-webdev/pull/744/files) and other
  ["src reorg" PRs](https://github.com/dart-lang/site-webdev/pulls?utf8=%E2%9C%93&q=is%3Apr%20%22src%20reorg%22)
* [PR #684](https://github.com/dart-lang/site-webdev/pull/684/files)
  (pubspec changes)


## AngularDart 3.1 (May 2017)

The examples changed to update the release and reflect new recommendations.

* Replaced `core.dart` imports:
  `angular2/core.dart` &rarr; `angular2/angular2.dart`
* Updated `angular2.core` API doc references. Example: .../angular2.core/OnInit-class
  &rarr; [.../angular2/OnInit-class](/api/angular/angular/OnInit-class)
* To prepare for 3.1's experimental compiler, in each example:
  * Removed `platform_directives` from `pubspec.yaml`,
    moving the directives it listed
    to the relevant components' `directives` lists.
  * Removed `platform_pipes` from `pubspec.yaml`,
    moving `COMMON_PIPES` to the relevant components' `pipes` lists.
* Updated the `angular2` dependency in each example's pubspec:
  `^3.0.0` &rarr; `^3.1.0`.

Here's an example of moving the directive and pipe lists:

{% prettify yaml %}
# OLD: pubspec.yaml
transformers:
- angular2:
    platform_directives:
    - 'package:angular2/common.dart#CORE_DIRECTIVES'
    platform_pipes:
    - 'package:angular2/common.dart#COMMON_PIPES'
{% endprettify %}

{% prettify dart %}
// NEW: Dart component file
@Component(
  ...
  directives: const [CORE_DIRECTIVES],
  pipes: const [COMMON_PIPES])
{% endprettify %}

Common directive constants include `COMMON_DIRECTIVES`, `CORE_DIRECTIVES`,
`FORM_DIRECTIVES`, and `ROUTER_DIRECTIVES`.


More information:

* [`angular2` changelog][]
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

[4.x toh-5/web/main.dart]: https://github.com/dart-lang/site-webdev/blob/4.x/examples/ng/doc/toh-5/web/main.dart
[AngularDart]: /angular
[`angular` changelog]: https://pub.dartlang.org/packages/angular/versions/{{site.data.pkg-vers.angular.vers | url_escapse}}#-changelog-tab-
[`angular2` changelog]: https://pub.dartlang.org/packages/angular2#-changelog-tab-
[dartfix]: {{site.pub-pkg}}/dartfix
[dependency-injection diff]: {{site.ghNgEx}}/dependency-injection/compare/4.x...master
[forms]: /angular/guide/forms
[Hummingbird]: https://medium.com/flutter-io/hummingbird-building-flutter-for-the-web-e687c2a023a8
[issue #1834]: https://github.com/dart-lang/site-webdev/issues/1834
[ngFor]: /angular/guide/template-syntax#ngFor
[quickstart diff]: {{site.ghNgEx}}/quickstart/compare/4.x...master
[runApp()]: /api/angular/angular/runApp.html
[template reference variables]: /angular/guide/template-syntax#ref-vars
[toh-5 diff]: {{site.ghNgEx}}/toh-5/compare/4.x...master
[two-way bindings]: /angular/guide/template-syntax#two-way
[webdev]: /tools/webdev
