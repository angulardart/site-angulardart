// #docregion
import 'package:angular/angular.dart';
// #docregion directives
import 'package:angular_forms/angular_forms.dart';

@Component(
  selector: 'my-app',
  // #enddocregion directives
  // #docregion editing-Hero, template
  template: '''
    <h1>{{title}}</h1>
    <h2>{{hero.name}} details!</h2>
    <div><label>id: </label>{{hero.id}}</div>
    <div>
      <label>name: </label>
      <input [(ngModel)]="hero.name" placeholder="name">
    </div>''',
  // #enddocregion editing-Hero, template
  // #docregion directives
  directives: const [formDirectives],
)
// #enddocregion directives
class AppComponent {
  final title = 'Tour of Heroes';
  // #docregion hero-property-1
  Hero hero = new Hero(1, 'Windstorm');
  // #enddocregion hero-property-1
}

// #docregion hero-class-1
class Hero {
  final int id;
  String name;

  Hero(this.id, this.name);
}
