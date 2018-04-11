@TestOn('browser')

import 'package:angular_test/angular_test.dart';
import 'package:angular_tour_of_heroes/app_component.dart';
import 'package:angular_tour_of_heroes/app_component.template.dart' as ng;
import 'package:test/test.dart';

import 'app_po.dart';

NgTestFixture<AppComponent> fixture;
AppPO appPO;

void main() {
  final testBed =
      NgTestBed.forComponent<AppComponent>(ng.AppComponentNgFactory);

  setUp(() async {
    fixture = await testBed.create();
    appPO = await new AppPO().resolve(fixture);
  });

  tearDown(disposeAnyRunningTest);

  group('Basics:', basicTests);
  group('Select hero:', selectHeroTests);
}

void basicTests() {
  test('page title', () async {
    expect(await appPO.pageTitle, 'Tour of Heroes');
  });

  test('tab title', () async {
    expect(await appPO.tabTitle, 'Heroes');
  });

  test('hero count', () {
    expect(appPO.heroes.length, 10);
  });

  test('no selected hero', () async {
    expect(await appPO.selected, null);
  });
}

void selectHeroTests() {
  const targetHero = {'id': 16, 'name': 'RubberMan'};

  setUp(() async {
    await appPO.selectHero(5);
    appPO = await new AppPO().resolve(fixture); // Refresh PO
  });

  test('is selected', () async {
    expect(await appPO.selected, targetHero);
  });

  test('show hero details', () async {
    expect(await appPO.heroFromDetails, targetHero);
  });

  group('Update hero:', () {
    const nameSuffix = 'X';
    final updatedHero = new Map.from(targetHero);
    updatedHero['name'] = "${targetHero['name']}$nameSuffix";

    setUp(() async {
      await appPO.type(nameSuffix);
    });

    tearDown(() async {
      // Restore hero name
      await appPO.clear();
      await appPO.type(targetHero['name']);
    });

    test('name in list is updated', () async {
      expect(await appPO.selected, updatedHero);
    });

    test('name in details view is updated', () async {
      expect(await appPO.heroFromDetails, updatedHero);
    });
  });
}
