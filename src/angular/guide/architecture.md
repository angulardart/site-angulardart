---
layout: angular
title: Architecture Overview
description: The basic building blocks of Angular applications
sideNavGroup: basic
prevpage:
  title: Learning Angular
  url: /angular/guide/learning-angular
nextpage:
  title: Displaying Data
  url: /angular/guide/displaying-data
---
<!-- FilePath: src/angular/guide/architecture.md -->
<?code-excerpt path-base="architecture"?>
<style>img.image-display {
  box-shadow: none;
  padding: 0;
  margin: 8px 0 8px 0;
}
.image-left {
  float: left;
  margin-right: 10px;
}
.guide-architecture-fix-overflow { overflow: hidden; }
</style>

AngularDart (which we usually call simply Angular in this documentation)
is a framework for building client applications in HTML and Dart.
It is published as the
[**angular2**](https://pub.dartlang.org/packages/angular2) package, which
(like many other Dart packages) is available via the Pub tool.

You write Angular applications by composing HTML *templates* with Angularized markup,
writing *component* classes to manage those templates, adding application logic in *services*,
and boxing components and services in *modules*.

Then you launch the app by *bootstrapping* the _root module_.
Angular takes over, presenting your application content in a browser and
responding to user interactions according to the instructions you've provided.

Of course, there is more to it than this.
You'll learn the details in the pages that follow. For now, focus on the big picture.

<img class="image-display" src="{% asset_path 'ng/devguide/architecture/overview2.png' %}" alt="overview" width="700">

The architecture diagram identifies the eight main building blocks of an Angular application:

* [Modules](#modules)
* [Components](#components)
* [Templates](#templates)
* [Metadata](#metadata)
* [Data binding](#data-binding)
* [Directives](#directives)
* [Services](#services)
* [Dependency injection](#dependency-injection)

Learn these building blocks, and you're on your way.

<div class="l-sub-section" markdown="1">
  The code referenced on this page is available as a <live-example></live-example>.
</div>

## Modules

<img class="image-left" src="{% asset_path 'ng/devguide/architecture/module.png' %}" alt="Modules" width="150px">

Angular apps are modular; that is, applications are assembled from many **modules**.

In this guide, the term **_module_** refers to a Dart compilation unit, such
as a library, or a package. (If a Dart file has no `library` or `part`
directive, then that file itself is a library and thus a compilation
unit.) For more information about compilation units, see
the chapter on "Libraries and Scripts" in the
[Dart Language Specification]({{site.dartlang}}/guides/language/spec).
<br class="l-clear-both">

Every Angular app has at least one module, the _root module_.
While the _root module_ may be the only module in a small application,
most apps have many more _feature modules_,
each a cohesive block of code dedicated to an application domain,
a workflow, or a closely related set of capabilities.

The simplest of root modules defines a single _root_
[**component**](#components) class such as this one:

<?code-excerpt "lib/app_component.dart (class)" title?>
```
  class AppComponent {}
```

By convention, the name of the root component is `AppComponent`.

### Angular libraries

<img class="image-left" src="{% asset_path 'ng/devguide/architecture/library-module.png' %}" alt="Libraries" width="200px">

Angular ships as a collection of libraries within the
[**angular2**](https://pub.dartlang.org/packages/angular2) package.
The main Angular library is [angular2](/api/#!?package=angular2), which most application modules import as follows:

<?code-excerpt "lib/app_component.dart (import)" class="guide-architecture-fix-overflow"?>
```
  import 'package:angular2/angular2.dart';
```

The angular2 package has other important libraries, such as
[angular2.router](/api/angular2/angular2.router/angular2.router-library) and
[angular2.security](/api/angular2/angular2.security/angular2.security-library).

<div class="l-hr"></div>

## Components

<img class="image-left" src="{% asset_path 'ng/devguide/architecture/hero-component.png' %}" alt="Component" width="200px">

<div class="guide-architecture-fix-overflow" markdown="1">
  A _component_ controls a patch of screen called a *view*.

  For example, the following views are controlled by components:

  * The app root with the navigation links.
  * The list of heroes.
  * The hero editor.
</div>

You define a component's application logic&mdash;what it does to support the view&mdash;inside a class.
The class interacts with the view through an API of properties and methods.

<a id="component-code"></a>
For example, this `HeroListComponent` has a `heroes` property that returns a list of heroes
that it acquires from a service.
`HeroListComponent` also has a `selectHero()` method that sets a `selectedHero` property when the user clicks to choose a hero from that list.

<?code-excerpt "lib/src/hero_list_component.dart (class)" title?>
```
  class HeroListComponent implements OnInit {
    List<Hero> heroes;
    Hero selectedHero;
    final HeroService _heroService;

    HeroListComponent(this._heroService);

    void ngOnInit() {
      heroes = _heroService.getHeroes();
    }

    void selectHero(Hero hero) {
      selectedHero = hero;
    }
  }
```

Angular creates, updates, and destroys components as the user moves through the application.
Your app can take action at each moment in this lifecycle through optional [lifecycle hooks](lifecycle-hooks.html), like `ngOnInit()` declared above.

<div class="l-hr"></div>

## Templates

<img class="image-left" src="{% asset_path 'ng/devguide/architecture/template.png' %}" alt="Template" width="200px">

You define a component's view with its companion **template**. A template is a form of HTML
that tells Angular how to render the component.

A template looks like regular HTML, except for a few differences. Here is a
template for our `HeroListComponent`:

<?code-excerpt "lib/src/hero_list_component.html" title?>
```
  <h2>Hero List</h2>

  <p><i>Pick a hero from the list</i></p>
  <ul>
    <li *ngFor="let hero of heroes" (click)="selectHero(hero)">
      {!{hero.name}!}
    </li>
  </ul>

  <hero-detail *ngIf="selectedHero != null" [hero]="selectedHero"></hero-detail>
```

Although this template uses typical HTML elements like `<h2>` and  `<p>`, it also has some differences. Code like `*ngFor`, `{!{hero.name}}`, `(click)`, `[hero]`, and `<hero-detail>` uses Angular's [template syntax](template-syntax.html).

In the last line of the template, the `<hero-detail>` tag is a custom element that represents a new component, `HeroDetailComponent`.

The `HeroDetailComponent` is a *different* component than the `HeroListComponent` you've been reviewing.
The `HeroDetailComponent` (code not shown) presents facts about a particular hero, the
hero that the user selects from the list presented by the `HeroListComponent`.
The `HeroDetailComponent` is a **child** of the `HeroListComponent`.

<img class="image-left" src="{% asset_path 'ng/devguide/architecture/component-tree.png' %}" alt="Metadata"  width="300px">

Notice how `<hero-detail>` rests comfortably among native HTML elements. Custom components mix seamlessly with native HTML in the same layouts.
<br class="l-clear-both">

<div class="l-hr"></div>

## Metadata

<img class="image-left" src="{% asset_path 'ng/devguide/architecture/metadata.png' %}" alt="Metadata" width="150px">

Metadata tells Angular how to process a class.<br class="l-clear-both">

[Looking back at the code](#component-code) for `HeroListComponent`, you can see that it's just a class.
There is no evidence of a framework, no "Angular" in it at all.

In fact, `HeroListComponent` really is *just a class*. It's not a component until you *tell Angular about it*.

To tell Angular that `HeroListComponent` is a component, attach **metadata** to the class.

In Dart, you attach metadata by using an **annotation**.
Here's some metadata for `HeroListComponent`:

<?code-excerpt "lib/src/hero_list_component.dart (metadata)" title?>
```
  @Component(
    selector: 'hero-list',
    templateUrl: 'hero_list_component.html',
    directives: const [COMMON_DIRECTIVES, HeroDetailComponent],
    providers: const [HeroService],
  )
  class HeroListComponent implements OnInit {
  /* . . . */
  }
```

Here is the `@Component` annotation, which identifies the class
immediately below it as a component class.

Annotations often have configuration parameters.
The `@Component` annotation takes parameters to provide the
information Angular needs to create and present the component and its view.

Here are a few of the possible `@Component` parameters:

- `selector`: CSS selector that tells Angular to create and insert an instance of this component
where it finds a `<hero-list>` tag in *parent* HTML.
For example, if an app's  HTML contains `<hero-list></hero-list>`, then
Angular inserts an instance of the `HeroListComponent` view between those tags.

- `templateUrl`: module-relative address of this component's HTML template, shown [above](#templates).

- `directives`: list of the components or directives that *this* template requires.
For Angular to process application tags, like `<hero-detail>`, that appear in a
template, the component corresponding to the tag must be declared in the
`directives` list.

- `providers`: list of **dependency injection providers** for services that the component requires.
This is one way to tell Angular that the component's constructor requires a `HeroService`
so it can get the list of heroes to display.

<img class="image-left" src="{% asset_path 'ng/devguide/architecture/template-metadata-component.png' %}" alt="Metadata" width="115px">

The metadata in the `@Component` tells Angular where to get the major building blocks you specify for the component.

The template, metadata, and component together describe a view.

Apply other metadata annotations in a similar fashion to guide Angular behavior.
`@Injectable`, `@Input`, and `@Output` are a few of the more popular annotations.
<br class="l-clear-both">

The architectural takeaway is that you must add metadata to your code
so that Angular knows what to do.

<div class="l-hr"></div>

## Data binding

Without a framework, you would be responsible for pushing data values into the HTML controls and turning user responses
into actions and value updates. Writing such push/pull logic by hand is tedious, error-prone, and a nightmare to
read as any experienced jQuery programmer can attest.

<img class="image-left" src="{% asset_path 'ng/devguide/architecture/databinding.png' %}" alt="Data Binding" width="220px">

Angular supports **data binding**,
a mechanism for coordinating parts of a template with parts of a component.
Add binding markup to the template HTML to tell Angular how to connect both sides.

As the diagram shows, there are four forms of data binding syntax. Each form has a direction &mdash; to the DOM, from the DOM, or in both directions.
<br class="l-clear-both">

The `HeroListComponent` [example](#templates) template has three forms:

<?code-excerpt "lib/src/hero_list_component_1.html (binding)" title?>
```
  <li>{!{hero.name}!}</li>
  <hero-detail [hero]="selectedHero"></hero-detail>
  <li (click)="selectHero(hero)"></li>
```

* The `{!{hero.name}}` [*interpolation*](displaying-data.html#interpolation)
displays the component's `hero.name` property value within the `<li>` element.

* The `[hero]` [*property binding*](template-syntax.html#property-binding) passes the value of `selectedHero` from
the parent `HeroListComponent` to the `hero` property of the child `HeroDetailComponent`.

* The `(click)` [*event binding*](user-input.html#click) calls the component's `selectHero` method when the user clicks a hero's name.

**Two-way data binding** is an important fourth form
that combines property and event binding in a single notation, using the `ngModel` directive.
Here's an example from the `HeroDetailComponent` template:

<?code-excerpt "lib/src/hero_detail_component.html (ngModel)" title?>
```
  <input [(ngModel)]="hero.name">
```

In two-way binding, a data property value flows to the input box from the component as with property binding.
The user's changes also flow back to the component, resetting the property to the latest value,
as with event binding.

Angular processes *all* data bindings once per JavaScript event cycle,
from the root of the application component tree through all child components.

<img class="image-left" src="{% asset_path 'ng/devguide/architecture/component-databinding.png' %}" alt="Data Binding" width="300px">

Data binding plays an important role in communication
between a template and its component.
<br class="l-clear-both">

<img class="image-left" src="{% asset_path 'ng/devguide/architecture/parent-child-binding.png' %}" alt="Parent/Child binding" width="300px">

Data binding is also important for communication between parent and child components.
<br class="l-clear-both">

<div class="l-hr"></div>

## Directives

<img class="image-left" src="{% asset_path 'ng/devguide/architecture/directive.png' %}" alt="Parent child" width="150px">

Angular templates are *dynamic*. When Angular renders them, it transforms the DOM
according to the instructions given by **directives**.

A directive is a class with a `@Directive` annotation.
A component is a *directive-with-a-template*;
a `@Component` annotation is actually a `@Directive` annotation extended with template-oriented features.
<br class="l-clear-both">

<div class="l-sub-section" markdown="1">
  While **a component is technically a directive**,
  components are so distinctive and central to Angular applications that this architectural overview  separates components from directives.
</div>

Two *other* kinds of directives exist: _structural_ and _attribute_ directives.

They tend to appear within an element tag as attributes do,
sometimes by name but more often as the target of an assignment or a binding.

**Structural** directives alter layout by adding, removing, and replacing elements in DOM.

The [example template](#templates) uses two built-in structural directives:

<?code-excerpt "lib/src/hero_list_component_1.html (structural)" title?>
```
  <li *ngFor="let hero of heroes"></li>
  <hero-detail *ngIf="selectedHero != null"></hero-detail>
```

* [`*ngFor`](displaying-data.html#ngFor) tells Angular to stamp out one `<li>` per hero in the `heroes` list.
* [`*ngIf`](displaying-data.html#ngIf) includes the `HeroDetail` component only if a selected hero exists.

<div class="callout is-important" markdown="1">
  In Dart, **the only value that is true is the boolean value `true`**; all
  other values are false. JavaScript and TypeScript, in contrast, treat values
  such as 1 and most non-null objects as true. For this reason, the JavaScript
  and TypeScript versions of this app can use just `selectedHero` as the value
  of the `*ngIf` expression. The Dart version must use a boolean operator such
  as `!=` instead.
</div>

**Attribute** directives alter the appearance or behavior of an existing element.
In templates they look like regular HTML attributes, hence the name.

The `ngModel` directive, which implements two-way data binding, is
an example of an attribute directive. `ngModel` modifies the behavior of
an existing element (typically an `<input>`)
by setting its display value property and responding to change events.

<?code-excerpt "lib/src/hero_detail_component.html (ngModel)" title?>
```
  <input [(ngModel)]="hero.name">
```

Angular has a few more directives that either alter the layout structure
(for example, [ngSwitch](template-syntax.html#ngSwitch))
or modify aspects of DOM elements and components
(for example, [ngStyle](template-syntax.html#ngStyle) and [ngClass](template-syntax.html#ngClass)).

Of course, you can also write your own directives. Components such as
`HeroListComponent` are one kind of custom directive.
<!-- PENDING: link to where to learn more about other kinds! -->

<div class="l-hr"></div>

## Services

<img class="image-left" src="{% asset_path 'ng/devguide/architecture/service.png' %}" alt="Service" width="150px">

_Service_ is a broad category encompassing any value, function, or feature that your application needs.

Almost anything can be a service.
A service is typically a class with a narrow, well-defined purpose. It should do something specific and do it well.
<br class="l-clear-both">

Examples include:
* logging service
* data service
* message bus
* tax calculator
* application configuration

There is nothing specifically _Angular_ about services. Angular has no definition of a service.
There is no service base class, and no place to register a service.

Yet services are fundamental to any Angular application. Components are big consumers of services.

Here's an example of a service class that logs to the browser console:

<?code-excerpt "lib/src/logger_service.dart (class)" title?>
```
  class Logger {
    void log(Object msg) => window.console.log(msg);
    void error(Object msg) => window.console.error(msg);
    void warn(Object msg) => window.console.warn(msg);
  }
```

Here's a `HeroService` that uses a <a href="https://api.dartlang.org/dart_async/Future.html">Future</a> to fetch heroes.
The `HeroService` depends on the `Logger` service and another `BackendService` that handles the server communication grunt work.

<?code-excerpt "lib/src/hero_service.dart (class)" title?>
```
  class HeroService {
    final BackendService _backendService;
    final Logger _logger;
    final heroes = <Hero>[];

    HeroService(this._logger, this._backendService);

    List<Hero> getHeroes() {
      _backendService.getAll(Hero).then((heroes) {
        _logger.log('Fetched ${heroes.length} heroes.');
        this.heroes.addAll(heroes as List<Hero>); // fill cache
      });
      return heroes;
    }
  }
```

Services are everywhere.

Component classes should be lean. They don't fetch data from the server,
validate user input, or log directly to the console.
They delegate such tasks to services.

A component's job is to enable the user experience and nothing more. It mediates between the view (rendered by the template)
and the application logic (which often includes some notion of a _model_).
A good component presents properties and methods for data binding.
It delegates everything nontrivial to services.

Angular doesn't *enforce* these principles.
It won't complain if you write a "kitchen sink" component with 3000 lines.

Angular does help you *follow* these principles by making it easy to factor your
application logic into services and make those services available to components through *dependency injection*.

<div class="l-hr"></div>

## Dependency injection

<img class="image-left" src="{% asset_path 'ng/devguide/architecture/dependency-injection.png' %}" alt="Dependency injection" width="200px">

_Dependency injection_ is a way to supply a new instance of a class
with the fully-formed dependencies it requires. Most dependencies are services.
Angular uses dependency injection to provide new components with the services they need.
<br class="l-clear-both">

Angular can tell which services a component needs by looking at the types of its constructor parameters.
For example, the constructor of your `HeroListComponent` needs a `HeroService`:

<?code-excerpt "lib/src/hero_list_component.dart (constructor)" region="ctor" title?>
```
  final HeroService _heroService;

  HeroListComponent(this._heroService);
```

When Angular creates a component, it first asks an **injector** for
the services that the component requires.

An injector maintains a container of service instances that it has previously created.
If a requested service instance is not in the container, the injector makes one and adds it to the container
before returning the service to Angular.
When all requested services have been resolved and returned,
Angular can call the component's constructor with those services as arguments.
This is *dependency injection*.

The process of `HeroService` injection looks a bit like this:

<img src="{% asset_path 'ng/devguide/architecture/injector-injects.png' %}" alt="Service">

If the injector doesn't have a `HeroService`, how does it know how to make one?

In brief, you must have previously registered a **provider** of the `HeroService` with the injector.
A provider is something that can create or return a service, typically the service class itself.

You can register providers during bootstrapping or with a component,
regardless of its level in the application component tree.

The most common way to register providers is at the component level using the `providers` argument
of the `@Component` annotation:

<?code-excerpt "lib/app_component.dart (providers)" title?>
```
  @Component(
  /* . . . */
    providers: const [BackendService, HeroService, Logger],
  )
  class AppComponent {}
```

Registering with a component means you get a new instance of the
service with each new instance of that component.
A service provided through a component is
shared with all of the component's descendants in the app component tree.

Registering providers when bootstrapping is much less common.
See the [Configuring the injector][] section of the
[Dependency Injection][] page for details.

[Configuring the injector]: /angular/guide/dependency-injection#configuring-the-injector
[Dependency Injection]: /angular/guide/dependency-injection

Points to remember about dependency injection:

* Dependency injection is wired into the Angular framework and used everywhere.

* The *injector* is the main mechanism.
  * An injector maintains a *container* of service instances that it created.
  * An injector can create a new service instance from a *provider*.

* A *provider* is a recipe for creating a service.

* Register *providers* with injectors.

<div class="l-hr"></div>

## Wrap up

You've learned the basics about the eight main building blocks of an Angular application:

* [Modules](#modules)
* [Components](#components)
* [Templates](#templates)
* [Metadata](#metadata)
* [Data binding](#data-binding)
* [Directives](#directives)
* [Services](#services)
* [Dependency injection](#dependency-injection)

That's a foundation for everything else in an Angular application,
and it's more than enough to get going.
But it doesn't include everything you need to know.

Here is a brief, alphabetical list of other important Angular features and services.

- [**Forms**](forms): Support complex data entry scenarios with HTML-based validation and dirty checking.

- [**HTTP**](server-communication): Communicate with a server to get data, save data, and invoke server-side actions with an HTTP client.

- [**Lifecycle hooks**](lifecycle-hooks): Tap into key moments in the lifetime of a component, from its creation to its destruction,
by implementing the lifecycle hook interfaces.

- [**Pipes**](pipes): Improve the user experience by transforming values for display.

- [**Router**](router): Navigate from page to page within the client application and never leave the browser.

- [**Testing**](testing): Write component tests and end-to-end tests for your app.
