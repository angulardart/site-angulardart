// #docregion
import 'package:angular2/angular2.dart';

@Directive(selector: '[myHighlight]')
class HighlightDirective {
  final ElementRef _el;

  HighlightDirective(this._el);

  // #docregion defaultColor
  @Input()
  String defaultColor;
  // #enddocregion defaultColor

  // #docregion color
  @Input('myHighlight')
  String highlightColor;
  // #enddocregion color

  // #docregion mouse-enter
  @HostListener('mouseenter')
  void onMouseEnter() => _highlight(highlightColor ?? defaultColor ?? 'red');
  // #enddocregion mouse-enter

  @HostListener('mouseleave')
  void onMouseLeave() => _highlight();

  void _highlight([String color]) {
    _el.nativeElement.style.backgroundColor = color;
  }
}
