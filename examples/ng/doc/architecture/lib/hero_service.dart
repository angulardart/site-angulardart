import 'package:angular2/angular2.dart';

import 'backend_service.dart';
import 'hero.dart';
import 'logger_service.dart';

@Injectable()
// #docregion class
class HeroService {
  final BackendService _backendService;
  final Logger _logger;
  final heroes = <Hero>[];

  HeroService(this._logger, this._backendService);

  List<Hero> getHeroes() {
    _backendService.getAll(Hero).then((heroes) {
      _logger.log('Fetched ${heroes.length} heroes.');
      this.heroes.addAll(heroes as List<Hero>); // fill cache
    });
    return heroes;
  }
}
