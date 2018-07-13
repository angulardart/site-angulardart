import 'hero.dart';
import 'mock_heroes.dart';

// #docregion empty-class
class HeroService {
  // #enddocregion empty-class
  // #docregion getAll
  List<Hero> getAll() => mockHeroes;
  // #enddocregion getAll
  // #docregion empty-class
}
