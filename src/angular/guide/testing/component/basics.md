---
layout: angular
title: "Component Testing: Basics"
description: Techniques and practices for component testing of AngularDart apps.
sideNavGroup: advanced
prevpage:
  title: Running Component Tests
  url: /angular/guide/testing/component/running-tests
nextpage:
  title: "Component Testing: Page Objects"
  url: /angular/guide/testing/component/page-objects
---
{% include_relative _page-top-toc.md %}

Ready to write tests for your own project? This page explains how to setup your
project, and it illustrates how to write basic component tests.

## _Pubspec_ configuration

Projects with component tests depend on the
[angular_test][] and [test][] packages. Because these packages are used
only during development, and not shipped with the app, they don't belong
under `dependencies` in the [pubspec][]. Instead, `test` and `angular_test`
are under **`dev_dependencies`**, for example:

<?code-excerpt "toh-0/pubspec.yaml (dev_dependencies)" title?>
```
  dev_dependencies:
    angular_test: ^1.0.0-beta+2
    browser: ^0.10.0
    dart_to_js_script_rewriter: ^1.0.1
    test: ^0.12.21
```

The `pubspec.yaml` file should also include
the `reflection_remover` and `pub_serve` transformers.
Without these, `angular_test`-based tests won't run.

{% comment %}
TODO: add highlights of the key region once highlighting works again:
https://github.com/dart-lang/site-webdev/issues/374
{% endcomment %}

<?code-excerpt "toh-0/pubspec.yaml (transformers)" title?>
```
  transformers:
  - angular2:
      entry_points: web/main.dart
  - angular2/transform/reflection_remover:
      $include: test/**_test.dart
  - test/pub_serve:
      $include: test/**_test.dart
  - dart_to_js_script_rewriter
```

## API basics: _test_() and _expect_()

Write component tests using the [test][] package API.
For example, define tests using `test()` functions
containing `expect()` test assertions:

<?code-excerpt "toh-0/test/app_test.dart (simple test)" region="default-test" title?>
```
  test('Default greeting', () {
    expect(fixture.text, 'Hello Angular');
  });
```

You can also use other [test][] package features, like [group()][], to write your component tests.

## Test fixture, setup and teardown

Component tests must explicitly define the **component under test**. You define it by passing the component class name as a generic type argument to the [NgTestBed][] and [NgTestFixture][] classes:

<?code-excerpt "toh-0/test/app_test.dart (test bed and fixture)" title?>
```
  final testBed = new NgTestBed<AppComponent>();
  NgTestFixture<AppComponent> fixture;
```

You'll generally initialize the fixture in a `setUp()` function.
Since component tests are often asynchronous, the `tearDown()` function 
generally instructs the test framework to dispose of any running tests
before it moves on to the next test group, if any. Here is an example:

<?code-excerpt "toh-0/test/app_test.dart (excerpt)" region="initial" title?>
```
  @Tags(const ['aot'])
  @TestOn('browser')

  /* . . . */
  @AngularEntrypoint()
  void main() {
    final testBed = new NgTestBed<AppComponent>();
    NgTestFixture<AppComponent> fixture;

    setUp(() async {
      fixture = await testBed.create();
    });

    tearDown(disposeAnyRunningTest);

    test('Default greeting', () {
      expect(fixture.text, 'Hello Angular');
    });
    /* . . . */
  }
```

Use [setUpAll()][] and [tearDownAll()][] for setup/teardown that should encompass all tests and be performed only once for the entire test suite.

## More _package:test_ features

You've just worked through the elementary features of `package:test`. For
complete coverage of the package capabilities, see the package 
[documentation][package:test].

[angular_test]: https://pub.dartlang.org/packages/angular_test
[group()]: https://pub.dartlang.org/packages/test#writing-tests
[group API]: {{site.api}}/test/latest/test/group.html
[NgTestBed]: {{site.api}}/angular_test/latest/angular_test/NgTestBed-class.html
[NgTestFixture]: {{site.api}}/angular_test/latest/angular_test/NgTestFixture-class.html
[package:test]: https://pub.dartlang.org/packages/test
[pubspec]: {{site.dartlang}}/tools/pub/pubspec
[setUpAll()]: {{site.api}}/test/latest/test/setUpAll.html
[tearDownAll()]: {{site.api}}/test/latest/test/tearDownAll.html
[test]: https://pub.dartlang.org/packages/test
