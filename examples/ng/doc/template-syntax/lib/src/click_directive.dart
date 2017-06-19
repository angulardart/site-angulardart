// #docplaster
import 'dart:async';
import 'dart:html';

import 'package:angular2/angular2.dart';

@Directive(selector: '[myClick]')
class ClickDirective {
  // #docregion output-myClick
  final _onClick = new StreamController<String>();
  // @Output(alias) propertyName = ...
  @Output('myClick')
  Stream<String> get clicks => _onClick.stream;

  // #enddocregion output-myClick
  bool _toggle = false;

  ClickDirective(ElementRef el) {
    Element nativeEl = el.nativeElement;
    nativeEl.onClick.listen((Event e) {
      _toggle = !_toggle;
      _onClick.add(_toggle ? 'Click!' : '');
    });
  }
}

// #docregion output-myClick2
@Directive(
  // #enddocregion output-myClick2
  selector: '[myClick2]',
  // #docregion output-myClick2
  // ...
  outputs: const ['clicks:myClick'], // propertyName:alias
)
// #enddocregion output-myClick2
class ClickDirective2 {
  final _onClick = new StreamController<String>();
  Stream<String> get clicks => _onClick.stream;
  bool _toggle = false;

  ClickDirective2(ElementRef el) {
    el.nativeElement.onClick.listen((Event e) {
      _toggle = !_toggle;
      _onClick.add(_toggle ? 'Click2!' : '');
    });
  }
}
