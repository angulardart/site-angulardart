// #docregion
import 'package:angular2/angular2.dart';
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
  directives: const [CORE_DIRECTIVES],
)
// #docregion class
class AppComponent {
  String title = 'Tour of Heroes';
  // #docregion heroes
  List<Hero> heroes = [
    new Hero(1, 'Windstorm'),
    new Hero(13, 'Bombasto'),
    new Hero(15, 'Magneta'),
    new Hero(20, 'Tornado')
  ];
  Hero get myHero => heroes.first;
  // #enddocregion heroes
}
