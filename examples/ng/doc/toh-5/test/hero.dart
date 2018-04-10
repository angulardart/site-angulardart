@TestOn('browser')

import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';
import 'package:angular_test/angular_test.dart';
import 'package:angular_tour_of_heroes/src/route_paths.dart' show idParam;
import 'package:angular_tour_of_heroes/src/hero_component.dart';
import 'package:angular_tour_of_heroes/src/hero_service.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'hero_po.dart';
import 'utils.dart';

NgTestFixture<HeroComponent> fixture;
HeroDetailPO po;

/// HeroDetail is simple enough that it can be tested without a router.
/// Instead we only mock Location.
void main() {
  final injector = new InjectorProbe();
  final testBed = new NgTestBed<HeroComponent>().addProviders([
    const ClassProvider(HeroService),
    const ClassProvider(Location, useClass: MockLocation),
  ]).addInjector(injector.init);

  setUp(() async {
    fixture = await testBed.create();
  });

  tearDown(disposeAnyRunningTest);

  test('No initial hero results in an empty view', () async {
    expect(fixture.rootElement.text.trim(), '');
  });

  const targetHero = {idParam: 15, 'name': 'Magneta'};

  group('${targetHero['name']} initial hero:', () {
    final Map updatedHero = {idParam: targetHero[idParam]};

    final mockRouterState = new MockRouterState();
    when(mockRouterState.parameters)
        .thenReturn({idParam: '${targetHero[idParam]}'});

    setUp(() async {
      await fixture.update((c) => c.onActivate(null, mockRouterState));
      po = await new HeroDetailPO().resolve(fixture);
    });

    test('show hero details', () async {
      expect(await po.heroFromDetails, targetHero);
    });

    test('updates name', () async {
      const nameSuffix = 'X';
      updatedHero['name'] = "${targetHero['name']}$nameSuffix";
      await po.type(nameSuffix);
      expect(await po.heroFromDetails, updatedHero);
    });

    test('back button', () async {
      final mockLocation = injector.get<MockLocation>(Location);
      clearInteractions(mockLocation);
      await po.back();
      verify(mockLocation.back());
    });
  });
}

@Injectable()
class MockLocation extends Mock implements Location {}

class MockRouterState extends Mock implements RouterState {}
