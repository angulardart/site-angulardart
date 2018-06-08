// #docregion
import 'dart:html';

import 'package:angular/angular.dart';

@Directive(selector: '[myHighlight]')
class HighlightDirective {
  // #docregion ctor
  final Element _el;

  HighlightDirective(this._el);
  // #enddocregion ctor

  // #docregion mouse-methods, host
  @HostListener('mouseenter')
  void onMouseEnter() {
    // #enddocregion host
    _highlight('yellow');
    // #docregion host
  }

  @HostListener('mouseleave')
  void onMouseLeave() {
    // #enddocregion host
    _highlight();
    // #docregion host
  }
  // #enddocregion host

  void _highlight([String color]) {
    _el.style.backgroundColor = color;
  }
  // #enddocregion '', mouse-methods

  // #docregion color
  @Input()
  String highlightColor;
  // #enddocregion color

  // #docregion color-2
  @Input()
  String myHighlight;
  // #enddocregion color-2
  // #docregion
}
