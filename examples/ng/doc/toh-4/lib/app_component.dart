// #docplaster
// #docregion
import 'dart:async';

import 'package:angular/angular.dart';

import 'src/hero.dart';
import 'src/hero_detail_component.dart';
// #docregion hero-service-import
import 'src/hero_service.dart';
// #enddocregion hero-service-import

@Component(
  selector: 'my-app',
  // #docregion template
  templateUrl: 'app_component.html',
  // #enddocregion template
  styleUrls: const ['app_component.css'],
  directives: const [CORE_DIRECTIVES, HeroDetailComponent],
  providers: const [HeroService],
)
class AppComponent implements OnInit {
  final title = 'Tour of Heroes';
  List<Hero> heroes;
  Hero selectedHero;

  final HeroService _heroService;

  AppComponent(this._heroService);

  // #docregion getHeroes
  Future<Null> getHeroes() async {
    heroes = await _heroService.getHeroes();
  }
  // #enddocregion getHeroes

  void ngOnInit() {
    getHeroes();
  }

  void onSelect(Hero hero) {
    selectedHero = hero;
  }
}
