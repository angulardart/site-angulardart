import 'dart:async';

import 'package:pageloader/pageloader.dart';

part 'sizer_po.g.dart';

@PageObject()
abstract class SizerPO {
  SizerPO();
  factory SizerPO.create(PageLoaderElement context) = $SizerPO.create;

  @ByTagName('label')
  PageLoaderElement get _fontSize;

  @ByTagName('button')
  @WithVisibleText('-')
  PageLoaderElement get _dec;

  @ByTagName('button')
  @WithVisibleText('+')
  PageLoaderElement get _inc;

  Future<void> dec() async => _dec.click();
  Future<void> inc() async => _inc.click();

  int get fontSizeFromLabelText {
    final text = _fontSize.visibleText;
    final matches = RegExp((r'^FontSize: (\d+)px$')).firstMatch(text);
    return _toInt(matches[1]);
  }

  int get fontSizeFromStyle {
    final text = _fontSize.attributes['style'];
    final matches = RegExp((r'^font-size: (\d+)px;$')).firstMatch(text);
    return _toInt(matches[1]);
  }

  int _toInt(String s) => int.tryParse(s) ?? -1;
}
