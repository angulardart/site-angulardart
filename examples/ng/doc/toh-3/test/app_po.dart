// #docregion

import 'dart:async';

import 'package:pageloader/objects.dart';

class AppPO {
  @ByTagName('h1')
  PageLoaderElement _h1;

  @FirstByCss('h2')
  PageLoaderElement _h2;

  @ByTagName('li')
  List<PageLoaderElement> heroesLi;

  @ByTagName('li')
  @WithClass('selected')
  @optional
  PageLoaderElement _selectedLi;

  @FirstByCss('div h2')
  @optional
  PageLoaderElement _heroDetailsH2; // e.g. 'Mr Freeze details!'

  @FirstByCss('div div')
  @optional
  PageLoaderElement _heroDetailsIdDiv;

  @ByTagName('input')
  @optional
  PageLoaderElement _input;

  Future<String> get pageTitle => _h1.visibleText;
  Future<String> get tabTitle => _h2.visibleText;

  Iterable<Future<Map>> get heroes =>
      heroesLi.map((el) async => _heroDataFromLi(await el.visibleText));

  Future<Map> get selectedHero async => _selectedLi == null
      ? null
      : _heroDataFromLi(await _selectedLi.visibleText);

  Future<Map> get heroFromDetails async {
    if (_heroDetailsIdDiv == null) return null;
    final idAsString = (await _heroDetailsIdDiv.visibleText).split(' ')[1];
    final text = await _heroDetailsH2.visibleText;
    final matches = new RegExp((r'^(.*) details!$')).firstMatch(text);
    return _heroData(idAsString, matches[1]);
  }

  Future type(String s) => _input.type(s);

  Map<String, dynamic> _heroData(String idAsString, String name) =>
      {'id': int.parse(idAsString, onError: (_) => -1), 'name': name};

  Map<String, dynamic> _heroDataFromLi(String liText) {
    final matches = new RegExp((r'^(\d+) (.*)$')).firstMatch(liText);
    return _heroData(matches[1], matches[2]);
  }
}
