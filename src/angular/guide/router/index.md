---
title: Routing Overview
description: Overview of core router features
sideNavGroup: advanced
prevpage:
  title: Pipes
  url: /angular/guide/pipes
nextpage:
  title: Routing Basics
  url: /angular/guide/router/1
---
{%- assign pageUrl = page.url | regex_replace: '/index$|/index.html$|/$' -%}

<?code-excerpt path-base="examples/ng/doc/router"?>
<?code-excerpt replace="/_\d((\.template)?\.dart)/$1/g"?>

<div class="alert alert-success" markdown="1">
  This is a **DRAFT** of the router pages, which are still being actively updated.
  Most of the content is accurate, but the sample is still being reworked and enhanced.
  [Feedback][] is welcome.
</div>

[Feedback]: {{site.repo.this}}/issues/new?title='{{page.title}}' page issue&body=From URL: {{site.url}}{{page.url}}

The Angular **router** enables navigation from one [view](/angular/glossary#view) to the next
as users perform app tasks.

This guide covers the router's primary features, illustrating them through the evolution
of a small app that you can {% example_ref text="run live" %}.

## Overview

The browser is a familiar model of app navigation:

- Enter a URL in the address bar and the browser navigates to a corresponding page.
- Click links on the page and the browser navigates to a new page.
- Click the browser's back and forward buttons and the browser navigates
  backward and forward through the history of pages you've seen.

The Angular router borrows from this model.
It can interpret a browser URL as an instruction to navigate to a client-generated view.
It can pass optional parameters along to the supporting view component that help it decide what specific content to present.
You can bind the router to links on a page and it will navigate to
the appropriate app view when the user clicks a link.
You can navigate imperatively when the user clicks a button, selects from a drop box,
or in response to some other stimulus from any source. And the router logs activity
in the browser's history journal so the back and forward buttons work as well.

{% comment %}
//- Skip this for now; might drop it altogether anyways
You'll learn many router details in this guide which covers

* Setting the [base href](#base-href)
* Importing from the [router library](#import)
* [Configuring the router](#route-config)
* Handling unmatched URLs with a [wildcard route](#wildcard-route)
* The [link parameters list](#link-parameters-list) that propels router navigation
* Setting the [default route](#default-route) where the app navigates at launch
* [Redirecting](#redirect) from one route to another
* Navigating when the user clicks a data-bound [RouterLink](#router-link)
* Navigating under [program control](#navigate)
* Retrieving information from the [route](#activated-route)
* [Animating](#route-animation) transitions for route components
* Navigating [relative](#relative-navigation) to the current URL
* Toggling css classes for the [active router link](#router-link-active)
* Embedding critical information in the URL with [route parameters](#route-parameters)
* Creating a [child router](#child-router) with its own routes
* Setting a [default route](#default)
* Confirming or canceling navigation with [router lifecycle hooks](#lifecycle-hooks)
* Providing optional information across routes with [query parameters](#query-parameters)
* Choosing the "HTML5" or "hash" [URL style](#browser-url-styles)

[After the Embedding entry above, the TS page has the following list]
* Providing non-critical information in [optional route parameters](#optional-route-parameters)
* Refactoring routing into a [routing module](#routing-module)
* Add [child routes](#child-routing-component) under a feature section
* [Grouping child routes](#component-less-route) without a component
* Displaying [multiple routes](#named-outlets) in separate outlets
* Confirming or canceling navigation with [guards](#guards)
  * [CanActivate](#can-activate-guard) to prevent navigation to a route
  * [CanActivateChild](#can-activate-child-guard) to prevent navigation to a child route
  * [CanDeactivate](#can-deactivate) to prevent navigation away from the current route
  * [Resolve](#resolve-guard) to pre-fetch data before activating a route
  * [CanLoad](#can-load-guard) to prevent asynchronous routing
* Providing optional information across routes with [query parameters](#query-parameters)
* Jumping to anchor elements using a [fragment](#fragment)
* Loading feature areas [asynchronously](#asynchronous-routing)
* Preloading feature areas [during navigation](#preloading)
* Using a [custom strategy](#custom-preloading) to only preload certain features
* Choosing the "HTML5" or "hash" [URL style](#browser-url-styles)
{% endcomment %}

## Setup overview

### Add angular_router

Router functionality is in the [angular_router][] library,
which comes in [its own package.][angular_router@pub]
Add the package to the pubspec dependencies:

<?code-excerpt "pubspec.yaml (dependencies)" region="dependencies-wo-forms" replace="/angular_.+/[!$&!]/g" title?>
```
  dependencies:
    angular: ^5.2.0
    # ···
    [!angular_router: ^2.0.0-alpha+21!]
```

In any Dart file that makes use of router features, import the router library:

<?code-excerpt "lib/app_component_1.dart (angular_router)"?>
```
  import 'package:angular_router/angular_router.dart';
```

### Register providers and list directives

If you're already familiar with Angular routing,
here's a reminder of what you need to do:

- Choose a [location strategy]({{pageUrl}}/1#which-location-strategy-to-use).
- [Register appropriate router providers][router providers] when launching your app.
- Ensure that each routing component has metadata listing the
  [router directives]({{pageUrl}}/1#router-directives) used by the component.

[router providers]: {{pageUrl}}/1#add-router-providers

## Basic feature overview

This guide proceeds in phases, marked by milestones, starting from a skeletal app
and building toward a modular, multi-view design with child routes.
This overview of core router concepts will help orient you to the details that follow.

### \<base href>

Most routing apps have a `<base href="...">` element in the `index.html` `<head>`
to tell the router how to compose navigation URLs.
For details, see [Set the *base href*]({{pageUrl}}/1#base-href).

### Routes

[Routes]({{pageUrl}}/1#routes) tell the router which views to display when a user
clicks a link or pastes a URL into the browser address bar. To configure routes
you'll need to do the following:

<?code-excerpt path-base="examples/ng/doc/toh-5"?>

<ul><li markdown="1">
Define [route paths]({{pageUrl}}/1#route-paths):

<?code-excerpt "lib/src/route_paths.dart" region="v1" plaster="none" title?>
```
  import 'package:angular_router/angular_router.dart';

  class RoutePaths {
    static final heroes = RoutePath(path: 'heroes');
  }
```
</li><li markdown="1">
Define [route definitions]({{pageUrl}}/1#route-definitions):

<?code-excerpt "lib/src/routes.dart (a first route)" plaster="none" title?>
```
  import 'package:angular_router/angular_router.dart';

  import 'route_paths.dart';
  import 'hero_list_component.template.dart' as hero_list_template;

  export 'route_paths.dart';

  class Routes {
    static final heroes = RouteDefinition(
      routePath: RoutePaths.heroes,
      component: hero_list_template.HeroListComponentNgFactory,
    );

    static final all = <RouteDefinition>[
      heroes,
    ];
  }
```
</li><li markdown="1">
Bind the route definitions to a _router outlet_, as illustrated next.
</li></ul>

### Router outlet

When you visit
[localhost:8080/#/heroes](http://localhost:8080/#/heroes){:.no-automatic-external},
the router matches the URL with the heroes route path, and displays a
`HeroListComponent` immediately below the `<router-outlet>` in the routing
component template:

<?code-excerpt "lib/app_component.dart (routes and template)" plaster="none" remove="/Hero|nav|routerLink|title/" replace="/(\s+)(.router-outlet.*)/$1...$1[!$2!]/g" title?>
```
  import 'src/routes.dart';

  @Component(
    template: '''
      ...
      [!<router-outlet [routes]="Routes.all"></router-outlet>!]
    ''',
    directives: [routerDirectives],
    exports: [RoutePaths, Routes],
  )
  class AppComponent {
  }
```

For details, see [RouterOutlet]({{pageUrl}}/1#routeroutlet).

<?code-excerpt path-base="examples/ng/doc/router"?>

### Router links

A [RouterLink][] directive on an anchor tag gives the router control over the anchor.
Bind each `RouterLink` directive to a template expression that evaluates to a URL.

<?code-excerpt "lib/app_component_1.dart (template and styles)" region="template" replace="/\[routerLink(Active)?\]/[!$&!]/g" title?>
```
  template: '''
    <h1>Angular Router</h1>
    <nav>
      <a [![routerLink]!]="RoutePaths.crises.toUrl()"
         [![routerLinkActive]!]="'active-route'">Crisis Center</a>
      <a [![routerLink]!]="RoutePaths.heroes.toUrl()"
         [![routerLinkActive]!]="'active-route'">Heroes</a>
    </nav>
    <router-outlet [routes]="Routes.all"></router-outlet>
  ''',
  styles: ['.active-route {color: #039be5}'],
```

A [RouterLinkActive][] will apply the named CSS class to the anchor whose link
is active. This helps visually distinguish the active links.

For details, see [RouterLinks]({{pageUrl}}/1#router-link).

## Summary

Here are the key router terms and their meanings.

{:.table .table-striped}
| **Router Part** | **Meaning** |
| [Router][] | Displays the app component for the active URL. Manages navigation from one component to the next. |
| Routing component | An Angular component with a `<router-outlet>` that displays views based on router navigations. |
| Route | A kind of `RouteDefinition`. Defines how the router should navigate to a component based on a URL pattern. Most routes consist of a path, a route name, and a component type. |
| [RouteDefinition][] | Defines how the router should navigate to a component based on a URL pattern. |
| [RouterOutlet][] | The directive (`<router-outlet>`) that marks where the router should display a views. |
| [RouterLink][] | The directive for binding a clickable HTML element to a route. Clicking an element with a `routerLink` directive triggers a navigation. |

## What next?

The rest of this guide describes the development of a {% example_ref
text="multi-page routed app" %} through a sequence of milestones. Each milestone
highlights specific design decisions and introduces new key features of the
router.

[angular_forms]: https://pub.dartlang.org/packages/angular_forms
[angular_router]: /api/angular_router/angular_router/angular_router-library
[angular_router@pub]: https://pub.dartlang.org/packages/angular_router
[RouteDefinition]: /api/angular_router/angular_router/RouteDefinition-class
[Router]: /api/angular_router/angular_router/Router-class
[RouterLink]: /api/angular_router/angular_router/RouterLink-class
[RouterLinkActive]: /api/angular_router/angular_router/RouterLinkActive-class
[RouterOutlet]: /api/angular_router/angular_router/RouterOutlet-class
[RoutePath]: /api/angular_router/angular_router/RoutePath-class
