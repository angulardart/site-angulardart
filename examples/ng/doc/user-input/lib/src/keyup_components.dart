import 'dart:html';

import 'package:angular/angular.dart';

@Component(
  selector: 'key-up1-untyped',
  template: '''
    <input (keyup)="onKey(\$event)">
    <p>{{values}}</p>
  ''',
)
// #docregion v1-class-untyped
class KeyUp1Component_untyped {
  String values = '';

  void onKey(dynamic event) {
    values += event.target.value + ' | ';
  }
}
// #enddocregion v1-class-untyped

@Component(
  selector: 'key-up1',
  // #docregion v1-template
  template: '''
    <input (keyup)="onKey(\$event)">
    <p>{{values}}</p>
  ''',
  // #enddocregion v1-template
)
// #docregion v1-class
class KeyUp1Component {
  String values = '';

  void onKey(KeyboardEvent event) {
    InputElement el = event.target;
    values += '${el.value}  | ';
  }
}
// #enddocregion v1-class

// #docregion v2
@Component(
  selector: 'key-up2',
  template: '''
    <input #box (keyup)="onKey(box.value)">
    <p>{{values}}</p>
  ''',
)
class KeyUp2Component {
  String values = '';
  void onKey(value) => values += '$value | ';
}
// #enddocregion v2

// #docregion v3
@Component(
  selector: 'key-up3',
  template: '''
    <input #box (keyup.enter)="values=box.value">
    <p>{{values}}</p>
  ''',
)
class KeyUp3Component {
  String values = '';
}
// #enddocregion v3

// #docregion v4
@Component(
  selector: 'key-up4',
  template: '''
    <input #box
      (keyup.enter)="values=box.value"
      (blur)="values=box.value">
    <p>{{values}}</p>
  ''',
)
class KeyUp4Component {
  String values = '';
}
