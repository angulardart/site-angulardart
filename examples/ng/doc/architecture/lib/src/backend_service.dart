import 'dart:async';

import 'package:angular/angular.dart';

import 'hero.dart';

@Injectable()
class BackendService {
  static final _mockHeroes = [
    new Hero('Windstorm', 'Weather mastery'),
    new Hero('Mr. Nice', 'Killing them with kindness'),
    new Hero('Magneta', 'Manipulates metalic objects')
  ];

  Future<List> getAll(type) async => type == Hero
      ? _mockHeroes
      : throw new Exception('Cannot get object of this type');
}
