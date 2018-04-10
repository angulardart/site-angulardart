// #docregion
@TestOn('browser')

import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';
import 'package:angular_test/angular_test.dart';
import 'package:angular_tour_of_heroes/src/routes.dart';
import 'package:angular_tour_of_heroes/src/dashboard_component.dart';
import 'package:angular_tour_of_heroes/src/hero_service.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'dashboard_po.dart';
import 'matchers.dart';
import 'utils.dart';

// #docregion providers-with-context
NgTestFixture<DashboardComponent> fixture;
DashboardPO po;

void main() {
  final injector = new InjectorProbe();
  // #docregion providers
  final testBed = new NgTestBed<DashboardComponent>().addProviders([
    const ValueProvider.forToken(appBaseHref, '/'),
    const ClassProvider(Routes),
    const ClassProvider(HeroService),
    routerProviders,
    const ClassProvider(Router, useClass: MockRouter),
  ]).addInjector(injector.init);
  // #enddocregion providers, providers-with-context

  setUp(() async {
    fixture = await testBed.create();
    po = await new DashboardPO().resolve(fixture);
  });

  tearDown(disposeAnyRunningTest);

  test('title', () async {
    expect(await po.title, 'Top Heroes');
  });

  test('show top heroes', () async {
    final expectedNames = ['Narco', 'Bombasto', 'Celeritas', 'Magneta'];
    expect(await po.heroNames, expectedNames);
  });

  // #docregion go-to-detail
  test('select hero and navigate to detail', () async {
    final mockRouter = injector.get<MockRouter>(Router);
    clearInteractions(mockRouter);
    await po.selectHero(3);
    final c = verify(mockRouter.navigate(typed(captureAny), typed(captureAny)));
    expect(c.captured[0], '/heroes/15');
    expect(c.captured[1], isNavParams()); // empty params
    expect(c.captured.length, 2);
  });
  // #enddocregion go-to-detail
  // #docregion providers-with-context
}
