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
<?code-excerpt path-base="examples/ng/doc/dependency-injection"?>

**Dependency injection** is an important app design pattern.
It's used so widely that almost everyone just calls it _DI_.

Angular has its own dependency injection framework, and
you really can't build an Angular application without it.

This page covers what DI is, why it's useful, and how to use Angular DI.

Run the <live-example></live-example>.

<a id="why-di"></a>
## Why dependency injection?

To understand why dependency injection is so important, consider an example without it.
Imagine writing the following code:

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

The `Car` class creates everything it needs inside its constructor.
What's the problem?
The problem is that the `Car` class is brittle, inflexible, and hard to test.

This `Car` needs an engine and tires. Instead of asking for them,
the `Car` constructor instantiates its own copies from
the very specific classes `Engine` and `Tires`.

What if the `Engine` class evolves and its constructor requires a parameter?
That would break the `Car` class and it would stay broken until you rewrote it along the lines of
`engine = new Engine(theNewParameter)`.
The `Engine` constructor parameters weren't even a consideration when you first wrote `Car`.
You may not anticipate them even now.
But you'll *have* to start caring because
when the definition of `Engine` changes, the `Car` class must change.
That makes `Car` brittle.

What if you want to put a different brand of tires on your `Car`? Too bad.
You're locked into whatever brand the `Tires` class creates. That makes the
`Car` class inflexible.

Right now each new car gets its own engine. It can't share an engine with other cars.
While that makes sense for an automobile engine,
surely you can think of other dependencies that should be shared, such as the onboard
wireless connection to the manufacturer's service center. This `Car` lacks the flexibility
to share services that have been created previously for other consumers.

When you write tests for `Car` you're at the mercy of its hidden dependencies.
Is it even possible to create a new `Engine` in a test environment?
What does `Engine` depend upon? What does that dependency depend on?
Will a new instance of `Engine` make an asynchronous call to the server?
You certainly don't want that going on during tests.

What if the `Car` should flash a warning signal when tire pressure is low?
How do you confirm that it actually does flash a warning
if you can't swap in low-pressure tires during the test?

You have no control over the car's hidden dependencies.
When you can't control the dependencies, a class becomes difficult to test.

How can you make `Car` more robust, flexible, and testable?

<a id="ctor-injection"></a>
That's super easy. Change the `Car` constructor to a version with DI:

<code-tabs>
  <?code-pane "lib/src/car/car.dart (excerpt with DI)" region="car-ctor" linenums?>
  <?code-pane "lib/src/car/car_no_di.dart (excerpt without DI)" region="car-ctor" linenums?>
</code-tabs>

See what happened? The definition of the dependencies are
now in the constructor.
The `Car` class no longer creates an engine or tires.
It just consumes them.

<div class="l-sub-section" markdown="1">
  This example leverages Dart's constructor syntax for declaring parameters and
  initializing properties simultaneously.
</div>

Now you can create a car by passing the engine and tires to the constructor.

<?code-excerpt "lib/src/car/car_creations.dart (car-ctor-instantiation)"?>
```
  // Simple car with 4 cylinders and Flintstone tires.
  new Car(new Engine(), new Tires())
```

How cool is that?
The definition of the engine and tire dependencies are
decoupled from the `Car` class.
You can pass in any kind of engine or tires you like, as long as they
conform to the general API requirements of an engine or tires.

If someone extends the `Engine` class, that is not `Car`'s problem.

<div class="l-sub-section" markdown="1">
  The _consumer_ of `Car` has the problem. The consumer must update the car creation code to
  something like this:

  <?code-excerpt "lib/src/car/car_creations.dart (car-ctor-instantiation-with-param)" replace="/new Car.*/[!$&!]/g"?>
  ```
    class Engine2 extends Engine {
      Engine2(cylinders) : super.withCylinders(cylinders);
    }

    Car superCar() =>
      // Super car with 12 cylinders and Flintstone tires.
      [!new Car(new Engine2(12), new Tires())!]
      ..description = 'Super';
  ```

The critical point is this: the `Car` class did not have to change.
You'll take care of the consumer's problem shortly.

