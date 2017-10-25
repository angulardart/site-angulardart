import 'dart:async';

import 'package:angular/angular.dart';

import 'hero.dart';
import 'mock_heroes.dart';

@Injectable()
class HeroService {
  Future<List<Hero>> getHeroes() async => mockHeroes;

  Future<List<Hero>> getHeroesSlowly() {
    return new Future<List<Hero>>.delayed(
        const Duration(seconds: 2), getHeroes);
  }

  Future<Hero> getHero(int id) async =>
      (await getHeroes()).firstWhere((hero) => hero.id == id);
}
