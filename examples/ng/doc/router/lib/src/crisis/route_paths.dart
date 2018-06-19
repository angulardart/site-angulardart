// #docregion v1
import 'package:angular_router/angular_router.dart';

import '../route_paths.dart';

export '../route_paths.dart' show idParam, getId;

final crisis = RoutePath(
  path: ':$idParam',
  parent: crises,
);
// #enddocregion v1

// #docregion home
final home = RoutePath(
  path: '',
  parent: crises,
  useAsDefault: true,
);
