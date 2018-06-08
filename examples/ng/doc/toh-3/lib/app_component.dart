import 'package:angular/angular.dart';

import 'src/hero.dart';
// #docregion hero-import
import 'src/hero_component.dart';
// #enddocregion hero-import
import 'src/mock_heroes.dart';

@Component(
  selector: 'my-app',
  templateUrl: 'app_component.html',
  styleUrls: ['app_component.css'],
  // #docregion directives
  directives: [coreDirectives, HeroComponent],
  // #enddocregion directives
)
class AppComponent {
  final title = 'Tour of Heroes';
  List<Hero> heroes = mockHeroes;
  Hero selected;

  void onSelect(Hero hero) => selected = hero;
}
