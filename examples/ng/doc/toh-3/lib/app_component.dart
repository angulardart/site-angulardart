// #docregion
import 'package:angular/angular.dart';

import 'src/hero.dart';
// #docregion hero-detail-import
import 'src/hero_detail_component.dart';
// #enddocregion hero-detail-import
import 'src/mock_heroes.dart';

@Component(
  selector: 'my-app',
  templateUrl: 'app_component.html',
  styleUrls: const ['app_component.css'],
  // #docregion directives
  directives: const [CORE_DIRECTIVES, HeroDetailComponent],
  // #enddocregion directives
)
class AppComponent {
  final title = 'Tour of Heroes';
  List<Hero> heroes = mockHeroes;
  Hero selectedHero;

  void onSelect(Hero hero) => selectedHero = hero;
}
