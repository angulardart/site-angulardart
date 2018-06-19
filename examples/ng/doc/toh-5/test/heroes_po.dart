import 'dart:async';

import 'package:pageloader/pageloader.dart';
import 'utils.dart';

part 'heroes_po.g.dart';

@PageObject()
abstract class HeroesPO {
  HeroesPO();
  factory HeroesPO.create(PageLoaderElement context) = $HeroesPO.create;

  @First(ByCss('h2'))
  PageLoaderElement get _title;

  @ByTagName('li')
  List<PageLoaderElement> get _heroes;

  @ByTagName('li')
  @WithClass('selected')
  PageLoaderElement get _selected;

  @First(ByCss('div h2'))
  PageLoaderElement get _miniDetailHeading;

  @ByTagName('button')
  PageLoaderElement get _gotoDetail;

  String get title => _title.visibleText;

  Iterable<Map> get heroes =>
      _heroes.map((el) => _heroDataFromLi(el.visibleText));

  Future<void> selectHero(int index) => _heroes[index].click();

  Map get selected =>
      _selected.exists ? _heroDataFromLi(_selected.visibleText) : null;

  String get myHeroNameInUppercase {
    if (!_miniDetailHeading.exists) return null;
    final text = _miniDetailHeading.visibleText;
    final matches = RegExp((r'^\s*(.+) is my hero\s*$')).firstMatch(text);
    return matches[1];
  }

  Future<void> gotoDetail() => _gotoDetail.click();

  Map<String, dynamic> _heroDataFromLi(String liText) {
    final matches = RegExp((r'^(\d+) (.*)$')).firstMatch(liText);
    return heroData(matches[1], matches[2]);
  }
}
