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
  RoutePath get crisis => paths.crisis;
  // #enddocregion v1
  // #docregion home
  RoutePath get home => paths.home;
  // #docregion v1

  final List<RouteDefinition> all = [
    // #enddocregion home
    new RouteDefinition(
      routePath: paths.crisis,
      component: cct.CrisisComponentNgFactory,
    ),
    // #enddocregion v1
    // #docregion home
    new RouteDefinition(
      routePath: paths.home,
      component: clhct.CrisisListHomeComponentNgFactory,
      useAsDefault: true,
    ),
    // #docregion v1
  ];
}
