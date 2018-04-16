import 'package:angular_router/angular_router.dart';

final crises = new RoutePath(path: 'crises');
final heroes = new RoutePath(path: 'heroes');
final idParam = 'id';
final hero = new RoutePath(path: '${heroes.path}/:$idParam');

int getId(Map<String, String> parameters) {
  final id = parameters[idParam];
  return id == null ? null : int.tryParse(id);
}
