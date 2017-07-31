---
layout: default
title: Dart Tools for the Web
description: "The tools that support web development using Dart."
permalink: /tools
---

This page lists specialized tools for developing web apps.
For information about general tools for Dart apps, see
[Dart Tools.]({{site.dartlang}}/tools)

---

<a name="tools"></a>
<h2>Dartium</h2>

Dartium is a special build of Chromium used for developing web apps.

<aside class="alert alert-info" markdown="1">
**Dartium is going away in Dart 2.0:**
In Dart 2.0, you'll use Chrome or other standard browsers for testing
instead of Dartium, thanks to a new development compiler called
[_dartdevc_](/tools/dartdevc). For information on Dartium's removal,
see [A stronger Dart for
everyone.](http://news.dartlang.org/2017/06/a-stronger-dart-for-everyone.html)
Once your code is [strong mode]({{site.www}}/guides/language/sound-dart) clean,
you can start to play with dartdevc now,
though it doesn't yet work for AngularDart apps.
</aside>

{% comment %}
update-for-dart-2
{% endcomment %}

<a href="/tools/dartium">
<img src="{% asset_path 'dartium-logo-48.jpg' %}" alt="Dart logo" /><br>
<b>Dartium</b>
</a>

---

<a name="ides"></a>
<h2>Recommended IDE</h2>

If you don't already have a favorite IDE,
we recommend WebStorm, which comes with Dart support.

<a href="/tools/webstorm">
<img src="{% asset_path 'webstorm.png' %}" alt="WebStorm logo"><br>
<b>WebStorm</b>
</a>

See [Dart Tools]({{site.dartlang}}/tools) for a list of other IDEs.

---

<a name="other-tools"></a>
<h2>Command-line tools</h2>

In addition to the [other Dart tools]({{site.dartlang}}/tools)
included in the SDK, the following tools
offer specialized support for web programming.

[dart2js](/tools/dart2js)
: The original Dart-to-JavaScript compiler, with tree shaking

[dartdevc](/tools/dartdevc)
: The Dart dev compiler, a modular Dart-to-JavaScript compiler

[pub build](/tools/pub/pub-build)
: Pub command for building a web app

[pub serve](/tools/pub/pub-serve)
: Pub command for serving a web app

