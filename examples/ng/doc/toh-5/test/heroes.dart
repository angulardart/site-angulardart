// #docregion
@TestOn('browser')

import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';
import 'package:angular_test/angular_test.dart';
import 'package:angular_tour_of_heroes/src/route_paths.dart' show idParam;
import 'package:angular_tour_of_heroes/src/hero_list_component.dart';
// #docregion providers-with-context, rootInjector
import 'package:angular_tour_of_heroes/src/hero_list_component.template.dart'
    as ng;
// #enddocregion rootInjector
import 'package:angular_tour_of_heroes/src/hero_service.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

// #docregion rootInjector
import 'heroes.template.dart' as self;
// #enddocregion rootInjector
import 'heroes_po.dart';
import 'utils.dart';

NgTestFixture<HeroListComponent> fixture;
HeroesPO po;

// #docregion rootInjector
@GenerateInjector([
  const ClassProvider(HeroService),
  const ClassProvider(Router, useClass: MockRouter),
])
final InjectorFactory rootInjector = self.rootInjector$Injector;

void main() {
  final injector = new InjectorProbe(rootInjector);
  final testBed = NgTestBed.forComponent<HeroListComponent>(
      ng.HeroListComponentNgFactory,
      rootInjector: injector.factory);
  // #enddocregion rootInjector

  setUp(() async {
    fixture = await testBed.create();
    po = await new HeroesPO().resolve(fixture);
  });

  tearDown(disposeAnyRunningTest);
  // #enddocregion providers-with-context

  group('Basics:', basicTests);
  group('Selected hero:', () => selectedHeroTests(injector));
  // #docregion providers-with-context, rootInjector
}
// #enddocregion providers-with-context, rootInjector

void basicTests() {
  test('title', () async {
    expect(await po.title, 'Heroes');
  });

  test('hero count', () async {
    expect(po.heroes.length, 10);
  });

  test('no selected hero', () async {
    expect(await po.selected, null);
  });
}

// #docregion go-to-detail
void selectedHeroTests(InjectorProbe injector) {
  const targetHero = {idParam: 15, 'name': 'Magneta'};

  setUp(() async {
    await po.selectHero(4);
    po = await new HeroesPO().resolve(fixture);
  });

  // #enddocregion go-to-detail
  test('is selected', () async {
    expect(await po.selected, targetHero);
  });

  test('show mini-detail', () async {
    expect(
        await po.myHeroNameInUppercase, equalsIgnoringCase(targetHero['name']));
  });

  // #docregion go-to-detail
  test('go to detail', () async {
    await po.gotoDetail();
    final mockRouter = injector.get<MockRouter>(Router);
    final c = verify(mockRouter.navigate(typed(captureAny)));
    expect(c.captured.single, '/heroes/${targetHero[idParam]}');
  });
  // #enddocregion go-to-detail

  test('select another hero', () async {
    await po.selectHero(0);
    po = await new HeroesPO().resolve(fixture);
    final heroData = {'id': 11, 'name': 'Mr. Nice'};
    expect(await po.selected, heroData);
  });
  // #docregion go-to-detail
}
