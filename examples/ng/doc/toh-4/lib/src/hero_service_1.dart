// #docregion empty-class,
import 'package:angular/angular.dart';

// #enddocregion empty-class
import 'hero.dart';
import 'mock_heroes.dart';

// #docregion empty-class
@Injectable()
class HeroService {
  // #enddocregion empty-class
  // #docregion getAll
  List<Hero> getAll() => mockHeroes;
  // #enddocregion getAll
  // #docregion empty-class
}
