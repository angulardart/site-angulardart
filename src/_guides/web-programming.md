---
layout: default
title: "Overview: Web Libraries"
short-title: "Web Libraries"
description: "What libraries are available for writing web apps in Dart?"
---

What kind of support is available for web programming in Dart?
Where can you learn more?

## Angular

Work through the
[Angular 2 code lab](/codelabs/ng2/),
and then learn more from the
[Angular 2 for Dart](https://angular.io/dart) docs.

## JS interop

Perhaps you want to leverage one of the many existing libraries
written in JavaScript.
Use [package.js](https://pub.dartlang.org/packages/js)
to implement Dart-JavaScript interoperability.
The [chartjs](https://github.com/google/chartjs.dart/)
example provides an end-to-end example of using package:js.

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
check out the original [Pirate code lab](/codelabs/darrrt).
The [low-level HTML tutorials](/tutorials/low-level-html/) have
further information on how to include a Dart script in an HTML page,
and how to add and remove elements from a web page.
The [Improving the DOM](/articles/low-level-html/improving-the-dom) article
gives an overview of Dart's DOM API,
and how it differs from the JavaScript DOM API.

## Other libraries

You're free to use whatever open-source libraries you like
when creating web apps.
For example, you can use [Polymer](/guides/polymer) elements.

---

Also see the [FAQ](/faq).

