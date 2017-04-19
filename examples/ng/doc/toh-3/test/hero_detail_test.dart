// #docregion
@Tags(const ['aot'])
@TestOn('browser')

import 'package:angular2/angular2.dart';
import 'package:angular_test/angular_test.dart';
import 'package:angular_tour_of_heroes/hero.dart';
import 'package:angular_tour_of_heroes/hero_detail_component.dart';
import 'package:test/test.dart';

import 'hero_detail_po.dart';

const targetHero = const {'id': 1, 'name': 'Alice'};

NgTestFixture<HeroDetailComponent> fixture;
HeroDetailPO po;

@AngularEntrypoint()
void main() {
  final testBed = new NgTestBed<HeroDetailComponent>();

  tearDown(disposeAnyRunningTest);

  group('No hero:', () {
    setUp(() async {
      fixture = await testBed.create();
      po = await fixture.resolvePageObject(HeroDetailPO);
    });

    test('view is empty', () async {
      expect(fixture.rootElement.text.trim(), '');
    });
  });

  group('${targetHero['name']} hero:', () {
    setUp(() async {
      fixture = await testBed.create(
          beforeChangeDetection: (c) =>
              c.hero = new Hero(targetHero['id'], targetHero['name']));
      po = await fixture.resolvePageObject(HeroDetailPO);
    });

    test('shows hero details', () async {
      expect(await po.heroFromDetails, targetHero);
    });

    const nameSuffix = 'X';
    final updatedHero = new Map.from(targetHero);

    test('updates name', () async {
      updatedHero['name'] = "${targetHero['name']}$nameSuffix";
      await po.type(nameSuffix);
      expect(await po.heroFromDetails, updatedHero);
    });

    const newName = 'Bobbie';

    test('changes name', () async {
      updatedHero['name'] = newName;
      await po.clear();
      await po.type(newName);
      expect(await po.heroFromDetails, updatedHero);
    });

  });
}
