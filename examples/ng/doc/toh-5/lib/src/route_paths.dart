// #docregion v1
import 'package:angular_router/angular_router.dart';
// #enddocregion v1

// #docregion dashboard
final dashboard = RoutePath(path: 'dashboard');
// #enddocregion dashboard
// #docregion v1
final heroes = RoutePath(path: 'heroes');
// #docregion hero
// #enddocregion v1
const idParam = 'id';
final hero = RoutePath(path: '${heroes.path}/:$idParam');
// #enddocregion hero

// #docregion getId
int getId(Map<String, String> parameters) {
  final id = parameters[idParam];
  return id == null ? null : int.tryParse(id);
}
