// #docregion , v1
import 'package:angular_router/angular_router.dart';

import 'crisis_component.template.dart' as cct;
// #enddocregion v1
// #docregion home
import 'crisis_list_home_component.template.dart' as clhct;
// #docregion v1
import 'route_paths.dart' as paths;

class Routes {
  // #enddocregion home
  static final _crisis = new RouteDefinition(
    routePath: paths.crisis,
    component: cct.CrisisComponentNgFactory,
  );

  final crisis = _crisis;
  // #enddocregion v1

  // #docregion home
  static final _home = new RouteDefinition(
    routePath: paths.home,
    component: clhct.CrisisListHomeComponentNgFactory,
    useAsDefault: true,
  );

  final home = _home;
  // #docregion v1

  final List<RouteDefinition> all = [
    _crisis,
    // #enddocregion v1
    _home,
    // #docregion v1
  ];
}
