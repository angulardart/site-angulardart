// #docregion
@Tags(const ['aot'])
@TestOn('browser')

import 'package:angular2/angular2.dart';
import 'package:angular2/platform/common.dart';
import 'package:angular2/router.dart';
import 'package:angular_test/angular_test.dart';
import 'package:angular_tour_of_heroes/src/hero_detail_component.dart';
import 'package:angular_tour_of_heroes/src/hero_service.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'hero_detail_po.dart';

NgTestFixture<HeroDetailComponent> fixture;
HeroDetailPO po;

class MockPlatformLocation extends Mock implements PlatformLocation {}

final mockPlatformLocation = new MockPlatformLocation();

@AngularEntrypoint()
void main() {
  final baseProviders = new List.from(ROUTER_PROVIDERS)
    ..addAll([
      provide(APP_BASE_HREF, useValue: '/'),
      provide(PlatformLocation, useValue: mockPlatformLocation),
      provide(RouteParams, useValue: new RouteParams({})),
      HeroService,
    ]);
  final testBed =
      new NgTestBed<HeroDetailComponent>().addProviders(baseProviders);

  tearDown(disposeAnyRunningTest);

  test('null initial @Input() hero has an empty view', () async {
    fixture = await testBed.create();
    expect(fixture.rootElement.text.trim(), '');
  });

  const targetHero = const {'id': 15, 'name': 'Magneta'};

  group('${targetHero['name']} initial @Input() hero:', () {
    final Map updatedHero = {'id': targetHero['id']};

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

    test('updates name', () async {
      const nameSuffix = 'X';
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
