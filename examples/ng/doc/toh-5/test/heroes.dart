// #docregion
@Tags(const ['aot'])
@TestOn('browser')

import 'package:angular2/angular2.dart';
import 'package:angular2/router.dart';
import 'package:angular_test/angular_test.dart';
import 'package:angular_tour_of_heroes/heroes_component.dart';
import 'package:angular_tour_of_heroes/hero_service.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'heroes_po.dart';

const targetHero = const {'id': 15, 'name': 'Magneta'};

NgTestFixture<HeroesComponent> fixture;
HeroesPO po;

class MockRouter extends Mock implements Router {}
final mockRouter = new MockRouter();

@AngularEntrypoint()
void main() {
  // When using the real router
  // final app = new AppComponent();
  final providers = new List.from(ROUTER_PROVIDERS)
    ..addAll([
      // When using the real router
      // provide(APP_BASE_HREF, useValue: '/'),
      // provide(ROUTER_PRIMARY_COMPONENT, useValue: app),
      provide(Router, useValue: mockRouter),
      HeroService,
    ]);
  final testBed = new NgTestBed<HeroesComponent>().addProviders(providers);

  setUp(() async {
    fixture = await testBed.create();
    po = await fixture.resolvePageObject(HeroesPO);
  });

  tearDown(disposeAnyRunningTest);

  group('Basics:', basicTests);
  group('Selected hero:', selectedHeroTests);
}

void basicTests() {
  test('title', () async {
    expect(await po.title, 'My Heroes');
  });

  test('hero count', () async {
    await fixture.update();
    expect(po.heroes.length, 10);
  });

  test('no selected hero', () async {
    expect(await po.selectedHero, null);
  });
}

void selectedHeroTests() {
  setUp(() async {
    await po.clickHero(4);
    po = await fixture.resolvePageObject(HeroesPO);
  });

  test('is selected', () async {
    expect(await po.selectedHero, targetHero);
  });

  test('shows mini-detail', () async {
    expect(
        await po.myHeroNameInUppercase, equalsIgnoringCase(targetHero['name']));
  });

  test('go to detail', () async {
    await po.gotoDetail();
    verify(mockRouter.navigate([
      'HeroDetail',
      {'id': '${targetHero['id']}'}
    ]));
  });
}
