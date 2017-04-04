@Tags(const ['aot'])
@TestOn('browser')
import 'dart:async';

import 'package:angular2/angular2.dart';
import 'package:angular_test/angular_test.dart';
import 'package:angular_tour_of_heroes/app_component.dart';
import 'package:pageloader/objects.dart';
import 'package:test/test.dart';

const expectedH1 = 'Tour of Heroes';
const expectedId = 1;
const expectedName = 'Windstorm';
const nameSuffix = 'X';

class AppPO {
  @ByTagName('h1')
  PageLoaderElement _h1;

  @FirstByCss('div')
  PageLoaderElement _div1; // e.g. 'id: 1'

  @ByTagName('h2')
  PageLoaderElement _h2; // e.g. 'Mr Freeze details!'

  @ByTagName('input')
  PageLoaderElement _input;

  Future<String> get title => _h1.visibleText;

  Future<int> get heroId async {
    final idAsString = (await _div1.visibleText).split(' ')[1];
    return int.parse(idAsString, onError: (_) => -1);
  }

  Future<String> get heroName async {
    final text = await _h2.visibleText;
    return text.substring(0, text.lastIndexOf(' '));
  }

  Future<Null> type(String s) => _input.type(s);
}

@AngularEntrypoint()
void main() {
  final testBed = new NgTestBed<AppComponent>();
  NgTestFixture<AppComponent> fixture;
  AppPO appPO;

  setUp(() async {
    fixture = await testBed.create();
    appPO = await fixture.resolvePageObject(AppPO);
  });

  tearDown(disposeAnyRunningTest);

  test('title', () async {
    expect(await appPO.title, expectedH1);
  });

  test('initial hero properties', () async {
    expect(await appPO.heroId, expectedId);
    expect(await appPO.heroName, expectedName);
  });

  test('update hero name', () async {
    await appPO.type(nameSuffix);
    expect(await appPO.heroId, expectedId);
    expect(await appPO.heroName, expectedName + nameSuffix);
  });
}
