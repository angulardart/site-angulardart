// #docregion
import 'dart:async';

import 'package:angular/angular.dart';

import 'hero.dart';
import 'mock_heroes.dart';

@Injectable()
class HeroService {
  Future<List<Hero>> getAll() async => mockHeroes;

  // #docregion get
  Future<Hero> get(int id) async =>
      (await getAll()).firstWhere((hero) => hero.id == id);
  // #enddocregion get
}
