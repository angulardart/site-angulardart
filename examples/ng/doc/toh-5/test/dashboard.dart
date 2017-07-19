// #docregion
@Tags(const ['aot'])
@TestOn('browser')

import 'package:angular2/angular2.dart';
import 'package:angular2/platform/common.dart';
import 'package:angular2/router.dart';
import 'package:angular_test/angular_test.dart';
import 'package:angular_tour_of_heroes/app_component.dart';
import 'package:angular_tour_of_heroes/src/dashboard_component.dart';
import 'package:angular_tour_of_heroes/src/hero_service.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'dashboard_po.dart';

// #docregion providers-with-context
NgTestFixture<DashboardComponent> fixture;
DashboardPO po;

final mockPlatformLocation = new MockPlatformLocation();

class MockPlatformLocation extends Mock implements PlatformLocation {}

@AngularEntrypoint()
void main() {
  final providers = new List.from(ROUTER_PROVIDERS)
    ..addAll([
      provide(APP_BASE_HREF, useValue: '/'),
      provide(PlatformLocation, useValue: mockPlatformLocation),
      provide(ROUTER_PRIMARY_COMPONENT, useValue: AppComponent),
      HeroService,
    ]);
  final testBed = new NgTestBed<DashboardComponent>().addProviders(providers);
  // #enddocregion providers-with-context

  // #docregion setUpAll
  setUpAll(() async {
    when(mockPlatformLocation.pathname).thenReturn('');
    when(mockPlatformLocation.search).thenReturn('');
    when(mockPlatformLocation.hash).thenReturn('');
    when(mockPlatformLocation.getBaseHrefFromDOM()).thenReturn('');
  });
  // #enddocregion setUpAll

  setUp(() async {
    fixture = await testBed.create();
    po = await fixture.resolvePageObject(DashboardPO);
  });

  tearDown(disposeAnyRunningTest);

  test('title', () async {
    expect(await po.title, 'Top Heroes');
  });

  test('show top heroes', () async {
    final expectedNames = ['Narco', 'Bombasto', 'Celeritas', 'Magneta'];
    expect(await po.heroNames, expectedNames);
  });

  // #docregion go-to-detail
  test('select hero and navigate to detail', () async {
    clearInteractions(mockPlatformLocation);
    await po.selectHero(3);
    final c = verify(mockPlatformLocation.pushState(any, any, captureAny));
    expect(c.captured.single, '/detail/15');
  });
  // #enddocregion go-to-detail
  // #docregion providers-with-context
}
