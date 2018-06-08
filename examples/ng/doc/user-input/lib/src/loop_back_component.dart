import 'package:angular/angular.dart';

// #docregion component
@Component(
  selector: 'loop-back',
  template: '''
    <input #box (keyup)="0">
    <p>{{box.value}}</p>
  ''',
)
class LoopBackComponent {}
