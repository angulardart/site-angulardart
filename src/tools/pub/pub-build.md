---
layout: default
title: "pub build"
permalink: /tools/pub/pub-build
description: "Use pub build to deploy your Dart application."
---

_Build_ is one of the commands of the _pub_ tool.
[Learn more about pub](/tools/pub).

{% prettify sh %}
$ pub build [<options>] [<directories>] [--output=<directory>]
{% endprettify %}

Use `pub build` when you're ready to deploy your web app.
When you run `pub build`, it generates the
[assets]({{site.dartlang}}/tools/pub/glossary#asset)
for the current package and all of its dependencies, putting them into
new directory named `build`.

To use `pub build`, just run it in your package's root directory. For example:

{% prettify sh %}
$ cd ~/dart/helloworld
$ pub build
Building helloworld......
Built 5 files!
{% endprettify %}

If the build directory already exists, `pub build` deletes it and then creates
it again.

To generate assets, `pub build` uses
[transformers.]({{site.dartlang}}/tools/pub/glossary#transformer)
Any source assets that aren't transformed are copied,
as is, into the build directory or one of its subdirectories.
Pub also automatically compiles your
Dart application to JavaScript using dart2js
(or the specified compiler).
See [Configuring the Built-in dart2js Transformer](/tools/pub/dart2js-transformer)
for information on how to configure the dart2js options in your pubspec.

See [Pub Assets and Transformers]({{site.dartlang}}/tools/pub/assets-and-transformers)
for information on:

* Where in your package to put assets.
* What URLs to use when referring to assets.
* How to use `pubspec.yaml` to specify which transformers run, and in
  what order.

Also see [`pub serve`](/tools/pub/pub-serve). With `pub serve`, you can run a
development server that continuously generates and serves assets.

<aside class="alert alert-info" markdown="1">
**Note:** In early releases of Dart, _pub build_ was called _pub deploy_.
</aside>

## Options

For options that apply to all pub commands, see
[Global options]({{site.dartlang}}/tools/pub/cmd#global-options).

<dl>

<dt><code>&lt;directories&gt;</code></dt>
<dd>Optional. Use this option to specify directories to use
as input for the build command, in addition to <code>lib</code>
(which is always processed).  The default value is <code>web</code>.
Directories you might typically specify include the following:

<ul>
<li>benchmark</li>
<li>bin</li>
<li>example</li>
<li>test</li>
<li>web</li>
</ul>

For example, you might specify:

{% prettify sh %}
pub build test benchmark example/foo bar
{% endprettify %}

In the preceding example, the <code>test</code>, <code>benchmark</code>,
<code>example/foo</code>, and <code>bar</code> directories are processed,
as is the <code>lib</code> directory.
The <code>web</code> directory is not built because it isn't specified.</dd>


<dt><code>--all</code></dt>
<dd>Optional. Builds all of the buildable directories (benchmark, bin, example,
test, and web) that are present.</dd>


<dt><code>--mode=&lt;mode&gt;</code></dt>
<dd>Optional. Specifies a transformation mode. Typical values are "debug"
and "release", but any word is allowed.
Transformers may use this to change how they behave.<br><br>

If the mode is "release",
then pub generates minified JavaScript using dart2js (or the specified compiler).
Otherwise, pub uses dart2js (or the specified compiler)
to generate unminified JavaScript.
In release mode, pub does not
include any source <code>.dart</code> files in the build output.
In any other mode, the raw Dart files are included.<br><br>

If this option is omitted, its default value is "release".</dd>


<dt><code>--output=&lt;directory&gt;</code> or
    <code>-o &lt;directory&gt;</code></dt>
<dd>Optional. Specifies where to put the build output. The default is the
top-level <code>build</code> directory.</dd>


<dt><code>--web-compiler=&lt;compiler&gt;</code> </dt>
<dd>Optional (added in 1.24).
Specifies which Dart-to-JavaScript compiler to use.
Possible values are "<a href="/tools/dart2js">dart2js</a>",
"<a href="/tools/dartdevc">dartdevc</a>", and "none" (no generated JavaScript).
<br><br>

If this option is omitted, its default value is "dart2js".
</dd>
</dl>


<aside class="alert alert-info" markdown="1">
*Problems?*
See [Troubleshooting Pub]({{site.dartlang}}/tools/pub/troubleshoot).
</aside>

