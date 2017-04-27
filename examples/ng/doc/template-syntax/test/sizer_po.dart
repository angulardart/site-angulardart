// #docregion
import 'dart:async';

import 'package:pageloader/objects.dart';

class SizerPO {
  @ByTagName('label')
  PageLoaderElement _fontSize;

  @ByTagName('button')
  List<PageLoaderElement> _buttons;

  Future dec() async {
    final dec = _buttons[0];
    assert('-' == await dec.visibleText);
    return dec.click();
  }

  Future inc() async {
    final inc = _buttons[1];
    assert('+' == await inc.visibleText);
    return inc.click();
  }

  Future<int/*?*/> get fontSizeFromLabelText async {
    final text = await _fontSize.visibleText;
    final matches = new RegExp((r'^FontSize: (\d+)px$')).firstMatch(text);
    return _toInt(matches[1]);
  }

  Future<int/*?*/> get fontSizeFromStyle async {
    final text = await _fontSize.attributes['style'];
    final matches = new RegExp((r'^font-size: (\d+)px;$')).firstMatch(text);
    return _toInt(matches[1]);
  }

  int /*?*/ _toInt(String s) => int.parse(s, onError: (_) => -1);
}
