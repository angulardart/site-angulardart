@TestOn('browser')

import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';
import 'package:angular_test/angular_test.dart';
import 'package:angular_tour_of_heroes/src/routes.dart';
import 'package:angular_tour_of_heroes/src/dashboard_component.dart';
import 'package:angular_tour_of_heroes/src/hero_service.dart';
import 'package:pageloader/html.dart';
import 'package:test/test.dart';

import 'dashboard_po.dart';
import 'dashboard_real_router.template.dart' as self;
import 'matchers.dart';
import 'utils.dart';

// #docregion providers-with-context
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
  // #enddocregion providers-with-context

  // #docregion setUp
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
  // #enddocregion setUp

  tearDown(disposeAnyRunningTest);

  test('title', () {
    expect(po.title, 'Top Heroes');
  });

  test('show top heroes', () {
    final expectedNames = ['Narco', 'Bombasto', 'Celeritas', 'Magneta'];
    expect(po.heroNames, expectedNames);
  });

  // #docregion go-to-detail
  test('select hero and navigate to detail + navHistory', () async {
    await po.selectHero(3);
    await fixture.update();
    expect(navHistory.length, 1);
    expect(navHistory[0].path, '/heroes/15');
    // Or, using a custom matcher:
    expect(navHistory[0], isRouterState('/heroes/15'));
  });
  // #enddocregion go-to-detail

  // #docregion go-to-detail-alt
  test('select hero and navigate to detail + mock platform location', () async {
    await po.selectHero(3);
    await fixture.update();
    final mockLocation = injector.get<MockPlatformLocation>(PlatformLocation);
    expect(mockLocation.pathname, '/heroes/15');
  });
  // #enddocregion go-to-detail-alt
  // #docregion providers-with-context
}
// #enddocregion providers-with-context

// #docregion TestComponent
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
