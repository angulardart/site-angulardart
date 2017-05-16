// #docregion
import 'dart:async';

import 'package:angular2/angular2.dart';
import 'package:angular2/router.dart';

import 'hero.dart';
import 'hero_service.dart';

@Component(
  selector: 'my-heroes',
  templateUrl: 'heroes_component_0.html',
  styleUrls: const ['heroes_component.css'],
  directives: const [CORE_DIRECTIVES],
  pipes: const [COMMON_PIPES],
)
class HeroesComponent implements OnInit {
  final Router _router;
  final HeroService _heroService;
  List<Hero> heroes;
  Hero selectedHero;

  HeroesComponent(this._heroService, this._router);

  Future<Null> getHeroes() async {
    heroes = await _heroService.getHeroes();
  }

  // #docregion ngOnInit
  void ngOnInit() {
    getHeroes();
  }
  // #enddocregion ngOnInit

  // #docregion onSelect
  void onSelect(Hero hero) {
    selectedHero = hero;
  }
  // #enddocregion onSelect

  Future gotoDetail() => _router.navigate([
        'HeroDetail',
        {'id': selectedHero.id.toString()}
      ]);
}
