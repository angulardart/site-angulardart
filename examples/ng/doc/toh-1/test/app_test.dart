// #docregion
@TestOn('browser')
import 'dart:async';

import 'package:angular_test/angular_test.dart';
import 'package:angular_tour_of_heroes/app_component.dart';
import 'package:angular_tour_of_heroes/app_component.template.dart' as ng;
import 'package:pageloader/objects.dart';
import 'package:test/test.dart';

import 'app_test.template.dart' as ng;

// #docregion AppPO, AppPO-initial, AppPO-hero, AppPO-input
class AppPO extends PageObjectBase {
  // #enddocregion AppPO-hero, AppPO-input
  @ByTagName('h1')
  PageLoaderElement get _title => q('h1');
  // #enddocregion AppPO-initial

  // #docregion AppPO-hero
  @FirstByCss('div')
  PageLoaderElement get _id => q('div'); // e.g. 'id: 1'

  @ByTagName('h2')
  PageLoaderElement get _heroName => q('h2');
  // #enddocregion AppPO-hero

  // #docregion AppPO-input
  @ByTagName('input')
  PageLoaderElement get _input => q('input');
  // #enddocregion AppPO-input

  // #docregion AppPO-initial
  Future<String> get title => _title.visibleText;
  // #enddocregion AppPO-initial

  // #docregion AppPO-hero
  Future<int> get heroId async {
    final idAsString = (await _id.visibleText).split(':')[1];
    return int.parse(idAsString, onError: (_) => -1);
  }

  Future<String> get heroName => _heroName.visibleText;
  // #enddocregion AppPO-hero

  // #docregion AppPO-input
  Future type(String s) => _input.type(s);
  // #docregion AppPO-initial, AppPO-hero
}
// #enddocregion AppPO, AppPO-initial, AppPO-hero, AppPO-input

void main() {
  // #docregion appPO-setup
  final testBed =
      NgTestBed.forComponent<AppComponent>(ng.AppComponentNgFactory);
  NgTestFixture<AppComponent> fixture;
  AppPO appPO;

  setUp(() async {
    fixture = await testBed.create();
    appPO = await new AppPO().resolve(fixture);
  });
  // #enddocregion appPO-setup

  tearDown(disposeAnyRunningTest);

  // #docregion title
  test('title', () async {
    expect(await appPO.title, 'Tour of Heroes');
  });
  // #enddocregion title

  // #docregion hero
  const windstormData = const <String, dynamic>{'id': 1, 'name': 'Windstorm'};

  test('initial hero properties', () async {
    expect(await appPO.heroId, windstormData['id']);
    expect(await appPO.heroName, windstormData['name']);
  });
  // #enddocregion hero

  // #docregion update-name
  const nameSuffix = 'X';

  test('update hero name', () async {
    await appPO.type(nameSuffix);
    expect(await appPO.heroId, windstormData['id']);
    expect(await appPO.heroName, windstormData['name'] + nameSuffix);
  });
  // #enddocregion update-name
}
