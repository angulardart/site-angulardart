// #docplaster
// #docregion
import 'dart:async';

import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';

import 'hero.dart';
import 'hero_service.dart';

// #docregion metadata, pipes, renaming
@Component(
  selector: 'my-heroes',
  // #enddocregion pipes
  templateUrl: 'heroes_component.html',
  styleUrls: const ['heroes_component.css'],
  // #enddocregion renaming
  directives: const [CORE_DIRECTIVES],
  // #docregion pipes
  pipes: const [COMMON_PIPES],
  // #docregion renaming
)
// #enddocregion metadata, pipes
// #docregion class
class HeroesComponent implements OnInit {
  // #enddocregion renaming
  final HeroService _heroService;
  final Router _router;
  List<Hero> heroes;
  Hero selectedHero;

  // #docregion renaming
  HeroesComponent(
      this._heroService,
      // #enddocregion renaming
      this._router
      // #docregion renaming
      );
  // #enddocregion renaming

  Future<Null> getHeroes() async {
    heroes = await _heroService.getHeroes();
  }

  void ngOnInit() => getHeroes();

  void onSelect(Hero hero) => selectedHero = hero;

  // #docregion gotoDetail, gotoDetail-stub
  Future<Null> gotoDetail() => _router.navigate([
    // #enddocregion gotoDetail-stub
        'HeroDetail',
        {'id': selectedHero.id.toString()}
      ]);
  // #enddocregion gotoDetail
  // #docregion renaming
}
