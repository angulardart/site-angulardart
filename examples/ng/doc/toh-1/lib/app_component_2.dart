import 'package:angular/angular.dart';

// #docregion import-and-class
import 'hero.dart';
// #enddocregion import-and-class

@Component(
  selector: 'my-app',
  // #docregion template
  template: '''
    <h1>{{title}}</h1>
    <h2>{{hero.name}}</h2>
    <div><label>id: </label>{{hero.id}}</div>
    <div><label>name: </label>{{hero.name}}</div>
  ''',
  // #enddocregion template
)
// #docregion class, import-and-class
class AppComponent {
  final title = 'Tour of Heroes';
  Hero hero = Hero(1, 'Windstorm');
}
