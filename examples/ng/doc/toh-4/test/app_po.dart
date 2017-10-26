import 'dart:async';

import 'package:pageloader/objects.dart';

class AppPO {
  @ByTagName('h1')
  PageLoaderElement _pageTitle;

  @FirstByCss('h2')
  PageLoaderElement _tabTitle;

  @ByTagName('li')
  List<PageLoaderElement> _heroes;

  @ByTagName('li')
  @WithClass('selected')
  @optional
  PageLoaderElement _selectedHero;

  @FirstByCss('div h2')
  @optional
  PageLoaderElement _heroDetailHeading; // e.g. 'Mr Freeze details!'

  @FirstByCss('div div')
  @optional
  PageLoaderElement _heroDetailId;

  @ByTagName('input')
  @optional
  PageLoaderElement _input;

  Future<String> get pageTitle => _pageTitle.visibleText;
  Future<String> get tabTitle => _tabTitle.visibleText;

  Iterable<Future<Map>> get heroes =>
      _heroes.map((el) async => _heroDataFromLi(await el.visibleText));

  Future selectHero(int index) => _heroes[index].click();

  Future<Map> get selectedHero async => _selectedHero == null
      ? null
      : _heroDataFromLi(await _selectedHero.visibleText);

  Future<Map> get heroFromDetails async {
    if (_heroDetailId == null) return null;
    final idAsString = (await _heroDetailId.visibleText).split(':')[1];
    final text = await _heroDetailHeading.visibleText;
    final matches = new RegExp((r'^(.*) details!$')).firstMatch(text);
    return _heroData(idAsString, matches[1]);
  }

  Future clear() => _input.clear();
  Future type(String s) => _input.type(s);

  Map<String, dynamic> _heroData(String idAsString, String name) =>
      {'id': int.parse(idAsString, onError: (_) => -1), 'name': name};

  Map<String, dynamic> _heroDataFromLi(String liText) {
    final matches = new RegExp((r'^(\d+) (.*)$')).firstMatch(liText);
    return _heroData(matches[1], matches[2]);
  }
}
