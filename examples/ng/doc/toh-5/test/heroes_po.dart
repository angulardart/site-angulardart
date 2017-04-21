// #docregion
import 'dart:async';

import 'package:pageloader/objects.dart';

class HeroesPO {
  @FirstByCss('h2')
  PageLoaderElement _h2;

  @ByTagName('li')
  List<PageLoaderElement> _heroesLi;

  @ByTagName('li')
  @WithClass('selected')
  @optional
  PageLoaderElement _selectedLi;

  @FirstByCss('div h2')
  @optional
  PageLoaderElement _miniDetailH2;

  @ByTagName('button')
  @optional
  PageLoaderElement _button;

  Future<String> get title => _h2.visibleText;

  Iterable<Future<Map>> get heroes =>
      _heroesLi.map((el) async => _heroDataFromLi(await el.visibleText));

  Future clickHero(int index) => _heroesLi[index].click();

  Future<Map> get selectedHero async => _selectedLi == null
      ? null
      : _heroDataFromLi(await _selectedLi.visibleText);

  Future<String> get myHeroNameInUppercase async {
    if(_miniDetailH2 == null) return null;
    final text = await _miniDetailH2.visibleText;
    final matches = new RegExp((r'^(.*) is my hero\s*$')).firstMatch(text);
    return matches[1];
  }

  Future<Null> gotoDetail() => _button.click();

  Map<String, dynamic> _heroData(String idAsString, String name) =>
      {'id': int.parse(idAsString, onError: (_) => -1), 'name': name};

  Map<String, dynamic> _heroDataFromLi(String liText) {
    final matches = new RegExp((r'^(\d+) (.*)$')).firstMatch(liText);
    return _heroData(matches[1], matches[2]);
  }
}
