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

  // #docregion _heroes, selectHero
  @ByTagName('li')
  List<PageLoaderElement> get _heroes;
  // #enddocregion _heroes, selectHero

  // #docregion _selected
  @ByTagName('li')
  @WithClass('selected')
  PageLoaderElement get _selected;
  // #enddocregion _selected

  // #docregion hero-detail-heading
  @First(ByCss('div h2'))
  PageLoaderElement get _heroDetailHeading;
  // #enddocregion hero-detail-heading

  // #docregion hero-detail-ID
  @First(ByCss('div div'))
  PageLoaderElement get _heroDetailId;
  // #enddocregion hero-detail-ID

  @ByTagName('input')
  PageLoaderElement get _input;

  String get pageTitle => _pageTitle.visibleText;
  String get tabTitle => _tabTitle.visibleText;

  // #docregion heroes
  Iterable<Map> get heroes =>
      _heroes.map((el) => _heroDataFromLi(el.visibleText));

  // #enddocregion heroes
  // #docregion selectHero
  Future<void> selectHero(int index) => _heroes[index].click();
  // #enddocregion selectHero

  // #docregion selected
  Map get selected =>
      _selected.exists ? _heroDataFromLi(_selected.visibleText) : null;
  // #enddocregion selected

  // #docregion heroFromDetails
  Map get heroFromDetails {
    if (!_heroDetailId.exists) return null;
    // #enddocregion heroFromDetails
    final idAsString = _heroDetailId.visibleText.split(':')[1];
    return _heroData(idAsString, _heroDetailHeading.visibleText);
    // #docregion heroFromDetails
  }
  // #enddocregion heroFromDetails

  // #docregion clear
  Future<void> clear() => _input.clear();
  // #enddocregion clear
  Future<void> type(String s) => _input.type(s);

  Map<String, dynamic> _heroData(String idAsString, String name) =>
      {'id': int.tryParse(idAsString) ?? -1, 'name': name};

  // #docregion heroes
  Map<String, dynamic> _heroDataFromLi(String liText) {
    final matches = RegExp((r'^(\d+) (.*)$')).firstMatch(liText);
    return _heroData(matches[1], matches[2]);
  }
  // #enddocregion heroes
}
