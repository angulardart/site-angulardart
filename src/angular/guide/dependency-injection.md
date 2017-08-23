---
layout: angular
title: Dependency Injection
description: Angular's dependency injection system creates and delivers dependent services "just-in-time".
sideNavGroup: basic
prevpage:
  title: Forms
  url: /angular/guide/forms
nextpage:
  title: Template Syntax
  url: /angular/guide/template-syntax
---
<?code-excerpt path-base="dependency-injection"?>

**Dependency injection** is an important application design pattern.
Angular has its own dependency injection framework, and
we really can't build an Angular application without it.
It's used so widely that almost everyone just calls it _DI_.

In this chapter we'll learn what DI is and why we want it.
Then we'll learn [how to use it](#angular-di) in an Angular app.

- [Why dependency injection?](#why-dependency-injection)
- [Angular dependency injection](#angular-dependency-injection)
- [Injector providers](#injector-providers)
- [Dependency injection tokens](#dependency-injection-tokens)
- [Summary](#summary)

Run the <live-example></live-example>.

<div id="why-di"></div>
## Why dependency injection?

Let's start with the following code.

<?code-excerpt "lib/src/car/car_no_di.dart (car)" title="lib/src/car/car.dart (without DI)"?>
```
  class Car {
    Engine engine;
    Tires tires;
    var description = 'No DI';

    Car() {
      engine = new Engine();
      tires = new Tires();
    }

    // Method using the engine and tires
    String drive() => '$description car with '
      '${engine.cylinders} cylinders and '
      '${tires.make} tires.';
  }
```

Our `Car` creates everything it needs inside its constructor.
What's the problem?
The problem is that our `Car` class is brittle, inflexible, and hard to test.

Our `Car` needs an engine and tires. Instead of asking for them,
the `Car` constructor instantiates its own copies from
the very specific classes `Engine` and `Tires`.

What if the `Engine` class evolves and its constructor requires a parameter?
Our `Car` is broken and stays broken until we rewrite it along the lines of
`engine = new Engine(theNewParameter)`.
We didn't care about `Engine` constructor parameters when we first wrote `Car`.
We don't really care about them now.
But we'll *have* to start caring because
when the definition of `Engine` changes, our `Car` class must change.
That makes `Car` brittle.

What if we want to put a different brand of tires on our `Car`? Too bad.
We're locked into whatever brand the `Tires` class creates. That makes our `Car` inflexible.

Right now each new car gets its own engine. It can't share an engine with other cars.
While that makes sense for an automobile engine,
we can think of other dependencies that should be shared, such as the onboard
wireless connection to the manufacturer's service center. Our `Car` lacks the flexibility
to share services that have been created previously for other consumers.

When we write tests for our `Car` we're at the mercy of its hidden dependencies.
Is it even possible to create a new `Engine` in a test environment?
What does `Engine`itself depend upon? What does that dependency depend on?
Will a new instance of `Engine` make an asynchronous call to the server?
We certainly don't want that going on during our tests.

What if our `Car` should flash a warning signal when tire pressure is low?
How do we confirm that it actually does flash a warning
if we can't swap in low-pressure tires during the test?

We have no control over the car's hidden dependencies.
When we can't control the dependencies, a class becomes difficult to test.

How can we make `Car` more robust, flexible, and testable?

<a id="ctor-injection"></a>
That's super easy. We change our `Car` constructor to a version with DI:

<code-tabs>
  <?code-pane "lib/src/car/car.dart (excerpt with DI)" region="car-ctor"?>
  <?code-pane "lib/src/car/car_no_di.dart (excerpt without DI)" region="car-ctor"?>
</code-tabs>

See what happened? We moved the definition of the dependencies to the constructor.
Our `Car` class no longer creates an engine or tires.
It just consumes them.

<div class="l-sub-section" markdown="1">
  We also leveraged Dart's constructor syntax for declaring parameters and
  initializing properties simultaneously.
</div>

Now we create a car by passing the engine and tires to the constructor.

<?code-excerpt "lib/src/car/car_creations.dart (car-ctor-instantiation)"?>
```
  // Simple car with 4 cylinders and Flintstone tires.
  new Car(new Engine(), new Tires())
```

How cool is that?
The definition of the engine and tire dependencies are
decoupled from the `Car` class itself.
We can pass in any kind of engine or tires we like, as long as they
conform to the general API requirements of an engine or tires.

If someone extends the `Engine` class, that is not `Car`'s problem.

<div class="l-sub-section" markdown="1">
  The _consumer_ of `Car` has the problem. The consumer must update the car creation code to
  something like this:

  {%comment%}var stylePattern = { otl: /(new Car.*$)/gm };{%endcomment%}

  <?code-excerpt "lib/src/car/car_creations.dart (car-ctor-instantiation-with-param)"?>
  ```
    class Engine2 extends Engine {
      Engine2(cylinders) : super.withCylinders(cylinders);
    }

    Car superCar() =>
      // Super car with 12 cylinders and Flintstone tires.
      new Car(new Engine2(12), new Tires())
      ..description = 'Super';
  ```

  The critical point is this: `Car` itself did not have to change.
  We'll take care of the consumer's problem soon enough.
</div>

The `Car` class is much easier to test because we are in complete control
of its dependencies.
We can pass mocks to the constructor that do exactly what we want them to do
during each test:

{%comment%}- var stylePattern = { otl: /(new Car.*$)/gm };{%endcomment%}
<?code-excerpt "lib/src/car/car_creations.dart (car-ctor-instantiation-with-mocks)"?>
```
  class MockEngine extends Engine {
    MockEngine() : super.withCylinders(8);
  }

  class MockTires extends Tires {
    MockTires() { make = 'YokoGoodStone'; }
  }

  Car testCar() =>
    // Test car with 8 cylinders and YokoGoodStone tires.
    new Car(new MockEngine(), new MockTires())
    ..description = 'Test';
```

**We just learned what dependency injection is**.

It's a coding pattern in which a class receives its dependencies from external
sources rather than creating them itself.

Cool! But what about that poor consumer?
Anyone who wants a `Car` must now
create all three parts: the `Car`, `Engine`, and `Tires`.
The `Car` class shed its problems at the consumer's expense.
We need something that takes care of assembling these parts for us.

We could write a giant class to do that:

<?code-excerpt "lib/src/car/car_factory.dart" title?>
```
  import 'car.dart';

  // BAD pattern!
  class CarFactory {
    Car createCar() =>
        new Car(createEngine(), createTires())
          ..description = 'Factory';

    Engine createEngine() => new Engine();
    Tires createTires() => new Tires();
  }
```

It's not so bad now with only three creation methods.
But maintaining it will be hairy as the application grows.
This factory is going to become a huge spiderweb of
interdependent factory methods!

Wouldn't it be nice if we could simply list the things we want to build without
having to define which dependency gets injected into what?

This is where the dependency injection framework comes into play.
Imagine the framework had something called an _injector_.
We register some classes with this injector, and it figures out how to create them.

When we need a `Car`, we simply ask the injector to get it for us and we're good to go.

<?code-excerpt "lib/src/car/car_injector.dart (injector-call)"?>
```
  var car = injector.get(Car);
```

Everyone wins. The `Car` knows nothing about creating an `Engine` or `Tires`.
The consumer knows nothing about creating a `Car`.
We don't have a gigantic factory class to maintain.
Both `Car` and consumer simply ask for what they need and the injector delivers.

This is what a **dependency injection framework** is all about.

Now that we know what dependency injection is and appreciate its benefits,
let's see how it is implemented in Angular.

<div id="angular-di"></div>
## Angular dependency injection

Angular ships with its own dependency injection framework. This framework can also be used
as a standalone module by other applications and frameworks.

That sounds nice. What does it do for us when building components in Angular?
Let's see, one step at a time.

We'll begin with a simplified version of the `HeroesComponent`
that we built in the [The Tour of Heroes](../tutorial/).

<code-tabs>
  <?code-pane "lib/src/heroes/heroes_component_1.dart" region="v1"?>
  <?code-pane "lib/src/heroes/hero_list_component_1.dart"?>
  <?code-pane "lib/src/heroes/hero.dart"?>
  <?code-pane "lib/src/heroes/mock_heroes.dart"?>
</code-tabs>

The `HeroesComponent` is the root component of the *Heroes* feature area.
It governs all the child components of this area.
Our stripped down version has only one child, `HeroListComponent`,
which displays a list of heroes.

Right now `HeroListComponent` gets heroes from `HEROES`, an in-memory collection
defined in another file.
That may suffice in the early stages of development, but it's far from ideal.
As soon as we try to test this component or want to get our heroes data from a remote server,
we'll have to change the implementation of `heroes` and
fix every other use of the `HEROES` mock data.

Let's make a service that hides how we get hero data.

<div class="l-sub-section" markdown="1">
  Given that the service is a
  [separate concern](https://en.wikipedia.org/wiki/Separation_of_concerns),
  we suggest that you
  write the service code in its own file.
</div>

<?code-excerpt "lib/src/heroes/hero_service_1.dart" title?>
```
  import 'package:angular2/angular2.dart';

  import 'hero.dart';
  import 'mock_heroes.dart';

  @Injectable()
  class HeroService {
    List<Hero> getHeroes() => HEROES;
  }
```

Our `HeroService` exposes a `getHeroes` method that returns
the same mock data as before, but none of its consumers need to know that.

<div class="l-sub-section" markdown="1">
  Notice the `@Injectable()` annotation above the service class.
  We'll discuss its purpose [shortly](#injectable).
</div>

<div class="l-sub-section" markdown="1">
  We aren't even pretending this is a real service.
  If we were actually getting data from a remote server, the API would have to be
  asynchronous, returning a [Future]({{site.dart_api}}/dart-async/Future-class.html).
  We'd also have to rewrite the way components consume our service.
  This is important in general, but not to our current story.
</div>

A service is nothing more than a class in Angular.
It remains nothing more than a class until we register it with an Angular injector.

<div id="bootstrap"></div>
### Configuring the injector

We don't have to create an Angular injector.
Angular creates an application-wide injector for us during the bootstrap process.

<?code-excerpt "web/main.dart (bootstrap)" title?>
```
  bootstrap(AppComponent);
```

We do have to configure the injector by registering the **providers**
that create the services our application requires.
We'll explain what [providers](#providers) are later in this chapter.

Before we do, let's see an example of provider registration during bootstrapping:

<?code-excerpt "web/main_1.dart (discouraged)" region="bootstrap-discouraged"?>
```
  bootstrap(AppComponent,
    [HeroService]); // DISCOURAGED (but works)
```

The injector now knows about our `HeroService`.
An instance of our `HeroService` will be available for injection across our entire application.

Of course we can't help wondering about that comment telling us not to do it this way.
It *will* work. It's just not a best practice.
The bootstrap provider option is intended for configuring and overriding Angular's own
preregistered services, such as its routing support.

The preferred approach is to register application providers in application components.
Because the `HeroService` is used within the *Heroes* feature area &mdash;
and nowhere else &mdash; the ideal place to register it is in the top-level `HeroesComponent`.

### Registering providers in a component

Here's a revised `HeroesComponent` that registers the `HeroService`.

{%comment%}var stylePattern = { otl: /(providers:[^,]+),/ };{%endcomment%}
<?code-excerpt "lib/src/heroes/heroes_component_1.dart (revised)" region="full" title?>
```
  import 'package:angular2/angular2.dart';

  import 'hero_list_component.dart';
  import 'hero_service.dart';

  @Component(
      selector: 'my-heroes',
      template: '''
        <h2>Heroes</h2>
        <hero-list></hero-list>''',
      providers: const [HeroService],
      directives: const [HeroListComponent])
  class HeroesComponent {}
```

Look at the `providers` part of the `@Component` annotation.
An instance of the `HeroService` is now available for injection in this `HeroesComponent`
and all of its child components.

The `HeroesComponent` itself doesn't happen to need the `HeroService`.
But its child `HeroListComponent` does, so we head there next.

### Preparing the HeroListComponent for injection

The `HeroListComponent` should get heroes from the injected `HeroService`.
Per the dependency injection pattern, the component must ask for the service in its
constructor, [as we explained earlier](#ctor-injection).
It's a small change:

<code-tabs>
  <?code-pane "lib/src/heroes/hero_list_component_2.dart (with DI)" region=""?>
  <?code-pane "lib/src/heroes/hero_list_component_1.dart (without DI)" region=""?>
</code-tabs>

<div class="l-sub-section" markdown="1">
#### Focus on the constructor

  Adding a parameter to the constructor isn't all that's happening here.

  <?code-excerpt "lib/src/heroes/hero_list_component_2.dart (ctor)"?>
  ```
    HeroListComponent(HeroService heroService) : heroes = heroService.getHeroes();
  ```
  Note that the constructor parameter has the type `HeroService`, and that
  the `HeroListComponent` class has an `@Component` annotation
  (scroll up to confirm that fact).
  Also recall that the parent component (`HeroesComponent`)
  has `providers` information for `HeroService`.

  The constructor parameter type, the `@Component` annotation,
  and the parent's `providers` information combine to tell the
  Angular injector to inject an instance of
  `HeroService` whenever it creates a new `HeroListComponent`.
</div>

<div id="di-metadata"></div>
### Implicit injector creation

When we introduced the idea of an injector above, we showed how to
use it to create a new `Car`. Here we also show how such an injector
would be explicitly created:

<?code-excerpt "lib/src/car/car_injector.dart (injector-create-and-call)"?>
```
  injector = ReflectiveInjector.resolveAndCreate([Car, Engine, Tires]);
  var car = injector.get(Car);
```

We won't find code like that in the Tour of Heroes or any of our other samples.
We *could* write code that [explicitly creates an injector](#explicit-injector) if we *had* to, but we rarely do.
Angular takes care of creating and calling injectors
when it creates components for us &mdash; whether through HTML markup, as in `<hero-list></hero-list>`,
or after navigating to a component with the [router](./router.html).
If we let Angular do its job, we'll enjoy the benefits of automated dependency injection.

### Singleton services

Dependencies are singletons within the scope of an injector.
In our example, a single `HeroService` instance is shared among the
`HeroesComponent` and its `HeroListComponent` children.

However, Angular DI is an hierarchical injection
system, which means that nested injectors can create their own service instances.
Learn more about that in the [Hierarchical Injectors](./hierarchical-dependency-injection.html) chapter.

### Testing the component

We emphasized earlier that designing a class for dependency injection makes the class easier to test.
Listing dependencies as constructor parameters may be all we need to test application parts effectively.

For example, we can create a new `HeroListComponent` with a mock service that we can manipulate
under test:

<?code-excerpt "lib/src/test_component.dart (spec)"?>
```
  var expectedHeroes = [new Hero(0, 'A'), new Hero(1, 'B')];
  var mockService = new MockHeroService(expectedHeroes);
  it('should have heroes when HeroListComponent created', () {
    var hlc = new HeroListComponent(mockService);
    expect(hlc.heroes.length).toEqual(expectedHeroes.length);
  });
```

<div class="l-sub-section" markdown="1">
  Learn more in [Testing](./testing.html).
</div>

### When the service needs a service

Our `HeroService` is very simple. It doesn't have any dependencies of its own.

What if it had a dependency? What if it reported its activities through a logging service?
We'd apply the same *constructor injection* pattern,
adding a constructor that takes a `Logger` parameter.

Here is the revision compared to the original.

<code-tabs>
  <?code-pane "lib/src/heroes/hero_service_2.dart (v2)" region=""?>
  <?code-pane "lib/src/heroes/hero_service_1.dart (v1)" region=""?>
</code-tabs>

The constructor now asks for an injected instance of a `Logger` and stores it in a private property called `_logger`.
We call that property within our `getHeroes` method when anyone asks for heroes.

### Why @Injectable()? {#injectable}

**[@Injectable()][Injectable]** marks a class as available to an
injector for instantiation. Generally speaking, an injector will report an
error when trying to instantiate a class that is not marked as
`@Injectable()`.

{%comment%}
The [Angular Dart Transformer](https://github.com/dart-lang/angular2/wiki/Transformer)
generates static code to replace the use of dart:mirrors. It requires that types be
identified as targets for static code generation. Generally this is achieved
by marking the class as @Injectable (though there are other mechanisms).
{%endcomment%}

Injectors are also responsible for instantiating components
like `HeroesComponent`. Why haven't we marked `HeroesComponent` as
`@Injectable()`?

We *can* add it if we really want to. It isn't necessary because the
`HeroesComponent` is already marked with `@Component`, and this
annotation class (like `@Directive` and `@Pipe`, which we'll learn about later)
is a subtype of [Injectable][].  It is in
fact `Injectable` annotations that
identify a class as a target for instantiation by an injector.

[Injectable]: /api/angular2/angular2.core/Injectable-class.html

<div class="callout is-critical" markdown="1">
  <header> Always include the parentheses</header>
  Always write `@Injectable()`, not just `@Injectable`.
  A metadata annotation must be either a reference to a
  compile-time constant variable or a call to a constant
  constructor such as `Injectable()`.

  If we forget the parentheses, the analyzer will complain:
  "Annotation creation must have arguments". If we try to run the
  app anyway, it won't work, and the console will say
  "expression must be a compile-time constant".
</div>

<div id="logger-service"></div>
## Creating and registering a logger service

We're injecting a logger into our `HeroService` in two steps:
1. Create the logger service.
1. Register it with the application.

Our logger service is quite simple:

<?code-excerpt "lib/src/logger_service.dart" title?>
```
  import 'package:angular2/angular2.dart';

  @Injectable()
  class Logger {
    List<String> _logs = [];
    List<String> get logs => _logs;

    void log(String message) {
      _logs.add(message);
      print(message);
    }
  }
```

<div class="l-sub-section" markdown="1">
  A real implementation would probably use the
  [logging package](https://pub.dartlang.org/packages/logging).
</div>

We're likely to need the same logger service everywhere in our application,
so we put it in the project's `lib/src` folder, and
we register it in the `providers` list of our application component, `AppComponent`.

<?code-excerpt "lib/src/providers_component.dart (providers-logger)" title="lib/app_component.dart (excerpt)"?>
```
  providers: const [Logger]
```

If we forget to register the logger, Angular throws an exception when it first looks for the logger:

<?code-excerpt?>
```
  EXCEPTION: No provider for Logger! (HeroListComponent -> HeroService -> Logger)
```

That's Angular telling us that the dependency injector couldn't find the *provider* for the logger.
It needed that provider to create a `Logger` to inject into a new
`HeroService`, which it needed to
create and inject into a new `HeroListComponent`.

The chain of creations started with the `Logger` provider. *Providers* are the subject of our next section.

<div id="providers"></div>
## Injector providers

A provider *provides* the concrete, runtime version of a dependency value.
The injector relies on **providers** to create instances of the services
that the injector injects into components and other services.

We must register a service *provider* with the injector, or it won't know how to create the service.

Earlier we registered the `Logger` service in the `providers` list of the metadata for the `AppModule` like this:

<?code-excerpt "lib/src/providers_component.dart (providers-logger)"?>
```
  providers: const [Logger]
```

There are many ways to *provide* something that implements `Logger`.
The `Logger` class itself is an obvious and natural provider.
But it's not the only way.

We can configure the injector with alternative providers that can deliver a `Logger`.
We could provide a substitute class.
We could give it a provider that calls a logger factory function.
Any of these approaches might be a good choice under the right circumstances.

What matters is that the injector has a provider to go to when it needs a `Logger`.

<div id="provide"></div>
### The *Provider* class

We wrote the `providers` list like this:

<?code-excerpt "lib/src/providers_component.dart (providers-1)"?>
```
  providers: const [Logger]
```

This is actually a shorthand expression for a provider registration
that creates a new instance of the
[Provider](/api/angular2/angular2.core/Provider-class.html) class:

<?code-excerpt "lib/src/providers_component.dart (providers-3)"?>
```
  const [const Provider(Logger, useClass: Logger)]
```

We supply two arguments (or more) to the `Provider` constructor.

The first is the [token](#token) that serves as the key for both locating a dependency value
and registering the provider.

The second is a named parameter, such as `useClass`,
which we can think of as a *recipe* for creating the dependency value.
There are many ways to create dependency values ... and many ways to write a recipe.

<div id="class-provider"></div>
### Alternative class providers

Occasionally we'll ask a different class to provide the service.
The following code tells the injector
to return a `BetterLogger` when something asks for the `Logger`.

<?code-excerpt "lib/src/providers_component.dart (providers-4)"?>
```
  const [const Provider(Logger, useClass: BetterLogger)]
```

<div class="callout is-helpful" markdown="1">
  <header> Dart difference: Constants in metadata</header>
  In Dart, the value of a metadata annotation must be a compile-time constant.
  For that reason, we can't call functions to get values
  to use within an annotation.
  Instead, we use constant literals or constant constructors.
  For example, a TypeScript program will use the
  object literal `{ provide: Logger, useClass: BetterLogger }`.
  A Dart annotation would instead use the constant value
  `const Provider(Logger, useClass: BetterLogger)`.
</div>

### Class provider with dependencies

Maybe an `EvenBetterLogger` could display the user name in the log message.
This logger gets the user from the injected `UserService`,
which happens also to be injected at the application level.

<?code-excerpt "lib/src/providers_component.dart (EvenBetterLogger)"?>
```
  @Injectable()
  class EvenBetterLogger extends Logger {
    final UserService _userService;

    EvenBetterLogger(this._userService);

    @override void log(String message) {
      var name = _userService.user.name;
      super.log('Message to $name: $message');
    }
  }
```

Configure it like we did `BetterLogger`.

<?code-excerpt "lib/src/providers_component.dart (providers-5)"?>
```
  const [UserService, const Provider(Logger, useClass: EvenBetterLogger)]
```

### Aliased class providers

Suppose an old component depends upon an `OldLogger` class.
`OldLogger` has the same interface as the `NewLogger`, but for some reason
we can't update the old component to use it.

When the *old* component logs a message with `OldLogger`,
we want the singleton instance of `NewLogger` to handle it instead.

The dependency injector should inject that singleton instance
when a component asks for either the new or the old logger.
The `OldLogger` should be an alias for `NewLogger`.

We certainly do not want two different `NewLogger` instances in our app.
Unfortunately, that's what we get if we try to alias `OldLogger` to `NewLogger` with `useClass`.

<?code-excerpt "lib/src/providers_component.dart (providers-6a)"?>
```
  const [NewLogger,
    // Not aliased! Creates two instances of `NewLogger`
    const Provider(OldLogger, useClass: NewLogger)]
```

The solution: alias with the `useExisting` option.

{%comment%}var stylePattern = { otl: /(useExisting: \w*)/gm };{%endcomment%}
<?code-excerpt "lib/src/providers_component.dart (providers-6b)"?>
```
  const [NewLogger,
    // Alias OldLogger with reference to NewLogger
    const Provider(OldLogger, useExisting: NewLogger)]
```

<div id="value-provider"></div>
### Value providers

Sometimes it's easier to provide a ready-made object rather than ask the injector to create it from a class.

<div class="callout is-helpful" markdown="1">
  <header> Dart difference: Constants in metadata</header>
  Because Dart annotations must be compile-time constants,
  `useValue` is often used with string or list literals.
  However, `useValue` works with any constant object.

  To create a class that can provide constant objects,
  ensure all its instance variables are `final`,
  and give it a `const` constructor.

  Create a constant instance of the class by using `const` instead of `new`.
</div>

{%comment%}
- var stylePattern = { otl: /(useValue.*\))/gm };
+makeExample('dependency-injection/dart/lib/providers_component.dart','providers-9','', stylePattern)(format='.')
{%endcomment%}

<?code-excerpt "lib/src/providers_component.dart (silent-logger)"?>
```
  class SilentLogger implements Logger {
    @override
    final List<String> logs = const ['Silent logger says "Shhhhh!". Provided via "useValue"'];

    const SilentLogger();

    @override
    void log(String message) { }
  }

  const silentLogger = const SilentLogger();
```

Then we register a provider with the `useValue` option,
which makes this object play the logger role.

{%comment%}- var stylePattern = { otl: /(useValue: \w*)/gm };{%endcomment%}
<?code-excerpt "lib/src/providers_component.dart (providers-7)"?>
```
  const [const Provider(Logger, useValue: silentLogger)]
```

See more `useValue` examples in the
[Non-class dependencies](#non-class-dependencies) and
[OpaqueToken](#opaquetoken) sections.

<div id="factory-provider"></div>
### Factory providers

Sometimes we need to create the dependent value dynamically,
based on information we won't have until the last possible moment.
Maybe the information changes repeatedly in the course of the browser session.

Suppose also that the injectable service has no independent access to the source of this information.

This situation calls for a **factory provider**.

Let's illustrate by adding a new business requirement:
the HeroService must hide *secret* heroes from normal users.
Only authorized users should see secret heroes.

Like the `EvenBetterLogger`, the `HeroService` needs a fact about the user.
It needs to know if the user is authorized to see secret heroes.
That authorization can change during the course of a single application session,
as when we log in a different user.

Unlike `EvenBetterLogger`, we can't inject the `UserService` into the `HeroService`.
The `HeroService` won't have direct access to the user information to decide
who is authorized and who is not.

<div class="l-sub-section" markdown="1">
  Why? We don't know either. Stuff like this happens.
</div>

Instead the `HeroService` constructor takes a boolean flag to control display of secret heroes.

<?code-excerpt "lib/src/heroes/hero_service.dart (excerpt)" region="internals" title?>
```
  final Logger _logger;
  final bool _isAuthorized;

  HeroService(this._logger, this._isAuthorized);

  List<Hero> getHeroes() {
    var auth = _isAuthorized ? 'authorized' : 'unauthorized';
    _logger.log('Getting heroes for $auth user.');
    return HEROES
        .where((hero) => _isAuthorized || !hero.isSecret)
        .toList();
  }
```

We can inject the `Logger`, but we can't inject the  boolean `isAuthorized`.
We'll have to take over the creation of new instances of this `HeroService` with a factory provider.

A factory provider needs a factory function:

<?code-excerpt "lib/src/heroes/hero_service_provider.dart (excerpt)" region="factory" title?>
```
  HeroService heroServiceFactory(Logger logger, UserService userService) =>
      new HeroService(logger, userService.user.isAuthorized);
```

Although the `HeroService` has no access to the `UserService`, our factory function does.

We inject both the `Logger` and the `UserService` into the factory provider and let the injector pass them along to the factory function:

<?code-excerpt "lib/src/heroes/hero_service_provider.dart (excerpt)" region="provider" title?>
```
  const heroServiceProvider = const Provider(HeroService,
      useFactory: heroServiceFactory,
      deps: const [Logger, UserService]);
```

<div class="l-sub-section" markdown="1">
  The `useFactory` field tells Angular that the provider is a factory function
  whose implementation is the `heroServiceFactory`.

  The `deps` property is a list of [provider tokens](#token).
  The `Logger` and `UserService` classes serve as tokens for their own class providers.
  The injector resolves these tokens and injects the corresponding services into the matching factory function parameters.
</div>

Notice that we captured the factory provider in a constant, `heroServiceProvider`.
This extra step makes the factory provider reusable.
We can register our `HeroService` with this constant wherever we need it.

In our sample, we need it only in the `HeroesComponent`,
where it replaces the previous `HeroService` registration in the metadata `providers` list.
Here we see the new and the old implementation side-by-side:

{%comment%}var stylePattern = { otl: /(providers.*),$/gm };{%endcomment%}
<code-tabs>
  <?code-pane "lib/src/heroes/heroes_component.dart (v3)" region=""?>
  <?code-pane "lib/src/heroes/heroes_component_1.dart (v2)" region="full"?>
</code-tabs>

<div id="token"></div>
## Dependency injection tokens

When we register a provider with an injector, we associate that provider with a dependency injection token.
The injector maintains an internal *token-provider* map that it references when
asked for a dependency. The token is the key to the map.

In all previous examples, the dependency value has been a class *instance*, and
the class *type* served as its own lookup key.
Here we get a `HeroService` directly from the injector by supplying the `HeroService` type as the token:

<?code-excerpt "lib/src/injector_component.dart (get-hero-service)"?>
```
  heroService = _injector.get(HeroService);
```

We have similar good fortune when we write a constructor that requires an injected class-based dependency.
We define a constructor parameter with the `HeroService` class type,
and Angular knows to inject the
service associated with that `HeroService` class token:

<?code-excerpt "lib/src/heroes/hero_list_component.dart (ctor-signature)"?>
```
  HeroListComponent(HeroService heroService)
```

This is especially convenient when we consider that most dependency values are provided by classes.

{%comment%}TODO: if function injection is useful explain or illustrate why.{%endcomment%}
### Non-class dependencies

What if the dependency value isn't a class? Sometimes the thing we want to inject is a
string, list, map, or maybe a function.

Applications often define configuration objects with lots of small facts
(like the title of the application or the address of a web API endpoint).
They can be **[Map][]** literals such as this one:

<?code-excerpt "lib/src/app_config.dart (excerpt)" region="config" title?>
```
  const Map heroDiConfig = const <String,String>{
    'apiEndpoint' : 'api.heroes.com',
    'title' : 'Dependency Injection'
  };
```

We'd like to make this configuration object available for injection.
We know we can register an object with a [value provider](#value-provider).

But what should we use as the token?
While we _could_ use **[Map][]**, we _should not_ because (like
`String`) `Map` is too general. Our app might depend on several maps, each
for a different purpose.

[Map]: https://api.dartlang.org/stable/dart-core/Map-class.html

<div class="callout is-helpful" markdown="1">
  <header> Dart difference: Interfaces are valid tokens</header>
  In TypeScript, interfaces don't work as provider tokens.
  Dart doesn't have this limitation;
  every class implicitly defines an interface,
  so interface names are just class names.
  `Map` is a *valid* token even though it's the name of an abstract class;
  it's just *unsuitable* as a token because it's too general.
</div>

{%comment%}FIXME update once https://github.com/dart-lang/angular2/issues/16 is addressed.{%endcomment%}
### OpaqueToken

One solution to choosing a provider token for non-class dependencies is
to define and use an `OpaqueToken`.
The definition looks like this:

<?code-excerpt "lib/src/app_config.dart (token)"?>
```
  import 'package:angular2/angular2.dart';

  const APP_CONFIG = const OpaqueToken('app.config');
```

We register the dependency provider using the `OpaqueToken` object:

<?code-excerpt "lib/src/providers_component.dart (providers-9)"?>
```
  providers: const [
    const Provider(APP_CONFIG, useValue: heroDiConfig)]
```

Now we can inject the configuration object into any constructor that needs it, with
the help of an `@Inject` annotation:

<?code-excerpt "lib/app_component_2.dart (ctor)"?>
```
  AppComponent(@Inject(APP_CONFIG) Map config) : title = config['title'];
```

<div class="l-sub-section" markdown="1">
  Although the `Map` interface plays no role in dependency injection,
  it supports typing of the configuration object within the class.
</div>

As an alternative to using a configuration `Map`, we can define
a custom configuration class:

<?code-excerpt "lib/src/app_config.dart (alternative config)" region="config-alt" title?>
```
  class AppConfig {
    String apiEndpoint;
    String title;
  }

  AppConfig heroDiConfigFactory() => new AppConfig()
    ..apiEndpoint = 'api.heroes.com'
    ..title = 'Dependency Injection';
```

Defining a configuration class has a few benefits. One key benefit
is strong static checking: we'll be warned early if we misspell a property
name or assign it a value of the wrong type.
The Dart [cascade notation][cascade] (`..`) provides a convenient means of initializing
a configuration object.

If we use cascades, the configuration object can't be declared `const` and
we can't use a [value provider](#value-provider).
A solution is to use a [factory provider](#factory-provider).
We illustrate this next. We also show how to provide and inject the
configuration object in our top-level `AppComponent`:

[cascade]: {{site.dartlang}}/guides/language/language-tour#cascade

<?code-excerpt "lib/app_component.dart (providers)" title?>
```
  providers: const [
    Logger,
    UserService,
    const Provider(APP_CONFIG, useFactory: heroDiConfigFactory),
  ],
```
<?code-excerpt "lib/app_component.dart (ctor)" title?>
```
  AppComponent(@Inject(APP_CONFIG) AppConfig config, this._userService)
      : title = config.title;
```

<div id="optional"></div>
## Optional dependencies

Our `HeroService` *requires* a `Logger`, but what if it could get by without
a logger?
We can tell Angular that the dependency is optional by annotating the
constructor argument with `@Optional()`:

<?code-excerpt "lib/src/providers_component.dart (provider-10-ctor)"?>
```
  HeroService(@Optional() this._logger) {
    _logger?.log(someMessage);
  }
```

When using `@Optional()`, our code must be prepared for a null value. If we
don't register a logger somewhere up the line, the injector will set the
value of `logger` to null.

## Summary

We learned the basics of Angular dependency injection in this chapter.
We can register various kinds of providers,
and we know how to ask for an injected object (such as a service) by
adding a parameter to a constructor.

Angular dependency injection is more capable than we've described.
We can learn more about its advanced features, beginning with its support for
nested injectors, in the
[Hierarchical Dependency Injection](hierarchical-dependency-injection.html) chapter.

<div id="explicit-injector"></div>
## Appendix: Working with injectors directly

We rarely work directly with an injector, but
here's an `InjectorComponent` that does.

<?code-excerpt "lib/src/injector_component.dart (injector)" title?>
```
  @Component(
      selector: 'my-injectors',
      template: '''
        <h2>Other Injections</h2>
        <div id="car">{!{car.drive()}!}</div>
        <div id="hero">{!{hero.name}!}</div>
        <div id="rodent">{!{rodent}!}</div>''',
      providers: const [
        Car, Engine, Tires, heroServiceProvider, Logger])
  class InjectorComponent {
    final Injector _injector;
    Car car;
    HeroService heroService;
    Hero hero;

    InjectorComponent(this._injector) {
      car = _injector.get(Car);
      heroService = _injector.get(HeroService);
      hero = heroService.getHeroes()[0];
    }

    String get rodent =>
      _injector.get(ROUS, "R.O.U.S.'s? I don't think they exist!");
  }
```

An `Injector` is itself an injectable service.

In this example, Angular injects the component's own `Injector` into the component's constructor.
The component then asks the injected injector for the services it wants.

Note that the services themselves are not injected into the component.
They are retrieved by calling `injector.get`.

The `get` method throws an error if it can't resolve the requested service.
We can call `get` with a second parameter (the value to return if the service is not found)
instead, which we do in one case
to retrieve a service (`ROUS`) that isn't registered with this or any ancestor injector.

<div class="l-sub-section" markdown="1">
  The technique we just described is an example of the
  [service locator pattern](https://en.wikipedia.org/wiki/Service_locator_pattern).

  We **avoid** this technique unless we genuinely need it.
  It encourages a careless grab-bag approach such as we see here.
  It's difficult to explain, understand, and test.
  We can't know by inspecting the constructor what this class requires or what it will do.
  It could acquire services from any ancestor component, not just its own.
  We're forced to spelunk the implementation to discover what it does.

  Framework developers may take this approach when they
  must acquire services generically and dynamically.
</div>
