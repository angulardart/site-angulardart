@TestOn('browser')

import 'package:angular_test/angular_test.dart';
import 'package:angular_tour_of_heroes/app_component.dart';
import 'package:angular_tour_of_heroes/app_component.template.dart' as ng;
import 'package:pageloader/html.dart';
import 'package:test/test.dart';

import 'app_po.dart';

NgTestFixture<AppComponent> fixture;
AppPO appPO;

void main() {
  final testBed =
      NgTestBed.forComponent<AppComponent>(ng.AppComponentNgFactory);

  setUp(() async {
    fixture = await testBed.create();
    final context =
        HtmlPageLoaderElement.createFromElement(fixture.rootElement);
    appPO = AppPO.create(context);
  });

  tearDown(disposeAnyRunningTest);

  group('Basics:', basicTests);
  group('Select hero:', selectHeroTests);
}

void basicTests() {
  test('page title', () {
    expect(appPO.pageTitle, 'Tour of Heroes');
  });

  test('tab title', () {
    expect(appPO.tabTitle, 'Heroes');
  });

  test('hero count', () {
    expect(appPO.heroes.length, 10);
  });

  test('no selected hero', () {
    expect(appPO.selected, null);
  });
}

void selectHeroTests() {
  // #docregion show-hero-details
  const targetHero = {'id': 16, 'name': 'RubberMan'};

  setUp(() async {
    // #docregion new-PO-after-view-update
    await appPO.selectHero(5);
    // #enddocregion new-PO-after-view-update
  });

  test('is selected', () {
    // #docregion new-PO-after-view-update
    expect(appPO.selected, targetHero);
    // #enddocregion new-PO-after-view-update
  });

  test('show hero details', () {
    expect(appPO.heroFromDetails, targetHero);
  });
  // #enddocregion show-hero-details

  group('Update hero:', () {
    const nameSuffix = 'X';
    final updatedHero = Map.from(targetHero);
    updatedHero['name'] = "${targetHero['name']}$nameSuffix";

    setUp(() async {
      await appPO.type(nameSuffix);
    });

    tearDown(() async {
      // Restore hero name
      await appPO.clear();
      await appPO.type(targetHero['name']);
    });

    test('name in list is updated', () {
      expect(appPO.selected, updatedHero);
    });

    test('name in details view is updated', () {
      expect(appPO.heroFromDetails, updatedHero);
    });
  });
}
