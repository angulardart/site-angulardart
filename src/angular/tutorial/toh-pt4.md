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
<!-- FilePath: src/angular/tutorial/toh-pt4.md -->
<?code-excerpt path-base="toh-4"?>

As the Tour of Heroes app evolves, you'll add more components that need access to hero data.

Instead of copying and pasting the same code over and over,
you'll create a single reusable data service and
inject it into the components that need it.
Using a separate service keeps components lean and focused on supporting the view,
and makes it easy to unit-test components with a mock service.

Because data services are invariably asynchronous,
you'll finish the page with a *Future*-based version of the data service.

When you're done with this page, the app should look like this <live-example></live-example>.

## Where you left off

Before continuing with the Tour of Heroes, verify that you have the following structure.
If not, go back to the previous pages.

<div class="ul-filetree" markdown="1">
- angular_tour_of_heroes
  - lib
    - app_component.dart
    - src
      - hero.dart
      - hero_detail_component.dart
  - web
    - index.html
    - main.dart
    - styles.css
  - pubspec.yaml
</div>

{% include_relative _keep-app-running.md %}

## Creating a hero service

The stakeholders want to show the heroes in various ways on different pages.
Users can already select a hero from a list.
Soon you'll add a dashboard with the top performing heroes and create a separate view for editing hero details.
All three views need hero data.

At the moment, the `AppComponent` defines mock heroes for display.
However, defining heroes is not the component's job,
and you can't easily share the list of heroes with other components and views.
In this page, you'll move the hero data acquisition business to a single service that provides the data and
share that service with all components that need the data.

### Create _HeroService_

Create a file in the `lib` folder called `hero_service.dart`.

