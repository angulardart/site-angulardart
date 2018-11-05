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
<?code-excerpt path-base="examples/ng/doc"?>

{% include_relative _page-top-toc.md %}

Ready to write tests for your own project? This page explains how to setup your
project, and it illustrates how to write basic component tests.

## Pubspec configuration

Projects with component tests depend on the
[angular_test][], [build_test][], and [test][] packages. Because these packages are used
only during development, and not shipped with the app, they don't belong
under `dependencies` in the [pubspec][]. Instead add them
under **`dev_dependencies`**, for example:

<?code-excerpt "toh-0/pubspec.yaml (dev_dependencies)" title?>
```
  dev_dependencies:
    angular_test: ^2.0.0
    build_runner: ^1.0.0
    build_test: ^0.10.2
    build_web_compilers: ^0.4.0
    test: ^1.0.0
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
  import 'package:angular_tour_of_heroes/app_component.template.dart' as ng;
  // ···
  void main() {
    final testBed =
        NgTestBed.forComponent<AppComponent>(ng.AppComponentNgFactory);
    NgTestFixture<AppComponent> fixture;
    // ···
  }
```

You'll generally initialize the fixture in a `setUp()` function.
Since component tests are often asynchronous, the `tearDown()` function
generally instructs the test framework to dispose of any running tests
before it moves on to the next test group, if any. Here is an example:

<?code-excerpt "toh-0/test/app_test.dart (excerpt)" region="initial" title?>
```
  @TestOn('browser')

  import 'package:angular_test/angular_test.dart';
  import 'package:angular_tour_of_heroes/app_component.dart';
  import 'package:angular_tour_of_heroes/app_component.template.dart' as ng;
  import 'package:test/test.dart';

  void main() {
    final testBed =
        NgTestBed.forComponent<AppComponent>(ng.AppComponentNgFactory);
    NgTestFixture<AppComponent> fixture;

    setUp(() async {
      fixture = await testBed.create();
    });

    tearDown(disposeAnyRunningTest);

    test('Default greeting', () {
      expect(fixture.text, 'Hello Angular');
    });
    // ···
  }
```

Use [setUpAll()][] and [tearDownAll()][] for setup/teardown that should encompass all tests and be performed only once for the entire test suite.

## More _package:test_ features

You've just worked through the elementary features of `package:test`. For
complete coverage of the package capabilities, see the
[package test documentation.][test]

[angular_test]: https://pub.dartlang.org/packages/angular_test
[build_test]: https://pub.dartlang.org/packages/build_test
[group()]: https://pub.dartlang.org/packages/test#writing-tests
[group API]: {{site.api}}/test/latest/test/group.html
[NgTestBed]: {{site.api}}/angular_test/latest/angular_test/NgTestBed-class.html
[NgTestFixture]: {{site.api}}/angular_test/latest/angular_test/NgTestFixture-class.html
[pubspec]: {{site.dartlang}}/tools/pub/pubspec
[setUpAll()]: {{site.api}}/test/latest/test/setUpAll.html
[tearDownAll()]: {{site.api}}/test/latest/test/tearDownAll.html
[test]: https://pub.dartlang.org/packages/test
