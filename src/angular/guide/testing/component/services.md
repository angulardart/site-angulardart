---
layout: angular
title: "Component Testing: Services"
description: Techniques and practices for component testing of AngularDart apps.
sideNavGroup: advanced
prevpage:
  title: "Component Testing: Simulating user action"
  url: /angular/guide/testing/component/simulating-user-action
nextpage:
  title: "Component Testing: @Input() and @Output()"
  url: /angular/guide/testing/component/input-and-output
---
<?code-excerpt path-base="examples/ng/doc"?>

{% include_relative _page-top-toc.md %}

Components make use of services to accomplish tasks such as accessing and
persisting data. Your main choice, when testing a component that uses
services, will be to decide whether or not to mock the service. This page
illustrates how to do both.

## Using real, locally provided services

The `AppComponent` from [part 4][] of the [tutorial][] declares its need for a
`HeroService` by including the service in the `@Component` `provider` list:

<?code-excerpt "toh-4/lib/app_component_2.dart (locally provided service)" title?>
```
  @Component(
    selector: 'my-app',
    // ···
    providers: [ClassProvider(HeroService)],
  )
  class AppComponent implements OnInit {
    List<Hero> heroes;
    final HeroService _heroService;

    AppComponent(this._heroService);
    // ···
  }
```

**No special measures are necessary** to test `AppComponent` with a
(real) `HeroService`. For components under test, such locally provided
services are instatiated, as usual, thanks to Angular's
[dependency injection][] subsystem.

## Component-external services: mock or real

When testing a component that expects a service, you need to supply the
`NgTestBed` with a root injector factory. The provider list of the generated
injector factory can contain both real and mock services, as shown here:

<?code-excerpt "toh-5/test/heroes.dart (rootInjector)" title remove="Probe" replace="/injector.factory/rootInjector/g; /rootInjector(?!\$)/[!$&!]/g"?>
```
  import 'package:angular_tour_of_heroes/src/hero_list_component.template.dart'
      as ng;
  // ···
  import 'heroes.template.dart' as self;
  // ···
  @GenerateInjector([
    ClassProvider(HeroService),
    ClassProvider(Router, useClass: MockRouter),
  ])
  final InjectorFactory [!rootInjector!] = self.rootInjector$Injector;

  void main() {
    final testBed = NgTestBed.forComponent<HeroListComponent>(
        ng.HeroListComponentNgFactory,
        [!rootInjector!]: [!rootInjector!]);
    // ···
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
