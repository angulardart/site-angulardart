import 'package:angular/angular.dart';
// #docregion directives
import 'package:angular_forms/angular_forms.dart';

import 'hero.dart';

@Component(
  selector: 'my-app',
  // #enddocregion directives
  // #docregion editing-Hero, template
  template: '''
    <h1>{{title}}</h1>
    <h2>{{hero.name}}</h2>
    <div><label>id: </label>{{hero.id}}</div>
    <div>
      <label>name: </label>
      <input [(ngModel)]="hero.name" placeholder="name">
    </div>
  ''',
  // #enddocregion editing-Hero, template
  // #docregion directives
  directives: [formDirectives],
)
// #docregion class
class AppComponent {
  // #enddocregion directives
  final title = 'Tour of Heroes';
  // #docregion hero
  Hero hero = Hero(1, 'Windstorm');
  // #enddocregion hero
  // #docregion directives
}
