// #docregion
import 'package:angular/angular.dart';

// #docregion loop-back-component
@Component(
  selector: 'loop-back',
  template: '''
    <input #box (keyup)="0">
    <p>{{box.value}}</p>
  ''',
)
class LoopBackComponent {}
