---
layout: default
permalink: /faq
title: "FAQ"
description: "FAQ and other tips for using Dart for web development."
---

This FAQ applies to web programming. For more general Dart questions,
see the [FAQ]({{site.dartlang}}/faq), or the [Tools FAQ]({{site.dartlang}}/tools/faq),
both on dartlang.

## General

#### Q. What browsers do you support as JavaScript compilation targets?

We support the following browsers:

  * Internet Explorer, versions 10 and 11
    * Dart v1.5 was the last release to support Internet Explorer 9.
  * Firefox, latest version
  * Chrome, latest version
  * Safari for desktop, latest version
  * Safari for mobile, latest version

{% comment %}
[TODO: check version #s every time we update this file]
{% endcomment %}

#### Q. Is Dart supported by my browser?

Although no production browsers can execute Dart code directly,
all modern browsers can execute Dart code that's been compiled to JavaScript.
For convenience while you're developing Dart code,
you can use a version of Chromium (nicknamed [Dartium])
has the Dart VM integrated into it.

#### Q. How do I debug an app once it has been compiled to JavaScript?

Dart web apps are easiest to debug with an IDE, like WebStorm,
and Dartium. However,
the [debugging](/tools/dart2js#debugging)
section of the dart2js documentation
has some tips for specific browsers.

#### Q. Can I use Angular with Dart?

Yes! [Angular 2 for Dart][] is a port of Angular to Dart.

#### Q. Can I use web components with Dart?

Yes! [Polymer Dart] is a port of polymer to Dart. Polymer is a set of
polyfills and usability enhancements for web components.

#### Q. Should I use Angular or Polymer?

Both. Or either. It's really up to you.

#### Q. Can I build a Chrome App with Dart?

You can use the [chrome.dart] libraries,
but you still need to compile to JavaScript.
But otherwise, yes, you can build a Chrome App with Dart.

---

## JavaScript and other web technologies

#### Does Google want to replace JavaScript with Dart?

We believe developers should have a choice when they build for the web.
Adding a new option, such as Dart, does not imply replacing an existing
option.

#### Q. Isn't Dart a lot like JavaScript?

Yes and no.  The Dart project thinks that JavaScript can use some changes for
more productive software engineering, smarter editors and development
environments, and web apps that are as beautiful and pleasing as the best client
apps can be.  On the other hand, we don't think everything needs to change, and
why change what isn't broken?

Dart, like JavaScript, is a dynamically typed language.  It adds optional
type annotations to help you catch errors earlier.  It takes out a
few features of JavaScript, such as prototypes and the global object: this
streamlines the VM, enables faster execution, and makes it easier to do code
completion and refactoring.  And Dart adds some goodies.  To name a few:

* User-defined operator methods.  We like the lightweight, readable code
these give for
<a href="/articles/low-level-html/improving-the-dom">our DOM interface</a>.

* Lightweight syntax for anonymous functions.  You use them a lot in
web programming; now they look great.  And they come with correct
binding of <code>this</code> and full block-level lexical scoping, no gotchas.

Dart is more than a new syntax, it's a full language with its own semantics.
Dart differs from JavaScript in many ways, including:

* Only `true` is true.
* No `undefined`, only `null`.
* No automatic type coercion with `==`, `+`, and other operators.

When compared to JavaScript, Dart aims to be faster, more regular, and more
scalable to large programs.

#### Q. How does Dart code interoperate with JavaScript libraries?

Although Dart and JavaScript are completely separate languages with
separate VMs, they can interoperate. For more information, see
[package:js](https://pub.dartlang.org/packages/js) and
the [chartjs](https://github.com/google/chartjs.dart/) example.

#### Q. I have a large JavaScript codebase. How can I migrate it to Dart?

Try migrating one major feature at a time, and use the
[JavaScript interoperability library][jsinterop]
only when necessary.

#### Q. How does Dart compare with using the Closure compiler on JavaScript?

The idea of optional type annotations is similar.  Dart's are nicer
syntactically.

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

#### Q. How does Dart compare with CoffeeScript?

Both Dart and CoffeeScript are inspired by JavaScript, and both can be
translated back to it.  They make different choices, particularly in the flavor
of their syntax.  As a language we think it's fair to say that Dart differs
semantically from JavaScript more than CoffeeScript does; that may result in a
less line-for-line translation, but we believe Dart-generated JavaScript can
have excellent size and speed.

Dart introduces new semantics, while CoffeeScript retains the semantics
of JavaScript.

If you like CoffeeScript for its more structured feel than raw JavaScript, you
may like Dart's optional static type annotations.

#### Q. What does Google think of TypeScript?

TypeScript and Dart have similar goals; they make building large-scale web
applications easier. However, their approaches are fairly different. TypeScript
maintains backwards compatability with JavaScript, whereas Dart purposely made a
break from certain parts of JavaScript’s syntax and semantics in order to
eradicate large classes of bugs and to improve performance. The web has suffered
from too little choice for too long, and we think that both Dart and TypeScript
are pointing to a brighter future for web developers. You can read a
[more complete response][typescript] on our blog.

#### Q. I have a large application written in GWT. How do I port it to Dart?

Java and Dart are syntactically similar, so this might be easier than you think.
You can rely on the [Dart analyzer][dartanalyzer]
to flag any syntax problems. Alternatively, you may
consider porting one feature at a time to Dart and using the
[JavaScript interoperability library][jsinterop] as the common middle
ground. Be sure to watch our Google I/O 2012 talk <a
href="http://www.youtube.com/watch?v=EvACKPBo_R8">Migrating Code from GWT to
Dart</a>, but keep in mind that it predates our JavaScript interoperability
library.

---

## JavaScript compilation

#### Q. Will any valid Dart code compile to JavaScript, or are there limitations?

We intend for any valid Dart code to compile to JavaScript.  Of course, there
are some libraries that will only run on the server because they
don't make sense in a browser context. For example, the `dart:io` library
provides access to operating system files and directories with APIs not
available to the browser.

#### Q. How can dart2js produce JavaScript that runs faster than handwritten JavaScript?

Think of dart2js as a real compiler,
which can analyze your entire program and make optimizations
that you probably can't or won't do. Just like gcc can output efficient code
by moving code around, dart2js can take advantage of Dart's structured nature
to implement global optimizations.

We don't claim that all Dart code will run faster
than handwritten JavaScript, when compiled to JavaScript,
but we're working to make the common cases fast.

#### Q. How can I write Dart code that compiles to performant JavaScript?

See [Helping dart2js generate better
code](/tools/dart2js#helping-dart2js-generate-efficient-code).
Just be aware that this information might change as the implementation of
dart2js changes.

#### Q. Why is the code for "Hello, World" so big, compared to the original Dart code after compilation to JavaScript?

We believe that it's important to create small and efficient JavaScript
from Dart, but most developers don't write "Hello, World" apps. It's all
relative, and with tree shaking (dead code elimination), minification, and
compression, Dart apps can be compiled to JavaScript fairly efficiently.

Kevin Moore [saw improvements][ppwsize] in the size of the generated
JavaScript from his real-world HTML5 game.

The dart2js team strives to generate smaller output, but is more focused on
real-world apps instead of trivial examples.

#### Q. How are floating point numbers handled when compiled to JavaScript?

JavaScript has only one number representation: an IEEE-754 double-precision
floating-point number. This means that any number&mdash;integer or floating
point&mdash;is represented as a double. JavaScript has typed data arrays,
and the mapping from native Dart typed lists to JavaScript typed arrays is trivial.

#### Q. How are integers handled when compiled to JavaScript?

Because all numbers are stored as doubles,
integers are restricted to a 53-bit precision.
Integer values in the range of -2<sup>53</sup> to 2<sup>53</sup> can be stored
without loss of accuracy.
Because JavaScript VMs play tricks
with the internal representation of numbers
(similar to those described above),
staying within smi range is still good practice.

#### Q. How are typed lists handled when compiled to JavaScript?

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

#### Q. Why Dart?

At Google we've written our share of web apps, and we've tried in many ways to
make improvements to that development process, short of introducing a new
language.  Now we think it's time to take that leap.  We designed Dart to be
easy to write development tools for, well-suited to modern app development, and
capable of high-performance implementations.

#### Q. Is the language what really needs to be fixed in web development?

We want to [fix ALL the things][fixallthethings].  There's "Dart" the language,
and then there's "Dart" the overall project.  The Dart _project_ is
betting that the language needs some changes, but we also want to
[improve the DOM][improvethedom] and other libraries, and
to improve the tools we use.

At the same time, Google is also placing bets that JavaScript _can_ be
evolved as needed, and contributing to that work.  Google wants web development
to be great, and if that happens with JavaScript, we're happy.

#### Q. Is Dart going to divert community effort from JavaScript-based web development?

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

#### Q. Will the Dart VM get into Chrome?

[No.](http://news.dartlang.org/2015/03/dart-for-entire-web.html)
Dart is designed to compile to JavaScript to run across the modern web, and the
dart2js compiler is a top priority for the team.

#### Q. Why doesn't Dart support IE9 or earlier?

Supporting legacy browsers takes a lot of engineering resources and testing infrastructure.
Dart is a bet for the future, and the project can't push forward if it needs to
spend valuable resources on supporting browsers that are dying or dead.
Also, dart2js can emit efficient code if it assumes a modern browser with
ECMAScript5 or greater features.

#### Q. Why not compile Dart to asm.js instead of building a specialized VM?

Dart could have used asm.js in two ways; compiling Dart applications to asm.js,
or compile the Dart VM to asm.js.

However, after careful consideration it becomes clear that both ways incur non-
acceptable overhead which nullifies some of Dart’s value proposition: its fast
start-up and better performance.

**Compilation of a Dart application to asm.js**

Asm.js is a very restricted subset of JavaScript best suited as a compilation
target for C compilers. It does not include JavaScript objects, or direct
access to the DOM. Essentially, it only allows arithmetic operations and
manipulations on typed arrays.

While it is possible to implement the dynamic features that are required by
Dart, they would incur a large overhead in both speed and size, compared to
relying on the already existing features provided by the underlying JS engine.
For example, any JS machine comes with a garbage collector (henceforth GC), and
implementing another one in asm.js would increase the output size, and be
noticeably slower than the well-tuned GCs of modern JS VMs.

Similarly, JS VMs have spent significant effort in making dynamic dispatch
efficient, using a combination of dynamic code generation and self-modifying
code.

**Compilation of the Dart VM to asm.js (for example via emscripten)**

Arguments in the preceding section also apply here. A Dart VM in asm.js would
need to reimplement, on top of asm.js, many facilities that are already provided
by the JS VMs. Furthermore, asm.js doesn’t allow direct access to all machine
capabilities, like threading and specialized instruction sets.

Shipping the Dart VM (compiled to asm.js) with every program would also add
significant download size to every Dart program. Even cached, it would still
take a long time to compile the Dart VM (as asm.js) program on the client,
yielding significant start-up times.

Furthermore you would have to rewrite the Dart VM backend to generate asm.js
code, as the Dart VM relies on dynamic code generation to achieve peak
performance. (In an additional step, the JS VM would then need to compile that
code into assembly, adding to the latency.)

The generated code would be restricted to the instruction set that is provided
by asm.js, whereas a native VM can emit specialized instructions for the
platform.

That said, it would be amazing to see the Dart VM compiled to asm.js. This
experiment would have little practical value, but it would be a nice
achievement.

[ppwsize]: http://work.j832.com/2012/11/excited-to-see-dart2js-minified-output.html
[sourcemaps]: http://www.html5rocks.com/en/tutorials/developertools/sourcemaps/
[jsinterop]: https://pub.dartlang.org/packages/js
[Angular 2 for Dart]: https://angulardart.org
[Polymer Dart]: https://github.com/dart-lang/polymer-dart/wiki
[dartanalyzer]: https://github.com/dart-lang/analyzer_cli#dartanalyzer
[chrome.dart]: https://github.com/dart-gde/chrome.dart
[fixallthethings]: http://hyperboleandahalf.blogspot.com/2010/06/this-is-why-ill-never-be-adult.html
[improvethedom]: /articles/low-level-html/improving-the-dom
[typescript]: http://news.dartlang.org/2012/10/the-dart-team-welcomes-typescript.html
[Dartium]: /tools/dartium


