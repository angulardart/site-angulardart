// #docregion
import 'package:angular2/angular2.dart';

@Directive(selector: '[myHighlight]')
class HighlightDirective {
  HighlightDirective(ElementRef el) {
    el.nativeElement.style.backgroundColor = 'yellow';
  }
}
