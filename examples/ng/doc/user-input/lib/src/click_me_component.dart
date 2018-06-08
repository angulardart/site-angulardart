import 'package:angular/angular.dart';

// #docregion component
@Component(
  selector: 'click-me',
  // #docregion template
  template: '''
    <button (click)="onClickMe()">Click me!</button>
    {{clickMessage}}
  ''',
  // #enddocregion template
)
class ClickMeComponent {
  String clickMessage = '';

  void onClickMe() => clickMessage = 'You are my hero!';
}
