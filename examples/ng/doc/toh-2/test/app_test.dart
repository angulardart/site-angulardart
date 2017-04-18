// #docregion
@Tags(const ['aot'])
@TestOn('browser')

import 'package:angular2/angular2.dart';
import 'package:angular_test/angular_test.dart';
import 'package:angular_tour_of_heroes/app_component.dart';
import 'package:test/test.dart';

import 'app_po.dart';

const targetHero = const {'id': 16, 'name': 'RubberMan'};

NgTestFixture<AppComponent> fixture;
AppPO appPO;

@AngularEntrypoint()
void main() {
  final testBed = new NgTestBed<AppComponent>();

  setUpAll(() async {
    fixture = await testBed.create();
    appPO = await fixture.resolvePageObject(AppPO);
  });

  tearDownAll(disposeAnyRunningTest);

  group('Basics:', basicTests);

  test('Select ${targetHero['name']}', () async {
    await appPO.heroesLi[5].click();
    // Nothing specific to expect here other than lack of exceptions.
  });

  group('Selected hero:', selectedHeroTests);
}

void basicTests() {
  test('page title', () async {
    expect(await appPO.pageTitle, 'Tour of Heroes');
  });

  test('tab title', () async {
    expect(await appPO.tabTitle, 'My Heroes');
  });

  test('hero count', () async {
    expect(appPO.heroes.length, 10);
  });

  test('no selected hero', () async {
    expect(await appPO.selectedHero, null);
  });
}

void selectedHeroTests() {
  setUp(() async {
    appPO = await fixture.resolvePageObject(AppPO); // Refresh PO
  });

  test('is selected', () async {
    expect(await appPO.selectedHero, targetHero);
  });

  test('shows hero details', () async {
    expect(await appPO.heroFromDetails, targetHero);
  });

  const nameSuffix = 'X';
  final updatedHero = new Map.from(targetHero);
  updatedHero['name'] = "${targetHero['name']}$nameSuffix";

  test('can update hero name', () async {
    await appPO.type(nameSuffix);
    // Nothing specific to expect here other than lack of exceptions.
  });

  test('updates name in list', () async {
    expect(await appPO.selectedHero, updatedHero);
  });

  test('updates name in details view', () async {
    expect(await appPO.heroFromDetails, updatedHero);
  });
}
