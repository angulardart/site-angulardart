import 'dart:async';
import 'dart:html';

import 'package:angular/angular.dart';

@Directive(selector: '[myClick]')
class ClickDirective {
  // #docregion output-myClick
  final _onClick = StreamController<String>();
  // @Output(alias) propertyName = ...
  @Output('myClick')
  Stream<String> get clicks => _onClick.stream;

  // #enddocregion output-myClick
  bool _toggle = false;

  ClickDirective(Element el) {
    el.onClick.listen((Event e) {
      _toggle = !_toggle;
      _onClick.add(_toggle ? 'Click!' : '');
    });
  }
}

@Directive(selector: '[myClick2]')
class ClickDirective2 {
  final _onClick = StreamController<String>();
  @Output('myClick')
  Stream<String> get clicks => _onClick.stream;
  bool _toggle = false;

  ClickDirective2(Element el) {
    el.onClick.listen((Event e) {
      _toggle = !_toggle;
      _onClick.add(_toggle ? 'Click2!' : '');
    });
  }
}
