---
layout: angular
title: "Component Testing: Services"
description: Techniques and practices for component testing of AngularDart apps.
sideNavGroup: advanced
prevpage:
  title: "Component Testing: Simulating user action"
  url: /angular/guide/testing/component/page-objects
nextpage:
  title: "Component Testing: @Input() and @Output()"
  url: /angular/guide/testing/component/input-and-output
---
{% include_relative _page-top-toc.md %}

Components make use of services to accomplish tasks such as accessing and
persisting data. You're main choice, when testing a component that uses
services, will be to decide whether or not to mock the service. This page
illustrates how to do both.

## Using real, locally provided services

The `AppComponent` from [part 4][] of the [tutorial][] declares its need for a
`HeroService` by including the service in the `@Component` `provider` list:

<?code-excerpt "toh-4/lib/app_component_2.dart (locally provided service)" title?>
```
  @Component(
    selector: 'my-app',
    /* . . . */
    providers: const [HeroService],
  )
  class AppComponent implements OnInit {
    List<Hero> heroes;
    final HeroService _heroService;

    AppComponent(this._heroService);
    /* . . . */
  }
```

**No special measures are necessary** to test `AppComponent` with a
(real) `HeroService`. For components under test, such locally provided
services are instatiated, as usual, thanks to Angular's
[dependency injection][] subsystem.

## Component-external services: mock or real

Some components expect services to have been bootstrapped, or provided by an
ancestor in the app component tree.  When testing such a component, you need
to supply a list of providers to the `NgTestBed` before instantiating the
fixture. For example:

<?code-excerpt "toh-5/test/heroes.dart (providers)"?>
```
  final testBed = new NgTestBed<HeroesComponent>().addProviders([
    provide(Router, useValue: mockRouter),
    HeroService,
  ]);
```

Note that this is true whether a real or mock service is provided. In
the following example, the providers list includes a real `HeroService` but a
mock `Router`:

<?code-excerpt "toh-5/test/heroes.dart (providers)" region="providers-with-context" title?>
```
  NgTestFixture<HeroesComponent> fixture;
  HeroesPO po;

  final mockRouter = new MockRouter();

  class MockRouter extends Mock implements Router {}

  @AngularEntrypoint()
  void main() {
    final testBed = new NgTestBed<HeroesComponent>().addProviders([
      provide(Router, useValue: mockRouter),
      HeroService,
    ]);

    setUp(() async {
      fixture = await testBed.create();
      po = await fixture.resolvePageObject(HeroesPO);
    });

    tearDown(disposeAnyRunningTest);
    /* . . . */
  }
```

See [Component Testing: Routing Components][] for details concerning the use of
mock routers.

## Mocking locally provided services

Mock locally provided services (to the component under test) in the same way as
for [component-external services]: add the requisite mock providers to the
`NgTestBed` before instantiating the fixture.

[component-external services]: #component-external-services-mock-or-real
[dependency injection]: /angular/guide/dependency-injection#angular-dependency-injection
[part 4]: /angular/tutorial/toh-pt4
[Component Testing: Routing Components]: ./routing-components
[tutorial]: /angular/tutorial
