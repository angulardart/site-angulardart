An example of using the new `NgTestBed` API with AoT-enabled!

> This is currently targeting [AngularDart 3.0.0][version], which is alpha, but
> of production quality. Using `package:angular_test`, specifically, requires
> the `3.0.0` release(s).

[version]: https://webdev.dartlang.org/angular/version

![demo3](https://cloud.githubusercontent.com/assets/168174/19536743/156845e4-9602-11e6-9f39-b682176b370b.gif)

To run the demo application locally, simply use `pub`:

```bash
$ pub serve
```

In Chrome or Dartium, open up `http://localhost:8080`

You'll see the Angular Dart github issues displayed in a table like you see above.

To see the automated tests running, open up:

1. `http://localhost:8081/issue_body_debug.html`
2. `http://localhost:8081/issue_list_debug.html`

The first test is a simple "do we parse the markdown", test.

The second test is an e2e-style test that uses [pageloader][pageloader].

[pageloader]: https://github.com/google/pageloader

## Automated testing

Our test package supports running these tests too!

You can use the `angular_test` executable to compile and run AoT tests:

```bash
$ pub run angular_test:test
```

This automatically runs `pub serve` to proxy your tests (and compile them) and
runs `pub run test` to run any test tagged with `@Tags(const ['aot])`. It can
safely be used alongside other (non-Angular) tests - just exclude your `aot`
tests from normal runs:

```bash
$ pub run test -x aot 
```
