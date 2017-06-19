// #docplaster
// #docregion
import 'dart:async';

import 'package:angular2/angular2.dart';

import 'hero.dart';
import 'mock_heroes.dart';

@Injectable()
class HeroService {
  // #docregion getHeroes, get-heroes
  Future<List<Hero>> getHeroes() async => mockHeroes;
  // #enddocregion getHeroes, get-heroes
  // #enddocregion
  // See the "Take it slow" appendix
  // #docregion getHeroesSlowly
  Future<List<Hero>> getHeroesSlowly() {
    return new Future.delayed(const Duration(seconds: 2), getHeroes);
  }
  // #enddocregion getHeroesSlowly
  // #docregion
}
