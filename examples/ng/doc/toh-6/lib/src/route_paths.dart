import 'package:angular_router/angular_router.dart';

class RoutePaths {
  static final dashboard = RoutePath(path: 'dashboard');
  static final heroes = RoutePath(path: 'heroes');

  static const idParam = 'id';
  static final hero = RoutePath(path: '${heroes.path}/:$idParam');

  static int getId(Map<String, String> parameters) {
    final id = parameters[idParam];
    return id == null ? null : int.tryParse(id);
  }
}
