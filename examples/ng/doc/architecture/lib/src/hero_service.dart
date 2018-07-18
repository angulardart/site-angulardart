import 'dart:async';

import 'backend_service.dart';
import 'hero.dart';
import 'logger_service.dart';

// #docregion class
class HeroService {
  final BackendService _backendService;
  final Logger _logger;
  List<Hero> heroes;

  HeroService(this._logger, this._backendService);

  Future<List<Hero>> getAll() async {
    heroes = await _backendService.getAll(Hero);
    _logger.log('Fetched ${heroes.length} heroes.');
    return heroes;
  }
}
