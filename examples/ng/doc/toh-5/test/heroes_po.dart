import 'dart:async';

import 'package:pageloader/objects.dart';
import 'utils.dart';

class HeroesPO {
  @FirstByCss('h2')
  PageLoaderElement _title;

  @ByTagName('li')
  List<PageLoaderElement> _heroes;

  @ByTagName('li')
  @WithClass('selected')
  @optional
  PageLoaderElement _selectedHero;

  @FirstByCss('div h2')
  @optional
  PageLoaderElement _miniDetailHeading;

  @ByTagName('button')
  @optional
  PageLoaderElement _gotoDetail;

  Future<String> get title => _title.visibleText;

  Iterable<Future<Map>> get heroes =>
      _heroes.map((el) async => _heroDataFromLi(await el.visibleText));

  Future selectHero(int index) => _heroes[index].click();

  Future<Map> get selectedHero async => _selectedHero == null
      ? null
      : _heroDataFromLi(await _selectedHero.visibleText);

  Future<String> get myHeroNameInUppercase async {
    if (_miniDetailHeading == null) return null;
    final text = await _miniDetailHeading.visibleText;
    final matches = new RegExp((r'^(.*) is my hero\s*$')).firstMatch(text);
    return matches[1];
  }

  Future<Null> gotoDetail() => _gotoDetail.click();

  Map<String, dynamic> _heroDataFromLi(String liText) {
    final matches = new RegExp((r'^(\d+) (.*)$')).firstMatch(liText);
    return heroData(matches[1], matches[2]);
  }
}
