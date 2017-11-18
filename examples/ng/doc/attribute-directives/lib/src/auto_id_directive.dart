// #docregion
import 'dart:html';
import 'package:angular/angular.dart';

int _idCounter = 0;

@Directive(selector: '[autoId]')
void autoIdDirective(
  Element el,
  @Attribute('autoId') String prefix,
) {
  el.id = '$prefix${_idCounter++}';
}
// #enddocregion

/*
TODO: the original idea was to auto-generate a header ID from the header text,
as is sometimes done by markdown processors. We can't do that yet because the
text isn't accessible (no issue was open, it was only discussed via email).
A fix should be available as of 5.0.0-alpha+1.
Consider updating this example once this issue is fixed; i.e., if prefix is
empty then auto-generate the id from the text.
*/
