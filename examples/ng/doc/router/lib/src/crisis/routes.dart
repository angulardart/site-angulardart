// #docregion v1
import 'package:angular_router/angular_router.dart';

import 'crisis_component.template.dart' as crisis_template;
// #enddocregion v1
// #docregion home
import 'crisis_list_home_component.template.dart' as crisis_list_home_template;
// #docregion v1
import 'route_paths.dart';

export 'route_paths.dart';

class Routes {
  // #enddocregion home
  static final crisis = RouteDefinition(
    routePath: RoutePaths.crisis,
    component: crisis_template.CrisisComponentNgFactory,
  );
  // #enddocregion v1
  // #docregion home
  static final home = RouteDefinition(
    routePath: RoutePaths.home,
    component: crisis_list_home_template.CrisisListHomeComponentNgFactory,
    useAsDefault: true,
  );
  // #docregion v1

  static final all = <RouteDefinition>[
    // #enddocregion home
    crisis,
    // #enddocregion v1
    // #docregion home
    home,
    // #docregion v1
  ];
}
