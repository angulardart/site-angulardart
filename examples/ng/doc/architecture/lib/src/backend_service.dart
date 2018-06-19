import 'dart:async';

import 'package:angular/angular.dart';

import 'hero.dart';

@Injectable()
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
