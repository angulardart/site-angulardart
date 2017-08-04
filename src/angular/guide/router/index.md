---
layout: angular
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
<!-- FilePath: src/angular/guide/router/index.md -->
<?code-excerpt path-base="router"?>

<div class="alert alert-success" markdown="1">
  This is a **DRAFT** of the router pages, which are still being actively updated.
  Most of the content is accurate, but the sample is still being reworked and enhanced.
  [Feedback](https://github.com/dart-lang/site-webdev/issues/new) is welcome.
</div>

The Angular **router** enables navigation from one [view](/angular/glossary.html#view) to the next
as users perform application tasks.

This guide covers the router's primary features, illustrating them through the evolution
of a small application that you can <live-example>run live</live-example>.

## Overview

The browser is a familiar model of application navigation:

- Enter a URL in the address bar and the browser navigates to a corresponding page.
- Click links on the page and the browser navigates to a new page.
- Click the browser's back and forward buttons and the browser navigates
  backward and forward through the history of pages you've seen.

The Angular router borrows from this model.
It can interpret a browser URL as an instruction to navigate to a client-generated view.
It can pass optional parameters along to the supporting view component that help it decide what specific content to present.
You can bind the router to links on a page and it will navigate to
the appropriate application view when the user clicks a link.
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
* Setting the [default route](#default-route) where the application navigates at launch
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
  * [CanDeactivate](#can-deactivate-guard) to prevent navigation away from the current route
  * [Resolve](#resolve-guard) to pre-fetch data before activating a route
  * [CanLoad](#can-load-guard) to prevent asynchronous routing
* Providing optional information across routes with [query parameters](#query-parameters)
* Jumping to anchor elements using a [fragment](#fragment)
* Loading feature areas [asynchronously](#asynchronous-routing)
* Preloading feature areas [during navigation](#preloading)
* Using a [custom strategy](#custom-preloading) to only preload certain features
* Choosing the "HTML5" or "hash" [URL style](#browser-url-styles)
{% endcomment %}

## Basic feature overview

This guide proceeds in phases, marked by milestones, starting from a simple two-pager
and building toward a modular, multi-view design with child routes.
This overview of core router concepts will help orient you to the details that follow.

### *&lt;base href>*

Most routing applications have a `<base href="...">` element in the `index.html` `<head>`
to tell the router how to compose navigation URLs.
For details, see [Set the *base href*](router/1#base-href).

### Router import

The Angular router is not part of the Angular core.
It is an optional service packaged within its own library, `angular2.router`.
Import it like any other package.

<?code-excerpt "lib/app_component_1.dart (import)"?>
```
  import 'package:angular2/router.dart';
```

### Configuration

When the browser's URL changes, the router looks for a corresponding **`RouteDefinition`**
from which it can determine the component to display.

A router has no routes until you configure it.
The following example creates some route definitions. It illustrates
the preferred way of simultaneously creating a router and
adding its routes using a **`@RouteConfig`**
applied to the router's host component:

<?code-excerpt "lib/app_component_1.dart (routes)" region="app-component-routes" title?>
```
  @Component(
    selector: 'my-app',
    /* . . . */
  )
  @RouteConfig(const [
    const Route(
        path: '/crisis-center',
        name: 'CrisisCenter',
        component: CrisisCenterComponent),
    const Route(path: '/heroes', name: 'Heroes', component: HeroesComponent)
  ])
  class AppComponent {}
```

There are several flavors of `RouteDefinition`.
The most common, illustrated above, is a named **`Route`** which maps a URL path to a component.

### Router outlet

When the browser URL for this application becomes `/heroes`,
the router matches that URL to the `RouteDefinition` named `Heroes` and displays the `HeroesComponent`
_after_ a `RouterOutlet` that you've placed in the host view's HTML.

<?code-excerpt?>
```html
  <router-outlet></router-outlet>
  <!-- Routed views go here -->
```

### Router links

Now you have routes configured and a place to render them, but
how do you navigate? The URL could arrive directly from the browser address bar.
But most of the time you navigate as a result of some user action such as the click of
an anchor tag.

Consider the following template:

<?code-excerpt "lib/app_component_1.dart (template and styles)" region="template" title?>
```
  template: '''
    <h1>Angular Router</h1>
    <nav>
      <a [routerLink]="['CrisisCenter']">Crisis Center</a>
      <a [routerLink]="['Heroes']">Heroes</a>
    </nav>
    <router-outlet></router-outlet>
  ''',
  styles: const ['.router-link-active {color: #039be5;}'],
```

The `RouterLink` directives on the anchor tags give the router control over those elements.
You bind each `RouterLink` directive to a template expression that
returns the route link parameters as a [link parameters list](router/appendices#link-parameters-list).
The router resolves each link parameters list into a complete URL.

{% comment %}
//- TODO: `RouterLinkActive` is forthcoming in the new router. Once it is available, we'll be
//- able to make use of the a.active style in the global styles file.
 The **`RouterLinkActive`** directive on each anchor tag helps visually distinguish the anchor for the currently selected _active_ route.
{% endcomment %}

The `RouterLink` directive also helps visually distinguish the anchor for the currently selected _active_ route.
The router adds the `router-link-active` CSS class to the element when the associated router link becomes active.
As illustrated above, you can define this style alongside the template in the `@Component` annotation
of the `AppComponent`.

### Summary

The application has a configured router.
The shell component has a `RouterOutlet` where it can display views produced by the router.
It has `RouterLink`s that users can click to navigate via the router.

Here are the key router terms and their meanings:

<style>td,th {vertical-align: top}</style>
<table>
<tr>
  <th>Router Part</th>
  <th>Meaning</th>
</tr>
<tr>
  <td><code>Router</code></td>
  <td>
    Displays the application component for the active URL.
    Manages navigation from one component to the next.
  </td>
</tr>
<tr>
  <td><code>@RouteConfig</code></td>
  <td>
    Configures a router with a <code>RouteDefinition</code> list.
  </td>
</tr>
<tr>
  <td><code>RouteDefinition</code></td>
  <td>
    Defines how the router should navigate to a component based on a URL pattern.
  </td>
</tr>
<tr>
  <td><code>Route</code></td>
  <td>
    A kind of <code>RouteDefinition</code>.
    Defines how the router should navigate to a component based on a URL pattern.
    Most routes consist of a path, a route name, and a component type.
  </td>
</tr>
<tr>
  <td><code>RouterOutlet</code></td>
  <td>
    The directive (<code>&lt;router-outlet></code>) that marks where the router should display a view.
  </td>
</tr>
<tr>
  <td><code>RouterLink</code></td>
  <td>
    The directive for binding a clickable HTML element to
    a route. Clicking an element with a <code>routerLink</code> directive
    that is bound to a <i>link parameters list</i> triggers a navigation.
  </td>
</tr>
<tr>
  <td><a href="router/appendices#link-parameters-list">Link parameters list</a></td>
  <td>
    A list that the router interprets as a routing instruction.
    You can bind that list to a <code>RouterLink</code> or pass the list as an argument to
    the <code>Router.navigate</code> method.
  </td>
</tr>
<tr>
  <td>Routing component</td>
  <td>
    An Angular component with a <code>RouterOutlet</code> that
    displays views based on router navigations.
  </td>
</tr>
</table>

## The sample application

This guide describes the development of a multi-page routed sample application.
Along the way, it highlights design decisions and describes key features of the router.

{% comment %}
//- TODO: review and/or drop the list:
such as:

* organizing the application features into modules
* navigating to a component (*Heroes* link to "Heroes List")
* including a route parameter (passing the Hero `id` while routing to the "Hero Detail")
* child routes (the *Crisis Center* has its own routes)
* the `CanActivate` guard (checking route access)
* the `CanActivateChild` guard (checking child route access)
* the `CanDeactivate` guard (ask permission to discard unsaved changes)
* the `Resolve` guard (pre-fetching route data)
* lazy loading feature modules
* the `CanLoad` guard (check before loading feature module assets)
{% endcomment %}

The guide proceeds as a sequence of milestones as if you were building the app step-by-step.
But, it is not a tutorial and it glosses over details of Angular application construction
that are more thoroughly covered elsewhere in the documentation.

The full source for the final version of the app can be seen and downloaded from the <live-example></live-example>.

### The sample application in action

Imagine an application that helps the _Hero Employment Agency_ run its business.
Heroes need work and the agency finds crises for them to solve.

The application has these main features:

1. A *Crisis Center* for maintaining the list of crises for assignment to heroes.
1. A *Heroes* area for maintaining the list of heroes employed by the agency.
{% comment %}TODO: add support for Admin feature
1. An *Admin* area to manage the list of crises and heroes.
{% endcomment %}

Try it by clicking on this <live-example title="Hero Employment Agency Live Example">live example link</live-example>.
Once the app warms up, you'll see a row of navigation buttons
and the *Heroes* view with its list of heroes.

<img class="image-display" src="{% asset_path 'ng/devguide/router/hero-list-2-tab.png' %}" alt="Hero List" width="282">

Select one hero and the app takes you to a hero editing screen.

<img class="image-display" src="{% asset_path 'ng/devguide/router/hero-detail-2-tab.png' %}" alt="Crisis Center Detail" width="282">

Alter the name.
Click the "Back" button and the app returns to the heroes list which displays the changed hero name.
Notice that the name change took effect immediately.

Had you clicked the browser's back button instead of the "Back" button,
the app would have returned you to the heroes list as well.
Angular app navigation updates the browser history as normal web navigation does.

Now click the *Crisis Center* link for a list of ongoing crises.

<img class="image-display" src="{% asset_path 'ng/devguide/router/crisis-center-list-2-tab.png' %}" alt="Crisis Center List" width="282">

Select a crisis and the application takes you to a crisis editing screen.
The _Crisis Detail_ appears in a child view on the same page, beneath the list.

Alter the name of a crisis.
Notice that the corresponding name in the crisis list does _not_ change.

<img class="image-display" src="{% asset_path 'ng/devguide/router/crisis-center-detail-2-tab.png' %}" alt="Crisis Center Detail" width="282">

Unlike *Hero Detail*, which updates as you type,
*Crisis Detail* changes are temporary until you either save or discard them by pressing the "Save" or "Cancel" buttons.
Both buttons navigate back to the *Crisis Center* and its list of crises.

***Do not click either button yet***.
Click the browser back button or the "Heroes" link instead.

Up pops a dialog box.

<img class="image-display" src="{% asset_path 'ng/devguide/router/confirm-dialog.png' %}" alt="Confirm Dialog" width="282">

You can select "OK" and lose your changes or click "Cancel" and continue editing.

Behind this behavior is the router's `routerCanDeactivate` hook.
The hook gives you a chance to clean-up or ask the user's permission
before navigating away from the current view.

{% comment %}
//- Not currently supported:
The `Admin` and `Login` buttons illustrate other router capabilities to be
covered later in the guide.
{% endcomment %}
