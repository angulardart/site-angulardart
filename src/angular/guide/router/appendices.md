---
layout: angular
title: Appendices
sideNavGroup: advanced
prevpage:
  title: Asynchronous Routing
  url: /angular/guide/router/6
nextpage:
  title: Security
  url: /angular/guide/security
---
<!-- FilePath: src/angular/guide/router/appendices.md -->
<?code-excerpt path-base="router"?>
{% include_relative _milestone-nav.md selectedOption="appendices" %}

The balance of this guide is a set of appendices that
elaborate some of the points covered quickly above.

The appendix material isn't essential. Continued reading is for the curious.

<div id="link-parameters-list"></div>
## Appendix: Link parameters list

A link parameters list holds the ingredients for router navigation:

* the *path* of the route to the destination component
* required and optional route parameters that go into the route URL

You can bind the `RouterLink` directive to such an list like this:

<?code-excerpt "lib/app_component_1.dart (Heroes-link)"?>
```
  <a [routerLink]="['Heroes']">Heroes</a>
```

You've written a two element list when specifying a route parameter to the `navigate` method:

<?code-excerpt "lib/src/heroes/heroes_component.dart (gotoDetail)"?>
```
  Future gotoDetail() => _router.navigate([
        'HeroDetail',
        {'id': selectedHero.id.toString()}
      ]);
```

{% comment %}
//- Note: as of 2.0, the TS router distinguishes between mandatory and optional route
parameters; e.g.

this.router.navigate(['/hero', hero.id]); // mandatory parameter
this.router.navigate(['/crisis-center', { foo: 'foo' }]);

Optional route parameters must be named. In Dart there is no such distinction (yet).
Hence, we comment out the following two lines:

//- :marked
You can provide optional route parameters in an object like this:
//- makeExcerpt('app/app.component.3.ts', 'cc-query-params', '')
--> <a [routerLink]="['/crisis-center', { foo: 'foo' }]">Crisis Center</a>
{% endcomment %}

These examples cover the need for an app with one level routing.
The moment you add a child router, such as the crisis center, you create new link parameters list possibilities.

Recall that you specified a default child route for crisis center so this simple `RouterLink` is fine.

<?code-excerpt "lib/app_component_1.dart (CrisisCenter-link)"?>
```
  <a [routerLink]="['CrisisCenter']">Crisis Center</a>
```

{% comment %}TODO: rework{% endcomment %}

Parse it out:

* The first item in the list identifies the parent route (`CrisisCenter`)
  whose path is `/crisis-center/...`.
* There are no parameters for this parent route so you're done with it.
* The default child route is `Crises`, which has path `/`.
* The resulting path is `/crisis-center/`.

Take it a step further. Consider the following router link that
navigates from the root of the application down to the *Dragon Crisis*:

<?code-excerpt "lib/app_component_4.dart (dragon-crisis)"?>
```
  <a [routerLink]="['CrisisCenter', 'Crises', 'CrisisDetail', {'id': '1'}]">Dragon Crisis</a>
```

* The first item in the list identifies the parent route (`CrisisCenter`)
  whose path is `/crisis-center`.
* There are no parameters for this parent route so we're done with it.
* The second item identifies the child route for details about a particular crisis ('CrisisDetail')
  whose path is `/:id`.
* The third and final item provides the `id` of the *Dragon Crisis* (`{'id': '1'}`).
* The resulting path is `/crisis-center/1`.

In summary, you can write applications with one, two or more levels of routing.
The link parameters list affords the flexibility to represent any routing depth and
any legal sequence of route names and route parameter values.

{% comment %}
//- Note(chalin): dropped this appendix. We just refer the reader to the docs on ngOnInit.
//- .l-main-section#onInit
//- :marked
//- ## Appendix: Why use an *ngOnInit* method
{% endcomment %}

<div id="browser-url-styles"></div>
<div id="location-strategy"></div>
## Appendix: *LocationStrategy* and browser URL styles

When the router navigates to a new component view, it updates the browser's location and history
with a URL for that view.
This is a strictly local URL. The browser shouldn't send this URL to the server
and should not reload the page.

Modern HTML 5 browsers support
[history.pushState](https://developer.mozilla.org/en-US/docs/Web/API/History_API#Adding_and_modifying_history_entries),
a technique that changes a browser's location and history without triggering a server page request.
The router can compose a "natural" URL that is indistinguishable from
one that would otherwise require a page load.

Here's the *Crisis Center* URL in this "HTML 5 pushState" style:

<?code-excerpt?>
```
  localhost:3002/crisis-center/
```

Older browsers send page requests to the server when the location URL changes ...
unless the change occurs after a "#" (called the "hash").
Routers can take advantage of this exception by composing in-application route
URLs with hashes.  Here's a "hash URL" that routes to the *Crisis Center*

<?code-excerpt?>
```
  localhost:3002/src/#/crisis-center/
```

The router supports both styles with two `LocationStrategy` providers:

1. `PathLocationStrategy` - the default "HTML 5 pushState" style.
1. `HashLocationStrategy` - the "hash URL" style.

The router's `ROUTER_PROVIDERS` list sets the `LocationStrategy` to the `PathLocationStrategy`,
making it the default strategy.
You can switch to the `HashLocationStrategy` with an override during the bootstrapping process if you prefer it.

<div class="l-sub-section" markdown="1">
  Learn about "providers" and the bootstrap process in the
  [Dependency Injection guide](../dependency-injection.html#bootstrap)
</div>

### Which strategy is best?

You must choose a strategy and you need to make the right call early in the project.
It won't be easy to change later once the application is in production
and there are lots of application URL references in the wild.

Almost all Angular projects should use the default HTML 5 style.
It produces URLs that are easier for users to understand.
And it preserves the option to do _server-side rendering_ later.

Rendering critical pages on the server is a technique that can greatly improve
perceived responsiveness when the app first loads.
An app that would otherwise take ten or more seconds to start
could be rendered on the server and delivered to the user's device
in less than a second.

This option is only available if application URLs look like normal web URLs
without hashes (#) in the middle.

Stick with the default unless you have a compelling reason to
resort to hash routes.

### HTML 5 URLs and the  *&lt;base href>*

While the router uses the
[HTML 5 pushState](https://developer.mozilla.org/en-US/docs/Web/API/History_API#Adding_and_modifying_history_entries)
style by default, you *must* configure that strategy with a **base href**

The preferred way to configure the strategy is to add a
[&lt;base href> element](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/base) tag
in the `<head>` of the `index.html`.

<?code-excerpt "web/index.html (base-href)"?>
```
  <script>
    // WARNING: DO NOT set the <base href> like this in production!
    // Details: https://webdev.dartlang.org/angular/guide/router
    (function () {
      // App being served out of web folder (like WebStorm does)?
      var match = document.location.pathname.match(/^\/[-\w]+\/web\//);
      var href = match ? match[0] : '/';
      document.write('<base href="' + href + '" />');
    }());
  </script>
```

Without that tag, the browser may not be able to load resources
(images, css, scripts) when "deep linking" into the app.
Bad things could happen when someone pastes an application link into the
browser's address bar or clicks such a link in an email link.

Some developers may not be able to add the `<base>` element, perhaps because they don't have
access to `<head>` or the `index.html`.

Those developers may still use HTML 5 URLs by taking two remedial steps:

1. Provide the router with an appropriate [APP_BASE_HREF][] value.
1. Use _root URLs_ for all web resources: css, images, scripts, and template html files.

[APP_BASE_HREF]: /api/angular2/angular2.platform.common/APP_BASE_HREF-constant.html
