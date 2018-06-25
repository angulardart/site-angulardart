---
layout: default
title: "Overview: Web Libraries"
short-title: "Web Libraries"
description: "What libraries are available for writing web apps in Dart?"
---

Many Dart libraries have support for web app development.
We recommend using the AngularDart framework,
but you also have lower level options.

## AngularDart

Learn from the [Angular documentation][AngularDart].
You can also follow the
[AngularDart codelab.](https://codelabs.developers.google.com/codelabs/your-first-angulardart-web-app/)

<img src="/angular/images/Google-AdWords-Next-Interface-800x342.png"
  alt="Screenshot of AdWords Next"
  title="The UI of AdWords Next">


## JS interop

To leverage one of the many existing libraries written in JavaScript,
use [package:js.](https://pub.dartlang.org/packages/js)
If a [TypeScript type definition](http://definitelytyped.org/)
exists for a JavaScript library, you can use the
[js_facade_gen](https://github.com/dart-lang/js_facade_gen)
tool to generate Dart code for that library.

Here are some projects on GitHub that use package:js:

[dart_js_interop](https://github.com/matanlurey/dart_js_interop)
: Examples of using package:js,
  with comparisons to old code that uses the dart:js library.

[firebase](https://github.com/firebase/firebase-dart)
: Dart wrapper library for Firebase.

{% comment %}
Check out these pages:

https://github.com/TheBosZ/dartins
https://medium.com/@thebosz/creating-a-dart-to-javascript-interop-library-c97da204c34a#.up26ibqyb
{% endcomment %}

## Low-level HTML

If you can't or don't want to use a framework,
you can use Dart's low-level HTML APIs.
Here's some documentation to help you get started:

[Low-level HTML tutorials](/tutorials/low-level-html)
: An overview of DOM, CSS, and HTML concepts, with information on
  how to include a Dart script in an HTML page and
  how to add and remove elements from a web page.
  These tutorials feature interactive examples in
  [DartPad.]({{site.custom.dartpad.direct-link}})

[Tour of the dart:html library](/guides/html-library-tour)
: An example-driven tour of using the dart:html library.
  Topics include manipulating the DOM programmatically,
  making HTTP requests, and using WebSockets.

[dart:html API reference]({{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-html/dart-html-library.html)
: Complete reference documentation for the dart:html library.

Once you're ready to develop complex apps that support
features such as event handling and dependency injection,
we recommend using [AngularDart.][AngularDart]


## Other libraries

To find more libraries that support writing web apps, look at
[web packages on pub.dartlang.org.](https://pub.dartlang.org/web)

---

Also see the [FAQ.](/faq)

[AngularDart]: /angular
