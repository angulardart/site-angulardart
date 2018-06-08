// #docregion directives
import 'package:angular/angular.dart';

@Component(
  selector: 'my-app',
  // #enddocregion directives
  // #docregion template
  template: '''
    <h1>{{title}}</h1>
    <h2>My favorite hero is: {{myHero}}</h2>
    <p>Heroes:</p>
    <ul>
    // #docregion li
      <li *ngFor="let hero of heroes">
        {{ hero }}
      </li>
    // #enddocregion li
    </ul>
  ''',
  // #enddocregion template
  // #docregion directives
  directives: [coreDirectives],
)
// #enddocregion directives
// #docregion class
class AppComponent {
  final title = 'Tour of Heroes';
  List<String> heroes = [
    'Windstorm',
    'Bombasto',
    'Magneta',
    'Tornado',
  ];
  String get myHero => heroes.first;
}
