// #docregion
import 'package:angular2/core.dart';

import 'highlight_directive.dart';

@Component(
    selector: 'my-app',
    templateUrl: 'app_component_1.html',
    directives: const [HighlightDirective])
// #docregion class
class AppComponent {
  String color = 'yellow';
}
