// #docregion v1
import 'package:angular_router/angular_router.dart';

import '../route_paths.dart' as _parent;

export '../route_paths.dart' show idParam, getId;

class RoutePaths {
  static final crisis = RoutePath(
    path: ':${_parent.idParam}',
    parent: _parent.RoutePaths.crises,
  );
  // #enddocregion v1

  // #docregion home
  static final home = RoutePath(
    path: '',
    parent: _parent.RoutePaths.crises,
    useAsDefault: true,
  );
  // #enddocregion home
  // #docregion v1
}
