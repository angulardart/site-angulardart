// #docregion
import 'package:angular/angular.dart';

import 'hero.dart';
import 'mock_heroes.dart';

@Injectable()
class HeroService {
  List<Hero> getHeroes() => HEROES;
}