<div class="l-sub-section" markdown="1">
  The naming convention for service files is the service name in lowercase followed by `_service`.
  For a multi-word service name, use lower [snake_case](../guide/glossary.html#snake_case).
  For example, the filename for `SpecialSuperHeroService` is `special_super_hero_service.dart`.
</div>

Name the class `HeroService`.

<?code-excerpt "lib/src/hero_service_1.dart (starting point)" region="empty-class" title?>
```
  import 'package:angular2/angular2.dart';

  import 'hero.dart';
  import 'mock_heroes.dart';

  @Injectable()
  class HeroService {
  }
```

### Injectable services

Notice that you used an `@Injectable()` annotation.

<div class="callout is-helpful" markdown="1">
  Don't forget the parentheses. Omitting them leads to an error that's difficult to diagnose.
</div>

### Getting hero data

Add a `getHeroes()` method stub.

<?code-excerpt "lib/src/hero_service_1.dart (getHeroes stub)" title?>
```
  @Injectable()
  class HeroService {
    List<Hero> getHeroes() {}
  }
```

The `HeroService` could get `Hero` data from anywhere&mdash;a
web service, local storage, or a mock data source.
Removing data access from the component means
you can change your mind about the implementation anytime,
without touching the components that need hero data.

### Move the mock hero data

Cut the `mockHeroes` list from `app_component.dart` and paste it to a new file in the `lib` folder named `mock_heroes.dart`.
Additionally, copy the `import 'hero.dart'` statement because the heroes list uses the `Hero` class.

<?code-excerpt "lib/src/mock_heroes.dart" title?>
```
  import 'hero.dart';

  final List<Hero> mockHeroes = [
    new Hero(11, 'Mr. Nice'),
    new Hero(12, 'Narco'),
    new Hero(13, 'Bombasto'),
    new Hero(14, 'Celeritas'),
    new Hero(15, 'Magneta'),
    new Hero(16, 'RubberMan'),
    new Hero(17, 'Dynama'),
    new Hero(18, 'Dr IQ'),
    new Hero(19, 'Magma'),
    new Hero(20, 'Tornado')
  ];
```

In `app_component.dart`, where you cut away the `mockHeroes` list,
add an uninitialized `heroes` property:

<?code-excerpt "lib/app_component_1.dart (excerpt)" region="heroes-prop" title?>
```
  List<Hero> heroes;
```

### Return mocked hero data

Back in the `HeroService`, import the mock `mockHeroes` and return it from the `getHeroes()` method.
The `HeroService` looks like this:

<?code-excerpt "lib/src/hero_service_1.dart (final)" title?>
```
  import 'package:angular2/angular2.dart';

  import 'hero.dart';
  import 'mock_heroes.dart';

  @Injectable()
  class HeroService {
    List<Hero> getHeroes() => mockHeroes;
  }
```

### Use the hero service

You're ready to use the `HeroService` in other components, starting with `AppComponent`.

Import the `HeroService` so that you can reference it in the code.

<?code-excerpt "lib/app_component.dart (hero service import)" title?>
```
  import 'src/hero_service.dart';
```

### Don't use *new* with the *HeroService*

How should the `AppComponent` acquire an instance of `HeroService`?

You could create a new instance of the `HeroService` with `new` like this:

<?code-excerpt "lib/app_component_1.dart (excerpt)" region="new-service" title?>
```
  HeroService heroService = new HeroService(); // don't do this
```

However, this option isn't ideal for the following reasons:

* The component has to know how to create a `HeroService`.
  If you change the `HeroService` constructor,
  you must find and update every place you created the service.
  Patching code in multiple places is error prone and adds to the test burden.
* You create a service each time you use `new`.
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
  Read more about dependency injection in the [Dependency Injection](../guide/dependency-injection.html) page.
</div>

The *injector* doesn't know yet how to create a `HeroService`.
If you ran the code now, Angular would fail with this error:

<?code-excerpt?>
```
  EXCEPTION: No provider for HeroService! (AppComponent -> HeroService)
```

To teach the injector how to make a `HeroService`,
add the following `providers` list as the last parameter of the `@Component` annotation.

<?code-excerpt "lib/app_component_1.dart (providers)" title?>
```
  providers: const [HeroService],
```

The `providers` parameter tells Angular to create a fresh instance of the `HeroService` when it creates an `AppComponent`.
The `AppComponent`, as well as its child components, can use that service to get hero data.

<div id="child-component"></div>
### The *AppComponent.getHeroes()* method

The service is in a `heroService` private variable.

You could call the service and get the data in one line.

<?code-excerpt "lib/app_component_1.dart (get-heroes)"?>
```
  heroes = _heroService.getHeroes();
```

You don't really need a dedicated method to wrap one line.  Write it anyway:

<?code-excerpt "lib/app_component_1.dart (getHeroes)" title?>
```
  void getHeroes() {
    heroes = _heroService.getHeroes();
  }
```

<div id="oninit"></div>
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
  Read more about lifecycle hooks in the [Lifecycle Hooks](../guide/lifecycle-hooks.html) page.
</div>

Add `OnInit` to the list of interfaces implemented by `AppComponent`:

<?code-excerpt "lib/app_component_1.dart (ngOnInit stub)" title?>
```
  import 'package:angular2/angular2.dart';

  class AppComponent implements OnInit {
    void ngOnInit() {
    }
  }
```

Write an `ngOnInit()` method with the initialization logic inside. Angular will call it
at the right time. In this case, initialize by calling `getHeroes()`.

<?code-excerpt "lib/app_component_1.dart (ngOnInit)"?>
```
  void ngOnInit() {
    getHeroes();
  }
```

The app should run as expected, showing a list of heroes and a hero detail view
when you click on a hero name.

## Async hero services {#async}

The `HeroService` returns a list of mock heroes immediately;
its `getHeroes()` signature is synchronous.

<?code-excerpt "lib/app_component_1.dart (get-heroes)" title?>
```
  heroes = _heroService.getHeroes();
```

Eventually, the hero data will come from a remote server.
When using a remote server, users don't have to wait for the server to respond;
additionally, you aren't able to block the UI during the wait.

To coordinate the view with the response,
you can use *Futures*, which is an asynchronous
technique that changes the signature of the `getHeroes()` method.

### The hero service returns a _Future_

A [Future][] represents a future computation or value. Using a `Future`, you
can register callback functions that will be invoked when the computation
completes (and results are ready), or when a computational error needs to be
reported.

[Future]: https://api.dartlang.org/stable/dart-async/Future-class.html

<div class="l-sub-section" markdown="1">
  This is a simplified explanation. Read more about Futures in the
  Dart language tutorial on [Asynchronous Programming: Futures][].

  [Asynchronous Programming: Futures]: {{site.dartlang}}/tutorials/language/futures
</div>

Add an import of `'dart:async'` because it defines `Future`, and
update the `HeroService` with this `Future`-returning `getHeroes()` method:

<?code-excerpt "lib/src/hero_service.dart (excerpt)" region="get-heroes" title?>
```
  Future<List<Hero>> getHeroes() async => mockHeroes;
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

<?code-excerpt "lib/app_component_1.dart (synchronous getHeroes)" region="getHeroes" title?>
```
  void getHeroes() {
    heroes = _heroService.getHeroes();
  }
```

Pass the callback function as an argument to the `Future.then()` method:

<?code-excerpt "lib/app_component_2.dart (asynchronous getHeroes)" region="getHeroes" title?>
```
  void getHeroes() {
    _heroService.getHeroes().then((heroes) => this.heroes = heroes);
  }
```

The callback sets the component's `heroes` property to the list of heroes returned by the service.

The app still runs, showing a list of heroes, and
responding to a name selection with a detail view.

## Use _async_/_await_

An asynchronous method containing one or more `Future.then()` methods can be
difficult to read and understand. Thankfully, Dart's `async`/`await`
language feature, lets you write asynchronous code that looks just
like synchronous code. Rewrite `getHeroes()`:

<?code-excerpt "lib/app_component.dart (revised async/await getHeroes)" region="getHeroes" title?>
```
  Future<Null> getHeroes() async {
    heroes = await _heroService.getHeroes();
  }
```

The `Future<Null>` return type is the asynchronous equivalent of `void`.

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
    - app_component.dart
    - src
      - hero.dart
      - hero_detail_component.dart
      - hero_service.dart
      - mock_heroes.dart
  - web
    - index.html
    - main.dart
    - styles.css
  - pubspec.yaml
</div>

Here are the code files discussed in this page.

<code-tabs>
  <?code-pane "lib/src/hero_service.dart"?>
  <?code-pane "lib/app_component.dart"?>
  <?code-pane "lib/src/mock_heroes.dart"?>
</code-tabs>

## The road you've travelled

Here's what you achieved in this page:

* You created a service class that can be shared by many components.
* You used the `ngOnInit` lifecycle hook to get the hero data when the `AppComponent` activates.
* You defined the `HeroService` as a provider for the `AppComponent`.
* You created mock hero data and imported them into the service.
* You designed the service to return a `Future` and the component to get the data from the `Future`.

Your app should look like this <live-example></live-example>.

## The road ahead

The Tour of Heroes has become more reusable using shared components and services.
The next goal is to create a dashboard, add menu links that route between the views, and format data in a template.
As the app evolves, you'll discover how to design it to make it easier to grow and maintain.

Read about the Angular component router and navigation among the views in the [next tutorial](toh-pt5.html) page.

## Appendix: Take it slow {#slow}

To simulate a slow connection,
add the following `getHeroesSlowly()` method to the `HeroService`.

<?code-excerpt "lib/src/hero_service.dart (getHeroesSlowly)" title?>
```
  Future<List<Hero>> getHeroesSlowly() {
    return new Future.delayed(const Duration(seconds: 2), getHeroes);
  }
```

Like `getHeroes()`, it also returns a `Future`, but this `Future` waits two
seconds before completing.

Back in the `AppComponent`, replace `getHeroes()` with `getHeroesSlowly()`
and see how the app behaves.
