import 'dart:async';

import 'hero.dart';
import 'mock_heroes.dart';

class HeroService {
  Future<List<Hero>> getAll() async => mockHeroes;

  // #docregion get
  Future<Hero> get(int id) async =>
      (await getAll()).firstWhere((hero) => hero.id == id);
  // #enddocregion get
}
