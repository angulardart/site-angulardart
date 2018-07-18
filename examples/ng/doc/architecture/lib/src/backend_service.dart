import 'dart:async';

import 'hero.dart';

class BackendService {
  static final _mockHeroes = [
    Hero('Windstorm', 'Weather mastery'),
    Hero('Mr. Nice', 'Killing them with kindness'),
    Hero('Magneta', 'Manipulates metalic objects')
  ];

  Future<List> getAll(type) async => type == Hero
      ? _mockHeroes
      : throw Exception('Cannot get object of this type');
}
