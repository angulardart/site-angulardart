---
layout: default
title: "Overview: Web Libraries"
short-title: "Web Libraries"
description: "What libraries are available for writing web apps in Dart?"
---

What kind of support is available for web programming in Dart?
Where can you learn more?

## AngularDart

Learn from the
[Angular docs](/angular).
You can also follow two codelabs:

* [Avast, Ye Pirates: Write an AngularDart App](/codelabs/ng2)
* [AngularDart Components](/codelabs/angular_components)

## JS interop

To leverage one of the many existing libraries written in JavaScript,
use [package:js](https://pub.dartlang.org/packages/js)
to implement Dart-JavaScript interoperability.
If a a TypeScript types definition file exists for a JavaScript library
(see [DefinitelyTyped](http://definitelytyped.org/) for more info),
you can use the [js_facade_gen](https://github.com/dart-lang/js_facade_gen)
tool to generate Dart code for that library.

For examples of using package:js, see the following source code:

[firebase](https://github.com/firebase/firebase-dart)
: Dart wrapper library for Firebase

[captains_log_final](https://github.com/dart-lang/one-hour-codelab/tree/dev-workflow/dev-workflow/captains_log_final)
: Example includes [lib/quill.dart](https://raw.githubusercontent.com/dart-lang/one-hour-codelab/dev-workflow/dev-workflow/captains_log_final/lib/quill.dart) generated from Quill.js

[chartjs](https://github.com/google/chartjs.dart)
: Dart API for Chart.js

{% comment %}
Check out these pages:

https://github.com/TheBosZ/dartins
https://medium.com/@thebosz/creating-a-dart-to-javascript-interop-library-c97da204c34a#.up26ibqyb
{% endcomment %}

## Low-level HTML

The GUI for a web app is programmed in HTML and is represented in the
browser by a tree structure called the Document Object Model (DOM).
Understanding how the DOM works is important for developing
a deeper understanding of HTML concepts.
Use the dart:html library to modify the DOM programmatically.

Once you're ready to develop complex applications that support
event handling and dependency injection, for example,
you'll want a more powerful solution, such as Angular 2 for Dart.

For an introduction to low-level DOM programming,
check out the original [Pirate codelab](/codelabs/darrrt).
The [low-level HTML tutorials](/tutorials/low-level-html) have
further information on how to include a Dart script in an HTML page,
and how to add and remove elements from a web page.

## Other libraries

You're free to use whatever open-source libraries you like
when creating web apps.
For example, you can use [Polymer](/guides/polymer) elements.

---

Also see the [FAQ](/faq).

