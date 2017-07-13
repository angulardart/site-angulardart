// #docregion
import 'dart:async';

import 'package:pageloader/objects.dart';
import 'utils.dart';

class HeroDetailPO {
  @FirstByCss('div h2')
  PageLoaderElement _title; // e.g. 'Mr Freeze details!'

  @FirstByCss('div div')
  PageLoaderElement _id;

  @ByTagName('input')
  PageLoaderElement _input;

  // #docregion back-button
  @ByTagName('button')
  PageLoaderElement _button;
  // #enddocregion back-button

  Future<Map> get heroFromDetails async {
    if (_id == null) return null;
    final idAsString = (await _id.visibleText).split(' ')[1];
    final text = await _title.visibleText;
    final matches = new RegExp((r'^(.*) details!$')).firstMatch(text);
    return heroData(idAsString, matches[1]);
  }

  Future clear() => _input.clear();
  Future type(String s) => _input.type(s);

  // #docregion back-button
  Future back() => _button.click();
  // #enddocregion back-button
}
