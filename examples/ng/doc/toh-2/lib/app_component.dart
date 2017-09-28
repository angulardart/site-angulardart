// #docregion
import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';

class Hero {
  final int id;
  String name;

  Hero(this.id, this.name);
}

// #docregion hero-list
final mockHeroes = <Hero>[
  new Hero(11, 'Mr. Nice'),
  new Hero(12, 'Narco'),
  new Hero(13, 'Bombasto'),
  new Hero(14, 'Celeritas'),
  new Hero(15, 'Magneta'),
  new Hero(16, 'RubberMan'),
  new Hero(17, 'Dynama'),
  new Hero(18, 'Dr IQ'),
  new Hero(19, 'Magma'),
  new Hero(20, 'Tornado')
];
// #enddocregion hero-list

// #docregion directives, styleUrls
@Component(
  selector: 'my-app',
  // #enddocregion directives, styleUrls
  templateUrl: 'app_component.html',
  // #docregion styleUrls
  styleUrls: const ['app_component.css'],
  // #docregion directives
  directives: const [CORE_DIRECTIVES, formDirectives],
)
// #enddocregion directives, styleUrls
class AppComponent {
  final title = 'Tour of Heroes';
  // #docregion heroes
  final List<Hero> heroes = mockHeroes;
  // #enddocregion heroes
  // #docregion selectedHero
  Hero selectedHero;
  // #enddocregion selectedHero

  // #docregion onSelect
  void onSelect(Hero hero) {
    selectedHero = hero;
  }
  // #enddocregion onSelect
}
