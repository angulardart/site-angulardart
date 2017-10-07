// #docregion
import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';

// #docregion hero-import
import 'src/hero.dart';
// #enddocregion hero-import
// #docregion heroes
import 'src/mock_heroes.dart';

// #enddocregion heroes
// #docregion directives, styleUrls
@Component(
  selector: 'my-app',
  // #enddocregion directives, styleUrls
  templateUrl: 'app_component.html',
  // #docregion styleUrls
  styleUrls: const ['app_component.css'],
  // #enddocregion styleUrls
  // #docregion directives
  directives: const [CORE_DIRECTIVES, formDirectives],
  // #docregion styleUrls
)
// #enddocregion directives, styleUrls
// #docregion heroes
class AppComponent {
  final title = 'Tour of Heroes';
  // #docregion heroes
  List<Hero> heroes = mockHeroes;
  // #enddocregion heroes
  // #docregion selectedHero
  Hero selectedHero;
  // #enddocregion selectedHero

  // #docregion onSelect
  void onSelect(Hero hero) => selectedHero = hero;
  // #enddocregion onSelect
  // #docregion heroes
}
