// #docregion
import 'package:angular2/core.dart';

@Directive(selector: '[myHighlight]')
class HighlightDirective {
  HighlightDirective(ElementRef el) {
    el.nativeElement.style.backgroundColor = 'yellow';
  }
}
