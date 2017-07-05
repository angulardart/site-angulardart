---
layout: angular
title: Testing
description: Techniques and practices for testing an Angular app.
sideNavGroup: advanced
prevpage:
  title: Structural Directives
  url: /angular/guide/structural-directives
nextpage:
  title: Glossary
  url: /angular/glossary
---
Testing is an essential part of software development.
This page shows how to use the **[angular_test][]** package to perform
**[component/subsystem testing][testing]**.

To track the state of all documentation on testing Dart web apps,
subscribe to notifications on [issue #195](https://github.com/dart-lang/site-webdev/issues/195).

[angular_test]: https://pub.dartlang.org/packages/angular_test
[testing]: https://en.wikipedia.org/wiki/Software_testing#Component_interface_testing
{%comment%}E2E: a form of in-browser system testing. https://en.wikipedia.org/wiki/Software_testing#System_testing
TODO: derice the test code from quickstart instead ...?
{%endcomment%}
<?code-excerpt path-base="toh-0"?>
## Starter app tests

The [tutorial](../tutorial)'s [starter app](/angular/tutorial/toh-pt0)
includes a few basic tests for `AppComponent` in the following test file:

<?code-excerpt "test/app_test.dart (excerpt)" region="initial" title?>
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

If you've used modern testing frameworks, then you'll recognize
elements such as the [test fixture][], setup, and teardown functions.

[test fixture]: https://github.com/junit-team/junit4/wiki/test-fixtures

The file contains a test named "Default greeting" that checks whether
the app component template generates the text "Hello Angular".

<?code-excerpt "test/app_test.dart (default-test)"?>
```
  test('Default greeting', () {
    expect(fixture.text, 'Hello Angular');
  });
```

As you'd guess from the test file imports, the test file depends on the
[test][] and [angular_test][] packages. Because these packages are used
only during development, and not shipped with the app, they don't belong
under `dependencies` in the pubspec. Instead, `test` and `angular_test`
are under **`dev_dependencies`**:

[test]: https://pub.dartlang.org/packages/test
[angular_test]: https://pub.dartlang.org/packages/angular_test

<?code-excerpt "pubspec.yaml (dev_dependencies)" title?>
```
  dev_dependencies:
    angular_test: ^1.0.0-beta+2
    browser: ^0.10.0
    dart_to_js_script_rewriter: ^1.0.1
    test: ^0.12.21
```

The `pubspec.yaml` file also includes
the `reflection_remover` and `pub_serve` transformers.
Without these, `angular_test`-based tests won't run.
{%comment%}
//- TODO: add highlights of the key region once highlighting works again:
  https://github.com/dart-lang/site-webdev/issues/374
{%endcomment%}
<?code-excerpt "pubspec.yaml (transformers)" title?>
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

To run tests, open a terminal, and from the project root issue the following
command:

<?code-excerpt class="code-shell"?>
```sh
  pub run angular_test --test-arg=--tags=aot --test-arg=--platform=dartium
```

The test framework runs code transformers, launches [pub serve][], loads the test file, and runs tests:

[pub serve]: /angular/guide/setup#running-the-app

<?code-excerpt class="code-shell"?>
```
  The pub serve output is at .../angular_test_pub_serve_output.log
  Finished AoT compilation. Running tests...
  00:00 +0: loading test/app_test.dart
  00:01 +0: loading test/app_test.dart
  00:02 +0: loading test/app_test.dart
  00:03 +0: loading test/app_test.dart
  00:03 +0: test/app_test.dart: Default greeting
  00:03 +1: test/app_test.dart: Default greeting
  00:03 +1: test/app_test.dart: Greet world
  00:03 +2: test/app_test.dart: Greet world
  00:03 +2: test/app_test.dart: Greet world HTML
  00:03 +3: test/app_test.dart: Greet world HTML
  00:03 +3: All tests passed!
```

You've already seen the code for the "Default greeting" test.
Here's the code for the "Greet world" and "Greet world HTML" tests:

<?code-excerpt "test/app_test.dart (more-tests)"?>
```
  test('Greet world', () async {
    await fixture.update((c) => c.name = 'World');
    expect(fixture.text, 'Hello World');
  });

  test('Greet world HTML', () {
    final html = fixture.rootElement.innerHtml;
    expect(html, '<h1>Hello Angular</h1>');
  });
```

The "Greet world" test interacts with the test fixture by setting
the app component's `name` property to "World", expecting the infamous
greeting as a result.

The "Greet world HTML" test uses the fixture's `rootElement` to get the native
DOM element generated from the component's template. It uses the DOM element
to check that the app component generates the expected HTML.

## Test the Hero Editor

In this section you'll write tests for the [tutorial](../tutorial)'s [Hero Editor](../tutorial/toh-pt1).

_To be continued..._
