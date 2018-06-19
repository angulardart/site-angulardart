import 'dart:async';

import 'package:pageloader/pageloader.dart';

part 'app_po.g.dart';

@PageObject()
abstract class AppPO {
  AppPO();
  factory AppPO.create(PageLoaderElement context) = $AppPO.create;

  @ByTagName('h1')
  PageLoaderElement get _pageTitle;

  @First(ByCss('h2'))
  PageLoaderElement get _tabTitle;

  @ByTagName('li')
  List<PageLoaderElement> get _heroes;

  @ByTagName('li')
  @WithClass('selected')
  PageLoaderElement get _selected;

  @First(ByCss('div h2'))
  PageLoaderElement get _heroDetailHeading;

  @First(ByCss('div div'))
  PageLoaderElement get _heroDetailId;

  @ByTagName('input')
  PageLoaderElement get _input;

  String get pageTitle => _pageTitle.visibleText;
  String get tabTitle => _tabTitle.visibleText;

  Iterable<Map> get heroes =>
      _heroes.map((el) => _heroDataFromLi(el.visibleText));

  Future<void> selectHero(int index) => _heroes[index].click();

  Map get selected =>
      _selected.exists ? _heroDataFromLi(_selected.visibleText) : null;

  Map get heroFromDetails {
    if (!_heroDetailId.exists) return null;
    final idAsString = _heroDetailId.visibleText.split(':')[1];
    return _heroData(idAsString, _heroDetailHeading.visibleText);
  }

  Future<void> clear() => _input.clear();
  Future<void> type(String s) => _input.type(s);

  Map<String, dynamic> _heroData(String idAsString, String name) =>
      {'id': int.tryParse(idAsString) ?? -1, 'name': name};

  Map<String, dynamic> _heroDataFromLi(String liText) {
    final matches = RegExp((r'^(\d+) (.*)$')).firstMatch(liText);
    return _heroData(matches[1], matches[2]);
  }
}
