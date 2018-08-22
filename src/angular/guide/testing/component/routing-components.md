---
title: "Component Testing: Routing Components"
description: Techniques and practices for component testing of AngularDart apps.
sideNavGroup: advanced
prevpage:
  title: "Component Testing: @Input() and @Output()"
  url: /angular/guide/testing/component/input-and-output
nextpage:
  title: End-to-end Testing
  url: /angular/guide/testing/e2e
---
<?code-excerpt path-base="examples/ng/doc"?>

{% include_relative _page-top-toc.md %}

This page describes how to test routing components using real or mock routers.
Whether or not you mock the router will, among other reasons,  depend on the following:

- The degree to which you wish to test your component in isolation
- The effort you are willing to invest in coding mock router behavior for your particular tests

## Running example

This page uses the heroes app from [part 5][] of the [tutorial][] as a running example.

{% comment %}
The app component of that revision of the app is just a shell delegating
functionality to either the dashboard or heroes components.

The sample tests for each of these components have been written in a
complementary manner: the heroes component tests use a **mock router**,
whereas those for the dashboard use a **real router**.
{% endcomment %}

## Using a mock router

To test using a mock router, you must add the mock router class to the providers
list of the generated root injector, as described in the section on
[Component-external services: mock or real](services#component-external-services-mock-or-real):

<?code-excerpt "toh-5/test/heroes.dart (excerpt)" region="providers-with-context" title?>
```
  import 'package:angular_tour_of_heroes/src/hero_list_component.template.dart'
      as ng;
  import 'package:angular_tour_of_heroes/src/hero_service.dart';
  import 'package:angular_tour_of_heroes/src/route_paths.dart';
  import 'package:mockito/mockito.dart';
  import 'package:pageloader/html.dart';
  import 'package:test/test.dart';

  import 'heroes.template.dart' as self;
  import 'heroes_po.dart';
  import 'utils.dart';

  NgTestFixture<HeroListComponent> fixture;
  HeroesPO po;

  @GenerateInjector([
    ClassProvider(HeroService),
    ClassProvider(Router, useClass: MockRouter),
  ])
  final InjectorFactory rootInjector = self.rootInjector$Injector;

  void main() {
    final injector = InjectorProbe(rootInjector);
    final testBed = NgTestBed.forComponent<HeroListComponent>(
        ng.HeroListComponentNgFactory,
        rootInjector: injector.factory);

    setUp(() async {
      fixture = await testBed.create();
      final context =
          HtmlPageLoaderElement.createFromElement(fixture.rootElement);
      po = HeroesPO.create(context);
    });

    tearDown(disposeAnyRunningTest);
    // ···
  }
```

The `InjectorProbe` will allow individual tests to access the test context injector.
You'll see an example soon.

<?code-excerpt "toh-5/test/utils.dart (InjectorProbe)" title?>
```
  class InjectorProbe {
    InjectorFactory _parent;
    Injector _injector;

    InjectorProbe(this._parent);

    InjectorFactory get factory => _factory;
    Injector get injector => _injector ??= _factory();

    Injector _factory([Injector parent]) => _injector = _parent(parent);
    T get<T>(dynamic token) => injector?.get(token);
  }
```


The following one-line class definition of `MockRouter` illustrates how easy it
is to use the [Mockito][package:mockito] package to define a mock class with the
appropriate API:

<?code-excerpt "toh-5/test/utils.dart (MockRouter)" title?>
```
  class MockRouter extends Mock implements Router {}
```

### Testing programmatic link navigation

Selecting a hero from the heroes list causes a
["mini detail" view to appear](/angular/tutorial/toh-pt5#add-the-mini-detail):

<img class="image-display" src="{% asset ng/devguide/toh/mini-hero-detail.png @path %}" alt="Mini Hero Detail" width="250">

Clicking the "View Details" button should cause a [request to navigate to the
corresponding hero's detail view](/angular/tutorial/toh-pt5#update-the-herolistcomponent-class).
The button's click event is bound to the `gotoDetail()` method which is defined as follows:

<?code-excerpt "toh-5/lib/src/hero_list_component.dart (gotoDetail)" title?>
```
  Future<NavigationResult> gotoDetail() =>
      _router.navigate(_heroUrl(selected.id));
```

In the following test excerpt:

- The `setUp()` method selects a hero.
- The test expects a _single_ call to the mock router's `navigate()` method,
  with an appropriate path a parameter.

<a id="heroes-go-to-detail-test"></a>

<code-tabs>
  <?code-pane "toh-5/test/heroes.dart (go-to detail)"?>
  <?code-pane "toh-5/test/heroes_po.dart" linenums?>
</code-tabs>

### Testing routerLink attribute navigation

The app [dashboard][], from [part 5][] of the [tutorial][], supports direct
navigation to hero details using router links:

<?code-excerpt "toh-5/lib/src/dashboard_component.html (excerpt)" region="click" title?>
```
  <a *ngFor="let hero of heroes" class="col-1-4"
     [routerLink]="heroUrl(hero.id)">
    <div class="module hero">
      <h4>{!{hero.name}!}</h4>
    </div>
  </a>
```

Setting up the initial providers list is a bit more involved.
Because the dashboard uses the [RouterLink][] directive, you need to add all
the usual router providers ([routerProviders][]).
Since you'll be testing outside of the context
of the app's `index.html` file, which sets the [\<base href>][base href], you also
need to provide a value for [appBaseHref][]:

<?code-excerpt "toh-5/test/dashboard.dart (providers)" title replace="/.addInjector[^;]+//g"?>
```
  final testBed = NgTestBed.forComponent<DashboardComponent>(
      ng.DashboardComponentNgFactory,
      rootInjector: injector.factory);
```

The test itself is similar to the one used for heroes, with the exception
that navigating a `routerLink` causes the router's `navigate()` method
to be called with two arguments. The following test checks for expected
values for both arguments:

<code-tabs>
  <?code-pane "toh-5/test/dashboard.dart (go-to detail)"?>
  <?code-pane "toh-5/test/dashboard_po.dart" linenums?>
</code-tabs>

How might you write the tests shown in this section using a real router?
That's covered next.

## Using a real router

### Testing the app root

Provisioning and setup for use of a real router is similar to what you've
seen already:

<?code-excerpt "toh-5/test/app.dart (provisioning and setup)" title?>
```
  final injector = InjectorProbe(rootInjector);
  final testBed = NgTestBed.forComponent<AppComponent>(ng.AppComponentNgFactory,
      rootInjector: injector.factory);

  setUp(() async {
    fixture = await testBed.create();
    router = injector.get<Router>(Router);
    await router?.navigate('/');
    await fixture.update();
    final context =
        HtmlPageLoaderElement.createFromElement(fixture.rootElement);
    appPO = AppPO.create(context);
  });
```

Where `routerProvidersForTesting` is defined as follows:

<?code-excerpt "toh-5/test/utils.dart (routerProvidersForTesting)" title?>
```
  const /* List<Provider|List<Provider>> */ routerProvidersForTesting = [
    ValueProvider.forToken(appBaseHref, '/'),
    routerProviders,
    // Mock platform location even with real router, otherwise sometimes tests hang.
    ClassProvider(PlatformLocation, useClass: MockPlatformLocation),
  ];
```

Among other things, testing the app root using a real router allows you to
exercise features like [deep linking][]:

<?code-excerpt "toh-5/test/app.dart (deep linking)" title?>
```
  group('Deep linking:', () {
    test('navigate to hero details', () async {
      await router.navigate('/heroes/11');
      await fixture.update();
      expect(fixture.rootElement.querySelector('my-hero'), isNotNull);
    });

    test('navigate to heroes', () async {
      await router.navigate('/heroes');
      await fixture.update();
      expect(fixture.rootElement.querySelector('my-heroes'), isNotNull);
    });
  });
```

Not only are you using the real router, but the tests shown above are also
testing out the use of app routes.

Testing using a real router for a non-app-root component requires more
test infrastructure, as you'll see in the next section.

### Testing a non-root component

Consider testing the dashboard component using a real router.
Remember that the dashboard is navigated to, and its view is
displayed in the app root's [RouterOutlet][], which gets
initialized with the full set of app routes:

<?code-excerpt "toh-5/lib/app_component.dart (template)" title?>
```html
  template: '''
    <h1>{!{title}!}</h1>
    <nav>
      <a [routerLink]="RoutePaths.dashboard.toUrl()"
         [routerLinkActive]="'active'">Dashboard</a>
      <a [routerLink]="RoutePaths.heroes.toUrl()"
         [routerLinkActive]="'active'">Heroes</a>
    </nav>
    <router-outlet [routes]="Routes.all"></router-outlet>
  ''',
```

Before you can test a dashboard, you need to create a test component
with a router outlet and a suitably (restricted) set of routes, something
like this:

<?code-excerpt "toh-5/test/dashboard_real_router.dart (TestComponent)" title?>
```
  @Component(
    selector: 'test',
    template: '''
      <my-dashboard></my-dashboard>
      <router-outlet [routes]="[Routes.hero]"></router-outlet>
    ''',
    directives: [RouterOutlet, DashboardComponent],
    exports: [Routes],
  )
  class TestComponent {
    final Router router;

    TestComponent(this.router);
  }
```

The test bed and test fixture are then parameterized over `TestComponent`
rather than `DashboardComponent`:

<?code-excerpt "toh-5/test/dashboard_real_router.dart (excerpt)" region="providers-with-context" title?>
```
  NgTestFixture<TestComponent> fixture;
  DashboardPO po;
  Router router;

  @GenerateInjector([
    ClassProvider(HeroService),
    routerProvidersForTesting,
  ])
  final InjectorFactory rootInjector = self.rootInjector$Injector;

  void main() {
    final injector = InjectorProbe(rootInjector);
    final testBed = NgTestBed.forComponent<TestComponent>(
        self.TestComponentNgFactory,
        rootInjector: injector.factory);
    // ···
  }
```

One way to test navigation, is to log the real router's change in navigation state.
You can achieve this by registering a listener:

<?code-excerpt "toh-5/test/dashboard_real_router.dart (setUp)" title?>
```
  List<RouterState> navHistory;

  setUp(() async {
    fixture = await testBed.create();
    router = fixture.assertOnlyInstance.router;
    navHistory = [];
    router.onRouteActivated.listen((newState) => navHistory.add(newState));
    final context =
        HtmlPageLoaderElement.createFromElement(fixture.rootElement);
    po = DashboardPO.create(context);
  });
```

Using this navigation history, the go-to-detail test illustrated previously when
using a mock router, can be written as follows:

<?code-excerpt "toh-5/test/dashboard_real_router.dart (go to detail)" title?>
```
  test('select hero and navigate to detail + navHistory', () async {
    await po.selectHero(3);
    await fixture.update();
    expect(navHistory.length, 1);
    expect(navHistory[0].path, '/heroes/15');
    // Or, using a custom matcher:
    expect(navHistory[0], isRouterState('/heroes/15'));
  });
```

Contrast this with the [heroes "go to details" test](#heroes-go-to-detail-test)
shown earlier. While the dashboard test requires more testing infrastructure,
the test has the advantage of ensuring that
[route configurations][] are declared as expected.

Alternatively, for a simple test scenario like go-to-detail,
you can simply test the last URL cached by the mock platform location:

<?code-excerpt "toh-5/test/dashboard_real_router.dart (excerpt)" region="go-to-detail-alt" title?>
```
  test('select hero and navigate to detail + mock platform location', () async {
    await po.selectHero(3);
    await fixture.update();
    final mockLocation = injector.get<MockPlatformLocation>(PlatformLocation);
    expect(mockLocation.pathname, '/heroes/15');
  });
```

[appBaseHref]: /api/angular_router/angular_router/appBaseHref-constant
[app shell]: /angular/tutorial/toh-pt5#create-appcomponent
[base href]: /angular/guide/router/1#set-the-base-href
[dashboard]: /angular/tutorial/toh-pt5#add-heroes-to-the-dashboard
[deep linking]: https://en.wikipedia.org/wiki/Deep_linking
[link parameter list]: /angular/guide/router/appendices#link-parameters-list
[package:mockito]: https://pub.dartlang.org/packages/mockito
[part 5]: /angular/tutorial/toh-pt5
[PlatformLocation]: /api/angular_router/angular_router/PlatformLocation-class
[route configurations]: /angular/tutorial/toh-pt5#configure-routes
[routerProviders]: /api/angular_router/angular_router/routerProviders-constant
[RouterLink]: /api/angular_router/angular_router/RouterLink-class
[RouterOutlet]: /api/angular_router/angular_router/RouterOutlet-class
[tutorial]: /angular/tutorial
