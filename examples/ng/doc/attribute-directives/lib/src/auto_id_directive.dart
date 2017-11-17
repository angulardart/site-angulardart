import 'dart:html';
import 'package:angular/angular.dart';

int _idCounter = 0;

@Directive(selector: '[autoId]')
void autoIdDirective(Element el) {
  el.id = 'heading-${_idCounter++}';
}
