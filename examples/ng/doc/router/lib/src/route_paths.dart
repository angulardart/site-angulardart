import 'package:angular_router/angular_router.dart';

// #docregion hero
const idParam = 'id';

class RoutePaths {
  // #enddocregion hero
  static final crises = RoutePath(path: 'crises');
  static final heroes = RoutePath(path: 'heroes');
  // #docregion hero
  static final hero = RoutePath(path: '${heroes.path}/:$idParam');
}

int getId(Map<String, String> parameters) {
  final id = parameters[idParam];
  return id == null ? null : int.tryParse(id);
}
