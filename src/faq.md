---
title: Dart Web Development FAQ
short-title: FAQ
description: FAQ and other tips for using Dart for web development.
---

_Updated December 2018_

This FAQ applies to web programming. For more general Dart questions,
see the [Dart FAQ.]({{site.dartlang}}/faq)

## General

### Q. What browsers do you support as JavaScript compilation targets?

The _production_ compiler ([dart2js][]) supports Internet Explorer 11
and the last two versions of the following browsers:

  * Chrome
  * Edge
  * Firefox
  * Safari

The _development_ compiler ([dartdevc][]) supports only Chrome.

### Q. Is Dart supported by my browser?

Although no production browsers can execute Dart code directly,
all modern browsers can execute Dart code that's been compiled to JavaScript.

### Q. How do I debug an app?

For setup details and a walkthrough, see [Debugging Dart Web Apps](/guides/debugging).

The [debugging](/tools/dart2js#debugging) section of the dart2js documentation
has some tips for specific browsers.

### Q. Can I use Angular with Dart?

Yes! [AngularDart][] is a port of Angular to Dart.

### Q. Should I use Angular or Polymer?

Use [AngularDart][].
[Polymer Dart][Polymer Dart] is no longer supported and is likely to break in
[Dart 2.]({{site.dartlang}}/dart-2)
At [Flutter Live][] we announced [Hummingbird][] as
an experimental way to write web applications.
We'll let you know when Hummingbird is ready to use.

### Q. Can I build a Chrome App with Dart?

You can use the [chrome.dart] libraries,
but you still need to compile to JavaScript.
But otherwise, yes, you can build a Chrome App with Dart.

---

## JavaScript and other web technologies

### Q. Does Google want to replace JavaScript with Dart?

No. We believe that developers should have a choice when they build for the web.
Adding a new option, such as Dart, does not imply replacing an existing option.

### Q. How does Dart code interoperate with JavaScript libraries?

Although Dart and JavaScript are completely separate languages with
separate VMs, they can interoperate. For more information, see
[package:js](https://pub.dartlang.org/packages/js) and
the [chartjs](https://github.com/google/chartjs.dart/) example.

### Q. I have a large JavaScript codebase. How can I migrate it to Dart?

Try migrating one major feature at a time, and use the
[JavaScript interoperability library][jsinterop]
only when necessary.

### Q. How does Dart compare with using the Closure compiler on JavaScript?

The idea of optional type annotations is similar.
Dart's are nicer syntactically.

Compare the following Closure compiler code:

{% prettify dart %}
// Closure compiler code

/**
 * @param {String} name
 * @return {String}
 */
makeGreeting = function(name) {
  /** @type {String} */
  var greeting = 'hello ' + name;
  return greeting;
}
{% endprettify %}

With the following Dart code:

{% prettify dart %}
// Dart code

String makeGreeting(String name) {
  String greeting = 'hello $name';
  return greeting;
}
{% endprettify %}

### Q. How does Dart compare with CoffeeScript?

Both Dart and CoffeeScript are inspired by JavaScript, and both can be
translated back to it.  They make different choices, particularly in the flavor
of their syntax.  As a language we think it's fair to say that Dart differs
semantically from JavaScript more than CoffeeScript does; that may result in a
less line-for-line translation, but we believe Dart-generated JavaScript can
have excellent size and speed.

Dart introduces new semantics, while CoffeeScript retains the semantics
of JavaScript.

If you like CoffeeScript for its more structured feel than raw JavaScript, you
may like Dart's static type annotations.

### Q. What does Google think of TypeScript?

TypeScript and Dart have similar goals; they make building large-scale web
apps easier. However, their approaches are fairly different. TypeScript
maintains backwards compatability with JavaScript, whereas Dart purposely made a
break from certain parts of JavaScript’s syntax and semantics in order to
eradicate large classes of bugs and to improve performance. The web has suffered
from too little choice for too long, and we think that both Dart and TypeScript
are pointing to a brighter future for web developers. You can read a
[more complete response][typescript] on our blog.

### Q. I have a large app written in GWT. How do I port it to Dart?

Java and Dart are syntactically similar,
so this might be easier than you think.
You can rely on the [Dart analyzer][dartanalyzer]
to flag any syntax problems. Alternatively, you may
consider porting one feature at a time to Dart and using the
[JavaScript interoperability library][jsinterop] as the common middle
ground. Be sure to watch [Dart-JavaScript
interoperability,](https://www.youtube.com/watch?v=aIonwL-8hdE)
a talk from Dart Developer Summit 2016.

---

## JavaScript compilation

### Q. Will any valid Dart code compile to JavaScript, or are there limitations?

We intend for any valid Dart code to compile to JavaScript.  Of course,
there are some libraries that will only run on the server because they
don't make sense in a browser context. For example, the `dart:io` library
provides access to operating system files and directories with APIs not
available to the browser.

### Q. Why does Dart have two compilers, dartdevc and dart2js?

The two compilers have different use cases. You don't usually have to worry
about which compiler you're using, because the [webdev][] tool
chooses the right compiler for your use case. When you're developing your app,
webdev chooses [dartdevc][], which supports incremental compilation so
you can quickly see the results of your edits.
When you're building your app for deployment, webdev chooses [dart2js][],
which uses techniques such as tree shaking to produce optimized code.

### Q. How can dart2js produce JavaScript that runs faster than handwritten JavaScript?

Think of dart2js as a real compiler,
which can analyze your entire program and make optimizations
that you probably can't or won't do. Just like gcc can output efficient code
by moving code around, dart2js can take advantage of Dart's structured nature
to implement global optimizations.

We don't claim that all Dart code will run faster
than handwritten JavaScript, when compiled to JavaScript,
but we're working to make the common cases fast.

### Q. How can I write Dart code that compiles to performant JavaScript?

See [Helping dart2js generate better
code](/tools/dart2js#helping-dart2js-generate-efficient-code).
Just be aware that this information might change as the implementation of
dart2js changes.

### Q. Why is the code for "Hello, World" so big, compared to the original Dart code after compilation to JavaScript?

We believe that it's important to create small and efficient JavaScript
from Dart, but most developers don't write "Hello, World" apps. It's all
relative, and with tree shaking (dead code elimination), minification, and
compression, Dart apps can be compiled to JavaScript fairly efficiently.

Kevin Moore [saw improvements][ppwsize] in the size of the generated
JavaScript from his real-world HTML5 game.

The dart2js team strives to generate smaller output, but is more focused on
real-world apps instead of trivial examples.

### Q. How are floating point numbers handled when compiled to JavaScript?

JavaScript has only one number representation: an IEEE-754 double-precision
floating-point number. This means that any number&mdash;integer or floating
point&mdash;is represented as a double. JavaScript has typed data arrays,
and the mapping from native Dart typed lists to JavaScript typed arrays is trivial.

### Q. How are integers handled when compiled to JavaScript?

Because all numbers are stored as doubles,
integers are restricted to a 53-bit precision.
Integer values in the range of -2<sup>53</sup> to 2<sup>53</sup> can be stored
without loss of accuracy.
Because JavaScript VMs play tricks
with the internal representation of numbers
(similar to those described above),
staying within smi range is still good practice.

### Q. How are typed lists handled when compiled to JavaScript?

JavaScript offers typed arrays
that are compatible with Dart’s typed lists.
The mapping is trivial—for example,
Float32List becomes a Float32Array.
The one exception today is that dart2js does not support 64-bit integers
and thus does not support Int64List or Uint64List.
Dart code compiled via dart2js results in a runtime exception
if either of those lists is used.

---

## Historical

### Q. Why Dart?

At Google we've written our share of web apps, and we've tried in many ways to
make improvements to that development process, short of introducing a new
language.  Now we think it's time to take that leap.  We designed Dart to be
easy to write development tools for, well-suited to modern app development, and
capable of high-performance implementations.

### Q. Is the language what really needs to be fixed in web development?

We want to [fix ALL the things][fixallthethings].  There's "Dart" the language,
and then there's "Dart" the overall project.  The Dart _project_ is
betting that the language needs some changes, but we also want to
improve the DOM and other libraries, and to improve the tools we use.

At the same time, Google is also placing bets that JavaScript _can_ be
evolved as needed, and contributing to that work.  Google wants web development
to be great, and if that happens with JavaScript, we're happy.

### Q. Is Dart going to divert community effort from JavaScript-based web development?

If people like Dart and use it, then to a certain extent, yes, but isn't this
true of any improvement to existing web development?  Nothing is zero-effort to
learn or 100% back-compatible to legacy browsers, so people use both new and
old.  You might look at it this way: Google is putting significant effort behind
both Dart and JavaScript, choosing to develop Dart while at the same time using
JavaScript extensively, and working on JavaScript tools, implementation, and
language spec.  We're doing both because we think Dart is worth it.

Server-side web programming finds room for many languages: does Python divert
effort from Perl, and does Java undercut C++?  Again, to a certain extent, yes
they do, but people generally consider that a healthy situation, better than if
we all used a single programming language.  Multiple languages have allowed for
faster change than any single language has achieved through a standards process.
Furthermore, languages coexist in different niches: does Groovy really compete
directly with C++?  People face different engineering tradeoffs and choose
different languages to meet them.  Ultimately, we think client-side developers
should have this kind of flexibility.

### Q. Will the Dart VM get into Chrome?

[No.](http://news.dartlang.org/2015/03/dart-for-entire-web.html)
Dart is designed to compile to JavaScript to run across the modern web.

### Q. Why not compile Dart to asm.js instead of JavaScript?

Asm.js is a very restricted subset of JavaScript best suited as a compilation
target for C compilers. It does not include JavaScript objects or direct
access to the DOM. Essentially, it allows only arithmetic operations and
manipulations on typed arrays.

While it is possible to implement the features that Dart requires,
they would incur a large overhead in both speed and size, compared to
relying on the already existing features provided by the underlying
JavaScript engine.
For example, any JavaScript machine comes with a garbage collector;
implementing another one in asm.js would increase the output size, and be
noticeably slower than the well-tuned garbage collectors of
modern JavaScript VMs.


[ppwsize]: http://work.j832.com/2012/11/excited-to-see-dart2js-minified-output.html
[sourcemaps]: http://www.html5rocks.com/en/tutorials/developertools/sourcemaps/
[jsinterop]: https://pub.dartlang.org/packages/js
[AngularDart]: /angular
[Polymer Dart]: https://github.com/dart-archive/polymer-dart/wiki
[dart2js]: /tools/dart2js
[dartanalyzer]: https://github.com/dart-lang/sdk/tree/master/pkg/analyzer_cli#dartanalyzer
[dartdevc]: /tools/dartdevc
[chrome.dart]: https://github.com/dart-gde/chrome.dart
[fixallthethings]: http://hyperboleandahalf.blogspot.com/2010/06/this-is-why-ill-never-be-adult.html
[Flutter Live]: https://developers.google.com/events/flutter-live/
[Hummingbird]: https://medium.com/flutter-io/hummingbird-building-flutter-for-the-web-e687c2a023a8
[typescript]: http://news.dartlang.org/2012/10/the-dart-team-welcomes-typescript.html
[webdev]: /tools/webdev
