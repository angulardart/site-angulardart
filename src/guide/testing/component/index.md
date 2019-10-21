---
title: Component Testing
sideNavGroup: advanced
prevpage:
  title: Testing
  url: /guide/testing
nextpage:
  title: Running Component Tests
  url: /guide/testing/component/running-tests
toc: false
---
{% comment %}
TODO(chalin):
- The original plan called for an Appendix covering Mockito. If we do, add a link
  to it under the package:mockito bullet below. Otherwise,
  remove reference to the appendix elsewhere in the doc.
{% endcomment %}

This part of the [Testing](/guide/testing) how-to guide covers
[component testing][] of AngularDart apps using the following packages:

[package:test][]
: Dart's standard [testing][] package, which is similar to most
  [unit testing][] frameworks, including [Jasmine][] for
  JavaScript. If you've used a modern testing framework before,
  then writing tests using `package:test` will have a familiar feel.
  Testing basics is covered in [Writing component tests: Basics](component/basics). For
  in-depth coverage of the package capabilities, see the `package:test`
  [documentation][package:test].

[package:angular_test][]
: A complementary package that provides a means of interacting with Angular components created as test fixtures.

[package:mockito][]
: A library for creating
  [mock objects](https://en.wikipedia.org/wiki/Mock_object).
  Not all component tests require mock objects, but in later sections, you'll learn
  the fundamentals of using `package:mockito` as needed. For further details,
  see the package [documentation][package:mockito].

## Scope

The [angular_test][] package is suitable for testing either a
single component, or a _small_ group of related components.
This package is not meant to test an entire app. For that, you need to write
[end-to-end tests](/guide/testing/e2e).

## Topics

This guide covers the following component testing topics:

{% include_relative _toc.md %}
{% comment %}
{% include_relative _page-top-toc.md %}
{% endcomment %}

[Jasmine]: https://jasmine.github.io
[angular_test]: https://pub.dev/packages/angular_test
[component testing]: https://en.wikipedia.org/wiki/Software_testing
[package:angular_test]: https://pub.dev/packages/angular_test
[package:mockito]: https://pub.dev/packages/mockito
[package:test]: https://pub.dev/packages/test
[testing]: {{site.dartlang}}/guides/testing
[unit testing]: https://en.wikipedia.org/wiki/Unit_testing
