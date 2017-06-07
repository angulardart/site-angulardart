---
layout: default
permalink: /tools/dartdevc
title: "dartdevc: The Dart Dev Compiler"
description: "Fast, modular compilation of Dart code to JavaScript."
---

The Dart development compiler _(dartdevc_, also known as _DDC)_
lets you run and debug your Dart web app
in any modern browser.
As of SDK release 1.24,
`pub build` and `pub serve` support dartdevc.

Unlike the original Dart-to-JavaScript compiler ([dart2js](/tools/dart2js)),
dartdevc supports incremental compilation and emits modular JavaScript.
When you use `pub serve` with dartdevc,
you can edit your Dart files,
refresh in a modern browser like Chrome,
and see your edits almost immediately.
This speed is possible because pub compiles only updated modules,
not all the packages that your app depends on.

<aside class="alert alert-info" markdown="1">
**Note:**
The first compilation with dartdevc takes as long it would with dart2js
because the entire app must be compiled.
After that, as long as `pub serve` keeps running,
refresh times with dartdevc are much faster than with dart2js.
</aside> 


## Preparing your code

To compile with dartdevc, your web app's code—and
all packages you depend on—must be **type safe**.
For practical details on how to make your code type safe, see the list of
[common errors and warnings.](https://www.dartlang.org/guides/language/sound-problems#common-errors-and-warnings)
More information is in the
[sound Dart guide.](https://www.dartlang.org/guides/language/sound-dart)

<aside class="alert alert-info" markdown="1">
**Tip:**
Your code might already be type safe.
You can check it just by building with dartdevc, or you can run
`dartanalyzer` with [strong mode enabled.](https://www.dartlang.org/guides/language/sound-problems#command-line-analyzer)
</aside>

For best performance, **put implementation files under `/lib/src`**,
instead of anywhere else under `/lib`.
Also, **avoid imports of <code>package:<em>package_name</em>/src/...</code>.**
The
[pub package layout conventions](https://www.dartlang.org/tools/pub/package-layout)
have more information about how to structure your code.
{% comment %}
[PENDING: Can we specify a list of local directories that can import from src/
within a performance penalty?
Say, bin/, lib/, and test/?
Perhaps everything in the same package except web/ can import from src/?]
{% endcomment %}

The following repos have good examples of app code that works with dartdevc:

* [sample-pop_pop_win](https://github.com/dart-lang/sample-pop_pop_win)
* [angular_components_example](https://github.com/dart-lang/angular_components_example)

{% comment %}
TODO: add link to FAQ once it's up.
{% endcomment %}


## Building with dartdevc

To make pub use dartdevc, do one of the following:

* **Modify your pubspec.** A new top-level key named `web` supports a
  single key named `compiler` that maps mode names
  (such as `debug` and `release`) to compilers (`dartdevc`, `dart2js`, or `none`).

  To make `pub serve` use dartdevc
  (assuming `pub serve` runs in its default mode, `debug`),
  put the following in your `pubspec.yaml` file:

  ```yaml
  web:
    compiler:
      debug: dartdevc
  ```

* Alternately, **use the new `--web-compiler` flag** to `pub build` or `pub serve`.
  Specify the `dartdevc` option:

  ```
  pub serve --web-compiler=dartdevc
  ```

<aside class="alert alert-info" markdown="1">
**Note:**
The pubspec setting is the only way to tell WebStorm and IntelliJ
to use dartdevc.
</aside>

## Testing with dartdevc

You can use dartdevc to run your tests in Chrome much more
quickly than is possible with dart2js.
To run a test in Chrome, use the following commands:

```
pub serve test --web-compiler=dartdevc
pub run test -p chrome --pub-serve=8080
```


{% comment %}
## More information

[PENDING:
Link to FAQ.
Point to more info about pub and --web-compiler.]
{% endcomment %}

