import 'package:angular_router/angular_router.dart';

final crises = RoutePath(path: 'crises');
final heroes = RoutePath(path: 'heroes');
// #docregion hero
final idParam = 'id';
final hero = RoutePath(path: '${heroes.path}/:$idParam');

int getId(Map<String, String> parameters) {
  final id = parameters[idParam];
  return id == null ? null : int.tryParse(id);
}