</div>

The `Car` class is much easier to test now because you are in complete control
of its dependencies.
You can pass mocks to the constructor that do exactly what you want them to do
during each test:

<?code-excerpt "lib/src/car/car_creations.dart (car-ctor-instantiation-with-mocks)" replace="/new Car.*/[!$&!]/g"?>
```
  class MockEngine extends Engine {
    MockEngine() : super.withCylinders(8);
  }

  class MockTires extends Tires {
    MockTires() { make = 'YokoGoodStone'; }
  }

  Car testCar() =>
    // Test car with 8 cylinders and YokoGoodStone tires.
    [!new Car(new MockEngine(), new MockTires())!]
    ..description = 'Test';
```

**You just learned what dependency injection is**.

It's a coding pattern in which a class receives its dependencies from external
sources rather than creating them itself.

Cool! But what about that poor consumer?
Anyone who wants a `Car` must now
create all three parts: the `Car`, `Engine`, and `Tires`.
The `Car` class shed its problems at the consumer's expense.
You need something that takes care of assembling these parts.

You _could_ write a giant class to do that:

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
But maintaining it will be hairy as the app grows.
This factory is going to become a huge spiderweb of
interdependent factory methods!

Wouldn't it be nice if you could simply list the things you want to build without
having to define which dependency gets injected into what?

This is where the dependency injection framework comes into play.
Imagine the framework had something called an _injector_.
You register some classes with this injector, and it figures out how to create them.

When you need a `Car`, you simply ask the injector to get it for you and you're good to go.

<?code-excerpt "lib/src/car/car_injector.dart (injector-call)"?>
```
  var car = injector.get(Car);
```

Everyone wins. The `Car` knows nothing about creating an `Engine` or `Tires`.
The consumer knows nothing about creating a `Car`.
You don't have a gigantic factory class to maintain.
Both `Car` and consumer simply ask for what they need and the injector delivers.

This is what a **dependency injection framework** is all about.

<a id="angular-di"></a>
## Angular dependency injection

Angular ships with its own dependency injection framework.
You'll learn Angular Dependency Injection through a discussion of the sample app that accompanies this guide.
Run the <live-example></live-example> anytime.

Start by reviewing this simplified version of the _heroes_ feature
from the [The Tour of Heroes](../tutorial/).

<code-tabs>
  <?code-pane "lib/src/heroes/heroes_component_1.dart" region="v1" linenums?>
  <?code-pane "lib/src/heroes/hero_list_component_1.dart" linenums?>
  <?code-pane "lib/src/heroes/hero.dart" linenums?>
  <?code-pane "lib/src/heroes/mock_heroes.dart" linenums?>
</code-tabs>

The `HeroesComponent` is the top-level heroes component.
It's only purpose is to display the `HeroListComponent`
which displays a list of hero names.

This version of the `HeroListComponent` gets its heroes from `mockHeroes`, an in-memory collection
defined in a separate file.

<?code-excerpt "lib/src/heroes/hero_list_component_1.dart (class)" title?>
```
  class HeroListComponent {
    final List<Hero> heroes = mockHeroes;
  }
```

That may suffice in the early stages of development, but it's far from ideal.
As soon as you try to test this component or get heroes from a remote server,
you'll have to change the implementation of `HeroListComponent` and
replace every other use of the `mockHeroes` data.

## Create an injectable _HeroService_

It's better to hide the details concerning hero data access inside a _service_ class,
defined in its own file.

<?code-excerpt "lib/src/heroes/hero_service_1.dart" title?>
```
  import 'package:angular/angular.dart';

  import 'hero.dart';
  import 'mock_heroes.dart';

  @Injectable()
  class HeroService {
    List<Hero> getAll() => mockHeroes;
  }
```

