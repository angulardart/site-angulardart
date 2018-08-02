import 'package:angular_router/angular_router.dart';

import 'crisis_list_component_1.template.dart' as crisis_list_template;
import 'hero_list_component_1.template.dart' as hero_list_template;
import 'route_paths_1.dart';

export 'route_paths_1.dart';

class Routes {
  static final crises = RouteDefinition(
    routePath: RoutePaths.crises,
    component: crisis_list_template.CrisisListComponentNgFactory,
  );

  static final heroes = RouteDefinition(
    routePath: RoutePaths.heroes,
    component: hero_list_template.HeroListComponentNgFactory,
  );

  static final all = <RouteDefinition>[
    crises,
    heroes,
  ];
}
