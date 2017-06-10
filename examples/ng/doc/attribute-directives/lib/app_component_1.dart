// #docregion
import 'package:angular2/angular2.dart';

import 'src/highlight_directive_2.dart';

@Component(
    selector: 'my-app',
    templateUrl: 'app_component_1.html',
    directives: const [HighlightDirective])
// #docregion class
class AppComponent {
  String color = 'yellow';
}
