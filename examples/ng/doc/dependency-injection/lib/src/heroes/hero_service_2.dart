import '../logger_service.dart';
import 'hero.dart';
import 'mock_heroes.dart';

class HeroService {
  final Logger _logger;

  //#docregion ctor
  HeroService(this._logger);
  //#enddocregion ctor

  List<Hero> getAll() {
    _logger.fine('Getting heroes ...');
    return mockHeroes;
  }
}
