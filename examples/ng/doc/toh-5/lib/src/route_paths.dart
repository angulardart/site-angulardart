// #docregion v1
import 'package:angular_router/angular_router.dart';

class RoutePaths {
  // #enddocregion v1
  // #docregion dashboard
  static final dashboard = RoutePath(path: 'dashboard');
  // #enddocregion dashboard
  // #docregion v1
  static final heroes = RoutePath(path: 'heroes');
  // #enddocregion v1

  // #docregion hero
  static const idParam = 'id';
  static final hero = RoutePath(path: '${heroes.path}/:$idParam');
  // #enddocregion hero

  // #docregion getId
  static int getId(Map<String, String> parameters) {
    final id = parameters[idParam];
    return id == null ? null : int.tryParse(id);
  }
  // #enddocregion getId
  // #docregion v1
}
