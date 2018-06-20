// #docregion
import 'dart:async';

import 'package:angular/angular.dart';

import 'hero.dart';
import 'mock_heroes.dart';

@Injectable()
class HeroService {
  // #docregion getAll
  Future<List<Hero>> getAll() async => mockHeroes;
  // #enddocregion '', getAll
  // See the "Take it slow" appendix
  // #docregion getAllSlowly
  Future<List<Hero>> getAllSlowly() {
    return Future.delayed(Duration(seconds: 2), getAll);
  }
  // #enddocregion getAllSlowly
  // #docregion
}
