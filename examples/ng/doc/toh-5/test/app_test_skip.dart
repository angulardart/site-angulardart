// WIP - experiments, trying to get around lack of bootstrap()
// #docregion
@Tags(const ['aot'])
@TestOn('browser')

import 'package:angular2/angular2.dart';
import 'package:angular2/router.dart';
import 'package:angular_test/angular_test.dart';
import 'package:angular_tour_of_heroes/app_component.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'app_po.dart';

NgTestFixture<AppComponent> fixture;
AppPO appPO;

@Injectable()
class MockRouter extends Mock implements Router {}

final mockRouter = new MockRouter();
@Component(selector: 'my-mock')
class MockComponent {}

@AngularEntrypoint()
void main() {
  final mockRoot = new MockComponent();
  final routerReg = new RouteRegistry(mockRoot);
  final router = new Router(routerReg, null, mockRoot);
  final providers = new List.from(ROUTER_PROVIDERS)
  ..addAll([
    provide(Router, useValue: router),
    provide(ROUTER_PRIMARY_COMPONENT, useValue: mockRoot),
  ]);

  final testBed = new NgTestBed<AppComponent>().addProviders(providers);

  setUp(() async {
    fixture = await testBed.create();
    appPO = await fixture.resolvePageObject(AppPO);
  });

  tearDown(disposeAnyRunningTest);

  group('Basics:', basicTests);
}

void basicTests() {
  test('page title', () async {
    expect(await appPO.pageTitle, 'Tour of Heroes');
  });

  test('tab titles', () async {
    final expectTitles = ['Dashboard', 'Heroes'];
    expect(await appPO.tabTitles, expectTitles);
  });
}
