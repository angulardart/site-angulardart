// #docregion
@Tags(const ['aot'])
@TestOn('browser')
import 'dart:async';

import 'package:angular/angular.dart';
import 'package:angular_test/angular_test.dart';
import 'package:angular_tour_of_heroes/app_component.dart';
import 'package:pageloader/objects.dart';
import 'package:test/test.dart';

// #docregion AppPO, AppPO-initial, AppPO-hero, AppPO-input
class AppPO {
  // #enddocregion AppPO-hero, AppPO-input
  @ByTagName('h1')
  PageLoaderElement _title;
  // #enddocregion AppPO-initial

  // #docregion AppPO-hero
  @FirstByCss('div')
  PageLoaderElement _id; // e.g. 'id: 1'

  @ByTagName('h2')
  PageLoaderElement _heroName; // e.g. 'Mr Freeze details!'
  // #enddocregion AppPO-hero

  // #docregion AppPO-input
  @ByTagName('input')
  PageLoaderElement _input;
  // #enddocregion AppPO-input

  // #docregion AppPO-initial
  Future<String> get title => _title.visibleText;
  // #enddocregion AppPO-initial

  // #docregion AppPO-hero
  Future<int> get heroId async {
    final idAsString = (await _id.visibleText).split(' ')[1];
    return int.parse(idAsString, onError: (_) => -1);
  }

  Future<String> get heroName async {
    final text = await _heroName.visibleText;
    return text.substring(0, text.lastIndexOf(' '));
  }
  // #enddocregion AppPO-hero

  // #docregion AppPO-input
  Future type(String s) => _input.type(s);
  // #docregion AppPO-initial, AppPO-hero
}
// #enddocregion AppPO, AppPO-initial, AppPO-hero, AppPO-input

@AngularEntrypoint()
void main() {
  // #docregion appPO-setup
  final testBed = new NgTestBed<AppComponent>();
  NgTestFixture<AppComponent> fixture;
  AppPO appPO;

  setUp(() async {
    fixture = await testBed.create();
    appPO = await fixture.resolvePageObject(AppPO);
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
