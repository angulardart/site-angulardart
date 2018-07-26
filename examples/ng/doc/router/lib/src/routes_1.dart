import 'package:angular_router/angular_router.dart';

import 'route_paths_1.dart' as paths;
import 'crisis_list_component_1.template.dart' as crisis_list_template;
import 'hero_list_component_1.template.dart' as hero_list_template;

class Routes {
  RoutePath get crises => paths.crises;
  RoutePath get heroes => paths.heroes;

  final List<RouteDefinition> all = [
    RouteDefinition(
      path: paths.crises.path,
      component: crisis_list_template.CrisisListComponentNgFactory,
    ),
    RouteDefinition(
      path: paths.heroes.path,
      component: hero_list_template.HeroListComponentNgFactory,
    ),
  ];
}
