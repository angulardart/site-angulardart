// #docregion
import 'package:angular2/angular2.dart';

import 'hero.dart';
import 'mock_heroes.dart';

@Injectable()
class HeroService {
  List<Hero> getHeroes() => HEROES;
}
