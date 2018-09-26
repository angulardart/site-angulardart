---
layout: angular
title: Services
description: Create a reusable service to manage the hero data calls.
prevpage:
  title: Multiple Components
  url: /angular/tutorial/toh-pt3
nextpage:
  title: Routing
  url: /angular/tutorial/toh-pt5
---

<?code-excerpt path-base="examples/ng/doc/toh-4"?>

As the Tour of Heroes app evolves, you'll add more components that need access to hero data.

Instead of copying and pasting the same code over and over,
you'll create a single reusable data service and
inject it into the components that need it.
Using a separate service keeps components lean and focused on supporting the view,
and makes it easy to unit test components with a mock service.

Because data services are invariably asynchronous,
you'll finish the page with a *Future*-based version of the data service.

When you're done with this page, the app should look like this {% example_ref %}.

## Where you left off

Before continuing with the Tour of Heroes, verify that you have the following structure.
If not, go back to the previous pages.

<div class="ul-filetree" markdown="1">
- angular_tour_of_heroes
  - lib
    - app_component.{css,dart,html}
    - src
      - hero.dart
      - hero_component.dart
      - mock_heroes.dart
  - test
    - ...
  - web
    - index.html
    - main.dart
    - styles.css
  - analysis_options.yaml
  - pubspec.yaml
</div>

{% include_relative _keep-app-running.md %}

## Creating a hero service

The stakeholders want to show the heroes in various ways on different pages.
Users can already select a hero from a list.
Soon you'll add a dashboard with the top performing heroes and create a separate view for editing hero details.
All three views need hero data.

At the moment, the `AppComponent` defines mock heroes for display.
However, _defining_ heroes is not the component's job,
and you can't easily share the list of heroes with other components and views.
In this page, you'll move the hero data acquisition business to a single service that provides the data and
share that service with all components that need the data.

### Create an injectable _HeroService_

Create the file `hero_service.dart` under `lib/src`.

