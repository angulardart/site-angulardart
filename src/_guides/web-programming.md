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
If a TypeScript type definition file exists for a JavaScript library
(see [DefinitelyTyped](http://definitelytyped.org/) for more info),
you can use the
[js_facade_gen](https://github.com/dart-lang/js_facade_gen)
tool to generate Dart code for that library.

Here are some projects on GitHub that use package:js:

[firebase](https://github.com/firebase/firebase-dart)
: Dart wrapper library for Firebase.

[captains_log_final](https://github.com/dart-lang/one-hour-codelab/tree/dev-workflow/dev-workflow/captains_log_final)
: Example includes [lib/quill.dart,](https://raw.githubusercontent.com/dart-lang/one-hour-codelab/dev-workflow/dev-workflow/captains_log_final/lib/quill.dart) which is generated from Quill.js.

[chartjs](https://github.com/google/chartjs.dart)
: Dart API for Chart.js.

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
Use the dart:html library
([tour](/guides/html-library-tour),
[API reference]({{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-html/dart-html-library.html))
to modify the DOM programmatically.

The [low-level HTML tutorials](/tutorials/low-level-html) have
further information on how to include a Dart script in an HTML page,
and how to add and remove elements from a web page.

Once you're ready to develop complex applications that support
features such as event handling and dependency injection,
we recommend using [AngularDart.][AngularDart]


## Other libraries

To find more libraries that support writing web apps, look at
[web packages on pub.dartlang.org.](https://pub.dartlang.org/web)

---

Also see the [FAQ.](/faq)

[AngularDart]: /angular