Assume for now that the [`@Injectable()` annotation](#injectable) is an essential ingredient in every Angular service definition.
The service class exposes a `getHeroes()` method
that returns the same mock data as before.

Of course, this isn't a real data service.
If the service were actually getting data from a remote server,
the `getHeroes()` method signature would be asynchronous.
Such a hero service is presented in the
tutorial section on [Heroes and HTTP](/angular/tutorial/toh-pt6#heroes-and-http).
The focus here is on service _injection_, so a synchronous service will suffice.

<a id="injector-config"></a>
## Register a service provider

A _service_ is just a class in Angular until you register it with an Angular dependency injector.

An Angular injector is responsible for creating service instances and injecting them into classes like the `HeroListComponent`.

You rarely create an Angular injector yourself.
Angular creates injectors for you as it executes the app,
starting with the _root injector_ that it creates during the
[bootstrap][bootstrap()] process.
{% comment %}
https://github.com/dart-lang/site-webdev/issues/1180 - Consider adding a Bootstrapping page
{% endcomment %}

You do have to register _providers_ with an injector
before the injector can create that service.

**Providers** tell the injector _how to create the service_.
Without a provider, the injector would not know
that it is responsible for injecting the service
nor be able to create the service.

<div class="l-sub-section" markdown="1">
  You'll learn much more about _providers_ [below](#providers).
  For now it is sufficient to know that they create services
  and must be registered with an injector.
</div>

The most common way to register a provider is with
any Angular annotation that has a **`providers` list argument**.
The most common of these is `@Component`.

### _@Component_ providers

Here's a revised `HeroesComponent` that registers the `HeroService` in its `providers` list.

<?code-excerpt "lib/src/heroes/heroes_component_1.dart (revised)" region="full" replace="/providers:.*/[!$&!]/g" title?>
```
  import 'package:angular/angular.dart';

  import 'hero_list_component.dart';
  import 'hero_service.dart';

  @Component(
      selector: 'my-heroes',
      template: '''
        <h2>Heroes</h2>
        <hero-list></hero-list>''',
      [!providers: [HeroService],!]
      directives: [HeroListComponent])
  class HeroesComponent {}
```

An instance of the `HeroService` is now available for injection in this `HeroesComponent`
and all of its child components.

A component-provided service may have a limited lifetime. Each new instance of the component gets its own instance of the service
and, when the component instance is destroyed, so is that service instance.

In this sample app, the `HeroComponent` is created when the application starts
and is never destroyed so the `HeroService` created for the `HeroComponent` also lives for the life of the app.

<a id="bootstrap"></a>
### Bootstrap providers

Another common common way to register a provider is using the [bootstrap()][] function.

Applications are bootstrapped in `web/main.dart`:

<?code-excerpt "web/main.dart" title?>
```
  import 'package:angular/angular.dart';
  import 'package:dependency_injection/app_component.dart';

  import 'main.template.dart' as ng;

  void main() {
    bootstrapStatic(AppComponent, [], ng.initReflector);
  }
```

The first argument to `bootstrap()` is the app root component class.
The second argument is a providers list.
The last argument is the statically generated provider registration function
for the app. By using this function, DI works without runtime reflection.

<aside class="alert alert-warning" markdown="1">
  **Important:** We expect that the name of the `bootstrapStatic()` function
  will change, and that most apps won't need to import the generated
  Angular template file `main.template.dart`.
  For details, see [issue #756](https://github.com/dart-lang/angular/issues/756).
</aside>

For example:

<?code-excerpt "web/main_1.dart (discouraged)" region="bootstrap-discouraged"?>
```
  bootstrapStatic(
      AppComponent,
      [HeroService], // DISCOURAGED (but works)
      ng.initReflector);
```

An instance of the `HeroService` will now be available for injection across the entire app.

Bootstrap provisioning is usually reserved for application-wide services
declared external to the app package.
This is why registering app specific services using bootstrap is discouraged.
The preferred approach is to register app services in app components.

Because the `HeroService` is used within the *Heroes* feature set, and nowhere else,
the ideal place to register it is in `HeroesComponent`.

Here's a more realistic example of bootstrapping providers, taken from the
[tutorial, part 5](../tutorial/toh-pt5):

<?code-excerpt "../toh-5/web/main.dart" title?>
```
  import 'package:angular/angular.dart';
  import 'package:angular_router/angular_router.dart';
  import 'package:angular_tour_of_heroes/app_component.template.dart' as ng;

  import 'main.template.dart' as self;

  @GenerateInjector(
    routerProvidersHash, // You can use routerProviders in production
  )
  final InjectorFactory injector = self.injector$Injector;

  void main() {
    runApp(ng.AppComponentNgFactory, createInjector: injector);
  }
```

## Inject a service

The `HeroListComponent` should get heroes from the `HeroService`.

The component shouldn't create the `HeroService` with `new`.
It should ask for the `HeroService` to be injected.

You can tell Angular to inject a dependency in the component's constructor by specifying a **constructor parameter with the dependency type**.
Here's the `HeroListComponent` constructor, asking for the `HeroService` to be injected.

<?code-excerpt "lib/src/heroes/hero_list_component.dart (ctor-signature)"?>
```
  HeroListComponent(HeroService heroService)
```

Of course, the `HeroListComponent` should do something with the injected `HeroService`.
Here's the revised component, making use of the injected service, side-by-side with the previous version for comparison.

<code-tabs>
  <?code-pane "lib/src/heroes/hero_list_component_2.dart (with DI)" region="" linenums?>
  <?code-pane "lib/src/heroes/hero_list_component_1.dart (without DI)" region="" linenums?>
</code-tabs>

Notice that the `HeroListComponent` doesn't know where the `HeroService` comes from.
_You_ know that it comes from the parent `HeroesComponent`.
The _only thing that matters_ is that the `HeroService` is provided in some parent injector.

{% comment %} This might not be relevant anymore
<a id="di-metadata"></a>
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
{% endcomment %}

### Singleton services

Services are singletons _within the scope of an injector_.
There is at most one instance of a service in a given injector.

{% comment %}From TS page; not relevant until we have modules.
There is only one root injector and the `UserService` is registered with that injector.
Therefore, there can be just one `UserService` instance in the entire app
and every class that injects `UserService` get this service instance.
{% endcomment %}

However, Angular DI is a
[hierarchical injection system](hierarchical-dependency-injection),
which means that nested injectors can create their own service instances.
Angular creates nested injectors all the time.

### Component child injectors

For example, when Angular creates a new instance of a component that has `@Component.providers`,
it also creates a new _child injector_ for that instance.

Component injectors are independent of each other and
each of them creates its own instances of the component-provided services.

When Angular destroys one of these component instances, it also destroys the
component's injector and that injector's service instances.

Thanks to [injector inheritance](hierarchical-dependency-injection),
you can still inject application-wide services into these components.
A component's injector is a child of its parent component's injector,
and a descendent of its parent's parent's injector,
and so on all the way back to the application's _root_ injector.
Angular can inject a service provided by any injector in that lineage.

{% comment %}From TS page; not relevant until we have modules.
For example, Angular could inject a `HeroListComponent`
with both the `HeroService` provided in `HeroComponent`
and the `UserService` provided in `AppModule`.
{% endcomment %}

## Testing the component

Earlier you saw that designing a class for dependency injection makes the class easier to test.
Listing dependencies as constructor parameters may be all you need to test app parts effectively.

For example, you can create a new `HeroListComponent` with a mock service that you can manipulate
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
  Learn more in [Testing](testing).
</div>

## When the service needs a service

The `HeroService` is very simple. It doesn't have any dependencies of its own.

What if it had a dependency? What if it reported its activities through a logging service?
You'd apply the same *constructor injection* pattern,
adding a constructor that takes a `Logger` parameter.

Here is the revised `HeroService` that injects the `Logger`, side-by-side with the previous service for comparison.

<code-tabs>
  <?code-pane "lib/src/heroes/hero_service_2.dart (v2)" region="" linenums?>
  <?code-pane "lib/src/heroes/hero_service_1.dart (v1)" region="" linenums?>
</code-tabs>

The constructor asks for an injected instance of a `Logger` and stores it in a private field called `logger`.
The `getHeroes()` method logs a message when asked to fetch heroes.

<a id="logger-service"></a>
### The dependent _Logger_ service

The sample app's `Logger` service is quite simple:

<?code-excerpt "lib/src/logger_service.dart" title?>
```
  import 'package:angular/angular.dart';

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

If the app didn't provide this `Logger`,
Angular would throw an exception when it looked for a `Logger` to inject
into the `HeroService`.

```nocode
  EXCEPTION: No provider for Logger! (HeroListComponent -> HeroService -> Logger)
```

Because a singleton logger service is useful everywhere in the app,
it's registered in `AppComponent`:

<?code-excerpt "lib/src/providers_component.dart (providers-logger)" title="lib/app_component.dart (excerpt)"?>
```
  providers: [Logger]
```

### _@Injectable()_

The **[@Injectable()][Injectable]** annotation identifies a service class as available to an
injector for instantiation. Generally speaking, an injector will report an
error when trying to instantiate a class that is not marked as
`@Injectable()`.

Injectors are also responsible for instantiating components
like `HeroesComponent`. Why isn't `HeroesComponent` marked as `@Injectable()`?

You *can* add it if you really want to. It isn't necessary because the
`HeroesComponent` is already marked with `@Component`, and this
annotation class (like `@Directive` and `@Pipe`, which you'll learn about later)
is a subtype of [Injectable][].  It is in
fact `Injectable` annotations that
identify a class as a target for instantiation by an injector.

<div class="alert alert-warning" markdown="1">
  <h4>Always include the parentheses</h4>

  Always write `@Injectable()`, not just `@Injectable`.
  A metadata annotation must be either a reference to a
  compile-time constant variable or a call to a constant
  constructor such as `Injectable()`.

  If you forget the parentheses, the analyzer will complain:
  "Annotation creation must have arguments". If you try to run the
  app anyway, it won't work, and the console will say
  "expression must be a compile-time constant".
</div>

## Providers

A service provider *provides* the concrete, runtime version of a dependency value.
The injector relies on **providers** to create instances of the services
that the injector injects into components, directives, pipes, and other services.

You must register a service *provider* with an injector, or it won't know how to create the service.

The next few sections explain the many ways you can register a provider.

### The class as its own provider

There are many ways to *provide* something that implements `Logger`.
The `Logger` class itself is an obvious and natural provider.

<?code-excerpt "lib/src/providers_component.dart (providers-logger)"?>
```
  providers: [Logger]
```

But it's not the only way.

You can configure the injector with alternative providers that can deliver a `Logger`.
You could provide a substitute class.
You could give it a provider that calls a logger factory function.
Any of these approaches might be a good choice under the right circumstances.

What matters is that the injector has a provider to go to when it needs a `Logger`.

### The *Provider* class

Here's the class-provider syntax again.

<?code-excerpt "lib/src/providers_component.dart (providers-1)"?>
```
  providers: [Logger]
```

This is actually a shorthand expression for a provider registration
using an instance of the [Provider][] class:

<?code-excerpt "lib/src/providers_component.dart (providers-3)"?>
```
  [const Provider(Logger, useClass: Logger)]
```

The first `Provider` constructor argument is the [token](#token) that serves as the key for both
locating a dependency value and registering the provider.

The second is a named parameter, such as `useClass`,
which you can think of as a *recipe* for creating the dependency value.
There are many ways to create dependency values just as there are many ways to write a recipe.

<a id="class-provider"></a>
### Alternative class providers

Occasionally you'll ask a different class to provide the service.
The following code tells the injector
to return a `BetterLogger` when something asks for the `Logger`.

<?code-excerpt "lib/src/providers_component.dart (providers-4)"?>
```
  [const Provider(Logger, useClass: BetterLogger)]
```

<a id="provide"></a>
### The *provide()* function

When registering providers in a `bootstrap()` function, you can use
the [provide()][] function instead of the more verbose `Provider` constructor expressions.
The `provide()` function accepts the same arguments as the `Provider` constructor.

The `provide()` function cannot be used in an Angular annotation's `providers` list,
because annotations can only contain `const` expressions.

### Class provider with dependencies

Maybe an `EvenBetterLogger` could display the user name in the log message.
This logger gets the user from the injected `UserService`,
which is also injected at the app level.

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

Configure it like `BetterLogger`.

<?code-excerpt "lib/src/providers_component.dart (providers-5)"?>
```
  [UserService, const Provider(Logger, useClass: EvenBetterLogger)]
```

### Aliased class providers

Suppose an old component depends upon an `OldLogger` class.
`OldLogger` has the same interface as the `NewLogger`, but for some reason
you can't update the old component to use it.

When the *old* component logs a message with `OldLogger`,
you'd like the singleton instance of `NewLogger` to handle it instead.

The dependency injector should inject that singleton instance
when a component asks for either the new or the old logger.
The `OldLogger` should be an alias for `NewLogger`.

You certainly do not want two different `NewLogger` instances in your app.
Unfortunately, that's what you get if you try to alias `OldLogger` to `NewLogger` with `useClass`.

<?code-excerpt "lib/src/providers_component.dart (providers-6a)"?>
```
  [NewLogger,
    // Not aliased! Creates two instances of `NewLogger`
    const Provider(OldLogger, useClass: NewLogger)]
```

The solution: alias with the `useExisting` option.

<?code-excerpt "lib/src/providers_component.dart (providers-6b)" replace="/useExisting: \w+/[!$&!]/g"?>
```
  const [NewLogger,
    // Alias OldLogger with reference to NewLogger
    const Provider(OldLogger, [!useExisting: NewLogger!])]
```

<a id="value-provider"></a>
### Value providers

Sometimes it's easier to provide a ready-made object rather than ask the injector to create it from a class.

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

Then you register a provider with the `useValue` option,
which makes this object play the logger role.

<?code-excerpt "lib/src/providers_component.dart (providers-7)" replace="/useValue: \w+/[!$&!]/g"?>
```
  [const Provider(Logger, [!useValue: silentLogger!])]
```

See more `useValue` examples in the
[Non-class dependencies](#non-class-dependencies) and
[OpaqueToken](#opaquetoken) sections.

<a id="factory-provider"></a>
### Factory providers

Sometimes you need to create the dependent value dynamically,
based on information you won't have until the last possible moment.
Maybe the information changes repeatedly in the course of the browser session.

Suppose also that the injectable service has no independent access to the source of this information.

This situation calls for a **factory provider**.

To illustrate the point, add a new business requirement:
the `HeroService` must hide *secret* heroes from normal users.
Only authorized users should see secret heroes.

Like the `EvenBetterLogger`, the `HeroService` needs a fact about the user.
It needs to know if the user is authorized to see secret heroes.
That authorization can change during the course of a single app session,
as when you log in a different user.

Unlike `EvenBetterLogger`, you can't inject the `UserService` into the `HeroService`.
The `HeroService` won't have direct access to the user information to decide
who is authorized and who is not.

Instead, the `HeroService` constructor takes a boolean flag to control display of secret heroes.

<?code-excerpt "lib/src/heroes/hero_service.dart (excerpt)" region="internals" title?>
```
  final Logger _logger;
  final bool _isAuthorized;

  HeroService(this._logger, this._isAuthorized);

  List<Hero> getAll() {
    var auth = _isAuthorized ? 'authorized' : 'unauthorized';
    _logger.log('Getting heroes for $auth user.');
    return mockHeroes
        .where((hero) => _isAuthorized || !hero.isSecret)
        .toList();
  }
```

You can inject the `Logger`, but you can't inject the  boolean `isAuthorized`.
You'll have to take over the creation of new instances of this `HeroService` with a factory provider.

A factory provider needs a factory function:

<?code-excerpt "lib/src/heroes/hero_service_provider.dart (excerpt)" region="factory" title?>
```
  HeroService heroServiceFactory(Logger logger, UserService userService) =>
      new HeroService(logger, userService.user.isAuthorized);
```

Although the `HeroService` has no access to the `UserService`, the factory function does.

You inject both the `Logger` and the `UserService` into the factory provider
and let the injector pass them along to the factory function:

<?code-excerpt "lib/src/heroes/hero_service_provider.dart (excerpt)" region="provider" title?>
```
  const heroServiceProvider = const Provider<HeroService>(HeroService,
      useFactory: heroServiceFactory,
      deps: [Logger, UserService]);
```

<div class="l-sub-section" markdown="1">
  The `useFactory` field tells Angular that the provider is a factory function
  whose implementation is the `heroServiceFactory`.

  The `deps` property is a list of [provider tokens](#token).
  The `Logger` and `UserService` classes serve as tokens for their own class providers.
  The injector resolves these tokens and injects the corresponding services into the matching factory function parameters.
</div>

Notice that you captured the factory provider in a constant, `heroServiceProvider`.
This extra step makes the factory provider reusable.
You can register the `HeroService` with this constant wherever you need it.

In this sample, you need it only in the `HeroesComponent`,
where it replaces the previous `HeroService` registration in the metadata `providers` array.
Here you see the new and the old implementation side-by-side:

<code-tabs>
  <?code-pane "lib/src/heroes/heroes_component.dart (v3)" region="" replace="/providers.*/[!$&!]/g" linenums?>
  <?code-pane "lib/src/heroes/heroes_component_1.dart (v2)" region="full" replace="/providers.*/[!$&!]/g" linenums?>
</code-tabs>

<a id="token"></a>
## Dependency injection tokens

When you register a provider with an injector, you associate that provider with a dependency injection token.
The injector maintains an internal *token-provider* map that it references when
asked for a dependency. The token is the key to the map.

In all previous examples, the dependency value has been a class *instance*, and
the class *type* served as its own lookup key.
Here you get a `HeroService` directly from the injector by supplying the `HeroService` type as the token:

<?code-excerpt "lib/src/injector_component.dart (get-hero-service)"?>
```
  heroService = _injector.get(HeroService);
```

You have similar good fortune when you write a constructor that requires an injected class-based dependency.
When you define a constructor parameter with the `HeroService` class type,
Angular knows to inject the
service associated with that `HeroService` class token:

<?code-excerpt "lib/src/heroes/hero_list_component.dart (ctor-signature)"?>
```
  HeroListComponent(HeroService heroService)
```

This is especially convenient when you consider that most dependency values are provided by classes.

### Non-class dependencies

What if the dependency value isn't a class? Sometimes the thing you want to inject is a
string, list, map, or maybe a function.
{%comment%}TODO: if function injection is useful explain or illustrate why.{%endcomment%}

Applications often define configuration objects with lots of small facts
(like the title of the app or the address of a web API endpoint)
but these configuration objects aren't always instances of a class.
They can be **[Map][]** literals such as this one:

<?code-excerpt "lib/src/app_config.dart (excerpt)" region="config" title?>
```
  const Map heroDiConfig = const <String,String>{
    'apiEndpoint' : 'api.heroes.com',
    'title' : 'Dependency Injection'
  };
```

What if you'd like to make this configuration object available for injection?
You know you can register an object with a [value provider](#value-provider).

But what should you use as the token?
You don't have a class to serve as a token; there is no `HeroDiConfig` class.

While you _could_ use **[Map][]**, you _should not_ because (like
`String`) `Map` is too general. Your app might depend on several maps, each
for a different purpose.

{%comment%}FIXME update once https://github.com/dart-lang/angular/issues/16 is addressed.{%endcomment%}
### OpaqueToken

One solution to choosing a provider token for non-class dependencies is
to define and use an `OpaqueToken`.
The definition of such a token looks like this:

<?code-excerpt "lib/src/app_config.dart (token)"?>
```
  import 'package:angular/angular.dart';

  const appConfigToken = const OpaqueToken('app.config');
```

{% comment %}
The type parameter, while optional, conveys the dependency's type to developers and tooling.
{% endcomment %}
The token description is a developer aid.

Register the dependency provider using the `OpaqueToken` object:

<?code-excerpt "lib/src/providers_component.dart (providers-9)"?>
```
  providers: [
    const Provider(appConfigToken, useValue: heroDiConfig)]
```

Now you can inject the configuration object into any constructor that needs it, with
the help of an `@Inject` annotation:

<?code-excerpt "lib/app_component_2.dart (ctor)"?>
```
  AppComponent(@Inject(appConfigToken) Map config) : title = config['title'];
```

<div class="l-sub-section" markdown="1">
  Although the `Map` interface plays no role in dependency injection,
  it supports typing of the configuration object within the class.
</div>

### Custom configuration class

As an alternative to using a configuration `Map`, you can define
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
is strong static checking: you'll be warned early if you misspell a property
name or assign to it a value of the wrong type.
The Dart [cascade notation (`..`)][cascade] provides a convenient means of initializing
a configuration object.

If you use cascades, the configuration object can't be declared `const` and
you can't use a [value provider](#value-provider),
but you can use a [factory provider](#factory-provider).

<?code-excerpt "lib/app_component.dart (providers)" title?>
```
  providers: [
    Logger,
    UserService,
    const Provider(appConfigToken, useFactory: heroDiConfigFactory),
  ],
```
<?code-excerpt "lib/app_component.dart (ctor)" title?>
```
  AppComponent(@Inject(appConfigToken) AppConfig config, this._userService)
      : title = config.title;
```

<a id="optional"></a>
## Optional dependencies

The `HeroService` *requires* a `Logger`, but what if it could get by without
a logger?
You can tell Angular that the dependency is optional by annotating the
constructor argument with `@Optional()`:

<?code-excerpt "lib/src/providers_component.dart (provider-10-ctor)"?>
```
  HeroService(@Optional() this._logger) {
    _logger?.log(someMessage);
  }
```

When using `@Optional()`, your code must be prepared for a null value. If you
don't register a logger somewhere up the line, the injector will set the
value of `logger` to null.

## Summary

You learned the basics of Angular dependency injection in this page.
You can register various kinds of providers,
and you know how to ask for an injected object (such as a service) by
adding a parameter to a constructor.

Angular dependency injection is more capable than this page has described.
You can learn more about its advanced features, beginning with its support for
nested injectors, in
[Hierarchical Dependency Injection](hierarchical-dependency-injection).

<a id="explicit-injector"></a>
## Appendix: Working with injectors directly

Developers rarely work directly with an injector, but
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
    providers: [
      Car,
      Engine,
      Tires,
      heroServiceProvider,
      Logger,
    ],
  )
  class InjectorComponent implements OnInit {
    final Injector _injector;
    Car car;
    HeroService heroService;
    Hero hero;

    InjectorComponent(this._injector);

    @override
    void ngOnInit() {
      car = _injector.get(Car);
      heroService = _injector.get(HeroService);
      hero = heroService.getAll()[0];
    }

    String get rodent =>
        _injector.get(ROUS, "R.O.U.S.'s? I don't think they exist!");
  }
```

An `Injector` is itself an injectable service.

In this example, Angular injects the component's own `Injector` into the component's constructor.
The component then asks the injected injector for the services it wants in `ngOnInit()`.

Note that the services themselves are not injected into the component.
They are retrieved by calling `injector.get()`.

The `get()` method throws an error if it can't resolve the requested service.
You can call `get()` with a second parameter, which is the value to return if the service
is not found. Angular can't find the service if it's not registered with this or any ancestor injector.

<div class="l-sub-section" markdown="1">
  This technique is an example of the
  [service locator pattern](https://en.wikipedia.org/wiki/Service_locator_pattern).

  **Avoid** this technique unless you genuinely need it.
  It encourages a careless grab-bag approach such as you see here.
  It's difficult to explain, understand, and test.
  You can't know by inspecting the constructor what this class requires or what it will do.
  It could acquire services from any ancestor component, not just its own.
  You're forced to spelunk the implementation to discover what it does.

  Framework developers may take this approach when they
  must acquire services generically and dynamically.
</div>

[bootstrap()]: /api/angular/angular/bootstrap
[cascade]: {{site.dartlang}}/guides/language/language-tour#cascade
[Injectable]: /api/angular/angular/Injectable-class.html
[provide()]: /api/angular/angular/provide
[Provider]: /api/angular/angular/Provider-class.html
[Map]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-core/Map-class.html
