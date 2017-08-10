---
layout: angular
title: Deployment
description: Learn how to build and serve your AngularDart web app.
sideNavGroup: advanced
prevpage:
  title: Component Styles
  url: /angular/guide/component-styles
nextpage:
  title: Hierarchical Dependency Injectors
  url: /angular/guide/hierarchical-dependency-injection
---
Deploying an AngularDart web app is similar to deploying any other web app,
except that you first need to compile the app to JavaScript.
This page describes how to compile your app—with
tips for making it smaller and faster—and
points you to resources for serving the app.


## Building your app {#compiling-to-javascript}

Use `pub build` to build your app,
compiling it to JavaScript and generating all the assets
you need for deployment.
When you use the default pub settings,
you get a minified JavaScript file that's reasonably small,
thanks to the dart2js compiler's support for tree shaking.

With a little extra work, you can make your deployable app
[smaller, faster, and more reliable](#making-your-app-smaller-faster-and-more-reliable).


### Compile using pub build {#pub-build}

To create a deployable version of your app, use the `pub build` command.
By default, this command uses
[dart2js](/tools/dart2js) and the angular2 transformer to
produce the JavaScript file that implements your app.
Here's what happens when you use `pub build` with the default settings:

* The deployable files appear under your app's **build/web** directory.
* The dart2js compiler runs in **release** mode,
  producing minified JavaScript in the file `build/web/main.dart.js`.
* As long as **dart_to_js_script_rewriter** is
  the last transformer in your app's `pubspec.yaml` file
  (or next to last, if you're using the `$dart2js` transformer),
  the `build/web/index.html` file is rewritten to link to `main.dart.js`
  instead of `main.dart`.

For more information, see the documentation for
[pub build](/tools/pub/pub-build),
search for **pubspec** in the
[starter app discussion](/angular/tutorial/toh-pt0), and see the
[pubspec.yaml section](/codelabs/ng2/1-skeleton#pubspecyaml)
of the AngularDart codelab.


### Use dart2js flags to produce better JavaScript

Google's apps often use the following dart2js options:

* `--trust-type-annotations`
* `--trust-primitives`
* `--fast-startup`

**Test your apps before deploying with these options!**
If your app runs under [dart2js](/tools/dart2js) in checked mode
or under [dartdevc](/tools/dartdevc),
then we recommend using `--trust-type-annotations`.
However, `--trust-primitives` can have unexpected results
(even in well-typed code) if your data isn't always valid.
Build your app both with and without `--fast-startup`,
so you can judge whether the speedup is worth the increase in JavaScript size.

{% include checked-mode-2.0.html %}

{% comment %}
update-for-dart-2
{% endcomment %}

<aside class="alert alert-warning" markdown="1">
**Important:**
Make sure your app has good [test coverage](/angular/guide/testing)
before you use either of the `--trust-*` options.
If some code paths aren't tested,
your app might run in dartdevc but
misbehave when compiled using dart2js.
</aside>

You can specify dart2js options in your app's pubspec
using the `$dart2js` transformer,
which should be the last transformer in the pubspec file:

```
transformers:
- ...all other transformers...
- $dart2js:
    commandLineOptions: [--trust-type-annotations, --trust-primitives, --fast-startup]
```

For more information, see the dart2js
[size and speed options](/tools/dart2js#size-and-speed-options) and
the documentation on
[configuring the dart2js transformer for pub](/tools/pub/dart2js-transformer).


### Make your app smaller, faster, and more reliable {#making-your-app-smaller-faster-and-more-reliable}

The following steps are optional,
but they can help make your app more reliable and responsive.

* [Use the pwa package to make your app work offline](#use-the-pwa-package-to-make-your-app-work-offline)
* [Use deferred loading to reduce your app's initial size](#use-deferred-loading-to-reduce-initial-size)
* [Follow best practices for web apps](#follow-best-practices-for-web-apps)
* [Remove unneeded build files](#remove-unneeded-build-files)


#### Use the pwa package to make your app work offline {#use-the-pwa-package-to-make-your-app-work-offline}

The [pwa package](https://pub.dartlang.org/packages/pwa) simplifies the task of
making your app work with limited or no connectivity.
For information on using this package, see
[Making a Dart web app offline-capable: 3 lines of code.](https://medium.com/dartlang/making-a-dart-web-app-offline-capable-3-lines-of-code-e980010a7815)


#### Use deferred loading to reduce your app's initial size {#use-deferred-loading-to-reduce-initial-size}

You can use Dart's support for deferred loading to
reduce your app's initial download size, as described in
[Lazy loading with Angular Dart](https://medium.com/@matanlurey/lazy-loading-with-angular-dart-14f58004f988).

{% comment %}
**[TODO: add info about @deferred once it's in a stable release]**
{% endcomment %}


#### Follow best practices for web apps {#follow-best-practices-for-web-apps}

The usual advice for web apps applies to AngularDart web apps.
Here are a few resources:

* [Web Fundamentals](https://developers.google.com/web/fundamentals/) (especially [Optimizing Content Efficiency](https://developers.google.com/web/fundamentals/performance/optimizing-content-efficiency/))
* [Progressive Web Apps](https://developers.google.com/web/progressive-web-apps/)
* [Lighthouse](https://developers.google.com/web/tools/lighthouse/)


#### Remove unneeded build files {#remove-unneeded-build-files}

The angular2 transformer currently produces many intermediate
files (with suffixes like `.ng_meta.json` and `.ng_summary.json`)
that you don't need when deploying your app.
To remove these files, you can use a command like the following:

```shell
# From your app's top directory:
$ find build -name "*.ng_*.json" -exec rm {} +
```


## Serving your app {#serving-your-app}

You can serve your AngularDart app just like you'd serve any other web app.
This section points to tips for serving Angular apps,
as well as Dart-specific resources to help you use GitHub Pages or Firebase
to serve your app.


### Angular-specific tips {#angular-specific-tips}

For information on changes you might have to make to the server, see the
[Server configuration](https://angular.io/guide/deployment#server-configuration)
section of the Angular TypeScript deployment documentation.


### GitHub Pages {#github-pages}

If your app doesn't use routing or require server-side support,
you can serve the app using [GitHub Pages](https://pages.github.com/).
The [peanut](https://pub.dartlang.org/packages/peanut) package is
an easy way to automatically produce a gh-pages branch for any Dart web app.

The [startup_namer example](https://filiph.github.io/startup_namer/)
is hosted using GitHub Pages.
Its files are in the **gh-pages** branch of the
[filiph/startup_namer repo](https://github.com/filiph/startup_namer)
and were built using [peanut.](https://pub.dartlang.org/packages/peanut)


### Firebase {#firebase}

For a walk-through of using Firebase to serve a chat app, see
[Build a Real-Time Chat Web App with Dart, Angular 2, and Firebase 3.](http://dart.academy/build-a-real-time-chat-web-app-with-dart-angular-2-and-firebase-3/)
{% comment %}
TODO: Instead of just pointing to that very long article,
show how to deploy here.
{% endcomment %}

Other resources:

* The Google I/O 2017 codelab
  [Build an AngularDart & Firebase Web App](https://codelabs.developers.google.com/codelabs/angulardart-firebase-web-app/)
  walks through using Firebase for server-side communication,
  but doesn't include instructions for serving the app.
* The [Firebase Hosting documentation](https://firebase.google.com/docs/hosting/)
  describes how to deploy web apps with Firebase.
* In the Firebase Hosting documentation,
  [Customize Hosting Behavior](https://firebase.google.com/docs/hosting/url-redirects-rewrites)
  covers redirects, rewrites, and more.
