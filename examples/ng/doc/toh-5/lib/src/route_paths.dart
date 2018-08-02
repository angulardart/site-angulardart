// #docregion v1
import 'package:angular_router/angular_router.dart';

// #enddocregion v1
// #docregion hero
const idParam = 'id';

// #docregion v1
class RoutePaths {
  // #enddocregion hero, v1
  // #docregion dashboard
  static final dashboard = RoutePath(path: 'dashboard');
  // #enddocregion dashboard
  // #docregion v1
  static final heroes = RoutePath(path: 'heroes');
  // #enddocregion v1
  // #docregion hero
  static final hero = RoutePath(path: '${heroes.path}/:$idParam');
  // #docregion v1
}
// #enddocregion hero, v1

// #docregion getId
int getId(Map<String, String> parameters) {
  final id = parameters[idParam];
  return id == null ? null : int.tryParse(id);
}
// #enddocregion getId
