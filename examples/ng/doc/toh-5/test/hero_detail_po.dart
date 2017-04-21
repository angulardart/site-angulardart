// #docregion
import 'dart:async';

import 'package:pageloader/objects.dart';

class HeroDetailPO {
  @FirstByCss('div h2')
  @optional
  PageLoaderElement _heroDetailsH2; // e.g. 'Mr Freeze details!'

  @FirstByCss('div div')
  @optional
  PageLoaderElement _heroDetailsIdDiv;

  @ByTagName('input')
  @optional
  PageLoaderElement _input;

  @ByTagName('button')
  @optional
  PageLoaderElement _button;

  Future<Map> get heroFromDetails async {
    if (_heroDetailsIdDiv == null) return null;
    final idAsString = (await _heroDetailsIdDiv.visibleText).split(' ')[1];
    final text = await _heroDetailsH2.visibleText;
    final matches = new RegExp((r'^(.*) details!$')).firstMatch(text);
    return _heroData(idAsString, matches[1]);
  }

  Future type(String s) => _input.type(s);
  Future clear() => _input.clear();

  Future back() => _button.click();

  Map<String, dynamic> _heroData(String idAsString, String name) =>
      {'id': int.parse(idAsString, onError: (_) => -1), 'name': name};
}
