// #docregion
@Tags(const ['aot'])
@TestOn('browser')

import 'package:angular2/angular2.dart';
import 'package:angular2/platform/common.dart';
import 'package:angular2/router.dart';
import 'package:angular_test/angular_test.dart';
import 'package:angular_tour_of_heroes/hero_detail_component.dart';
import 'package:angular_tour_of_heroes/hero_service.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'hero_detail_po.dart';

const targetHero = const {'id': 15, 'name': 'Magneta'};

NgTestFixture<HeroDetailComponent> fixture;
HeroDetailPO po;

class MockPlatformLocation extends Mock implements PlatformLocation {}
final mockPlatformLocation = new MockPlatformLocation();

@AngularEntrypoint()
void main() {
  final baseProviders = new List.from(ROUTER_PROVIDERS)
    ..add(provide(APP_BASE_HREF, useValue: '/'))
    ..add(HeroService)
    ..add(provide(PlatformLocation, useValue: mockPlatformLocation))
    ..add(provide(RouteParams, useValue: new RouteParams({})));
  final testBed =
      new NgTestBed<HeroDetailComponent>().addProviders(baseProviders);

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
      final groupTestBed = testBed.fork().addProviders([
        provide(RouteParams, useValue: new RouteParams({'id': '15'}))
      ]);
      fixture = await groupTestBed.create();
      po = await fixture.resolvePageObject(HeroDetailPO);
    });

    test('shows hero details', () async {
      expect(await po.heroFromDetails, targetHero);
    });

    const nameSuffix = 'X';

    test('updates name', () async {
      final updatedHero = new Map.from(targetHero);
      updatedHero['name'] = "${targetHero['name']}$nameSuffix";
      await po.type(nameSuffix);
      expect(await po.heroFromDetails, updatedHero);
    });

    test('back button', () async {
      await po.back();
      verify(mockPlatformLocation.back());
    });
  });
}
