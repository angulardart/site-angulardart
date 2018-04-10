@TestOn('browser')
import 'package:angular_router/angular_router.dart';
import 'package:angular_test/angular_test.dart';
import 'package:angular_tour_of_heroes/app_component.dart';
import 'package:test/test.dart';

import 'app_po.dart';
import 'utils.dart';

NgTestFixture<AppComponent> fixture;
AppPO appPO;
Router router;

void main() {
  // #docregion provisioning-and-setup
  final injector = new InjectorProbe();
  final testBed = new NgTestBed<AppComponent>()
      .addProviders(routerProvidersForTesting)
      .addInjector(injector.init);

  setUp(() async {
    fixture = await testBed.create();
    router = injector.get<Router>(Router);
    await router.navigate('/');
    await fixture.update();
    appPO = await new AppPO().resolve(fixture);
  });
  // #enddocregion provisioning-and-setup

  tearDown(disposeAnyRunningTest);

  group('Basics:', basicTests);
  group('Defaults:', dashboardTests);

  group('Select Heroes:', () {
    setUp(() async {
      await appPO.selectTab(1);
      appPO = await new AppPO().resolve(fixture);
    });

    test('route', () async {
      expect(router.current.path, '/heroes');
    });

    test('tab is showing', () {
      expect(appPO.heroesTabIsActive, isTrue);
    });
  });

  group('Select Dashboard:', () {
    setUp(() async {
      // Navigate away from, then back to the dashboard
      await appPO.selectTab(1);
      await fixture.update();
      await appPO.selectTab(0);
      appPO = await new AppPO().resolve(fixture);
    });

    dashboardTests();
  });

  // #docregion deep-linking
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
  // #enddocregion deep-linking
}

void basicTests() {
  test('page title', () async {
    expect(await appPO.pageTitle, 'Tour of Heroes');
  });

  test('tab titles', () async {
    final expectTitles = ['Dashboard', 'Heroes'];
    expect(await appPO.tabTitles, expectTitles);
  });
}

void dashboardTests() {
  test('route', () async {
    expect(router.current.path, '/dashboard');
  });

  test('tab is showing', () {
    expect(appPO.dashboardTabIsActive, isTrue);
  });
}
