// #docregion v1
import 'package:angular_router/angular_router.dart';

import 'crisis_component.template.dart' as crisis_template;
// #enddocregion v1
// #docregion home
import 'crisis_list_home_component.template.dart' as crisis_list_home_template;
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
    RouteDefinition(
      routePath: paths.crisis,
      component: crisis_template.CrisisComponentNgFactory,
    ),
    // #enddocregion v1
    // #docregion home
    RouteDefinition(
      routePath: paths.home,
      component: crisis_list_home_template.CrisisListHomeComponentNgFactory,
      useAsDefault: true,
    ),
    // #docregion v1
  ];
}
