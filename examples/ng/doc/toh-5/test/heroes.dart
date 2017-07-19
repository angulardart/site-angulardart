// #docregion
@Tags(const ['aot'])
@TestOn('browser')

import 'package:angular2/angular2.dart';
import 'package:angular2/router.dart';
import 'package:angular_test/angular_test.dart';
import 'package:angular_tour_of_heroes/src/heroes_component.dart';
import 'package:angular_tour_of_heroes/src/hero_service.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'heroes_po.dart';

// #docregion providers-with-context
NgTestFixture<HeroesComponent> fixture;
HeroesPO po;

final mockRouter = new MockRouter();

class MockRouter extends Mock implements Router {}

@AngularEntrypoint()
void main() {
  // #docregion providers
  final testBed = new NgTestBed<HeroesComponent>().addProviders([
    provide(Router, useValue: mockRouter),
    HeroService,
  ]);
  // #enddocregion providers

  setUp(() async {
    fixture = await testBed.create();
    po = await fixture.resolvePageObject(HeroesPO);
  });

  tearDown(disposeAnyRunningTest);
  // #enddocregion providers-with-context

  group('Basics:', basicTests);
  group('Selected hero:', selectedHeroTests);
  // #docregion providers-with-context
}
// #enddocregion providers-with-context

void basicTests() {
  test('title', () async {
    expect(await po.title, 'My Heroes');
  });

  test('hero count', () async {
    expect(po.heroes.length, 10);
  });

  test('no selected hero', () async {
    expect(await po.selectedHero, null);
  });
}

// #docregion go-to-detail
void selectedHeroTests() {
  const targetHero = const {'id': 15, 'name': 'Magneta'};

  setUp(() async {
    await po.selectHero(4);
    po = await fixture.resolvePageObject(HeroesPO);
  });

  // #enddocregion go-to-detail
  test('is selected', () async {
    expect(await po.selectedHero, targetHero);
  });

  test('show mini-detail', () async {
    expect(
        await po.myHeroNameInUppercase, equalsIgnoringCase(targetHero['name']));
  });

  // #docregion go-to-detail
  test('go to detail', () async {
    await po.gotoDetail();
    final c = verify(mockRouter.navigate(captureAny));
    final linkParams = [
      'HeroDetail',
      {'id': '${targetHero['id']}'}
    ];
    expect(c.captured.single, linkParams);
  });
  // #enddocregion go-to-detail

  test('select another hero', () async {
    await po.selectHero(0);
    po = await fixture.resolvePageObject(HeroesPO);
    final heroData = {'id': 11, 'name': 'Mr. Nice'};
    expect(await po.selectedHero, heroData);
  });
  // #docregion go-to-detail
}