<div class="l-sub-section" markdown="1">
  The naming convention for service files is the service name in lowercase followed by `_service`.
  For a multi-word service name, use lower [snake_case](../guide/glossary#snake_case).
  For example, the filename for `SpecialSuperHeroService` is `special_super_hero_service.dart`.
</div>

Name the class `HeroService`.

<?code-excerpt "lib/src/hero_service_1.dart (empty class)" plaster="none" title?>
```
  class HeroService {
  }
```

### Getting hero data

The `HeroService` could get hero data from anywhere&mdash;a
web service, local storage, or a mock data source.
For now, import `Hero` and `mockHeroes`, and return the mock heroes from a `getAll()` method:

<?code-excerpt "lib/src/hero_service_1.dart" title?>
```
  import 'hero.dart';
  import 'mock_heroes.dart';

  class HeroService {
    List<Hero> getAll() => mockHeroes;
  }
```

### Use the hero service

You're ready to use the `HeroService` in other components, starting with `AppComponent`.

Import the `HeroService` so that you can reference it in the code.

<?code-excerpt "lib/app_component.dart (hero service import)" title?>
```
  import 'src/hero_service.dart';
```

### Don't instantiate services

How should the `AppComponent` get an instance of `HeroService`?

You could create a new instance of the `HeroService` like this:

<?code-excerpt "lib/app_component_1.dart (excerpt)" region="new-service" title?>
```
  HeroService heroService = HeroService(); // DON'T do this
```

However, this option isn't ideal for the following reasons:

* The component has to know how to create a `HeroService`.
  If you change the `HeroService` constructor,
  you must find and update every place you created the service.
  Patching code in multiple places is error prone and adds to the test burden.
* You create a service each time you invoke the constructor.
  What if the service caches heroes and shares that cache with others?
  You couldn't do that.
* With the `AppComponent` locked into a specific implementation of the `HeroService`,
  switching implementations for different scenarios, such as operating offline or using
  different mocked versions for testing, would be difficult.


### Inject *HeroService*

Instead of using the *new* expression, add these lines:

* Add a private `HeroService` property.
* Add a constructor that initializes the private property.
* Add `HeroService` to the component's `providers` metadata.

Here are the property and the constructor:

<?code-excerpt "lib/app_component_1.dart (constructor)" region="ctor" title?>
```
  final HeroService _heroService;
  AppComponent(this._heroService);
```

The constructor does nothing except set the `_heroService` property.
The `HeroService` type of `_heroService` identifies the constructor's parameter as
a `HeroService` injection point.

Now Angular knows to supply a `HeroService` instance when it creates a new `AppComponent`.

<div class="l-sub-section" markdown="1">
  Read more about dependency injection in the [Dependency Injection](../guide/dependency-injection) page.
</div>

The *injector* doesn't know yet how to create a `HeroService`.
If you ran the code now, Angular would fail with this error:

```
EXCEPTION: No provider for HeroService! (AppComponent -> HeroService)
```

To teach the injector how to make a `HeroService`,
add the following `providers` list as the last parameter of the `@Component` annotation.

<?code-excerpt "lib/app_component_1.dart (providers)" title?>
```
  providers: [ClassProvider(HeroService)],
```

The `providers` parameter tells Angular to create a fresh instance of the `HeroService` when it creates an `AppComponent`.
The `AppComponent`, as well as its child components, can use that service to get hero data.

<a id="child-component"></a>
### The *AppComponent.getHeroes()* method

Add a `getHeroes()` method to the app component,
and **remove** the `heroes` initializer:

<?code-excerpt "lib/app_component_1.dart (heroes and getHeroes)" title?>
```
  List<Hero> heroes;
  // ···
  void _getHeroes() {
    heroes = _heroService.getAll();
  }
```

<a id="oninit"></a>
### The *ngOnInit* lifecycle hook

`AppComponent` should fetch and display hero data with no issues.

You might be tempted to call the `getHeroes()` method in a constructor, but
a constructor should not contain complex logic,
especially a constructor that calls a server, such as a data access method.
A constructor is for simple initializations, like wiring constructor parameters to properties.

To have Angular call `getHeroes()`, you can implement the Angular *ngOnInit lifecycle hook*.
Angular offers interfaces for tapping into critical moments in the component lifecycle:
at creation, after each change, and at its eventual destruction.

Each interface has a single method. When the component implements that method, Angular calls it at the appropriate time.

<div class="l-sub-section" markdown="1">
  Read more about lifecycle hooks in the [Lifecycle Hooks](../guide/lifecycle-hooks) page.
</div>

Add [OnInit][] to the list of interfaces implemented by `AppComponent`, and
write an `ngOnInit()` method with the initialization logic inside. Angular will call it
at the right time. In this case, initialize by calling `getHeroes()`.

<?code-excerpt "lib/app_component_1.dart (OnInit and ngOnInit)"?>
```
  class AppComponent implements OnInit {
    // ···
    void ngOnInit() => _getHeroes();
    // ···
  }
```

<i class="material-icons">open_in_browser</i>
 **Refresh the browser.** The app should show a list of heroes and a hero detail view
when you click on a hero name.

## Async hero services {#async}

The `HeroService` returns a list of mock heroes immediately;
its `getAll()` signature is synchronous.

<?code-excerpt "lib/src/hero_service_1.dart (getAll)" title?>
```
  List<Hero> getAll() => mockHeroes;
```

Eventually, the hero data will come from a remote server.
When using a remote server, users don't have to wait for the server to respond;
additionally, you aren't able to block the UI during the wait.

To coordinate the view with the response,
you can use *Futures*, which is an asynchronous
technique that changes the signature of the `getAll()` method.

### The hero service returns a _Future_

A [Future][] represents a future computation or value. Using a `Future`, you
can register callback functions that will be invoked when the computation
completes (and results are ready), or when a computational error needs to be
reported.

<div class="l-sub-section" markdown="1">
  This is a simplified explanation. Read more about Futures in the
  Dart language tutorial on [Asynchronous Programming: Futures][].

  [Asynchronous Programming: Futures]: {{site.dartlang}}/tutorials/language/futures
</div>

Add an import of [dart:async][] because it defines `Future`, and
update the `HeroService` with this `Future`-returning `getAll()` method:

<?code-excerpt "lib/src/hero_service.dart (getAll)" title?>
```
  Future<List<Hero>> getAll() async => mockHeroes;
```

You're still mocking the data. You're simulating the behavior of an ultra-fast, zero-latency server,
by returning a `Future` whose mock heroes become available immediately.

<div class="l-sub-section" markdown="1">
  Marking a method as `async` automatically sets the return type to `Future`.
  For more information on `async` functions, see
  [Declaring async functions]({{site.dartlang}}/guides/language/language-tour#async) in the Dart language tour.
</div>

### Processing the _Future_

As a result of the change to `HeroService`, the app component's `heroes`
property is now a `Future` rather than a list of heroes.  You have to change
the implementation to process the `Future` result when it completes.  When
the `Future` completes successfully, you'll have heroes to display.

Here is the current implementation:

<?code-excerpt "lib/app_component_1.dart (synchronous _getHeroes)" region="_getHeroes" title?>
```
  void _getHeroes() {
    heroes = _heroService.getAll();
  }
```

Pass the callback function as an argument to the `Future.then()` method:

<?code-excerpt "lib/app_component_2.dart (asynchronous _getHeroes)" region="_getHeroes" title?>
```
  void _getHeroes() {
    _heroService.getAll().then((heroes) => this.heroes = heroes);
  }
```

The callback sets the component's `heroes` property to the list of heroes returned by the service.

<i class="material-icons">open_in_browser</i>
 **Refresh the browser.** The app still runs, showing a list of heroes, and
responding to a name selection with a detail view.

## Use _async_/_await_

An asynchronous method containing one or more `Future.then()` methods can be
difficult to read and understand. Thankfully, Dart's `async`/`await`
language feature lets you write asynchronous code that looks just
like synchronous code. Rewrite `getHeroes()`:

<?code-excerpt "lib/app_component.dart (revised async/await _getHeroes)" region="_getHeroes" title?>
```
  Future<void> _getHeroes() async {
    heroes = await _heroService.getAll();
  }
```

The `Future<void>` return type is the asynchronous equivalent of `void`.

Read more about asynchronous programming using `async`/`await` in the [Async
and await][] section of the Dart language tutorial on [Asynchronous
Programming: Futures][].

[Asynchronous Programming: Futures]: {{site.dartlang}}/tutorials/language/futures
[Async and await]: {{site.dartlang}}/tutorials/language/futures#async-and-await

<div class="l-sub-section" markdown="1">
  At the end of this page, [Appendix: Take it slow](#slow) describes what the app might be like with a poor connection.
</div>

## Review the app structure

Verify that you have the following structure after all of your refactoring:

<div class="ul-filetree" markdown="1">
- angular_tour_of_heroes
  - lib
    - app_component.{css,dart,html}
    - src
      - hero.dart
      - hero_component.dart
      - hero_service.dart
      - mock_heroes.dart
  - test
    - ...
  - web
    - index.html
    - main.dart
    - styles.css
  - analysis_options.yaml
  - pubspec.yaml
</div>

Here are the code files discussed in this page.

<code-tabs>
  <?code-pane "lib/src/hero_service.dart" linenums?>
  <?code-pane "lib/app_component.dart" linenums?>
</code-tabs>

## The road you've travelled

Here's what you achieved in this page:

* You created a service class that can be shared by many components.
* You used the `ngOnInit` lifecycle hook to get the hero data when the `AppComponent` activates.
* You defined the `HeroService` as a provider for the `AppComponent`.
* You designed the service to return a `Future` and the component to get the data from the `Future`.

Your app should look like this {% example_ref %}.

## The road ahead

The Tour of Heroes has become more reusable using shared components and services.
The next goal is to create a dashboard, add menu links that route between the views, and format data in a template.
As the app evolves, you'll discover how to design it to make it easier to grow and maintain.

Read about the Angular component router and navigation among the views in the [next tutorial](toh-pt5) page.

## Appendix: Take it slow {#slow}

To simulate a slow connection,
add the following `getAllSlowly()` method to the `HeroService`.

<?code-excerpt "lib/src/hero_service.dart (getAllSlowly)" title?>
```
  Future<List<Hero>> getAllSlowly() {
    return Future.delayed(Duration(seconds: 2), getAll);
  }
```

Like `getAll()`, it also returns a `Future`, but this `Future` waits two
seconds before completing.

Back in the `AppComponent`, replace `getAll()` with `getAllSlowly()`
and see how the app behaves.

[dart:async]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-async/dart-async-library.html
[Future]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-async/Future-class.html
[OnInit]: /api/angular/angular/OnInit-class
