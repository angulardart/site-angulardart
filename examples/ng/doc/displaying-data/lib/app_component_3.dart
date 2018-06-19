import 'package:angular/angular.dart';
// #docregion import
import 'src/hero.dart';
// #enddocregion import

@Component(
  selector: 'my-app',
  // #docregion template
  template: '''
    <h1>{{title}}</h1>
    <h2>My favorite hero is: {{myHero.name}}</h2>
    <p>Heroes:</p>
    <ul>
      <li *ngFor="let hero of heroes">
        {{ hero.name }}
      </li>
    </ul>
  ''',
  // #enddocregion template
  directives: [coreDirectives],
)
// #docregion class
class AppComponent {
  final title = 'Tour of Heroes';
  // #docregion heroes
  List<Hero> heroes = [
    Hero(1, 'Windstorm'),
    Hero(13, 'Bombasto'),
    Hero(15, 'Magneta'),
    Hero(20, 'Tornado')
  ];
  Hero get myHero => heroes.first;
  // #enddocregion heroes
}
