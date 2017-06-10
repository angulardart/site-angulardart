// #docregion
import 'package:angular2/angular2.dart';

import 'src/highlight_directive.dart';

@Component(
    selector: 'my-app',
    templateUrl: 'app_component.html',
    directives: const [HighlightDirective])
// #docregion class
class AppComponent {
  String color;
}
