// #docregion
import 'dart:async';

import 'package:angular2/angular2.dart';

import 'hero.dart';
import 'hero_service.dart';

@Component(
  selector: 'hero-list',
  templateUrl: 'hero_list_component.html',
  providers: const [HeroService],
  styles: const ['.error {color:red;}'],
  directives: const [CORE_DIRECTIVES],
)
// #docregion component
class HeroListComponent implements OnInit {
  final HeroService _heroService;
  String errorMessage;
  List<Hero> heroes = [];

  HeroListComponent(this._heroService);

  Future<Null> ngOnInit() => getHeroes();

  // #docregion methods, getHeroes
  Future<Null> getHeroes() async {
    try {
      heroes = await _heroService.getHeroes();
    } catch (e) {
      errorMessage = e.toString();
    }
  }
  // #enddocregion getHeroes

  // #docregion addHero
  Future<Null> addHero(String name) async {
    name = name.trim();
    if (name.isEmpty) return;
    try {
      heroes.add(await _heroService.create(name));
    } catch (e) {
      errorMessage = e.toString();
    }
  }
  // #enddocregion addHero, methods
}
