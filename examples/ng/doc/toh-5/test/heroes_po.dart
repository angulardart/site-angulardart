import 'dart:async';

import 'package:pageloader/objects.dart';
import 'utils.dart';

class HeroesPO extends PageObjectBase {
  @FirstByCss('h2')
  PageLoaderElement get _title => q('h2');

  @ByTagName('li')
  List<PageLoaderElement> get _heroes => qq('li');

  @ByTagName('li')
  @WithClass('selected')
  @optional
  PageLoaderElement get _selected => q('li.selected');

  @FirstByCss('div h2')
  @optional
  PageLoaderElement get _miniDetailHeading => q('div h2');

  @ByTagName('button')
  @optional
  PageLoaderElement get _gotoDetail => q('button');

  Future<String> get title => _title.visibleText;

  Iterable<Future<Map>> get heroes =>
      _heroes.map((el) async => _heroDataFromLi(await el.visibleText));

  Future selectHero(int index) => _heroes[index].click();

  Future<Map> get selected async => _selected == null
      ? null
      : _heroDataFromLi(await _selected.visibleText);

  Future<String> get myHeroNameInUppercase async {
    if (_miniDetailHeading == null) return null;
    final text = await _miniDetailHeading.visibleText;
    final matches = new RegExp((r'^(.*) is my hero\s*$')).firstMatch(text);
    return matches[1];
  }

  Future<void> gotoDetail() => _gotoDetail.click();

  Map<String, dynamic> _heroDataFromLi(String liText) {
    final matches = new RegExp((r'^(\d+) (.*)$')).firstMatch(liText);
    return heroData(matches[1], matches[2]);
  }
}
