import 'package:angular/angular.dart';

@Component(
  selector: 'my-app',
  // #docregion template
  template: '''
    <h1>{{title}}</h1>
    <h2>{{hero}}</h2>
  ''',
  // #enddocregion template
)
// #docregion class
class AppComponent {
  final title = 'Tour of Heroes';
  var hero = 'Windstorm';
}
