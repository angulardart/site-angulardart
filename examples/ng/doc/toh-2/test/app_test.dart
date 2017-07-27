// #docregion
@Tags(const ['aot'])
@TestOn('browser')

import 'package:angular2/angular2.dart';
import 'package:angular_test/angular_test.dart';
import 'package:angular_tour_of_heroes/app_component.dart';
import 'package:test/test.dart';

import 'app_po.dart';

NgTestFixture<AppComponent> fixture;
AppPO appPO;

@AngularEntrypoint()
void main() {
  final testBed = new NgTestBed<AppComponent>();

  setUp(() async {
    fixture = await testBed.create();
    appPO = await fixture.resolvePageObject(AppPO);
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
    expect(await appPO.tabTitle, 'My Heroes');
  });

  test('hero count', () {
    expect(appPO.heroes.length, 10);
  });

  test('no selected hero', () async {
    expect(await appPO.selectedHero, null);
  });
}

void selectHeroTests() {
  // #docregion show-hero-details
  const targetHero = const {'id': 16, 'name': 'RubberMan'};

  setUp(() async {
    // #docregion new-PO-after-view-update
    await appPO.selectHero(5);
    appPO = await fixture.resolvePageObject(AppPO);
    // #enddocregion new-PO-after-view-update
  });

  test('is selected', () async {
    // #docregion new-PO-after-view-update
    expect(await appPO.selectedHero, targetHero);
    // #enddocregion new-PO-after-view-update
  });

  test('show hero details', () async {
    expect(await appPO.heroFromDetails, targetHero);
  });
  // #enddocregion show-hero-details

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
      expect(await appPO.selectedHero, updatedHero);
    });

    test('name in details view is updated', () async {
      expect(await appPO.heroFromDetails, updatedHero);
    });
  });
}
