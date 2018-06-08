import 'dart:html';

import 'package:angular/angular.dart';

@Directive(selector: '[myHighlight]')
class HighlightDirective {
  final Element _el;

  HighlightDirective(this._el);

  // #docregion color
  @Input('myHighlight')
  String highlightColor;
  // #enddocregion color

  // #docregion mouse-enter
  @HostListener('mouseenter')
  void onMouseEnter() => _highlight(highlightColor ?? 'red');
  // #enddocregion mouse-enter

  @HostListener('mouseleave')
  void onMouseLeave() => _highlight();

  void _highlight([String color]) {
    _el.style.backgroundColor = color;
  }
}
