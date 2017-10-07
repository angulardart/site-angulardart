// #docregion
import 'dart:async';

import 'package:angular/angular.dart';

import 'hero.dart';
import 'mock_heroes.dart';

@Injectable()
class HeroService {
  Future<List<Hero>> getHeroes() async => mockHeroes;

  // #docregion getHero
  Future<Hero> getHero(int id) async =>
      (await getHeroes()).firstWhere((hero) => hero.id == id);
  // #enddocregion getHero
}
