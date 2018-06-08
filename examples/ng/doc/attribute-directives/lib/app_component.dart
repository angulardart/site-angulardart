import 'package:angular/angular.dart';

import 'src/auto_id_directive.dart';
import 'src/highlight_directive.dart';

@Component(
  selector: 'my-app',
  templateUrl: 'app_component.html',
  directives: [autoIdDirective, HighlightDirective],
)
// #docregion class
class AppComponent {
  String color;
}
