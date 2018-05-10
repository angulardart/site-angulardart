---
title: Running Component Tests
description: Running component tests
sideNavGroup: advanced
prevpage:
  title: Component Testing
  url: /angular/guide/testing/component
nextpage:
  title: "Component Testing: Basics"
  url: /angular/guide/testing/component/basics
toc: false
---
<?code-excerpt path-base="examples/ng/doc"?>

{% include_relative _page-top-toc.md %}

Whether you've just started the [tutorial](/angular/tutorial), or
finished the [Get Started](/guides/get-started) page,
you are ready to run your first tests!
If you haven't worked through these projects recently, don't worry.
You can follow along by first setting up the
tutorial's [Starter App](/angular/tutorial/toh-pt0).

The [tutorial](/angular/tutorial)'s [Starter App](/angular/tutorial/toh-pt0)
includes a few basic tests for its `AppComponent` in the following test file:

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

If you've used modern testing frameworks, then you'll recognize
elements such as the [test fixture][], and setup and teardown functions.

The file contains a test named "Default greeting" that checks whether
the app component template generates the text "Hello Angular":

<?code-excerpt "toh-0/test/app_test.dart (default test)"?>
```
  test('Default greeting', () {
    expect(fixture.text, 'Hello Angular');
  });
```

To run tests, open a terminal, and from the project root issue the following
command:

```terminal
$ pub run build_runner test --fail-on-severe -- -p chrome
```

The optional [build_runner][] `test` flag `--fail-on-severe` prevents tests from
being run if there is a severe build error. For a complete list of
command line options run `pub run build_runner test -h`.

Arguments after `--` (like `-p chrome` above) are passed directly to the [test package][] runner.
To see all command-line options for the test runner, use this command:
`pub run build_runner test -- -h`.

The first test run builds the entire app.
Incremental compilation makes subsequent test runs much quicker.

```terminal
  [INFO] Entrypoint: Generating build script completed, took 230ms
  [INFO] BuildDefinition: Reading cached asset graph completed, took 271ms
  [INFO] BuildDefinition: Checking for updates since last build completed, took 409ms
  [INFO] Build: Running build completed, took 65ms
  [INFO] Build: Caching finalized dependency graph completed, took 115ms
  [INFO] CreateOutputDir: Creating merged output dir `.../build_runner_testimEd04/` completed, took 1.7s
  [INFO] CreateOutputDir: Writing asset manifest completed, took 1ms
  [INFO] Build: Succeeded after 1.9s with 0 outputs
  Running tests...

  00:01 +3: All tests passed!
```

[build_runner]: https://pub.dartlang.org/packages/build_runner
[serves the app]: /angular/guide/setup#running-the-app
[test fixture]: https://github.com/junit-team/junit4/wiki/test-fixtures
[test package]: https://pub.dartlang.org/packages/test