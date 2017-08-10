---
layout: default
permalink: /tools/dartdevc/faq
title: "dartdevc: FAQ"
description: "FAQ and other tips for using dartdevc."
---

This page answers common questions about the Dart dev compiler (dartdevc).
For information on how to use dartdevc, see the
[dartdevc documentation](/tools/dartdevc).

## The basics

#### What is dartdevc?

The dartdevc tool is a new Dart-to-JavaScript compiler
that's targeted at web app development in modern browsers.
The existing Dart-to-JavaScript compiler,
[dart2js](/tools/dart2js),
is still supported.


#### How do I use dartdevc?

Don't run `dartdevc` directly.
Instead, use a build tool.
For instructions on using `pub build` and `pub serve`
with dartdevc,
see the [dartdevc documentation.](/tools/dartdevc)


#### When should I use dartdevc?

Use **dartdevc** whenever you're actively working on your code.
Here are some of the advantages of dartdevc over dart2js:

* Faster refreshing after code changes.
* Stronger runtime checks, based on
  [strong mode Dart]({{site.dartlang}}/guides/language/sound-dart).
* Simpler, more readable, more idiomatic JavaScript output
  containing fewer runtime checks.
* Integration with Chrome dev tools for easier debugging.

Keep using **dart2js** to build your deployed, production application.
With dart2js you get advanced optimizations such as
tree shaking to minimize downloaded code size.


#### What browsers does dartdevc work with?

Chrome is the only supported browser.
You _might_ be able to use other modern browsers
(Edge, Firefox, and Safari).

If you find a bug in dartdevc's support for Chrome, Edge, Firefox, or Safari, please
[create an issue.](https://github.com/dart-lang/sdk/issues/new?title=[dartdevc]%20)


## Common problems

#### My code analyzes correctly, so why am I getting compile-time errors?

Because dartdevc analyzes more code.

The Dart analyzer looks at an individual package's source code,
not the code of any additional packages.
In contrast, dartdevc analyzes the whole, generated program;
it covers the original source code,
plus generated code and all used packages.

{% comment %}
TODO: Provide guidance as to how to debug such errors,
especially when they come from generated code or third-party libraries.
{% endcomment %}


#### My code analyzes correctly, so why am I getting runtime errors?

Some of dartdevc's type safety checks are implemented only at runtime.
Even if your code has no static type safety errors,
you may see runtime errors in dartdevc that you don't see in dart2js or the VM
(even in checked mode).

For more information, see
[Strong Mode Dart]({{site.dartlang}}/guides/language/sound-dart)
(especially the sections on
[runtime checks]({{site.dartlang}}/guides/language/sound-dart#runtime-checks)
and
[resources]({{site.dartlang}}/guides/language/sound-dart#other-resources))
and the
[common problems page.]({{site.dartlang}}/guides/language/sound-problems)


#### Why does dartdevc take longer to run the first time?

Because it's compiling your entire app,
including the packages your app depends on.

The first time `pub build` or `pub serve` compiles your app,
dartdevc compiles every module.
Afterward, as long as pub continues to run,
pub tracks which Dart files change,
and it recompiles only the modules that are affected by those changes.


#### Why are subsequent runs taking a long time?

Are the implementation files for your package under `lib/src`?
If not, pub is probably creating too many modules.
For more information, see
[How are the modules created?](#how-are-the-modules-created)


#### Why is dartdevc producing so many JavaScript files?

Pub is probably creating too many modules
because implementation files aren't under `lib/src`.
For more information, see
[How are the modules created?](#how-are-the-modules-created)


#### Where can I see known problems with dartdevc?

Issues are in the Dart SDK repo
with the label [area-dev-compiler.](https://github.com/dart-lang/sdk/issues?q=is%3Aissue%20is%3Aopen%20label%3Aarea-dev-compiler)


## Modules

#### What are JavaScript modules?

When you use pub with dartdevc, modules are an implementation detail.

Pub uses dartdevc to create several JavaScript modules,
each of which contains code generated from one or more Dart files.
When you edit your Dart files,
`pub serve` recompiles only the affected modules, instead of your whole app.
The result is a much quicker edit-refresh cycle.

By contrast, when you use dart2js with or without pub,
dart2js creates one JavaScript file for the entire application.

If you'd like to know more about JavaScript modules,
see Preethi Kasireddy's
[beginner's guide](https://medium.freecodecamp.com/javascript-modules-a-beginner-s-guide-783f7d7a5fcc) or
Addy Osmani’s
[article on writing modular JavaScript.](https://addyosmani.com/writing-modular-js/)


#### How are the modules created?

When you use pub with dartdevc,
a heuristic that's based on package structure
determines which modules pub creates:

* One module for each Dart file that’s under `lib`, but not under `lib/src`. <br>
  These are the Dart files that are part of the package's public API,
  and can be imported by other packages.

* One module for each Dart file that’s not under `lib` and
  that contains a top-level `main` function. <br>
  For example, `web/main.dart` gets its own module.

* One module for each Dart file that’s not imported by one of the above.

* Shared modules. <br>
  Pub produces a minimum set of shared modules,
  taking care not to introduce cycles.

Any Dart file that is imported ends up either
directly in the importing file’s module
or (if it’s imported more than once) in a shared module.

These rules ensure that no Dart file is compiled into more than one module.
Importing only from `lib` and not `lib/src`
minimizes the amount of code that your app loads.


#### What kind of modules does dartdevc produce?

When run with pub, dartdevc generates
[AMD modules.](https://github.com/amdjs/amdjs-api/blob/master/AMD.md#amd)
It can also generate
[ES6 (Harmony)](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Statements/import) and
[CommonJS (Node)](https://nodejs.org/docs/latest/api/modules.html#modules_modules)
modules.


#### Can I customize my modules?

Not today, but possibly in the future.


{% comment %}
PENDING: talk about summaries?
{% endcomment %}

## Resources

#### Where can I talk to people who are using dartdevc?

Try one of the [Dart Gitter rooms](https://gitter.im/dart-lang/home)—perhaps
[dev_compiler](https://gitter.im/dart-lang/dev_compiler).


#### Where can I learn what to do about common dartdevc errors?

Although you can find help for
[common analyzer errors and warnings,]({{site.dartlang}}/guides/language/sound-problems#common-errors-and-warnings)
there's no similar help for dartdevc-specific errors.
See [SDK issue #29825](https://github.com/dart-lang/sdk/issues/29825)
for more information.


#### Where can I learn the gory details of dartdevc?

You can find source code and more documentation in the Dart SDK repo under
[`/pkg/dev_compiler`.](https://github.com/dart-lang/sdk/tree/master/pkg/dev_compiler)
