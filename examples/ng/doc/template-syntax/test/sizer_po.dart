// #docregion
import 'dart:async';

import 'package:pageloader/objects.dart';

class SizerPO {
  @ByTagName('label')
  PageLoaderElement _fontSize;

  @ByTagName('button')
  @WithVisibleText('-')
  PageLoaderElement _dec;

  @ByTagName('button')
  @WithVisibleText('+')
  PageLoaderElement _inc;

  Future dec() async => _dec.click();
  Future inc() async => _inc.click();

  Future<int /*?*/ > get fontSizeFromLabelText async {
    final text = await _fontSize.visibleText;
    final matches = new RegExp((r'^FontSize: (\d+)px$')).firstMatch(text);
    return _toInt(matches[1]);
  }

  Future<int /*?*/ > get fontSizeFromStyle async {
    final text = await _fontSize.attributes['style'];
    final matches = new RegExp((r'^font-size: (\d+)px;$')).firstMatch(text);
    return _toInt(matches[1]);
  }

  int /*?*/ _toInt(String s) => int.parse(s, onError: (_) => -1);
}
