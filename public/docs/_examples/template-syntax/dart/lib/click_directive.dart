// #docplaster
import 'dart:html';

import 'package:angular2/core.dart';

@Directive(selector: '[myClick]')
class ClickDirective {
  // #docregion output-myClick
  // @Output(alias) propertyName = ...
  @Output('myClick')
  final EventEmitter clicks = new EventEmitter<String>();

  // #enddocregion output-myClick
  bool _toggle = false;

  ClickDirective(ElementRef el) {
    Element nativeEl = el.nativeElement;
    nativeEl.onClick.listen((Event e) {
      _toggle = !_toggle;
      clicks.emit(_toggle ? 'Click!' : '');
    });
  }
}

// #docregion output-myClick2
@Directive(
// #enddocregion output-myClick2
    selector: '[myClick2]',
// #docregion output-myClick2
    // ...
    outputs: const ['clicks:myClick'] // propertyName:alias
    )
// #enddocregion output-myClick2
class ClickDirective2 {
  final EventEmitter clicks = new EventEmitter<String>();
  bool _toggle = false;

  ClickDirective2(ElementRef el) {
    el.nativeElement.onClick.listen((Event e) {
      _toggle = !_toggle;
      clicks.emit(_toggle ? 'Click2!' : '');
    });
  }
}
