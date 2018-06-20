@TestOn('browser')

import 'package:angular_test/angular_test.dart';
import 'package:angular_tour_of_heroes/app_component.dart';
import 'package:angular_tour_of_heroes/app_component.template.dart' as ng;
import 'package:pageloader/html.dart';
import 'package:test/test.dart';

import 'app_po.dart';

void main() {
  // #docregion appPO-setup
  final testBed =
      NgTestBed.forComponent<AppComponent>(ng.AppComponentNgFactory);
  NgTestFixture<AppComponent> fixture;
  AppPO appPO;

  setUp(() async {
    fixture = await testBed.create();
    final context =
        HtmlPageLoaderElement.createFromElement(fixture.rootElement);
    appPO = AppPO.create(context);
  });
  // #enddocregion appPO-setup

  tearDown(disposeAnyRunningTest);

  // #docregion title
  test('title', () {
    expect(appPO.title, 'Tour of Heroes');
  });
  // #enddocregion title

  // #docregion hero
  const windstormData = <String, dynamic>{'id': 1, 'name': 'Windstorm'};

  test('initial hero properties', () {
    expect(appPO.heroId, windstormData['id']);
    expect(appPO.heroName, windstormData['name']);
  });
  // #enddocregion hero

  // #docregion update-name
  const nameSuffix = 'X';

  test('update hero name', () async {
    await appPO.type(nameSuffix);
    expect(appPO.heroId, windstormData['id']);
    expect(appPO.heroName, windstormData['name'] + nameSuffix);
  });
  // #enddocregion update-name
}
