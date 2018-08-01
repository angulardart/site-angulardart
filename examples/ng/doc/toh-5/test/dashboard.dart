@TestOn('browser')

import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';
import 'package:angular_test/angular_test.dart';
import 'package:angular_tour_of_heroes/src/dashboard_component.dart';
import 'package:angular_tour_of_heroes/src/dashboard_component.template.dart'
    as ng;
import 'package:angular_tour_of_heroes/src/hero_service.dart';
import 'package:mockito/mockito.dart';
import 'package:pageloader/html.dart';
import 'package:test/test.dart';

import 'dashboard.template.dart' as self;
import 'dashboard_po.dart';
import 'matchers.dart';
import 'utils.dart';

// #docregion providers-with-context
NgTestFixture<DashboardComponent> fixture;
DashboardPO po;

@GenerateInjector([
  ValueProvider.forToken(appBaseHref, '/'),
  ClassProvider(HeroService),
  routerProviders,
  ClassProvider(Router, useClass: MockRouter),
])
final InjectorFactory rootInjector = self.rootInjector$Injector;

void main() {
  final injector = InjectorProbe(rootInjector);
  // #docregion providers
  final testBed = NgTestBed.forComponent<DashboardComponent>(
      ng.DashboardComponentNgFactory,
      rootInjector: injector.factory);
  // #enddocregion providers, providers-with-context

  setUp(() async {
    fixture = await testBed.create();
    final context =
        HtmlPageLoaderElement.createFromElement(fixture.rootElement);
    po = DashboardPO.create(context);
  });

  tearDown(disposeAnyRunningTest);

  test('title', () {
    expect(po.title, 'Top Heroes');
  });

  test('show top heroes', () {
    final expectedNames = ['Narco', 'Bombasto', 'Celeritas', 'Magneta'];
    expect(po.heroNames, expectedNames);
  });

  // #docregion go-to-detail
  test('select hero and navigate to detail', () async {
    final mockRouter = injector.get<MockRouter>(Router);
    clearInteractions(mockRouter);
    await po.selectHero(3);
    final c = verify(mockRouter.navigate(captureAny, captureAny));
    expect(c.captured[0], '/heroes/15');
    expect(c.captured[1], isNavParams()); // empty params
    expect(c.captured.length, 2);
  });
  // #enddocregion go-to-detail
  // #docregion providers-with-context
}
