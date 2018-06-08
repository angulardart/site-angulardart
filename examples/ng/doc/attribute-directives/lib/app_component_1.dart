import 'package:angular/angular.dart';

import 'src/highlight_directive_2.dart';

@Component(
  selector: 'my-app',
  templateUrl: 'app_component_1.html',
  directives: [HighlightDirective],
)
// #docregion class
class AppComponent {
  String color = 'yellow';
}
